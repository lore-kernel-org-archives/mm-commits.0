From: akpm@linux-foundation.org
Subject: [merged] mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:05:45 -0700
Message-ID: <53e3dc19.xmwk1g5uDzuSn8Km%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:64293 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaHGUFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:46 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1175437pab.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move zone->pages_scanned into a vmstat counter
has been removed from the -mm tree.  Its filename was
     mm-move-zone-pages_scanned-into-a-vmstat-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: move zone->pages_scanned into a vmstat counter

zone->pages_scanned is a write-intensive cache line during page reclaim
and it's also updated during page free.  Move the counter into vmstat to
take advantage of the per-cpu updates and do not update it in the free
paths unless necessary.

On a small UMA machine running tiobench the difference is marginal.  On a
4-node machine the overhead is more noticable.  Note that automatic NUMA
balancing was disabled for this test as otherwise the system CPU overhead
is unpredictable.

          3.16.0-rc3  3.16.0-rc3  3.16.0-rc3
             vanillarearrange-v5   vmstat-v5
User          746.94      759.78      774.56
System      65336.22    58350.98    32847.27
Elapsed     27553.52    27282.02    27415.04

Note that the overhead reduction will vary depending on where exactly
pages are allocated and freed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/page_alloc.c        |   12 +++++++++---
 mm/vmscan.c            |    7 ++++---
 mm/vmstat.c            |    3 ++-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-move-zone-pages_scanned-into-a-vmstat-counter include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-move-zone-pages_scanned-into-a-vmstat-counter
+++ a/include/linux/mmzone.h
@@ -143,6 +143,7 @@ enum zone_stat_item {
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
+	NR_PAGES_SCANNED,	/* pages scanned since last reclaim */
 #ifdef CONFIG_NUMA
 	NUMA_HIT,		/* allocated in intended node */
 	NUMA_MISS,		/* allocated in non intended node */
@@ -480,7 +481,6 @@ struct zone {
 
 	/* Fields commonly accessed by the page reclaim scanner */
 	spinlock_t		lru_lock;
-	unsigned long		pages_scanned;	   /* since last reclaim */
 	struct lruvec		lruvec;
 
 	/* Evictions & activations on the inactive file list */
diff -puN mm/page_alloc.c~mm-move-zone-pages_scanned-into-a-vmstat-counter mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-zone-pages_scanned-into-a-vmstat-counter
+++ a/mm/page_alloc.c
@@ -680,9 +680,12 @@ static void free_pcppages_bulk(struct zo
 	int migratetype = 0;
 	int batch_free = 0;
 	int to_free = count;
+	unsigned long nr_scanned;
 
 	spin_lock(&zone->lock);
-	zone->pages_scanned = 0;
+	nr_scanned = zone_page_state(zone, NR_PAGES_SCANNED);
+	if (nr_scanned)
+		__mod_zone_page_state(zone, NR_PAGES_SCANNED, -nr_scanned);
 
 	while (to_free) {
 		struct page *page;
@@ -731,8 +734,11 @@ static void free_one_page(struct zone *z
 				unsigned int order,
 				int migratetype)
 {
+	unsigned long nr_scanned;
 	spin_lock(&zone->lock);
-	zone->pages_scanned = 0;
+	nr_scanned = zone_page_state(zone, NR_PAGES_SCANNED);
+	if (nr_scanned)
+		__mod_zone_page_state(zone, NR_PAGES_SCANNED, -nr_scanned);
 
 	__free_one_page(page, pfn, zone, order, migratetype);
 	if (unlikely(!is_migrate_isolate(migratetype)))
@@ -3248,7 +3254,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)),
 			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
-			zone->pages_scanned,
+			K(zone_page_state(zone, NR_PAGES_SCANNED)),
 			(!zone_reclaimable(zone) ? "yes" : "no")
 			);
 		printk("lowmem_reserve[]:");
diff -puN mm/vmscan.c~mm-move-zone-pages_scanned-into-a-vmstat-counter mm/vmscan.c
--- a/mm/vmscan.c~mm-move-zone-pages_scanned-into-a-vmstat-counter
+++ a/mm/vmscan.c
@@ -174,7 +174,8 @@ static unsigned long zone_reclaimable_pa
 
 bool zone_reclaimable(struct zone *zone)
 {
-	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
+	return zone_page_state(zone, NR_PAGES_SCANNED) <
+		zone_reclaimable_pages(zone) * 6;
 }
 
 static unsigned long get_lru_size(struct lruvec *lruvec, enum lru_list lru)
@@ -1508,7 +1509,7 @@ shrink_inactive_list(unsigned long nr_to
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, nr_taken);
 
 	if (global_reclaim(sc)) {
-		zone->pages_scanned += nr_scanned;
+		__mod_zone_page_state(zone, NR_PAGES_SCANNED, nr_scanned);
 		if (current_is_kswapd())
 			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scanned);
 		else
@@ -1698,7 +1699,7 @@ static void shrink_active_list(unsigned
 	nr_taken = isolate_lru_pages(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, isolate_mode, lru);
 	if (global_reclaim(sc))
-		zone->pages_scanned += nr_scanned;
+		__mod_zone_page_state(zone, NR_PAGES_SCANNED, nr_scanned);
 
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
diff -puN mm/vmstat.c~mm-move-zone-pages_scanned-into-a-vmstat-counter mm/vmstat.c
--- a/mm/vmstat.c~mm-move-zone-pages_scanned-into-a-vmstat-counter
+++ a/mm/vmstat.c
@@ -763,6 +763,7 @@ const char * const vmstat_text[] = {
 	"nr_shmem",
 	"nr_dirtied",
 	"nr_written",
+	"nr_pages_scanned",
 
 #ifdef CONFIG_NUMA
 	"numa_hit",
@@ -1067,7 +1068,7 @@ static void zoneinfo_show_print(struct s
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
-		   zone->pages_scanned,
+		   zone_page_state(zone, NR_PAGES_SCANNED),
 		   zone->spanned_pages,
 		   zone->present_pages,
 		   zone->managed_pages);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

