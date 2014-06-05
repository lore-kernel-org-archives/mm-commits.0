From: akpm@linux-foundation.org
Subject: [merged]
 fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:34 -0700
Message-ID: <5390ca0a.mnCMwLWstqsQn1Ba%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaFETuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, dheeraj.reddy@intel.com, david@fromorbit.com, matthew.r.wilcox@intel.com

Subject: [merged] fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch removed from -mm tree
To: matthew.r.wilcox@intel.com,david@fromorbit.com,dheeraj.reddy@intel.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:34 -0700


The patch titled
     Subject: fs/block_dev.c: add bdev_read_page() and bdev_write_page()
has been removed from the -mm tree.  Its filename was
     fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: fs/block_dev.c: add bdev_read_page() and bdev_write_page()

A block device driver may choose to provide a rw_page operation.  These
will be called when the filesystem is attempting to do page sized I/O to
page cache pages (ie not for direct I/O).  This does preclude I/Os that
are larger than page size, so this may only be a performance gain for some
devices.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Tested-by: Dheeraj Reddy <dheeraj.reddy@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c         |   63 +++++++++++++++++++++++++++++++++++++++
 fs/mpage.c             |   12 +++++++
 include/linux/blkdev.h |    4 ++
 3 files changed, 79 insertions(+)

diff -puN fs/block_dev.c~fs-block_devc-add-bdev_read_page-and-bdev_write_page fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-add-bdev_read_page-and-bdev_write_page
+++ a/fs/block_dev.c
@@ -363,6 +363,69 @@ int blkdev_fsync(struct file *filp, loff
 }
 EXPORT_SYMBOL(blkdev_fsync);
 
+/**
+ * bdev_read_page() - Start reading a page from a block device
+ * @bdev: The device to read the page from
+ * @sector: The offset on the device to read the page to (need not be aligned)
+ * @page: The page to read
+ *
+ * On entry, the page should be locked.  It will be unlocked when the page
+ * has been read.  If the block driver implements rw_page synchronously,
+ * that will be true on exit from this function, but it need not be.
+ *
+ * Errors returned by this function are usually "soft", eg out of memory, or
+ * queue full; callers should try a different route to read this page rather
+ * than propagate an error back up the stack.
+ *
+ * Return: negative errno if an error occurs, 0 if submission was successful.
+ */
+int bdev_read_page(struct block_device *bdev, sector_t sector,
+			struct page *page)
+{
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	if (!ops->rw_page)
+		return -EOPNOTSUPP;
+	return ops->rw_page(bdev, sector + get_start_sect(bdev), page, READ);
+}
+EXPORT_SYMBOL_GPL(bdev_read_page);
+
+/**
+ * bdev_write_page() - Start writing a page to a block device
+ * @bdev: The device to write the page to
+ * @sector: The offset on the device to write the page to (need not be aligned)
+ * @page: The page to write
+ * @wbc: The writeback_control for the write
+ *
+ * On entry, the page should be locked and not currently under writeback.
+ * On exit, if the write started successfully, the page will be unlocked and
+ * under writeback.  If the write failed already (eg the driver failed to
+ * queue the page to the device), the page will still be locked.  If the
+ * caller is a ->writepage implementation, it will need to unlock the page.
+ *
+ * Errors returned by this function are usually "soft", eg out of memory, or
+ * queue full; callers should try a different route to write this page rather
+ * than propagate an error back up the stack.
+ *
+ * Return: negative errno if an error occurs, 0 if submission was successful.
+ */
+int bdev_write_page(struct block_device *bdev, sector_t sector,
+			struct page *page, struct writeback_control *wbc)
+{
+	int result;
+	int rw = (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	if (!ops->rw_page)
+		return -EOPNOTSUPP;
+	set_page_writeback(page);
+	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, rw);
+	if (result)
+		end_page_writeback(page);
+	else
+		unlock_page(page);
+	return result;
+}
+EXPORT_SYMBOL_GPL(bdev_write_page);
+
 /*
  * pseudo-fs
  */
diff -puN fs/mpage.c~fs-block_devc-add-bdev_read_page-and-bdev_write_page fs/mpage.c
--- a/fs/mpage.c~fs-block_devc-add-bdev_read_page-and-bdev_write_page
+++ a/fs/mpage.c
@@ -269,6 +269,11 @@ do_mpage_readpage(struct bio *bio, struc
 
 alloc_new:
 	if (bio == NULL) {
+		if (first_hole == blocks_per_page) {
+			if (!bdev_read_page(bdev, blocks[0] << (blkbits - 9),
+								page))
+				goto out;
+		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 			  	min_t(int, nr_pages, bio_get_nr_vecs(bdev)),
 				GFP_KERNEL);
@@ -587,6 +592,13 @@ page_is_mapped:
 
 alloc_new:
 	if (bio == NULL) {
+		if (first_unmapped == blocks_per_page) {
+			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
+								page, wbc)) {
+				clean_buffers(page, first_unmapped);
+				goto out;
+			}
+		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
 		if (bio == NULL)
diff -puN include/linux/blkdev.h~fs-block_devc-add-bdev_read_page-and-bdev_write_page include/linux/blkdev.h
--- a/include/linux/blkdev.h~fs-block_devc-add-bdev_read_page-and-bdev_write_page
+++ a/include/linux/blkdev.h
@@ -1588,6 +1588,7 @@ static inline bool blk_integrity_is_init
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
+	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*direct_access) (struct block_device *, sector_t,
@@ -1606,6 +1607,9 @@ struct block_device_operations {
 
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 				 unsigned long);
+extern int bdev_read_page(struct block_device *, sector_t, struct page *);
+extern int bdev_write_page(struct block_device *, sector_t, struct page *,
+						struct writeback_control *);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

