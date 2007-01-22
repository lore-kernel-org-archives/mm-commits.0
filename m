From: akpm@osdl.org
Subject: - driver-core-allow-device_movedev-null.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:45:47 -0800
Message-ID: <200701222045.l0MKjl8c001496@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50190 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524AbXAVUp7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:45:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver core: allow device_move(dev, NULL)
has been removed from the -mm tree.  Its filename was
     driver-core-allow-device_movedev-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: driver core: allow device_move(dev, NULL)
From: Cornelia Huck <cornelia.huck@de.ibm.com>

If we allow NULL as the new parent in device_move(), we need to make sure that
the device is placed into the same place as it would if it was newly
registered:

- Consider the device virtual tree. In order to be able to reuse code,
  setup_parent() has been tweaked a bit.
- kobject_move() can fall back to the kset's kobject.
- sysfs_move_dir() uses the sysfs root dir as fallback.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/base/core.c |   76 +++++++++++++++++++++++++-----------------
 fs/sysfs/dir.c      |    6 +--
 lib/kobject.c       |    6 +--
 3 files changed, 52 insertions(+), 36 deletions(-)

diff -puN drivers/base/core.c~driver-core-allow-device_movedev-null drivers/base/core.c
--- a/drivers/base/core.c~driver-core-allow-device_movedev-null
+++ a/drivers/base/core.c
@@ -390,22 +390,23 @@ void device_initialize(struct device *de
 }
 
 #ifdef CONFIG_SYSFS_DEPRECATED
-static int setup_parent(struct device *dev, struct device *parent)
+static struct kobject * get_device_parent(struct device *dev,
+					  struct device *parent)
 {
 	/* Set the parent to the class, not the parent device */
 	/* this keeps sysfs from having a symlink to make old udevs happy */
 	if (dev->class)
-		dev->kobj.parent = &dev->class->subsys.kset.kobj;
+		return &dev->class->subsys.kset.kobj;
 	else if (parent)
-		dev->kobj.parent = &parent->kobj;
+		return &parent->kobj;
 
-	return 0;
+	return NULL;
 }
 #else
-static int virtual_device_parent(struct device *dev)
+static struct kobject * virtual_device_parent(struct device *dev)
 {
 	if (!dev->class)
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	if (!dev->class->virtual_dir) {
 		static struct kobject *virtual_dir = NULL;
@@ -415,25 +416,31 @@ static int virtual_device_parent(struct 
 		dev->class->virtual_dir = kobject_add_dir(virtual_dir, dev->class->name);
 	}
 
-	dev->kobj.parent = dev->class->virtual_dir;
-	return 0;
+	return dev->class->virtual_dir;
 }
 
-static int setup_parent(struct device *dev, struct device *parent)
+static struct kobject * get_device_parent(struct device *dev,
+					  struct device *parent)
 {
-	int error;
-
 	/* if this is a class device, and has no parent, create one */
 	if ((dev->class) && (parent == NULL)) {
-		error = virtual_device_parent(dev);
-		if (error)
-			return error;
+		return virtual_device_parent(dev);
 	} else if (parent)
-		dev->kobj.parent = &parent->kobj;
+		return &parent->kobj;
+	return NULL;
+}
 
+#endif
+static int setup_parent(struct device *dev, struct device *parent)
+{
+	struct kobject *kobj;
+	kobj = get_device_parent(dev, parent);
+	if (IS_ERR(kobj))
+		return PTR_ERR(kobj);
+	if (kobj)
+		dev->kobj.parent = kobj;
 	return 0;
 }
-#endif
 
 /**
  *	device_add - add device to device hierarchy.
@@ -979,12 +986,18 @@ static int device_move_class_links(struc
 		sysfs_remove_link(&dev->kobj, "device");
 		sysfs_remove_link(&old_parent->kobj, class_name);
 	}
-	error = sysfs_create_link(&dev->kobj, &new_parent->kobj, "device");
-	if (error)
-		goto out;
-	error = sysfs_create_link(&new_parent->kobj, &dev->kobj, class_name);
-	if (error)
-		sysfs_remove_link(&dev->kobj, "device");
+	if (new_parent) {
+		error = sysfs_create_link(&dev->kobj, &new_parent->kobj,
+					  "device");
+		if (error)
+			goto out;
+		error = sysfs_create_link(&new_parent->kobj, &dev->kobj,
+					  class_name);
+		if (error)
+			sysfs_remove_link(&dev->kobj, "device");
+	}
+	else
+		error = 0;
 out:
 	kfree(class_name);
 	return error;
@@ -996,25 +1009,28 @@ out:
 /**
  * device_move - moves a device to a new parent
  * @dev: the pointer to the struct device to be moved
- * @new_parent: the new parent of the device
+ * @new_parent: the new parent of the device (can by NULL)
  */
 int device_move(struct device *dev, struct device *new_parent)
 {
 	int error;
 	struct device *old_parent;
+	struct kobject *new_parent_kobj;
 
 	dev = get_device(dev);
 	if (!dev)
 		return -EINVAL;
 
 	new_parent = get_device(new_parent);
-	if (!new_parent) {
-		error = -EINVAL;
+	new_parent_kobj = get_device_parent (dev, new_parent);
+	if (IS_ERR(new_parent_kobj)) {
+		error = PTR_ERR(new_parent_kobj);
+		put_device(new_parent);
 		goto out;
 	}
 	pr_debug("DEVICE: moving '%s' to '%s'\n", dev->bus_id,
-		new_parent->bus_id);
-	error = kobject_move(&dev->kobj, &new_parent->kobj);
+		 new_parent ? new_parent->bus_id : "<NULL>");
+	error = kobject_move(&dev->kobj, new_parent_kobj);
 	if (error) {
 		put_device(new_parent);
 		goto out;
@@ -1023,7 +1039,8 @@ int device_move(struct device *dev, stru
 	dev->parent = new_parent;
 	if (old_parent)
 		klist_remove(&dev->knode_parent);
-	klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
+	if (new_parent)
+		klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
 	if (!dev->class)
 		goto out_put;
 	error = device_move_class_links(dev, old_parent, new_parent);
@@ -1031,7 +1048,8 @@ int device_move(struct device *dev, stru
 		/* We ignore errors on cleanup since we're hosed anyway... */
 		device_move_class_links(dev, new_parent, old_parent);
 		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
-			klist_remove(&dev->knode_parent);
+			if (new_parent)
+				klist_remove(&dev->knode_parent);
 			if (old_parent)
 				klist_add_tail(&dev->knode_parent,
 					       &old_parent->klist_children);
diff -puN fs/sysfs/dir.c~driver-core-allow-device_movedev-null fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~driver-core-allow-device_movedev-null
+++ a/fs/sysfs/dir.c
@@ -378,12 +378,10 @@ int sysfs_move_dir(struct kobject *kobj,
 	struct sysfs_dirent *new_parent_sd, *sd;
 	int error;
 
-	if (!new_parent)
-		return -EINVAL;
-
 	old_parent_dentry = kobj->parent ?
 		kobj->parent->dentry : sysfs_mount->mnt_sb->s_root;
-	new_parent_dentry = new_parent->dentry;
+	new_parent_dentry = new_parent ?
+		new_parent->dentry : sysfs_mount->mnt_sb->s_root;
 
 again:
 	mutex_lock(&old_parent_dentry->d_inode->i_mutex);
diff -puN lib/kobject.c~driver-core-allow-device_movedev-null lib/kobject.c
--- a/lib/kobject.c~driver-core-allow-device_movedev-null
+++ a/lib/kobject.c
@@ -355,7 +355,7 @@ int kobject_rename(struct kobject * kobj
 /**
  *	kobject_move - move object to another parent
  *	@kobj:	object in question.
- *	@new_parent: object's new parent
+ *	@new_parent: object's new parent (can be NULL)
  */
 
 int kobject_move(struct kobject *kobj, struct kobject *new_parent)
@@ -371,8 +371,8 @@ int kobject_move(struct kobject *kobj, s
 		return -EINVAL;
 	new_parent = kobject_get(new_parent);
 	if (!new_parent) {
-		error = -EINVAL;
-		goto out;
+		if (kobj->kset)
+			new_parent = kobject_get(&kobj->kset->kobj);
 	}
 	/* old object path */
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-per-subsystem-multithreaded-probing.patch
driver-core-dont-fail-attaching-the-device-if-it.patch
git-s390.patch
