From: akpm@linux-foundation.org
Subject: + vfs-remove-get_xip_mem.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:10:58 -0800
Message-ID: <54b45482.LQG2y/rLmMx8ZBDB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbbALXLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:11:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: remove get_xip_mem
has been added to the -mm tree.  Its filename is
     vfs-remove-get_xip_mem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-remove-get_xip_mem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-remove-get_xip_mem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: vfs: remove get_xip_mem

All callers of get_xip_mem() are now gone.  Remove checks for it,
initialisers of it, documentation of it and the only implementation of it.
 Also remove mm/filemap_xip.c as it is now empty.  Also remove
documentation of the long-gone get_xip_page().

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    3 -
 Documentation/filesystems/vfs.txt |    7 ----
 fs/exofs/inode.c                  |    1 
 fs/ext2/inode.c                   |    1 
 fs/ext2/xip.c                     |   45 ----------------------------
 fs/ext2/xip.h                     |    3 -
 fs/open.c                         |    5 ---
 include/linux/fs.h                |    2 -
 include/linux/rmap.h              |    2 -
 mm/Makefile                       |    1 
 mm/fadvise.c                      |    6 ++-
 mm/filemap_xip.c                  |   23 --------------
 mm/madvise.c                      |    2 -
 13 files changed, 7 insertions(+), 94 deletions(-)

diff -puN Documentation/filesystems/Locking~vfs-remove-get_xip_mem Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~vfs-remove-get_xip_mem
+++ a/Documentation/filesystems/Locking
@@ -199,8 +199,6 @@ prototypes:
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
 	int (*direct_IO)(int, struct kiocb *, struct iov_iter *iter, loff_t offset);
-	int (*get_xip_mem)(struct address_space *, pgoff_t, int, void **,
-				unsigned long *);
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
 	int (*launder_page)(struct page *);
 	int (*is_partially_uptodate)(struct page *, unsigned long, unsigned long);
@@ -225,7 +223,6 @@ invalidatepage:		yes
 releasepage:		yes
 freepage:		yes
 direct_IO:
-get_xip_mem:					maybe
 migratepage:		yes (both)
 launder_page:		yes
 is_partially_uptodate:	yes
diff -puN Documentation/filesystems/vfs.txt~vfs-remove-get_xip_mem Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~vfs-remove-get_xip_mem
+++ a/Documentation/filesystems/vfs.txt
@@ -591,8 +591,6 @@ struct address_space_operations {
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter, loff_t offset);
-	struct page* (*get_xip_page)(struct address_space *, sector_t,
-			int);
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
 	int (*launder_page) (struct page *);
@@ -748,11 +746,6 @@ struct address_space_operations {
         and transfer data directly between the storage and the
         application's address space.
 
-  get_xip_page: called by the VM to translate a block number to a page.
-	The page is valid until the corresponding filesystem is unmounted.
-	Filesystems that want to use execute-in-place (XIP) need to implement
-	it.  An example implementation can be found in fs/ext2/xip.c.
-
   migrate_page:  This is used to compact the physical memory usage.
         If the VM wants to relocate a page (maybe off a memory card
         that is signalling imminent failure) it will pass a new page
diff -puN fs/exofs/inode.c~vfs-remove-get_xip_mem fs/exofs/inode.c
--- a/fs/exofs/inode.c~vfs-remove-get_xip_mem
+++ a/fs/exofs/inode.c
@@ -985,7 +985,6 @@ const struct address_space_operations ex
 	.direct_IO	= exofs_direct_IO,
 
 	/* With these NULL has special meaning or default is not exported */
-	.get_xip_mem	= NULL,
 	.migratepage	= NULL,
 	.launder_page	= NULL,
 	.is_partially_uptodate = NULL,
diff -puN fs/ext2/inode.c~vfs-remove-get_xip_mem fs/ext2/inode.c
--- a/fs/ext2/inode.c~vfs-remove-get_xip_mem
+++ a/fs/ext2/inode.c
@@ -894,7 +894,6 @@ const struct address_space_operations ex
 
 const struct address_space_operations ext2_aops_xip = {
 	.bmap			= ext2_bmap,
-	.get_xip_mem		= ext2_get_xip_mem,
 	.direct_IO		= ext2_direct_IO,
 };
 
diff -puN fs/ext2/xip.c~vfs-remove-get_xip_mem fs/ext2/xip.c
--- a/fs/ext2/xip.c~vfs-remove-get_xip_mem
+++ a/fs/ext2/xip.c
@@ -13,35 +13,6 @@
 #include "ext2.h"
 #include "xip.h"
 
-static inline long __inode_direct_access(struct inode *inode, sector_t block,
-				void **kaddr, unsigned long *pfn, long size)
-{
-	struct block_device *bdev = inode->i_sb->s_bdev;
-	sector_t sector = block * (PAGE_SIZE / 512);
-	return bdev_direct_access(bdev, sector, kaddr, pfn, size);
-}
-
-static inline int
-__ext2_get_block(struct inode *inode, pgoff_t pgoff, int create,
-		   sector_t *result)
-{
-	struct buffer_head tmp;
-	int rc;
-
-	memset(&tmp, 0, sizeof(struct buffer_head));
-	tmp.b_size = 1 << inode->i_blkbits;
-	rc = ext2_get_block(inode, pgoff, &tmp, create);
-	*result = tmp.b_blocknr;
-
-	/* did we get a sparse block (hole in the file)? */
-	if (!tmp.b_blocknr && !rc) {
-		BUG_ON(create);
-		rc = -ENODATA;
-	}
-
-	return rc;
-}
-
 void ext2_xip_verify_sb(struct super_block *sb)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
@@ -54,19 +25,3 @@ void ext2_xip_verify_sb(struct super_blo
 			     "not supported by bdev");
 	}
 }
-
-int ext2_get_xip_mem(struct address_space *mapping, pgoff_t pgoff, int create,
-				void **kmem, unsigned long *pfn)
-{
-	long rc;
-	sector_t block;
-
-	/* first, retrieve the sector number */
-	rc = __ext2_get_block(mapping->host, pgoff, create, &block);
-	if (rc)
-		return rc;
-
-	/* retrieve address of the target data */
-	rc = __inode_direct_access(mapping->host, block, kmem, pfn, PAGE_SIZE);
-	return (rc < 0) ? rc : 0;
-}
diff -puN fs/ext2/xip.h~vfs-remove-get_xip_mem fs/ext2/xip.h
--- a/fs/ext2/xip.h~vfs-remove-get_xip_mem
+++ a/fs/ext2/xip.h
@@ -12,10 +12,7 @@ static inline int ext2_use_xip (struct s
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	return (sbi->s_mount_opt & EXT2_MOUNT_XIP);
 }
-int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
-				void **, unsigned long *);
 #else
 #define ext2_xip_verify_sb(sb)			do { } while (0)
 #define ext2_use_xip(sb)			0
-#define ext2_get_xip_mem			NULL
 #endif
diff -puN fs/open.c~vfs-remove-get_xip_mem fs/open.c
--- a/fs/open.c~vfs-remove-get_xip_mem
+++ a/fs/open.c
@@ -667,11 +667,8 @@ int open_check_o_direct(struct file *f)
 {
 	/* NB: we're sure to have correct a_ops only after f_op->open */
 	if (f->f_flags & O_DIRECT) {
-		if (!f->f_mapping->a_ops ||
-		    ((!f->f_mapping->a_ops->direct_IO) &&
-		    (!f->f_mapping->a_ops->get_xip_mem))) {
+		if (!f->f_mapping->a_ops || !f->f_mapping->a_ops->direct_IO)
 			return -EINVAL;
-		}
 	}
 	return 0;
 }
diff -puN include/linux/fs.h~vfs-remove-get_xip_mem include/linux/fs.h
--- a/include/linux/fs.h~vfs-remove-get_xip_mem
+++ a/include/linux/fs.h
@@ -361,8 +361,6 @@ struct address_space_operations {
 	int (*releasepage) (struct page *, gfp_t);
 	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter, loff_t offset);
-	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
-						void **, unsigned long *);
 	/*
 	 * migrate the contents of a page to the specified target. If
 	 * migrate_mode is MIGRATE_ASYNC, it must not block.
diff -puN include/linux/rmap.h~vfs-remove-get_xip_mem include/linux/rmap.h
--- a/include/linux/rmap.h~vfs-remove-get_xip_mem
+++ a/include/linux/rmap.h
@@ -198,7 +198,7 @@ int page_referenced(struct page *, int i
 int try_to_unmap(struct page *, enum ttu_flags flags);
 
 /*
- * Called from mm/filemap_xip.c to unmap empty zero page
+ * Used by uprobes to replace a userspace page safely
  */
 pte_t *__page_check_address(struct page *, struct mm_struct *,
 				unsigned long, spinlock_t **, int);
diff -puN mm/Makefile~vfs-remove-get_xip_mem mm/Makefile
--- a/mm/Makefile~vfs-remove-get_xip_mem
+++ a/mm/Makefile
@@ -51,7 +51,6 @@ obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
-obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
diff -puN mm/fadvise.c~vfs-remove-get_xip_mem mm/fadvise.c
--- a/mm/fadvise.c~vfs-remove-get_xip_mem
+++ a/mm/fadvise.c
@@ -28,6 +28,7 @@
 SYSCALL_DEFINE4(fadvise64_64, int, fd, loff_t, offset, loff_t, len, int, advice)
 {
 	struct fd f = fdget(fd);
+	struct inode *inode;
 	struct address_space *mapping;
 	struct backing_dev_info *bdi;
 	loff_t endbyte;			/* inclusive */
@@ -39,7 +40,8 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 	if (!f.file)
 		return -EBADF;
 
-	if (S_ISFIFO(file_inode(f.file)->i_mode)) {
+	inode = file_inode(f.file);
+	if (S_ISFIFO(inode->i_mode)) {
 		ret = -ESPIPE;
 		goto out;
 	}
@@ -50,7 +52,7 @@ SYSCALL_DEFINE4(fadvise64_64, int, fd, l
 		goto out;
 	}
 
-	if (mapping->a_ops->get_xip_mem) {
+	if (IS_DAX(inode)) {
 		switch (advice) {
 		case POSIX_FADV_NORMAL:
 		case POSIX_FADV_RANDOM:
diff -puN mm/filemap_xip.c~vfs-remove-get_xip_mem /dev/null
--- a/mm/filemap_xip.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- *	linux/mm/filemap_xip.c
- *
- * Copyright (C) 2005 IBM Corporation
- * Author: Carsten Otte <cotte@de.ibm.com>
- *
- * derived from linux/mm/filemap.c - Copyright (C) Linus Torvalds
- *
- */
-
-#include <linux/fs.h>
-#include <linux/pagemap.h>
-#include <linux/export.h>
-#include <linux/uio.h>
-#include <linux/rmap.h>
-#include <linux/mmu_notifier.h>
-#include <linux/sched.h>
-#include <linux/seqlock.h>
-#include <linux/mutex.h>
-#include <linux/gfp.h>
-#include <asm/tlbflush.h>
-#include <asm/io.h>
-
diff -puN mm/madvise.c~vfs-remove-get_xip_mem mm/madvise.c
--- a/mm/madvise.c~vfs-remove-get_xip_mem
+++ a/mm/madvise.c
@@ -236,7 +236,7 @@ static long madvise_willneed(struct vm_a
 	if (!file)
 		return -EBADF;
 
-	if (file->f_mapping->a_ops->get_xip_mem) {
+	if (IS_DAX(file_inode(file))) {
 		/* no bad return value, but ignore advice */
 		return 0;
 	}
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

axonram-fix-bug-in-direct_access.patch
block-change-direct_access-calling-convention.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

