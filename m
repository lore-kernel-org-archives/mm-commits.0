From: akpm@linux-foundation.org
Subject: + swap-do-not-send-discards-as-barriers.patch added to -mm tree
Date: Tue, 07 Sep 2010 13:32:16 -0700
Message-ID: <201009072032.o87KWGtL004438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756829Ab0IGUcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 16:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@infradead.org, James.Bottomley@hansenpartnership.com, hch@lst.de, hughd@google.com, jaxboe@fusionio.com, martin.petersen@oracle.com, nigel@tuxonice.net, stable@kernel.org, tj@kernel.org


The patch titled
     swap: do not send discards as barriers
has been added to the -mm tree.  Its filename is
     swap-do-not-send-discards-as-barriers.patch

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
Subject: swap: do not send discards as barriers
From: Christoph Hellwig <hch@infradead.org>

The swap code already uses synchronous discards, no need to add I/O
barriers.

This fixes the worst of the terrible slowdown in swap allocation for
hibernation, reported on 2.6.35 by Nigel Cunningham; but does not entirely
eliminate that regression.

[tj@kernel.org: superflous newlines removed]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/swapfile.c~swap-do-not-send-discards-as-barriers mm/swapfile.c
--- a/mm/swapfile.c~swap-do-not-send-discards-as-barriers
+++ a/mm/swapfile.c
@@ -139,8 +139,7 @@ static int discard_swap(struct swap_info
 	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			return err;
 		cond_resched();
@@ -151,8 +150,7 @@ static int discard_swap(struct swap_info
 		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			break;
 
@@ -191,8 +189,7 @@ static void discard_swap_cluster(struct 
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT |
-							BLKDEV_IFL_BARRIER))
+				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT))
 				break;
 		}
 
_

Patches currently in -mm which might be from hch@infradead.org are

linux-next.patch
o_direct-fix-the-splitting-up-of-contiguous-i-o.patch
swap-do-not-send-discards-as-barriers.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
writeback-remove-nonblocking-encountered_congestion-references.patch

