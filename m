From: akpm@linux-foundation.org
Subject: [to-be-updated] block-return-on-congested-block-device.patch
 removed from -mm tree
Date: Fri, 16 Jun 2017 13:00:14 -0700
Message-ID: <594438ce.F4QfhS3aEQJb1z5l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdFPUAP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 16:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgoldwyn@suse.com, adilger.kernel@dilger.ca, axboe@kernel.dk, clm@fb.com, darrick.wong@oracle.com, dsterba@suse.com, hch@lst.de, jack@suse.cz, jbacik@fb.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: return on congested block device
has been removed from the -mm tree.  Its filename was
     block-return-on-congested-block-device.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: block: return on congested block device

A new bio operation flag REQ_NOWAIT is introduced to identify bio's
orignating from iocb with IOCB_NOWAIT.  This flag indicates to return
immediately if a request cannot be made instead of retrying.

Stacked devices such as md (the ones with make_request_fn hooks) currently
are not supported because it may block for housekeeping.  For example, an
md can have a part of the device suspended.  For this reason, only request
based devices are supported.  In the future, this feature will be expanded
to stacked devices by teaching them how to handle the REQ_NOWAIT flags.

Link: http://lkml.kernel.org/r/20170615160002.17233-8-rgoldwyn@suse.de
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Chris Mason <clm@fb.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN block/blk-core.c~block-return-on-congested-block-device block/blk-core.c
--- a/block/blk-core.c~block-return-on-congested-block-device
+++ a/block/blk-core.c
@@ -1314,6 +1314,11 @@ retry:
 	if (!IS_ERR(rq))
 		return rq;
 
+	if (op & REQ_NOWAIT) {
+		blk_put_rl(rl);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	if (!gfpflags_allow_blocking(gfp_mask) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
 		return rq;
@@ -1961,6 +1966,16 @@ generic_make_request_checks(struct bio *
 		goto end_io;
 	}
 
+	/*
+	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
+	 * if queue is not a request based queue.
+	 */
+
+	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q)) {
+		err = -EOPNOTSUPP;
+		goto end_io;
+	}
+
 	part = bio->bi_bdev->bd_part;
 	if (should_fail_request(part, bio->bi_iter.bi_size) ||
 	    should_fail_request(&part_to_disk(part)->part0,
@@ -2118,7 +2133,7 @@ blk_qc_t generic_make_request(struct bio
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
-		if (likely(blk_queue_enter(q, false) == 0)) {
+		if (likely(blk_queue_enter(q, bio->bi_opf & REQ_NOWAIT) == 0)) {
 			struct bio_list lower, same;
 
 			/* Create a fresh bio_list for all subordinate requests */
@@ -2143,7 +2158,11 @@ blk_qc_t generic_make_request(struct bio
 			bio_list_merge(&bio_list_on_stack[0], &same);
 			bio_list_merge(&bio_list_on_stack[0], &bio_list_on_stack[1]);
 		} else {
-			bio_io_error(bio);
+			if (unlikely(!blk_queue_dying(q) &&
+					(bio->bi_opf & REQ_NOWAIT)))
+				bio_wouldblock_error(bio);
+			else
+				bio_io_error(bio);
 		}
 		bio = bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);
diff -puN block/blk-mq-sched.c~block-return-on-congested-block-device block/blk-mq-sched.c
--- a/block/blk-mq-sched.c~block-return-on-congested-block-device
+++ a/block/blk-mq-sched.c
@@ -83,6 +83,9 @@ struct request *blk_mq_sched_get_request
 	if (likely(!data->hctx))
 		data->hctx = blk_mq_map_queue(q, data->ctx->cpu);
 
+	if (op & REQ_NOWAIT)
+		data->flags |= BLK_MQ_REQ_NOWAIT;
+
 	if (e) {
 		data->flags |= BLK_MQ_REQ_INTERNAL;
 
diff -puN block/blk-mq.c~block-return-on-congested-block-device block/blk-mq.c
--- a/block/blk-mq.c~block-return-on-congested-block-device
+++ a/block/blk-mq.c
@@ -1498,6 +1498,8 @@ static blk_qc_t blk_mq_make_request(stru
 	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
 	if (unlikely(!rq)) {
 		__wbt_done(q->rq_wb, wb_acct);
+		if (bio->bi_opf & REQ_NOWAIT)
+			bio_wouldblock_error(bio);
 		return BLK_QC_T_NONE;
 	}
 
diff -puN fs/direct-io.c~block-return-on-congested-block-device fs/direct-io.c
--- a/fs/direct-io.c~block-return-on-congested-block-device
+++ a/fs/direct-io.c
@@ -479,8 +479,12 @@ static blk_status_t dio_bio_complete(str
 	unsigned i;
 	blk_status_t err = bio->bi_status;
 
-	if (err)
-		dio->io_error = -EIO;
+	if (err) {
+		if (bio->bi_status == -EAGAIN && (bio->bi_opf & REQ_NOWAIT))
+			dio->io_error = -EAGAIN;
+		else
+			dio->io_error = -EIO;
+	}
 
 	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
@@ -1194,6 +1198,8 @@ do_blockdev_direct_IO(struct kiocb *iocb
 	if (iov_iter_rw(iter) == WRITE) {
 		dio->op = REQ_OP_WRITE;
 		dio->op_flags = REQ_SYNC | REQ_IDLE;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			dio->op_flags |= REQ_NOWAIT;
 	} else {
 		dio->op = REQ_OP_READ;
 	}
diff -puN include/linux/bio.h~block-return-on-congested-block-device include/linux/bio.h
--- a/include/linux/bio.h~block-return-on-congested-block-device
+++ a/include/linux/bio.h
@@ -418,6 +418,12 @@ static inline void bio_io_error(struct b
 	bio_endio(bio);
 }
 
+static inline void bio_wouldblock_error(struct bio *bio)
+{
+	bio->bi_error = -EAGAIN;
+	bio_endio(bio);
+}
+
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
diff -puN include/linux/blk_types.h~block-return-on-congested-block-device include/linux/blk_types.h
--- a/include/linux/blk_types.h~block-return-on-congested-block-device
+++ a/include/linux/blk_types.h
@@ -224,6 +224,7 @@ enum req_flag_bits {
 	/* command specific flags for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
+	__REQ_NOWAIT,           /* Don't wait if request will block */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -242,6 +243,7 @@ enum req_flag_bits {
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
+#define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
_

Patches currently in -mm which might be from rgoldwyn@suse.com are

ext4-nowait-aio-support.patch
xfs-nowait-aio-support.patch
btrfs-nowait-aio-support.patch

