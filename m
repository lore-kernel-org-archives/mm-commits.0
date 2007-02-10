From: akpm@linux-foundation.org
Subject: - optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:07:09 -0800
Message-ID: <200702100807.l1A879ZO006874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbXBJIHO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:07:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Reduce CONFIG_ZONE_DMA ifdefs
has been removed from the -mm tree.  Its filename was
     optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch

This patch was dropped because it was folded into optional-zone_dma-in-the-vm.patch

------------------------------------------------------
Subject: Reduce CONFIG_ZONE_DMA ifdefs
From: Christoph Lameter <clameter@sgi.com>

V1->V2 use CONFIG_ZONE_DMA_FLAG that was defined in mm/Kconfig.

Reduce #ifdef CONFIG_ZONE_DMA

This reduces the #ifdefs in the slab allocator by adding a new
CONFIG_ZONE_DMA_FLAG in mm/Kconfig.  The definitions for the page allocator
are already minimal and orthogonal to CONFIG_ZONE_DMA32 and CONFIG_HIGHMEM.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/Kconfig |    6 ++++++
 mm/slab.c  |   22 ++++++++++------------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff -puN mm/Kconfig~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs mm/Kconfig
--- a/mm/Kconfig~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs
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
diff -puN mm/slab.c~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs mm/slab.c
--- a/mm/slab.c~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs
+++ a/mm/slab.c
@@ -1493,14 +1493,14 @@ void __init kmem_cache_init(void)
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL, NULL);
 		}
-#ifdef CONFIG_ZONE_DMA
-		sizes->cs_dmacachep = kmem_cache_create(names->name_dma,
+		if (CONFIG_ZONE_DMA_FLAG)
+			sizes->cs_dmacachep = kmem_cache_create(
+					names->name_dma,
 					sizes->cs_size,
 					ARCH_KMALLOC_MINALIGN,
 					ARCH_KMALLOC_FLAGS|SLAB_CACHE_DMA|
 						SLAB_PANIC,
 					NULL, NULL);
-#endif
 		sizes++;
 		names++;
 	}
@@ -2322,10 +2322,8 @@ kmem_cache_create (const char *name, siz
 	cachep->slab_size = slab_size;
 	cachep->flags = flags;
 	cachep->gfpflags = 0;
-#ifdef CONFIG_ZONE_DMA
-	if (flags & SLAB_CACHE_DMA)
+	if (CONFIG_ZONE_DMA_FLAG && (flags & SLAB_CACHE_DMA))
 		cachep->gfpflags |= GFP_DMA;
-#endif
 	cachep->buffer_size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
 
@@ -2646,12 +2644,12 @@ static void cache_init_objs(struct kmem_
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
 {
-#ifdef CONFIG_ZONE_DMA
-	if (flags & GFP_DMA)
-		BUG_ON(!(cachep->gfpflags & GFP_DMA));
-	else
-		BUG_ON(cachep->gfpflags & GFP_DMA);
-#endif
+	if (CONFIG_ZONE_DMA_FLAG) {
+		if (flags & GFP_DMA)
+			BUG_ON(!(cachep->gfpflags & GFP_DMA));
+		else
+			BUG_ON(cachep->gfpflags & GFP_DMA);
+	}
 }
 
 static void *slab_get_obj(struct kmem_cache *cachep, struct slab *slabp,
_

Patches currently in -mm which might be from clameter@sgi.com are

use-parameter-passed-to-cache_reap-to-determine-pointer-to.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
replace-highest_possible_node_id-with-nr_node_ids-fix.patch
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
