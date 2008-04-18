From: akpm@linux-foundation.org
Subject: - sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y.patch removed from -mm tree
Date: Thu, 17 Apr 2008 20:23:21 -0700
Message-ID: <200804180323.m3I3NLZI008810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327AbYDRDXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 23:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     sysfs: add /sys/dev/usb to handle CONFIG_USB_DEVICE_CLASS=y
has been removed from the -mm tree.  Its filename was
     sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y.patch

This patch was dropped because head is spinning

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: add /sys/dev/usb to handle CONFIG_USB_DEVICE_CLASS=y
From: Dan Williams <dan.j.williams@intel.com>

The deprecated config option CONFIG_USB_DEVICE_CLASS causes class devices with
duplicate major:minor numbers to be registered.  In effect they represent a
usb specific address space for major:minor numbers so add 'usb' as a directory
along side 'block' and 'char'.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c      |   25 +++++++++++++++++++++++--
 drivers/usb/core/devio.c |    2 +-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff -puN drivers/base/core.c~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y drivers/base/core.c
--- a/drivers/base/core.c~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y
+++ a/drivers/base/core.c
@@ -30,6 +30,10 @@ int (*platform_notify_remove)(struct dev
 static struct kobject *dev_kobj;
 static struct kobject *char_kobj;
 static struct kobject *block_kobj;
+#ifdef CONFIG_USB_DEVICE_CLASS
+extern struct class *usb_classdev_class;
+static struct kobject *usb_kobj;
+#endif
 
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
@@ -765,7 +769,13 @@ static void device_remove_class_symlinks
 
 static struct kobject *device_to_dev_kobj(struct device *dev)
 {
-	return dev->class == &block_class ? block_kobj : char_kobj;
+	if (dev->class == &block_class)
+		return block_kobj;
+#ifdef CONFIG_USB_DEVICE_CLASS
+	if (usb_classdev_class && dev->class == usb_classdev_class)
+		return usb_kobj;
+#endif
+	return char_kobj;
 }
 
 /**
@@ -1087,9 +1097,17 @@ int __init devices_init(void)
 	char_kobj = kobject_create_and_add("char", dev_kobj);
 	if (!char_kobj)
 		goto char_kobj_err;
-
+#ifdef CONFIG_USB_DEVICE_CLASS
+	usb_kobj = kobject_create_and_add("usb", dev_kobj);
+	if (!usb_kobj)
+		goto usb_kobj_err;
+#endif
 	return 0;
 
+#ifdef CONFIG_USB_DEVICE_CLASS
+ usb_kobj_err:
+	kobject_put(char_kobj);
+#endif
  char_kobj_err:
 	kobject_put(block_kobj);
  block_kobj_err:
@@ -1392,6 +1410,9 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+#ifdef CONFIG_USB_DEVICE_CLASS
+	kobject_put(usb_kobj);
+#endif
 	kobject_put(char_kobj);
 	kobject_put(block_kobj);
 	kobject_put(dev_kobj);
diff -puN drivers/usb/core/devio.c~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y drivers/usb/core/devio.c
--- a/drivers/usb/core/devio.c~sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y
+++ a/drivers/usb/core/devio.c
@@ -1660,7 +1660,7 @@ const struct file_operations usbdev_file
 };
 
 #ifdef CONFIG_USB_DEVICE_CLASS
-static struct class *usb_classdev_class;
+struct class *usb_classdev_class;
 
 static int usb_classdev_add(struct usb_device *dev)
 {
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-arm.patch
sysfs-add-sys-dev-usb-to-handle-config_usb_device_class=y.patch
git-async-tx.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch
md-raid5c-convert-simple_strtoul-to-strict_strtoul.patch

