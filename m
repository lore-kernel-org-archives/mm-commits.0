From: akpm@linux-foundation.org
Subject: [merged] mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:01:03 -0800
Message-ID: <20121212200108.CE431100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:48103 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab2LLUJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:09:01 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so118941yen.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:09:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: skip watermarks check for already isolated blocks in split_free_page()
has been removed from the -mm tree.  Its filename was
     mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: skip watermarks check for already isolated blocks in split_free_page()

Since commit 2139cbe627b8 ("cma: fix counting of isolated pages") free
pages in isolated pageblocks are not accounted to NR_FREE_PAGES counters,
so watermarks check is not required if one operates on a free page in
isolated pageblock.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page
+++ a/mm/page_alloc.c
@@ -1394,21 +1394,22 @@ int capture_free_page(struct page *page,
 
 	zone = page_zone(page);
 	order = page_order(page);
+	mt = get_pageblock_migratetype(page);
 
-	/* Obey watermarks as if the page was being allocated */
-	watermark = low_wmark_pages(zone) + (1 << order);
-	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
-		return 0;
+	if (mt != MIGRATE_ISOLATE) {
+		/* Obey watermarks as if the page was being allocated */
+		watermark = low_wmark_pages(zone) + (1 << order);
+		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
+			return 0;
+
+		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
+	}
 
 	/* Remove page from free list */
 	list_del(&page->lru);
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	mt = get_pageblock_migratetype(page);
-	if (unlikely(mt != MIGRATE_ISOLATE))
-		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
