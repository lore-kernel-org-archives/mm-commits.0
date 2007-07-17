From: akpm@linux-foundation.org
Subject: - add-a-movablecore=-parameter-for-sizing-zone_movable.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:44 -0700
Message-ID: <200707172300.l6HN0iH1011319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759643AbXGQXBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Add a movablecore= parameter for sizing ZONE_MOVABLE
has been removed from the -mm tree.  Its filename was
     add-a-movablecore=-parameter-for-sizing-zone_movable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a movablecore= parameter for sizing ZONE_MOVABLE
From: Mel Gorman <mel@csn.ul.ie>

This patch adds a new parameter for sizing ZONE_MOVABLE called
movablecore=.  While kernelcore= is used to specify the minimum amount of
memory that must be available for all allocation types, movablecore= is
used to specify the minimum amount of memory that is used for migratable
allocations.  The amount of memory used for migratable allocations
determines how large the huge page pool could be dynamically resized to at
runtime for example.

How movablecore is actually handled is that the total number of pages in
the system is calculated and a value is set for kernelcore that is

kernelcore == totalpages - movablecore

Both kernelcore= and movablecore= can be safely specified at the same time.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   10 ++++
 mm/page_alloc.c                     |   65 +++++++++++++++++++++++---
 2 files changed, 68 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~add-a-movablecore=-parameter-for-sizing-zone_movable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~add-a-movablecore=-parameter-for-sizing-zone_movable
+++ a/Documentation/kernel-parameters.txt
@@ -833,6 +833,16 @@ and is between 256 and 4096 characters. 
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
+	movablecore=nn[KMG]	[KNL,IA-32,IA-64,PPC,X86-64] This parameter
+			is similar to kernelcore except it specifies the
+			amount of memory used for migratable allocations.
+			If both kernelcore and movablecore is specified,
+			then kernelcore will be at *least* the specified
+			value but may be more. If movablecore on its own
+			is specified, the administrator must be careful
+			that the amount of memory usable for all allocations
+			is not too small.
+
 	keepinitrd	[HW,ARM]
 
 	kstack=N	[IA-32,X86-64] Print N words from the kernel stack
diff -puN mm/page_alloc.c~add-a-movablecore=-parameter-for-sizing-zone_movable mm/page_alloc.c
--- a/mm/page_alloc.c~add-a-movablecore=-parameter-for-sizing-zone_movable
+++ a/mm/page_alloc.c
@@ -137,6 +137,7 @@ static unsigned long __meminitdata dma_r
   static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
   unsigned long __initdata required_kernelcore;
+  unsigned long __initdata required_movablecore;
   unsigned long __initdata zone_movable_pfn[MAX_NUMNODES];
 
   /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
@@ -3219,6 +3220,18 @@ unsigned long __init find_max_pfn_with_a
 	return max_pfn;
 }
 
+unsigned long __init early_calculate_totalpages(void)
+{
+	int i;
+	unsigned long totalpages = 0;
+
+	for (i = 0; i < nr_nodemap_entries; i++)
+		totalpages += early_node_map[i].end_pfn -
+						early_node_map[i].start_pfn;
+
+	return totalpages;
+}
+
 /*
  * Find the PFN the Movable zone begins in each node. Kernel memory
  * is spread evenly between nodes as long as the nodes have enough
@@ -3232,6 +3245,29 @@ void __init find_zone_movable_pfns_for_n
 	unsigned long kernelcore_node, kernelcore_remaining;
 	int usable_nodes = num_online_nodes();
 
+	/*
+	 * If movablecore was specified, calculate what size of
+	 * kernelcore that corresponds so that memory usable for
+	 * any allocation type is evenly spread. If both kernelcore
+	 * and movablecore are specified, then the value of kernelcore
+	 * will be used for required_kernelcore if it's greater than
+	 * what movablecore would have allowed.
+	 */
+	if (required_movablecore) {
+		unsigned long totalpages = early_calculate_totalpages();
+		unsigned long corepages;
+
+		/*
+		 * Round-up so that ZONE_MOVABLE is at least as large as what
+		 * was requested by the user
+		 */
+		required_movablecore =
+			roundup(required_movablecore, MAX_ORDER_NR_PAGES);
+		corepages = totalpages - required_movablecore;
+
+		required_kernelcore = max(required_kernelcore, corepages);
+	}
+
 	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
 	if (!required_kernelcore)
 		return;
@@ -3412,26 +3448,41 @@ void __init free_area_init_nodes(unsigne
 	}
 }
 
-/*
- * kernelcore=size sets the amount of memory for use for allocations that
- * cannot be reclaimed or migrated.
- */
-static int __init cmdline_parse_kernelcore(char *p)
+static int __init cmdline_parse_core(char *p, unsigned long *core)
 {
 	unsigned long long coremem;
 	if (!p)
 		return -EINVAL;
 
 	coremem = memparse(p, &p);
-	required_kernelcore = coremem >> PAGE_SHIFT;
+	*core = coremem >> PAGE_SHIFT;
 
-	/* Paranoid check that UL is enough for required_kernelcore */
+	/* Paranoid check that UL is enough for the coremem value */
 	WARN_ON((coremem >> PAGE_SHIFT) > ULONG_MAX);
 
 	return 0;
 }
 
+/*
+ * kernelcore=size sets the amount of memory for use for allocations that
+ * cannot be reclaimed or migrated.
+ */
+static int __init cmdline_parse_kernelcore(char *p)
+{
+	return cmdline_parse_core(p, &required_kernelcore);
+}
+
+/*
+ * movablecore=size sets the amount of memory for use for allocations that
+ * can be reclaimed or migrated.
+ */
+static int __init cmdline_parse_movablecore(char *p)
+{
+	return cmdline_parse_core(p, &required_movablecore);
+}
+
 early_param("kernelcore", cmdline_parse_kernelcore);
+early_param("movablecore", cmdline_parse_movablecore);
 
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
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
