From: akpm@linux-foundation.org
Subject: + revert-driver-core-remove-config_sysfs_deprecated.patch added to -mm tree
Date: Wed, 14 Jul 2010 16:58:53 -0700
Message-ID: <201007150028.o6F0SCXv031566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757737Ab0GOA2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jul 2010 20:28:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com


The patch titled
     revert "driver core: remove CONFIG_SYSFS_DEPRECATED"
has been added to the -mm tree.  Its filename is
     revert-driver-core-remove-config_sysfs_deprecated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "driver core: remove CONFIG_SYSFS_DEPRECATED"
From: Andrew Morton <akpm@linux-foundation.org>

make Linux work again

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c            |    5 -
 drivers/base/bus.c       |   22 ++++
 drivers/base/class.c     |   25 +++++
 drivers/base/core.c      |  164 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/hosts.c     |    2 
 drivers/scsi/scsi_scan.c |    2 
 fs/partitions/check.c    |    6 -
 include/sound/core.h     |    6 +
 init/Kconfig             |   36 ++++++++
 sound/core/init.c        |   11 +-
 10 files changed, 272 insertions(+), 7 deletions(-)

diff -puN block/genhd.c~revert-driver-core-remove-config_sysfs_deprecated block/genhd.c
--- a/block/genhd.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/block/genhd.c
@@ -22,7 +22,9 @@
 #include "blk.h"
 
 static DEFINE_MUTEX(block_class_lock);
+#ifndef CONFIG_SYSFS_DEPRECATED
 struct kobject *block_depr;
+#endif
 
 /* for extended dynamic devt allocation, currently only one major is used */
 #define MAX_EXT_DEVT		(1 << MINORBITS)
@@ -801,9 +803,10 @@ static int __init genhd_device_init(void
 
 	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
 
+#ifndef CONFIG_SYSFS_DEPRECATED
 	/* create top-level block dir */
 	block_depr = kobject_create_and_add("block", NULL);
-
+#endif
 	return 0;
 }
 
diff -puN drivers/base/bus.c~revert-driver-core-remove-config_sysfs_deprecated drivers/base/bus.c
--- a/drivers/base/bus.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/drivers/base/bus.c
@@ -440,6 +440,22 @@ static void device_remove_attrs(struct b
 	}
 }
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+static int make_deprecated_bus_links(struct device *dev)
+{
+	return sysfs_create_link(&dev->kobj,
+				 &dev->bus->p->subsys.kobj, "bus");
+}
+
+static void remove_deprecated_bus_links(struct device *dev)
+{
+	sysfs_remove_link(&dev->kobj, "bus");
+}
+#else
+static inline int make_deprecated_bus_links(struct device *dev) { return 0; }
+static inline void remove_deprecated_bus_links(struct device *dev) { }
+#endif
+
 /**
  * bus_add_device - add device to bus
  * @dev: device being added
@@ -466,10 +482,15 @@ int bus_add_device(struct device *dev)
 				&dev->bus->p->subsys.kobj, "subsystem");
 		if (error)
 			goto out_subsys;
+		error = make_deprecated_bus_links(dev);
+		if (error)
+			goto out_deprecated;
 		klist_add_tail(&dev->p->knode_bus, &bus->p->klist_devices);
 	}
 	return 0;
 
+out_deprecated:
+	sysfs_remove_link(&dev->kobj, "subsystem");
 out_subsys:
 	sysfs_remove_link(&bus->p->devices_kset->kobj, dev_name(dev));
 out_id:
@@ -509,6 +530,7 @@ void bus_remove_device(struct device *de
 {
 	if (dev->bus) {
 		sysfs_remove_link(&dev->kobj, "subsystem");
+		remove_deprecated_bus_links(dev);
 		sysfs_remove_link(&dev->bus->p->devices_kset->kobj,
 				  dev_name(dev));
 		device_remove_attrs(dev->bus, dev);
diff -puN drivers/base/class.c~revert-driver-core-remove-config_sysfs_deprecated drivers/base/class.c
--- a/drivers/base/class.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/drivers/base/class.c
@@ -184,7 +184,13 @@ int __class_register(struct class *cls, 
 	if (!cls->dev_kobj)
 		cls->dev_kobj = sysfs_dev_char_kobj;
 
+#if defined(CONFIG_SYSFS_DEPRECATED) && defined(CONFIG_BLOCK)
+	/* let the block class directory show up in the root of sysfs */
+	if (cls != &block_class)
+		cp->class_subsys.kobj.kset = class_kset;
+#else
 	cp->class_subsys.kobj.kset = class_kset;
+#endif
 	cp->class_subsys.kobj.ktype = &class_ktype;
 	cp->class = cls;
 	cls->p = cp;
@@ -270,6 +276,25 @@ void class_destroy(struct class *cls)
 	class_unregister(cls);
 }
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+char *make_class_name(const char *name, struct kobject *kobj)
+{
+	char *class_name;
+	int size;
+
+	size = strlen(name) + strlen(kobject_name(kobj)) + 2;
+
+	class_name = kmalloc(size, GFP_KERNEL);
+	if (!class_name)
+		return NULL;
+
+	strcpy(class_name, name);
+	strcat(class_name, ":");
+	strcat(class_name, kobject_name(kobj));
+	return class_name;
+}
+#endif
+
 /**
  * class_dev_iter_init - initialize class device iterator
  * @iter: class iterator to initialize
diff -puN drivers/base/core.c~revert-driver-core-remove-config_sysfs_deprecated drivers/base/core.c
--- a/drivers/base/core.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/drivers/base/core.c
@@ -203,6 +203,37 @@ static int dev_uevent(struct kset *kset,
 	if (dev->driver)
 		add_uevent_var(env, "DRIVER=%s", dev->driver->name);
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+	if (dev->class) {
+		struct device *parent = dev->parent;
+
+		/* find first bus device in parent chain */
+		while (parent && !parent->bus)
+			parent = parent->parent;
+		if (parent && parent->bus) {
+			const char *path;
+
+			path = kobject_get_path(&parent->kobj, GFP_KERNEL);
+			if (path) {
+				add_uevent_var(env, "PHYSDEVPATH=%s", path);
+				kfree(path);
+			}
+
+			add_uevent_var(env, "PHYSDEVBUS=%s", parent->bus->name);
+
+			if (parent->driver)
+				add_uevent_var(env, "PHYSDEVDRIVER=%s",
+					       parent->driver->name);
+		}
+	} else if (dev->bus) {
+		add_uevent_var(env, "PHYSDEVBUS=%s", dev->bus->name);
+
+		if (dev->driver)
+			add_uevent_var(env, "PHYSDEVDRIVER=%s",
+				       dev->driver->name);
+	}
+#endif
+
 	/* have the bus specific function add its stuff */
 	if (dev->bus && dev->bus->uevent) {
 		retval = dev->bus->uevent(dev, env);
@@ -547,6 +578,24 @@ void device_initialize(struct device *de
 	set_dev_node(dev, -1);
 }
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+static struct kobject *get_device_parent(struct device *dev,
+					 struct device *parent)
+{
+	/* class devices without a parent live in /sys/class/<classname>/ */
+	if (dev->class && (!parent || parent->class != dev->class))
+		return &dev->class->p->class_subsys.kobj;
+	/* all other devices keep their parent */
+	else if (parent)
+		return &parent->kobj;
+
+	return NULL;
+}
+
+static inline void cleanup_device_parent(struct device *dev) {}
+static inline void cleanup_glue_dir(struct device *dev,
+				    struct kobject *glue_dir) {}
+#else
 static struct kobject *virtual_device_parent(struct device *dev)
 {
 	static struct kobject *virtual_dir = NULL;
@@ -670,6 +719,7 @@ static void cleanup_device_parent(struct
 {
 	cleanup_glue_dir(dev, dev->kobj.parent);
 }
+#endif
 
 static void setup_parent(struct device *dev, struct device *parent)
 {
@@ -692,6 +742,53 @@ static int device_add_class_symlinks(str
 	if (error)
 		goto out;
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+	/* stacked class devices need a symlink in the class directory */
+	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
+	    device_is_not_partition(dev)) {
+		error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
+					  &dev->kobj, dev_name(dev));
+		if (error)
+			goto out_subsys;
+	}
+
+	if (dev->parent && device_is_not_partition(dev)) {
+		struct device *parent = dev->parent;
+		char *class_name;
+
+		/*
+		 * stacked class devices have the 'device' link
+		 * pointing to the bus device instead of the parent
+		 */
+		while (parent->class && !parent->bus && parent->parent)
+			parent = parent->parent;
+
+		error = sysfs_create_link(&dev->kobj,
+					  &parent->kobj,
+					  "device");
+		if (error)
+			goto out_busid;
+
+		class_name = make_class_name(dev->class->name,
+						&dev->kobj);
+		if (class_name)
+			error = sysfs_create_link(&dev->parent->kobj,
+						&dev->kobj, class_name);
+		kfree(class_name);
+		if (error)
+			goto out_device;
+	}
+	return 0;
+
+out_device:
+	if (dev->parent && device_is_not_partition(dev))
+		sysfs_remove_link(&dev->kobj, "device");
+out_busid:
+	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
+	    device_is_not_partition(dev))
+		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
+				  dev_name(dev));
+#else
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->class_subsys.kobj,
 				  &dev->kobj, dev_name(dev));
@@ -708,6 +805,7 @@ static int device_add_class_symlinks(str
 
 out_busid:
 	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
+#endif
 
 out_subsys:
 	sysfs_remove_link(&dev->kobj, "subsystem");
@@ -720,10 +818,29 @@ static void device_remove_class_symlinks
 	if (!dev->class)
 		return;
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+	if (dev->parent && device_is_not_partition(dev)) {
+		char *class_name;
+
+		class_name = make_class_name(dev->class->name, &dev->kobj);
+		if (class_name) {
+			sysfs_remove_link(&dev->parent->kobj, class_name);
+			kfree(class_name);
+		}
+		sysfs_remove_link(&dev->kobj, "device");
+	}
+
+	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
+	    device_is_not_partition(dev))
+		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
+				  dev_name(dev));
+#else
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 
 	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
+#endif
+
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }
 
@@ -1496,23 +1613,41 @@ int device_rename(struct device *dev, ch
 	pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
 		 __func__, new_name);
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+	if ((dev->class) && (dev->parent))
+		old_class_name = make_class_name(dev->class->name, &dev->kobj);
+#endif
+
 	old_device_name = kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!old_device_name) {
 		error = -ENOMEM;
 		goto out;
 	}
 
+#ifndef CONFIG_SYSFS_DEPRECATED
 	if (dev->class) {
 		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
 			&dev->kobj, old_device_name, new_name);
 		if (error)
 			goto out;
 	}
-
+#endif
 	error = kobject_rename(&dev->kobj, new_name);
 	if (error)
 		goto out;
 
+#ifdef CONFIG_SYSFS_DEPRECATED
+	if (old_class_name) {
+		new_class_name = make_class_name(dev->class->name, &dev->kobj);
+		if (new_class_name) {
+			error = sysfs_rename_link(&dev->parent->kobj,
+						  &dev->kobj,
+						  old_class_name,
+						  new_class_name);
+		}
+	}
+#endif
+
 out:
 	put_device(dev);
 
@@ -1529,13 +1664,40 @@ static int device_move_class_links(struc
 				   struct device *new_parent)
 {
 	int error = 0;
+#ifdef CONFIG_SYSFS_DEPRECATED
+	char *class_name;
 
+	class_name = make_class_name(dev->class->name, &dev->kobj);
+	if (!class_name) {
+		error = -ENOMEM;
+		goto out;
+	}
+	if (old_parent) {
+		sysfs_remove_link(&dev->kobj, "device");
+		sysfs_remove_link(&old_parent->kobj, class_name);
+	}
+	if (new_parent) {
+		error = sysfs_create_link(&dev->kobj, &new_parent->kobj,
+					  "device");
+		if (error)
+			goto out;
+		error = sysfs_create_link(&new_parent->kobj, &dev->kobj,
+					  class_name);
+		if (error)
+			sysfs_remove_link(&dev->kobj, "device");
+	} else
+		error = 0;
+out:
+	kfree(class_name);
+	return error;
+#else
 	if (old_parent)
 		sysfs_remove_link(&dev->kobj, "device");
 	if (new_parent)
 		error = sysfs_create_link(&dev->kobj, &new_parent->kobj,
 					  "device");
 	return error;
+#endif
 }
 
 /**
diff -puN drivers/scsi/hosts.c~revert-driver-core-remove-config_sysfs_deprecated drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/drivers/scsi/hosts.c
@@ -406,7 +406,9 @@ struct Scsi_Host *scsi_host_alloc(struct
 
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
+#ifndef CONFIG_SYSFS_DEPRECATED
 	shost->shost_gendev.bus = &scsi_bus_type;
+#endif
 	shost->shost_gendev.type = &scsi_host_type;
 
 	device_initialize(&shost->shost_dev);
diff -puN drivers/scsi/scsi_scan.c~revert-driver-core-remove-config_sysfs_deprecated drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/drivers/scsi/scsi_scan.c
@@ -417,7 +417,9 @@ static struct scsi_target *scsi_alloc_ta
 	starget->reap_ref = 1;
 	dev->parent = get_device(parent);
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
+#ifndef CONFIG_SYSFS_DEPRECATED
 	dev->bus = &scsi_bus_type;
+#endif
 	dev->type = &scsi_target_type;
 	starget->id = id;
 	starget->channel = channel;
diff -puN fs/partitions/check.c~revert-driver-core-remove-config_sysfs_deprecated fs/partitions/check.c
--- a/fs/partitions/check.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/fs/partitions/check.c
@@ -499,14 +499,14 @@ void register_disk(struct gendisk *disk)
 
 	if (device_add(ddev))
 		return;
-
+#ifndef CONFIG_SYSFS_DEPRECATED
 	err = sysfs_create_link(block_depr, &ddev->kobj,
 				kobject_name(&ddev->kobj));
 	if (err) {
 		device_del(ddev);
 		return;
 	}
-
+#endif
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
@@ -723,6 +723,8 @@ void del_gendisk(struct gendisk *disk)
 	kobject_put(disk->part0.holder_dir);
 	kobject_put(disk->slave_dir);
 	disk->driverfs_dev = NULL;
+#ifndef CONFIG_SYSFS_DEPRECATED
 	sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
+#endif
 	device_del(disk_to_dev(disk));
 }
diff -puN include/sound/core.h~revert-driver-core-remove-config_sysfs_deprecated include/sound/core.h
--- a/include/sound/core.h~revert-driver-core-remove-config_sysfs_deprecated
+++ a/include/sound/core.h
@@ -133,7 +133,9 @@ struct snd_card {
 	int free_on_last_close;		/* free in context of file_release */
 	wait_queue_head_t shutdown_sleep;
 	struct device *dev;		/* device assigned to this card */
+#ifndef CONFIG_SYSFS_DEPRECATED
 	struct device *card_dev;	/* cardX object for sysfs */
+#endif
 
 #ifdef CONFIG_PM
 	unsigned int power_state;	/* power state */
@@ -194,7 +196,11 @@ struct snd_minor {
 /* return a device pointer linked to each sound device as a parent */
 static inline struct device *snd_card_get_device_link(struct snd_card *card)
 {
+#ifdef CONFIG_SYSFS_DEPRECATED
+	return card ? card->dev : NULL;
+#else
 	return card ? card->card_dev : NULL;
+#endif
 }
 
 /* sound.c */
diff -puN init/Kconfig~revert-driver-core-remove-config_sysfs_deprecated init/Kconfig
--- a/init/Kconfig~revert-driver-core-remove-config_sysfs_deprecated
+++ a/init/Kconfig
@@ -655,6 +655,42 @@ endif # CGROUPS
 config MM_OWNER
 	bool
 
+config SYSFS_DEPRECATED
+	bool
+
+config SYSFS_DEPRECATED_V2
+	bool "enable deprecated sysfs features to support old userspace tools"
+	depends on SYSFS
+	default n
+	select SYSFS_DEPRECATED
+	help
+	  This option switches the layout of sysfs to the deprecated
+	  version. Do not use it on recent distributions.
+
+	  The current sysfs layout features a unified device tree at
+	  /sys/devices/, which is able to express a hierarchy between
+	  class devices. If the deprecated option is set to Y, the
+	  unified device tree is split into a bus device tree at
+	  /sys/devices/ and several individual class device trees at
+	  /sys/class/. The class and bus devices will be connected by
+	  "<subsystem>:<name>" and the "device" links. The "block"
+	  class devices, will not show up in /sys/class/block/. Some
+	  subsystems will suppress the creation of some devices which
+	  depend on the unified device tree.
+
+	  This option is not a pure compatibility option that can
+	  be safely enabled on newer distributions. It will change the
+	  layout of sysfs to the non-extensible deprecated version,
+	  and disable some features, which can not be exported without
+	  confusing older userspace tools. Since 2007/2008 all major
+	  distributions do not enable this option, and ship no tools which
+	  depend on the deprecated layout or this option.
+
+	  If you are using a new kernel on an older distribution, or use
+	  older userspace tools, you might need to say Y here. Do not say Y,
+	  if the original kernel, that came with your distribution, has
+	  this option set to N.
+
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
 	help
diff -puN sound/core/init.c~revert-driver-core-remove-config_sysfs_deprecated sound/core/init.c
--- a/sound/core/init.c~revert-driver-core-remove-config_sysfs_deprecated
+++ a/sound/core/init.c
@@ -395,10 +395,12 @@ int snd_card_disconnect(struct snd_card 
 		snd_printk(KERN_ERR "not all devices for card %i can be disconnected\n", card->number);
 
 	snd_info_card_disconnect(card);
+#ifndef CONFIG_SYSFS_DEPRECATED
 	if (card->card_dev) {
 		device_unregister(card->card_dev);
 		card->card_dev = NULL;
 	}
+#endif
 #ifdef CONFIG_PM
 	wake_up(&card->power_sleep);
 #endif
@@ -571,6 +573,7 @@ void snd_card_set_id(struct snd_card *ca
 }
 EXPORT_SYMBOL(snd_card_set_id);
 
+#ifndef CONFIG_SYSFS_DEPRECATED
 static ssize_t
 card_id_show_attr(struct device *dev,
 		  struct device_attribute *attr, char *buf)
@@ -627,6 +630,7 @@ card_number_show_attr(struct device *dev
 
 static struct device_attribute card_number_attrs =
 	__ATTR(number, S_IRUGO, card_number_show_attr, NULL);
+#endif /* CONFIG_SYSFS_DEPRECATED */
 
 /**
  *  snd_card_register - register the soundcard
@@ -645,7 +649,7 @@ int snd_card_register(struct snd_card *c
 
 	if (snd_BUG_ON(!card))
 		return -EINVAL;
-
+#ifndef CONFIG_SYSFS_DEPRECATED
 	if (!card->card_dev) {
 		card->card_dev = device_create(sound_class, card->dev,
 					       MKDEV(0, 0), card,
@@ -653,7 +657,7 @@ int snd_card_register(struct snd_card *c
 		if (IS_ERR(card->card_dev))
 			card->card_dev = NULL;
 	}
-
+#endif
 	if ((err = snd_device_register_all(card)) < 0)
 		return err;
 	mutex_lock(&snd_card_mutex);
@@ -670,6 +674,7 @@ int snd_card_register(struct snd_card *c
 	if (snd_mixer_oss_notify_callback)
 		snd_mixer_oss_notify_callback(card, SND_MIXER_OSS_NOTIFY_REGISTER);
 #endif
+#ifndef CONFIG_SYSFS_DEPRECATED
 	if (card->card_dev) {
 		err = device_create_file(card->card_dev, &card_id_attrs);
 		if (err < 0)
@@ -678,7 +683,7 @@ int snd_card_register(struct snd_card *c
 		if (err < 0)
 			return err;
 	}
-
+#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
mm-vmap-area-cache-fix.patch
x86-numa-fix-boot-without-ram-on-node0-again-fix.patch
linux-next.patch
next-remove-localversion.patch
revert-driver-core-remove-config_sysfs_deprecated.patch
module-fix-crash-in-get_ksymbol-when-oopsing-in-module-init.patch
i-need-old-gcc.patch
revert-ed5aa19b93da2c094b6647762774a8022e4e1d6c.patch
revert-9652e31db6d841e291531547b3f4f12b5aeb42a9.patch
revert-fdc8302019d9bc10729cd3e8d348571e833388aa.patch
revert-324d76561842e551051e2a897b958b0539f6867b.patch
revert-e92e80797e7eaaf2a9bbd586c63f7c6bd3177276.patch
revert-d04ab5241f301bdcad2f6beb0ecd326bd82100a7.patch
revert-3ab7269a6058c136795ce9417f7051a0edde60db.patch
revert-4624469822455b4accc886557f6c997ccdd59066.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
acpi-fix-bogus-preemption-logic-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path-v2-fix.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs-fix.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
serial-mmio32-support-for-8250_earlyc-fix-fix.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver-checkpatch-fixes.patch
mmc-add-jz4740-mmc-driver-fix.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

