From: akpm@osdl.org
Subject: - reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:51:43 -0800
Message-ID: <200701260751.l0Q7ph8C010752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50497 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030814AbXAZHvx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:51:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vs@namesys.com, jeffm@suse.com, mason@suse.com, mm-commits@vger.kernel.org


The patch titled
     resierfs: avoid tail packing if an inode was ever mmapped
has been removed from the -mm tree.  Its filename was
     reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: resierfs: avoid tail packing if an inode was ever mmapped
From: Vladimir Saveliev <vs@namesys.com>

This patch fixes a confusion reiserfs has for a long time.

On release file operation reiserfs used to try to pack file data stored in
last incomplete page of some files into metadata blocks.  After packing the
page got cleared with clear_page_dirty.  It did not take into account that
the page may be mmaped into other process's address space.  Recent
replacement for clear_page_dirty cancel_dirty_page found the confusion with
sanity check that page has to be not mapped.

The patch fixes the confusion by making reiserfs avoid tail packing if an
inode was ever mmapped.  reiserfs_mmap and reiserfs_file_release are
serialized with mutex in reiserfs specific inode.  reiserfs_mmap locks the
mutex and sets a bit in reiserfs specific inode flags. 
reiserfs_file_release checks the bit having the mutex locked.  If bit is
set - tail packing is avoided.  This eliminates a possibility that mmapped
page gets cancel_page_dirty-ed.

Signed-off-by: Vladimir Saveliev <vs@namesys.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <mason@suse.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiserfs/file.c            |   20 +++++++++++++++++++-
 fs/reiserfs/inode.c           |    2 ++
 include/linux/reiserfs_fs_i.h |    2 ++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/file.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped
+++ a/fs/reiserfs/file.c
@@ -48,6 +48,11 @@ static int reiserfs_file_release(struct 
 	}
 
 	mutex_lock(&inode->i_mutex);
+
+	mutex_lock(&(REISERFS_I(inode)->i_mmap));
+	if (REISERFS_I(inode)->i_flags & i_ever_mapped)
+		REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
+
 	reiserfs_write_lock(inode->i_sb);
 	/* freeing preallocation only involves relogging blocks that
 	 * are already in the current transaction.  preallocation gets
@@ -100,11 +105,24 @@ static int reiserfs_file_release(struct 
 		err = reiserfs_truncate_file(inode, 0);
 	}
       out:
+	mutex_unlock(&(REISERFS_I(inode)->i_mmap));
 	mutex_unlock(&inode->i_mutex);
 	reiserfs_write_unlock(inode->i_sb);
 	return err;
 }
 
+static int reiserfs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode;
+
+	inode = file->f_path.dentry->d_inode;
+	mutex_lock(&(REISERFS_I(inode)->i_mmap));
+	REISERFS_I(inode)->i_flags |= i_ever_mapped;
+	mutex_unlock(&(REISERFS_I(inode)->i_mmap));
+
+	return generic_file_mmap(file, vma);
+}
+
 static void reiserfs_vfs_truncate_file(struct inode *inode)
 {
 	reiserfs_truncate_file(inode, 1);
@@ -1527,7 +1545,7 @@ const struct file_operations reiserfs_fi
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = reiserfs_compat_ioctl,
 #endif
-	.mmap = generic_file_mmap,
+	.mmap = reiserfs_file_mmap,
 	.open = generic_file_open,
 	.release = reiserfs_file_release,
 	.fsync = reiserfs_sync_file,
diff -puN fs/reiserfs/inode.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped
+++ a/fs/reiserfs/inode.c
@@ -1125,6 +1125,7 @@ static void init_inode(struct inode *ino
 	REISERFS_I(inode)->i_prealloc_count = 0;
 	REISERFS_I(inode)->i_trans_id = 0;
 	REISERFS_I(inode)->i_jl = NULL;
+	mutex_init(&(REISERFS_I(inode)->i_mmap));
 	reiserfs_init_acl_access(inode);
 	reiserfs_init_acl_default(inode);
 	reiserfs_init_xattr_rwsem(inode);
@@ -1832,6 +1833,7 @@ int reiserfs_new_inode(struct reiserfs_t
 	REISERFS_I(inode)->i_attrs =
 	    REISERFS_I(dir)->i_attrs & REISERFS_INHERIT_MASK;
 	sd_attrs_to_i_attrs(REISERFS_I(inode)->i_attrs, inode);
+	mutex_init(&(REISERFS_I(inode)->i_mmap));
 	reiserfs_init_acl_access(inode);
 	reiserfs_init_acl_default(inode);
 	reiserfs_init_xattr_rwsem(inode);
diff -puN include/linux/reiserfs_fs_i.h~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped include/linux/reiserfs_fs_i.h
--- a/include/linux/reiserfs_fs_i.h~reiserfs-avoid-tail-packing-if-an-inode-was-ever-mmapped
+++ a/include/linux/reiserfs_fs_i.h
@@ -25,6 +25,7 @@ typedef enum {
 	i_link_saved_truncate_mask = 0x0020,
 	i_has_xattr_dir = 0x0040,
 	i_data_log = 0x0080,
+	i_ever_mapped = 0x0100
 } reiserfs_inode_flags;
 
 struct reiserfs_inode_info {
@@ -52,6 +53,7 @@ struct reiserfs_inode_info {
 	 ** flushed */
 	unsigned long i_trans_id;
 	struct reiserfs_journal_list *i_jl;
+	struct mutex i_mmap;
 #ifdef CONFIG_REISERFS_FS_POSIX_ACL
 	struct posix_acl *i_acl_access;
 	struct posix_acl *i_acl_default;
_

Patches currently in -mm which might be from vs@namesys.com are

reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-fix-trivial-tyops-which-were-hard-to-hit.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-bug-fixes.patch
reiser4-fix-gcc-ws-compains.patch
fs-reiser4-possible-cleanups.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
reiser4-rename-generic_sounding_globalspatch.patch
reiser4-possible-cleanups-2.patch
reiser4-temp-fix.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-freeze-and-corruption.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
