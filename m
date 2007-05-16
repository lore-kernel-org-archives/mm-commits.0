From: akpm@linux-foundation.org
Subject: + driver-core-check-return-code-of-sysfs_create_link.patch added to -mm tree
Date: Wed, 16 May 2007 01:33:12 -0700
Message-ID: <200705160833.l4G8XBTm029802@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762542AbXEPIf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 04:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     Driver core: check return code of sysfs_create_link()
has been added to the -mm tree.  Its filename is
     driver-core-check-return-code-of-sysfs_create_link.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Driver core: check return code of sysfs_create_link()
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Check for return value of sysfs_create_link() in device_add() and
device_rename().  Add helper functions device_add_class_symlinks() and
device_remove_class_symlinks() to make the code easier to read.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |  140 +++++++++++++++++++++++++++++-------------
 1 file changed, 99 insertions(+), 41 deletions(-)

diff -puN drivers/base/core.c~driver-core-check-return-code-of-sysfs_create_link drivers/base/core.c
--- a/drivers/base/core.c~driver-core-check-return-code-of-sysfs_create_link
+++ a/drivers/base/core.c
@@ -641,6 +641,77 @@ static int setup_parent(struct device *d
 	return 0;
 }
 
+static int device_add_class_symlinks(struct device *dev)
+{
+	int error;
+	char *class_name;
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
+	if (dev->kobj.parent == &dev->class->subsys.kobj)
+		return 0;
+	error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
+				  dev->bus_id);
+	if (error)
+		goto out_subsys;
+	if (dev->parent) {
+		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+					  "device");
+		if (error)
+			goto out_busid;
+#ifdef CONFIG_SYSFS_DEPRECATED
+		class_name = make_class_name(dev->class->name, &dev->kobj);
+		if (class_name)
+			error = sysfs_create_link(&dev->parent->kobj,
+						  &dev->kobj, class_name);
+		kfree(class_name);
+		if (error)
+			goto out_device;
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
+	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+out_subsys:
+	sysfs_remove_link(&dev->kobj, "subsystem");
+out:
+	return error;
+}
+
+static void device_remove_class_symlinks(struct device *dev)
+{
+	char *class_name;
+
+	if (!dev->class)
+		return;
+	if (dev->parent) {
+#ifdef CONFIG_SYSFS_DEPRECATED
+		class_name = make_class_name(dev->class->name, &dev->kobj);
+		if (class_name) {
+			sysfs_remove_link(&dev->parent->kobj, class_name);
+			kfree(class_name);
+		}
+#endif
+		sysfs_remove_link(&dev->kobj, "device");
+	}
+	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
+	sysfs_remove_link(&dev->kobj, "subsystem");
+}
+
 /**
  *	device_add - add device to device hierarchy.
  *	@dev:	device.
@@ -655,7 +726,6 @@ static int setup_parent(struct device *d
 int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
-	char *class_name = NULL;
 	struct class_interface *class_intf;
 	int error = -EINVAL;
 
@@ -694,28 +764,8 @@ int device_add(struct device *dev)
 		if (error)
 			goto ueventattrError;
 	}
-
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
+	if ((error = device_add_class_symlinks(dev)))
+		goto SymlinkError;
 	if ((error = device_add_attrs(dev)))
 		goto AttrsError;
 	if ((error = device_pm_add(dev)))
@@ -739,7 +789,6 @@ int device_add(struct device *dev)
 		up(&dev->class->sem);
 	}
  Done:
-	kfree(class_name);
 	put_device(dev);
 	return error;
  BusError:
@@ -750,6 +799,8 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_attrs(dev);
  AttrsError:
+	device_remove_class_symlinks(dev);
+ SymlinkError:
 	if (MAJOR(dev->devt))
 		device_remove_file(dev, &devt_attr);
 
@@ -1135,7 +1186,7 @@ int device_rename(struct device *dev, ch
 {
 	char *old_class_name = NULL;
 	char *new_class_name = NULL;
-	char *old_symlink_name = NULL;
+	char *old_device_name = NULL;
 	int error;
 
 	dev = get_device(dev);
@@ -1149,42 +1200,49 @@ int device_rename(struct device *dev, ch
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

driver-core-check-return-code-of-sysfs_create_link.patch
git-s390.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
