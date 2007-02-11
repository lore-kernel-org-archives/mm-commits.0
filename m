From: akpm@linux-foundation.org
Subject: - optional-zone_dma-in-the-vm.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:37 -0800
Message-ID: <200702112246.l1BMkbch015503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633AbXBKWrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, James.Bottomley@steeleye.com, ak@suse.de, apw@shadowen.org, jdike@addtoit.com, kyle@mcmartin.ca, lethal@linux-sh.org, tony.luck@intel.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     optional ZONE_DMA: optional ZONE_DMA in the VM
has been removed from the -mm tree.  Its filename was
     optional-zone_dma-in-the-vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optional ZONE_DMA: optional ZONE_DMA in the VM
From: Christoph Lameter <clameter@sgi.com>

Make ZONE_DMA optional in core code.

- ifdef all code for ZONE_DMA and related definitions following the example
  for ZONE_DMA32 and ZONE_HIGHMEM.

- Without ZONE_DMA, ZONE_HIGHMEM and ZONE_DMA32 we get to a ZONES_SHIFT of
  0.

- Modify the VM statistics to work correctly without a DMA zone.

- Modify slab to not create DMA slabs if there is no ZONE_DMA.

[akpm@osdl.org: cleanup]
[jdike@addtoit.com: build fix]
[apw@shadowen.org: Simplify calculation of the number of bits we need for ZONES_SHIFT]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h      |    2 ++
 include/linux/mmzone.h   |   26 ++++++++++++++++++++++++--
 include/linux/slab_def.h |   30 +++++++++++++++++++++---------
 include/linux/vmstat.h   |   17 +++++++++++++----
 mm/Kconfig               |    6 ++++++
 mm/page_alloc.c          |    4 ++++
 mm/slab.c                |   20 +++++++++++++-------
 mm/vmstat.c              |    8 +++++++-
 8 files changed, 90 insertions(+), 23 deletions(-)

diff -puN include/linux/gfp.h~optional-zone_dma-in-the-vm include/linux/gfp.h
--- a/include/linux/gfp.h~optional-zone_dma-in-the-vm
+++ a/include/linux/gfp.h
@@ -85,8 +85,10 @@ struct vm_area_struct;
 
 static inline enum zone_type gfp_zone(gfp_t flags)
 {
+#ifdef CONFIG_ZONE_DMA
 	if (flags & __GFP_DMA)
 		return ZONE_DMA;
+#endif
 #ifdef CONFIG_ZONE_DMA32
 	if (flags & __GFP_DMA32)
 		return ZONE_DMA32;
diff -puN include/linux/mmzone.h~optional-zone_dma-in-the-vm include/linux/mmzone.h
--- a/include/linux/mmzone.h~optional-zone_dma-in-the-vm
+++ a/include/linux/mmzone.h
@@ -96,6 +96,7 @@ struct per_cpu_pageset {
 #endif
 
 enum zone_type {
+#ifdef CONFIG_ZONE_DMA
 	/*
 	 * ZONE_DMA is used when there are devices that are not able
 	 * to do DMA to all of addressable memory (ZONE_NORMAL). Then we
@@ -116,6 +117,7 @@ enum zone_type {
 	 * 			<16M.
 	 */
 	ZONE_DMA,
+#endif
 #ifdef CONFIG_ZONE_DMA32
 	/*
 	 * x86_64 needs two ZONE_DMAs because it supports devices that are
@@ -152,11 +154,27 @@ enum zone_type {
  * match the requested limits. See gfp_zone() in include/linux/gfp.h
  */
 
-#if !defined(CONFIG_ZONE_DMA32) && !defined(CONFIG_HIGHMEM)
+/*
+ * Count the active zones.  Note that the use of defined(X) outside
+ * #if and family is not necessarily defined so ensure we cannot use
+ * it later.  Use __ZONE_COUNT to work out how many shift bits we need.
+ */
+#define __ZONE_COUNT (			\
+	  defined(CONFIG_ZONE_DMA)	\
+	+ defined(CONFIG_ZONE_DMA32)	\
+	+ 1				\
+	+ defined(CONFIG_HIGHMEM)	\
+)
+#if __ZONE_COUNT < 2
+#define ZONES_SHIFT 0
+#elif __ZONE_COUNT <= 2
 #define ZONES_SHIFT 1
-#else
+#elif __ZONE_COUNT <= 4
 #define ZONES_SHIFT 2
+#else
+#error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
+#undef __ZONE_COUNT
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */
@@ -523,7 +541,11 @@ static inline int is_dma32(struct zone *
 
 static inline int is_dma(struct zone *zone)
 {
+#ifdef CONFIG_ZONE_DMA
 	return zone == zone->zone_pgdat->node_zones + ZONE_DMA;
+#else
+	return 0;
+#endif
 }
 
 /* These two functions are used to setup the per zone pages min values */
diff -puN include/linux/slab_def.h~optional-zone_dma-in-the-vm include/linux/slab_def.h
--- a/include/linux/slab_def.h~optional-zone_dma-in-the-vm
+++ a/include/linux/slab_def.h
@@ -19,7 +19,9 @@
 struct cache_sizes {
 	size_t		 	cs_size;
 	struct kmem_cache	*cs_cachep;
+#ifdef CONFIG_ZONE_DMA
 	struct kmem_cache	*cs_dmacachep;
+#endif
 };
 extern struct cache_sizes malloc_sizes[];
 
@@ -39,9 +41,12 @@ static inline void *kmalloc(size_t size,
 			__you_cannot_kmalloc_that_much();
 		}
 found:
-		return kmem_cache_alloc((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags);
+#ifdef CONFIG_ZONE_DMA
+		if (flags & GFP_DMA)
+			return kmem_cache_alloc(malloc_sizes[i].cs_dmacachep,
+						flags);
+#endif
+		return kmem_cache_alloc(malloc_sizes[i].cs_cachep, flags);
 	}
 	return __kmalloc(size, flags);
 }
@@ -62,9 +67,12 @@ static inline void *kzalloc(size_t size,
 			__you_cannot_kzalloc_that_much();
 		}
 found:
-		return kmem_cache_zalloc((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags);
+#ifdef CONFIG_ZONE_DMA
+		if (flags & GFP_DMA)
+			return kmem_cache_zalloc(malloc_sizes[i].cs_dmacachep,
+						flags);
+#endif
+		return kmem_cache_zalloc(malloc_sizes[i].cs_cachep, flags);
 	}
 	return __kzalloc(size, flags);
 }
@@ -88,9 +96,13 @@ static inline void *kmalloc_node(size_t 
 			__you_cannot_kmalloc_that_much();
 		}
 found:
-		return kmem_cache_alloc_node((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags, node);
+#ifdef CONFIG_ZONE_DMA
+		if (flags & GFP_DMA)
+			return kmem_cache_alloc_node(malloc_sizes[i].cs_dmacachep,
+						flags, node);
+#endif
+		return kmem_cache_alloc_node(malloc_sizes[i].cs_cachep,
+						flags, node);
 	}
 	return __kmalloc_node(size, flags, node);
 }
diff -puN include/linux/vmstat.h~optional-zone_dma-in-the-vm include/linux/vmstat.h
--- a/include/linux/vmstat.h~optional-zone_dma-in-the-vm
+++ a/include/linux/vmstat.h
@@ -19,6 +19,12 @@
  * generated will simply be the increment of a global address.
  */
 
+#ifdef CONFIG_ZONE_DMA
+#define DMA_ZONE(xx) xx##_DMA,
+#else
+#define DMA_ZONE(xx)
+#endif
+
 #ifdef CONFIG_ZONE_DMA32
 #define DMA32_ZONE(xx) xx##_DMA32,
 #else
@@ -31,7 +37,7 @@
 #define HIGHMEM_ZONE(xx)
 #endif
 
-#define FOR_ALL_ZONES(xx) xx##_DMA, DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx)
+#define FOR_ALL_ZONES(xx) DMA_ZONE(xx) DMA32_ZONE(xx) xx##_NORMAL HIGHMEM_ZONE(xx)
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
@@ -96,7 +102,8 @@ static inline void vm_events_fold_cpu(in
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 
 #define __count_zone_vm_events(item, zone, delta) \
-			__count_vm_events(item##_DMA + zone_idx(zone), delta)
+		__count_vm_events(item##_NORMAL - ZONE_NORMAL + \
+		zone_idx(zone), delta)
 
 /*
  * Zone based page accounting with per cpu differentials.
@@ -143,14 +150,16 @@ static inline unsigned long node_page_st
 	struct zone *zones = NODE_DATA(node)->node_zones;
 
 	return
+#ifdef CONFIG_ZONE_DMA
+		zone_page_state(&zones[ZONE_DMA], item) +
+#endif
 #ifdef CONFIG_ZONE_DMA32
 		zone_page_state(&zones[ZONE_DMA32], item) +
 #endif
-		zone_page_state(&zones[ZONE_NORMAL], item) +
 #ifdef CONFIG_HIGHMEM
 		zone_page_state(&zones[ZONE_HIGHMEM], item) +
 #endif
-		zone_page_state(&zones[ZONE_DMA], item);
+		zone_page_state(&zones[ZONE_NORMAL], item);
 }
 
 extern void zone_statistics(struct zonelist *, struct zone *);
diff -puN mm/Kconfig~optional-zone_dma-in-the-vm mm/Kconfig
--- a/mm/Kconfig~optional-zone_dma-in-the-vm
+++ a/mm/Kconfig
@@ -161,3 +161,9 @@ config RESOURCES_64BIT
 	default 64BIT
 	help
 	  This option allows memory and IO resources to be 64 bit.
+
+config ZONE_DMA_FLAG
+	int
+	default "0" if !ZONE_DMA
+	default "1"
+
diff -puN mm/page_alloc.c~optional-zone_dma-in-the-vm mm/page_alloc.c
--- a/mm/page_alloc.c~optional-zone_dma-in-the-vm
+++ a/mm/page_alloc.c
@@ -73,7 +73,9 @@ static void __free_pages_ok(struct page 
  * don't need any ZONE_NORMAL reservation
  */
 int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1] = {
+#ifdef CONFIG_ZONE_DMA
 	 256,
+#endif
 #ifdef CONFIG_ZONE_DMA32
 	 256,
 #endif
@@ -85,7 +87,9 @@ int sysctl_lowmem_reserve_ratio[MAX_NR_Z
 EXPORT_SYMBOL(totalram_pages);
 
 static char * const zone_names[MAX_NR_ZONES] = {
+#ifdef CONFIG_ZONE_DMA
 	 "DMA",
+#endif
 #ifdef CONFIG_ZONE_DMA32
 	 "DMA32",
 #endif
diff -puN mm/slab.c~optional-zone_dma-in-the-vm mm/slab.c
--- a/mm/slab.c~optional-zone_dma-in-the-vm
+++ a/mm/slab.c
@@ -793,8 +793,10 @@ static inline struct kmem_cache *__find_
 	 * has cs_{dma,}cachep==NULL. Thus no special case
 	 * for large kmalloc calls required.
 	 */
+#ifdef CONFIG_ZONE_DMA
 	if (unlikely(gfpflags & GFP_DMA))
 		return csizep->cs_dmacachep;
+#endif
 	return csizep->cs_cachep;
 }
 
@@ -1493,13 +1495,15 @@ void __init kmem_cache_init(void)
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL, NULL);
 		}
-
-		sizes->cs_dmacachep = kmem_cache_create(names->name_dma,
+#ifdef CONFIG_ZONE_DMA
+		sizes->cs_dmacachep = kmem_cache_create(
+					names->name_dma,
 					sizes->cs_size,
 					ARCH_KMALLOC_MINALIGN,
 					ARCH_KMALLOC_FLAGS|SLAB_CACHE_DMA|
 						SLAB_PANIC,
 					NULL, NULL);
+#endif
 		sizes++;
 		names++;
 	}
@@ -2321,7 +2325,7 @@ kmem_cache_create (const char *name, siz
 	cachep->slab_size = slab_size;
 	cachep->flags = flags;
 	cachep->gfpflags = 0;
-	if (flags & SLAB_CACHE_DMA)
+	if (CONFIG_ZONE_DMA_FLAG && (flags & SLAB_CACHE_DMA))
 		cachep->gfpflags |= GFP_DMA;
 	cachep->buffer_size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
@@ -2643,10 +2647,12 @@ static void cache_init_objs(struct kmem_
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
 {
-	if (flags & GFP_DMA)
-		BUG_ON(!(cachep->gfpflags & GFP_DMA));
-	else
-		BUG_ON(cachep->gfpflags & GFP_DMA);
+	if (CONFIG_ZONE_DMA_FLAG) {
+		if (flags & GFP_DMA)
+			BUG_ON(!(cachep->gfpflags & GFP_DMA));
+		else
+			BUG_ON(cachep->gfpflags & GFP_DMA);
+	}
 }
 
 static void *slab_get_obj(struct kmem_cache *cachep, struct slab *slabp,
diff -puN mm/vmstat.c~optional-zone_dma-in-the-vm mm/vmstat.c
--- a/mm/vmstat.c~optional-zone_dma-in-the-vm
+++ a/mm/vmstat.c
@@ -408,6 +408,12 @@ const struct seq_operations fragmentatio
 	.show	= frag_show,
 };
 
+#ifdef CONFIG_ZONE_DMA
+#define TEXT_FOR_DMA(xx) xx "_dma",
+#else
+#define TEXT_FOR_DMA(xx)
+#endif
+
 #ifdef CONFIG_ZONE_DMA32
 #define TEXT_FOR_DMA32(xx) xx "_dma32",
 #else
@@ -420,7 +426,7 @@ const struct seq_operations fragmentatio
 #define TEXT_FOR_HIGHMEM(xx)
 #endif
 
-#define TEXTS_FOR_ZONES(xx) xx "_dma", TEXT_FOR_DMA32(xx) xx "_normal", \
+#define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
 					TEXT_FOR_HIGHMEM(xx)
 
 static const char * const vmstat_text[] = {
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
