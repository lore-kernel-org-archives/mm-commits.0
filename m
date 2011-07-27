From: akpm@linux-foundation.org
Subject: [merged] fail_make_request-cleanup-should_fail_request.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:49 -0700
Message-ID: <201107271928.p6RJSacc003317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     fail_make_request: cleanup should_fail_request
has been removed from the -mm tree.  Its filename was
     fail_make_request-cleanup-should_fail_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fail_make_request: cleanup should_fail_request
From: Akinobu Mita <akinobu.mita@gmail.com>

This changes should_fail_request() to more usable wrapper function of
should_fail().  It can avoid putting #ifdef CONFIG_FAIL_MAKE_REQUEST in
the middle of a function.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN block/blk-core.c~fail_make_request-cleanup-should_fail_request block/blk-core.c
--- a/block/blk-core.c~fail_make_request-cleanup-should_fail_request
+++ a/block/blk-core.c
@@ -1361,14 +1361,9 @@ static int __init setup_fail_make_reques
 }
 __setup("fail_make_request=", setup_fail_make_request);
 
-static int should_fail_request(struct bio *bio)
+static bool should_fail_request(struct hd_struct *part, unsigned int bytes)
 {
-	struct hd_struct *part = bio->bi_bdev->bd_part;
-
-	if (part_to_disk(part)->part0.make_it_fail || part->make_it_fail)
-		return should_fail(&fail_make_request, bio->bi_size);
-
-	return 0;
+	return part->make_it_fail && should_fail(&fail_make_request, bytes);
 }
 
 static int __init fail_make_request_debugfs(void)
@@ -1381,9 +1376,10 @@ late_initcall(fail_make_request_debugfs)
 
 #else /* CONFIG_FAIL_MAKE_REQUEST */
 
-static inline int should_fail_request(struct bio *bio)
+static inline bool should_fail_request(struct hd_struct *part,
+					unsigned int bytes)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
@@ -1466,6 +1462,7 @@ static inline void __generic_make_reques
 	old_dev = 0;
 	do {
 		char b[BDEVNAME_SIZE];
+		struct hd_struct *part;
 
 		q = bdev_get_queue(bio->bi_bdev);
 		if (unlikely(!q)) {
@@ -1489,7 +1486,10 @@ static inline void __generic_make_reques
 		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
 			goto end_io;
 
-		if (should_fail_request(bio))
+		part = bio->bi_bdev->bd_part;
+		if (should_fail_request(part, bio->bi_size) ||
+		    should_fail_request(&part_to_disk(part)->part0,
+					bio->bi_size))
 			goto end_io;
 
 		/*
@@ -1704,11 +1704,9 @@ int blk_insert_cloned_request(struct req
 	if (blk_rq_check_limits(q, rq))
 		return -EIO;
 
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-	if (rq->rq_disk && rq->rq_disk->part0.make_it_fail &&
-	    should_fail(&fail_make_request, blk_rq_bytes(rq)))
+	if (rq->rq_disk &&
+	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
 		return -EIO;
-#endif
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

