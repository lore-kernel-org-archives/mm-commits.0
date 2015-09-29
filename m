From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch added
 to -mm tree
Date: Tue, 29 Sep 2015 14:10:09 -0700
Message-ID: <560afe31.qznC3y7wuA9aDvVz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbbI2VKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 17:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: only enforce watermarks for order-0 allocations
has been added to the -mm tree.  Its filename is
     mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   51 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-only-enforce-watermarks-for-order-0-allocations
+++ a/mm/page_alloc.c
@@ -2308,8 +2308,10 @@ static inline bool should_fail_alloc_pag
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
@@ -2317,7 +2319,7 @@ static bool __zone_watermark_ok(struct z
 {
 	long min = mark;
 	int o;
-	long free_cma = 0;
+	const bool alloc_harder = (alloc_flags & ALLOC_HARDER);
 
 	/* free_pages may go negative - that's OK */
 	free_pages -= (1 << order) - 1;
@@ -2330,7 +2332,7 @@ static bool __zone_watermark_ok(struct z
 	 * the high-atomic reserves. This will over-estimate the size of the
 	 * atomic reserve but it avoids a search.
 	 */
-	if (likely(!(alloc_flags & ALLOC_HARDER)))
+	if (likely(!alloc_harder))
 		free_pages -= z->nr_reserved_highatomic;
 	else
 		min -= min / 4;
@@ -2338,22 +2340,43 @@ static bool __zone_watermark_ok(struct z
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
-		free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);
+		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
 
-	if (free_pages - free_cma <= min + z->lowmem_reserve[classzone_idx])
+	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
 		return false;
-	for (o = 0; o < order; o++) {
-		/* At the next order, this order's pages become unavailable */
-		free_pages -= z->free_area[o].nr_free << o;
 
-		/* Require fewer higher order pages to be free */
-		min >>= 1;
+	/* order-0 watermarks are ok */
+	if (!order)
+		return true;
+
+	/* Check at least one high-order page is free */
+	for (o = order; o < MAX_ORDER; o++) {
+		struct free_area *area = &z->free_area[o];
+		int mt;
+
+		if (!area->nr_free)
+			continue;
+
+		if (alloc_harder) {
+			if (area->nr_free)
+				return true;
+			continue;
+		}
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

mm-hugetlbfs-skip-shared-vmas-when-unmapping-private-pages-to-satisfy-a-fault.patch
mm-page_alloc-remove-unnecessary-parameter-from-zone_watermark_ok_safe.patch
mm-page_alloc-remove-unnecessary-recalculations-for-dirty-zone-balancing.patch
mm-page_alloc-remove-unnecessary-taking-of-a-seqlock-when-cpusets-are-disabled.patch
mm-page_alloc-use-masks-and-shifts-when-converting-gfp-flags-to-migrate-types.patch
mm-page_alloc-distinguish-between-being-unable-to-sleep-unwilling-to-sleep-and-avoiding-waking-kswapd.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim.patch
mm-page_alloc-delete-the-zonelist_cache.patch
mm-page_alloc-remove-migrate_reserve.patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations.patch

