From: akpm@linux-foundation.org
Subject: - sysfs-add-sysfs_dirent-s_parent.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:29:03 -0700
Message-ID: <200704132329.l3DNT3N5012569@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161123AbXDMX30 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, cornelia.huck@de.ibm.com, dipankar@in.ibm.com, greg@kroah.com, maneesh@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: add sysfs_dirent->s_parent
has been removed from the -mm tree.  Its filename was
     sysfs-add-sysfs_dirent-s_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: add sysfs_dirent->s_parent
From: Tejun Heo <htejun@gmail.com>

Add sysfs_dirent->s_parent.  With this patch, each sd points to and holds a
reference to its parent.  This allows walking sysfs tree without referencing
sd->s_dentry which can go away anytime if the user doesn't control when it's
deleted.

sd->s_parent is initialized and parent is referenced in sysfs_attach_dirent().
 Reference to parent is released when the sd is released, so as long as
reference to a sd is held, s_parent can be followed.

dentry walk in sysfs_readdir() is convereted to s_parent walk.

This will be used to reimplement symlink such that it uses only sysfs_dirent
tree.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c   |   27 ++++++++++++++++++++-------
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 22 insertions(+), 7 deletions(-)

diff -puN fs/sysfs/dir.c~sysfs-add-sysfs_dirent-s_parent fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-add-sysfs_dirent-s_parent
+++ a/fs/sysfs/dir.c
@@ -16,6 +16,11 @@ DECLARE_RWSEM(sysfs_rename_sem);
 
 void release_sysfs_dirent(struct sysfs_dirent * sd)
 {
+	struct sysfs_dirent *parent_sd;
+
+ repeat:
+	parent_sd = sd->s_parent;
+
 	if (sd->s_type & SYSFS_KOBJ_LINK) {
 		struct sysfs_symlink * sl = sd->s_element;
 		kfree(sl->link_name);
@@ -24,6 +29,10 @@ void release_sysfs_dirent(struct sysfs_d
 	}
 	kfree(sd->s_iattr);
 	kmem_cache_free(sysfs_dir_cachep, sd);
+
+	sd = parent_sd;
+	if (sd && atomic_dec_and_test(&sd->s_count))
+		goto repeat;
 }
 
 static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
@@ -71,8 +80,10 @@ void sysfs_attach_dirent(struct sysfs_di
 		dentry->d_op = &sysfs_dentry_ops;
 	}
 
-	if (parent_sd)
+	if (parent_sd) {
+		sd->s_parent = sysfs_get(parent_sd);
 		list_add(&sd->s_sibling, &parent_sd->s_children);
+	}
 }
 
 /*
@@ -508,7 +519,7 @@ static int sysfs_readdir(struct file * f
 			i++;
 			/* fallthrough */
 		case 1:
-			ino = (unsigned long)dentry->d_parent->d_fsdata;
+			ino = (unsigned long)parent_sd->s_parent;
 			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -625,13 +636,13 @@ int sysfs_make_shadowed_dir(struct kobje
 
 struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 {
+	struct dentry *dir = kobj->dentry;
+	struct inode *inode = dir->d_inode;
+	struct dentry *parent = dir->d_parent;
+	struct sysfs_dirent *parent_sd = parent->d_fsdata;
+	struct dentry *shadow;
 	struct sysfs_dirent *sd;
-	struct dentry *parent, *dir, *shadow;
-	struct inode *inode;
 
-	dir = kobj->dentry;
-	inode = dir->d_inode;
-	parent = dir->d_parent;
 	shadow = ERR_PTR(-EINVAL);
 	if (!sysfs_is_shadowed_inode(inode))
 		goto out;
@@ -643,6 +654,8 @@ struct dentry *sysfs_create_shadow_dir(s
 	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
+	/* point to parent_sd but don't attach to it */
+	sd->s_parent = sysfs_get(parent_sd);
 	sysfs_attach_dirent(sd, NULL, shadow);
 
 	d_instantiate(shadow, igrab(inode));
diff -puN fs/sysfs/mount.c~sysfs-add-sysfs_dirent-s_parent fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~sysfs-add-sysfs_dirent-s_parent
+++ a/fs/sysfs/mount.c
@@ -28,6 +28,7 @@ static const struct super_operations sys
 };
 
 static struct sysfs_dirent sysfs_root = {
+	.s_count	= ATOMIC_INIT(1),
 	.s_sibling	= LIST_HEAD_INIT(sysfs_root.s_sibling),
 	.s_children	= LIST_HEAD_INIT(sysfs_root.s_children),
 	.s_element	= NULL,
diff -puN fs/sysfs/sysfs.h~sysfs-add-sysfs_dirent-s_parent fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-add-sysfs_dirent-s_parent
+++ a/fs/sysfs/sysfs.h
@@ -1,5 +1,6 @@
 struct sysfs_dirent {
 	atomic_t		s_count;
+	struct sysfs_dirent	* s_parent;
 	struct list_head	s_sibling;
 	struct list_head	s_children;
 	void 			* s_element;
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
optional-led-trigger-for-libata.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
git-scsi-misc.patch
introduce-config_has_dma.patch
