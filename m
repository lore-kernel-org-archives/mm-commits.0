From: akpm@osdl.org
Subject: - drain_node_page-drain-pages-in-batch-units.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:50 -0800
Message-ID: <200612072257.kB7MvoJa029325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50667 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163625AbWLGW5w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     drain_node_page(): Drain pages in batch units
has been removed from the -mm tree.  Its filename was
     drain_node_page-drain-pages-in-batch-units.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drain_node_page(): Drain pages in batch units
From: Christoph Lameter <clameter@sgi.com>

drain_node_pages() currently drains the complete pageset of all pages.  If
there are a large number of pages in the queues then we may hold off
interrupts for too long.

Duplicate the method used in free_hot_cold_page.  Only drain pcp->batch
pages at one time.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~drain_node_page-drain-pages-in-batch-units mm/page_alloc.c
--- a/mm/page_alloc.c~drain_node_page-drain-pages-in-batch-units
+++ a/mm/page_alloc.c
@@ -685,9 +685,15 @@ void drain_node_pages(int nodeid)
 
 			pcp = &pset->pcp[i];
 			if (pcp->count) {
+				int to_drain;
+
 				local_irq_save(flags);
-				free_pages_bulk(zone, pcp->count, &pcp->list, 0);
-				pcp->count = 0;
+				if (pcp->count >= pcp->batch)
+					to_drain = pcp->batch;
+				else
+					to_drain = pcp->count;
+				free_pages_bulk(zone, to_drain, &pcp->list, 0);
+				pcp->count -= to_drain;
 				local_irq_restore(flags);
 			}
 		}
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

