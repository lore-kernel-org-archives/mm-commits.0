From: akpm@linux-foundation.org
Subject: - driver-core-cleanup-device-links-code.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:08:50 -0800
Message-ID: <200703070408.l2748pFi018607@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46626 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161263AbXCGEJH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:09:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     driver core: cleanup device links code
has been removed from the -mm tree.  Its filename was
     driver-core-cleanup-device-links-code.patch

This patch was dropped because changes in Greg's tree killed it

------------------------------------------------------
Subject: driver core: cleanup device links code
From: "Akinobu Mita" <akinobu.mita@gmail.com>

Cleanup by introducing device_add_links() and device_remove_links().

This patch should not change any current behavior except the scope of
class_name moved to the inside of device_add_links().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   92 +++++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 40 deletions(-)

diff -puN drivers/base/core.c~driver-core-cleanup-device-links-code drivers/base/core.c
--- a/drivers/base/core.c~driver-core-cleanup-device-links-code
+++ a/drivers/base/core.c
@@ -501,6 +501,56 @@ static int setup_parent(struct device *d
 	return 0;
 }
 
+static void device_add_links(struct device *dev, struct device *parent)
+{
+	if (dev->class) {
+		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
+				  "subsystem");
+		/* If this is not a "fake" compatible device, then create the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_create_link(&dev->class->subsys.kset.kobj,
+					  &dev->kobj, dev->bus_id);
+#ifdef CONFIG_SYSFS_DEPRECATED
+		if (parent) {
+			char *class_name = NULL;
+
+			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+							"device");
+			class_name = make_class_name(dev->class->name,
+							&dev->kobj);
+			if (class_name)
+				sysfs_create_link(&dev->parent->kobj,
+						  &dev->kobj, class_name);
+			kfree(class_name);
+		}
+#endif
+	}
+}
+
+static void device_remove_links(struct device *dev, struct device *parent)
+{
+	if (dev->class) {
+		sysfs_remove_link(&dev->kobj, "subsystem");
+		/* If this is not a "fake" compatible device, remove the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
+					  dev->bus_id);
+#ifdef CONFIG_SYSFS_DEPRECATED
+		if (parent) {
+			char *class_name = make_class_name(dev->class->name,
+							   &dev->kobj);
+			if (class_name)
+				sysfs_remove_link(&dev->parent->kobj,
+						  class_name);
+			kfree(class_name);
+			sysfs_remove_link(&dev->kobj, "device");
+		}
+#endif
+	}
+}
+
 /**
  *	device_add - add device to device hierarchy.
  *	@dev:	device.
@@ -515,7 +565,6 @@ static int setup_parent(struct device *d
 int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
-	char *class_name = NULL;
 	struct class_interface *class_intf;
 	int error = -EINVAL;
 
@@ -576,26 +625,7 @@ int device_add(struct device *dev)
 		dev->devt_attr = attr;
 	}
 
-	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
-				  "subsystem");
-		/* If this is not a "fake" compatible device, then create the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_create_link(&dev->class->subsys.kset.kobj,
-					  &dev->kobj, dev->bus_id);
-#ifdef CONFIG_SYSFS_DEPRECATED
-		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
-			class_name = make_class_name(dev->class->name,
-							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
-		}
-#endif
-	}
+	device_add_links(dev, parent);
 
 	if ((error = device_add_attrs(dev)))
 		goto AttrsError;
@@ -623,7 +653,6 @@ int device_add(struct device *dev)
 		up(&dev->class->sem);
 	}
  Done:
- 	kfree(class_name);
 	put_device(dev);
 	return error;
  BusError:
@@ -752,25 +781,8 @@ void device_del(struct device * dev)
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
 	}
+	device_remove_links(dev, parent);
 	if (dev->class) {
-		sysfs_remove_link(&dev->kobj, "subsystem");
-		/* If this is not a "fake" compatible device, remove the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_remove_link(&dev->class->subsys.kset.kobj,
-					  dev->bus_id);
-#ifdef CONFIG_SYSFS_DEPRECATED
-		if (parent) {
-			char *class_name = make_class_name(dev->class->name,
-							   &dev->kobj);
-			if (class_name)
-				sysfs_remove_link(&dev->parent->kobj,
-						  class_name);
-			kfree(class_name);
-			sysfs_remove_link(&dev->kobj, "device");
-		}
-#endif
-
 		down(&dev->class->sem);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

driver-core-cleanup-device-links-code.patch
driver-core-add-missing-symlinks-error-handling.patch
driver-core-check-sysfs_create_link-errors.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-ocfs2.patch
git-qla3xxx.patch
simplify-the-stacktrace-code.patch
