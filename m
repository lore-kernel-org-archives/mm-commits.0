From: akpm@linux-foundation.org
Subject: + mm-cma-remove-watermark-hacks.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:24:17 -0800
Message-ID: <20121108202417.7AD36100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:47780 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab2KHUYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:24:18 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so377323yen.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:24:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.szyprowski@samsung.com, arnd@arndb.de, b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org


The patch titled
     Subject: mm: cma: remove watermark hacks
has been added to the -mm tree.  Its filename is
     mm-cma-remove-watermark-hacks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 ------
 mm/page_alloc.c        |   57 ---------------------------------------
 2 files changed, 66 deletions(-)

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
@@ -373,13 +371,6 @@ struct zone {
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
@@ -5255,10 +5255,6 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
-		zone->watermark[WMARK_MIN] += cma_wmark_pages(zone);
-		zone->watermark[WMARK_LOW] += cma_wmark_pages(zone);
-		zone->watermark[WMARK_HIGH] += cma_wmark_pages(zone);
-
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -5803,54 +5799,6 @@ static int __alloc_contig_migrate_range(
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
