From: akpm@linux-foundation.org
Subject: - use-zvc-for-inactive-and-active-counts.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:15 -0800
Message-ID: <200702112246.l1BMkFLV015476@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59479 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbXBKWqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use ZVC for inactive and active counts
has been removed from the -mm tree.  Its filename was
     use-zvc-for-inactive-and-active-counts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use ZVC for inactive and active counts
From: Christoph Lameter <clameter@sgi.com>

The determination of the dirty ratio to determine writeback behavior is
currently based on the number of total pages on the system.

However, not all pages in the system may be dirtied.  Thus the ratio is always
too low and can never reach 100%.  The ratio may be particularly skewed if
large hugepage allocations, slab allocations or device driver buffers make
large sections of memory not available anymore.  In that case we may get into
a situation in which f.e.  the background writeback ratio of 40% cannot be
reached anymore which leads to undesired writeback behavior.

This patchset fixes that issue by determining the ratio based on the actual
pages that may potentially be dirty.  These are the pages on the active and
the inactive list plus free pages.

The problem with those counts has so far been that it is expensive to
calculate these because counts from multiple nodes and multiple zones will
have to be summed up.  This patchset makes these counters ZVC counters.  This
means that a current sum per zone, per node and for the whole system is always
available via global variables and not expensive anymore to calculate.

The patchset results in some other good side effects:

- Removal of the various functions that sum up free, active and inactive
  page counts

- Cleanup of the functions that display information via the proc filesystem.


This patch:

The use of a ZVC for nr_inactive and nr_active allows a simplification of some
counter operations.  More ZVC functionality is used for sums etc in the
following patches.

[akpm@osdl.org: UP build fix]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   13 ++++-----
 include/linux/mmzone.h    |    4 +-
 include/linux/vmstat.h    |    9 ++++++
 mm/page_alloc.c           |    6 +---
 mm/vmscan.c               |   51 +++++++++++++++++++-----------------
 mm/vmstat.c               |   28 +++++++++----------
 6 files changed, 60 insertions(+), 51 deletions(-)

diff -puN include/linux/mm_inline.h~use-zvc-for-inactive-and-active-counts include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~use-zvc-for-inactive-and-active-counts
+++ a/include/linux/mm_inline.h
@@ -1,30 +1,29 @@
-
 static inline void
 add_page_to_active_list(struct zone *zone, struct page *page)
 {
 	list_add(&page->lru, &zone->active_list);
-	zone->nr_active++;
+	__inc_zone_state(zone, NR_ACTIVE);
 }
 
 static inline void
 add_page_to_inactive_list(struct zone *zone, struct page *page)
 {
 	list_add(&page->lru, &zone->inactive_list);
-	zone->nr_inactive++;
+	__inc_zone_state(zone, NR_INACTIVE);
 }
 
 static inline void
 del_page_from_active_list(struct zone *zone, struct page *page)
 {
 	list_del(&page->lru);
-	zone->nr_active--;
+	__dec_zone_state(zone, NR_ACTIVE);
 }
 
 static inline void
 del_page_from_inactive_list(struct zone *zone, struct page *page)
 {
 	list_del(&page->lru);
-	zone->nr_inactive--;
+	__dec_zone_state(zone, NR_INACTIVE);
 }
 
 static inline void
@@ -33,9 +32,9 @@ del_page_from_lru(struct zone *zone, str
 	list_del(&page->lru);
 	if (PageActive(page)) {
 		__ClearPageActive(page);
-		zone->nr_active--;
+		__dec_zone_state(zone, NR_ACTIVE);
 	} else {
-		zone->nr_inactive--;
+		__dec_zone_state(zone, NR_INACTIVE);
 	}
 }
 
diff -puN include/linux/mmzone.h~use-zvc-for-inactive-and-active-counts include/linux/mmzone.h
--- a/include/linux/mmzone.h~use-zvc-for-inactive-and-active-counts
+++ a/include/linux/mmzone.h
@@ -47,6 +47,8 @@ struct zone_padding {
 #endif
 
 enum zone_stat_item {
+	NR_INACTIVE,
+	NR_ACTIVE,
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
@@ -197,8 +199,6 @@ struct zone {
 	struct list_head	inactive_list;
 	unsigned long		nr_scan_active;
 	unsigned long		nr_scan_inactive;
-	unsigned long		nr_active;
-	unsigned long		nr_inactive;
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	int			all_unreclaimable; /* All pages pinned */
 
diff -puN include/linux/vmstat.h~use-zvc-for-inactive-and-active-counts include/linux/vmstat.h
--- a/include/linux/vmstat.h~use-zvc-for-inactive-and-active-counts
+++ a/include/linux/vmstat.h
@@ -186,6 +186,9 @@ void inc_zone_page_state(struct page *, 
 void dec_zone_page_state(struct page *, enum zone_stat_item);
 
 extern void inc_zone_state(struct zone *, enum zone_stat_item);
+extern void __inc_zone_state(struct zone *, enum zone_stat_item);
+extern void dec_zone_state(struct zone *, enum zone_stat_item);
+extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 
 void refresh_cpu_vm_stats(int);
 void refresh_vm_stats(void);
@@ -214,6 +217,12 @@ static inline void __inc_zone_page_state
 	__inc_zone_state(page_zone(page), item);
 }
 
+static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	atomic_long_dec(&zone->vm_stat[item]);
+	atomic_long_dec(&vm_stat[item]);
+}
+
 static inline void __dec_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
diff -puN mm/page_alloc.c~use-zvc-for-inactive-and-active-counts mm/page_alloc.c
--- a/mm/page_alloc.c~use-zvc-for-inactive-and-active-counts
+++ a/mm/page_alloc.c
@@ -1616,8 +1616,8 @@ void show_free_areas(void)
 			K(zone->pages_min),
 			K(zone->pages_low),
 			K(zone->pages_high),
-			K(zone->nr_active),
-			K(zone->nr_inactive),
+			K(zone_page_state(zone, NR_ACTIVE)),
+			K(zone_page_state(zone, NR_INACTIVE)),
 			K(zone->present_pages),
 			zone->pages_scanned,
 			(zone->all_unreclaimable ? "yes" : "no")
@@ -2684,8 +2684,6 @@ static void __meminit free_area_init_cor
 		INIT_LIST_HEAD(&zone->inactive_list);
 		zone->nr_scan_active = 0;
 		zone->nr_scan_inactive = 0;
-		zone->nr_active = 0;
-		zone->nr_inactive = 0;
 		zap_zone_vm_stats(zone);
 		atomic_set(&zone->reclaim_in_progress, 0);
 		if (!size)
diff -puN mm/vmscan.c~use-zvc-for-inactive-and-active-counts mm/vmscan.c
--- a/mm/vmscan.c~use-zvc-for-inactive-and-active-counts
+++ a/mm/vmscan.c
@@ -679,7 +679,7 @@ static unsigned long shrink_inactive_lis
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
 					     &zone->inactive_list,
 					     &page_list, &nr_scan);
-		zone->nr_inactive -= nr_taken;
+		__mod_zone_page_state(zone, NR_INACTIVE, -nr_taken);
 		zone->pages_scanned += nr_scan;
 		spin_unlock_irq(&zone->lru_lock);
 
@@ -740,7 +740,8 @@ static inline void note_zone_scanning_pr
 
 static inline int zone_is_near_oom(struct zone *zone)
 {
-	return zone->pages_scanned >= (zone->nr_active + zone->nr_inactive)*3;
+	return zone->pages_scanned >= (zone_page_state(zone, NR_ACTIVE)
+				+ zone_page_state(zone, NR_INACTIVE))*3;
 }
 
 /*
@@ -825,7 +826,7 @@ force_reclaim_mapped:
 	pgmoved = isolate_lru_pages(nr_pages, &zone->active_list,
 				    &l_hold, &pgscanned);
 	zone->pages_scanned += pgscanned;
-	zone->nr_active -= pgmoved;
+	__mod_zone_page_state(zone, NR_ACTIVE, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
 	while (!list_empty(&l_hold)) {
@@ -857,7 +858,7 @@ force_reclaim_mapped:
 		list_move(&page->lru, &zone->inactive_list);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
-			zone->nr_inactive += pgmoved;
+			__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
 			spin_unlock_irq(&zone->lru_lock);
 			pgdeactivate += pgmoved;
 			pgmoved = 0;
@@ -867,7 +868,7 @@ force_reclaim_mapped:
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	zone->nr_inactive += pgmoved;
+	__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
 	pgdeactivate += pgmoved;
 	if (buffer_heads_over_limit) {
 		spin_unlock_irq(&zone->lru_lock);
@@ -885,14 +886,14 @@ force_reclaim_mapped:
 		list_move(&page->lru, &zone->active_list);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
-			zone->nr_active += pgmoved;
+			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;
 			spin_unlock_irq(&zone->lru_lock);
 			__pagevec_release(&pvec);
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	zone->nr_active += pgmoved;
+	__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
@@ -918,14 +919,16 @@ static unsigned long shrink_zone(int pri
 	 * Add one to `nr_to_scan' just to make sure that the kernel will
 	 * slowly sift through the active list.
 	 */
-	zone->nr_scan_active += (zone->nr_active >> priority) + 1;
+	zone->nr_scan_active +=
+		(zone_page_state(zone, NR_ACTIVE) >> priority) + 1;
 	nr_active = zone->nr_scan_active;
 	if (nr_active >= sc->swap_cluster_max)
 		zone->nr_scan_active = 0;
 	else
 		nr_active = 0;
 
-	zone->nr_scan_inactive += (zone->nr_inactive >> priority) + 1;
+	zone->nr_scan_inactive +=
+		(zone_page_state(zone, NR_INACTIVE) >> priority) + 1;
 	nr_inactive = zone->nr_scan_inactive;
 	if (nr_inactive >= sc->swap_cluster_max)
 		zone->nr_scan_inactive = 0;
@@ -1037,7 +1040,8 @@ unsigned long try_to_free_pages(struct z
 		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 			continue;
 
-		lru_pages += zone->nr_active + zone->nr_inactive;
+		lru_pages += zone_page_state(zone, NR_ACTIVE)
+				+ zone_page_state(zone, NR_INACTIVE);
 	}
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
@@ -1182,7 +1186,8 @@ loop_again:
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 
-			lru_pages += zone->nr_active + zone->nr_inactive;
+			lru_pages += zone_page_state(zone, NR_ACTIVE)
+					+ zone_page_state(zone, NR_INACTIVE);
 		}
 
 		/*
@@ -1219,8 +1224,9 @@ loop_again:
 			if (zone->all_unreclaimable)
 				continue;
 			if (nr_slab == 0 && zone->pages_scanned >=
-				    (zone->nr_active + zone->nr_inactive) * 6)
-				zone->all_unreclaimable = 1;
+				(zone_page_state(zone, NR_ACTIVE)
+				+ zone_page_state(zone, NR_INACTIVE)) * 6)
+					zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -1385,18 +1391,22 @@ static unsigned long shrink_all_zones(un
 
 		/* For pass = 0 we don't shrink the active list */
 		if (pass > 0) {
-			zone->nr_scan_active += (zone->nr_active >> prio) + 1;
+			zone->nr_scan_active +=
+				(zone_page_state(zone, NR_ACTIVE) >> prio) + 1;
 			if (zone->nr_scan_active >= nr_pages || pass > 3) {
 				zone->nr_scan_active = 0;
-				nr_to_scan = min(nr_pages, zone->nr_active);
+				nr_to_scan = min(nr_pages,
+					zone_page_state(zone, NR_ACTIVE));
 				shrink_active_list(nr_to_scan, zone, sc, prio);
 			}
 		}
 
-		zone->nr_scan_inactive += (zone->nr_inactive >> prio) + 1;
+		zone->nr_scan_inactive +=
+			(zone_page_state(zone, NR_INACTIVE) >> prio) + 1;
 		if (zone->nr_scan_inactive >= nr_pages || pass > 3) {
 			zone->nr_scan_inactive = 0;
-			nr_to_scan = min(nr_pages, zone->nr_inactive);
+			nr_to_scan = min(nr_pages,
+				zone_page_state(zone, NR_INACTIVE));
 			ret += shrink_inactive_list(nr_to_scan, zone, sc);
 			if (ret >= nr_pages)
 				return ret;
@@ -1408,12 +1418,7 @@ static unsigned long shrink_all_zones(un
 
 static unsigned long count_lru_pages(void)
 {
-	struct zone *zone;
-	unsigned long ret = 0;
-
-	for_each_zone(zone)
-		ret += zone->nr_active + zone->nr_inactive;
-	return ret;
+	return global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
 }
 
 /*
diff -puN mm/vmstat.c~use-zvc-for-inactive-and-active-counts mm/vmstat.c
--- a/mm/vmstat.c~use-zvc-for-inactive-and-active-counts
+++ a/mm/vmstat.c
@@ -19,12 +19,10 @@ void __get_zone_counts(unsigned long *ac
 	struct zone *zones = pgdat->node_zones;
 	int i;
 
-	*active = 0;
-	*inactive = 0;
+	*active = node_page_state(pgdat->node_id, NR_ACTIVE);
+	*inactive = node_page_state(pgdat->node_id, NR_INACTIVE);
 	*free = 0;
 	for (i = 0; i < MAX_NR_ZONES; i++) {
-		*active += zones[i].nr_active;
-		*inactive += zones[i].nr_inactive;
 		*free += zones[i].free_pages;
 	}
 }
@@ -34,14 +32,12 @@ void get_zone_counts(unsigned long *acti
 {
 	struct pglist_data *pgdat;
 
-	*active = 0;
-	*inactive = 0;
+	*active = global_page_state(NR_ACTIVE);
+	*inactive = global_page_state(NR_INACTIVE);
 	*free = 0;
 	for_each_online_pgdat(pgdat) {
 		unsigned long l, m, n;
 		__get_zone_counts(&l, &m, &n, pgdat);
-		*active += l;
-		*inactive += m;
 		*free += n;
 	}
 }
@@ -239,7 +235,7 @@ EXPORT_SYMBOL(mod_zone_page_state);
  * in between and therefore the atomicity vs. interrupt cannot be exploited
  * in a useful way here.
  */
-static void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
+void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
 	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
 	s8 *p = pcp->vm_stat_diff + item;
@@ -260,9 +256,8 @@ void __inc_zone_page_state(struct page *
 }
 EXPORT_SYMBOL(__inc_zone_page_state);
 
-void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
+void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct zone *zone = page_zone(page);
 	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
 	s8 *p = pcp->vm_stat_diff + item;
 
@@ -275,6 +270,11 @@ void __dec_zone_page_state(struct page *
 		*p = overstep;
 	}
 }
+
+void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	__dec_zone_state(page_zone(page), item);
+}
 EXPORT_SYMBOL(__dec_zone_page_state);
 
 void inc_zone_state(struct zone *zone, enum zone_stat_item item)
@@ -454,6 +454,8 @@ const struct seq_operations fragmentatio
 
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
+	"nr_active",
+	"nr_inactive",
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
@@ -529,8 +531,6 @@ static int zoneinfo_show(struct seq_file
 			   "\n        min      %lu"
 			   "\n        low      %lu"
 			   "\n        high     %lu"
-			   "\n        active   %lu"
-			   "\n        inactive %lu"
 			   "\n        scanned  %lu (a: %lu i: %lu)"
 			   "\n        spanned  %lu"
 			   "\n        present  %lu",
@@ -538,8 +538,6 @@ static int zoneinfo_show(struct seq_file
 			   zone->pages_min,
 			   zone->pages_low,
 			   zone->pages_high,
-			   zone->nr_active,
-			   zone->nr_inactive,
 			   zone->pages_scanned,
 			   zone->nr_scan_active, zone->nr_scan_inactive,
 			   zone->spanned_pages,
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
