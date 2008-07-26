From: akpm@linux-foundation.org
Subject: - block-blk-mapc-use-the-new-object_is_on_stack-helper.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:12 -0700
Message-ID: <200807262113.m6QLDC17019580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757326AbYGZVNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     block/blk-map.c: use the new object_is_on_stack() helper
has been removed from the -mm tree.  Its filename was
     block-blk-mapc-use-the-new-object_is_on_stack-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/blk-map.c: use the new object_is_on_stack() helper
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-map.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN block/blk-map.c~block-blk-mapc-use-the-new-object_is_on_stack-helper block/blk-map.c
--- a/block/blk-map.c~block-blk-mapc-use-the-new-object_is_on_stack-helper
+++ a/block/blk-map.c
@@ -269,7 +269,6 @@ int blk_rq_map_kern(struct request_queue
 	int reading = rq_data_dir(rq) == READ;
 	int do_copy = 0;
 	struct bio *bio;
-	unsigned long stack_mask = ~(THREAD_SIZE - 1);
 
 	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
@@ -278,11 +277,8 @@ int blk_rq_map_kern(struct request_queue
 
 	kaddr = (unsigned long)kbuf;
 	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
-	do_copy = ((kaddr & alignment) || (len & alignment));
