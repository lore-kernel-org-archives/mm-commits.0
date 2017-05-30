From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock.patch added to -mm tree
Date: Tue, 30 May 2017 14:22:56 -0700
Message-ID: <592de2b0.CpGecRIj9tXl8LII%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59796 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750869AbdE3VXF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 17:23:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: fallback to smallest page when not stealing whole pageblock
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: fallback to smallest page when not stealing whole pageblock

Since commit 3bc48f96cf11 ("mm, page_alloc: split smallest stolen page in
fallback") we pick the smallest (but sufficient) page of all that have
been stolen from a pageblock of different migratetype.  However, there are
cases when we decide not to steal the whole pageblock.  Practically in the
current implementation it means that we are trying to fallback for a
MIGRATE_MOVABLE allocation of order X, go through the freelists from
MAX_ORDER-1 down to X, and find free page of order Y.  If Y is less than
pageblock_order / 2, we decide not to steal all pages from the pageblock. 
When Y > X, it means we are potentially splitting a larger page than we
need, as there might be other pages of order Z, where X <= Z < Y.  Since Y
is already too small to steal whole pageblock, picking smallest available
Z will result in the same decision and we avoid splitting a higher-order
page in a MIGRATE_UNMOVABLE or MIGRATE_RECLAIMABLE pageblock.

This patch therefore changes the fallback algorithm so that in the
situation described above, we switch the fallback search strategy to go
from order X upwards to find the smallest suitable fallback.  In theory
there shouldn't be a downside of this change wrt fragmentation.

This has been tested with mmtests' stress-highalloc performing GFP_KERNEL
order-4 allocations, here is the relevant extfrag tracepoint statistics:

                                                      4.12.0-rc2      4.12.0-rc2
                                                       1-kernel4       2-kernel4
Page alloc extfrag event                                  25640976    69680977
Extfrag fragmenting                                       25621086    69661364
Extfrag fragmenting for unmovable                            74409       73204
Extfrag fragmenting unmovable placed with movable            69003       67684
Extfrag fragmenting unmovable placed with reclaim.            5406        5520
Extfrag fragmenting for reclaimable                           6398        8467
Extfrag fragmenting reclaimable placed with movable            869         884
Extfrag fragmenting reclaimable placed with unmov.            5529        7583
Extfrag fragmenting for movable                           25540279    69579693

Since we force movable allocations to steal the smallest available page
(which we then practially always split), we steal less per fallback, so
the number of fallbacks increases and steals potentially happen from
different pageblocks.  This is however not an issue for movable pages that
can be compacted.

Importantly, the "unmovable placed with movable" statistics is lower,
which is the result of less fragmentation in the unmovable pageblocks. 
The effect on reclaimable allocation is a bit unclear.

Link: http://lkml.kernel.org/r/20170529093947.22618-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   53 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock
+++ a/mm/page_alloc.c
@@ -2205,7 +2205,11 @@ __rmqueue_fallback(struct zone *zone, un
 	int fallback_mt;
 	bool can_steal;
 
-	/* Find the largest possible block of pages in the other list */
+	/*
+	 * Find the largest available free page in the other list. This roughly
+	 * approximates finding the pageblock with the most free pages, which
+	 * would be too costly to do exactly.
+	 */
 	for (current_order = MAX_ORDER-1;
 				current_order >= order && current_order <= MAX_ORDER-1;
 				--current_order) {
@@ -2215,19 +2219,50 @@ __rmqueue_fallback(struct zone *zone, un
 		if (fallback_mt == -1)
 			continue;
 
-		page = list_first_entry(&area->free_list[fallback_mt],
-						struct page, lru);
+		/*
+		 * We cannot steal all free pages from the pageblock and the
+		 * requested migratetype is movable. In that case it's better to
+		 * steal and split the smallest available page instead of the
+		 * largest available page, because even if the next movable
+		 * allocation falls back into a different pageblock than this
+		 * one, it won't cause permanent fragmentation.
+		 */
+		if (!can_steal && start_migratetype == MIGRATE_MOVABLE
+					&& current_order > order)
+			goto find_smallest;
 
-		steal_suitable_fallback(zone, page, start_migratetype,
-								can_steal);
+		goto do_steal;
+	}
 
-		trace_mm_page_alloc_extfrag(page, order, current_order,
-			start_migratetype, fallback_mt);
+	return false;
 
-		return true;
+find_smallest:
+	for (current_order = order; current_order < MAX_ORDER;
+							current_order++) {
+		area = &(zone->free_area[current_order]);
+		fallback_mt = find_suitable_fallback(area, current_order,
+				start_migratetype, false, &can_steal);
+		if (fallback_mt != -1)
+			break;
 	}
 
-	return false;
+	/*
+	 * This should not happen - we already found a suitable fallback
+	 * when looking for the largest page.
+	 */
+	VM_BUG_ON(current_order == MAX_ORDER);
+
+do_steal:
+	page = list_first_entry(&area->free_list[fallback_mt],
+							struct page, lru);
+
+	steal_suitable_fallback(zone, page, start_migratetype, can_steal);
+
+	trace_mm_page_alloc_extfrag(page, order, current_order,
+		start_migratetype, fallback_mt);
+
+	return true;
+
 }
 
 /*
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-fix-more-premature-oom-due-to-race-with-cpuset-update.patch
mm-mempolicy-stop-adjusting-current-il_next-in-mpol_rebind_nodemask.patch
mm-page_alloc-pass-preferred-nid-instead-of-zonelist-to-allocator.patch
mm-mempolicy-simplify-rebinding-mempolicies-when-updating-cpusets.patch
mm-cpuset-always-use-seqlock-when-changing-tasks-nodemask.patch
mm-mempolicy-dont-check-cpuset-seqlock-where-it-doesnt-matter.patch
mm-page_alloc-fallback-to-smallest-page-when-not-stealing-whole-pageblock.patch

