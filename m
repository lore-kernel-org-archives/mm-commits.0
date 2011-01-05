From: akpm@linux-foundation.org
Subject: [folded] reiser4-change-fsync-signature.patch removed from -mm tree
Date: Tue, 04 Jan 2011 16:36:00 -0800
Message-ID: <201101050036.p050a0RT000704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab1AEAgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:36:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: change fsync signature
has been removed from the -mm tree.  Its filename was
     reiser4-change-fsync-signature.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: change fsync signature
From: Edward Shishkin <edward.shishkin@gmail.com>

Change signatures of
. reiser4_sync_common();
. reiser4_sync_file_common()
in accordance with ->fsync() of file_operations

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c |    2 +-
 fs/reiser4/plugin/file/file.h |    2 +-
 fs/reiser4/plugin/file_ops.c  |    7 ++++---
 fs/reiser4/plugin/object.h    |    2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-change-fsync-signature fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-change-fsync-signature
+++ a/fs/reiser4/plugin/file/file.c
@@ -2241,7 +2241,7 @@ ssize_t write_unix_file(struct file *fil
 	if (result == 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		reiser4_txn_restart_current();
 		grab_space_enable();
-		result = reiser4_sync_file_common(file, file->f_dentry,
+		result = reiser4_sync_file_common(file,
 						  0 /* data and stat data */);
 		if (result)
 			warning("reiser4-7", "failed to sync file %llu",
diff -puN fs/reiser4/plugin/file/file.h~reiser4-change-fsync-signature fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-change-fsync-signature
+++ a/fs/reiser4/plugin/file/file.h
@@ -52,7 +52,7 @@ int reiser4_ioctl_careful(struct inode *
 int reiser4_mmap_careful(struct file *, struct vm_area_struct *);
 int reiser4_open_careful(struct inode *inode, struct file *file);
 int reiser4_release_careful(struct inode *, struct file *);
-int reiser4_sync_file_common(struct file *, struct dentry *, int datasync);
+int reiser4_sync_file_common(struct file *, int datasync);
 
 /* address space operations */
 int reiser4_readpage(struct file *, struct page *);
diff -puN fs/reiser4/plugin/file_ops.c~reiser4-change-fsync-signature fs/reiser4/plugin/file_ops.c
--- a/fs/reiser4/plugin/file_ops.c~reiser4-change-fsync-signature
+++ a/fs/reiser4/plugin/file_ops.c
@@ -43,10 +43,11 @@ int reiser4_release_dir_common(struct in
 /* this is common implementation of vfs's fsync method of struct
    file_operations
 */
-int reiser4_sync_common(struct file *file, struct dentry *dentry, int datasync)
+int reiser4_sync_common(struct file *file, int datasync)
 {
 	reiser4_context *ctx;
 	int result;
+	struct dentry *dentry = file->f_path.dentry;
 
 	ctx = reiser4_init_context(dentry->d_inode->i_sb);
 	if (IS_ERR(ctx))
@@ -70,12 +71,12 @@ int reiser4_sync_common(struct file *fil
  * filemap_fdatawrite() that will ultimately call reiser4_writepages(), insert
  * all missing extents and capture anonymous pages.
  */
-int reiser4_sync_file_common(struct file *file,
-			     struct dentry *dentry, int datasync)
+int reiser4_sync_file_common(struct file *file, int datasync)
 {
 	reiser4_context *ctx;
 	txn_atom *atom;
 	reiser4_block_nr reserve;
+	struct dentry *dentry = file->f_path.dentry;
 
 	ctx = reiser4_init_context(dentry->d_inode->i_sb);
 	if (IS_ERR(ctx))
diff -puN fs/reiser4/plugin/object.h~reiser4-change-fsync-signature fs/reiser4/plugin/object.h
--- a/fs/reiser4/plugin/object.h~reiser4-change-fsync-signature
+++ a/fs/reiser4/plugin/object.h
@@ -34,7 +34,7 @@ int reiser4_getattr_common(struct vfsmou
 loff_t reiser4_llseek_dir_common(struct file *, loff_t off, int origin);
 int reiser4_readdir_common(struct file *, void *dirent, filldir_t);
 int reiser4_release_dir_common(struct inode *, struct file *);
-int reiser4_sync_common(struct file *, struct dentry *, int datasync);
+int reiser4_sync_common(struct file *, int datasync);
 
 
 /* file plugin operations: common implementations */
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

linux-next.patch
reiserfs-make-sure-va_end-is-always-called-after-va_start.patch
vfs-add-super-operation-writeback_inodes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
vfs-take-2add-set_page_dirty_notag.patch
vfs-change-writeback_inodes-signature.patch
reiser4.patch
reiser4-writeback_inodes-implementation.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-writeback_inodes-implementation-adjust-to-writeback-changes.patch
reiser4-fixup-checkin-checkout-jnodes-for-entd.patch
reiser4-fixups.patch
reiser4-broke.patch

