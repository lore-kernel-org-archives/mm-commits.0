From: akpm@linux-foundation.org
Subject: + mm-cma-remove-alloc_cma.patch added to -mm tree
Date: Mon, 28 Aug 2017 16:00:06 -0700
Message-ID: <59a4a076.yic1Hl+1Jvrx38X7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1XAI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Aug 2017 19:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, linux@armlinux.org.uk, m.szyprowski@samsung.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, riel@redhat.com, vbabka@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: remove ALLOC_CMA
has been added to the -mm tree.  Its filename is
     mm-cma-remove-alloc_cma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-remove-alloc_cma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-remove-alloc_cma.patch

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
Subject: mm/cma: remove ALLOC_CMA

Now, all reserved pages for CMA region are belong to the ZONE_MOVABLE and
it only serves for a request with GFP_HIGHMEM && GFP_MOVABLE.  Therefore,
we don't need to maintain ALLOC_CMA at all.

Link: http://lkml.kernel.org/r/1503556593-10720-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +---
 mm/internal.h   |    1 -
 mm/page_alloc.c |   28 +++-------------------------
 3 files changed, 4 insertions(+), 29 deletions(-)

diff -puN mm/compaction.c~mm-cma-remove-alloc_cma mm/compaction.c
--- a/mm/compaction.c~mm-cma-remove-alloc_cma
+++ a/mm/compaction.c
@@ -1458,14 +1458,12 @@ static enum compact_result __compaction_
 	 * if compaction succeeds.
 	 * For costly orders, we require low watermark instead of min for
 	 * compaction to proceed to increase its chances.
-	 * ALLOC_CMA is used, as pages in CMA pageblocks are considered
-	 * suitable migration targets
 	 */
 	watermark = (order > PAGE_ALLOC_COSTLY_ORDER) ?
 				low_wmark_pages(zone) : min_wmark_pages(zone);
 	watermark += compact_gap(order);
 	if (!__zone_watermark_ok(zone, 0, watermark, classzone_idx,
-						ALLOC_CMA, wmark_target))
+						0, wmark_target))
 		return COMPACT_SKIPPED;
 
 	return COMPACT_CONTINUE;
diff -puN mm/internal.h~mm-cma-remove-alloc_cma mm/internal.h
--- a/mm/internal.h~mm-cma-remove-alloc_cma
+++ a/mm/internal.h
@@ -497,7 +497,6 @@ unsigned long reclaim_clean_pages_from_l
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
-#define ALLOC_CMA		0x80 /* allow allocations from CMA areas */
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff -puN mm/page_alloc.c~mm-cma-remove-alloc_cma mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-remove-alloc_cma
+++ a/mm/page_alloc.c
@@ -2720,7 +2720,7 @@ int __isolate_free_page(struct page *pag
 		 * exists.
 		 */
 		watermark = min_wmark_pages(zone) + (1UL << order);
-		if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
+		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 			return 0;
 
 		__mod_zone_freepage_state(zone, -(1UL << order), mt);
@@ -2997,12 +2997,6 @@ bool __zone_watermark_ok(struct zone *z,
 	}
 
 
-#ifdef CONFIG_CMA
-	/* If allocation can't use CMA areas don't use free CMA pages */
-	if (!(alloc_flags & ALLOC_CMA))
-		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
-#endif
-
 	/*
 	 * Check watermarks for an order-0 allocation request. If these
 	 * are not met, then a high-order request also cannot go ahead
@@ -3032,10 +3026,8 @@ bool __zone_watermark_ok(struct zone *z,
 		}
 
 #ifdef CONFIG_CMA
-		if ((alloc_flags & ALLOC_CMA) &&
-		    !list_empty(&area->free_list[MIGRATE_CMA])) {
+		if (!list_empty(&area->free_list[MIGRATE_CMA]))
 			return true;
-		}
 #endif
 	}
 	return false;
@@ -3052,13 +3044,6 @@ static inline bool zone_watermark_fast(s
 		unsigned long mark, int classzone_idx, unsigned int alloc_flags)
 {
 	long free_pages = zone_page_state(z, NR_FREE_PAGES);
-	long cma_pages = 0;
-
-#ifdef CONFIG_CMA
-	/* If allocation can't use CMA areas don't use free CMA pages */
-	if (!(alloc_flags & ALLOC_CMA))
-		cma_pages = zone_page_state(z, NR_FREE_CMA_PAGES);
-#endif
 
 	/*
 	 * Fast check for order-0 only. If this fails then the reserves
@@ -3067,7 +3052,7 @@ static inline bool zone_watermark_fast(s
 	 * the caller is !atomic then it'll uselessly search the free
 	 * list. That corner case is then slower but it is harmless.
 	 */
-	if (!order && (free_pages - cma_pages) > mark + z->lowmem_reserve[classzone_idx])
+	if (!order && free_pages > mark + z->lowmem_reserve[classzone_idx])
 		return true;
 
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
@@ -3648,10 +3633,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-#ifdef CONFIG_CMA
-	if (gfpflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
-#endif
 	return alloc_flags;
 }
 
@@ -4127,9 +4108,6 @@ static inline bool prepare_alloc_pages(g
 	if (should_fail_alloc_page(gfp_mask, order))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
-		*alloc_flags |= ALLOC_CMA;
