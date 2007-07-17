From: akpm@linux-foundation.org
Subject: - create-the-zone_movable-zone.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:37 -0700
Message-ID: <200707172300.l6HN0bDb011310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934191AbXGQXCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, wli@holomorphy.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Create the ZONE_MOVABLE zone
has been removed from the -mm tree.  Its filename was
     create-the-zone_movable-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Create the ZONE_MOVABLE zone
From: Mel Gorman <mel@csn.ul.ie>

The following 8 patches against 2.6.20-mm2 create a zone called ZONE_MOVABLE
that is only usable by allocations that specify both __GFP_HIGHMEM and
__GFP_MOVABLE.  This has the effect of keeping all non-movable pages within a
single memory partition while allowing movable allocations to be satisfied
from either partition.  The patches may be applied with the list-based
anti-fragmentation patches that groups pages together based on mobility.

The size of the zone is determined by a kernelcore= parameter specified at
boot-time.  This specifies how much memory is usable by non-movable
allocations and the remainder is used for ZONE_MOVABLE.  Any range of pages
within ZONE_MOVABLE can be released by migrating the pages or by reclaiming.

When selecting a zone to take pages from for ZONE_MOVABLE, there are two
things to consider.  First, only memory from the highest populated zone is
used for ZONE_MOVABLE.  On the x86, this is probably going to be ZONE_HIGHMEM
but it would be ZONE_DMA on ppc64 or possibly ZONE_DMA32 on x86_64.  Second,
the amount of memory usable by the kernel will be spread evenly throughout
NUMA nodes where possible.  If the nodes are not of equal size, the amount of
memory usable by the kernel on some nodes may be greater than others.

By default, the zone is not as useful for hugetlb allocations because they are
pinned and non-migratable (currently at least).  A sysctl is provided that
allows huge pages to be allocated from that zone.  This means that the huge
page pool can be resized to the size of ZONE_MOVABLE during the lifetime of
the system assuming that pages are not mlocked.  Despite huge pages being
non-movable, we do not introduce additional external fragmentation of note as
huge pages are always the largest contiguous block we care about.

Credit goes to Andy Whitcroft for catching a large variety of problems during
review of the patches.




This patch creates an additional zone, ZONE_MOVABLE.  This zone is only usable
by allocations which specify both __GFP_HIGHMEM and __GFP_MOVABLE.  Hot-added
memory continues to be placed in their existing destination as there is no
mechanism to redirect them to a specific zone.

[y-goto@jp.fujitsu.com: Fix section mismatch of memory hotplug related code]
[akpm@linux-foundation.org: various fixes]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |    3 
 include/linux/mm.h     |    1 
 include/linux/mmzone.h |   20 +++
 include/linux/vmstat.h |    5 
 mm/highmem.c           |    7 +
 mm/page_alloc.c        |  232 ++++++++++++++++++++++++++++++++++++++-
 mm/vmstat.c            |    2 
 7 files changed, 260 insertions(+), 10 deletions(-)

diff -puN include/linux/gfp.h~create-the-zone_movable-zone include/linux/gfp.h
--- a/include/linux/gfp.h~create-the-zone_movable-zone
+++ a/include/linux/gfp.h
@@ -106,6 +106,9 @@ static inline enum zone_type gfp_zone(gf
 	if (flags & __GFP_DMA32)
 		return ZONE_DMA32;
 #endif
+	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
+			(__GFP_HIGHMEM | __GFP_MOVABLE))
+		return ZONE_MOVABLE;
 #ifdef CONFIG_HIGHMEM
 	if (flags & __GFP_HIGHMEM)
 		return ZONE_HIGHMEM;
diff -puN include/linux/mm.h~create-the-zone_movable-zone include/linux/mm.h
--- a/include/linux/mm.h~create-the-zone_movable-zone
+++ a/include/linux/mm.h
@@ -1005,6 +1005,7 @@ extern unsigned long find_max_pfn_with_a
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
+extern int cmdline_parse_kernelcore(char *p);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
diff -puN include/linux/mmzone.h~create-the-zone_movable-zone include/linux/mmzone.h
--- a/include/linux/mmzone.h~create-the-zone_movable-zone
+++ a/include/linux/mmzone.h
@@ -146,6 +146,7 @@ enum zone_type {
 	 */
 	ZONE_HIGHMEM,
 #endif
+	ZONE_MOVABLE,
 	MAX_NR_ZONES
 };
 
@@ -167,6 +168,7 @@ enum zone_type {
 	+ defined(CONFIG_ZONE_DMA32)	\
 	+ 1				\
 	+ defined(CONFIG_HIGHMEM)	\
+	+ 1				\
 )
 #if __ZONE_COUNT < 2
 #define ZONES_SHIFT 0
@@ -499,10 +501,22 @@ static inline int populated_zone(struct 
 	return (!!zone->present_pages);
 }
 
+extern int movable_zone;
+
+static inline int zone_movable_is_highmem(void)
+{
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
+	return movable_zone == ZONE_HIGHMEM;
+#else
+	return 0;
+#endif
+}
+
 static inline int is_highmem_idx(enum zone_type idx)
 {
 #ifdef CONFIG_HIGHMEM
-	return (idx == ZONE_HIGHMEM);
+	return (idx == ZONE_HIGHMEM ||
+		(idx == ZONE_MOVABLE && zone_movable_is_highmem()));
 #else
 	return 0;
 #endif
@@ -522,7 +536,9 @@ static inline int is_normal_idx(enum zon
 static inline int is_highmem(struct zone *zone)
 {
 #ifdef CONFIG_HIGHMEM
-	return zone == zone->zone_pgdat->node_zones + ZONE_HIGHMEM;
+	int zone_idx = zone - zone->zone_pgdat->node_zones;
+	return zone_idx == ZONE_HIGHMEM ||
+		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
 #else
 	return 0;
 #endif
diff -puN include/linux/vmstat.h~create-the-zone_movable-zone include/linux/vmstat.h
--- a/include/linux/vmstat.h~create-the-zone_movable-zone
+++ a/include/linux/vmstat.h
@@ -25,7 +25,7 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx)
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx) , xx##_MOVABLE
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
@@ -170,7 +170,8 @@ static inline unsigned long node_page_st
 #ifdef CONFIG_HIGHMEM
 		zone_page_state(&zones[ZONE_HIGHMEM], item) +
 #endif
-		zone_page_state(&zones[ZONE_NORMAL], item);
+		zone_page_state(&zones[ZONE_NORMAL], item) +
+		zone_page_state(&zones[ZONE_MOVABLE], item);
 }
 
 extern void zone_statistics(struct zonelist *, struct zone *);
diff -puN mm/highmem.c~create-the-zone_movable-zone mm/highmem.c
--- a/mm/highmem.c~create-the-zone_movable-zone
+++ a/mm/highmem.c
@@ -46,9 +46,14 @@ unsigned int nr_free_highpages (void)
 	pg_data_t *pgdat;
 	unsigned int pages = 0;
 
-	for_each_online_pgdat(pgdat)
+	for_each_online_pgdat(pgdat) {
 		pages += zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
 			NR_FREE_PAGES);
+		if (zone_movable_is_highmem())
+			pages += zone_page_state(
+					&pgdat->node_zones[ZONE_MOVABLE],
+					NR_FREE_PAGES);
+	}
 
 	return pages;
 }
diff -puN mm/page_alloc.c~create-the-zone_movable-zone mm/page_alloc.c
--- a/mm/page_alloc.c~create-the-zone_movable-zone
+++ a/mm/page_alloc.c
@@ -80,8 +80,9 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 	 256,
 #endif
 #ifdef CONFIG_HIGHMEM
-	 32
+	 32,
 #endif
+	 32,
 };
 
 EXPORT_SYMBOL(totalram_pages);
@@ -95,8 +96,9 @@ static char * const zone_names[MAX_NR_ZO
 #endif
 	 "Normal",
 #ifdef CONFIG_HIGHMEM
-	 "HighMem"
+	 "HighMem",
 #endif
+	 "Movable",
 };
 
 int min_free_kbytes = 1024;
@@ -134,6 +136,12 @@ static unsigned long __meminitdata dma_r
   static unsigned long __meminitdata node_boundary_start_pfn[MAX_NUMNODES];
   static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
+  unsigned long __initdata required_kernelcore;
+  unsigned long __initdata zone_movable_pfn[MAX_NUMNODES];
+
+  /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
+  int movable_zone;
+  EXPORT_SYMBOL(movable_zone);
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 #if MAX_NUMNODES > 1
@@ -1480,7 +1488,7 @@ unsigned int nr_free_buffer_pages(void)
  */
 unsigned int nr_free_pagecache_pages(void)
 {
-	return nr_free_zone_pages(gfp_zone(GFP_HIGHUSER));
+	return nr_free_zone_pages(gfp_zone(GFP_HIGHUSER_MOVABLE));
 }
 
 static inline void show_node(struct zone *zone)
@@ -2667,6 +2675,63 @@ void __meminit get_pfn_range_for_nid(uns
 }
 
 /*
+ * This finds a zone that can be used for ZONE_MOVABLE pages. The
+ * assumption is made that zones within a node are ordered in monotonic
+ * increasing memory addresses so that the "highest" populated zone is used
+ */
+void __init find_usable_zone_for_movable(void)
+{
+	int zone_index;
+	for (zone_index = MAX_NR_ZONES - 1; zone_index >= 0; zone_index--) {
+		if (zone_index == ZONE_MOVABLE)
+			continue;
+
+		if (arch_zone_highest_possible_pfn[zone_index] >
+				arch_zone_lowest_possible_pfn[zone_index])
+			break;
+	}
+
+	VM_BUG_ON(zone_index == -1);
+	movable_zone = zone_index;
+}
+
+/*
+ * The zone ranges provided by the architecture do not include ZONE_MOVABLE
+ * because it is sized independant of architecture. Unlike the other zones,
+ * the starting point for ZONE_MOVABLE is not fixed. It may be different
+ * in each node depending on the size of each node and how evenly kernelcore
+ * is distributed. This helper function adjusts the zone ranges
+ * provided by the architecture for a given node by using the end of the
+ * highest usable zone for ZONE_MOVABLE. This preserves the assumption that
+ * zones within a node are in order of monotonic increases memory addresses
+ */
+void __meminit adjust_zone_range_for_zone_movable(int nid,
+					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
+					unsigned long *zone_start_pfn,
+					unsigned long *zone_end_pfn)
+{
+	/* Only adjust if ZONE_MOVABLE is on this node */
+	if (zone_movable_pfn[nid]) {
+		/* Size ZONE_MOVABLE */
+		if (zone_type == ZONE_MOVABLE) {
+			*zone_start_pfn = zone_movable_pfn[nid];
+			*zone_end_pfn = min(node_end_pfn,
+				arch_zone_highest_possible_pfn[movable_zone]);
+
+		/* Adjust for ZONE_MOVABLE starting within this range */
+		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
+				*zone_end_pfn > zone_movable_pfn[nid]) {
+			*zone_end_pfn = zone_movable_pfn[nid];
+
+		/* Check if this whole range is within ZONE_MOVABLE */
+		} else if (*zone_start_pfn >= zone_movable_pfn[nid])
+			*zone_start_pfn = *zone_end_pfn;
+	}
+}
+
+/*
  * Return the number of pages a zone spans in a node, including holes
  * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
  */
@@ -2681,6 +2746,9 @@ static unsigned long __meminit zone_span
 	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
 	zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
 	zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
+	adjust_zone_range_for_zone_movable(nid, zone_type,
+				node_start_pfn, node_end_pfn,
+				&zone_start_pfn, &zone_end_pfn);
 
 	/* Check that this node has pages within the zone's required range */
 	if (zone_end_pfn < node_start_pfn || zone_start_pfn > node_end_pfn)
@@ -2771,6 +2839,9 @@ static unsigned long __meminit zone_abse
 	zone_end_pfn = min(arch_zone_highest_possible_pfn[zone_type],
 							node_end_pfn);
 
+	adjust_zone_range_for_zone_movable(nid, zone_type,
+			node_start_pfn, node_end_pfn,
+			&zone_start_pfn, &zone_end_pfn);
 	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
@@ -3148,6 +3219,122 @@ unsigned long __init find_max_pfn_with_a
 	return max_pfn;
 }
 
+/*
+ * Find the PFN the Movable zone begins in each node. Kernel memory
+ * is spread evenly between nodes as long as the nodes have enough
+ * memory. When they don't, some nodes will have more kernelcore than
+ * others
+ */
+void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
+{
+	int i, nid;
+	unsigned long usable_startpfn;
+	unsigned long kernelcore_node, kernelcore_remaining;
+	int usable_nodes = num_online_nodes();
+
+	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
+	if (!required_kernelcore)
+		return;
+
+	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
+	find_usable_zone_for_movable();
+	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
+
+restart:
+	/* Spread kernelcore memory as evenly as possible throughout nodes */
+	kernelcore_node = required_kernelcore / usable_nodes;
+	for_each_online_node(nid) {
+		/*
+		 * Recalculate kernelcore_node if the division per node
+		 * now exceeds what is necessary to satisfy the requested
+		 * amount of memory for the kernel
+		 */
+		if (required_kernelcore < kernelcore_node)
+			kernelcore_node = required_kernelcore / usable_nodes;
+
+		/*
+		 * As the map is walked, we track how much memory is usable
+		 * by the kernel using kernelcore_remaining. When it is
+		 * 0, the rest of the node is usable by ZONE_MOVABLE
+		 */
+		kernelcore_remaining = kernelcore_node;
+
+		/* Go through each range of PFNs within this node */
+		for_each_active_range_index_in_nid(i, nid) {
+			unsigned long start_pfn, end_pfn;
+			unsigned long size_pages;
+
+			start_pfn = max(early_node_map[i].start_pfn,
+						zone_movable_pfn[nid]);
+			end_pfn = early_node_map[i].end_pfn;
+			if (start_pfn >= end_pfn)
+				continue;
+
+			/* Account for what is only usable for kernelcore */
+			if (start_pfn < usable_startpfn) {
+				unsigned long kernel_pages;
+				kernel_pages = min(end_pfn, usable_startpfn)
+								- start_pfn;
+
+				kernelcore_remaining -= min(kernel_pages,
+							kernelcore_remaining);
+				required_kernelcore -= min(kernel_pages,
+							required_kernelcore);
+
+				/* Continue if range is now fully accounted */
+				if (end_pfn <= usable_startpfn) {
+
+					/*
+					 * Push zone_movable_pfn to the end so
+					 * that if we have to rebalance
+					 * kernelcore across nodes, we will
+					 * not double account here
+					 */
+					zone_movable_pfn[nid] = end_pfn;
+					continue;
+				}
+				start_pfn = usable_startpfn;
+			}
+
+			/*
+			 * The usable PFN range for ZONE_MOVABLE is from
+			 * start_pfn->end_pfn. Calculate size_pages as the
+			 * number of pages used as kernelcore
+			 */
+			size_pages = end_pfn - start_pfn;
+			if (size_pages > kernelcore_remaining)
+				size_pages = kernelcore_remaining;
+			zone_movable_pfn[nid] = start_pfn + size_pages;
+
+			/*
+			 * Some kernelcore has been met, update counts and
+			 * break if the kernelcore for this node has been
+			 * satisified
+			 */
+			required_kernelcore -= min(required_kernelcore,
+								size_pages);
+			kernelcore_remaining -= size_pages;
+			if (!kernelcore_remaining)
+				break;
+		}
+	}
+
+	/*
+	 * If there is still required_kernelcore, we do another pass with one
+	 * less node in the count. This will push zone_movable_pfn[nid] further
+	 * along on the nodes that still have memory until kernelcore is
+	 * satisified
+	 */
+	usable_nodes--;
+	if (usable_nodes && required_kernelcore > usable_nodes)
+		goto restart;
+
+	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
+	for (nid = 0; nid < MAX_NUMNODES; nid++)
+		zone_movable_pfn[nid] =
+			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
+}
+
 /**
  * free_area_init_nodes - Initialise all pg_data_t and zone data
  * @max_zone_pfn: an array of max PFNs for each zone
@@ -3177,19 +3364,37 @@ void __init free_area_init_nodes(unsigne
 	arch_zone_lowest_possible_pfn[0] = find_min_pfn_with_active_regions();
 	arch_zone_highest_possible_pfn[0] = max_zone_pfn[0];
 	for (i = 1; i < MAX_NR_ZONES; i++) {
+		if (i == ZONE_MOVABLE)
+			continue;
 		arch_zone_lowest_possible_pfn[i] =
 			arch_zone_highest_possible_pfn[i-1];
 		arch_zone_highest_possible_pfn[i] =
 			max(max_zone_pfn[i], arch_zone_lowest_possible_pfn[i]);
 	}
+	arch_zone_lowest_possible_pfn[ZONE_MOVABLE] = 0;
+	arch_zone_highest_possible_pfn[ZONE_MOVABLE] = 0;
+
+	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
+	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
+	find_zone_movable_pfns_for_nodes(zone_movable_pfn);
 
 	/* Print out the zone ranges */
 	printk("Zone PFN ranges:\n");
-	for (i = 0; i < MAX_NR_ZONES; i++)
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		if (i == ZONE_MOVABLE)
+			continue;
 		printk("  %-8s %8lu -> %8lu\n",
 				zone_names[i],
 				arch_zone_lowest_possible_pfn[i],
 				arch_zone_highest_possible_pfn[i]);
+	}
+
+	/* Print out the PFNs ZONE_MOVABLE begins at in each node */
+	printk("Movable zone start PFN for each node\n");
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		if (zone_movable_pfn[i])
+			printk("  Node %d: %lu\n", i, zone_movable_pfn[i]);
+	}
 
 	/* Print out the early_node_map[] */
 	printk("early_node_map[%d] active PFN ranges\n", nr_nodemap_entries);
@@ -3206,6 +3411,25 @@ void __init free_area_init_nodes(unsigne
 				find_min_pfn_for_node(nid), NULL);
 	}
 }
+
+/*
+ * kernelcore=size sets the amount of memory for use for allocations that
+ * cannot be reclaimed or migrated.
+ */
+int __init cmdline_parse_kernelcore(char *p)
+{
+	unsigned long long coremem;
+	if (!p)
+		return -EINVAL;
+
+	coremem = memparse(p, &p);
+	required_kernelcore = coremem >> PAGE_SHIFT;
+
+	/* Paranoid check that UL is enough for required_kernelcore */
+	WARN_ON((coremem >> PAGE_SHIFT) > ULONG_MAX);
+
+	return 0;
+}
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 /**
diff -puN mm/vmstat.c~create-the-zone_movable-zone mm/vmstat.c
--- a/mm/vmstat.c~create-the-zone_movable-zone
+++ a/mm/vmstat.c
@@ -472,7 +472,7 @@ const struct seq_operations fragmentatio
 #endif
 
 #define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
-					TEXT_FOR_HIGHMEM(xx)
+					TEXT_FOR_HIGHMEM(xx) xx "_movable",
 
 static const char * const vmstat_text[] = {
 	/* Zoned VM counters */
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
