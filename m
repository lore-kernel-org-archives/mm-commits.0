From: akpm@linux-foundation.org
Subject: + qnx4-remove-write-support.patch added to -mm tree
Date: Mon, 24 Aug 2009 15:05:43 -0700
Message-ID: <200908242205.n7OM5hHI004740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbZHXWGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 18:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, al@alarsen.net, npiggin@suse.de


The patch titled
     qnx4: remove write support
has been added to the -mm tree.  Its filename is
     qnx4-remove-write-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qnx4: remove write support
From: Christoph Hellwig <hch@lst.de>

qnx4 has never been fully implement, is broken since the dawn of time and
hasn't been actively develped since before git history started.

Instead of letting it further bitrot and complicate API transition (like
the new truncate code) remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Anders Larsen <al@alarsen.net>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/Kconfig    |   11 ----
 fs/qnx4/Makefile   |    2 
 fs/qnx4/bitmap.c   |   81 ---------------------------------
 fs/qnx4/dir.c      |    5 --
 fs/qnx4/file.c     |   40 ----------------
 fs/qnx4/inode.c    |   84 ----------------------------------
 fs/qnx4/namei.c    |  105 -------------------------------------------
 fs/qnx4/qnx4.h     |    8 ---
 fs/qnx4/truncate.c |   34 -------------
 9 files changed, 2 insertions(+), 368 deletions(-)

diff -puN fs/qnx4/Kconfig~qnx4-remove-write-support fs/qnx4/Kconfig
--- a/fs/qnx4/Kconfig~qnx4-remove-write-support
+++ a/fs/qnx4/Kconfig
@@ -6,20 +6,9 @@ config QNX4FS_FS
 	  QNX 4 and QNX 6 (the latter is also called QNX RTP).
 	  Further information is available at <http://www.qnx.com/>.
 	  Say Y if you intend to mount QNX hard disks or floppies.
-	  Unless you say Y to "QNX4FS read-write support" below, you will
-	  only be able to read these file systems.
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called qnx4.
 
 	  If you don't know whether you need it, then you don't need it:
 	  answer N.
-
-config QNX4FS_RW
-	bool "QNX4FS write support (DANGEROUS)"
-	depends on QNX4FS_FS && EXPERIMENTAL && BROKEN
-	help
-	  Say Y if you want to test write support for QNX4 file systems.
-
-	  It's currently broken, so for now:
-	  answer N.
diff -puN fs/qnx4/Makefile~qnx4-remove-write-support fs/qnx4/Makefile
--- a/fs/qnx4/Makefile~qnx4-remove-write-support
+++ a/fs/qnx4/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_QNX4FS_FS) += qnx4.o
 
-qnx4-objs := inode.o dir.o namei.o file.o bitmap.o truncate.o
+qnx4-objs := inode.o dir.o namei.o bitmap.o
diff -puN fs/qnx4/bitmap.c~qnx4-remove-write-support fs/qnx4/bitmap.c
--- a/fs/qnx4/bitmap.c~qnx4-remove-write-support
+++ a/fs/qnx4/bitmap.c
@@ -78,84 +78,3 @@ unsigned long qnx4_count_free_blocks(str
 
 	return total_free;
 }
-
-#ifdef CONFIG_QNX4FS_RW
-
-int qnx4_is_free(struct super_block *sb, long block)
-{
-	int start = le32_to_cpu(qnx4_sb(sb)->BitMap->di_first_xtnt.xtnt_blk) - 1;
-	int size = le32_to_cpu(qnx4_sb(sb)->BitMap->di_size);
-	struct buffer_head *bh;
-	const char *g;
-	int ret = -EIO;
-
-	start += block / (QNX4_BLOCK_SIZE * 8);
-	QNX4DEBUG(("qnx4: is_free requesting block [%lu], bitmap in block [%lu]\n",
-		   (unsigned long) block, (unsigned long) start));
-	(void) size;		/* CHECKME */
-	bh = sb_bread(sb, start);
-	if (bh == NULL) {
-		return -EIO;
-	}
-	g = bh->b_data + (block % QNX4_BLOCK_SIZE);
-	if (((*g) & (1 << (block % 8))) == 0) {
-		QNX4DEBUG(("qnx4: is_free -> block is free\n"));
-		ret = 1;
-	} else {
-		QNX4DEBUG(("qnx4: is_free -> block is busy\n"));
-		ret = 0;
-	}
-	brelse(bh);
-
-	return ret;
-}
-
-int qnx4_set_bitmap(struct super_block *sb, long block, int busy)
-{
-	int start = le32_to_cpu(qnx4_sb(sb)->BitMap->di_first_xtnt.xtnt_blk) - 1;
-	int size = le32_to_cpu(qnx4_sb(sb)->BitMap->di_size);
-	struct buffer_head *bh;
-	char *g;
-
-	start += block / (QNX4_BLOCK_SIZE * 8);
-	QNX4DEBUG(("qnx4: set_bitmap requesting block [%lu], bitmap in block [%lu]\n",
-		   (unsigned long) block, (unsigned long) start));
-	(void) size;		/* CHECKME */
-	bh = sb_bread(sb, start);
-	if (bh == NULL) {
-		return -EIO;
-	}
-	g = bh->b_data + (block % QNX4_BLOCK_SIZE);
-	if (busy == 0) {
-		(*g) &= ~(1 << (block % 8));
-	} else {
-		(*g) |= (1 << (block % 8));
-	}
-	mark_buffer_dirty(bh);
-	brelse(bh);
-
-	return 0;
-}
-
-static void qnx4_clear_inode(struct inode *inode)
-{
-	struct qnx4_inode_entry *qnx4_ino = qnx4_raw_inode(inode);
-	/* What for? */
-	memset(qnx4_ino->di_fname, 0, sizeof qnx4_ino->di_fname);
-	qnx4_ino->di_size = 0;
-	qnx4_ino->di_num_xtnts = 0;
-	qnx4_ino->di_mode = 0;
-	qnx4_ino->di_status = 0;
-}
-
-void qnx4_free_inode(struct inode *inode)
-{
-	if (inode->i_ino < 1) {
-		printk("free_inode: inode 0 or nonexistent inode\n");
-		return;
-	}
-	qnx4_clear_inode(inode);
-	clear_inode(inode);
-}
-
-#endif
diff -puN fs/qnx4/dir.c~qnx4-remove-write-support fs/qnx4/dir.c
--- a/fs/qnx4/dir.c~qnx4-remove-write-support
+++ a/fs/qnx4/dir.c
@@ -85,9 +85,4 @@ const struct file_operations qnx4_dir_op
 const struct inode_operations qnx4_dir_inode_operations =
 {
 	.lookup		= qnx4_lookup,
-#ifdef CONFIG_QNX4FS_RW
-	.create		= qnx4_create,
-	.unlink		= qnx4_unlink,
-	.rmdir		= qnx4_rmdir,
-#endif
 };
diff -puN fs/qnx4/file.c~qnx4-remove-write-support /dev/null
--- a/fs/qnx4/file.c
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * QNX4 file system, Linux implementation.
- *
- * Version : 0.2.1
- *
- * Using parts of the xiafs filesystem.
- *
- * History :
- *
- * 25-05-1998 by Richard Frowijn : first release.
- * 21-06-1998 by Frank Denis : wrote qnx4_readpage to use generic_file_read.
- * 27-06-1998 by Frank Denis : file overwriting.
- */
-
-#include "qnx4.h"
-
-/*
- * We have mostly NULL's here: the current defaults are ok for
- * the qnx4 filesystem.
- */
-const struct file_operations qnx4_file_operations =
-{
-	.llseek		= generic_file_llseek,
-	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
-	.mmap		= generic_file_mmap,
-	.splice_read	= generic_file_splice_read,
-#ifdef CONFIG_QNX4FS_RW
-	.write		= do_sync_write,
-	.aio_write	= generic_file_aio_write,
-	.fsync		= simple_fsync,
-#endif
-};
-
-const struct inode_operations qnx4_file_inode_operations =
-{
-#ifdef CONFIG_QNX4FS_RW
-	.truncate	= qnx4_truncate,
-#endif
-};
diff -puN fs/qnx4/inode.c~qnx4-remove-write-support fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~qnx4-remove-write-support
+++ a/fs/qnx4/inode.c
@@ -28,73 +28,6 @@
 
 static const struct super_operations qnx4_sops;
 
-#ifdef CONFIG_QNX4FS_RW
-
-static void qnx4_delete_inode(struct inode *inode)
-{
-	QNX4DEBUG(("qnx4: deleting inode [%lu]\n", (unsigned long) inode->i_ino));
-	truncate_inode_pages(&inode->i_data, 0);
-	inode->i_size = 0;
-	qnx4_truncate(inode);
-	lock_kernel();
-	qnx4_free_inode(inode);
-	unlock_kernel();
-}
-
-static int qnx4_write_inode(struct inode *inode, int do_sync)
-{
-	struct qnx4_inode_entry *raw_inode;
-	int block, ino;
-	struct buffer_head *bh;
-	ino = inode->i_ino;
-
-	QNX4DEBUG(("qnx4: write inode 1.\n"));
-	if (inode->i_nlink == 0) {
-		return 0;
-	}
-	if (!ino) {
-		printk("qnx4: bad inode number on dev %s: %d is out of range\n",
-		       inode->i_sb->s_id, ino);
-		return -EIO;
-	}
-	QNX4DEBUG(("qnx4: write inode 2.\n"));
-	block = ino / QNX4_INODES_PER_BLOCK;
-	lock_kernel();
-	if (!(bh = sb_bread(inode->i_sb, block))) {
-		printk("qnx4: major problem: unable to read inode from dev "
-		       "%s\n", inode->i_sb->s_id);
-		unlock_kernel();
-		return -EIO;
-	}
-	raw_inode = ((struct qnx4_inode_entry *) bh->b_data) +
-	    (ino % QNX4_INODES_PER_BLOCK);
-	raw_inode->di_mode  = cpu_to_le16(inode->i_mode);
-	raw_inode->di_uid   = cpu_to_le16(fs_high2lowuid(inode->i_uid));
-	raw_inode->di_gid   = cpu_to_le16(fs_high2lowgid(inode->i_gid));
-	raw_inode->di_nlink = cpu_to_le16(inode->i_nlink);
-	raw_inode->di_size  = cpu_to_le32(inode->i_size);
-	raw_inode->di_mtime = cpu_to_le32(inode->i_mtime.tv_sec);
-	raw_inode->di_atime = cpu_to_le32(inode->i_atime.tv_sec);
-	raw_inode->di_ctime = cpu_to_le32(inode->i_ctime.tv_sec);
-	raw_inode->di_first_xtnt.xtnt_size = cpu_to_le32(inode->i_blocks);
-	mark_buffer_dirty(bh);
-	if (do_sync) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			printk("qnx4: IO error syncing inode [%s:%08x]\n",
-					inode->i_sb->s_id, ino);
-			brelse(bh);
-			unlock_kernel();
-			return -EIO;
-		}
-	}
-	brelse(bh);
-	unlock_kernel();
-	return 0;
-}
-
-#endif
-
 static void qnx4_put_super(struct super_block *sb);
 static struct inode *qnx4_alloc_inode(struct super_block *sb);
 static void qnx4_destroy_inode(struct inode *inode);
@@ -108,10 +41,6 @@ static const struct super_operations qnx
 	.put_super	= qnx4_put_super,
 	.statfs		= qnx4_statfs,
 	.remount_fs	= qnx4_remount,
-#ifdef CONFIG_QNX4FS_RW
-	.write_inode	= qnx4_write_inode,
-	.delete_inode	= qnx4_delete_inode,
-#endif
 };
 
 static int qnx4_remount(struct super_block *sb, int *flags, char *data)
@@ -120,15 +49,7 @@ static int qnx4_remount(struct super_blo
 
 	qs = qnx4_sb(sb);
 	qs->Version = QNX4_VERSION;
-#ifndef CONFIG_QNX4FS_RW
 	*flags |= MS_RDONLY;
-#endif
-	if (*flags & MS_RDONLY) {
-		return 0;
-	}
-
-	mark_buffer_dirty(qs->sb_buf);
-
 	return 0;
 }
 
@@ -354,9 +275,7 @@ static int qnx4_fill_super(struct super_
 	}
 	s->s_op = &qnx4_sops;
 	s->s_magic = QNX4_SUPER_MAGIC;
-#ifndef CONFIG_QNX4FS_RW
 	s->s_flags |= MS_RDONLY;	/* Yup, read-only yet */
-#endif
 	qnx4_sb(s)->sb_buf = bh;
 	qnx4_sb(s)->sb = (struct qnx4_super_block *) bh->b_data;
 
@@ -489,8 +408,7 @@ struct inode *qnx4_iget(struct super_blo
 
 	memcpy(qnx4_inode, raw_inode, QNX4_DIR_ENTRY_SIZE);
 	if (S_ISREG(inode->i_mode)) {
-		inode->i_op = &qnx4_file_inode_operations;
-		inode->i_fop = &qnx4_file_operations;
+		inode->i_fop = &generic_ro_fops;
 		inode->i_mapping->a_ops = &qnx4_aops;
 		qnx4_i(inode)->mmu_private = inode->i_size;
 	} else if (S_ISDIR(inode->i_mode)) {
diff -puN fs/qnx4/namei.c~qnx4-remove-write-support fs/qnx4/namei.c
--- a/fs/qnx4/namei.c~qnx4-remove-write-support
+++ a/fs/qnx4/namei.c
@@ -134,108 +134,3 @@ out:
 
 	return NULL;
 }
-
-#ifdef CONFIG_QNX4FS_RW
-int qnx4_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
-{
-	QNX4DEBUG(("qnx4: qnx4_create\n"));
-	if (dir == NULL) {
-		return -ENOENT;
-	}
-	return -ENOSPC;
-}
-
-int qnx4_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	struct buffer_head *bh;
-	struct qnx4_inode_entry *de;
-	struct inode *inode;
-	int retval;
-	int ino;
-
-	QNX4DEBUG(("qnx4: qnx4_rmdir [%s]\n", dentry->d_name.name));
-	lock_kernel();
-	bh = qnx4_find_entry(dentry->d_name.len, dir, dentry->d_name.name,
-			     &de, &ino);
-	if (bh == NULL) {
-		unlock_kernel();
-		return -ENOENT;
-	}
-	inode = dentry->d_inode;
-	if (inode->i_ino != ino) {
-		retval = -EIO;
-		goto end_rmdir;
-	}
-#if 0
-	if (!empty_dir(inode)) {
-		retval = -ENOTEMPTY;
-		goto end_rmdir;
-	}
-#endif
-	if (inode->i_nlink != 2) {
-		QNX4DEBUG(("empty directory has nlink!=2 (%d)\n", inode->i_nlink));
-	}
-	QNX4DEBUG(("qnx4: deleting directory\n"));
-	de->di_status = 0;
-	memset(de->di_fname, 0, sizeof de->di_fname);
-	de->di_mode = 0;
-	mark_buffer_dirty_inode(bh, dir);
-	clear_nlink(inode);
-	mark_inode_dirty(inode);
-	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
-	inode_dec_link_count(dir);
-	retval = 0;
-
-      end_rmdir:
-	brelse(bh);
-
-	unlock_kernel();
-	return retval;
-}
-
-int qnx4_unlink(struct inode *dir, struct dentry *dentry)
-{
-	struct buffer_head *bh;
-	struct qnx4_inode_entry *de;
-	struct inode *inode;
-	int retval;
-	int ino;
-
-	QNX4DEBUG(("qnx4: qnx4_unlink [%s]\n", dentry->d_name.name));
-	lock_kernel();
-	bh = qnx4_find_entry(dentry->d_name.len, dir, dentry->d_name.name,
-			     &de, &ino);
-	if (bh == NULL) {
-		unlock_kernel();
-		return -ENOENT;
-	}
-	inode = dentry->d_inode;
-	if (inode->i_ino != ino) {
-		retval = -EIO;
-		goto end_unlink;
-	}
-	retval = -EPERM;
-	if (!inode->i_nlink) {
-		QNX4DEBUG(("Deleting nonexistent file (%s:%lu), %d\n",
-			   inode->i_sb->s_id,
-			   inode->i_ino, inode->i_nlink));
-		inode->i_nlink = 1;
-	}
-	de->di_status = 0;
-	memset(de->di_fname, 0, sizeof de->di_fname);
-	de->di_mode = 0;
-	mark_buffer_dirty_inode(bh, dir);
-	dir->i_ctime = dir->i_mtime = CURRENT_TIME_SEC;
-	mark_inode_dirty(dir);
-	inode->i_ctime = dir->i_ctime;
-	inode_dec_link_count(inode);
-	retval = 0;
-
-end_unlink:
-	unlock_kernel();
-	brelse(bh);
-
-	return retval;
-}
-#endif
diff -puN fs/qnx4/qnx4.h~qnx4-remove-write-support fs/qnx4/qnx4.h
--- a/fs/qnx4/qnx4.h~qnx4-remove-write-support
+++ a/fs/qnx4/qnx4.h
@@ -29,17 +29,9 @@ extern unsigned long qnx4_block_map(stru
 
 extern struct buffer_head *qnx4_bread(struct inode *, int, int);
 
-extern const struct inode_operations qnx4_file_inode_operations;
 extern const struct inode_operations qnx4_dir_inode_operations;
-extern const struct file_operations qnx4_file_operations;
 extern const struct file_operations qnx4_dir_operations;
 extern int qnx4_is_free(struct super_block *sb, long block);
-extern int qnx4_set_bitmap(struct super_block *sb, long block, int busy);
-extern int qnx4_create(struct inode *inode, struct dentry *dentry, int mode, struct nameidata *nd);
-extern void qnx4_truncate(struct inode *inode);
-extern void qnx4_free_inode(struct inode *inode);
-extern int qnx4_unlink(struct inode *dir, struct dentry *dentry);
-extern int qnx4_rmdir(struct inode *dir, struct dentry *dentry);
 
 static inline struct qnx4_sb_info *qnx4_sb(struct super_block *sb)
 {
diff -puN fs/qnx4/truncate.c~qnx4-remove-write-support /dev/null
--- a/fs/qnx4/truncate.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/* 
- * QNX4 file system, Linux implementation.
- * 
- * Version : 0.1
- * 
- * Using parts of the xiafs filesystem.
- * 
- * History :
- * 
- * 30-06-1998 by Frank DENIS : ugly filler.
- */
-
-#include <linux/smp_lock.h>
-#include "qnx4.h"
-
-#ifdef CONFIG_QNX4FS_RW
-
-void qnx4_truncate(struct inode *inode)
-{
-	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
-	      S_ISLNK(inode->i_mode))) {
-		return;
-	}
-	lock_kernel();
-	if (!(S_ISDIR(inode->i_mode))) {
-		/* TODO */
-	}
-	QNX4DEBUG(("qnx4: qnx4_truncate called\n"));
-	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
-	mark_inode_dirty(inode);
-	unlock_kernel();
-}
-
-#endif
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
avr32-convert-to-asm-generic-hardirqh.patch
sparc32-convert-to-asm-generic-hardirqh.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-fix-d_path-for-unreachable-paths.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
xtensa-convert-to-asm-generic-hardirqh.patch
frv-convert-to-asm-generic-hardirqh.patch
h8300-convert-to-asm-generic-hardirqh.patch
alpha-convert-to-asm-generic-hardirqh.patch
m32r-convert-to-asm-generic-hardirqh.patch
m68k-convert-to-asm-generic-hardirqh.patch
cris-convert-to-asm-generic-hardirqh.patch
um-convert-to-asm-generic-hardirqh.patch
fs-turn-iprune_mutex-into-rwsem.patch
ntfs-remove-ntfs_file_write.patch
qnx4-remove-write-support.patch
fcntl-add-f_etown_ex.patch

