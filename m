From: akpm@linux-foundation.org
Subject: +
 mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch added to -mm tree
Date: Mon, 30 Jun 2014 14:14:18 -0700
Message-ID: <53b1d32a.4uIaODmtHVZyX+c0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61747 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaF3VOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jun 2014 17:14:20 -0400
Received: by mail-vc0-f202.google.com with SMTP id id10so855392vcb.5
        for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2014 14:14:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rearrange zone fields into read-only, page alloc, statistics and page reclaim lines
has been added to the -mm tree.  Its filename is
     mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: rearrange zone fields into read-only, page alloc, statistics and page reclaim lines

The arrangement of struct zone has changed over time and now it has
reached the point where there is some inappropriate sharing going on.  On
x86-64 for example

o The zone->node field is shared with the zone lock and zone->node is
  accessed frequently from the page allocator due to the fair zone
  allocation policy.

o span_seqlock is almost never used by shares a line with free_area

o Some zone statistics share a cache line with the LRU lock so
  reclaim-intensive and allocator-intensive workloads can bounce the cache
  line on a stat update

This patch rearranges struct zone to put read-only and read-mostly fields
together and then splits the page allocator intensive fields, the zone
statistics and the page reclaim intensive fields into their own cache
lines.  Note that arguably the biggest change is reducing the size of the
lowmem_reserve type.  It should still be large enough but by shrinking it
the fields used by the page allocator fast path all fit in one cache line.

On the test configuration I used the overall size of struct zone shrunk by
one cache line.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |  201 +++++++++++++++++++--------------------
 mm/page_alloc.c        |   13 +-
 mm/vmstat.c            |    4 
 3 files changed, 113 insertions(+), 105 deletions(-)

diff -puN include/linux/mmzone.h~mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines
+++ a/include/linux/mmzone.h
@@ -324,19 +324,12 @@ enum zone_type {
 #ifndef __GENERATING_BOUNDS_H
 
 struct zone {
-	/* Fields commonly accessed by the page allocator */
+	/* Read-mostly fields */
 
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long watermark[NR_WMARK];
 
 	/*
-	 * When free pages are below this point, additional steps are taken
-	 * when reading the number of free pages to avoid per-cpu counter
-	 * drift allowing watermarks to be breached
-	 */
-	unsigned long percpu_drift_mark;
-
-	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
 	 * or/and it will be released eventually, so to avoid totally wasting several
 	 * GB of ram we must reserve some of the lower zone memory (otherwise we risk
@@ -344,41 +337,17 @@ struct zone {
 	 * on the higher zones). This array is recalculated at runtime if the
 	 * sysctl_lowmem_reserve_ratio sysctl changes.
 	 */
-	unsigned long		lowmem_reserve[MAX_NR_ZONES];
-
-	/*
-	 * This is a per-zone reserve of pages that should not be
-	 * considered dirtyable memory.
-	 */
-	unsigned long		dirty_balance_reserve;
+	unsigned int lowmem_reserve[MAX_NR_ZONES];
 
+	struct per_cpu_pageset __percpu *pageset;
 #ifdef CONFIG_NUMA
 	int node;
-	/*
-	 * zone reclaim becomes active if more unmapped pages exist.
-	 */
-	unsigned long		min_unmapped_pages;
-	unsigned long		min_slab_pages;
 #endif
-	struct per_cpu_pageset __percpu *pageset;
 	/*
-	 * free areas of different sizes
+	 * The target ratio of ACTIVE_ANON to INACTIVE_ANON pages on
+	 * this zone's LRU.  Maintained by the pageout code.
 	 */
-	spinlock_t		lock;
-#if defined CONFIG_COMPACTION || defined CONFIG_CMA
-	/* Set to true when the PG_migrate_skip bits should be cleared */
-	bool			compact_blockskip_flush;
-
-	/* pfn where compaction free scanner should start */
-	unsigned long		compact_cached_free_pfn;
-	/* pfn where async and sync compaction migration scanner should start */
-	unsigned long		compact_cached_migrate_pfn[2];
-#endif
-#ifdef CONFIG_MEMORY_HOTPLUG
-	/* see spanned/present_pages for more description */
-	seqlock_t		span_seqlock;
-#endif
-	struct free_area	free_area[MAX_ORDER];
+	unsigned int inactive_ratio;
 
 #ifndef CONFIG_SPARSEMEM
 	/*
@@ -388,74 +357,37 @@ struct zone {
 	unsigned long		*pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
 
-#ifdef CONFIG_COMPACTION
 	/*
-	 * On compaction failure, 1<<compact_defer_shift compactions
-	 * are skipped before trying again. The number attempted since
-	 * last failure is tracked with compact_considered.
+	 * This is a per-zone reserve of pages that should not be
+	 * considered dirtyable memory.
 	 */
-	unsigned int		compact_considered;
-	unsigned int		compact_defer_shift;
-	int			compact_order_failed;
-#endif
-
-	ZONE_PADDING(_pad1_)
-
-	/* Fields commonly accessed by the page reclaim scanner */
-	spinlock_t		lru_lock;
-	struct lruvec		lruvec;
-
-	/* Evictions & activations on the inactive file list */
-	atomic_long_t		inactive_age;
-
-	unsigned long		pages_scanned;	   /* since last reclaim */
-	unsigned long		flags;		   /* zone flags, see below */
-
-	/* Zone statistics */
-	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
+	unsigned long		dirty_balance_reserve;
 
 	/*
-	 * The target ratio of ACTIVE_ANON to INACTIVE_ANON pages on
-	 * this zone's LRU.  Maintained by the pageout code.
+	 * When free pages are below this point, additional steps are taken
+	 * when reading the number of free pages to avoid per-cpu counter
+	 * drift allowing watermarks to be breached
 	 */
-	unsigned int inactive_ratio;
-
-
-	ZONE_PADDING(_pad2_)
-	/* Rarely used or read-mostly fields */
+	unsigned long percpu_drift_mark;
 
+#ifdef CONFIG_NUMA
 	/*
-	 * wait_table		-- the array holding the hash table
-	 * wait_table_hash_nr_entries	-- the size of the hash table array
-	 * wait_table_bits	-- wait_table_size == (1 << wait_table_bits)
-	 *
-	 * The purpose of all these is to keep track of the people
-	 * waiting for a page to become available and make them
-	 * runnable again when possible. The trouble is that this
-	 * consumes a lot of space, especially when so few things
-	 * wait on pages at a given time. So instead of using
-	 * per-page waitqueues, we use a waitqueue hash table.
-	 *
-	 * The bucket discipline is to sleep on the same queue when
-	 * colliding and wake all in that wait queue when removing.
-	 * When something wakes, it must check to be sure its page is
-	 * truly available, a la thundering herd. The cost of a
-	 * collision is great, but given the expected load of the
-	 * table, they should be so rare as to be outweighed by the
-	 * benefits from the saved space.
-	 *
-	 * __wait_on_page_locked() and unlock_page() in mm/filemap.c, are the
-	 * primary users of these fields, and in mm/page_alloc.c
-	 * free_area_init_core() performs the initialization of them.
+	 * zone reclaim becomes active if more unmapped pages exist.
 	 */
-	wait_queue_head_t	* wait_table;
-	unsigned long		wait_table_hash_nr_entries;
-	unsigned long		wait_table_bits;
+	unsigned long		min_unmapped_pages;
+	unsigned long		min_slab_pages;
+#endif /* CONFIG_NUMA */
+
+	const char		*name;
 
 	/*
-	 * Discontig memory support fields.
+	 * Number of MIGRATE_RESEVE page block. To maintain for just
+	 * optimization. Protected by zone->lock.
 	 */
+	int			nr_migrate_reserve_block;
+
 	struct pglist_data	*zone_pgdat;
+
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
@@ -504,16 +436,89 @@ struct zone {
 	unsigned long		present_pages;
 	unsigned long		managed_pages;
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+	/* see spanned/present_pages for more description */
+	seqlock_t		span_seqlock;
+#endif
+
 	/*
-	 * Number of MIGRATE_RESEVE page block. To maintain for just
-	 * optimization. Protected by zone->lock.
+	 * wait_table		-- the array holding the hash table
+	 * wait_table_hash_nr_entries	-- the size of the hash table array
+	 * wait_table_bits	-- wait_table_size == (1 << wait_table_bits)
+	 *
+	 * The purpose of all these is to keep track of the people
+	 * waiting for a page to become available and make them
+	 * runnable again when possible. The trouble is that this
+	 * consumes a lot of space, especially when so few things
+	 * wait on pages at a given time. So instead of using
+	 * per-page waitqueues, we use a waitqueue hash table.
+	 *
+	 * The bucket discipline is to sleep on the same queue when
+	 * colliding and wake all in that wait queue when removing.
+	 * When something wakes, it must check to be sure its page is
+	 * truly available, a la thundering herd. The cost of a
+	 * collision is great, but given the expected load of the
+	 * table, they should be so rare as to be outweighed by the
+	 * benefits from the saved space.
+	 *
+	 * __wait_on_page_locked() and unlock_page() in mm/filemap.c, are the
+	 * primary users of these fields, and in mm/page_alloc.c
+	 * free_area_init_core() performs the initialization of them.
 	 */
-	int			nr_migrate_reserve_block;
+	wait_queue_head_t	*wait_table;
+	unsigned long		wait_table_hash_nr_entries;
+	unsigned long		wait_table_bits;
+
+	ZONE_PADDING(_pad1_)
+
+	/* Write-intensive fields used from the page allocator */
+	spinlock_t		lock;
+
+	/* free areas of different sizes */
+	struct free_area	free_area[MAX_ORDER];
+
+	/* zone flags, see below */
+	unsigned long		flags;
+
+	ZONE_PADDING(_pad2_)
+
+	/* Write-intensive fields used by page reclaim */
 
+	/* Fields commonly accessed by the page reclaim scanner */
+	spinlock_t		lru_lock;
+	struct lruvec		lruvec;
+
+	/* Evictions & activations on the inactive file list */
+	atomic_long_t		inactive_age;
+
+	unsigned long		pages_scanned;	   /* since last reclaim */
+
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+	/* pfn where compaction free scanner should start */
+	unsigned long		compact_cached_free_pfn;
+	/* pfn where async and sync compaction migration scanner should start */
+	unsigned long		compact_cached_migrate_pfn[2];
+#endif
+
+#ifdef CONFIG_COMPACTION
 	/*
-	 * rarely used fields:
+	 * On compaction failure, 1<<compact_defer_shift compactions
+	 * are skipped before trying again. The number attempted since
+	 * last failure is tracked with compact_considered.
 	 */
-	const char		*name;
+	unsigned int		compact_considered;
+	unsigned int		compact_defer_shift;
+	int			compact_order_failed;
+#endif
+
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+	/* Set to true when the PG_migrate_skip bits should be cleared */
+	bool			compact_blockskip_flush;
+#endif
+
+	ZONE_PADDING(_pad3_)
+	/* Zone statistics */
+	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 } ____cacheline_internodealigned_in_smp;
 
 typedef enum {
diff -puN mm/page_alloc.c~mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines
+++ a/mm/page_alloc.c
@@ -1708,7 +1708,6 @@ static bool __zone_watermark_ok(struct z
 {
 	/* free_pages my go negative - that's OK */
 	long min = mark;
-	long lowmem_reserve = z->lowmem_reserve[classzone_idx];
 	int o;
 	long free_cma = 0;
 
@@ -1723,7 +1722,7 @@ static bool __zone_watermark_ok(struct z
 		free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
 
-	if (free_pages - free_cma <= min + lowmem_reserve)
+	if (free_pages - free_cma <= min + z->lowmem_reserve[classzone_idx])
 		return false;
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
@@ -3254,7 +3253,7 @@ void show_free_areas(unsigned int filter
 			);
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
-			printk(" %lu", zone->lowmem_reserve[i]);
+			printk(" %u", zone->lowmem_reserve[i]);
 		printk("\n");
 	}
 
@@ -5577,7 +5576,7 @@ static void calculate_totalreserve_pages
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < MAX_NR_ZONES; i++) {
 			struct zone *zone = pgdat->node_zones + i;
-			unsigned long max = 0;
+			unsigned int max = 0;
 
 			/* Find valid and maximum lowmem_reserve in the zone */
 			for (j = i; j < MAX_NR_ZONES; j++) {
@@ -5628,6 +5627,7 @@ static void setup_per_zone_lowmem_reserv
 			idx = j;
 			while (idx) {
 				struct zone *lower_zone;
+				unsigned long reserve;
 
 				idx--;
 
@@ -5635,8 +5635,11 @@ static void setup_per_zone_lowmem_reserv
 					sysctl_lowmem_reserve_ratio[idx] = 1;
 
 				lower_zone = pgdat->node_zones + idx;
-				lower_zone->lowmem_reserve[j] = managed_pages /
+				reserve = managed_pages /
 					sysctl_lowmem_reserve_ratio[idx];
+				if (WARN_ON(reserve > UINT_MAX))
+					reserve = UINT_MAX;
+				lower_zone->lowmem_reserve[j] = reserve;
 				managed_pages += lower_zone->managed_pages;
 			}
 		}
diff -puN mm/vmstat.c~mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines mm/vmstat.c
--- a/mm/vmstat.c~mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines
+++ a/mm/vmstat.c
@@ -1077,10 +1077,10 @@ static void zoneinfo_show_print(struct s
 				zone_page_state(zone, i));
 
 	seq_printf(m,
-		   "\n        protection: (%lu",
+		   "\n        protection: (%u",
 		   zone->lowmem_reserve[0]);
 	for (i = 1; i < ARRAY_SIZE(zone->lowmem_reserve); i++)
-		seq_printf(m, ", %lu", zone->lowmem_reserve[i]);
+		seq_printf(m, ", %u", zone->lowmem_reserve[i]);
 	seq_printf(m,
 		   ")"
 		   "\n  pagesets");
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-page_alloc-fix-cma-area-initialisation-when-pageblock-max_order.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
mem-hotplug-improve-zone_movable_is_highmem-logic.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
tracing-tell-mm_migrate_pages-event-about-numa_misplaced.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-vmscan-do-not-reclaim-from-lower-zones-if-they-are-balanced.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

