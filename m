From: akpm@linux-foundation.org
Subject: + block-separate-out-padding-from-alignment.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:35:07 -0800
Message-ID: <200803030835.m238Z7g7007035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbYCCIg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:36:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com


The patch titled
     block: separate out padding from alignment
has been added to the -mm tree.  Its filename is
     block-separate-out-padding-from-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: separate out padding from alignment
From: Tejun Heo <htejun@gmail.com>

Block layer alignment was used for two different purposes - memory alignment
and padding.  This causes problems in lower layers because drivers which only
require memory alignment ends up with adjusted rq->data_len.  Separate out
padding such that padding occurs iff driver explicitly requests it.

The major problem was that drivers which don't want size adjustment got it
acciedentally by mixing up aligning and padding which are two conceptually
separate things.  Let padding occur iff the driver explicitly requested it. 
This makes both parties happy.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-map.c           |   15 +++++++++------
 block/blk-settings.c      |   17 +++++++++++++++++
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    2 ++
 4 files changed, 30 insertions(+), 7 deletions(-)

diff -puN block/blk-map.c~block-separate-out-padding-from-alignment block/blk-map.c
--- a/block/blk-map.c~block-separate-out-padding-from-alignment
+++ a/block/blk-map.c
@@ -43,6 +43,7 @@ static int __blk_rq_map_user(struct requ
 			     void __user *ubuf, unsigned int len)
 {
 	unsigned long uaddr;
+	unsigned int alignment;
 	struct bio *bio, *orig_bio;
 	int reading, ret;
 
@@ -53,8 +54,8 @@ static int __blk_rq_map_user(struct requ
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) &&
-	    !(len & queue_dma_alignment(q)))
+	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
+	if (!(uaddr & alignment) && !(len & alignment))
 		bio = bio_map_user(q, NULL, uaddr, len, reading);
 	else
 		bio = bio_copy_user(q, uaddr, len, reading);
@@ -141,15 +142,17 @@ int blk_rq_map_user(struct request_queue
 
 	/*
 	 * __blk_rq_map_user() copies the buffers if starting address
-	 * or length isn't aligned.  As the copied buffer is always
-	 * page aligned, we know that there's enough room for padding.
-	 * Extend the last bio and update rq->data_len accordingly.
+	 * or length isn't aligned to dma_pad_mask.  As the copied
+	 * buffer is always page aligned, we know that there's enough
+	 * room for padding.  Extend the last bio and update
+	 * rq->data_len accordingly.
 	 *
 	 * On unmap, bio_uncopy_user() will use unmodified
 	 * bio_map_data pointed to by bio->bi_private.
 	 */
 	if (len & queue_dma_alignment(q)) {
-		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
+	if (len & q->dma_pad_mask) {
+		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
 		struct bio *tail = rq->biotail;
 
 		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
diff -puN block/blk-settings.c~block-separate-out-padding-from-alignment block/blk-settings.c
--- a/block/blk-settings.c~block-separate-out-padding-from-alignment
+++ a/block/blk-settings.c
@@ -293,6 +293,23 @@ void blk_queue_stack_limits(struct reque
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
 /**
+ * blk_queue_dma_pad - set pad mask
+ * @q:     the request queue for the device
+ * @mask:  pad mask
+ *
+ * Set pad mask.  Direct IO requests are padded to the mask specified.
+ *
+ * Appending pad buffer to a request modifies ->data_len such that it
+ * includes the pad buffer.  The original requested data length can be
+ * obtained using blk_rq_raw_data_len().
+ **/
+void blk_queue_dma_pad(struct request_queue *q, unsigned int mask)
+{
+	q->dma_pad_mask = mask;
+}
+EXPORT_SYMBOL(blk_queue_dma_pad);
+
+/**
  * blk_queue_dma_drain - Set up a drain buffer for excess dma.
  *
  * @q:  the request queue for the device
diff -puN drivers/ata/libata-scsi.c~block-separate-out-padding-from-alignment drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~block-separate-out-padding-from-alignment
+++ a/drivers/ata/libata-scsi.c
@@ -862,9 +862,10 @@ static int ata_scsi_dev_config(struct sc
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
-		/* set the min alignment */
+		/* set the min alignment and padding */
 		blk_queue_update_dma_alignment(sdev->request_queue,
 					       ATA_DMA_PAD_SZ - 1);
+		blk_queue_dma_pad(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
diff -puN include/linux/blkdev.h~block-separate-out-padding-from-alignment include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-separate-out-padding-from-alignment
+++ a/include/linux/blkdev.h
@@ -362,6 +362,7 @@ struct request_queue
 	unsigned long		seg_boundary_mask;
 	void			*dma_drain_buffer;
 	unsigned int		dma_drain_size;
+	unsigned int		dma_pad_mask;
 	unsigned int		dma_alignment;
 
 	struct blk_queue_tag	*queue_tags;
@@ -707,6 +708,7 @@ extern void blk_queue_max_hw_segments(st
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
+extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size);
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
block-fix-residual-byte-count-handling.patch
block-separate-out-padding-from-alignment.patch

