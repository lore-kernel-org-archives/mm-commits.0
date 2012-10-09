From: akpm@linux-foundation.org
Subject: [merged] cma-count-free-cma-pages.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:29 -0700
Message-ID: <20121009181130.4AA7F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43032 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab2JISLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:33 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365252wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: b.zolnierkie@samsung.com, hughd@google.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cma: count free CMA pages
has been removed from the -mm tree.  Its filename was
     cma-count-free-cma-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: cma: count free CMA pages

Add NR_FREE_CMA_PAGES counter to be later used for checking watermark in
__zone_watermark_ok().  For simplicity and to avoid #ifdef hell make this
counter always available (not only when CONFIG_CMA=y).

[akpm@linux-foundation.org: use conventional migratetype naming]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 include/linux/vmstat.h |    8 ++++++++
 mm/page_alloc.c        |   26 +++++++++++++++++++-------
 mm/page_isolation.c    |    5 +++--
 mm/vmstat.c            |    1 +
 5 files changed, 32 insertions(+), 9 deletions(-)

diff -puN include/linux/mmzone.h~cma-count-free-cma-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~cma-count-free-cma-pages
+++ a/include/linux/mmzone.h
@@ -142,6 +142,7 @@ enum zone_stat_item {
 	NUMA_OTHER,		/* allocation from other node */
 #endif
 	NR_ANON_TRANSPARENT_HUGEPAGES,
+	NR_FREE_CMA_PAGES,
 	NR_VM_ZONE_STAT_ITEMS };
 
 /*
diff -puN include/linux/vmstat.h~cma-count-free-cma-pages include/linux/vmstat.h
--- a/include/linux/vmstat.h~cma-count-free-cma-pages
+++ a/include/linux/vmstat.h
@@ -253,6 +253,14 @@ static inline void refresh_zone_stat_thr
 
 #endif		/* CONFIG_SMP */
 
+static inline void __mod_zone_freepage_state(struct zone *zone, int nr_pages,
+					     int migratetype)
+{
+	__mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
+	if (is_migrate_cma(migratetype))
+		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
+}
+
 extern const char * const vmstat_text[];
 
 #endif /* _LINUX_VMSTAT_H */
diff -puN mm/page_alloc.c~cma-count-free-cma-pages mm/page_alloc.c
--- a/mm/page_alloc.c~cma-count-free-cma-pages
+++ a/mm/page_alloc.c
@@ -558,7 +558,8 @@ static inline void __free_one_page(struc
 		if (page_is_guard(buddy)) {
 			clear_page_guard_flag(buddy);
 			set_page_private(page, 0);
-			__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
+			__mod_zone_freepage_state(zone, 1 << order,
+						  migratetype);
 		} else {
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
@@ -677,6 +678,8 @@ static void free_pcppages_bulk(struct zo
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
 			__free_one_page(page, zone, 0, mt);
 			trace_mm_page_pcpu_drain(page, 0, mt);
+			if (is_migrate_cma(mt))
+				__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
 		} while (--to_free && --batch_free && !list_empty(list));
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
@@ -692,7 +695,7 @@ static void free_one_page(struct zone *z
 
 	__free_one_page(page, zone, order, migratetype);
 	if (unlikely(migratetype != MIGRATE_ISOLATE))
-		__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
+		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 	spin_unlock(&zone->lock);
 }
 
@@ -815,7 +818,8 @@ static inline void expand(struct zone *z
 			set_page_guard_flag(&page[size]);
 			set_page_private(&page[size], high);
 			/* Guard pages are not available for any usage */
-			__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << high));
+			__mod_zone_freepage_state(zone, -(1 << high),
+						  migratetype);
 			continue;
 		}
 #endif
@@ -1141,6 +1145,9 @@ static int rmqueue_bulk(struct zone *zon
 		}
 		set_page_private(page, mt);
 		list = &page->lru;
+		if (is_migrate_cma(mt))
+			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
+					      -(1 << order));
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
@@ -1412,7 +1419,7 @@ int capture_free_page(struct page *page,
 
 	mt = get_pageblock_migratetype(page);
 	if (unlikely(mt != MIGRATE_ISOLATE))
-		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
+		__mod_zone_freepage_state(zone, -(1UL << order), mt);
 
 	if (alloc_order != order)
 		expand(zone, page, alloc_order, order,
@@ -1516,7 +1523,8 @@ again:
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
-		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
+		__mod_zone_freepage_state(zone, -(1 << order),
+					  get_pageblock_migratetype(page));
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
@@ -2890,7 +2898,8 @@ void show_free_areas(unsigned int filter
 		" unevictable:%lu"
 		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
-		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n",
+		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" free_cma:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
 		global_page_state(NR_INACTIVE_ANON),
 		global_page_state(NR_ISOLATED_ANON),
@@ -2907,7 +2916,8 @@ void show_free_areas(unsigned int filter
 		global_page_state(NR_FILE_MAPPED),
 		global_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
-		global_page_state(NR_BOUNCE));
+		global_page_state(NR_BOUNCE),
+		global_page_state(NR_FREE_CMA_PAGES));
 
 	for_each_populated_zone(zone) {
 		int i;
@@ -2939,6 +2949,7 @@ void show_free_areas(unsigned int filter
 			" pagetables:%lukB"
 			" unstable:%lukB"
 			" bounce:%lukB"
+			" free_cma:%lukB"
 			" writeback_tmp:%lukB"
 			" pages_scanned:%lu"
 			" all_unreclaimable? %s"
@@ -2968,6 +2979,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
 			K(zone_page_state(zone, NR_BOUNCE)),
+			K(zone_page_state(zone, NR_FREE_CMA_PAGES)),
 			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			zone->pages_scanned,
 			(zone->all_unreclaimable ? "yes" : "no")
diff -puN mm/page_isolation.c~cma-count-free-cma-pages mm/page_isolation.c
--- a/mm/page_isolation.c~cma-count-free-cma-pages
+++ a/mm/page_isolation.c
@@ -77,11 +77,12 @@ int set_migratetype_isolate(struct page 
 out:
 	if (!ret) {
 		unsigned long nr_pages;
+		int migratetype = get_pageblock_migratetype(page);
 
 		set_pageblock_isolate(page);
 		nr_pages = move_freepages_block(zone, page, MIGRATE_ISOLATE);
 
-		__mod_zone_page_state(zone, NR_FREE_PAGES, -nr_pages);
+		__mod_zone_freepage_state(zone, -nr_pages, migratetype);
 	}
 
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -100,7 +101,7 @@ void unset_migratetype_isolate(struct pa
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
 	nr_pages = move_freepages_block(zone, page, migratetype);
-	__mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
+	__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	restore_pageblock_isolate(page, migratetype);
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
diff -puN mm/vmstat.c~cma-count-free-cma-pages mm/vmstat.c
--- a/mm/vmstat.c~cma-count-free-cma-pages
+++ a/mm/vmstat.c
@@ -722,6 +722,7 @@ const char * const vmstat_text[] = {
 	"numa_other",
 #endif
 	"nr_anon_transparent_hugepages",
+	"nr_free_cma",
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
 
_

Patches currently in -mm which might be from b.zolnierkie@samsung.com are

origin.patch

