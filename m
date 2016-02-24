From: akpm@linux-foundation.org
Subject: + dax-move-writeback-calls-into-the-filesystems.patch added to
 -mm tree
Date: Wed, 24 Feb 2016 14:27:23 -0800
Message-ID: <56ce2e4b.EY/IFPMC9Tb2S5yv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbcBXW1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2016 17:27:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@fb.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz, matthew.r.wilcox@intel.com, tytso@mit.edu, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: move writeback calls into the filesystems
has been added to the -mm tree.  Its filename is
     dax-move-writeback-calls-into-the-filesystems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-move-writeback-calls-into-the-filesystems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-move-writeback-calls-into-the-filesystems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: move writeback calls into the filesystems

Previously calls to dax_writeback_mapping_range() for all DAX filesystems
(ext2, ext4 & xfs) were centralized in filemap_write_and_wait_range(). 
dax_writeback_mapping_range() needs a struct block_device, and it used to
get that from inode->i_sb->s_bdev.  This is correct for normal inodes
mounted on ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
block devices and for XFS real-time files.

Instead, call dax_writeback_mapping_range() directly from the filesystem
->writepages function so that it can supply us with a valid block device. 
This also fixes DAX code to properly flush caches in response to sync(2).

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c      |   13 ++++++++++++-
 fs/dax.c            |   12 +++++++-----
 fs/ext2/inode.c     |    8 ++++++++
 fs/ext4/inode.c     |    4 ++++
 fs/xfs/xfs_aops.c   |    4 ++++
 include/linux/dax.h |    6 ++++--
 mm/filemap.c        |   12 ++++--------
 7 files changed, 43 insertions(+), 16 deletions(-)

diff -puN fs/block_dev.c~dax-move-writeback-calls-into-the-filesystems fs/block_dev.c
--- a/fs/block_dev.c~dax-move-writeback-calls-into-the-filesystems
+++ a/fs/block_dev.c
@@ -1697,13 +1697,24 @@ static int blkdev_releasepage(struct pag
 	return try_to_free_buffers(page);
 }
 
+static int blkdev_writepages(struct address_space *mapping,
+			     struct writeback_control *wbc)
+{
+	if (dax_mapping(mapping)) {
+		struct block_device *bdev = I_BDEV(mapping->host);
+
+		return dax_writeback_mapping_range(mapping, bdev, wbc);
+	}
+	return generic_writepages(mapping, wbc);
+}
+
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.readpages	= blkdev_readpages,
 	.writepage	= blkdev_writepage,
 	.write_begin	= blkdev_write_begin,
 	.write_end	= blkdev_write_end,
-	.writepages	= generic_writepages,
+	.writepages	= blkdev_writepages,
 	.releasepage	= blkdev_releasepage,
 	.direct_IO	= blkdev_direct_IO,
 	.is_dirty_writeback = buffer_check_dirty_writeback,
diff -puN fs/dax.c~dax-move-writeback-calls-into-the-filesystems fs/dax.c
--- a/fs/dax.c~dax-move-writeback-calls-into-the-filesystems
+++ a/fs/dax.c
@@ -484,11 +484,10 @@ static int dax_writeback_one(struct bloc
  * end]. This is required by data integrity operations to ensure file data is
  * on persistent storage prior to completion of the operation.
  */
-int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
-		loff_t end)
+int dax_writeback_mapping_range(struct address_space *mapping,
+		struct block_device *bdev, struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	struct block_device *bdev = inode->i_sb->s_bdev;
 	pgoff_t start_index, end_index, pmd_index;
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
@@ -499,8 +498,11 @@ int dax_writeback_mapping_range(struct a
 	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
 		return -EIO;
 
-	start_index = start >> PAGE_CACHE_SHIFT;
-	end_index = end >> PAGE_CACHE_SHIFT;
+	if (!mapping->nrexceptional || wbc->sync_mode != WB_SYNC_ALL)
+		return 0;
+
+	start_index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end_index = wbc->range_end >> PAGE_CACHE_SHIFT;
 	pmd_index = DAX_PMD_INDEX(start_index);
 
 	rcu_read_lock();
diff -puN fs/ext2/inode.c~dax-move-writeback-calls-into-the-filesystems fs/ext2/inode.c
--- a/fs/ext2/inode.c~dax-move-writeback-calls-into-the-filesystems
+++ a/fs/ext2/inode.c
@@ -876,6 +876,14 @@ ext2_direct_IO(struct kiocb *iocb, struc
 static int
 ext2_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
+#ifdef CONFIG_FS_DAX
+	if (dax_mapping(mapping)) {
+		return dax_writeback_mapping_range(mapping,
+						   mapping->host->i_sb->s_bdev,
+						   wbc);
+	}
+#endif
+
 	return mpage_writepages(mapping, wbc, ext2_get_block);
 }
 
diff -puN fs/ext4/inode.c~dax-move-writeback-calls-into-the-filesystems fs/ext4/inode.c
--- a/fs/ext4/inode.c~dax-move-writeback-calls-into-the-filesystems
+++ a/fs/ext4/inode.c
@@ -2478,6 +2478,10 @@ static int ext4_writepages(struct addres
 
 	trace_ext4_writepages(inode, wbc);
 
+	if (dax_mapping(mapping))
+		return dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev,
+						   wbc);
+
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
 	 * a transaction for special inodes like journal inode on last iput()
diff -puN fs/xfs/xfs_aops.c~dax-move-writeback-calls-into-the-filesystems fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~dax-move-writeback-calls-into-the-filesystems
+++ a/fs/xfs/xfs_aops.c
@@ -1208,6 +1208,10 @@ xfs_vm_writepages(
 	struct writeback_control *wbc)
 {
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	if (dax_mapping(mapping))
+		return dax_writeback_mapping_range(mapping,
+				xfs_find_bdev_for_inode(mapping->host), wbc);
+
 	return generic_writepages(mapping, wbc);
 }
 
diff -puN include/linux/dax.h~dax-move-writeback-calls-into-the-filesystems include/linux/dax.h
--- a/include/linux/dax.h~dax-move-writeback-calls-into-the-filesystems
+++ a/include/linux/dax.h
@@ -52,6 +52,8 @@ static inline bool dax_mapping(struct ad
 {
 	return mapping->host && IS_DAX(mapping->host);
 }
-int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
-		loff_t end);
+
+struct writeback_control;
+int dax_writeback_mapping_range(struct address_space *mapping,
+		struct block_device *bdev, struct writeback_control *wbc);
 #endif
diff -puN mm/filemap.c~dax-move-writeback-calls-into-the-filesystems mm/filemap.c
--- a/mm/filemap.c~dax-move-writeback-calls-into-the-filesystems
+++ a/mm/filemap.c
@@ -446,7 +446,8 @@ int filemap_write_and_wait(struct addres
 {
 	int err = 0;
 
-	if (mapping->nrpages) {
+	if ((!dax_mapping(mapping) && mapping->nrpages) ||
+	    (dax_mapping(mapping) && mapping->nrexceptional)) {
 		err = filemap_fdatawrite(mapping);
 		/*
 		 * Even if the above returned error, the pages may be
@@ -482,13 +483,8 @@ int filemap_write_and_wait_range(struct
 {
 	int err = 0;
 
-	if (dax_mapping(mapping) && mapping->nrexceptional) {
-		err = dax_writeback_mapping_range(mapping, lstart, lend);
-		if (err)
-			return err;
-	}
