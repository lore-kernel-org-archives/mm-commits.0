From: akpm@linux-foundation.org
Subject: - optional-zone_dma-for-ia64.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:40 -0800
Message-ID: <200702112246.l1BMkeYL015506@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59528 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbXBKWqm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     optional ZONE_DMA: optional ZONE_DMA for ia64
has been removed from the -mm tree.  Its filename was
     optional-zone_dma-for-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optional ZONE_DMA: optional ZONE_DMA for ia64
From: Christoph Lameter <clameter@sgi.com>

ZONE_DMA less operation for IA64 SGI platform

Disable ZONE_DMA for SGI SN2.  All memory is addressable by all devices and we
do not need any special memory pool.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig        |    4 ++--
 arch/ia64/mm/contig.c    |    4 +++-
 arch/ia64/mm/discontig.c |    6 ++++++
 3 files changed, 11 insertions(+), 3 deletions(-)

diff -puN arch/ia64/Kconfig~optional-zone_dma-for-ia64 arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~optional-zone_dma-for-ia64
+++ a/arch/ia64/Kconfig
@@ -25,8 +25,8 @@ config 64BIT
 	default y
 
 config ZONE_DMA
-	bool
-	default y
+	def_bool y
+	depends on !IA64_SGI_SN2
 
 config MMU
 	bool
diff -puN arch/ia64/mm/contig.c~optional-zone_dma-for-ia64 arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~optional-zone_dma-for-ia64
+++ a/arch/ia64/mm/contig.c
@@ -259,9 +259,11 @@ paging_init (void)
 	num_physpages = 0;
 	efi_memmap_walk(count_pages, &num_physpages);
 
-	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
+	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 	max_zone_pfns[ZONE_DMA] = max_dma;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 
 #ifdef CONFIG_VIRTUAL_MEM_MAP
diff -puN arch/ia64/mm/discontig.c~optional-zone_dma-for-ia64 arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~optional-zone_dma-for-ia64
+++ a/arch/ia64/mm/discontig.c
@@ -37,7 +37,9 @@ struct early_node_data {
 	unsigned long pernode_size;
 	struct bootmem_data bootmem_data;
 	unsigned long num_physpages;
+#ifdef CONFIG_ZONE_DMA
 	unsigned long num_dma_physpages;
+#endif
 	unsigned long min_pfn;
 	unsigned long max_pfn;
 };
@@ -633,9 +635,11 @@ static __init int count_node_pages(unsig
 	unsigned long end = start + len;
 
 	mem_data[node].num_physpages += len >> PAGE_SHIFT;
+#ifdef CONFIG_ZONE_DMA
 	if (start <= __pa(MAX_DMA_ADDRESS))
 		mem_data[node].num_dma_physpages +=
 			(min(end, __pa(MAX_DMA_ADDRESS)) - start) >>PAGE_SHIFT;
+#endif
 	start = GRANULEROUNDDOWN(start);
 	start = ORDERROUNDDOWN(start);
 	end = GRANULEROUNDUP(end);
@@ -688,7 +692,9 @@ void __init paging_init(void)
 	}
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = max_dma;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 	free_area_init_nodes(max_zone_pfns);
 
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
