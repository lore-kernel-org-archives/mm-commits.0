From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-pass-writeback_control-to-write_inode.patch removed from -mm tree
Date: Wed, 13 Jan 2010 22:23:56 -0800
Message-ID: <201001140623.o0E6Nuwi020524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab0ANGYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 01:24:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bharrosh@panasas.com, david@fromorbit.com, jack@suse.cz, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: pass writeback_control to ->write_inode
has been removed from the -mm tree.  Its filename was
     fs-pass-writeback_control-to-write_inode.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: pass writeback_control to ->write_inode
From: Christoph Hellwig <hch@lst.de>

This gives the filesystem more information about the writeback that is
happening.  Trond requested this for the NFS unstable write handling, and
other filesystems might benefit from this too by beeing able to
distinguish between the different callers in more detail.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Dave Chinner <david@fromorbit.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/adfs.h               |    2 +-
 fs/adfs/inode.c              |    5 +++--
 fs/affs/affs.h               |    3 ++-
 fs/affs/inode.c              |    2 +-
 fs/bfs/inode.c               |    5 +++--
 fs/btrfs/ctree.h             |    2 +-
 fs/btrfs/inode.c             |    4 ++--
 fs/exofs/exofs.h             |    2 +-
 fs/exofs/inode.c             |    4 ++--
 fs/ext2/ext2.h               |    2 +-
 fs/ext2/inode.c              |   11 +++++++++--
 fs/ext3/inode.c              |    4 ++--
 fs/ext4/ext4.h               |    2 +-
 fs/ext4/inode.c              |    6 +++---
 fs/fat/inode.c               |    9 +++++++--
 fs/fs-writeback.c            |   11 +++++------
 fs/gfs2/super.c              |    5 +++--
 fs/hfs/hfs_fs.h              |    2 +-
 fs/hfs/inode.c               |    2 +-
 fs/hfsplus/super.c           |    3 ++-
 fs/jfs/inode.c               |    5 ++++-
 fs/jfs/jfs_inode.h           |    2 +-
 fs/minix/inode.c             |    8 +++++---
 fs/ntfs/dir.c                |    2 +-
 fs/ntfs/file.c               |    2 +-
 fs/ntfs/inode.c              |    2 +-
 fs/ntfs/inode.h              |    2 +-
 fs/ntfs/super.c              |    8 ++++++++
 fs/omfs/inode.c              |   10 ++++++++--
 fs/reiserfs/inode.c          |    4 ++--
 fs/sysv/inode.c              |   10 ++++++++--
 fs/sysv/sysv.h               |    2 +-
 fs/ubifs/dir.c               |    2 +-
 fs/ubifs/file.c              |    8 ++++----
 fs/ubifs/super.c             |    2 +-
 fs/udf/inode.c               |    4 ++--
 fs/udf/udfdecl.h             |    2 +-
 fs/ufs/inode.c               |    5 +++--
 fs/ufs/ufs.h                 |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |    4 ++--
 include/linux/ext3_fs.h      |    2 +-
 include/linux/fs.h           |    2 +-
 include/linux/reiserfs_fs.h  |    2 +-
 43 files changed, 110 insertions(+), 68 deletions(-)

diff -puN fs/adfs/adfs.h~fs-pass-writeback_control-to-write_inode fs/adfs/adfs.h
--- a/fs/adfs/adfs.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/adfs/adfs.h
@@ -121,7 +121,7 @@ struct adfs_discmap {
 
 /* Inode stuff */
 struct inode *adfs_iget(struct super_block *sb, struct object_info *obj);
-int adfs_write_inode(struct inode *inode,int unused);
+int adfs_write_inode(struct inode *inode, struct writeback_control *wbc);
 int adfs_notify_change(struct dentry *dentry, struct iattr *attr);
 
 /* map.c */
diff -puN fs/adfs/inode.c~fs-pass-writeback_control-to-write_inode fs/adfs/inode.c
--- a/fs/adfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/adfs/inode.c
@@ -9,6 +9,7 @@
  */
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/writeback.h>
 #include "adfs.h"
 
 /*
@@ -360,7 +361,7 @@ out:
  * The adfs-specific inode data has already been updated by
  * adfs_notify_change()
  */
-int adfs_write_inode(struct inode *inode, int wait)
+int adfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct super_block *sb = inode->i_sb;
 	struct object_info obj;
@@ -375,7 +376,7 @@ int adfs_write_inode(struct inode *inode
 	obj.attr	= ADFS_I(inode)->attr;
 	obj.size	= inode->i_size;
 
-	ret = adfs_dir_update(sb, &obj, wait);
+	ret = adfs_dir_update(sb, &obj, wbc->sync_mode == WB_SYNC_ALL);
 	unlock_kernel();
 	return ret;
 }
diff -puN fs/affs/affs.h~fs-pass-writeback_control-to-write_inode fs/affs/affs.h
--- a/fs/affs/affs.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/affs/affs.h
@@ -175,7 +175,8 @@ extern void			 affs_delete_inode(struct 
 extern void			 affs_clear_inode(struct inode *inode);
 extern struct inode		*affs_iget(struct super_block *sb,
 					unsigned long ino);
-extern int			 affs_write_inode(struct inode *inode, int);
+extern int			 affs_write_inode(struct inode *inode,
+					struct writeback_control *wbc);
 extern int			 affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s32 type);
 
 /* file.c */
diff -puN fs/affs/inode.c~fs-pass-writeback_control-to-write_inode fs/affs/inode.c
--- a/fs/affs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/affs/inode.c
@@ -166,7 +166,7 @@ bad_inode:
 }
 
 int
-affs_write_inode(struct inode *inode, int unused)
+affs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct super_block	*sb = inode->i_sb;
 	struct buffer_head	*bh;
diff -puN fs/bfs/inode.c~fs-pass-writeback_control-to-write_inode fs/bfs/inode.c
--- a/fs/bfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/bfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/writeback.h>
 #include <asm/uaccess.h>
 #include "bfs.h"
 
@@ -98,7 +99,7 @@ error:
 	return ERR_PTR(-EIO);
 }
 
-static int bfs_write_inode(struct inode *inode, int wait)
+static int bfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct bfs_sb_info *info = BFS_SB(inode->i_sb);
 	unsigned int ino = (u16)inode->i_ino;
@@ -147,7 +148,7 @@ static int bfs_write_inode(struct inode 
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
 
 	mark_buffer_dirty(bh);
-	if (wait) {
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh))
 			err = -EIO;
diff -puN fs/btrfs/ctree.h~fs-pass-writeback_control-to-write_inode fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/btrfs/ctree.h
@@ -2325,7 +2325,7 @@ int btrfs_page_mkwrite(struct vm_area_st
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_delete_inode(struct inode *inode);
 void btrfs_put_inode(struct inode *inode);
-int btrfs_write_inode(struct inode *inode, int wait);
+int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
 void btrfs_dirty_inode(struct inode *inode);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
diff -puN fs/btrfs/inode.c~fs-pass-writeback_control-to-write_inode fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/btrfs/inode.c
@@ -4005,7 +4005,7 @@ err:
 	return ret;
 }
 
-int btrfs_write_inode(struct inode *inode, int wait)
+int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
@@ -4014,7 +4014,7 @@ int btrfs_write_inode(struct inode *inod
 	if (root->fs_info->btree_inode == inode)
 		return 0;
 
-	if (wait) {
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		trans = btrfs_join_transaction(root, 1);
 		btrfs_set_trans_block_group(trans, inode);
 		ret = btrfs_commit_transaction(trans, root);
diff -puN fs/exofs/exofs.h~fs-pass-writeback_control-to-write_inode fs/exofs/exofs.h
--- a/fs/exofs/exofs.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/exofs/exofs.h
@@ -226,7 +226,7 @@ int exofs_write_begin(struct file *file,
 		struct page **pagep, void **fsdata);
 extern struct inode *exofs_iget(struct super_block *, unsigned long);
 struct inode *exofs_new_inode(struct inode *, int);
-extern int exofs_write_inode(struct inode *, int);
+extern int exofs_write_inode(struct inode *, struct writeback_control *wbc);
 extern void exofs_delete_inode(struct inode *);
 
 /* dir.c:                */
diff -puN fs/exofs/inode.c~fs-pass-writeback_control-to-write_inode fs/exofs/inode.c
--- a/fs/exofs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/exofs/inode.c
@@ -1238,9 +1238,9 @@ out:
 	return ret;
 }
 
-int exofs_write_inode(struct inode *inode, int wait)
+int exofs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	return exofs_update_inode(inode, wait);
+	return exofs_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 }
 
 /*
diff -puN fs/ext2/ext2.h~fs-pass-writeback_control-to-write_inode fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/ext2/ext2.h
@@ -118,7 +118,7 @@ extern unsigned long ext2_count_free (st
 
 /* inode.c */
 extern struct inode *ext2_iget (struct super_block *, unsigned long);
-extern int ext2_write_inode (struct inode *, int);
+extern int ext2_write_inode (struct inode *, struct writeback_control *);
 extern void ext2_delete_inode (struct inode *);
 extern int ext2_sync_inode (struct inode *);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
diff -puN fs/ext2/inode.c~fs-pass-writeback_control-to-write_inode fs/ext2/inode.c
--- a/fs/ext2/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ext2/inode.c
@@ -41,6 +41,8 @@ MODULE_AUTHOR("Remy Card and others");
 MODULE_DESCRIPTION("Second Extended Filesystem");
 MODULE_LICENSE("GPL");
 
+static int __ext2_write_inode(struct inode *inode, int do_sync);
+
 /*
  * Test whether an inode is a fast symlink.
  */
@@ -64,7 +66,7 @@ void ext2_delete_inode (struct inode * i
 		goto no_delete;
 	EXT2_I(inode)->i_dtime	= get_seconds();
 	mark_inode_dirty(inode);
-	ext2_write_inode(inode, inode_needs_sync(inode));
+	__ext2_write_inode(inode, inode_needs_sync(inode));
 
 	inode->i_size = 0;
 	if (inode->i_blocks)
@@ -1335,7 +1337,7 @@ bad_inode:
 	return ERR_PTR(ret);
 }
 
-int ext2_write_inode(struct inode *inode, int do_sync)
+static int __ext2_write_inode(struct inode *inode, int do_sync)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	struct super_block *sb = inode->i_sb;
@@ -1440,6 +1442,11 @@ int ext2_write_inode(struct inode *inode
 	return err;
 }
 
+int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	return __ext2_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+}
+
 int ext2_sync_inode(struct inode *inode)
 {
 	struct writeback_control wbc = {
diff -puN fs/ext3/inode.c~fs-pass-writeback_control-to-write_inode fs/ext3/inode.c
--- a/fs/ext3/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ext3/inode.c
@@ -3096,7 +3096,7 @@ out_brelse:
  * `stuff()' is running, and the new i_size will be lost.  Plus the inode
  * will no longer be on the superblock's dirty inode list.
  */
-int ext3_write_inode(struct inode *inode, int wait)
+int ext3_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	if (current->flags & PF_MEMALLOC)
 		return 0;
@@ -3107,7 +3107,7 @@ int ext3_write_inode(struct inode *inode
 		return -EIO;
 	}
 
-	if (!wait)
+	if (wbc->sync_mode != WB_SYNC_ALL)
 		return 0;
 
 	return ext3_force_commit(inode->i_sb);
diff -puN fs/ext4/ext4.h~fs-pass-writeback_control-to-write_inode fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/ext4/ext4.h
@@ -1419,7 +1419,7 @@ int ext4_get_block(struct inode *inode, 
 				struct buffer_head *bh_result, int create);
 
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
-extern int  ext4_write_inode(struct inode *, int);
+extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 				struct kstat *stat);
diff -puN fs/ext4/inode.c~fs-pass-writeback_control-to-write_inode fs/ext4/inode.c
--- a/fs/ext4/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ext4/inode.c
@@ -5155,7 +5155,7 @@ out_brelse:
  * `stuff()' is running, and the new i_size will be lost.  Plus the inode
  * will no longer be on the superblock's dirty inode list.
  */
-int ext4_write_inode(struct inode *inode, int wait)
+int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int err;
 
@@ -5169,7 +5169,7 @@ int ext4_write_inode(struct inode *inode
 			return -EIO;
 		}
 
-		if (!wait)
+		if (wbc->sync_mode != WB_SYNC_ALL)
 			return 0;
 
 		err = ext4_force_commit(inode->i_sb);
@@ -5179,7 +5179,7 @@ int ext4_write_inode(struct inode *inode
 		err = ext4_get_inode_loc(inode, &iloc);
 		if (err)
 			return err;
-		if (wait)
+		if (wbc->sync_mode == WB_SYNC_ALL)
 			sync_dirty_buffer(iloc.bh);
 		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
 			ext4_error(inode->i_sb, __func__,
diff -puN fs/fat/inode.c~fs-pass-writeback_control-to-write_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/fat/inode.c
@@ -577,7 +577,7 @@ static inline loff_t fat_i_pos_read(stru
 	return i_pos;
 }
 
-static int fat_write_inode(struct inode *inode, int wait)
+static int __fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
@@ -634,9 +634,14 @@ retry:
 	return err;
 }
 
+static int fat_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	return __fat_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+}
+
 int fat_sync_inode(struct inode *inode)
 {
-	return fat_write_inode(inode, 1);
+	return __fat_write_inode(inode, 1);
 }
 
 EXPORT_SYMBOL_GPL(fat_sync_inode);
diff -puN fs/fs-writeback.c~fs-pass-writeback_control-to-write_inode fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/fs-writeback.c
@@ -381,10 +381,10 @@ static void queue_io(struct bdi_writebac
 	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 }
 
-static int write_inode(struct inode *inode, int sync)
+static int write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	if (inode->i_sb->s_op->write_inode && !is_bad_inode(inode))
-		return inode->i_sb->s_op->write_inode(inode, sync);
+		return inode->i_sb->s_op->write_inode(inode, wbc);
 	return 0;
 }
 
@@ -432,7 +432,6 @@ static int
 writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
-	int wait = wbc->sync_mode == WB_SYNC_ALL;
 	unsigned dirty;
 	int ret;
 
@@ -450,7 +449,7 @@ writeback_single_inode(struct inode *ino
 		 * We'll have another go at writing back this inode when we
 		 * completed a full scan of b_io.
 		 */
-		if (!wait) {
+		if (wbc->sync_mode != WB_SYNC_ALL) {
 			requeue_io(inode);
 			return 0;
 		}
@@ -477,7 +476,7 @@ writeback_single_inode(struct inode *ino
 	 * This is important for filesystems that modify metadata on data
 	 * I/O completion.
 	 */
-	if (wait) {
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		int err = filemap_fdatawait(mapping);
 		if (ret == 0)
 			ret = err;
@@ -485,7 +484,7 @@ writeback_single_inode(struct inode *ino
 
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
-		int err = write_inode(inode, wait);
+		int err = write_inode(inode, wbc);
 		if (ret == 0)
 			ret = err;
 	}
diff -puN fs/gfs2/super.c~fs-pass-writeback_control-to-write_inode fs/gfs2/super.c
--- a/fs/gfs2/super.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/gfs2/super.c
@@ -21,6 +21,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/time.h>
+#include <linux/writeback.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -710,7 +711,7 @@ void gfs2_unfreeze_fs(struct gfs2_sbd *s
  * Returns: errno
  */
 
-static int gfs2_write_inode(struct inode *inode, int sync)
+static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -744,7 +745,7 @@ static int gfs2_write_inode(struct inode
 do_unlock:
 	gfs2_glock_dq_uninit(&gh);
 do_flush:
-	if (sync != 0)
+	if (wbc->sync_mode == WB_SYNC_ALL)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
 	return ret;
 }
diff -puN fs/hfs/hfs_fs.h~fs-pass-writeback_control-to-write_inode fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/hfs/hfs_fs.h
@@ -188,7 +188,7 @@ extern const struct address_space_operat
 
 extern struct inode *hfs_new_inode(struct inode *, struct qstr *, int);
 extern void hfs_inode_write_fork(struct inode *, struct hfs_extent *, __be32 *, __be32 *);
-extern int hfs_write_inode(struct inode *, int);
+extern int hfs_write_inode(struct inode *, struct writeback_control *);
 extern int hfs_inode_setattr(struct dentry *, struct iattr *);
 extern void hfs_inode_read_fork(struct inode *inode, struct hfs_extent *ext,
 			__be32 log_size, __be32 phys_size, u32 clump_size);
diff -puN fs/hfs/inode.c~fs-pass-writeback_control-to-write_inode fs/hfs/inode.c
--- a/fs/hfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/hfs/inode.c
@@ -381,7 +381,7 @@ void hfs_inode_write_fork(struct inode *
 					 HFS_SB(inode->i_sb)->alloc_blksz);
 }
 
-int hfs_write_inode(struct inode *inode, int unused)
+int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct inode *main_inode = inode;
 	struct hfs_find_data fd;
diff -puN fs/hfsplus/super.c~fs-pass-writeback_control-to-write_inode fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/hfsplus/super.c
@@ -87,7 +87,8 @@ bad_inode:
 	return ERR_PTR(err);
 }
 
-static int hfsplus_write_inode(struct inode *inode, int unused)
+static int hfsplus_write_inode(struct inode *inode,
+		struct writeback_control *wbc)
 {
 	struct hfsplus_vh *vhdr;
 	int ret = 0;
diff -puN fs/jfs/inode.c~fs-pass-writeback_control-to-write_inode fs/jfs/inode.c
--- a/fs/jfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/jfs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
+#include <linux/writeback.h>
 #include "jfs_incore.h"
 #include "jfs_inode.h"
 #include "jfs_filsys.h"
@@ -120,8 +121,10 @@ int jfs_commit_inode(struct inode *inode
 	return rc;
 }
 
-int jfs_write_inode(struct inode *inode, int wait)
+int jfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
+	int wait = wbc->sync_mode == WB_SYNC_ALL;
+
 	if (test_cflag(COMMIT_Nolink, inode))
 		return 0;
 	/*
diff -puN fs/jfs/jfs_inode.h~fs-pass-writeback_control-to-write_inode fs/jfs/jfs_inode.h
--- a/fs/jfs/jfs_inode.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/jfs/jfs_inode.h
@@ -26,7 +26,7 @@ extern long jfs_ioctl(struct file *, uns
 extern long jfs_compat_ioctl(struct file *, unsigned int, unsigned long);
 extern struct inode *jfs_iget(struct super_block *, unsigned long);
 extern int jfs_commit_inode(struct inode *, int);
-extern int jfs_write_inode(struct inode*, int);
+extern int jfs_write_inode(struct inode *, struct writeback_control *);
 extern void jfs_delete_inode(struct inode *);
 extern void jfs_dirty_inode(struct inode *);
 extern void jfs_truncate(struct inode *);
diff -puN fs/minix/inode.c~fs-pass-writeback_control-to-write_inode fs/minix/inode.c
--- a/fs/minix/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/minix/inode.c
@@ -17,8 +17,10 @@
 #include <linux/init.h>
 #include <linux/highuid.h>
 #include <linux/vfs.h>
+#include <linux/writeback.h>
 
-static int minix_write_inode(struct inode * inode, int wait);
+static int minix_write_inode(struct inode *inode,
+		struct writeback_control *wbc);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int minix_remount (struct super_block * sb, int * flags, char * data);
 
@@ -552,7 +554,7 @@ static struct buffer_head * V2_minix_upd
 	return bh;
 }
 
-static int minix_write_inode(struct inode *inode, int wait)
+static int minix_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int err = 0;
 	struct buffer_head *bh;
@@ -563,7 +565,7 @@ static int minix_write_inode(struct inod
 		bh = V2_minix_update_inode(inode);
 	if (!bh)
 		return -EIO;
-	if (wait && buffer_dirty(bh)) {
+	if (wbc->sync_mode == WB_SYNC_ALL && buffer_dirty(bh)) {
 		sync_dirty_buffer(bh);
 		if (buffer_req(bh) && !buffer_uptodate(bh)) {
 			printk("IO error syncing minix inode [%s:%08lx]\n",
diff -puN fs/ntfs/dir.c~fs-pass-writeback_control-to-write_inode fs/ntfs/dir.c
--- a/fs/ntfs/dir.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ntfs/dir.c
@@ -1545,7 +1545,7 @@ static int ntfs_dir_fsync(struct file *f
  		write_inode_now(bmp_vi, !datasync);
 		iput(bmp_vi);
 	}
-	ret = ntfs_write_inode(vi, 1);
+	ret = __ntfs_write_inode(vi, 1);
 	write_inode_now(vi, !datasync);
 	err = sync_blockdev(vi->i_sb->s_bdev);
 	if (unlikely(err && !ret))
diff -puN fs/ntfs/file.c~fs-pass-writeback_control-to-write_inode fs/ntfs/file.c
--- a/fs/ntfs/file.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ntfs/file.c
@@ -2182,7 +2182,7 @@ static int ntfs_file_fsync(struct file *
 	ntfs_debug("Entering for inode 0x%lx.", vi->i_ino);
 	BUG_ON(S_ISDIR(vi->i_mode));
 	if (!datasync || !NInoNonResident(NTFS_I(vi)))
-		ret = ntfs_write_inode(vi, 1);
+		ret = __ntfs_write_inode(vi, 1);
 	write_inode_now(vi, !datasync);
 	/*
 	 * NOTE: If we were to use mapping->private_list (see ext2 and
diff -puN fs/ntfs/inode.c~fs-pass-writeback_control-to-write_inode fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ntfs/inode.c
@@ -2957,7 +2957,7 @@ out:
  *
  * Return 0 on success and -errno on error.
  */
-int ntfs_write_inode(struct inode *vi, int sync)
+int __ntfs_write_inode(struct inode *vi, int sync)
 {
 	sle64 nt;
 	ntfs_inode *ni = NTFS_I(vi);
diff -puN fs/ntfs/inode.h~fs-pass-writeback_control-to-write_inode fs/ntfs/inode.h
--- a/fs/ntfs/inode.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/ntfs/inode.h
@@ -307,7 +307,7 @@ extern void ntfs_truncate_vfs(struct ino
 
 extern int ntfs_setattr(struct dentry *dentry, struct iattr *attr);
 
-extern int ntfs_write_inode(struct inode *vi, int sync);
+extern int __ntfs_write_inode(struct inode *vi, int sync);
 
 static inline void ntfs_commit_inode(struct inode *vi)
 {
diff -puN fs/ntfs/super.c~fs-pass-writeback_control-to-write_inode fs/ntfs/super.c
--- a/fs/ntfs/super.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ntfs/super.c
@@ -40,6 +40,7 @@
 #include "dir.h"
 #include "debug.h"
 #include "index.h"
+#include "inode.h"
 #include "aops.h"
 #include "layout.h"
 #include "malloc.h"
@@ -2663,6 +2664,13 @@ static int ntfs_statfs(struct dentry *de
 	return 0;
 }
 
+#ifdef NTFS_RW
+static int ntfs_write_inode(struct inode *vi, struct writeback_control *wbc)
+{
+	return __ntfs_write_inode(vi, wbc->sync_mode == WB_SYNC_ALL);
+}
+#endif
+
 /**
  * The complete super operations.
  */
diff -puN fs/omfs/inode.c~fs-pass-writeback_control-to-write_inode fs/omfs/inode.c
--- a/fs/omfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/omfs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/parser.h>
 #include <linux/buffer_head.h>
 #include <linux/vmalloc.h>
+#include <linux/writeback.h>
 #include <linux/crc-itu-t.h>
 #include "omfs.h"
 
@@ -89,7 +90,7 @@ static void omfs_update_checksums(struct
 	oi->i_head.h_check_xor = xor;
 }
 
-static int omfs_write_inode(struct inode *inode, int wait)
+static int __omfs_write_inode(struct inode *inode, int wait)
 {
 	struct omfs_inode *oi;
 	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
@@ -162,9 +163,14 @@ out:
 	return ret;
 }
 
+static int omfs_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	return __omfs_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+}
+
 int omfs_sync_inode(struct inode *inode)
 {
-	return omfs_write_inode(inode, 1);
+	return __omfs_write_inode(inode, 1);
 }
 
 /*
diff -puN fs/reiserfs/inode.c~fs-pass-writeback_control-to-write_inode fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/reiserfs/inode.c
@@ -1613,7 +1613,7 @@ int reiserfs_encode_fh(struct dentry *de
 ** to properly mark inodes for datasync and such, but only actually
 ** does something when called for a synchronous update.
 */
-int reiserfs_write_inode(struct inode *inode, int do_sync)
+int reiserfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct reiserfs_transaction_handle th;
 	int jbegin_count = 1;
@@ -1625,7 +1625,7 @@ int reiserfs_write_inode(struct inode *i
 	 ** inode needs to reach disk for safety, and they can safely be
 	 ** ignored because the altered inode has already been logged.
 	 */
-	if (do_sync && !(current->flags & PF_MEMALLOC)) {
+	if (wbc->sync_mode == WB_SYNC_ALL && !(current->flags & PF_MEMALLOC)) {
 		reiserfs_write_lock(inode->i_sb);
 		if (!journal_begin(&th, inode->i_sb, jbegin_count)) {
 			reiserfs_update_sd(&th, inode);
diff -puN fs/sysv/inode.c~fs-pass-writeback_control-to-write_inode fs/sysv/inode.c
--- a/fs/sysv/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/sysv/inode.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/writeback.h>
 #include <linux/namei.h>
 #include <asm/byteorder.h>
 #include "sysv.h"
@@ -246,7 +247,7 @@ bad_inode:
 	return ERR_PTR(-EIO);
 }
 
-int sysv_write_inode(struct inode *inode, int wait)
+static int __sysv_write_inode(struct inode *inode, int wait)
 {
 	struct super_block * sb = inode->i_sb;
 	struct sysv_sb_info * sbi = SYSV_SB(sb);
@@ -296,9 +297,14 @@ int sysv_write_inode(struct inode *inode
 	return 0;
 }
 
+int sysv_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	return __sysv_write_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
+}
+
 int sysv_sync_inode(struct inode *inode)
 {
-	return sysv_write_inode(inode, 1);
+	return __sysv_write_inode(inode, 1);
 }
 
 static void sysv_delete_inode(struct inode *inode)
diff -puN fs/sysv/sysv.h~fs-pass-writeback_control-to-write_inode fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/sysv/sysv.h
@@ -142,7 +142,7 @@ extern int __sysv_write_begin(struct fil
 
 /* inode.c */
 extern struct inode *sysv_iget(struct super_block *, unsigned int);
-extern int sysv_write_inode(struct inode *, int);
+extern int sysv_write_inode(struct inode *, struct writeback_control *wbc);
 extern int sysv_sync_inode(struct inode *);
 extern void sysv_set_inode(struct inode *, dev_t);
 extern int sysv_getattr(struct vfsmount *, struct dentry *, struct kstat *);
diff -puN fs/ubifs/dir.c~fs-pass-writeback_control-to-write_inode fs/ubifs/dir.c
--- a/fs/ubifs/dir.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ubifs/dir.c
@@ -1120,7 +1120,7 @@ static int ubifs_rename(struct inode *ol
 	if (release)
 		ubifs_release_budget(c, &ino_req);
 	if (IS_SYNC(old_inode))
-		err = old_inode->i_sb->s_op->write_inode(old_inode, 1);
+		err = old_inode->i_sb->s_op->write_inode(old_inode, NULL);
 	return err;
 
 out_cancel:
diff -puN fs/ubifs/file.c~fs-pass-writeback_control-to-write_inode fs/ubifs/file.c
--- a/fs/ubifs/file.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ubifs/file.c
@@ -1011,7 +1011,7 @@ static int ubifs_writepage(struct page *
 	/* Is the page fully inside @i_size? */
 	if (page->index < end_index) {
 		if (page->index >= synced_i_size >> PAGE_CACHE_SHIFT) {
-			err = inode->i_sb->s_op->write_inode(inode, 1);
+			err = inode->i_sb->s_op->write_inode(inode, NULL);
 			if (err)
 				goto out_unlock;
 			/*
@@ -1039,7 +1039,7 @@ static int ubifs_writepage(struct page *
 	kunmap_atomic(kaddr, KM_USER0);
 
 	if (i_size > synced_i_size) {
-		err = inode->i_sb->s_op->write_inode(inode, 1);
+		err = inode->i_sb->s_op->write_inode(inode, NULL);
 		if (err)
 			goto out_unlock;
 	}
@@ -1242,7 +1242,7 @@ static int do_setattr(struct ubifs_info 
 	if (release)
 		ubifs_release_budget(c, &req);
 	if (IS_SYNC(inode))
-		err = inode->i_sb->s_op->write_inode(inode, 1);
+		err = inode->i_sb->s_op->write_inode(inode, NULL);
 	return err;
 
 out:
@@ -1316,7 +1316,7 @@ int ubifs_fsync(struct file *file, struc
 	 * the inode unless this is a 'datasync()' call.
 	 */
 	if (!datasync || (inode->i_state & I_DIRTY_DATASYNC)) {
-		err = inode->i_sb->s_op->write_inode(inode, 1);
+		err = inode->i_sb->s_op->write_inode(inode, NULL);
 		if (err)
 			return err;
 	}
diff -puN fs/ubifs/super.c~fs-pass-writeback_control-to-write_inode fs/ubifs/super.c
--- a/fs/ubifs/super.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ubifs/super.c
@@ -283,7 +283,7 @@ static void ubifs_destroy_inode(struct i
 /*
  * Note, Linux write-back code calls this without 'i_mutex'.
  */
-static int ubifs_write_inode(struct inode *inode, int wait)
+static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int err = 0;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
diff -puN fs/udf/inode.c~fs-pass-writeback_control-to-write_inode fs/udf/inode.c
--- a/fs/udf/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/udf/inode.c
@@ -1373,12 +1373,12 @@ static mode_t udf_convert_permissions(st
 	return mode;
 }
 
-int udf_write_inode(struct inode *inode, int sync)
+int udf_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 
 	lock_kernel();
-	ret = udf_update_inode(inode, sync);
+	ret = udf_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 	unlock_kernel();
 
 	return ret;
diff -puN fs/udf/udfdecl.h~fs-pass-writeback_control-to-write_inode fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/udf/udfdecl.h
@@ -142,7 +142,7 @@ extern void udf_truncate(struct inode *)
 extern void udf_read_inode(struct inode *);
 extern void udf_delete_inode(struct inode *);
 extern void udf_clear_inode(struct inode *);
-extern int udf_write_inode(struct inode *, int);
+extern int udf_write_inode(struct inode *, struct writeback_control *wbc);
 extern long udf_block_map(struct inode *, sector_t);
 extern int udf_extend_file(struct inode *, struct extent_position *,
 			   struct kernel_long_ad *, sector_t);
diff -puN fs/ufs/inode.c~fs-pass-writeback_control-to-write_inode fs/ufs/inode.c
--- a/fs/ufs/inode.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/ufs/inode.c
@@ -36,6 +36,7 @@
 #include <linux/mm.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/writeback.h>
 
 #include "ufs_fs.h"
 #include "ufs.h"
@@ -890,11 +891,11 @@ static int ufs_update_inode(struct inode
 	return 0;
 }
 
-int ufs_write_inode (struct inode * inode, int wait)
+int ufs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
 	lock_kernel();
-	ret = ufs_update_inode (inode, wait);
+	ret = ufs_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
 	unlock_kernel();
 	return ret;
 }
diff -puN fs/ufs/ufs.h~fs-pass-writeback_control-to-write_inode fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~fs-pass-writeback_control-to-write_inode
+++ a/fs/ufs/ufs.h
@@ -106,7 +106,7 @@ extern struct inode * ufs_new_inode (str
 
 /* inode.c */
 extern struct inode *ufs_iget(struct super_block *, unsigned long);
-extern int ufs_write_inode (struct inode *, int);
+extern int ufs_write_inode (struct inode *, struct writeback_control *);
 extern int ufs_sync_inode (struct inode *);
 extern void ufs_delete_inode (struct inode *);
 extern struct buffer_head * ufs_bread (struct inode *, unsigned, int, int *);
diff -puN fs/xfs/linux-2.6/xfs_super.c~fs-pass-writeback_control-to-write_inode fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~fs-pass-writeback_control-to-write_inode
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -1033,7 +1033,7 @@ xfs_fs_dirty_inode(
 STATIC int
 xfs_fs_write_inode(
 	struct inode		*inode,
-	int			sync)
+	struct writeback_control *wbc)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1057,7 +1057,7 @@ xfs_fs_write_inode(
 	 * This prevents the flush path from blocking on inodes inside
 	 * another operation right now, they get caught later by xfs_sync.
 	 */
-	if (sync) {
+	if (wbc->sync_mode == WB_SYNC_ALL) {
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		xfs_iflock(ip);
 
diff -puN include/linux/ext3_fs.h~fs-pass-writeback_control-to-write_inode include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~fs-pass-writeback_control-to-write_inode
+++ a/include/linux/ext3_fs.h
@@ -894,7 +894,7 @@ int ext3_get_blocks_handle(handle_t *han
 	int create);
 
 extern struct inode *ext3_iget(struct super_block *, unsigned long);
-extern int  ext3_write_inode (struct inode *, int);
+extern int  ext3_write_inode (struct inode *, struct writeback_control *);
 extern int  ext3_setattr (struct dentry *, struct iattr *);
 extern void ext3_delete_inode (struct inode *);
 extern int  ext3_sync_inode (handle_t *, struct inode *);
diff -puN include/linux/fs.h~fs-pass-writeback_control-to-write_inode include/linux/fs.h
--- a/include/linux/fs.h~fs-pass-writeback_control-to-write_inode
+++ a/include/linux/fs.h
@@ -1555,7 +1555,7 @@ struct super_operations {
 	void (*destroy_inode)(struct inode *);
 
    	void (*dirty_inode) (struct inode *);
-	int (*write_inode) (struct inode *, int);
+	int (*write_inode) (struct inode *, struct writeback_control *wbc);
 	void (*drop_inode) (struct inode *);
 	void (*delete_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
diff -puN include/linux/reiserfs_fs.h~fs-pass-writeback_control-to-write_inode include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~fs-pass-writeback_control-to-write_inode
+++ a/include/linux/reiserfs_fs.h
@@ -2034,7 +2034,7 @@ void reiserfs_read_locked_inode(struct i
 int reiserfs_find_actor(struct inode *inode, void *p);
 int reiserfs_init_locked_inode(struct inode *inode, void *p);
 void reiserfs_delete_inode(struct inode *inode);
-int reiserfs_write_inode(struct inode *inode, int);
+int reiserfs_write_inode(struct inode *inode, struct writeback_control *wbc);
 int reiserfs_get_block(struct inode *inode, sector_t block,
 		       struct buffer_head *bh_result, int create);
 struct dentry *reiserfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-pass-writeback_control-to-write_inode.patch
xtensa-convert-to-asm-generic-hardirqh.patch

