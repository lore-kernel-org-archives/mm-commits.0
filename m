From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch removed from -mm tree
Date: Mon, 09 Nov 2015 11:44:36 -0800
Message-ID: <5640f7a4.c/uZHXNa0hrzBtHm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbKIToh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: only enforce watermarks for order-0 allocations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: only enforce watermarks for order-0 allocations

The primary purpose of watermarks is to ensure that reclaim can always
make forward progress in PF_MEMALLOC context (kswapd and direct reclaim). 
These assume that order-0 allocations are all that is necessary for
forward progress.

High-order watermarks serve a different purpose.  Kswapd had no high-order
awareness before they were introduced
(https://lkml.kernel.org/r/413AA7B2.4000907@yahoo.com.au).  This was
particularly important when there were high-order atomic requests.  The
watermarks both gave kswapd awareness and made a reserve for those atomic
requests.

There are two important side-effects of this.  The most important is that
a non-atomic high-order request can fail even though free pages are
available and the order-0 watermarks are ok.  The second is that
high-order watermark checks are expensive as the free list counts up to
the requested order must be examined.

With the introduction of MIGRATE_HIGHATOMIC it is no longer necessary to
have high-order watermarks.  Kswapd and compaction still need high-order
awareness which is handled by checking that at least one suitable
high-order page is free.

With the patch applied, there was little difference in the allocation
failure rates as the atomic reserves are small relative to the number of
allocation attempts.  The expected impact is that there will never be an
allocation failure report that shows suitable pages on the free lists.

The one potential side-effect of this is that in a vanilla kernel, the
watermark checks may have kept a free page for an atomic allocation.  Now,
we are 100% relying on the HighAtomic reserves and an early allocation to
have allocated them.  If the first high-order atomic allocation is after
the system is already heavily fragmented then it'll fail.

[akpm@linux-foundation.org: simplify __zone_watermark_ok(), per Vlastimil]
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   53 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations
+++ a/mm/page_alloc.c
@@ -2322,8 +2322,10 @@ static inline bool should_fail_alloc_pag
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
 /*
- * Return true if free pages are above 'mark'. This takes into account the order
- * of the allocation.
+ * Return true if free base pages are above 'mark'. For high-order checks it
+ * will return true of the order-0 watermark is reached and there is at least
+ * one free page of a suitable size. Checking now avoids taking the zone lock
+ * to check in the allocation paths if no pages are free.
  */
 static bool __zone_watermark_ok(struct zone *z, unsigned int order,
 			unsigned long mark, int classzone_idx, int alloc_flags,
@@ -2331,7 +2333,7 @@ static bool __zone_watermark_ok(struct z
 {
 	long min = mark;
 	int o;
-	long free_cma = 0;
+	const int alloc_harder = (alloc_flags & ALLOC_HARDER);
 
 	/* free_pages may go negative - that's OK */
 	free_pages -= (1 << order) - 1;
@@ -2344,7 +2346,7 @@ static bool __zone_watermark_ok(struct z
 	 * the high-atomic reserves. This will over-estimate the size of the
 	 * atomic reserve but it avoids a search.
 	 */
-	if (likely(!(alloc_flags & ALLOC_HARDER)))
+	if (likely(!alloc_harder))
 		free_pages -= z->nr_reserved_highatomic;
 	else
 		min -= min / 4;
@@ -2352,22 +2354,45 @@ static bool __zone_watermark_ok(struct z
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
-		free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);
+		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
 
-	if (free_pages - free_cma <= min + z->lowmem_reserve[classzone_idx])
+	/*
+	 * Check watermarks for an order-0 allocation request. If these
+	 * are not met, then a high-order request also cannot go ahead
+	 * even if a suitable page happened to be free.
+	 */
+	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
 		return false;
-	for (o = 0; o < order; o++) {
-		/* At the next order, this order's pages become unavailable */
-		free_pages -= z->free_area[o].nr_free << o;
 
-		/* Require fewer higher order pages to be free */
-		min >>= 1;
+	/* If this is an order-0 request then the watermark is fine */
+	if (!order)
+		return true;
+
+	/* For a high-order request, check at least one suitable page is free */
+	for (o = order; o < MAX_ORDER; o++) {
+		struct free_area *area = &z->free_area[o];
+		int mt;
+
+		if (!area->nr_free)
+			continue;
+
+		if (alloc_harder)
+			return true;
+
+		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+			if (!list_empty(&area->free_list[mt]))
+				return true;
+		}
 
-		if (free_pages <= min)
-			return false;
+#ifdef CONFIG_CMA
+		if ((alloc_flags & ALLOC_CMA) &&
+		    !list_empty(&area->free_list[MIGRATE_CMA])) {
+			return true;
+		}
+#endif
 	}
-	return true;
+	return false;
 }
 
 bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


