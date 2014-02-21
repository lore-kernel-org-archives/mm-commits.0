From: akpm@linux-foundation.org
Subject: +
 mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch added
 to -mm tree
Date: Fri, 21 Feb 2014 14:52:54 -0800
Message-ID: <5307d8c6.v3wpmhshAccS1DvO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbaBUWwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 17:52:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, riel@redhat.com, mgorman@suse.de, iamjoonsoo.kim@lge.com

Subject: + mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,mgorman@suse.de,riel@redhat.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 14:52:54 -0800


The patch titled
     Subject: mm/compaction: change the timing to check to drop the spinlock
has been added to the -mm tree.  Its filename is
     mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -481,7 +481,7 @@ isolate_migratepages_range(struct zone *
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

kthread-ensure-locality-of-task_struct-allocations.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch

