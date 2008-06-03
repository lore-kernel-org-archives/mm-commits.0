From: akpm@linux-foundation.org
Subject: - block-add-blk_queue_update_dma_pad.patch removed from -mm tree
Date: Tue, 03 Jun 2008 14:51:12 -0700
Message-ID: <200806032151.m53LpC06021519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbYFCVwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     block: add blk_queue_update_dma_pad
has been removed from the -mm tree.  Its filename was
     block-add-blk_queue_update_dma_pad.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: add blk_queue_update_dma_pad
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This adds blk_queue_update_dma_pad to prevent LLDs from overwriting the
dma pad mask wrongly (we added blk_queue_update_dma_alignment due to the
same reason).

This also converts libata to use blk_queue_update_dma_pad instead of
blk_queue_dma_pad.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-settings.c      |   24 ++++++++++++++++++++----
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    1 +
 3 files changed, 23 insertions(+), 5 deletions(-)

diff -puN block/blk-settings.c~block-add-blk_queue_update_dma_pad block/blk-settings.c
--- a/block/blk-settings.c~block-add-blk_queue_update_dma_pad
+++ a/block/blk-settings.c
@@ -308,11 +308,10 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * @q:     the request queue for the device
  * @mask:  pad mask
  *
- * Set pad mask.  Direct IO requests are padded to the mask specified.
+ * Set dma pad mask.
  *
- * Appending pad buffer to a request modifies ->data_len such that it
- * includes the pad buffer.  The original requested data length can be
- * obtained using blk_rq_raw_data_len().
+ * Appending pad buffer to a request modifies the last entry of a
+ * scatter list such that it includes the pad buffer.
  **/
 void blk_queue_dma_pad(struct request_queue *q, unsigned int mask)
 {
@@ -321,6 +320,23 @@ void blk_queue_dma_pad(struct request_qu
 EXPORT_SYMBOL(blk_queue_dma_pad);
 
 /**
+ * blk_queue_update_dma_pad - update pad mask
+ * @q:     the request queue for the device
+ * @mask:  pad mask
+ *
+ * Update dma pad mask.
+ *
+ * Appending pad buffer to a request modifies the last entry of a
+ * scatter list such that it includes the pad buffer.
+ **/
+void blk_queue_update_dma_pad(struct request_queue *q, unsigned int mask)
+{
+	if (mask > q->dma_pad_mask)
+		q->dma_pad_mask = mask;
+}
+EXPORT_SYMBOL(blk_queue_update_dma_pad);
+
+/**
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
  * @q:  the request queue for the device
  * @dma_drain_needed: fn which returns non-zero if drain is necessary
diff -puN drivers/ata/libata-scsi.c~block-add-blk_queue_update_dma_pad drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~block-add-blk_queue_update_dma_pad
+++ a/drivers/ata/libata-scsi.c
@@ -885,7 +885,8 @@ static int ata_scsi_dev_config(struct sc
 		/* set the min alignment and padding */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_DMA_PAD_SZ - 1);
-		blk_queue_dma_pad(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
+		blk_queue_update_dma_pad(sdev->request_queue,
+					 ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
diff -puN include/linux/blkdev.h~block-add-blk_queue_update_dma_pad include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-add-blk_queue_update_dma_pad
+++ a/include/linux/blkdev.h
@@ -748,6 +748,7 @@ extern void blk_queue_max_segment_size(s
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
+extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
 extern int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch

