From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:36:27 -0700
Message-ID: <53445dcb.w/jmpIzAt7Kxphsh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbaDHUg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: [merged] mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:36:27 -0700


The patch titled
     Subject: mm/compaction: change the timing to check to drop the spinlock
has been removed from the -mm tree.  Its filename was
     mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: change the timing to check to drop the spinlock

It is odd to drop the spinlock when we scan (SWAP_CLUSTER_MAX - 1) th pfn
page.  This may results in below situation while isolating migratepage.

1. try isolate 0x0 ~ 0x200 pfn pages.
2. When low_pfn is 0x1ff, ((low_pfn+1) % SWAP_CLUSTER_MAX) == 0, so drop
   the spinlock.
3. Then, to complete isolating, retry to aquire the lock.

I think that it is better to use SWAP_CLUSTER_MAX th pfn for checking the
criteria about dropping the lock.  This has no harm 0x0 pfn, because, at
this time, locked variable would be false.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-change-the-timing-to-check-to-drop-the-spinlock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-change-the-timing-to-check-to-drop-the-spinlock
+++ a/mm/compaction.c
@@ -487,7 +487,7 @@ isolate_migratepages_range(struct zone *
 	cond_resched();
 	for (; low_pfn < end_pfn; low_pfn++) {
 		/* give a chance to irqs before checking need_resched() */
-		if (locked && !((low_pfn+1) % SWAP_CLUSTER_MAX)) {
+		if (locked && !(low_pfn % SWAP_CLUSTER_MAX)) {
 			if (should_release_lock(&zone->lru_lock)) {
 				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				locked = false;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
page-owners-correct-page-order-when-to-free-page.patch

