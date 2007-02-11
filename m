From: akpm@linux-foundation.org
Subject: - remove-zone_dma-remains-from-parisc.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:42 -0800
Message-ID: <200702112246.l1BMkgQs015509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59569 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932628AbXBKWq7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, James.Bottomley@steeleye.com, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     optional ZONE_DMA: remove ZONE_DMA remains from parisc
has been removed from the -mm tree.  Its filename was
     remove-zone_dma-remains-from-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optional ZONE_DMA: remove ZONE_DMA remains from parisc
From: Christoph Lameter <clameter@sgi.com>

Remove ZONE_DMA remains from parisc so that kernels are build without
ZONE_DMA.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig   |    3 ---
 arch/parisc/mm/init.c |    4 +---
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/parisc/Kconfig~remove-zone_dma-remains-from-parisc arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~remove-zone_dma-remains-from-parisc
+++ a/arch/parisc/Kconfig
@@ -50,9 +50,6 @@ config TIME_LOW_RES
 	depends on SMP
 	default y
 
-config GENERIC_ISA_DMA
-	bool
-
 config GENERIC_HARDIRQS
 	def_bool y
 
diff -puN arch/parisc/mm/init.c~remove-zone_dma-remains-from-parisc arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~remove-zone_dma-remains-from-parisc
+++ a/arch/parisc/mm/init.c
@@ -808,9 +808,7 @@ void __init paging_init(void)
 	for (i = 0; i < npmem_ranges; i++) {
 		unsigned long zones_size[MAX_NR_ZONES] = { 0, };
 
-		/* We have an IOMMU, so all memory can go into a single
-		   ZONE_DMA zone. */
-		zones_size[ZONE_DMA] = pmem_ranges[i].pages;
+		zones_size[ZONE_NORMAL] = pmem_ranges[i].pages;
 
 #ifdef CONFIG_DISCONTIGMEM
 		/* Need to initialize the pfnnid_map before we can initialize
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
