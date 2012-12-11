From: akpm@linux-foundation.org
Subject: [folded-merged] mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:53:23 -0800
Message-ID: <20121211235323.931B882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62784 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab2LKXxZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:53:25 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so8279vcd.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:53:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, b.zolnierkie@samsung.com, kyungmin.park@samsung.com, mel@csn.ul.ie, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: skip watermarks check for already isolated blocks in split_free_page() fix
has been removed from the -mm tree.  Its filename was
     mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix.patch

This patch was dropped because it was folded into mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page.patch

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm: cma: skip watermarks check for already isolated blocks in split_free_page() fix

Cleanup and simplify the code which uses page migrate type.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix
+++ a/mm/page_alloc.c
@@ -1393,12 +1393,15 @@ int capture_free_page(struct page *page,
 
 	zone = page_zone(page);
 	order = page_order(page);
+	mt = get_pageblock_migratetype(page);
 
-	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE) {
+	if (mt != MIGRATE_ISOLATE) {
 		/* Obey watermarks as if the page was being allocated */
 		watermark = low_wmark_pages(zone) + (1 << order);
 		if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 			return 0;
+
+		__mod_zone_freepage_state(zone, -(1UL << order), mt);
 	}
 
 	/* Remove page from free list */
@@ -1406,10 +1409,6 @@ int capture_free_page(struct page *page,
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	mt = get_pageblock_migratetype(page);
-	if (unlikely(mt != MIGRATE_ISOLATE))
-		__mod_zone_freepage_state(zone, -(1UL << alloc_order), mt);
