From: akpm@linux-foundation.org
Subject: + cma-fix-counting-of-isolated-pages.patch added to -mm tree
Date: Wed, 19 Sep 2012 12:51:42 -0700
Message-ID: <20120919195143.0B4F0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:37080 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2ISTvo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 15:51:44 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so190857ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 12:51:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: b.zolnierkie@samsung.com, hughd@google.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org


The patch titled
     Subject: cma: fix counting of isolated pages
has been added to the -mm tree.  Its filename is
     cma-fix-counting-of-isolated-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: cma: fix counting of isolated pages

Isolated free pages shouldn't be accounted to NR_FREE_PAGES counter.  Fix
it by properly decreasing/increasing NR_FREE_PAGES counter in
set_migratetype_isolate()/unset_migratetype_isolate() and removing counter
adjustment for isolated pages from free_one_page() and split_free_page().

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |    9 +++++++--
 mm/page_isolation.c |   12 +++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~cma-fix-counting-of-isolated-pages mm/page_alloc.c
--- a/mm/page_alloc.c~cma-fix-counting-of-isolated-pages
+++ a/mm/page_alloc.c
@@ -690,7 +690,8 @@ static void free_one_page(struct zone *z
 	zone->pages_scanned = 0;
 
 	__free_one_page(page, zone, order, migratetype);
-	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
+	if (unlikely(migratetype != MIGRATE_ISOLATE))
+		__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	spin_unlock(&zone->lock);
 }
 
@@ -1391,6 +1392,7 @@ int capture_free_page(struct page *page,
 	unsigned int order;
 	unsigned long watermark;
 	struct zone *zone;
+	int mt;
 
 	BUG_ON(!PageBuddy(page));
 
@@ -1406,7 +1408,10 @@ int capture_free_page(struct page *page,
 	list_del(&page->lru);
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
-	__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
+
+	mt = get_pageblock_migratetype(page);
+	if (unlikely(mt != MIGRATE_ISOLATE))
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
 
 	if (alloc_order != order)
 		expand(zone, page, alloc_order, order,
diff -puN mm/page_isolation.c~cma-fix-counting-of-isolated-pages mm/page_isolation.c
--- a/mm/page_isolation.c~cma-fix-counting-of-isolated-pages
+++ a/mm/page_isolation.c
@@ -76,8 +76,12 @@ int set_migratetype_isolate(struct page 
 
 out:
 	if (!ret) {
+		unsigned long nr_pages;
+
 		set_pageblock_isolate(page);
-		move_freepages_block(zone, page, MIGRATE_ISOLATE);
+		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
+
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -nr_pages);
 	}
 
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -89,12 +93,14 @@ out:
 void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 {
 	struct zone *zone;
-	unsigned long flags;
+	unsigned long flags, nr_pages;
+
 	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
-	move_freepages_block(zone, page, migratetype);
+	nr_pages = move_freepages_block(zone, page, migratetype);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
 	restore_pageblock_isolate(page, migratetype);
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch

