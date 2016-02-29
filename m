From: akpm@linux-foundation.org
Subject: [merged] dax-give-dax-clearing-code-correct-bdev.patch removed
 from -mm tree
Date: Mon, 29 Feb 2016 12:24:56 -0800
Message-ID: <56d4a918.83EWF5calx33bbP/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbcB2UY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 15:24:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@fb.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz, matthew.r.wilcox@intel.com, tytso@mit.edu, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: give DAX clearing code correct bdev
has been removed from the -mm tree.  Its filename was
     dax-give-dax-clearing-code-correct-bdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: give DAX clearing code correct bdev

dax_clear_blocks() needs a valid struct block_device and previously it was
using inode->i_sb->s_bdev in all cases.  This is correct for normal inodes
on mounted ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
block devices and for XFS real-time devices.

Instead, rename dax_clear_blocks() to dax_clear_sectors(), and change its
arguments to take a bdev and a sector instead of an inode and a block. 
This better reflects what the function does, and it allows the filesystem
and raw block device code to pass in an appropriate struct block_device.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c               |    9 ++++-----
 fs/ext2/inode.c        |    6 ++++--
 fs/xfs/xfs_aops.c      |    2 +-
 fs/xfs/xfs_aops.h      |    1 +
 fs/xfs/xfs_bmap_util.c |    3 ++-
 include/linux/dax.h    |    2 +-
 6 files changed, 13 insertions(+), 10 deletions(-)

diff -puN fs/dax.c~dax-give-dax-clearing-code-correct-bdev fs/dax.c
--- a/fs/dax.c~dax-give-dax-clearing-code-correct-bdev
+++ a/fs/dax.c
@@ -79,15 +79,14 @@ struct page *read_dax_sector(struct bloc
 }
 
 /*
- * dax_clear_blocks() is called from within transaction context from XFS,
+ * dax_clear_sectors() is called from within transaction context from XFS,
  * and hence this means the stack from this point must follow GFP_NOFS
  * semantics for all operations.
  */
-int dax_clear_blocks(struct inode *inode, sector_t block, long _size)
+int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size)
 {
-	struct block_device *bdev = inode->i_sb->s_bdev;
 	struct blk_dax_ctl dax = {
-		.sector = block << (inode->i_blkbits - 9),
+		.sector = _sector,
 		.size = _size,
 	};
 
@@ -109,7 +108,7 @@ int dax_clear_blocks(struct inode *inode
 	wmb_pmem();
 	return 0;
 }
-EXPORT_SYMBOL_GPL(dax_clear_blocks);
+EXPORT_SYMBOL_GPL(dax_clear_sectors);
 
 /* the clear_pmem() calls are ordered by a wmb_pmem() in the caller */
 static void dax_new_buf(void __pmem *addr, unsigned size, unsigned first,
diff -puN fs/ext2/inode.c~dax-give-dax-clearing-code-correct-bdev fs/ext2/inode.c
--- a/fs/ext2/inode.c~dax-give-dax-clearing-code-correct-bdev
+++ a/fs/ext2/inode.c
@@ -737,8 +737,10 @@ static int ext2_get_blocks(struct inode
 		 * so that it's not found by another thread before it's
 		 * initialised
 		 */
-		err = dax_clear_blocks(inode, le32_to_cpu(chain[depth-1].key),
-						1 << inode->i_blkbits);
+		err = dax_clear_sectors(inode->i_sb->s_bdev,
+				le32_to_cpu(chain[depth-1].key) <<
+				(inode->i_blkbits - 9),
+				1 << inode->i_blkbits);
 		if (err) {
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
diff -puN fs/xfs/xfs_aops.c~dax-give-dax-clearing-code-correct-bdev fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~dax-give-dax-clearing-code-correct-bdev
+++ a/fs/xfs/xfs_aops.c
@@ -55,7 +55,7 @@ xfs_count_page_state(
 	} while ((bh = bh->b_this_page) != head);
 }
 
-STATIC struct block_device *
+struct block_device *
 xfs_find_bdev_for_inode(
 	struct inode		*inode)
 {
diff -puN fs/xfs/xfs_aops.h~dax-give-dax-clearing-code-correct-bdev fs/xfs/xfs_aops.h
--- a/fs/xfs/xfs_aops.h~dax-give-dax-clearing-code-correct-bdev
+++ a/fs/xfs/xfs_aops.h
@@ -62,5 +62,6 @@ int	xfs_get_blocks_dax_fault(struct inod
 			         struct buffer_head *map_bh, int create);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
+extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
 
 #endif /* __XFS_AOPS_H__ */
diff -puN fs/xfs/xfs_bmap_util.c~dax-give-dax-clearing-code-correct-bdev fs/xfs/xfs_bmap_util.c
--- a/fs/xfs/xfs_bmap_util.c~dax-give-dax-clearing-code-correct-bdev
+++ a/fs/xfs/xfs_bmap_util.c
@@ -75,7 +75,8 @@ xfs_zero_extent(
 	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
 
 	if (IS_DAX(VFS_I(ip)))
-		return dax_clear_blocks(VFS_I(ip), block, size);
+		return dax_clear_sectors(xfs_find_bdev_for_inode(VFS_I(ip)),
+				sector, size);
 
 	/*
 	 * let the block layer decide on the fastest method of
diff -puN include/linux/dax.h~dax-give-dax-clearing-code-correct-bdev include/linux/dax.h
--- a/include/linux/dax.h~dax-give-dax-clearing-code-correct-bdev
+++ a/include/linux/dax.h
@@ -7,7 +7,7 @@
 
 ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 		  get_block_t, dio_iodone_t, int flags);
-int dax_clear_blocks(struct inode *, sector_t block, long size);
+int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


