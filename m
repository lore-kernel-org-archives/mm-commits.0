From: akpm@linux-foundation.org
Subject: - ecryptfs-make-all-persistent-file-opens-delayed.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:03 -0700
Message-ID: <200807242329.m6ONT3MZ011339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757146AbYGXXen (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:34:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Make all persistent file opens delayed
has been removed from the -mm tree.  Its filename was
     ecryptfs-make-all-persistent-file-opens-delayed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Make all persistent file opens delayed
From: Michael Halcrow <mhalcrow@us.ibm.com>

There is no good reason to immediately open the lower file, and that can
cause problems with files that the user does not intend to immediately
open, such as device nodes.

This patch removes the persistent file open from the interpose step and
pushes that to the locations where eCryptfs really does need the lower
persistent file, such as just before reading or writing the metadata
stored in the lower file header.

Two functions are jumping to out_dput when they should just be jumping to
out on error paths.  This patch also fixes these.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |    2 --
 fs/ecryptfs/file.c            |    4 ----
 fs/ecryptfs/inode.c           |   27 +++++++++++++++++++++++----
 fs/ecryptfs/main.c            |   16 ----------------
 4 files changed, 23 insertions(+), 26 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-make-all-persistent-file-opens-delayed fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-make-all-persistent-file-opens-delayed
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -235,7 +235,6 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_METADATA_IN_XATTR  0x00000100
 #define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
 #define ECRYPTFS_KEY_SET            0x00000400
-#define ECRYPTFS_DELAY_PERSISTENT   0x00000800
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -576,7 +575,6 @@ struct ecryptfs_open_req {
 };
 
 #define ECRYPTFS_INTERPOSE_FLAG_D_ADD                 0x00000001
-#define ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE 0x00000002
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
 		       u32 flags);
diff -puN fs/ecryptfs/file.c~ecryptfs-make-all-persistent-file-opens-delayed fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-make-all-persistent-file-opens-delayed
+++ a/fs/ecryptfs/file.c
@@ -200,10 +200,6 @@ static int ecryptfs_open(struct inode *i
 		goto out;
 	}
 	if (!ecryptfs_inode_to_private(inode)->lower_file) {
-		BUG_ON(!(crypt_stat->flags & ECRYPTFS_DELAY_PERSISTENT));
-		mutex_lock(&crypt_stat->cs_mutex);
-		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-		mutex_unlock(&crypt_stat->cs_mutex);
 		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
 		if (rc) {
 			printk(KERN_ERR "%s: Error attempting to initialize "
diff -puN fs/ecryptfs/inode.c~ecryptfs-make-all-persistent-file-opens-delayed fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-make-all-persistent-file-opens-delayed
+++ a/fs/ecryptfs/inode.c
@@ -189,6 +189,16 @@ static int ecryptfs_initialize_file(stru
 				"context; rc = [%d]\n", rc);
 		goto out;
 	}
+	if (!ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->lower_file) {
+		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       ecryptfs_dentry->d_name.name, rc);
+			goto out;
+		}
+	}
 	rc = ecryptfs_write_metadata(ecryptfs_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error writing headers; rc = [%d]\n", rc);
@@ -312,7 +322,7 @@ static struct dentry *ecryptfs_lookup(st
 				ECRYPTFS_INTERPOSE_FLAG_D_ADD);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error interposing\n");
-		goto out_dput;
+		goto out;
 	}
 	if (S_ISDIR(lower_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "Is a directory; returning\n");
@@ -338,11 +348,21 @@ static struct dentry *ecryptfs_lookup(st
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR,
 				"Cannot ecryptfs_kmalloc a page\n");
-		goto out_dput;
+		goto out;
 	}
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
 		ecryptfs_set_default_sizes(crypt_stat);
+	if (!ecryptfs_inode_to_private(dentry->d_inode)->lower_file) {
+		rc = ecryptfs_init_persistent_file(dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       dentry->d_name.name, rc);
+			goto out;
+		}
+	}
 	rc = ecryptfs_read_and_validate_header_region(page_virt,
 						      dentry->d_inode);
 	if (rc) {
@@ -538,8 +558,7 @@ ecryptfs_mknod(struct inode *dir, struct
 	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, mode, dev);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
-	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb,
-				ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE);
+	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out;
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
diff -puN fs/ecryptfs/main.c~ecryptfs-make-all-persistent-file-opens-delayed fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-make-all-persistent-file-opens-delayed
+++ a/fs/ecryptfs/main.c
@@ -201,22 +201,6 @@ int ecryptfs_interpose(struct dentry *lo
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
-	if (!(flags & ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE)) {
-		rc = ecryptfs_init_persistent_file(dentry);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to initialize "
-			       "the persistent file for the dentry with name "
-			       "[%s]; rc = [%d]\n", __func__,
-			       dentry->d_name.name, rc);
-			goto out;
-		}
-	} else {
-		struct ecryptfs_inode_info *inode_info =
-			ecryptfs_inode_to_private(dentry->d_inode);
