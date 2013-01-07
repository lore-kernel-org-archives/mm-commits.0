From: akpm@linux-foundation.org
Subject: [merged] mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:39 -0800
Message-ID: <20130107192540.5E7A720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:50934 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:44 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so1261148wey.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, aaditya.kumar.30@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mhocko@suse.cz, mina86@mina86.com, minchan@kernel.org, t.stanislaws@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix zone_watermark_ok_safe() accounting of isolated pages
has been removed from the -mm tree.  Its filename was
     mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: mm: fix zone_watermark_ok_safe() accounting of isolated pages

In kernel v3.6 commit 702d1a6e07 ("memory-hotplug: fix kswapd looping
forever problem") added isolated pageblocks counter (nr_pageblock_isolate
in struct zone) and used it to adjust free pages counter in
zone_watermark_ok_safe() to prevent kswapd looping forever problem.

In kernel v3.7 commit 2139cbe627b8 ("cma: fix counting of isolated pages")
fixed accounting of isolated pages in global free pages counter.  It made
previous zone_watermark_ok_safe() fix unnecessary and potentially harmful
(cause now isolated pages may be accounted twice making free pages counter
incorrect).

This patch removes special isolated pageblocks counter altogether which
fixes zone_watermark_ok_safe() free pages check.

Reported-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 --------
 mm/page_alloc.c        |   27 ---------------------------
 mm/page_isolation.c    |   26 ++------------------------
 3 files changed, 2 insertions(+), 59 deletions(-)

diff -puN include/linux/mmzone.h~mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages
+++ a/include/linux/mmzone.h
@@ -503,14 +503,6 @@ struct zone {
 	 * rarely used fields:
 	 */
 	const char		*name;
-#ifdef CONFIG_MEMORY_ISOLATION
-	/*
-	 * the number of MIGRATE_ISOLATE *pageblock*.
-	 * We need this for free page counting. Look at zone_watermark_ok_safe.
-	 * It's protected by zone->lock
-	 */
-	int		nr_pageblock_isolate;
-#endif
 } ____cacheline_internodealigned_in_smp;
 
 typedef enum {
diff -puN mm/page_alloc.c~mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages
+++ a/mm/page_alloc.c
@@ -221,11 +221,6 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 int page_group_by_mobility_disabled __read_mostly;
 
-/*
- * NOTE:
- * Don't use set_pageblock_migratetype(page, MIGRATE_ISOLATE) directly.
- * Instead, use {un}set_pageblock_isolate.
- */
 void set_pageblock_migratetype(struct page *page, int migratetype)
 {
 
@@ -1655,20 +1650,6 @@ static bool __zone_watermark_ok(struct z
 	return true;
 }
 
-#ifdef CONFIG_MEMORY_ISOLATION
-static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
-{
-	if (unlikely(zone->nr_pageblock_isolate))
-		return zone->nr_pageblock_isolate * pageblock_nr_pages;
-	return 0;
-}
-#else
-static inline unsigned long nr_zone_isolate_freepages(struct zone *zone)
-{
-	return 0;
-}
-#endif
-
 bool zone_watermark_ok(struct zone *z, int order, unsigned long mark,
 		      int classzone_idx, int alloc_flags)
 {
@@ -1684,14 +1665,6 @@ bool zone_watermark_ok_safe(struct zone 
 	if (z->percpu_drift_mark && free_pages < z->percpu_drift_mark)
 		free_pages = zone_page_state_snapshot(z, NR_FREE_PAGES);
 
-	/*
-	 * If the zone has MIGRATE_ISOLATE type free pages, we should consider
-	 * it.  nr_zone_isolate_freepages is never accurate so kswapd might not
-	 * sleep although it could do so.  But this is more desirable for memory
-	 * hotplug than sleeping which can cause a livelock in the direct
-	 * reclaim path.
-	 */
-	free_pages -= nr_zone_isolate_freepages(z);
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
 								free_pages);
 }
diff -puN mm/page_isolation.c~mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages mm/page_isolation.c
--- a/mm/page_isolation.c~mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages
+++ a/mm/page_isolation.c
@@ -8,28 +8,6 @@
 #include <linux/memory.h>
 #include "internal.h"
 
-/* called while holding zone->lock */
-static void set_pageblock_isolate(struct page *page)
-{
-	if (get_pageblock_migratetype(page) == MIGRATE_ISOLATE)
-		return;
-
-	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
-	page_zone(page)->nr_pageblock_isolate++;
-}
-
-/* called while holding zone->lock */
-static void restore_pageblock_isolate(struct page *page, int migratetype)
-{
-	struct zone *zone = page_zone(page);
-	if (WARN_ON(get_pageblock_migratetype(page) != MIGRATE_ISOLATE))
-		return;
-
-	BUG_ON(zone->nr_pageblock_isolate <= 0);
-	set_pageblock_migratetype(page, migratetype);
-	zone->nr_pageblock_isolate--;
-}
-
 int set_migratetype_isolate(struct page *page, bool skip_hwpoisoned_pages)
 {
 	struct zone *zone;
@@ -80,7 +58,7 @@ out:
 		unsigned long nr_pages;
 		int migratetype = get_pageblock_migratetype(page);
 
-		set_pageblock_isolate(page);
+		set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
 
 		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
@@ -103,7 +81,7 @@ void unset_migratetype_isolate(struct pa
 		goto out;
 	nr_pages = move_freepages_block(zone, page, migratetype);
 	__mod_zone_freepage_state(zone, nr_pages, migratetype);
-	restore_pageblock_isolate(page, migratetype);
+	set_pageblock_migratetype(page, migratetype);
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

origin.patch
linux-next.patch
cma-make-putback_lru_pages-call-conditional.patch
cma-make-putback_lru_pages-call-conditional-fix.patch

