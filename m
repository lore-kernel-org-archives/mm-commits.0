From: akpm@linux-foundation.org
Subject: - remove-zone_dma-remains-from-sh-sh64.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:44 -0800
Message-ID: <200702112246.l1BMkiL5015512@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59537 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624AbXBKWqs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     optional ZONE_DMA: remove ZONE_DMA remains from sh/sh64
has been removed from the -mm tree.  Its filename was
     remove-zone_dma-remains-from-sh-sh64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optional ZONE_DMA: remove ZONE_DMA remains from sh/sh64
From: Christoph Lameter <clameter@sgi.com>

sh / sh64: Remove ZONE_DMA remains.

Both arches do not need ZONE_DMA

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/init.c   |   17 +----------------
 arch/sh64/Kconfig   |    3 ---
 arch/sh64/mm/init.c |    5 +----
 3 files changed, 2 insertions(+), 23 deletions(-)

diff -puN arch/sh/mm/init.c~remove-zone_dma-remains-from-sh-sh64 arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~remove-zone_dma-remains-from-sh-sh64
+++ a/arch/sh/mm/init.c
@@ -158,7 +158,6 @@ void __init paging_init(void)
 	 * Setup some defaults for the zone sizes.. these should be safe
 	 * regardless of distcontiguous memory or MMU settings.
 	 */
-	zones_size[ZONE_DMA] = 0 >> PAGE_SHIFT;
 	zones_size[ZONE_NORMAL] = __MEMORY_SIZE >> PAGE_SHIFT;
 #ifdef CONFIG_HIGHMEM
 	zones_size[ZONE_HIGHMEM] = 0 >> PAGE_SHIFT;
@@ -170,8 +169,6 @@ void __init paging_init(void)
 	 * the zone sizes accordingly, in addition to turning it on.
 	 */
 	{
-		unsigned long max_dma, low, start_pfn;
-
 		/* We don't need to map the kernel through the TLB, as
 		 * it is permanatly mapped using P1. So clear the
 		 * entire pgd. */
@@ -179,19 +176,7 @@ void __init paging_init(void)
 
 		/* Turn on the MMU */
 		enable_mmu();
-
-		/* Fixup the zone sizes */
-		start_pfn = START_PFN;
-		max_dma = virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-		low = MAX_LOW_PFN;
-
-		if (low < max_dma) {
-			zones_size[ZONE_DMA] = low - start_pfn;
-			zones_size[ZONE_NORMAL] = 0;
-		} else {
-			zones_size[ZONE_DMA] = max_dma - start_pfn;
-			zones_size[ZONE_NORMAL] = low - max_dma;
-		}
+		zones_size[ZONE_NORMAL] = MAX_LOW_PFN - START_PFN;
 	}
 
 	/* Set an initial value for the MMU.TTB so we don't have to
diff -puN arch/sh64/Kconfig~remove-zone_dma-remains-from-sh-sh64 arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~remove-zone_dma-remains-from-sh-sh64
+++ a/arch/sh64/Kconfig
@@ -36,9 +36,6 @@ config GENERIC_CALIBRATE_DELAY
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_ISA_DMA
-	bool
-
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
diff -puN arch/sh64/mm/init.c~remove-zone_dma-remains-from-sh-sh64 arch/sh64/mm/init.c
--- a/arch/sh64/mm/init.c~remove-zone_dma-remains-from-sh-sh64
+++ a/arch/sh64/mm/init.c
@@ -118,10 +118,7 @@ void __init paging_init(void)
 
 	mmu_context_cache = MMU_CONTEXT_FIRST_VERSION;
 
-        /*
-	 * All memory is good as ZONE_NORMAL (fall-through) and ZONE_DMA.
-         */
-	zones_size[ZONE_DMA] = MAX_LOW_PFN - START_PFN;
+	zones_size[ZONE_NORMAL] = MAX_LOW_PFN - START_PFN;
 	NODE_DATA(0)->node_mem_map = NULL;
 	free_area_init_node(0, NODE_DATA(0), zones_size, __MEMORY_START >> PAGE_SHIFT, 0);
 }
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
