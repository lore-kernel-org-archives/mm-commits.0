From: akpm@linux-foundation.org
Subject: - config_zone_movable-zone-ifdef-cleanup-by-renumbering.patch removed from -mm tree
Date: Mon, 17 Sep 2007 19:48:15 -0700
Message-ID: <200709180248.l8I2mFB4016867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033AbXIRCs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 22:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     CONFIG_ZONE_MOVABLE: zone ifdef cleanup by renumbering
has been removed from the -mm tree.  Its filename was
     config_zone_movable-zone-ifdef-cleanup-by-renumbering.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: CONFIG_ZONE_MOVABLE: zone ifdef cleanup by renumbering
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Two patches to make ZONE_MOVABLE configurable.

This patch defines zone_idx for not-configured-zones.  like

	enum_zone_type {
		(ZONE_DMA configured)
		(ZONE_DMA32 configured)
		ZONE_NORMAL
		(ZONE_HIGHMEM configured)
		ZONE_MOVABLE
		MAX_NR_ZONES,
		(ZONE_DMA not-configured)
		(ZONE_DMA32 not-configured)
		(ZONE_HIGHMEM not-configured)
	};

By this, we can determine zone is configured or not by

	zone_idx < MAX_NR_ZONES.

We can avoid #ifdef for CONFIG_ZONE_xxx to some extent.

This patch also replaces CONFIG_ZONE_DMA_FLAG by is_configured_zone(ZONE_DMA).

Changelog: v2 -> v3
	- updated against 2.6.23-rc3-mm1.
Changelog: v1 -> v2
	- rebased to 2.6.23-rc1
	- Removed MAX_POSSIBLE_ZONES
	- Added comments

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h    |   18 +++-----
 include/linux/mmzone.h |   79 ++++++++++++++++++++++++---------------
 include/linux/vmstat.h |   24 +++++------
 mm/Kconfig             |    5 --
 mm/page-writeback.c    |    7 +--
 mm/page_alloc.c        |   37 +++++++-----------
 mm/slab.c              |    4 -
 7 files changed, 89 insertions(+), 85 deletions(-)

diff -puN include/linux/gfp.h~config_zone_movable-zone-ifdef-cleanup-by-renumbering include/linux/gfp.h
--- a/include/linux/gfp.h~config_zone_movable-zone-ifdef-cleanup-by-renumbering
+++ a/include/linux/gfp.h
@@ -121,26 +121,22 @@ static inline enum zone_type gfp_zone(gf
 {
 	int base = 0;
 
-#ifdef CONFIG_NUMA
 	if (flags & __GFP_THISNODE)
 		base = MAX_NR_ZONES;
-#endif
 
-#ifdef CONFIG_ZONE_DMA
-	if (flags & __GFP_DMA)
+	if (is_configured_zone(ZONE_DMA) && (flags & __GFP_DMA))
 		return base + ZONE_DMA;
-#endif
-#ifdef CONFIG_ZONE_DMA32
-	if (flags & __GFP_DMA32)
+
+	if (is_configured_zone(ZONE_DMA32) && (flags & __GFP_DMA32))
 		return base + ZONE_DMA32;
-#endif
+
 	if ((flags & (__GFP_HIGHMEM | __GFP_MOVABLE)) ==
 			(__GFP_HIGHMEM | __GFP_MOVABLE))
 		return base + ZONE_MOVABLE;
-#ifdef CONFIG_HIGHMEM
-	if (flags & __GFP_HIGHMEM)
+
+	if (is_configured_zone(ZONE_HIGHMEM) && (flags & __GFP_HIGHMEM))
 		return base + ZONE_HIGHMEM;
-#endif
+
 	return base + ZONE_NORMAL;
 }
 
diff -puN include/linux/mmzone.h~config_zone_movable-zone-ifdef-cleanup-by-renumbering include/linux/mmzone.h
--- a/include/linux/mmzone.h~config_zone_movable-zone-ifdef-cleanup-by-renumbering
+++ a/include/linux/mmzone.h
@@ -178,10 +178,36 @@ enum zone_type {
 	ZONE_HIGHMEM,
 #endif
 	ZONE_MOVABLE,
-	MAX_NR_ZONES
+	MAX_NR_ZONES,
+#ifndef CONFIG_ZONE_DMA
+	ZONE_DMA,
+#endif
+#ifndef CONFIG_ZONE_DMA32
+	ZONE_DMA32,
+#endif
+#ifndef CONFIG_HIGHMEM
+	ZONE_HIGHMEM,
+#endif
 };
 
 /*
+ * Test zone type is configured or not.
+ * You can use this function for avoiding #ifdef.
+ *
+ * #ifdef CONFIG_ZONE_DMA
+ *	do_something...
+ * #endif
+ * can be written as
+ * if (is_configured_zone(ZONE_DMA)) {
+ *	do_something..
+ * }
+ */
+static inline int is_configured_zone(enum zone_type zoneidx)
+{
+	return (zoneidx < MAX_NR_ZONES);
+}
+
+/*
  * When a memory allocation must conform to specific limitations (such
  * as being suitable for DMA) the caller will pass in hints to the
  * allocator in the gfp_mask, in the zone modifier bits.  These bits
@@ -573,28 +599,35 @@ static inline int populated_zone(struct 
 
 extern int movable_zone;
 
-static inline int zone_movable_is_highmem(void)
+/*
+ * Check zone is configured && specified "idx" is equal to target zone type.
+ * Zone's index is calucalted by above zone_idx().
+ */
+static inline int zone_idx_is(enum zone_type idx, enum zone_type target)
 {
-#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
-	return movable_zone == ZONE_HIGHMEM;
-#else
+	if (is_configured_zone(target) && (idx == target))
+		return 1;
 	return 0;
+}
+
+static inline int zone_movable_is_highmem(void)
+{
+#if CONFIG_ARCH_POPULATES_NODE_MAP
+	if (is_configured_zone(ZONE_HIGHMEM))
+		return movable_zone == ZONE_HIGHMEM;
 #endif
+	return 0;
 }
 
 static inline int is_highmem_idx(enum zone_type idx)
 {
-#ifdef CONFIG_HIGHMEM
-	return (idx == ZONE_HIGHMEM ||
-		(idx == ZONE_MOVABLE && zone_movable_is_highmem()));
-#else
-	return 0;
-#endif
+	return (zone_idx_is(idx, ZONE_HIGHMEM) ||
+	       (zone_idx_is(idx, ZONE_MOVABLE) && zone_movable_is_highmem()));
 }
 
 static inline int is_normal_idx(enum zone_type idx)
 {
-	return (idx == ZONE_NORMAL);
+	return zone_idx_is(idx, ZONE_NORMAL);
 }
 
 /**
@@ -605,36 +638,22 @@ static inline int is_normal_idx(enum zon
  */
 static inline int is_highmem(struct zone *zone)
 {
-#ifdef CONFIG_HIGHMEM
-	int zone_idx = zone - zone->zone_pgdat->node_zones;
-	return zone_idx == ZONE_HIGHMEM ||
-		(zone_idx == ZONE_MOVABLE && zone_movable_is_highmem());
-#else
-	return 0;
-#endif
+	return is_highmem_idx(zone_idx(zone));
 }
 
 static inline int is_normal(struct zone *zone)
 {
-	return zone == zone->zone_pgdat->node_zones + ZONE_NORMAL;
+	return zone_idx_is(zone_idx(zone), ZONE_NORMAL);
 }
 
 static inline int is_dma32(struct zone *zone)
 {
-#ifdef CONFIG_ZONE_DMA32
-	return zone == zone->zone_pgdat->node_zones + ZONE_DMA32;
-#else
-	return 0;
-#endif
+	return zone_idx_is(zone_idx(zone), ZONE_DMA32);
 }
 
 static inline int is_dma(struct zone *zone)
 {
-#ifdef CONFIG_ZONE_DMA
-	return zone == zone->zone_pgdat->node_zones + ZONE_DMA;
-#else
-	return 0;
-#endif
+	return zone_idx_is(zone_idx(zone), ZONE_DMA);
 }
 
 /* These two functions are used to setup the per zone pages min values */
diff -puN include/linux/vmstat.h~config_zone_movable-zone-ifdef-cleanup-by-renumbering include/linux/vmstat.h
--- a/include/linux/vmstat.h~config_zone_movable-zone-ifdef-cleanup-by-renumbering
+++ a/include/linux/vmstat.h
@@ -159,19 +159,19 @@ static inline unsigned long node_page_st
 				 enum zone_stat_item item)
 {
 	struct zone *zones = NODE_DATA(node)->node_zones;
+	unsigned long val = zone_page_state(&zones[ZONE_NORMAL],item);
 
-	return
-#ifdef CONFIG_ZONE_DMA
-		zone_page_state(&zones[ZONE_DMA], item) +
-#endif
-#ifdef CONFIG_ZONE_DMA32
-		zone_page_state(&zones[ZONE_DMA32], item) +
-#endif
-#ifdef CONFIG_HIGHMEM
-		zone_page_state(&zones[ZONE_HIGHMEM], item) +
-#endif
-		zone_page_state(&zones[ZONE_NORMAL], item) +
-		zone_page_state(&zones[ZONE_MOVABLE], item);
+	if (is_configured_zone(ZONE_DMA))
+		val += zone_page_state(&zones[ZONE_DMA], item);
+
+	if (is_configured_zone(ZONE_DMA32))
+		val += zone_page_state(&zones[ZONE_DMA32], item);
+
+	if (is_configured_zone(ZONE_HIGHMEM))
+		val += zone_page_state(&zones[ZONE_HIGHMEM], item);
+
+	val += zone_page_state(&zones[ZONE_MOVABLE], item);
+	return val;
 }
 
 extern void zone_statistics(struct zonelist *, struct zone *);
diff -puN mm/Kconfig~config_zone_movable-zone-ifdef-cleanup-by-renumbering mm/Kconfig
--- a/mm/Kconfig~config_zone_movable-zone-ifdef-cleanup-by-renumbering
+++ a/mm/Kconfig
@@ -176,11 +176,6 @@ config RESOURCES_64BIT
 	help
 	  This option allows memory and IO resources to be 64 bit.
 
-config ZONE_DMA_FLAG
-	int
-	default "0" if !ZONE_DMA
-	default "1"
-
 config BOUNCE
 	def_bool y
 	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
diff -puN mm/page-writeback.c~config_zone_movable-zone-ifdef-cleanup-by-renumbering mm/page-writeback.c
--- a/mm/page-writeback.c~config_zone_movable-zone-ifdef-cleanup-by-renumbering
+++ a/mm/page-writeback.c
@@ -122,10 +122,12 @@ static void background_writeout(unsigned
 
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
-#ifdef CONFIG_HIGHMEM
 	int node;
 	unsigned long x = 0;
 
+	if (!is_configured_zone(ZONE_HIGHMEM))
+		return 0;
+
 	for_each_node_state(node, N_HIGH_MEMORY) {
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
@@ -141,9 +143,6 @@ static unsigned long highmem_dirtyable_m
 	 * that this does not occur.
 	 */
 	return min(x, total);
-#else
-	return 0;
-#endif
 }
 
 static unsigned long determine_dirtyable_memory(void)
diff -puN mm/page_alloc.c~config_zone_movable-zone-ifdef-cleanup-by-renumbering mm/page_alloc.c
--- a/mm/page_alloc.c~config_zone_movable-zone-ifdef-cleanup-by-renumbering
+++ a/mm/page_alloc.c
@@ -100,18 +100,12 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 
 EXPORT_SYMBOL(totalram_pages);
 
-static char * const zone_names[MAX_NR_ZONES] = {
-#ifdef CONFIG_ZONE_DMA
-	 "DMA",
-#endif
-#ifdef CONFIG_ZONE_DMA32
-	 "DMA32",
-#endif
-	 "Normal",
-#ifdef CONFIG_HIGHMEM
-	 "HighMem",
-#endif
-	 "Movable",
+static char * const zone_names[] = {
+	[ZONE_DMA] = "DMA",
+	[ZONE_DMA32] = "DMA32",
+	[ZONE_NORMAL] = "Normal",
+	[ZONE_HIGHMEM] = "HighMem",
+	[ZONE_MOVABLE] =  "Movable",
 };
 
 int min_free_kbytes = 1024;
@@ -1795,14 +1789,15 @@ void si_meminfo_node(struct sysinfo *val
 
 	val->totalram = pgdat->node_present_pages;
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
-#ifdef CONFIG_HIGHMEM
-	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
-	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
+	if (is_configured_zone(ZONE_HIGHMEM)) {
+		val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
+		val->freehigh =
+			zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
 			NR_FREE_PAGES);
-#else
-	val->totalhigh = 0;
-	val->freehigh = 0;
-#endif
+	} else {
+		val->totalhigh = 0;
+		val->freehigh = 0;
+	}
 	val->mem_unit = PAGE_SIZE;
 }
 #endif
@@ -3824,15 +3819,15 @@ restart:
 /* Any regular memory on that node ? */
 static void check_for_regular_memory(pg_data_t *pgdat)
 {
-#ifdef CONFIG_HIGHMEM
 	enum zone_type zone_type;
+	if (!is_configured_zone(ZONE_HIGHMEM))
+		return;
 
 	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (zone->present_pages)
 			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
 	}
-#endif
 }
 
 /**
diff -puN mm/slab.c~config_zone_movable-zone-ifdef-cleanup-by-renumbering mm/slab.c
--- a/mm/slab.c~config_zone_movable-zone-ifdef-cleanup-by-renumbering
+++ a/mm/slab.c
@@ -2342,7 +2342,7 @@ kmem_cache_create (const char *name, siz
 	cachep->slab_size = slab_size;
 	cachep->flags = flags;
 	cachep->gfpflags = 0;
-	if (CONFIG_ZONE_DMA_FLAG && (flags & SLAB_CACHE_DMA))
+	if (is_configured_zone(ZONE_DMA) && (flags & SLAB_CACHE_DMA))
 		cachep->gfpflags |= GFP_DMA;
 	cachep->buffer_size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
@@ -2663,7 +2663,7 @@ static void cache_init_objs(struct kmem_
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
 {
-	if (CONFIG_ZONE_DMA_FLAG) {
+	if (is_configured_zone(ZONE_DMA)) {
 		if (flags & GFP_DMA)
 			BUG_ON(!(cachep->gfpflags & GFP_DMA));
 		else
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

git-net.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
config_zone_movable-zone-ifdef-cleanup-by-renumbering.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
