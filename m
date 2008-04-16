From: akpm@linux-foundation.org
Subject: - sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:38 -0700
Message-ID: <200804162255.m3GMtcO8011140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757745AbYDPXBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 19:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, gregkh@suse.de, hpa@zytor.com, htejun@gmail.com, kay.sievers@vrfy.org, lkml@rtr.ca, neilb@suse.de, steve@xemacs.org, mm-commits@vger.kernel.org


The patch titled
     sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
has been removed from the -mm tree.  Its filename was
     sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
From: Dan Williams <dan.j.williams@intel.com>

Why?:

There are occasions where userspace would like to access sysfs attributes for
a device but it may not know how sysfs has named the device or the path.  For
example what is the sysfs path for /dev/disk/by-id/ata-ST3160827AS_5MT004CK? 
With this change a call to stat(2) returns the major:minor then userspace can
see that /sys/dev/block/8:32 links to /sys/block/sdc.

What are the alternatives?:

1/ Add an ioctl to return the path: Doable, but sysfs is meant to reduce
   the need to proliferate ioctl interfaces into the kernel, so this
   seems counter productive.

2/ Use udev to create these symlinks: Also doable, but it adds a
   udev dependency to utilities that might be running in a limited
   environment like an initramfs.

3/ Do a full-tree search of sysfs.

Cc: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>
Acked-by: Mark Lord <lkml@rtr.ca>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: SL Baur <steve@xemacs.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff -puN drivers/base/core.c~sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor drivers/base/core.c
--- a/drivers/base/core.c~sysfs-add-sys-dev-charblock-to-lookup-sysfs-path-by-major-minor
+++ a/drivers/base/core.c
@@ -27,6 +27,9 @@
 
 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
+static struct kobject *dev_kobj;
+static struct kobject *char_kobj;
+static struct kobject *block_kobj;
 
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
@@ -760,6 +763,11 @@ static void device_remove_class_symlinks
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }
 
+static struct kobject *device_to_dev_kobj(struct device *dev)
+{
+	return dev->class == &block_class ? block_kobj : char_kobj;
+}
+
 /**
  * device_add - add device to device hierarchy.
  * @dev: device.
@@ -776,6 +784,7 @@ int device_add(struct device *dev)
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
 	int error;
+	char devt_str[25];
 
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
@@ -807,9 +816,16 @@ int device_add(struct device *dev)
 		goto attrError;
 
 	if (MAJOR(dev->devt)) {
+		struct kobject *kobj = device_to_dev_kobj(dev);
+
 		error = device_create_file(dev, &devt_attr);
 		if (error)
 			goto ueventattrError;
+
+		format_dev_t(devt_str, dev->devt);
+		error = sysfs_create_link(kobj, &dev->kobj, devt_str);
+		if (error)
+			goto devtattrError;
 	}
 
 	error = device_add_class_symlinks(dev);
@@ -854,6 +870,9 @@ int device_add(struct device *dev)
 	device_remove_class_symlinks(dev);
  SymlinkError:
 	if (MAJOR(dev->devt))
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
+ devtattrError:
+	if (MAJOR(dev->devt))
 		device_remove_file(dev, &devt_attr);
  ueventattrError:
 	device_remove_file(dev, &uevent_attr);
@@ -925,12 +944,16 @@ void device_del(struct device *dev)
 {
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
+	char devt_str[25];
 
 	device_pm_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (MAJOR(dev->devt))
+	if (MAJOR(dev->devt)) {
+		format_dev_t(devt_str, dev->devt);
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
 		device_remove_file(dev, &devt_attr);
+	}
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
@@ -1055,6 +1078,15 @@ int __init devices_init(void)
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
 	if (!devices_kset)
 		return -ENOMEM;
+	dev_kobj = kobject_create_and_add("dev", NULL);
+	if (!dev_kobj)
+		return -ENOMEM;
+	block_kobj = kobject_create_and_add("block", dev_kobj);
+	if (!block_kobj)
+		return -ENOMEM;
+	char_kobj = kobject_create_and_add("char", dev_kobj);
+	if (!char_kobj)
+		return -ENOMEM;
 	return 0;
 }
 
@@ -1351,4 +1383,7 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+	kobject_put(char_kobj);
+	kobject_put(block_kobj);
+	kobject_put(dev_kobj);
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-arm.patch
git-async-tx.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch
md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

