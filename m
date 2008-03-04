From: akpm@linux-foundation.org
Subject: - block-fix-residual-byte-count-handling.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:05:16 -0800
Message-ID: <200803042005.m24K5GjH026607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762417AbYCDUG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: fix residual byte count handling
has been removed from the -mm tree.  Its filename was
     block-fix-residual-byte-count-handling.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix residual byte count handling
From: Tejun Heo <htejun@gmail.com>

rq->raw_data_len introduced for block layer padding and draining (commit
6b00769fe1502b4ad97bb327ef7ac971b208bfb5) broke residual byte count handling. 
Block drivers modify rq->data_len to notify residual byte count to the block
layer which blindly reported unmodified rq->raw_data_len to userland.

To keep block drivers dealing only with rq->data_len, this should be handled
inside block layer.  However, how much extra buffer was appened is lost after
rq->data_len is modified.

This patch replaces rq->raw_data_len with rq->extra_len and add
blk_rq_raw_data_len() helper to calculate raw data size from rq->data_len and
rq->extra_len.  The helper returns correct raw residual byte count when called
on a rq whose data_len is modified to carry residual byte count.

This problem was reported and diagnosed by Mike Galbraith.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c          |    3 +--
 block/blk-map.c           |    2 +-
 block/blk-merge.c         |    1 +
 block/blk-settings.c      |    4 ++++
 block/bsg.c               |    8 ++++----
 block/scsi_ioctl.c        |    4 ++--
 drivers/ata/libata-scsi.c |    3 ++-
 include/linux/blkdev.h    |    8 +++++++-
 8 files changed, 22 insertions(+), 11 deletions(-)

diff -puN block/blk-core.c~block-fix-residual-byte-count-handling block/blk-core.c
--- a/block/blk-core.c~block-fix-residual-byte-count-handling
+++ a/block/blk-core.c
@@ -127,7 +127,7 @@ void rq_init(struct request_queue *q, st
 	rq->nr_hw_segments = 0;
 	rq->ioprio = 0;
 	rq->special = NULL;
-	rq->raw_data_len = 0;
+	rq->extra_len = 0;
 	rq->buffer = NULL;
 	rq->tag = -1;
 	rq->errors = 0;
@@ -2016,7 +2016,6 @@ void blk_rq_bio_prep(struct request_queu
 	rq->hard_cur_sectors = rq->current_nr_sectors;
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->buffer = bio_data(bio);
-	rq->raw_data_len = bio->bi_size;
 	rq->data_len = bio->bi_size;
 
 	rq->bio = rq->biotail = bio;
diff -puN block/blk-map.c~block-fix-residual-byte-count-handling block/blk-map.c
--- a/block/blk-map.c~block-fix-residual-byte-count-handling
+++ a/block/blk-map.c
@@ -19,7 +19,6 @@ int blk_rq_append_bio(struct request_que
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->raw_data_len += bio->bi_size;
 		rq->data_len += bio->bi_size;
 	}
 	return 0;
@@ -156,6 +155,7 @@ int blk_rq_map_user(struct request_queue
 		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
 		tail->bi_size += pad_len;
 		rq->data_len += pad_len;
+		rq->extra_len += pad_len;
 	}
 
 	rq->buffer = rq->data = NULL;
diff -puN block/blk-merge.c~block-fix-residual-byte-count-handling block/blk-merge.c
--- a/block/blk-merge.c~block-fix-residual-byte-count-handling
+++ a/block/blk-merge.c
@@ -232,6 +232,7 @@ new_segment:
 			    (PAGE_SIZE - 1));
 		nsegs++;
 		rq->data_len += q->dma_drain_size;
+		rq->extra_len += q->dma_drain_size;
 	}
 
 	if (sg)
diff -puN block/blk-settings.c~block-fix-residual-byte-count-handling block/blk-settings.c
--- a/block/blk-settings.c~block-fix-residual-byte-count-handling
+++ a/block/blk-settings.c
@@ -309,6 +309,10 @@ EXPORT_SYMBOL(blk_queue_stack_limits);
  * does is adjust the queue so that the buf is always appended
  * silently to the scatterlist.
  *
+ * Appending draining buffer to a request modifies ->data_len such
+ * that it includes the drain buffer.  The original requested data
+ * length can be obtained using blk_rq_raw_data_len().
+ *
  * Note: This routine adjusts max_hw_segments to make room for
  * appending the drain buffer.  If you call
  * blk_queue_max_hw_segments() or blk_queue_max_phys_segments() after
diff -puN block/bsg.c~block-fix-residual-byte-count-handling block/bsg.c
--- a/block/bsg.c~block-fix-residual-byte-count-handling
+++ a/block/bsg.c
@@ -437,14 +437,14 @@ static int blk_complete_sgv4_hdr_rq(stru
 	}
 
 	if (rq->next_rq) {
-		hdr->dout_resid = rq->raw_data_len;
-		hdr->din_resid = rq->next_rq->raw_data_len;
+		hdr->dout_resid = blk_rq_raw_data_len(rq);
+		hdr->din_resid = blk_rq_raw_data_len(rq->next_rq);
 		blk_rq_unmap_user(bidi_bio);
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
-		hdr->din_resid = rq->raw_data_len;
+		hdr->din_resid = blk_rq_raw_data_len(rq);
 	else
-		hdr->dout_resid = rq->raw_data_len;
+		hdr->dout_resid = blk_rq_raw_data_len(rq);
 
 	/*
 	 * If the request generated a negative error number, return it
diff -puN block/scsi_ioctl.c~block-fix-residual-byte-count-handling block/scsi_ioctl.c
--- a/block/scsi_ioctl.c~block-fix-residual-byte-count-handling
+++ a/block/scsi_ioctl.c
@@ -266,7 +266,7 @@ static int blk_complete_sghdr_rq(struct 
 	hdr->info = 0;
 	if (hdr->masked_status || hdr->host_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->resid = rq->raw_data_len;
+	hdr->resid = blk_rq_raw_data_len(rq);
 	hdr->sb_len_wr = 0;
 
 	if (rq->sense_len && hdr->sbp) {
@@ -528,8 +528,8 @@ static int __blk_send_generic(struct req
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->data = NULL;
-	rq->raw_data_len = 0;
 	rq->data_len = 0;
+	rq->extra_len = 0;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd[0] = cmd;
diff -puN drivers/ata/libata-scsi.c~block-fix-residual-byte-count-handling drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~block-fix-residual-byte-count-handling
+++ a/drivers/ata/libata-scsi.c
@@ -2539,7 +2539,8 @@ static unsigned int atapi_xlat(struct at
 	 * want to set it properly, and for DMA where it is
 	 * effectively meaningless.
 	 */
-	nbytes = min(scmd->request->raw_data_len, (unsigned int)63 * 1024);
+	nbytes = min(blk_rq_raw_data_len(scmd->request),
+		     (unsigned int)63 * 1024);
 
 	/* Most ATAPI devices which honor transfer chunk size don't
 	 * behave according to the spec when odd chunk size which
diff -puN include/linux/blkdev.h~block-fix-residual-byte-count-handling include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-fix-residual-byte-count-handling
+++ a/include/linux/blkdev.h
@@ -216,8 +216,8 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];
 
-	unsigned int raw_data_len;
 	unsigned int data_len;
+	unsigned int extra_len;	/* length of padding and draining buffers */
 	unsigned int sense_len;
 	void *data;
 	void *sense;
@@ -477,6 +477,12 @@ enum {
 
 #define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
+/* data_len of the request sans extra stuff for padding and draining */
+static inline unsigned int blk_rq_raw_data_len(struct request *rq)
+{
+	return rq->data_len - min(rq->extra_len, rq->data_len);
+}
+
 /*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
block-fix-residual-byte-count-handling.patch

