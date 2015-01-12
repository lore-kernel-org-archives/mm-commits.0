From: akpm@linux-foundation.org
Subject: +
 daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch added to
 -mm tree
Date: Mon, 12 Jan 2015 15:10:47 -0800
Message-ID: <54b45477.UgyDRvOzdVONYbTU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbbALXKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax,ext2: replace ext2_clear_xip_target with dax_clear_blocks
has been added to the -mm tree.  Its filename is
     daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch

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
Subject: dax,ext2: replace ext2_clear_xip_target with dax_clear_blocks

This is practically generic code; other filesystems will want to call it
from other places, but there's nothing ext2-specific about it.

Make it a little more generic by allowing it to take a count of the number
of bytes to zero rather than fixing it to a single page.  Thanks to Dave
Hansen for suggesting that I need to call cond_resched() if zeroing more
than one page.

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

 fs/dax.c           |   37 +++++++++++++++++++++++++++++++++++++
 fs/ext2/inode.c    |    8 +++++---
 fs/ext2/xip.c      |   14 --------------
 fs/ext2/xip.h      |    3 ---
 include/linux/fs.h |    1 +
 5 files changed, 43 insertions(+), 20 deletions(-)

diff -puN fs/dax.c~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks fs/dax.c
--- a/fs/dax.c~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks
+++ a/fs/dax.c
@@ -20,8 +20,45 @@
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/uio.h>
 
+int dax_clear_blocks(struct inode *inode, sector_t block, long size)
+{
+	struct block_device *bdev = inode->i_sb->s_bdev;
+	sector_t sector = block << (inode->i_blkbits - 9);
+
+	might_sleep();
+	do {
+		void *addr;
+		unsigned long pfn;
+		long count;
+
+		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
+		if (count < 0)
+			return count;
+		BUG_ON(size < count);
+		while (count > 0) {
+			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
+			if (pgsz > count)
+				pgsz = count;
+			if (pgsz < PAGE_SIZE)
+				memset(addr, 0, pgsz);
+			else
+				clear_page(addr);
+			addr += pgsz;
+			size -= pgsz;
+			count -= pgsz;
+			BUG_ON(pgsz & 511);
+			sector += pgsz / 512;
+			cond_resched();
+		}
+	} while (size);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dax_clear_blocks);
+
 static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
 {
 	unsigned long pfn;
diff -puN fs/ext2/inode.c~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks fs/ext2/inode.c
--- a/fs/ext2/inode.c~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks
+++ a/fs/ext2/inode.c
@@ -733,10 +733,12 @@ static int ext2_get_blocks(struct inode
 
 	if (IS_DAX(inode)) {
 		/*
-		 * we need to clear the block
+		 * block must be initialised before we put it in the tree
+		 * so that it's not found by another thread before it's
+		 * initialised
 		 */
-		err = ext2_clear_xip_target (inode,
-			le32_to_cpu(chain[depth-1].key));
+		err = dax_clear_blocks(inode, le32_to_cpu(chain[depth-1].key),
+						1 << inode->i_blkbits);
 		if (err) {
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
diff -puN fs/ext2/xip.c~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks fs/ext2/xip.c
--- a/fs/ext2/xip.c~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks
+++ a/fs/ext2/xip.c
@@ -42,20 +42,6 @@ __ext2_get_block(struct inode *inode, pg
 	return rc;
 }
 
-int
-ext2_clear_xip_target(struct inode *inode, sector_t block)
-{
-	void *kaddr;
-	unsigned long pfn;
-	long size;
-
-	size = __inode_direct_access(inode, block, &kaddr, &pfn, PAGE_SIZE);
-	if (size < 0)
-		return size;
-	clear_page(kaddr);
-	return 0;
-}
-
 void ext2_xip_verify_sb(struct super_block *sb)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
diff -puN fs/ext2/xip.h~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks fs/ext2/xip.h
--- a/fs/ext2/xip.h~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks
+++ a/fs/ext2/xip.h
@@ -7,8 +7,6 @@
 
 #ifdef CONFIG_EXT2_FS_XIP
 extern void ext2_xip_verify_sb (struct super_block *);
-extern int ext2_clear_xip_target (struct inode *, sector_t);
-
 static inline int ext2_use_xip (struct super_block *sb)
 {
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
@@ -19,6 +17,5 @@ int ext2_get_xip_mem(struct address_spac
 #else
 #define ext2_xip_verify_sb(sb)			do { } while (0)
 #define ext2_use_xip(sb)			0
-#define ext2_clear_xip_target(inode, chain)	0
 #define ext2_get_xip_mem			NULL
 #endif
diff -puN include/linux/fs.h~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks include/linux/fs.h
--- a/include/linux/fs.h~daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks
+++ a/include/linux/fs.h
@@ -2535,6 +2535,7 @@ extern int nonseekable_open(struct inode
 
 ssize_t dax_do_io(int rw, struct kiocb *, struct inode *, struct iov_iter *,
 		loff_t, get_block_t, dio_iodone_t, int flags);
+int dax_clear_blocks(struct inode *, sector_t block, long size);
 
 #ifdef CONFIG_FS_XIP
 extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
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

