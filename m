From: akpm@linux-foundation.org
Subject: + block-blk_max_pfn-is-somtimes-wrong.patch added to -mm tree
Date: Fri, 09 Feb 2007 00:38:38 -0800
Message-ID: <200702090838.l198ccfJ008573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946167AbXBIIi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 03:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vtaras@openvz.org, jens.axboe@oracle.com


The patch titled
     block: blk_max_pfn is somtimes wrong
has been added to the -mm tree.  Its filename is
     block-blk_max_pfn-is-somtimes-wrong.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: block: blk_max_pfn is somtimes wrong
From: Vasily Tarasov <vtaras@openvz.org>

There is a small problem in handling page bounce.

At the moment blk_max_pfn equals max_pfn, which is in fact not maximum
possible _number_ of a page frame, but the _amount_ of page frames.  For
example for the 32bit x86 node with 4Gb RAM, max_pfn = 0x100000, but not
0xFFFF.

request_queue structure has a member q->bounce_pfn and queue needs bounce
pages for the pages _above_ this limit.  This routine is handled by
blk_queue_bounce(), where the following check is produced:

	if (q->bounce_pfn >= blk_max_pfn)
		return;

Assume, that a driver has set q->bounce_pfn to 0xFFFF, but blk_max_pfn
equals 0x10000.  In such situation the check above fails and for each bio
we always fall down for iterating over pages tied to the bio.

I want to notice, that for quite a big range of device drivers (ide, md,
...) such problem doesn't happen because they use BLK_BOUNCE_ANY for
bounce_pfn.  BLK_BOUNCE_ANY is defined as blk_max_pfn << PAGE_SHIFT, and
then the check above doesn't fail.  But for other drivers, which obtain
reuired value from drivers, it fails.  For example sata_nv uses
ATA_DMA_MASK or dev->dma_mask.

I propose to use (max_pfn - 1) for blk_max_pfn.  And the same for
blk_max_low_pfn.  The patch also cleanses some checks related with
bounce_pfn.

Signed-off-by: Vasily Tarasov <vtaras@openvz.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    6 +++---
 mm/bounce.c       |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN block/ll_rw_blk.c~block-blk_max_pfn-is-somtimes-wrong block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~block-blk_max_pfn-is-somtimes-wrong
+++ a/block/ll_rw_blk.c
@@ -1213,7 +1213,7 @@ void blk_recount_segments(request_queue_
 		 * considered part of another segment, since that might
 		 * change with the bounce page.
 		 */
-		high = page_to_pfn(bv->bv_page) >= q->bounce_pfn;
+		high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
 		if (high || highprv)
 			goto new_hw_segment;
 		if (cluster) {
@@ -3624,8 +3624,8 @@ int __init blk_dev_init(void)
 	open_softirq(BLOCK_SOFTIRQ, blk_done_softirq, NULL);
 	register_hotcpu_notifier(&blk_cpu_notifier);
 
-	blk_max_low_pfn = max_low_pfn;
-	blk_max_pfn = max_pfn;
+	blk_max_low_pfn = max_low_pfn - 1;
+	blk_max_pfn = max_pfn - 1;
 
 	return 0;
 }
diff -puN mm/bounce.c~block-blk_max_pfn-is-somtimes-wrong mm/bounce.c
--- a/mm/bounce.c~block-blk_max_pfn-is-somtimes-wrong
+++ a/mm/bounce.c
@@ -204,7 +204,7 @@ static void __blk_queue_bounce(request_q
 		/*
 		 * is destination page below bounce pfn?
 		 */
-		if (page_to_pfn(page) < q->bounce_pfn)
+		if (page_to_pfn(page) <= q->bounce_pfn)
 			continue;
 
 		/*
_

Patches currently in -mm which might be from vtaras@openvz.org are

block-blk_max_pfn-is-somtimes-wrong.patch
