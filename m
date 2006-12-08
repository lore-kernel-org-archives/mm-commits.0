From: akpm@osdl.org
Subject: - ecryptfs-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:20 -0800
Message-ID: <200612082002.kB8K2KHE001966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57006 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761160AbWLHUCW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     ecryptfs-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the
ecryptfs filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/file.c  |   14 +++++++-------
 fs/ecryptfs/inode.c |    4 ++--
 fs/ecryptfs/mmap.c  |   16 ++++++++--------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/ecryptfs/file.c~ecryptfs-change-uses-of-f_dentry fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-change-uses-of-f_dentry
+++ a/fs/ecryptfs/file.c
@@ -76,7 +76,7 @@ static loff_t ecryptfs_llseek(struct fil
 	}
 	ecryptfs_printk(KERN_DEBUG, "new_end_pos = [0x%.16x]\n", new_end_pos);
 	if (expanding_file) {
-		rc = ecryptfs_truncate(file->f_dentry, new_end_pos);
+		rc = ecryptfs_truncate(file->f_path.dentry, new_end_pos);
 		if (rc) {
 			rv = rc;
 			ecryptfs_printk(KERN_ERR, "Error on attempt to "
@@ -117,8 +117,8 @@ static ssize_t ecryptfs_read_update_atim
 	if (-EIOCBQUEUED == rc)
 		rc = wait_on_sync_kiocb(iocb);
 	if (rc >= 0) {
-		lower_dentry = ecryptfs_dentry_to_lower(file->f_dentry);
-		lower_vfsmount = ecryptfs_dentry_to_lower_mnt(file->f_dentry);
+		lower_dentry = ecryptfs_dentry_to_lower(file->f_path.dentry);
+		lower_vfsmount = ecryptfs_dentry_to_lower_mnt(file->f_path.dentry);
 		touch_atime(lower_vfsmount, lower_dentry);
 	}
 	return rc;
@@ -177,10 +177,10 @@ static int ecryptfs_readdir(struct file 
 
 	lower_file = ecryptfs_file_to_lower(file);
 	lower_file->f_pos = file->f_pos;
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	memset(&buf, 0, sizeof(buf));
 	buf.dirent = dirent;
-	buf.dentry = file->f_dentry;
+	buf.dentry = file->f_path.dentry;
 	buf.filldir = filldir;
 retry:
 	buf.filldir_called = 0;
@@ -193,7 +193,7 @@ retry:
 		goto retry;
 	file->f_pos = lower_file->f_pos;
 	if (rc >= 0)
-		fsstack_copy_attr_atime(inode, lower_file->f_dentry->d_inode);
+		fsstack_copy_attr_atime(inode, lower_file->f_path.dentry->d_inode);
 	return rc;
 }
 
@@ -240,7 +240,7 @@ static int ecryptfs_open(struct inode *i
 	int rc = 0;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
-	struct dentry *ecryptfs_dentry = file->f_dentry;
+	struct dentry *ecryptfs_dentry = file->f_path.dentry;
 	/* Private value of ecryptfs_dentry allocated in
 	 * ecryptfs_lookup() */
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
diff -puN fs/ecryptfs/inode.c~ecryptfs-change-uses-of-f_dentry fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-change-uses-of-f_dentry
+++ a/fs/ecryptfs/inode.c
@@ -155,7 +155,7 @@ static int grow_file(struct dentry *ecry
 	struct ecryptfs_file_info tmp_file_info;
 
 	memset(&fake_file, 0, sizeof(fake_file));
-	fake_file.f_dentry = ecryptfs_dentry;
+	fake_file.f_path.dentry = ecryptfs_dentry;
 	memset(&tmp_file_info, 0, sizeof(tmp_file_info));
 	ecryptfs_set_file_private(&fake_file, &tmp_file_info);
 	ecryptfs_set_file_lower(&fake_file, lower_file);
@@ -754,7 +754,7 @@ int ecryptfs_truncate(struct dentry *den
 	 * the file in the underlying filesystem so that the
 	 * truncation has an effect there as well. */
 	memset(&fake_ecryptfs_file, 0, sizeof(fake_ecryptfs_file));
-	fake_ecryptfs_file.f_dentry = dentry;
+	fake_ecryptfs_file.f_path.dentry = dentry;
 	/* Released at out_free: label */
 	ecryptfs_set_file_private(&fake_ecryptfs_file,
 				  kmem_cache_alloc(ecryptfs_file_info_cache,
diff -puN fs/ecryptfs/mmap.c~ecryptfs-change-uses-of-f_dentry fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-change-uses-of-f_dentry
+++ a/fs/ecryptfs/mmap.c
@@ -51,7 +51,7 @@ static struct page *ecryptfs_get1page(st
 	struct inode *inode;
 	struct address_space *mapping;
 
-	dentry = file->f_dentry;
+	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
 	mapping = inode->i_mapping;
 	page = read_cache_page(mapping, index,
@@ -84,7 +84,7 @@ int write_zeros(struct file *file, pgoff
 int ecryptfs_fill_zeros(struct file *file, loff_t new_length)
 {
 	int rc = 0;
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	pgoff_t old_end_page_index = 0;
 	pgoff_t index = old_end_page_index;
@@ -218,7 +218,7 @@ int ecryptfs_do_readpage(struct file *fi
 	char *lower_page_data;
 	const struct address_space_operations *lower_a_ops;
 
-	dentry = file->f_dentry;
+	dentry = file->f_path.dentry;
 	lower_file = ecryptfs_file_to_lower(file);
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	inode = dentry->d_inode;
@@ -275,9 +275,9 @@ static int ecryptfs_readpage(struct file
 	int rc = 0;
 	struct ecryptfs_crypt_stat *crypt_stat;
 
-	BUG_ON(!(file && file->f_dentry && file->f_dentry->d_inode));
-	crypt_stat =
-		&ecryptfs_inode_to_private(file->f_dentry->d_inode)->crypt_stat;
+	BUG_ON(!(file && file->f_path.dentry && file->f_path.dentry->d_inode));
+	crypt_stat = &ecryptfs_inode_to_private(file->f_path.dentry->d_inode)
+			->crypt_stat;
 	if (!crypt_stat
 	    || !ECRYPTFS_CHECK_FLAG(crypt_stat->flags, ECRYPTFS_ENCRYPTED)
 	    || ECRYPTFS_CHECK_FLAG(crypt_stat->flags, ECRYPTFS_NEW_FILE)) {
@@ -638,8 +638,8 @@ static int ecryptfs_commit_write(struct 
 	lower_inode = ecryptfs_inode_to_lower(inode);
 	lower_file = ecryptfs_file_to_lower(file);
 	mutex_lock(&lower_inode->i_mutex);
-	crypt_stat =
-		&ecryptfs_inode_to_private(file->f_dentry->d_inode)->crypt_stat;
+	crypt_stat = &ecryptfs_inode_to_private(file->f_path.dentry->d_inode)
+				->crypt_stat;
 	if (ECRYPTFS_CHECK_FLAG(crypt_stat->flags, ECRYPTFS_NEW_FILE)) {
 		ecryptfs_printk(KERN_DEBUG, "ECRYPTFS_NEW_FILE flag set in "
 			"crypt_stat at memory location [%p]\n", crypt_stat);
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

