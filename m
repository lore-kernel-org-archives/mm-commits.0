From: akpm@linux-foundation.org
Subject: - optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:07:05 -0800
Message-ID: <200702100807.l1A8751W006871@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39216 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbXBJIHK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:07:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     No GFP_DMA check in the slab if no CONFIG_ZONE_DMA is set
has been removed from the -mm tree.  Its filename was
     optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch

This patch was dropped because it was folded into optional-zone_dma-in-the-vm.patch

------------------------------------------------------
Subject: No GFP_DMA check in the slab if no CONFIG_ZONE_DMA is set
From: Christoph Lameter <clameter@sgi.com>

The GFP_DMA check in the slab is not necessary if there is no ZONE_DMA
available.

The SCSI layer still sets GFP_DMA just in case which may cause the
BUG_ON to fire although there cannot be a an issue since systems with
CONFIG_ZONE_DMA off have no DMA restrictions.

This bug was triggered by Paul Jackson on an SGI Altix system.  Altix never
had any memory below 4G (meaning of ZONE_DMA on ia64) and the driver has
been working for ages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/slab.c~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set mm/slab.c
--- a/mm/slab.c~optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set
+++ a/mm/slab.c
@@ -2646,10 +2646,12 @@ static void cache_init_objs(struct kmem_
 
 static void kmem_flagcheck(struct kmem_cache *cachep, gfp_t flags)
 {
+#ifdef CONFIG_ZONE_DMA
 	if (flags & GFP_DMA)
 		BUG_ON(!(cachep->gfpflags & GFP_DMA));
 	else
 		BUG_ON(cachep->gfpflags & GFP_DMA);
+#endif
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
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
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
