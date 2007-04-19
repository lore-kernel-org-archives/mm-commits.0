From: akpm@linux-foundation.org
Subject: + revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch added to -mm tree
Date: Thu, 19 Apr 2007 11:45:10 -0700
Message-ID: <200704191845.l3JIjA8k027750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170AbXDSSpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 14:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dtor@mail.ru, greg@kroah.com, kay.sievers@vrfy.org


The patch titled
     revert gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
has been added to the -mm tree.  Its filename is
     revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
From: Andrew Morton <akpm@linux-foundation.org>

This makes an unholy mess of the input tree.

Please, send patches to subsystems via the subsystem maintainer where at all
possible, rather than reasching over and fiddling with other people's stuff?

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c                          |   12 ++--
 drivers/base/base.h                    |    2 
 drivers/base/bus.c                     |   16 +++---
 drivers/base/class.c                   |   18 +++----
 drivers/base/core.c                    |   22 ++++----
 drivers/base/firmware.c                |    6 +-
 drivers/base/power/shutdown.c          |    4 +
 drivers/base/sys.c                     |   14 ++---
 drivers/firmware/efivars.c             |   12 ++--
 drivers/input/evdev.c                  |    4 -
 drivers/input/joydev.c                 |    4 -
 drivers/input/mousedev.c               |    4 -
 drivers/input/tsdev.c                  |    4 -
 drivers/pci/hotplug/acpiphp_ibm.c      |    4 -
 drivers/pci/hotplug/pci_hotplug_core.c |    4 -
 drivers/uio/uio.c                      |    1 
 fs/configfs/mount.c                    |    2 
 fs/debugfs/inode.c                     |    2 
 fs/dlm/lockspace.c                     |    2 
 fs/ecryptfs/main.c                     |   12 ++--
 fs/fuse/inode.c                        |    4 -
 fs/gfs2/locking/dlm/sysfs.c            |    2 
 fs/gfs2/sys.c                          |    2 
 fs/ocfs2/cluster/masklog.c             |    4 -
 fs/ocfs2/cluster/masklog.h             |    2 
 fs/ocfs2/cluster/sys.c                 |    7 +-
 fs/partitions/check.c                  |    6 +-
 fs/sysfs/file.c                        |   11 ++--
 include/acpi/acpi_bus.h                |    2 
 include/linux/device.h                 |    8 +--
 include/linux/fs.h                     |    2 
 include/linux/kobject.h                |   58 +++++++++++++----------
 include/linux/module.h                 |    2 
 include/linux/pci_hotplug.h            |    2 
 kernel/ksysfs.c                        |   12 ++--
 kernel/module.c                        |    8 +--
 kernel/params.c                        |    2 
 kernel/power/disk.c                    |   14 ++---
 kernel/power/main.c                    |   10 +--
 kernel/power/power.h                   |    2 
 lib/kobject.c                          |   53 +++++++++++++++++----
 security/inode.c                       |    2 
 42 files changed, 205 insertions(+), 159 deletions(-)

diff -puN block/genhd.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed block/genhd.c
--- a/block/genhd.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/block/genhd.c
@@ -17,7 +17,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 
-struct kset block_subsys;
+struct subsystem block_subsys;
 static DEFINE_MUTEX(block_subsys_lock);
 
 /*
@@ -221,7 +221,7 @@ static void *part_start(struct seq_file 
 	loff_t l = *pos;
 
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
+	list_for_each(p, &block_subsys.kset.list)
 		if (!l--)
 			return list_entry(p, struct gendisk, kobj.entry);
 	return NULL;
@@ -231,7 +231,7 @@ static void *part_next(struct seq_file *
 {
 	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
 	++*pos;
-	return p==&block_subsys.list ? NULL :
+	return p==&block_subsys.kset.list ? NULL : 
 		list_entry(p, struct gendisk, kobj.entry);
 }
 
@@ -246,7 +246,7 @@ static int show_partition(struct seq_fil
 	int n;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->kobj.entry == block_subsys.list.next)
+	if (&sgp->kobj.entry == block_subsys.kset.list.next)
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
@@ -565,7 +565,7 @@ static void *diskstats_start(struct seq_
 	struct list_head *p;
 
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
+	list_for_each(p, &block_subsys.kset.list)
 		if (!k--)
 			return list_entry(p, struct gendisk, kobj.entry);
 	return NULL;
@@ -575,7 +575,7 @@ static void *diskstats_next(struct seq_f
 {
 	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
 	++*pos;
-	return p==&block_subsys.list ? NULL :
+	return p==&block_subsys.kset.list ? NULL :
 		list_entry(p, struct gendisk, kobj.entry);
 }
 
diff -puN drivers/base/base.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/base/base.h
--- a/drivers/base/base.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/base/base.h
@@ -45,5 +45,3 @@ struct class_device_attribute *to_class_
 extern char *make_class_name(const char *name, struct kobject *kobj);
 
 extern void devres_release_all(struct device *dev);
-
-extern struct kset devices_subsys;
diff -puN drivers/base/bus.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/base/bus.c
--- a/drivers/base/bus.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/base/bus.c
@@ -17,7 +17,7 @@
 #include "power/power.h"
 
 #define to_bus_attr(_attr) container_of(_attr, struct bus_attribute, attr)
-#define to_bus(obj) container_of(obj, struct bus_type, subsys.kobj)
+#define to_bus(obj) container_of(obj, struct bus_type, subsys.kset.kobj)
 
 /*
  * sysfs bindings for drivers
@@ -123,7 +123,7 @@ int bus_create_file(struct bus_type * bu
 {
 	int error;
 	if (get_bus(bus)) {
-		error = sysfs_create_file(&bus->subsys.kobj, &attr->attr);
+		error = sysfs_create_file(&bus->subsys.kset.kobj, &attr->attr);
 		put_bus(bus);
 	} else
 		error = -EINVAL;
@@ -133,7 +133,7 @@ int bus_create_file(struct bus_type * bu
 void bus_remove_file(struct bus_type * bus, struct bus_attribute * attr)
 {
 	if (get_bus(bus)) {
-		sysfs_remove_file(&bus->subsys.kobj, &attr->attr);
+		sysfs_remove_file(&bus->subsys.kset.kobj, &attr->attr);
 		put_bus(bus);
 	}
 }
@@ -397,7 +397,7 @@ static void device_remove_attrs(struct b
 static int make_deprecated_bus_links(struct device *dev)
 {
 	return sysfs_create_link(&dev->kobj,
-				 &dev->bus->subsys.kobj, "bus");
+				 &dev->bus->subsys.kset.kobj, "bus");
 }
 
 static void remove_deprecated_bus_links(struct device *dev)
@@ -431,7 +431,7 @@ int bus_add_device(struct device * dev)
 		if (error)
 			goto out_id;
 		error = sysfs_create_link(&dev->kobj,
-				&dev->bus->subsys.kobj, "subsystem");
+				&dev->bus->subsys.kset.kobj, "subsystem");
 		if (error)
 			goto out_subsys;
 		error = make_deprecated_bus_links(dev);
@@ -808,7 +808,7 @@ int bus_register(struct bus_type * bus)
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&bus->bus_notifier);
 
-	retval = kobject_set_name(&bus->subsys.kobj, "%s", bus->name);
+	retval = kobject_set_name(&bus->subsys.kset.kobj, "%s", bus->name);
 	if (retval)
 		goto out;
 
@@ -818,13 +818,13 @@ int bus_register(struct bus_type * bus)
 		goto out;
 
 	kobject_set_name(&bus->devices.kobj, "devices");
-	bus->devices.kobj.parent = &bus->subsys.kobj;
+	bus->devices.subsys = &bus->subsys;
 	retval = kset_register(&bus->devices);
 	if (retval)
 		goto bus_devices_fail;
 
 	kobject_set_name(&bus->drivers.kobj, "drivers");
-	bus->drivers.kobj.parent = &bus->subsys.kobj;
+	bus->drivers.subsys = &bus->subsys;
 	bus->drivers.ktype = &ktype_driver;
 	retval = kset_register(&bus->drivers);
 	if (retval)
diff -puN drivers/base/class.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/base/class.c
--- a/drivers/base/class.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/base/class.c
@@ -19,8 +19,10 @@
 #include <linux/slab.h>
 #include "base.h"
 
+extern struct subsystem devices_subsys;
+
 #define to_class_attr(_attr) container_of(_attr, struct class_attribute, attr)
-#define to_class(obj) container_of(obj, struct class, subsys.kobj)
+#define to_class(obj) container_of(obj, struct class, subsys.kset.kobj)
 
 static ssize_t
 class_attr_show(struct kobject * kobj, struct attribute * attr, char * buf)
@@ -78,7 +80,7 @@ int class_create_file(struct class * cls
 {
 	int error;
 	if (cls) {
-		error = sysfs_create_file(&cls->subsys.kobj, &attr->attr);
+		error = sysfs_create_file(&cls->subsys.kset.kobj, &attr->attr);
 	} else
 		error = -EINVAL;
 	return error;
@@ -87,7 +89,7 @@ int class_create_file(struct class * cls
 void class_remove_file(struct class * cls, const struct class_attribute * attr)
 {
 	if (cls)
-		sysfs_remove_file(&cls->subsys.kobj, &attr->attr);
+		sysfs_remove_file(&cls->subsys.kset.kobj, &attr->attr);
 }
 
 static struct class *class_get(struct class *cls)
@@ -145,7 +147,7 @@ int class_register(struct class * cls)
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
 	init_MUTEX(&cls->sem);
-	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
+	error = kobject_set_name(&cls->subsys.kset.kobj, "%s", cls->name);
 	if (error)
 		return error;
 
@@ -609,7 +611,7 @@ int class_device_add(struct class_device
 	if (parent_class_dev)
 		class_dev->kobj.parent = &parent_class_dev->kobj;
 	else
-		class_dev->kobj.parent = &parent_class->subsys.kobj;
+		class_dev->kobj.parent = &parent_class->subsys.kset.kobj;
 
 	error = kobject_add(&class_dev->kobj);
 	if (error)
@@ -617,7 +619,7 @@ int class_device_add(struct class_device
 
 	/* add the needed attributes to this device */
 	error = sysfs_create_link(&class_dev->kobj,
-				  &parent_class->subsys.kobj, "subsystem");
+				  &parent_class->subsys.kset.kobj, "subsystem");
 	if (error)
 		goto out3;
 	class_dev->uevent_attr.attr.name = "uevent";
@@ -913,8 +915,8 @@ int __init classes_init(void)
 	/* ick, this is ugly, the things we go through to keep from showing up
 	 * in sysfs... */
 	subsystem_init(&class_obj_subsys);
-	if (!class_obj_subsys.kobj.parent)
-		class_obj_subsys.kobj.parent = &class_obj_subsys.kobj;
+	if (!class_obj_subsys.kset.subsys)
+			class_obj_subsys.kset.subsys = &class_obj_subsys;
 	return 0;
 }
 
diff -puN drivers/base/core.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/base/core.c
--- a/drivers/base/core.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/base/core.c
@@ -556,7 +556,7 @@ static struct kobject * get_device_paren
 	/* Set the parent to the class, not the parent device */
 	/* this keeps sysfs from having a symlink to make old udevs happy */
 	if (dev->class)
-		return &dev->class->subsys.kobj;
+		return &dev->class->subsys.kset.kobj;
 	else if (parent)
 		return &parent->kobj;
 
@@ -568,7 +568,7 @@ static struct kobject *virtual_device_pa
 	static struct kobject *virtual_dir = NULL;
 
 	if (!virtual_dir)
-		virtual_dir = kobject_add_dir(&devices_subsys.kobj, "virtual");
+		virtual_dir = kobject_add_dir(&devices_subsys.kset.kobj, "virtual");
 
 	return virtual_dir;
 }
@@ -698,12 +698,12 @@ int device_add(struct device *dev)
 	}
 
 	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kobj,
+		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
 				  "subsystem");
 		/* If this is not a "fake" compatible device, then create the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kobj)
-			sysfs_create_link(&dev->class->subsys.kobj,
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_create_link(&dev->class->subsys.kset.kobj,
 					  &dev->kobj, dev->bus_id);
 		if (parent) {
 			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
@@ -761,8 +761,8 @@ int device_add(struct device *dev)
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		/* If this is not a "fake" compatible device, remove the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kobj)
-			sysfs_remove_link(&dev->class->subsys.kobj,
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
 					  dev->bus_id);
 		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
@@ -863,8 +863,8 @@ void device_del(struct device * dev)
 		sysfs_remove_link(&dev->kobj, "subsystem");
 		/* If this is not a "fake" compatible device, remove the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kobj)
-			sysfs_remove_link(&dev->class->subsys.kobj,
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
 					  dev->bus_id);
 		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
@@ -1180,9 +1180,9 @@ int device_rename(struct device *dev, ch
 #endif
 
 	if (dev->class) {
-		sysfs_remove_link(&dev->class->subsys.kobj,
+		sysfs_remove_link(&dev->class->subsys.kset.kobj,
 				  old_symlink_name);
-		sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+		sysfs_create_link(&dev->class->subsys.kset.kobj, &dev->kobj,
 				  dev->bus_id);
 	}
 	put_device(dev);
diff -puN drivers/base/firmware.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/base/firmware.c
--- a/drivers/base/firmware.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/base/firmware.c
@@ -17,13 +17,13 @@
 
 static decl_subsys(firmware, NULL, NULL);
 
-int firmware_register(struct kset *s)
+int firmware_register(struct subsystem * s)
 {
-	kobj_set_kset_s(s, firmware_subsys);
+	kset_set_kset_s(s, firmware_subsys);
 	return subsystem_register(s);
 }
 
-void firmware_unregister(struct kset *s)
+void firmware_unregister(struct subsystem * s)
 {
 	subsystem_unregister(s);
 }
diff -puN drivers/base/power/shutdown.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/base/power/shutdown.c
--- a/drivers/base/power/shutdown.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/base/power/shutdown.c
@@ -16,6 +16,8 @@
 
 #define to_dev(node) container_of(node, struct device, kobj.entry)
 
+extern struct subsystem devices_subsys;
+
 
 /**
  * We handle system devices differently - we suspend and shut them
@@ -34,7 +36,7 @@ void device_shutdown(void)
 {
 	struct device * dev, *devn;
 
-	list_for_each_entry_safe_reverse(dev, devn, &devices_subsys.list,
+	list_for_each_entry_safe_reverse(dev, devn, &devices_subsys.kset.list,
 				kobj.entry) {
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
diff -puN drivers/base/sys.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/base/sys.c
--- a/drivers/base/sys.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/base/sys.c
@@ -25,7 +25,7 @@
 
 #include "base.h"
 
-extern struct kset devices_subsys;
+extern struct subsystem devices_subsys;
 
 #define to_sysdev(k) container_of(k, struct sys_device, kobj)
 #define to_sysdev_attr(a) container_of(a, struct sysdev_attribute, attr)
@@ -138,7 +138,7 @@ int sysdev_class_register(struct sysdev_
 	pr_debug("Registering sysdev class '%s'\n",
 		 kobject_name(&cls->kset.kobj));
 	INIT_LIST_HEAD(&cls->drivers);
-	cls->kset.kobj.parent = &system_subsys.kobj;
+	cls->kset.subsys = &system_subsys;
 	kset_set_kset_s(cls, system_subsys);
 	return kset_register(&cls->kset);
 }
@@ -309,7 +309,7 @@ void sysdev_shutdown(void)
 	pr_debug("Shutting Down System Devices\n");
 
 	down(&sysdev_drivers_lock);
-	list_for_each_entry_reverse(cls, &system_subsys.list,
+	list_for_each_entry_reverse(cls, &system_subsys.kset.list,
 				    kset.kobj.entry) {
 		struct sys_device * sysdev;
 
@@ -384,7 +384,7 @@ int sysdev_suspend(pm_message_t state)
 
 	pr_debug("Suspending System Devices\n");
 
-	list_for_each_entry_reverse(cls, &system_subsys.list,
+	list_for_each_entry_reverse(cls, &system_subsys.kset.list,
 				    kset.kobj.entry) {
 
 		pr_debug("Suspending type '%s':\n",
@@ -457,7 +457,7 @@ gbl_driver:
 	}
 
 	/* resume other classes */
-	list_for_each_entry_continue(cls, &system_subsys.list,
+	list_for_each_entry_continue(cls, &system_subsys.kset.list,
 					kset.kobj.entry) {
 		list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
 			pr_debug(" %s\n", kobject_name(&err_dev->kobj));
@@ -483,7 +483,7 @@ int sysdev_resume(void)
 
 	pr_debug("Resuming System Devices\n");
 
-	list_for_each_entry(cls, &system_subsys.list, kset.kobj.entry) {
+	list_for_each_entry(cls, &system_subsys.kset.list, kset.kobj.entry) {
 		struct sys_device * sysdev;
 
 		pr_debug("Resuming type '%s':\n",
@@ -501,7 +501,7 @@ int sysdev_resume(void)
 
 int __init system_bus_init(void)
 {
-	system_subsys.kobj.parent = &devices_subsys.kobj;
+	system_subsys.kset.kobj.parent = &devices_subsys.kset.kobj;
 	return subsystem_register(&system_subsys);
 }
 
diff -puN drivers/firmware/efivars.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/firmware/efivars.c
--- a/drivers/firmware/efivars.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/firmware/efivars.c
@@ -409,7 +409,7 @@ static struct kobj_type ktype_efivar = {
 };
 
 static ssize_t
-dummy(struct kset *kset, char *buf)
+dummy(struct subsystem *sub, char *buf)
 {
 	return -ENODEV;
 }
@@ -422,7 +422,7 @@ efivar_unregister(struct efivar_entry *v
 
 
 static ssize_t
-efivar_create(struct kset *kset, const char *buf, size_t count)
+efivar_create(struct subsystem *sub, const char *buf, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
 	struct efivar_entry *search_efivar, *n;
@@ -480,7 +480,7 @@ efivar_create(struct kset *kset, const c
 }
 
 static ssize_t
-efivar_delete(struct kset *kset, const char *buf, size_t count)
+efivar_delete(struct subsystem *sub, const char *buf, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
 	struct efivar_entry *search_efivar, *n;
@@ -551,11 +551,11 @@ static struct subsys_attribute *var_subs
  * the efivars driver
  */
 static ssize_t
-systab_read(struct kset *kset, char *buf)
+systab_read(struct subsystem *entry, char *buf)
 {
 	char *str = buf;
 
-	if (!kset || !buf)
+	if (!entry || !buf)
 		return -EINVAL;
 
 	if (efi.mps != EFI_INVALID_TABLE_ADDR)
@@ -687,7 +687,7 @@ efivars_init(void)
 		goto out_free;
 	}
 
-	kobj_set_kset_s(&vars_subsys, efi_subsys);
+	kset_set_kset_s(&vars_subsys, efi_subsys);
 
 	error = subsystem_register(&vars_subsys);
 
diff -puN drivers/input/evdev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/input/evdev.c
--- a/drivers/input/evdev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/input/evdev.c
@@ -650,7 +650,7 @@ static struct input_handle *evdev_connec
 			dev->cdev.dev, evdev->name);
 
 	/* temporary symlink to keep userspace happy */
-	sysfs_create_link(&input_class.subsys.kobj, &cdev->kobj,
+	sysfs_create_link(&input_class.subsys.kset.kobj, &cdev->kobj,
 			  evdev->name);
 
 	return &evdev->handle;
@@ -661,7 +661,7 @@ static void evdev_disconnect(struct inpu
 	struct evdev *evdev = handle->private;
 	struct evdev_list *list;
 
-	sysfs_remove_link(&input_class.subsys.kobj, evdev->name);
+	sysfs_remove_link(&input_class.subsys.kset.kobj, evdev->name);
 	class_device_destroy(&input_class,
 			MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + evdev->minor));
 	evdev->exist = 0;
diff -puN drivers/input/joydev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/input/joydev.c
--- a/drivers/input/joydev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/input/joydev.c
@@ -539,7 +539,7 @@ static struct input_handle *joydev_conne
 			dev->cdev.dev, joydev->name);
 
 	/* temporary symlink to keep userspace happy */
-	sysfs_create_link(&input_class.subsys.kobj, &cdev->kobj,
+	sysfs_create_link(&input_class.subsys.kset.kobj, &cdev->kobj,
 			  joydev->name);
 
 	return &joydev->handle;
@@ -550,7 +550,7 @@ static void joydev_disconnect(struct inp
 	struct joydev *joydev = handle->private;
 	struct joydev_list *list;
 
-	sysfs_remove_link(&input_class.subsys.kobj, joydev->name);
+	sysfs_remove_link(&input_class.subsys.kset.kobj, joydev->name);
 	class_device_destroy(&input_class, MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + joydev->minor));
 	joydev->exist = 0;
 
diff -puN drivers/input/mousedev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/input/mousedev.c
@@ -661,7 +661,7 @@ static struct input_handle *mousedev_con
 			dev->cdev.dev, mousedev->name);
 
 	/* temporary symlink to keep userspace happy */
-	sysfs_create_link(&input_class.subsys.kobj, &cdev->kobj,
+	sysfs_create_link(&input_class.subsys.kset.kobj, &cdev->kobj,
 			  mousedev->name);
 
 	return &mousedev->handle;
@@ -672,7 +672,7 @@ static void mousedev_disconnect(struct i
 	struct mousedev *mousedev = handle->private;
 	struct mousedev_list *list;
 
-	sysfs_remove_link(&input_class.subsys.kobj, mousedev->name);
+	sysfs_remove_link(&input_class.subsys.kset.kobj, mousedev->name);
 	class_device_destroy(&input_class,
 			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + mousedev->minor));
 	mousedev->exist = 0;
diff -puN drivers/input/tsdev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/input/tsdev.c
--- a/drivers/input/tsdev.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/input/tsdev.c
@@ -420,7 +420,7 @@ static struct input_handle *tsdev_connec
 			dev->cdev.dev, tsdev->name);
 
 	/* temporary symlink to keep userspace happy */
-	sysfs_create_link(&input_class.subsys.kobj, &cdev->kobj,
+	sysfs_create_link(&input_class.subsys.kset.kobj, &cdev->kobj,
 			  tsdev->name);
 
 	return &tsdev->handle;
@@ -431,7 +431,7 @@ static void tsdev_disconnect(struct inpu
 	struct tsdev *tsdev = handle->private;
 	struct tsdev_list *list;
 
-	sysfs_remove_link(&input_class.subsys.kobj, tsdev->name);
+	sysfs_remove_link(&input_class.subsys.kset.kobj, tsdev->name);
 	class_device_destroy(&input_class,
 			MKDEV(INPUT_MAJOR, TSDEV_MINOR_BASE + tsdev->minor));
 	tsdev->exist = 0;
diff -puN drivers/pci/hotplug/acpiphp_ibm.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/pci/hotplug/acpiphp_ibm.c
--- a/drivers/pci/hotplug/acpiphp_ibm.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/pci/hotplug/acpiphp_ibm.c
@@ -423,7 +423,7 @@ static int __init ibm_acpiphp_init(void)
 	int retval = 0;
 	acpi_status status;
 	struct acpi_device *device;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kobj;
+	struct kobject *sysdir = &pci_hotplug_slots_subsys.kset.kobj;
 
 	dbg("%s\n", __FUNCTION__);
 
@@ -470,7 +470,7 @@ init_return:
 static void __exit ibm_acpiphp_exit(void)
 {
 	acpi_status status;
-	struct kobject *sysdir = &pci_hotplug_slots_subsys.kobj;
+	struct kobject *sysdir = &pci_hotplug_slots_subsys.kset.kobj;
 
 	dbg("%s\n", __FUNCTION__);
 
diff -puN drivers/pci/hotplug/pci_hotplug_core.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/pci/hotplug/pci_hotplug_core.c
--- a/drivers/pci/hotplug/pci_hotplug_core.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/pci/hotplug/pci_hotplug_core.c
@@ -62,7 +62,7 @@ static int debug;
 
 static LIST_HEAD(pci_hotplug_slot_list);
 
-struct kset pci_hotplug_slots_subsys;
+struct subsystem pci_hotplug_slots_subsys;
 
 static ssize_t hotplug_slot_attr_show(struct kobject *kobj,
 		struct attribute *attr, char *buf)
@@ -764,7 +764,7 @@ static int __init pci_hotplug_init (void
 {
 	int result;
 
-	kobj_set_kset_s(&pci_hotplug_slots_subsys, pci_bus_type.subsys);
+	kset_set_kset_s(&pci_hotplug_slots_subsys, pci_bus_type.subsys);
 	result = subsystem_register(&pci_hotplug_slots_subsys);
 	if (result) {
 		err("Register subsys with error %d\n", result);
diff -puN drivers/uio/uio.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed drivers/uio/uio.c
--- a/drivers/uio/uio.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/drivers/uio/uio.c
@@ -162,6 +162,7 @@ static int uio_dev_add_attributes(struct
 			kobject_set_name(&idev->map_attr_kset.kobj,"maps");
 			idev->map_attr_kset.ktype = &map_attr_type;
 			idev->map_attr_kset.kobj.parent = &idev->dev->kobj;
+			idev->map_attr_kset.subsys = &uio_class->class->subsys;
 			ret = kset_register(&idev->map_attr_kset);
 			if (ret)
 				goto err_remove_group;
diff -puN fs/configfs/mount.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/configfs/mount.c
--- a/fs/configfs/mount.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/configfs/mount.c
@@ -140,7 +140,7 @@ static int __init configfs_init(void)
 	if (!configfs_dir_cachep)
 		goto out;
 
-	kobj_set_kset_s(&config_subsys, kernel_subsys);
+	kset_set_kset_s(&config_subsys, kernel_subsys);
 	err = subsystem_register(&config_subsys);
 	if (err) {
 		kmem_cache_destroy(configfs_dir_cachep);
diff -puN fs/debugfs/inode.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/debugfs/inode.c
--- a/fs/debugfs/inode.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/debugfs/inode.c
@@ -374,7 +374,7 @@ static int __init debugfs_init(void)
 {
 	int retval;
 
-	kobj_set_kset_s(&debug_subsys, kernel_subsys);
+	kset_set_kset_s(&debug_subsys, kernel_subsys);
 	retval = subsystem_register(&debug_subsys);
 	if (retval)
 		return retval;
diff -puN fs/dlm/lockspace.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/dlm/lockspace.c
--- a/fs/dlm/lockspace.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/dlm/lockspace.c
@@ -167,6 +167,7 @@ static struct kobj_type dlm_ktype = {
 };
 
 static struct kset dlm_kset = {
+	.subsys = &kernel_subsys,
 	.kobj   = {.name = "dlm",},
 	.ktype  = &dlm_ktype,
 };
@@ -217,7 +218,6 @@ int dlm_lockspace_init(void)
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
-	kobj_set_kset_s(&dlm_kset, kernel_subsys);
 	error = kset_register(&dlm_kset);
 	if (error)
 		printk("dlm_lockspace_init: cannot register kset %d\n", error);
diff -puN fs/ecryptfs/main.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/ecryptfs/main.c
@@ -793,7 +793,7 @@ static int do_sysfs_registration(void)
 		       "Unable to register ecryptfs sysfs subsystem\n");
 		goto out;
 	}
-	rc = sysfs_create_file(&ecryptfs_subsys.kobj,
+	rc = sysfs_create_file(&ecryptfs_subsys.kset.kobj,
 			       &sysfs_attr_version.attr);
 	if (rc) {
 		printk(KERN_ERR
@@ -801,12 +801,12 @@ static int do_sysfs_registration(void)
 		subsystem_unregister(&ecryptfs_subsys);
 		goto out;
 	}
-	rc = sysfs_create_file(&ecryptfs_subsys.kobj,
+	rc = sysfs_create_file(&ecryptfs_subsys.kset.kobj,
 			       &sysfs_attr_version_str.attr);
 	if (rc) {
 		printk(KERN_ERR
 		       "Unable to create ecryptfs version_str attribute\n");
-		sysfs_remove_file(&ecryptfs_subsys.kobj,
+		sysfs_remove_file(&ecryptfs_subsys.kset.kobj,
 				  &sysfs_attr_version.attr);
 		subsystem_unregister(&ecryptfs_subsys);
 		goto out;
@@ -841,7 +841,7 @@ static int __init ecryptfs_init(void)
 		ecryptfs_free_kmem_caches();
 		goto out;
 	}
-	kobj_set_kset_s(&ecryptfs_subsys, fs_subsys);
+	kset_set_kset_s(&ecryptfs_subsys, fs_subsys);
 	rc = do_sysfs_registration();
 	if (rc) {
 		printk(KERN_ERR "sysfs registration failed\n");
@@ -860,9 +860,9 @@ out:
 
 static void __exit ecryptfs_exit(void)
 {
-	sysfs_remove_file(&ecryptfs_subsys.kobj,
+	sysfs_remove_file(&ecryptfs_subsys.kset.kobj,
 			  &sysfs_attr_version.attr);
-	sysfs_remove_file(&ecryptfs_subsys.kobj,
+	sysfs_remove_file(&ecryptfs_subsys.kset.kobj,
 			  &sysfs_attr_version_str.attr);
 	subsystem_unregister(&ecryptfs_subsys);
 	ecryptfs_release_messaging(ecryptfs_transport);
diff -puN fs/fuse/inode.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/fuse/inode.c
--- a/fs/fuse/inode.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/fuse/inode.c
@@ -731,12 +731,12 @@ static int fuse_sysfs_init(void)
 {
 	int err;
 
-	kobj_set_kset_s(&fuse_subsys, fs_subsys);
+	kset_set_kset_s(&fuse_subsys, fs_subsys);
 	err = subsystem_register(&fuse_subsys);
 	if (err)
 		goto out_err;
 
-	kobj_set_kset_s(&connections_subsys, fuse_subsys);
+	kset_set_kset_s(&connections_subsys, fuse_subsys);
 	err = subsystem_register(&connections_subsys);
 	if (err)
 		goto out_fuse_unregister;
diff -puN fs/gfs2/locking/dlm/sysfs.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/gfs2/locking/dlm/sysfs.c
--- a/fs/gfs2/locking/dlm/sysfs.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/gfs2/locking/dlm/sysfs.c
@@ -190,6 +190,7 @@ static struct kobj_type gdlm_ktype = {
 };
 
 static struct kset gdlm_kset = {
+	.subsys = &kernel_subsys,
 	.kobj   = {.name = "lock_dlm",},
 	.ktype  = &gdlm_ktype,
 };
@@ -224,7 +225,6 @@ int gdlm_sysfs_init(void)
 {
 	int error;
 
-	kobj_set_kset_s(&gdlm_kset, kernel_subsys);
 	error = kset_register(&gdlm_kset);
 	if (error)
 		printk("lock_dlm: cannot register kset %d\n", error);
diff -puN fs/gfs2/sys.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/gfs2/sys.c
--- a/fs/gfs2/sys.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/gfs2/sys.c
@@ -222,6 +222,7 @@ static struct kobj_type gfs2_ktype = {
 };
 
 static struct kset gfs2_kset = {
+	.subsys = &fs_subsys,
 	.kobj   = {.name = "gfs2"},
 	.ktype  = &gfs2_ktype,
 };
@@ -553,7 +554,6 @@ int gfs2_sys_init(void)
 {
 	gfs2_sys_margs = NULL;
 	spin_lock_init(&gfs2_sys_margs_lock);
-	kobj_set_kset_s(&gfs2_kset, fs_subsys);
 	return kset_register(&gfs2_kset);
 }
 
diff -puN fs/ocfs2/cluster/masklog.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/ocfs2/cluster/masklog.c
--- a/fs/ocfs2/cluster/masklog.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/ocfs2/cluster/masklog.c
@@ -146,7 +146,7 @@ static struct kset mlog_kset = {
 	.kobj   = {.name = "logmask", .ktype = &mlog_ktype},
 };
 
-int mlog_sys_init(struct kset *o2cb_subsys)
+int mlog_sys_init(struct subsystem *o2cb_subsys)
 {
 	int i = 0;
 
@@ -156,7 +156,7 @@ int mlog_sys_init(struct kset *o2cb_subs
 	}
 	mlog_attr_ptrs[i] = NULL;
 
-	kobj_set_kset_s(&mlog_kset, o2cb_subsys);
+	mlog_kset.subsys = o2cb_subsys;
 	return kset_register(&mlog_kset);
 }
 
diff -puN fs/ocfs2/cluster/masklog.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/ocfs2/cluster/masklog.h
--- a/fs/ocfs2/cluster/masklog.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/ocfs2/cluster/masklog.h
@@ -278,7 +278,7 @@ extern struct mlog_bits mlog_and_bits, m
 
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
-int mlog_sys_init(struct kset *o2cb_subsys);
+int mlog_sys_init(struct subsystem *o2cb_subsys);
 void mlog_sys_shutdown(void);
 
 #endif /* O2CLUSTER_MASKLOG_H */
diff -puN fs/ocfs2/cluster/sys.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/ocfs2/cluster/sys.c
--- a/fs/ocfs2/cluster/sys.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/ocfs2/cluster/sys.c
@@ -42,6 +42,7 @@ struct o2cb_attribute {
 #define O2CB_ATTR(_name, _mode, _show, _store)	\
 struct o2cb_attribute o2cb_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
+#define to_o2cb_subsys(k) container_of(to_kset(k), struct subsystem, kset)
 #define to_o2cb_attr(_attr) container_of(_attr, struct o2cb_attribute, attr)
 
 static ssize_t o2cb_interface_revision_show(char *buf)
@@ -78,7 +79,7 @@ static ssize_t
 o2cb_show(struct kobject * kobj, struct attribute * attr, char * buffer)
 {
 	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
-	struct kset *sbs = to_kset(kobj);
+	struct subsystem *sbs = to_o2cb_subsys(kobj);
 
 	BUG_ON(sbs != &o2cb_subsys);
 
@@ -92,7 +93,7 @@ o2cb_store(struct kobject * kobj, struct
 	     const char * buffer, size_t count)
 {
 	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
-	struct kset *sbs = to_kset(kobj);
+	struct subsystem *sbs = to_o2cb_subsys(kobj);
 
 	BUG_ON(sbs != &o2cb_subsys);
 
@@ -111,7 +112,7 @@ int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_subsys.kobj.ktype = &o2cb_subsys_type;
+	o2cb_subsys.kset.kobj.ktype = &o2cb_subsys_type;
 	ret = subsystem_register(&o2cb_subsys);
 	if (ret)
 		return ret;
diff -puN fs/partitions/check.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/partitions/check.c
--- a/fs/partitions/check.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/partitions/check.c
@@ -312,7 +312,7 @@ static struct attribute * default_attrs[
 	NULL,
 };
 
-extern struct kset block_subsys;
+extern struct subsystem block_subsys;
 
 static void part_release(struct kobject *kobj)
 {
@@ -388,7 +388,7 @@ void add_partition(struct gendisk *disk,
 	kobject_add(&p->kobj);
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
@@ -443,7 +443,7 @@ static int disk_sysfs_symlinks(struct ge
 			goto err_out_dev_link;
 	}
 
-	err = sysfs_create_link(&disk->kobj, &block_subsys.kobj,
+	err = sysfs_create_link(&disk->kobj, &block_subsys.kset.kobj,
 				"subsystem");
 	if (err)
 		goto err_out_disk_name_lnk;
diff -puN fs/sysfs/file.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed fs/sysfs/file.c
--- a/fs/sysfs/file.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/fs/sysfs/file.c
@@ -13,7 +13,8 @@
 
 #include "sysfs.h"
 
-#define to_sattr(a) container_of(a,struct subsys_attribute, attr)
+#define to_subsys(k) container_of(k,struct subsystem,kset.kobj)
+#define to_sattr(a) container_of(a,struct subsys_attribute,attr)
 
 /*
  * Subsystem file operations.
@@ -23,12 +24,12 @@
 static ssize_t 
 subsys_attr_show(struct kobject * kobj, struct attribute * attr, char * page)
 {
-	struct kset *kset = to_kset(kobj);
+	struct subsystem * s = to_subsys(kobj);
 	struct subsys_attribute * sattr = to_sattr(attr);
 	ssize_t ret = -EIO;
 
 	if (sattr->show)
-		ret = sattr->show(kset, page);
+		ret = sattr->show(s,page);
 	return ret;
 }
 
@@ -36,12 +37,12 @@ static ssize_t 
 subsys_attr_store(struct kobject * kobj, struct attribute * attr, 
 		  const char * page, size_t count)
 {
-	struct kset *kset = to_kset(kobj);
+	struct subsystem * s = to_subsys(kobj);
 	struct subsys_attribute * sattr = to_sattr(attr);
 	ssize_t ret = -EIO;
 
 	if (sattr->store)
-		ret = sattr->store(kset, page, count);
+		ret = sattr->store(s,page,count);
 	return ret;
 }
 
diff -puN include/acpi/acpi_bus.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/include/acpi/acpi_bus.h
@@ -316,7 +316,7 @@ struct acpi_bus_event {
 	u32 data;
 };
 
-extern struct kset acpi_subsys;
+extern struct subsystem acpi_subsys;
 
 /*
  * External Functions
diff -puN include/linux/device.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed include/linux/device.h
--- a/include/linux/device.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/include/linux/device.h
@@ -53,7 +53,7 @@ struct bus_type {
 	const char		* name;
 	struct module		* owner;
 
-	struct kset		subsys;
+	struct subsystem	subsys;
 	struct kset		drivers;
 	struct kset		devices;
 	struct klist		klist_devices;
@@ -179,7 +179,7 @@ struct class {
 	const char		* name;
 	struct module		* owner;
 
-	struct kset		subsys;
+	struct subsystem	subsys;
 	struct list_head	children;
 	struct list_head	devices;
 	struct list_head	interfaces;
@@ -555,8 +555,8 @@ extern void device_shutdown(void);
 
 
 /* drivers/base/firmware.c */
-extern int __must_check firmware_register(struct kset *);
-extern void firmware_unregister(struct kset *);
+extern int __must_check firmware_register(struct subsystem *);
+extern void firmware_unregister(struct subsystem *);
 
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(struct device *dev);
diff -puN include/linux/fs.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed include/linux/fs.h
--- a/include/linux/fs.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/include/linux/fs.h
@@ -1411,7 +1411,7 @@ extern void mnt_set_mountpoint(struct vf
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 
 /* /sys/fs */
-extern struct kset fs_subsys;
+extern struct subsystem fs_subsys;
 
 #define FLOCK_VERIFY_READ  1
 #define FLOCK_VERIFY_WRITE 2
diff -puN include/linux/kobject.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed include/linux/kobject.h
--- a/include/linux/kobject.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/include/linux/kobject.h
@@ -124,6 +124,7 @@ struct kset_uevent_ops {
 };
 
 struct kset {
+	struct subsystem	* subsys;
 	struct kobj_type	* ktype;
 	struct list_head	list;
 	spinlock_t		list_lock;
@@ -170,23 +171,32 @@ extern struct kobject * kset_find_obj(st
 #define set_kset_name(str)	.kset = { .kobj = { .name = str } }
 
 
+
+struct subsystem {
+	struct kset		kset;
+};
+
 #define decl_subsys(_name,_type,_uevent_ops) \
-struct kset _name##_subsys = { \
-	.kobj = { .name = __stringify(_name) }, \
-	.ktype = _type, \
-	.uevent_ops =_uevent_ops, \
+struct subsystem _name##_subsys = { \
+	.kset = { \
+		.kobj = { .name = __stringify(_name) }, \
+		.ktype = _type, \
+		.uevent_ops =_uevent_ops, \
+	} \
 }
 #define decl_subsys_name(_varname,_name,_type,_uevent_ops) \
-struct kset _varname##_subsys = { \
-	.kobj = { .name = __stringify(_name) }, \
-	.ktype = _type, \
-	.uevent_ops =_uevent_ops, \
+struct subsystem _varname##_subsys = { \
+	.kset = { \
+		.kobj = { .name = __stringify(_name) }, \
+		.ktype = _type, \
+		.uevent_ops =_uevent_ops, \
+	} \
 }
 
 /* The global /sys/kernel/ subsystem for people to chain off of */
-extern struct kset kernel_subsys;
+extern struct subsystem kernel_subsys;
 /* The global /sys/hypervisor/ subsystem  */
-extern struct kset hypervisor_subsys;
+extern struct subsystem hypervisor_subsys;
 
 /**
  * Helpers for setting the kset of registered objects.
@@ -204,7 +214,7 @@ extern struct kset hypervisor_subsys;
  */
 
 #define kobj_set_kset_s(obj,subsys) \
-	(obj)->kobj.kset = &(subsys)
+	(obj)->kobj.kset = &(subsys).kset
 
 /**
  *	kset_set_kset_s(obj,subsys) - set kset for embedded kset.
@@ -218,7 +228,7 @@ extern struct kset hypervisor_subsys;
  */
 
 #define kset_set_kset_s(obj,subsys) \
-	(obj)->kset.kobj.kset = &(subsys)
+	(obj)->kset.kobj.kset = &(subsys).kset
 
 /**
  *	subsys_set_kset(obj,subsys) - set kset for subsystem
@@ -231,31 +241,29 @@ extern struct kset hypervisor_subsys;
  */
 
 #define subsys_set_kset(obj,_subsys) \
-	(obj)->subsys.kobj.kset = &(_subsys)
+	(obj)->subsys.kset.kobj.kset = &(_subsys).kset
 
-extern void subsystem_init(struct kset *);
-extern int __must_check subsystem_register(struct kset *);
-extern void subsystem_unregister(struct kset *);
+extern void subsystem_init(struct subsystem *);
+extern int __must_check subsystem_register(struct subsystem *);
+extern void subsystem_unregister(struct subsystem *);
 
-static inline struct kset *subsys_get(struct kset *s)
+static inline struct subsystem * subsys_get(struct subsystem * s)
 {
-	if (s)
-		return kset_get(s);
-	return NULL;
+	return s ? container_of(kset_get(&s->kset),struct subsystem,kset) : NULL;
 }
 
-static inline void subsys_put(struct kset *s)
+static inline void subsys_put(struct subsystem * s)
 {
-	kset_put(s);
+	kset_put(&s->kset);
 }
 
 struct subsys_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct kset *, char *);
-	ssize_t (*store)(struct kset *, const char *, size_t);
+	ssize_t (*show)(struct subsystem *, char *);
+	ssize_t (*store)(struct subsystem *, const char *, size_t); 
 };
 
-extern int __must_check subsys_create_file(struct kset *,
+extern int __must_check subsys_create_file(struct subsystem * ,
 					struct subsys_attribute *);
 
 #if defined(CONFIG_HOTPLUG)
diff -puN include/linux/module.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed include/linux/module.h
--- a/include/linux/module.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/include/linux/module.h
@@ -568,7 +568,7 @@ struct device_driver;
 #ifdef CONFIG_SYSFS
 struct module;
 
-extern struct kset module_subsys;
+extern struct subsystem module_subsys;
 
 int mod_sysfs_init(struct module *mod);
 int mod_sysfs_setup(struct module *mod,
diff -puN include/linux/pci_hotplug.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed include/linux/pci_hotplug.h
--- a/include/linux/pci_hotplug.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/include/linux/pci_hotplug.h
@@ -174,7 +174,7 @@ extern int pci_hp_register		(struct hotp
 extern int pci_hp_deregister		(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);
-extern struct kset pci_hotplug_slots_subsys;
+extern struct subsystem pci_hotplug_slots_subsys;
 
 /* PCI Setting Record (Type 0) */
 struct hpp_type0 {
diff -puN kernel/ksysfs.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed kernel/ksysfs.c
--- a/kernel/ksysfs.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/kernel/ksysfs.c
@@ -24,18 +24,18 @@ static struct subsys_attribute _name##_a
 
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
 /* current uevent sequence number */
-static ssize_t uevent_seqnum_show(struct kset *kset, char *page)
+static ssize_t uevent_seqnum_show(struct subsystem *subsys, char *page)
 {
 	return sprintf(page, "%llu\n", (unsigned long long)uevent_seqnum);
 }
 KERNEL_ATTR_RO(uevent_seqnum);
 
 /* uevent helper program, used during early boo */
-static ssize_t uevent_helper_show(struct kset *kset, char *page)
+static ssize_t uevent_helper_show(struct subsystem *subsys, char *page)
 {
 	return sprintf(page, "%s\n", uevent_helper);
 }
-static ssize_t uevent_helper_store(struct kset *kset, const char *page, size_t count)
+static ssize_t uevent_helper_store(struct subsystem *subsys, const char *page, size_t count)
 {
 	if (count+1 > UEVENT_HELPER_PATH_LEN)
 		return -ENOENT;
@@ -49,13 +49,13 @@ KERNEL_ATTR_RW(uevent_helper);
 #endif
 
 #ifdef CONFIG_KEXEC
-static ssize_t kexec_loaded_show(struct kset *kset, char *page)
+static ssize_t kexec_loaded_show(struct subsystem *subsys, char *page)
 {
 	return sprintf(page, "%d\n", !!kexec_image);
 }
 KERNEL_ATTR_RO(kexec_loaded);
 
-static ssize_t kexec_crash_loaded_show(struct kset *kset, char *page)
+static ssize_t kexec_crash_loaded_show(struct subsystem *subsys, char *page)
 {
 	return sprintf(page, "%d\n", !!kexec_crash_image);
 }
@@ -85,7 +85,7 @@ static int __init ksysfs_init(void)
 {
 	int error = subsystem_register(&kernel_subsys);
 	if (!error)
-		error = sysfs_create_group(&kernel_subsys.kobj,
+		error = sysfs_create_group(&kernel_subsys.kset.kobj,
 					   &kernel_attr_group);
 
 	return error;
diff -puN kernel/module.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed kernel/module.c
--- a/kernel/module.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/kernel/module.c
@@ -45,8 +45,6 @@
 #include <asm/cacheflush.h>
 #include <linux/license.h>
 
-extern int module_sysfs_initialized;
-
 #if 0
 #define DEBUGP printk
 #else
@@ -1116,8 +1114,8 @@ int mod_sysfs_init(struct module *mod)
 {
 	int err;
 
-	if (!module_sysfs_initialized) {
-		printk(KERN_ERR "%s: module sysfs not initialized\n",
+	if (!module_subsys.kset.subsys) {
+		printk(KERN_ERR "%s: module_subsys not initialized\n",
 		       mod->name);
 		err = -EINVAL;
 		goto out;
@@ -2382,7 +2380,7 @@ void module_add_driver(struct module *mo
 		struct kobject *mkobj;
 
 		/* Lookup built-in module entry in /sys/modules */
-		mkobj = kset_find_obj(&module_subsys, drv->mod_name);
+		mkobj = kset_find_obj(&module_subsys.kset, drv->mod_name);
 		if (mkobj) {
 			mk = container_of(mkobj, struct module_kobject, kobj);
 			/* remember our module structure */
diff -puN kernel/params.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed kernel/params.c
--- a/kernel/params.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/kernel/params.c
@@ -690,7 +690,6 @@ static struct kset_uevent_ops module_uev
 };
 
 decl_subsys(module, &module_ktype, &module_uevent_ops);
-int module_sysfs_initialized;
 
 static struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
@@ -709,7 +708,6 @@ static int __init param_sysfs_init(void)
 			__FILE__, __LINE__, ret);
 		return ret;
 	}
-	module_sysfs_initialized = 1;
 
 	param_sysfs_builtin();
 
diff -puN kernel/power/disk.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed kernel/power/disk.c
--- a/kernel/power/disk.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/kernel/power/disk.c
@@ -313,13 +313,13 @@ static const char * const pm_disk_modes[
  *	supports it (as determined from pm_ops->pm_disk_mode).
  */
 
-static ssize_t disk_show(struct kset *kset, char *buf)
+static ssize_t disk_show(struct subsystem * subsys, char * buf)
 {
 	return sprintf(buf, "%s\n", pm_disk_modes[pm_disk_mode]);
 }
 
 
-static ssize_t disk_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t disk_store(struct subsystem * s, const char * buf, size_t n)
 {
 	int error = 0;
 	int i;
@@ -360,13 +360,13 @@ static ssize_t disk_store(struct kset *k
 
 power_attr(disk);
 
-static ssize_t resume_show(struct kset *kset, char *buf)
+static ssize_t resume_show(struct subsystem * subsys, char *buf)
 {
 	return sprintf(buf,"%d:%d\n", MAJOR(swsusp_resume_device),
 		       MINOR(swsusp_resume_device));
 }
 
-static ssize_t resume_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t resume_store(struct subsystem *subsys, const char *buf, size_t n)
 {
 	unsigned int maj, min;
 	dev_t res;
@@ -392,12 +392,12 @@ static ssize_t resume_store(struct kset 
 
 power_attr(resume);
 
-static ssize_t image_size_show(struct kset *kset, char *buf)
+static ssize_t image_size_show(struct subsystem * subsys, char *buf)
 {
 	return sprintf(buf, "%lu\n", image_size);
 }
 
-static ssize_t image_size_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t image_size_store(struct subsystem * subsys, const char * buf, size_t n)
 {
 	unsigned long size;
 
@@ -426,7 +426,7 @@ static struct attribute_group attr_group
 
 static int __init pm_disk_init(void)
 {
-	return sysfs_create_group(&power_subsys.kobj, &attr_group);
+	return sysfs_create_group(&power_subsys.kset.kobj,&attr_group);
 }
 
 core_initcall(pm_disk_init);
diff -puN kernel/power/main.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed kernel/power/main.c
--- a/kernel/power/main.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/kernel/power/main.c
@@ -256,7 +256,7 @@ decl_subsys(power,NULL,NULL);
  *	proper enumerated value, and initiates a suspend transition.
  */
 
-static ssize_t state_show(struct kset *kset, char *buf)
+static ssize_t state_show(struct subsystem * subsys, char * buf)
 {
 	int i;
 	char * s = buf;
@@ -269,7 +269,7 @@ static ssize_t state_show(struct kset *k
 	return (s - buf);
 }
 
-static ssize_t state_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t state_store(struct subsystem * subsys, const char * buf, size_t n)
 {
 	suspend_state_t state = PM_SUSPEND_STANDBY;
 	const char * const *s;
@@ -296,13 +296,13 @@ power_attr(state);
 #ifdef CONFIG_PM_TRACE
 int pm_trace_enabled;
 
-static ssize_t pm_trace_show(struct kset *kset, char *buf)
+static ssize_t pm_trace_show(struct subsystem * subsys, char * buf)
 {
 	return sprintf(buf, "%d\n", pm_trace_enabled);
 }
 
 static ssize_t
-pm_trace_store(struct kset *kset, const char *buf, size_t n)
+pm_trace_store(struct subsystem * subsys, const char * buf, size_t n)
 {
 	int val;
 
@@ -336,7 +336,7 @@ static int __init pm_init(void)
 {
 	int error = subsystem_register(&power_subsys);
 	if (!error)
-		error = sysfs_create_group(&power_subsys.kobj,&attr_group);
+		error = sysfs_create_group(&power_subsys.kset.kobj,&attr_group);
 	return error;
 }
 
diff -puN kernel/power/power.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed kernel/power/power.h
--- a/kernel/power/power.h~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/kernel/power/power.h
@@ -35,7 +35,7 @@ static struct subsys_attribute _name##_a
 	.store	= _name##_store,		\
 }
 
-extern struct kset power_subsys;
+extern struct subsystem power_subsys;
 
 /* References to section boundaries */
 extern const void __nosave_begin, __nosave_end;
diff -puN lib/kobject.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed lib/kobject.c
--- a/lib/kobject.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/lib/kobject.c
@@ -632,10 +632,22 @@ void kset_init(struct kset * k)
 /**
  *	kset_add - add a kset object to the hierarchy.
  *	@k:	kset.
+ *
+ *	Simply, this adds the kset's embedded kobject to the 
+ *	hierarchy. 
+ *	We also try to make sure that the kset's embedded kobject
+ *	has a parent before it is added. We only care if the embedded
+ *	kobject is not part of a kset itself, since kobject_add()
+ *	assigns a parent in that case. 
+ *	If that is the case, and the kset has a controlling subsystem,
+ *	then we set the kset's parent to be said subsystem. 
  */
 
 int kset_add(struct kset * k)
 {
+	if (!k->kobj.parent && !k->kobj.kset && k->subsys)
+		k->kobj.parent = &k->subsys->kset.kobj;
+
 	return kobject_add(&k->kobj);
 }
 
@@ -694,28 +706,53 @@ struct kobject * kset_find_obj(struct ks
 	return ret;
 }
 
-void subsystem_init(struct kset *s)
+
+void subsystem_init(struct subsystem * s)
 {
-	kset_init(s);
+	kset_init(&s->kset);
 }
 
-int subsystem_register(struct kset *s)
+/**
+ *	subsystem_register - register a subsystem.
+ *	@s:	the subsystem we're registering.
+ *
+ *	Once we register the subsystem, we want to make sure that 
+ *	the kset points back to this subsystem.
+ */
+
+int subsystem_register(struct subsystem * s)
 {
-	return kset_register(s);
+	int error;
+
+	if (!s)
+		return -EINVAL;
+
+	subsystem_init(s);
+	pr_debug("subsystem %s: registering\n",s->kset.kobj.name);
+
+	if (!(error = kset_add(&s->kset))) {
+		if (!s->kset.subsys)
+			s->kset.subsys = s;
+	}
+	return error;
 }
 
-void subsystem_unregister(struct kset *s)
+void subsystem_unregister(struct subsystem * s)
 {
-	kset_unregister(s);
+	if (!s)
+		return;
+	pr_debug("subsystem %s: unregistering\n",s->kset.kobj.name);
+	kset_unregister(&s->kset);
 }
 
+
 /**
  *	subsystem_create_file - export sysfs attribute file.
  *	@s:	subsystem.
  *	@a:	subsystem attribute descriptor.
  */
 
-int subsys_create_file(struct kset *s, struct subsys_attribute *a)
+int subsys_create_file(struct subsystem * s, struct subsys_attribute * a)
 {
 	int error = 0;
 
@@ -723,7 +760,7 @@ int subsys_create_file(struct kset *s, s
 		return -EINVAL;
 
 	if (subsys_get(s)) {
-		error = sysfs_create_file(&s->kobj, &a->attr);
+		error = sysfs_create_file(&s->kset.kobj,&a->attr);
 		subsys_put(s);
 	}
 	return error;
diff -puN security/inode.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed security/inode.c
--- a/security/inode.c~revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed
+++ a/security/inode.c
@@ -321,7 +321,7 @@ static int __init securityfs_init(void)
 {
 	int retval;
 
-	kobj_set_kset_s(&security_subsys, kernel_subsys);
+	kset_set_kset_s(&security_subsys, kernel_subsys);
 	retval = subsystem_register(&security_subsys);
 	if (retval)
 		return retval;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
device_schedule_callback-needs-a-module-reference-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-input-fixup.patch
git-kvm.patch
git-libata-all.patch
libata-acpi-add-infrastructure-for-drivers-to-use-fix.patch
pata_acpi-restore-driver-fix.patch
pata_acpi-restore-driver-fix-2.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd.patch
git-ubi.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
reapply-gitpowerpc-ehea-changes.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-3.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390.patch
git-s390-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
scsi-fix-config_scsi_wait_scan=m-fix-fix.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-git-net.patch
git-wireless-vs-git-net-2.patch
git-wireless-vs-git-net-3.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
x86_64-inhibit-machine-from-asserting-an-nmi-when-doing-alt-sysrq-m-operation-tidy.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
xfs-clean-up-shrinker-games.patch
acpi-thermal-fix-mod_timer-interval.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
slab-mark-set_up_list3s-__init.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-more-statics.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls-x86_64-fix.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
undo-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
