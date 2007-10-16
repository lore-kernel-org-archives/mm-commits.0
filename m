From: akpm@linux-foundation.org
Subject: - ecryptfs-set-up-and-destroy-persistent-lower-file.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:56 -0700
Message-ID: <200710162040.l9GKeuUx015732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935975AbXJPVGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:06:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: set up and destroy persistent lower file
has been removed from the -mm tree.  Its filename was
     ecryptfs-set-up-and-destroy-persistent-lower-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: set up and destroy persistent lower file
From: Michael Halcrow <mhalcrow@us.ibm.com>

This patch sets up and destroys the persistent lower file for each eCryptfs
inode.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   23 ++++++++++++--
 fs/ecryptfs/main.c  |   65 ++++++++++++++++++++++++++++++++++++++++++
 fs/ecryptfs/super.c |   22 ++++++++++++--
 3 files changed, 103 insertions(+), 7 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-set-up-and-destroy-persistent-lower-file fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-set-up-and-destroy-persistent-lower-file
+++ a/fs/ecryptfs/inode.c
@@ -119,10 +119,23 @@ ecryptfs_do_create(struct inode *directo
 	}
 	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
 					     ecryptfs_dentry, mode, nd);
-	if (unlikely(rc)) {
-		ecryptfs_printk(KERN_ERR,
-				"Failure to create underlying file\n");
-		goto out_lock;
+	if (rc) {
+		struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
+		struct ecryptfs_inode_info *inode_info =
+			ecryptfs_inode_to_private(ecryptfs_inode);
+
+		printk(KERN_WARNING "%s: Error creating underlying file; "
+		       "rc = [%d]; checking for existing\n", __FUNCTION__, rc);
+		if (inode_info) {
+			mutex_lock(&inode_info->lower_file_mutex);
+			if (!inode_info->lower_file) {
+				mutex_unlock(&inode_info->lower_file_mutex);
+				printk(KERN_ERR "%s: Failure to set underlying "
+				       "file; rc = [%d]\n", __FUNCTION__, rc);
+				goto out_lock;
+			}
+			mutex_unlock(&inode_info->lower_file_mutex);
+		}
 	}
 	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
 				directory_inode->i_sb, 0);
@@ -252,6 +265,8 @@ ecryptfs_create(struct inode *directory_
 {
 	int rc;
 
+	/* ecryptfs_do_create() calls ecryptfs_interpose(), which opens
+	 * the crypt_stat->lower_file (persistent file) */
 	rc = ecryptfs_do_create(directory_inode, ecryptfs_dentry, mode, nd);
 	if (unlikely(rc)) {
 		ecryptfs_printk(KERN_WARNING, "Failed to create file in"
diff -puN fs/ecryptfs/main.c~ecryptfs-set-up-and-destroy-persistent-lower-file fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-set-up-and-destroy-persistent-lower-file
+++ a/fs/ecryptfs/main.c
@@ -99,6 +99,64 @@ void __ecryptfs_printk(const char *fmt, 
 }
 
 /**
+ * ecryptfs_init_persistent_file
+ * @ecryptfs_dentry: Fully initialized eCryptfs dentry object, with
+ *                   the lower dentry and the lower mount set
+ *
+ * eCryptfs only ever keeps a single open file for every lower
+ * inode. All I/O operations to the lower inode occur through that
+ * file. When the first eCryptfs dentry that interposes with the first
+ * lower dentry for that inode is created, this function creates the
+ * persistent file struct and associates it with the eCryptfs
+ * inode. When the eCryptfs inode is destroyed, the file is closed.
+ *
+ * The persistent file will be opened with read/write permissions, if
+ * possible. Otherwise, it is opened read-only.
+ *
+ * This function does nothing if a lower persistent file is already
+ * associated with the eCryptfs inode.
+ *
+ * Returns zero on success; non-zero otherwise
+ */
+int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
+{
+	struct ecryptfs_inode_info *inode_info =
+		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
+	int rc = 0;
+
+	mutex_lock(&inode_info->lower_file_mutex);
+	if (!inode_info->lower_file) {
+		struct dentry *lower_dentry;
+		struct vfsmount *lower_mnt =
+			ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
+
+		lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
+		/* Corresponding dput() and mntput() are done when the
+		 * persistent file is fput() when the eCryptfs inode
+		 * is destroyed. */
+		dget(lower_dentry);
+		mntget(lower_mnt);
+		inode_info->lower_file = dentry_open(lower_dentry,
+						     lower_mnt,
+						     (O_RDWR | O_LARGEFILE));
+		if (IS_ERR(inode_info->lower_file))
+			inode_info->lower_file = dentry_open(lower_dentry,
+							     lower_mnt,
+							     (O_RDONLY
+							      | O_LARGEFILE));
+		if (IS_ERR(inode_info->lower_file)) {
+			printk(KERN_ERR "Error opening lower persistent file "
+			       "for lower_dentry [0x%p] and lower_mnt [0x%p]\n",
+			       lower_dentry, lower_mnt);
+			rc = PTR_ERR(inode_info->lower_file);
+			inode_info->lower_file = NULL;
+		}
+	}
+	mutex_unlock(&inode_info->lower_file_mutex);
+	return rc;
+}
+
+/**
  * ecryptfs_interpose
  * @lower_dentry: Existing dentry in the lower filesystem
  * @dentry: ecryptfs' dentry
@@ -155,6 +213,13 @@ int ecryptfs_interpose(struct dentry *lo
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
+	rc = ecryptfs_init_persistent_file(dentry);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to initialize the "
+		       "persistent file for the dentry with name [%s]; "
+		       "rc = [%d]\n", __FUNCTION__, dentry->d_name.name, rc);
+		goto out;
+	}
 out:
 	return rc;
 }
diff -puN fs/ecryptfs/super.c~ecryptfs-set-up-and-destroy-persistent-lower-file fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-set-up-and-destroy-persistent-lower-file
+++ a/fs/ecryptfs/super.c
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/key.h>
 #include <linux/seq_file.h>
+#include <linux/file.h>
 #include <linux/crypto.h>
 #include "ecryptfs_kernel.h"
 
@@ -63,9 +64,10 @@ out:
  * ecryptfs_destroy_inode
  * @inode: The ecryptfs inode
  *
- * This is used during the final destruction of the inode.
- * All allocation of memory related to the inode, including allocated
- * memory in the crypt_stat struct, will be released here.
+ * This is used during the final destruction of the inode.  All
+ * allocation of memory related to the inode, including allocated
+ * memory in the crypt_stat struct, will be released here. This
+ * function also fput()'s the persistent file for the lower inode.
  * There should be no chance that this deallocation will be missed.
  */
 static void ecryptfs_destroy_inode(struct inode *inode)
@@ -73,6 +75,20 @@ static void ecryptfs_destroy_inode(struc
 	struct ecryptfs_inode_info *inode_info;
 
 	inode_info = ecryptfs_inode_to_private(inode);
+	mutex_lock(&inode_info->lower_file_mutex);
+	if (inode_info->lower_file) {
+		struct dentry *lower_dentry =
+			inode_info->lower_file->f_dentry;
+
+		BUG_ON(!lower_dentry);
+		if (lower_dentry->d_inode) {
+			fput(inode_info->lower_file);
+			inode_info->lower_file = NULL;
+			d_drop(lower_dentry);
+			d_delete(lower_dentry);
+		}
+	}
+	mutex_unlock(&inode_info->lower_file_mutex);
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
 	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
