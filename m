From: akpm@linux-foundation.org
Subject: - block-dont-take-lock-while-changing-ra_pages.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:08 -0800
Message-ID: <200812011949.mB1Jn8SJ025082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYLATtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, jens.axboe@oracle.com, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     block: don't take lock while changing ra_pages
has been removed from the -mm tree.  Its filename was
     block-dont-take-lock-while-changing-ra_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: don't take lock while changing ra_pages
From: Wu Fengguang <fengguang.wu@intel.com>

There's no need to take queue_lock or kernel_lock when modifying
bdi->ra_pages.  So remove them.  Also remove out of date comment for
queue_max_sectors_store().

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-sysfs.c    |    7 +------
 block/compat_ioctl.c |    2 --
 block/ioctl.c        |    2 --
 3 files changed, 1 insertion(+), 10 deletions(-)

diff -puN block/blk-sysfs.c~block-dont-take-lock-while-changing-ra_pages block/blk-sysfs.c
--- a/block/blk-sysfs.c~block-dont-take-lock-while-changing-ra_pages
+++ a/block/blk-sysfs.c
@@ -88,9 +88,7 @@ queue_ra_store(struct request_queue *q, 
 	unsigned long ra_kb;
 	ssize_t ret = queue_var_store(&ra_kb, page, count);
 
-	spin_lock_irq(q->queue_lock);
 	q->backing_dev_info.ra_pages = ra_kb >> (PAGE_CACHE_SHIFT - 10);
-	spin_unlock_irq(q->queue_lock);
 
 	return ret;
 }
@@ -117,10 +115,7 @@ queue_max_sectors_store(struct request_q
 
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
-	/*
-	 * Take the queue lock to update the readahead and max_sectors
-	 * values synchronously:
-	 */
+
 	spin_lock_irq(q->queue_lock);
 	q->max_sectors = max_sectors_kb << 1;
 	spin_unlock_irq(q->queue_lock);
diff -puN block/compat_ioctl.c~block-dont-take-lock-while-changing-ra_pages block/compat_ioctl.c
--- a/block/compat_ioctl.c~block-dont-take-lock-while-changing-ra_pages
+++ a/block/compat_ioctl.c
@@ -745,9 +745,7 @@ long compat_blkdev_ioctl(struct file *fi
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
-		lock_kernel();
 		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
-		unlock_kernel();
 		return 0;
 	case BLKGETSIZE:
 		size = bdev->bd_inode->i_size;
diff -puN block/ioctl.c~block-dont-take-lock-while-changing-ra_pages block/ioctl.c
--- a/block/ioctl.c~block-dont-take-lock-while-changing-ra_pages
+++ a/block/ioctl.c
@@ -323,9 +323,7 @@ int blkdev_ioctl(struct block_device *bd
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
 			return -ENOTTY;
-		lock_kernel();
 		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
-		unlock_kernel();
 		return 0;
 	case BLKBSZSET:
 		/* set the logical block size */
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
9p-convert-d_iname-references-to-d_namename.patch

