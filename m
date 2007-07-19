From: akpm@linux-foundation.org
Subject: - driver-core-check-return-code-of-sysfs_create_link.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:46 -0700
Message-ID: <200707192007.l6JK7kIk020369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760855AbXGSUPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Driver core: check return code of sysfs_create_link()
has been removed from the -mm tree.  Its filename was
     driver-core-check-return-code-of-sysfs_create_link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Driver core: check return code of sysfs_create_link()
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Check for return value of sysfs_create_link() in device_add() and
device_rename().  Add helper functions device_add_class_symlinks() and
device_remove_class_symlinks() to make the code easier to read.

[akpm@linux-foundation.org: fix unused var warnings]
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |  145 ++++++++++++++++++++++++++++++------------
 1 file changed, 105 insertions(+), 40 deletions(-)

diff -puN drivers/base/core.c~driver-core-check-return-code-of-sysfs_create_link drivers/base/core.c
--- a/drivers/base/core.c~driver-core-check-return-code-of-sysfs_create_link
+++ a/drivers/base/core.c
@@ -643,6 +643,82 @@ static int setup_parent(struct device *d
 	return 0;
 }
 
+static int device_add_class_symlinks(struct device *dev)
+{
+	int error;
+
+	if (!dev->class)
+		return 0;
+	error = sysfs_create_link(&dev->kobj, &dev->class->subsys.kobj,
+				  "subsystem");
+	if (error)
+		goto out;
+	/*
+	 * If this is not a "fake" compatible device, then create the
+	 * symlink from the class to the device.
+	 */
+	if (dev->kobj.parent != &dev->class->subsys.kobj) {
+		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+					  dev->bus_id);
+		if (error)
+			goto out_subsys;
+	}
+	/* only bus-device parents get a "device"-link */
+	if (dev->parent && dev->parent->bus) {
+		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+					  "device");
+		if (error)
+			goto out_busid;
+#ifdef CONFIG_SYSFS_DEPRECATED
+		{
+			char * class_name = make_class_name(dev->class->name,
+								&dev->kobj);
+			if (class_name)
+				error = sysfs_create_link(&dev->parent->kobj,
+							&dev->kobj, class_name);
+			kfree(class_name);
+			if (error)
+				goto out_device;
+		}
+#endif
+	}
+	return 0;
+
+#ifdef CONFIG_SYSFS_DEPRECATED
+out_device:
+	if (dev->parent)
+		sysfs_remove_link(&dev->kobj, "device");
+#endif
+out_busid:
+	if (dev->kobj.parent != &dev->class->subsys.kobj)
+		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+out_subsys:
+	sysfs_remove_link(&dev->kobj, "subsystem");
+out:
+	return error;
+}
+
+static void device_remove_class_symlinks(struct device *dev)
+{
+	if (!dev->class)
+		return;
+	if (dev->parent) {
+#ifdef CONFIG_SYSFS_DEPRECATED
+		char *class_name;
+
+		class_name = make_class_name(dev->class->name, &dev->kobj);
+		if (class_name) {
+			sysfs_remove_link(&dev->parent->kobj, class_name);
+			kfree(class_name);
+		}
+#endif
+		sysfs_remove_link(&dev->kobj, "device");
+	}
+	if (dev->kobj.parent != &dev->class->subsys.kobj)
+		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	sysfs_remove_link(&dev->kobj, "subsystem");
+}
+
 /**
  *	device_add - add device to device hierarchy.
  *	@dev:	device.
@@ -657,7 +733,6 @@ static int setup_parent(struct device *d
 int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
-	char *class_name = NULL;
 	struct class_interface *class_intf;
 	int error = -EINVAL;
 
@@ -697,27 +772,9 @@ int device_add(struct device *dev)
 			goto ueventattrError;
 	}
 
-	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kobj,
-				  "subsystem");
-		/* If this is not a "fake" compatible device, then create the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kobj)
-			sysfs_create_link(&dev->class->subsys.kobj,
-					  &dev->kobj, dev->bus_id);
-		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
-#ifdef CONFIG_SYSFS_DEPRECATED
-			class_name = make_class_name(dev->class->name,
-							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
-#endif
-		}
-	}
-
+	error = device_add_class_symlinks(dev);
+	if (error)
+		goto SymlinkError;
 	error = device_add_attrs(dev);
 	if (error)
 		goto AttrsError;
@@ -744,7 +801,6 @@ int device_add(struct device *dev)
 		up(&dev->class->sem);
 	}
  Done:
-	kfree(class_name);
 	put_device(dev);
 	return error;
  BusError:
@@ -755,6 +811,8 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_attrs(dev);
  AttrsError:
+	device_remove_class_symlinks(dev);
+ SymlinkError:
 	if (MAJOR(dev->devt))
 		device_remove_file(dev, &devt_attr);
 
@@ -1140,7 +1198,7 @@ int device_rename(struct device *dev, ch
 {
 	char *old_class_name = NULL;
 	char *new_class_name = NULL;
-	char *old_symlink_name = NULL;
+	char *old_device_name = NULL;
 	int error;
 
 	dev = get_device(dev);
@@ -1154,42 +1212,49 @@ int device_rename(struct device *dev, ch
 		old_class_name = make_class_name(dev->class->name, &dev->kobj);
 #endif
 
-	if (dev->class) {
-		old_symlink_name = kmalloc(BUS_ID_SIZE, GFP_KERNEL);
-		if (!old_symlink_name) {
-			error = -ENOMEM;
-			goto out_free_old_class;
-		}
-		strlcpy(old_symlink_name, dev->bus_id, BUS_ID_SIZE);
+	old_device_name = kmalloc(BUS_ID_SIZE, GFP_KERNEL);
+	if (!old_device_name) {
+		error = -ENOMEM;
+		goto out;
 	}
-
+	strlcpy(old_device_name, dev->bus_id, BUS_ID_SIZE);
 	strlcpy(dev->bus_id, new_name, BUS_ID_SIZE);
 
 	error = kobject_rename(&dev->kobj, new_name);
+	if (error) {
+		strlcpy(dev->bus_id, old_device_name, BUS_ID_SIZE);
+		goto out;
+	}
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 	if (old_class_name) {
 		new_class_name = make_class_name(dev->class->name, &dev->kobj);
 		if (new_class_name) {
-			sysfs_create_link(&dev->parent->kobj, &dev->kobj,
-					  new_class_name);
+			error = sysfs_create_link(&dev->parent->kobj,
+						  &dev->kobj, new_class_name);
+			if (error)
+				goto out;
 			sysfs_remove_link(&dev->parent->kobj, old_class_name);
 		}
 	}
 #endif
 
 	if (dev->class) {
-		sysfs_remove_link(&dev->class->subsys.kobj,
-				  old_symlink_name);
-		sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
-				  dev->bus_id);
+		sysfs_remove_link(&dev->class->subsys.kobj, old_device_name);
+		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+					  dev->bus_id);
+		if (error) {
+			/* Uh... how to unravel this if restoring can fail? */
+			dev_err(dev, "%s: sysfs_create_symlink failed (%d)\n",
+				__FUNCTION__, error);
+		}
 	}
+out:
 	put_device(dev);
 
 	kfree(new_class_name);
-	kfree(old_symlink_name);
- out_free_old_class:
 	kfree(old_class_name);
+	kfree(old_device_name);
 
 	return error;
 }
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
