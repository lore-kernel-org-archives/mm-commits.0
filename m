From: akpm@linux-foundation.org
Subject: - driver-core-check-sysfs_create_link-errors.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:09:42 -0800
Message-ID: <200703070409.l2749guW018620@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46638 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161260AbXCGEJx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:09:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     driver core: check sysfs_create_link() errors
has been removed from the -mm tree.  Its filename was
     driver-core-check-sysfs_create_link-errors.patch

This patch was dropped because changes in Greg's tree killed it

------------------------------------------------------
Subject: driver core: check sysfs_create_link() errors
From: "Akinobu Mita" <akinobu.mita@gmail.com>

This patch kills __must_check warnings for missing sysfs_create_link().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   59 ++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 14 deletions(-)

diff -puN drivers/base/core.c~driver-core-check-sysfs_create_link-errors drivers/base/core.c
--- a/drivers/base/core.c~driver-core-check-sysfs_create_link-errors
+++ a/drivers/base/core.c
@@ -501,31 +501,61 @@ static int setup_parent(struct device *d
 	return 0;
 }
 
-static void device_add_links(struct device *dev, struct device *parent)
+static int device_add_links(struct device *dev, struct device *parent)
 {
+	int err;
+
 	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
-				  "subsystem");
+		err = sysfs_create_link(&dev->kobj,
+					&dev->class->subsys.kset.kobj,
+					"subsystem");
+		if (err)
+			return err;
+
 		/* If this is not a "fake" compatible device, then create the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_create_link(&dev->class->subsys.kset.kobj,
-					  &dev->kobj, dev->bus_id);
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj) {
+			err = sysfs_create_link(&dev->class->subsys.kset.kobj,
+						&dev->kobj, dev->bus_id);
+			if (err)
+				goto out1;
+		}
 #ifdef CONFIG_SYSFS_DEPRECATED
 		if (parent) {
 			char *class_name = NULL;
 
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
+			err = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+						"device");
+			if (err)
+				goto out2;
 			class_name = make_class_name(dev->class->name,
 							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
+			if (class_name) {
+				err = sysfs_create_link(&dev->parent->kobj,
+							&dev->kobj, class_name);
+				if (err) {
+					kfree(class_name);
+					goto out3;
+				}
+
+			}
 			kfree(class_name);
 		}
 #endif
 	}
+
+	return 0;
+
+#ifdef CONFIG_SYSFS_DEPRECATED
+out3:
+	sysfs_remove_link(&dev->kobj, "device");
+out2:
+#endif
+	sysfs_remove_link(&dev->class->subsys.kset.kobj, dev->bus_id);
+out1:
+	sysfs_remove_link(&dev->kobj, "subsystem");
+
+	return err;
 }
 
 static void device_remove_links(struct device *dev, struct device *parent)
@@ -625,8 +655,9 @@ int device_add(struct device *dev)
 		dev->devt_attr = attr;
 	}
 
-	device_add_links(dev, parent);
-
+	error = device_add_links(dev, parent);
+	if (error)
+		goto LinksError;
 	if ((error = device_add_attrs(dev)))
 		goto AttrsError;
 	if ((error = device_add_groups(dev)))
@@ -666,7 +697,7 @@ int device_add(struct device *dev)
 	device_remove_attrs(dev);
  AttrsError:
 	device_remove_links(dev, parent);
-
+ LinksError:
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

driver-core-check-sysfs_create_link-errors.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-ocfs2.patch
git-qla3xxx.patch
simplify-the-stacktrace-code.patch
