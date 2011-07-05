From: akpm@linux-foundation.org
Subject: + fail_make_request-cleanup-should_fail_request.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:24:49 -0700
Message-ID: <201107052124.p65LOnFg024980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1GEVZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:25:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, axboe@kernel.dk


The patch titled
     fail_make_request: cleanup should_fail_request
has been added to the -mm tree.  Its filename is
     fail_make_request-cleanup-should_fail_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1357,14 +1357,9 @@ static int __init setup_fail_make_reques
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
@@ -1377,9 +1372,10 @@ late_initcall(fail_make_request_debugfs)
 
 #else /* CONFIG_FAIL_MAKE_REQUEST */
 
-static inline int should_fail_request(struct bio *bio)
+static inline bool should_fail_request(struct hd_struct *part,
+					unsigned int bytes)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
@@ -1462,6 +1458,7 @@ static inline void __generic_make_reques
 	old_dev = 0;
 	do {
 		char b[BDEVNAME_SIZE];
+		struct hd_struct *part;
 
 		q = bdev_get_queue(bio->bi_bdev);
 		if (unlikely(!q)) {
@@ -1485,7 +1482,10 @@ static inline void __generic_make_reques
 		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
 			goto end_io;
 
-		if (should_fail_request(bio))
+		part = bio->bi_bdev->bd_part;
+		if (should_fail_request(part, bio->bi_size) ||
+		    should_fail_request(&part_to_disk(part)->part0,
+					bio->bi_size))
 			goto end_io;
 
 		/*
@@ -1700,11 +1700,9 @@ int blk_insert_cloned_request(struct req
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

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

