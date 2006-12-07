From: akpm@osdl.org
Subject: - get-rid-of-zone_table.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:02 -0800
Message-ID: <200612072256.kB7Mu2VH029159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163672AbWLGXGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Get rid of zone_table[]
has been removed from the -mm tree.  Its filename was
     get-rid-of-zone_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Get rid of zone_table[]
From: Christoph Lameter <clameter@sgi.com>

The zone table is mostly not needed.  If we have a node in the page flags
then we can get to the zone via NODE_DATA() which is much more likely to be
already in the cpu cache.

In case of SMP and UP NODE_DATA() is a constant pointer which allows us to
access an exact replica of zonetable in the node_zones field.  In all of
the above cases there will be no need at all for the zone table.

The only remaining case is if in a NUMA system the node numbers do not fit
into the page flags.  In that case we make sparse generate a table that
maps sections to nodes and use that table to to figure out the node number.
 This table is sized to fit in a single cache line for the known 32 bit
NUMA platform which makes it very likely that the information can be
obtained without a cache miss.

For sparsemem the zone table seems to be have been fairly large based on
the maximum possible number of sections and the number of zones per node. 
There is some memory saving by removing zone_table.  The main benefit is to
reduce the cache foootprint of the VM from the frequent lookups of zones. 
Plus it simplifies the page allocator.

[akpm@osdl.org: build fix]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm.h  |   57 ++++++++++++++++++++++++++----------------
 mm/memory_hotplug.c |    1 
 mm/page_alloc.c     |   22 ----------------
 mm/sparse.c         |   23 ++++++++++++++++
 4 files changed, 59 insertions(+), 44 deletions(-)

diff -puN include/linux/mm.h~get-rid-of-zone_table include/linux/mm.h
--- a/include/linux/mm.h~get-rid-of-zone_table
+++ a/include/linux/mm.h
@@ -396,7 +396,9 @@ void split_page(struct page *page, unsig
  * We are going to use the flags for the page to node mapping if its in
  * there.  This includes the case where there is no node, so it is implicit.
  */
-#define FLAGS_HAS_NODE		(NODES_WIDTH > 0 || NODES_SHIFT == 0)
+#if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
+#define NODE_NOT_IN_PAGE_FLAGS
+#endif
 
 #ifndef PFN_SECTION_SHIFT
 #define PFN_SECTION_SHIFT 0
@@ -411,13 +413,18 @@ void split_page(struct page *page, unsig
 #define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
 #define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
 
-/* NODE:ZONE or SECTION:ZONE is used to lookup the zone from a page. */
-#if FLAGS_HAS_NODE
-#define ZONETABLE_SHIFT		(NODES_SHIFT + ZONES_SHIFT)
+/* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allcator */
+#ifdef NODE_NOT_IN_PAGEFLAGS
+#define ZONEID_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
 #else
-#define ZONETABLE_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
+#define ZONEID_SHIFT		(NODES_SHIFT + ZONES_SHIFT)
+#endif
+
+#if ZONES_WIDTH > 0
+#define ZONEID_PGSHIFT		ZONES_PGSHIFT
+#else
+#define ZONEID_PGSHIFT		NODES_PGOFF
 #endif
-#define ZONETABLE_PGSHIFT	ZONES_PGSHIFT
 
 #if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
 #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
@@ -426,23 +433,25 @@ void split_page(struct page *page, unsig
 #define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
 #define NODES_MASK		((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
-#define ZONETABLE_MASK		((1UL << ZONETABLE_SHIFT) - 1)
+#define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
 
 static inline enum zone_type page_zonenum(struct page *page)
 {
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
-struct zone;
-extern struct zone *zone_table[];
-
+/*
+ * The identification function is only used by the buddy allocator for
+ * determining if two pages could be buddies. We are not really
+ * identifying a zone since we could be using a the section number
+ * id if we have not node id available in page flags.
+ * We guarantee only that it will return the same value for two
+ * combinable pages in a zone.
+ */
 static inline int page_zone_id(struct page *page)
 {
-	return (page->flags >> ZONETABLE_PGSHIFT) & ZONETABLE_MASK;
-}
-static inline struct zone *page_zone(struct page *page)
-{
-	return zone_table[page_zone_id(page)];
+	BUILD_BUG_ON(ZONEID_PGSHIFT == 0 && ZONEID_MASK);
+	return (page->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
 }
 
 static inline unsigned long zone_to_nid(struct zone *zone)
@@ -454,13 +463,20 @@ static inline unsigned long zone_to_nid(
 #endif
 }
 
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+extern unsigned long page_to_nid(struct page *page);
+#else
 static inline unsigned long page_to_nid(struct page *page)
 {
-	if (FLAGS_HAS_NODE)
-		return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
-	else
-		return zone_to_nid(page_zone(page));
+	return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
 }
+#endif
+
+static inline struct zone *page_zone(struct page *page)
+{
+	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
+}
+
 static inline unsigned long page_to_section(struct page *page)
 {
 	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
@@ -477,6 +493,7 @@ static inline void set_page_node(struct 
 	page->flags &= ~(NODES_MASK << NODES_PGSHIFT);
 	page->flags |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
+
 static inline void set_page_section(struct page *page, unsigned long section)
 {
 	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
@@ -947,8 +964,6 @@ extern void mem_init(void);
 extern void show_mem(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
-extern void zonetable_add(struct zone *zone, int nid, enum zone_type zid,
-					unsigned long pfn, unsigned long size);
 
 #ifdef CONFIG_NUMA
 extern void setup_per_cpu_pageset(void);
diff -puN mm/memory_hotplug.c~get-rid-of-zone_table mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~get-rid-of-zone_table
+++ a/mm/memory_hotplug.c
@@ -72,7 +72,6 @@ static int __add_zone(struct zone *zone,
 			return ret;
 	}
 	memmap_init_zone(nr_pages, nid, zone_type, phys_start_pfn);
-	zonetable_add(zone, nid, zone_type, phys_start_pfn, nr_pages);
 	return 0;
 }
 
diff -puN mm/page_alloc.c~get-rid-of-zone_table mm/page_alloc.c
--- a/mm/page_alloc.c~get-rid-of-zone_table
+++ a/mm/page_alloc.c
@@ -83,13 +83,6 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 
 EXPORT_SYMBOL(totalram_pages);
 
-/*
- * Used by page_zone() to look up the address of the struct zone whose
- * id is encoded in the upper bits of page->flags
- */
-struct zone *zone_table[1 << ZONETABLE_SHIFT] __read_mostly;
-EXPORT_SYMBOL(zone_table);
-
 static char *zone_names[MAX_NR_ZONES] = {
 	 "DMA",
 #ifdef CONFIG_ZONE_DMA32
@@ -1715,20 +1708,6 @@ void zone_init_free_lists(struct pglist_
 	}
 }
 
-#define ZONETABLE_INDEX(x, zone_nr)	((x << ZONES_SHIFT) | zone_nr)
-void zonetable_add(struct zone *zone, int nid, enum zone_type zid,
-		unsigned long pfn, unsigned long size)
-{
-	unsigned long snum = pfn_to_section_nr(pfn);
-	unsigned long end = pfn_to_section_nr(pfn + size);
-
-	if (FLAGS_HAS_NODE)
-		zone_table[ZONETABLE_INDEX(nid, zid)] = zone;
-	else
-		for (; snum <= end; snum++)
-			zone_table[ZONETABLE_INDEX(snum, zid)] = zone;
-}
-
 #ifndef __HAVE_ARCH_MEMMAP_INIT
 #define memmap_init(size, nid, zone, start_pfn) \
 	memmap_init_zone((size), (nid), (zone), (start_pfn))
@@ -2421,7 +2400,6 @@ static void __meminit free_area_init_cor
 		if (!size)
 			continue;
 
-		zonetable_add(zone, nid, j, zone_start_pfn, size);
 		ret = init_currently_empty_zone(zone, zone_start_pfn, size);
 		BUG_ON(ret);
 		zone_start_pfn += size;
diff -puN mm/sparse.c~get-rid-of-zone_table mm/sparse.c
--- a/mm/sparse.c~get-rid-of-zone_table
+++ a/mm/sparse.c
@@ -24,6 +24,25 @@ struct mem_section mem_section[NR_SECTIO
 #endif
 EXPORT_SYMBOL(mem_section);
 
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+/*
+ * If we did not store the node number in the page then we have to
+ * do a lookup in the section_to_node_table in order to find which
+ * node the page belongs to.
+ */
+#if MAX_NUMNODES <= 256
+static u8 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
+#else
+static u16 section_to_node_table[NR_MEM_SECTIONS] __cacheline_aligned;
+#endif
+
+unsigned long page_to_nid(struct page *page)
+{
+	return section_to_node_table[page_to_section(page)];
+}
+EXPORT_SYMBOL(page_to_nid);
+#endif
+
 #ifdef CONFIG_SPARSEMEM_EXTREME
 static struct mem_section *sparse_index_alloc(int nid)
 {
@@ -49,6 +68,10 @@ static int sparse_index_init(unsigned lo
 	struct mem_section *section;
 	int ret = 0;
 
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+	section_to_node_table[section_nr] = nid;
+#endif
+
 	if (mem_section[root])
 		return -EEXIST;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
ia64-resolve-name-clash-by-renaming-is_available_memory.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch

