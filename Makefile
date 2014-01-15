#!/usr/bin/make -f

stamp := $(shell date +%s)

all: precise quantal raring saucy trusty
	@true

%: %-desktop-i386.box
	@true

%-server-cloudimg-i386-vagrant-disk1.box:
	wget -c http://cloud-images.ubuntu.com/vagrant/$*/current/$*-server-cloudimg-i386-vagrant-disk1.box

%-desktop-i386.box: %-server-cloudimg-i386-vagrant-disk1.box
	-vagrant up $*
	vagrant package $* --output $@
	vagrant destroy $* -f
	#vagrant box add -f $@ ./$@

clean:
	vagrant destroy -f

launch-%:
	mkdir -p $*-$(stamp)
	sed s/@RELEASE@/$*/ <Vagrantfile.in >$*-$(stamp)/Vagrantfile
	cp -r manifests $*-$(stamp)
	cd $*-$(stamp) && vagrant up

.SECONDARY:
