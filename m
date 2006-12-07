From: akpm@osdl.org
Subject: - cciss-remove-unused-revalidate_allvol-function.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:35 -0800
Message-ID: <200612072300.kB7N0ZPs029655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51342 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163741AbWLGXBB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cciss: remove unused revalidate_allvol function
has been removed from the -mm tree.  Its filename was
     cciss-remove-unused-revalidate_allvol-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: remove unused revalidate_allvol function
From: Mike Miller <mike.miller@hp.com>

Remove the no longer used revalidate_allvol function.  It was replaced by
rebuild_lun_table.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/cciss.c |   74 ----------------------------------------
 1 file changed, 1 insertion(+), 73 deletions(-)

diff -puN drivers/block/cciss.c~cciss-remove-unused-revalidate_allvol-function drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-remove-unused-revalidate_allvol-function
+++ a/drivers/block/cciss.c
@@ -141,7 +141,6 @@ static int cciss_ioctl(struct inode *ino
 		       unsigned int cmd, unsigned long arg);
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
-static int revalidate_allvol(ctlr_info_t *host);
 static int cciss_revalidate(struct gendisk *disk);
 static int rebuild_lun_table(ctlr_info_t *h, struct gendisk *del_disk);
 static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
@@ -857,9 +856,7 @@ static int cciss_ioctl(struct inode *ino
 		}
 
 	case CCISS_REVALIDVOLS:
-		if (bdev != bdev->bd_contains || drv != host->drv)
-			return -ENXIO;
-		return revalidate_allvol(host);
+		return rebuild_lun_table(host, NULL);
 
 	case CCISS_GETLUNINFO:{
 			LogvolInfo_struct luninfo;
@@ -1159,75 +1156,6 @@ static int cciss_ioctl(struct inode *ino
 	}
 }
 
-/*
- * revalidate_allvol is for online array config utilities.  After a
- * utility reconfigures the drives in the array, it can use this function
- * (through an ioctl) to make the driver zap any previous disk structs for
- * that controller and get new ones.
- *
- * Right now I'm using the getgeometry() function to do this, but this
- * function should probably be finer grained and allow you to revalidate one
- * particular logical volume (instead of all of them on a particular
- * controller).
- */
-static int revalidate_allvol(ctlr_info_t *host)
-{
-	int ctlr = host->ctlr, i;
-	unsigned long flags;
-
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	if (host->usage_count > 1) {
-		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-		printk(KERN_WARNING "cciss: Device busy for volume"
-		       " revalidation (usage=%d)\n", host->usage_count);
-		return -EBUSY;
-	}
-	host->usage_count++;
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-
-	for (i = 0; i < NWD; i++) {
-		struct gendisk *disk = host->gendisk[i];
-		if (disk) {
-			request_queue_t *q = disk->queue;
-
-			if (disk->flags & GENHD_FL_UP)
-				del_gendisk(disk);
-			if (q)
-				blk_cleanup_queue(q);
-		}
-	}
-
-	/*
-	 * Set the partition and block size structures for all volumes
-	 * on this controller to zero.  We will reread all of this data
-	 */
-	memset(host->drv, 0, sizeof(drive_info_struct)
-	       * CISS_MAX_LUN);
-	/*
-	 * Tell the array controller not to give us any interrupts while
-	 * we check the new geometry.  Then turn interrupts back on when
-	 * we're done.
-	 */
-	host->access.set_intr_mask(host, CCISS_INTR_OFF);
-	cciss_getgeometry(ctlr);
-	host->access.set_intr_mask(host, CCISS_INTR_ON);
-
-	/* Loop through each real device */
-	for (i = 0; i < NWD; i++) {
-		struct gendisk *disk = host->gendisk[i];
-		drive_info_struct *drv = &(host->drv[i]);
-		/* we must register the controller even if no disks exist */
-		/* this is for the online array utilities */
-		if (!drv->heads && i)
-			continue;
-		blk_queue_hardsect_size(drv->queue, drv->block_size);
-		set_capacity(disk, drv->nr_blocks);
-		add_disk(disk);
-	}
-	host->usage_count--;
-	return 0;
-}
-
 static inline void complete_buffers(struct bio *bio, int status)
 {
 	while (bio) {
_

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch

