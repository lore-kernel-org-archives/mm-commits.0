From: akpm@linux-foundation.org
Subject: - use-zvc-for-free_pages.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:18 -0800
Message-ID: <200702112246.l1BMkImh015479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932614AbXBKWqW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Use ZVC for free_pages
has been removed from the -mm tree.  Its filename was
     use-zvc-for-free_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use ZVC for free_pages
From: Christoph Lameter <clameter@sgi.com>

This is again simplifies some of the VM counter calculations through the use
of the ZVC consolidated counters.

[michal.k.k.piotrowski@gmail.com: build fix]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h  |    2 +-
 kernel/power/snapshot.c |    4 ++--
 kernel/power/swsusp.c   |    5 +++--
 mm/highmem.c            |    3 ++-
 mm/page_alloc.c         |   37 +++++++++++++------------------------
 mm/vmstat.c             |   20 ++++----------------
 6 files changed, 25 insertions(+), 46 deletions(-)

diff -puN include/linux/mmzone.h~use-zvc-for-free_pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~use-zvc-for-free_pages
+++ a/include/linux/mmzone.h
@@ -47,6 +47,7 @@ struct zone_padding {
 #endif
 
 enum zone_stat_item {
+	NR_FREE_PAGES,
 	NR_INACTIVE,
 	NR_ACTIVE,
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
@@ -157,7 +158,6 @@ enum zone_type {
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */
-	unsigned long		free_pages;
 	unsigned long		pages_min, pages_low, pages_high;
 	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
diff -puN kernel/power/snapshot.c~use-zvc-for-free_pages kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~use-zvc-for-free_pages
+++ a/kernel/power/snapshot.c
@@ -591,7 +591,7 @@ static unsigned int count_free_highmem_p
 
 	for_each_zone(zone)
 		if (populated_zone(zone) && is_highmem(zone))
-			cnt += zone->free_pages;
+			cnt += zone_page_state(zone, NR_FREE_PAGES);
 
 	return cnt;
 }
@@ -869,7 +869,7 @@ static int enough_free_mem(unsigned int 
 	for_each_zone(zone) {
 		meta += snapshot_additional_pages(zone);
 		if (!is_highmem(zone))
-			free += zone->free_pages;
+			free += zone_page_state(zone, NR_FREE_PAGES);
 	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
diff -puN kernel/power/swsusp.c~use-zvc-for-free_pages kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~use-zvc-for-free_pages
+++ a/kernel/power/swsusp.c
@@ -230,9 +230,10 @@ int swsusp_shrink_memory(void)
 		for_each_zone (zone)
 			if (populated_zone(zone)) {
 				if (is_highmem(zone)) {
-					highmem_size -= zone->free_pages;
+					highmem_size -=
+					zone_page_state(zone, NR_FREE_PAGES);
 				} else {
-					tmp -= zone->free_pages;
+					tmp -= zone_page_state(zone, NR_FREE_PAGES);
 					tmp += zone->lowmem_reserve[ZONE_NORMAL];
 					tmp += snapshot_additional_pages(zone);
 				}
diff -puN mm/highmem.c~use-zvc-for-free_pages mm/highmem.c
--- a/mm/highmem.c~use-zvc-for-free_pages
+++ a/mm/highmem.c
@@ -47,7 +47,8 @@ unsigned int nr_free_highpages (void)
 	unsigned int pages = 0;
 
 	for_each_online_pgdat(pgdat)
-		pages += pgdat->node_zones[ZONE_HIGHMEM].free_pages;
+		pages += zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
+			NR_FREE_PAGES);
 
 	return pages;
 }
diff -puN mm/page_alloc.c~use-zvc-for-free_pages mm/page_alloc.c
--- a/mm/page_alloc.c~use-zvc-for-free_pages
+++ a/mm/page_alloc.c
@@ -395,7 +395,7 @@ static inline void __free_one_page(struc
 	VM_BUG_ON(page_idx & (order_size - 1));
 	VM_BUG_ON(bad_range(zone, page));
 
-	zone->free_pages += order_size;
+	__mod_zone_page_state(zone, NR_FREE_PAGES, order_size);
 	while (order < MAX_ORDER-1) {
 		unsigned long combined_idx;
 		struct free_area *area;
@@ -631,7 +631,7 @@ static struct page *__rmqueue(struct zon
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
-		zone->free_pages -= 1UL << order;
+		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
 		expand(zone, page, order, current_order, area);
 		return page;
 	}
@@ -989,7 +989,8 @@ int zone_watermark_ok(struct zone *z, in
 		      int classzone_idx, int alloc_flags)
 {
 	/* free_pages my go negative - that's OK */
-	long min = mark, free_pages = z->free_pages - (1 << order) + 1;
+	long min = mark;
+	long free_pages = zone_page_state(z, NR_FREE_PAGES) - (1 << order) + 1;
 	int o;
 
 	if (alloc_flags & ALLOC_HIGH)
@@ -1444,13 +1445,7 @@ EXPORT_SYMBOL(free_pages);
  */
 unsigned int nr_free_pages(void)
 {
-	unsigned int sum = 0;
-	struct zone *zone;
-
-	for_each_zone(zone)
-		sum += zone->free_pages;
-
-	return sum;
+	return global_page_state(NR_FREE_PAGES);
 }
 
 EXPORT_SYMBOL(nr_free_pages);
@@ -1458,13 +1453,7 @@ EXPORT_SYMBOL(nr_free_pages);
 #ifdef CONFIG_NUMA
 unsigned int nr_free_pages_pgdat(pg_data_t *pgdat)
 {
-	unsigned int sum = 0;
-	enum zone_type i;
-
-	for (i = 0; i < MAX_NR_ZONES; i++)
-		sum += pgdat->node_zones[i].free_pages;
-
-	return sum;
+	return node_page_state(pgdat->node_id, NR_FREE_PAGES);
 }
 #endif
 
@@ -1514,7 +1503,7 @@ void si_meminfo(struct sysinfo *val)
 {
 	val->totalram = totalram_pages;
 	val->sharedram = 0;
-	val->freeram = nr_free_pages();
+	val->freeram = global_page_state(NR_FREE_PAGES);
 	val->bufferram = nr_blockdev_pages();
 	val->totalhigh = totalhigh_pages;
 	val->freehigh = nr_free_highpages();
@@ -1529,10 +1518,11 @@ void si_meminfo_node(struct sysinfo *val
 	pg_data_t *pgdat = NODE_DATA(nid);
 
 	val->totalram = pgdat->node_present_pages;
-	val->freeram = nr_free_pages_pgdat(pgdat);
+	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
 	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
-	val->freehigh = pgdat->node_zones[ZONE_HIGHMEM].free_pages;
+	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
+			NR_FREE_PAGES);
 #else
 	val->totalhigh = 0;
 	val->freehigh = 0;
@@ -1580,13 +1570,13 @@ void show_free_areas(void)
 	get_zone_counts(&active, &inactive, &free);
 
 	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu\n"
-		" free:%u slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
+		" free:%lu slab:%lu mapped:%lu pagetables:%lu bounce:%lu\n",
 		active,
 		inactive,
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
-		nr_free_pages(),
+		global_page_state(NR_FREE_PAGES),
 		global_page_state(NR_SLAB_RECLAIMABLE) +
 			global_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_page_state(NR_FILE_MAPPED),
@@ -1612,7 +1602,7 @@ void show_free_areas(void)
 			" all_unreclaimable? %s"
 			"\n",
 			zone->name,
-			K(zone->free_pages),
+			K(zone_page_state(zone, NR_FREE_PAGES)),
 			K(zone->pages_min),
 			K(zone->pages_low),
 			K(zone->pages_high),
@@ -2675,7 +2665,6 @@ static void __meminit free_area_init_cor
 		spin_lock_init(&zone->lru_lock);
 		zone_seqlock_init(zone);
 		zone->zone_pgdat = pgdat;
-		zone->free_pages = 0;
 
 		zone->prev_priority = DEF_PRIORITY;
 
diff -puN mm/vmstat.c~use-zvc-for-free_pages mm/vmstat.c
--- a/mm/vmstat.c~use-zvc-for-free_pages
+++ a/mm/vmstat.c
@@ -16,30 +16,17 @@
 void __get_zone_counts(unsigned long *active, unsigned long *inactive,
 			unsigned long *free, struct pglist_data *pgdat)
 {
-	struct zone *zones = pgdat->node_zones;
-	int i;
-
 	*active = node_page_state(pgdat->node_id, NR_ACTIVE);
 	*inactive = node_page_state(pgdat->node_id, NR_INACTIVE);
-	*free = 0;
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		*free += zones[i].free_pages;
-	}
+	*free = node_page_state(pgdat->node_id, NR_FREE_PAGES);
 }
 
 void get_zone_counts(unsigned long *active,
 		unsigned long *inactive, unsigned long *free)
 {
-	struct pglist_data *pgdat;
-
 	*active = global_page_state(NR_ACTIVE);
 	*inactive = global_page_state(NR_INACTIVE);
-	*free = 0;
-	for_each_online_pgdat(pgdat) {
-		unsigned long l, m, n;
-		__get_zone_counts(&l, &m, &n, pgdat);
-		*free += n;
-	}
+	*free = global_page_state(NR_FREE_PAGES);
 }
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
@@ -454,6 +441,7 @@ const struct seq_operations fragmentatio
 
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
+	"nr_free_pages",
 	"nr_active",
 	"nr_inactive",
 	"nr_anon_pages",
@@ -534,7 +522,7 @@ static int zoneinfo_show(struct seq_file
 			   "\n        scanned  %lu (a: %lu i: %lu)"
 			   "\n        spanned  %lu"
 			   "\n        present  %lu",
-			   zone->free_pages,
+			   zone_page_state(zone, NR_FREE_PAGES),
 			   zone->pages_min,
 			   zone->pages_low,
 			   zone->pages_high,
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
