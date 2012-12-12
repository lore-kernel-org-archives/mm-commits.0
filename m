From: akpm@linux-foundation.org
Subject: [merged] mm-cma-remove-watermark-hacks.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:01:12 -0800
Message-ID: <20121212200112.B847D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34932 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab2LLUBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:01:13 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so118859ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:01:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: remove watermark hacks
has been removed from the -mm tree.  Its filename was
     mm-cma-remove-watermark-hacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: remove watermark hacks

Commits 2139cbe627b89 ("cma: fix counting of isolated pages") and
d95ea5d18e69951 ("cma: fix watermark checking") introduced a reliable
method of free page accounting when memory is being allocated from CMA
regions, so the workaround introduced earlier by commit 49f223a9cd96c72
("mm: trigger page reclaim in alloc_contig_range() to stabilise
watermarks") can be finally removed.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 ------
 mm/page_alloc.c        |   58 ---------------------------------------
 2 files changed, 67 deletions(-)

diff -puN include/linux/mmzone.h~mm-cma-remove-watermark-hacks include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-cma-remove-watermark-hacks
+++ a/include/linux/mmzone.h
@@ -63,10 +63,8 @@ enum {
 
 #ifdef CONFIG_CMA
 #  define is_migrate_cma(migratetype) unlikely((migratetype) == MIGRATE_CMA)
-#  define cma_wmark_pages(zone)	zone->min_cma_pages
 #else
 #  define is_migrate_cma(migratetype) false
-#  define cma_wmark_pages(zone) 0
 #endif
 
 #define for_each_migratetype_order(order, type) \
@@ -383,13 +381,6 @@ struct zone {
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
 #endif
-#ifdef CONFIG_CMA
-	/*
-	 * CMA needs to increase watermark levels during the allocation
-	 * process to make sure that the system is not starved.
-	 */
-	unsigned long		min_cma_pages;
-#endif
 	struct free_area	free_area[MAX_ORDER];
 
 #ifndef CONFIG_SPARSEMEM
diff -puN mm/page_alloc.c~mm-cma-remove-watermark-hacks mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-remove-watermark-hacks
+++ a/mm/page_alloc.c
@@ -5218,10 +5218,6 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
-		zone->watermark[WMARK_MIN] += cma_wmark_pages(zone);
-		zone->watermark[WMARK_LOW] += cma_wmark_pages(zone);
-		zone->watermark[WMARK_HIGH] += cma_wmark_pages(zone);
-
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -5766,54 +5762,6 @@ static int __alloc_contig_migrate_range(
 	return ret > 0 ? 0 : ret;
 }
 
-/*
- * Update zone's cma pages counter used for watermark level calculation.
- */
-static inline void __update_cma_watermarks(struct zone *zone, int count)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&zone->lock, flags);
-	zone->min_cma_pages += count;
-	spin_unlock_irqrestore(&zone->lock, flags);
-	setup_per_zone_wmarks();
-}
-
-/*
- * Trigger memory pressure bump to reclaim some pages in order to be able to
- * allocate 'count' pages in single page units. Does similar work as
- *__alloc_pages_slowpath() function.
- */
-static int __reclaim_pages(struct zone *zone, gfp_t gfp_mask, int count)
-{
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	struct zonelist *zonelist = node_zonelist(0, gfp_mask);
-	int did_some_progress = 0;
-	int order = 1;
-
-	/*
-	 * Increase level of watermarks to force kswapd do his job
-	 * to stabilise at new watermark level.
-	 */
-	__update_cma_watermarks(zone, count);
-
-	/* Obey watermarks as if the page was being allocated */
-	while (!zone_watermark_ok(zone, 0, low_wmark_pages(zone), 0, 0)) {
-		wake_all_kswapd(order, zonelist, high_zoneidx, zone_idx(zone));
-
-		did_some_progress = __perform_reclaim(gfp_mask, order, zonelist,
-						      NULL);
-		if (!did_some_progress) {
-			/* Exhausted what can be done so it's blamo time */
-			out_of_memory(zonelist, gfp_mask, order, NULL, false);
-		}
-	}
-
-	/* Restore original watermark levels. */
-	__update_cma_watermarks(zone, -count);
-
-	return count;
-}
-
 /**
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
@@ -5837,7 +5785,6 @@ static int __reclaim_pages(struct zone *
 int alloc_contig_range(unsigned long start, unsigned long end,
 		       unsigned migratetype)
 {
-	struct zone *zone = page_zone(pfn_to_page(start));
 	unsigned long outer_start, outer_end;
 	int ret = 0, order;
 
@@ -5922,11 +5869,6 @@ int alloc_contig_range(unsigned long sta
 		goto done;
 	}
 
-	/*
-	 * Reclaim enough pages to make sure that contiguous allocation
-	 * will not starve the system.
-	 */
-	__reclaim_pages(zone, GFP_HIGHUSER_MOVABLE, end-start);
 
 	/* Grab isolated pages from freelists. */
 	outer_end = isolate_freepages_range(&cc, outer_start, end);
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
mm-use-migrate_prep-instead-of-migrate_prep_local.patch
linux-next.patch
mm-cma-warn-if-freed-memory-is-still-in-use.patch

