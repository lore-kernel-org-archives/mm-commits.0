From: akpm@osdl.org
Subject: - get-rid-of-zone_table-fix-3.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:00:59 -0800
Message-ID: <200612070300.kB730xCv026682@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40784 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967782AbWLGDBr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:01:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     get-rid-of-zone_table-fix 3
has been removed from the -mm tree.  Its filename was
     get-rid-of-zone_table-fix-3.patch

This patch was dropped because it was folded into get-rid-of-zone_table.patch

------------------------------------------------------
Subject: get-rid-of-zone_table-fix 3
From: Christoph Lameter <clameter@sgi.com>

Ensure that ZONEID_PGSHIFT is set even if ZONES_WIDTH is 0.

Andy needs to review this.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/mm.h~get-rid-of-zone_table-fix-3 include/linux/mm.h
--- a/include/linux/mm.h~get-rid-of-zone_table-fix-3
+++ a/include/linux/mm.h
@@ -419,7 +419,12 @@ void split_page(struct page *page, unsig
 #else
 #define ZONEID_SHIFT		(NODES_SHIFT + ZONES_SHIFT)
 #endif
+
+#if ZONES_WIDTH > 0
 #define ZONEID_PGSHIFT		ZONES_PGSHIFT
+#else
+#define ZONEID_PGSHIFT		NODES_PGOFF
+#endif
 
 #if SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
 #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > FLAGS_RESERVED
_

Patches currently in -mm which might be from clameter@sgi.com are

memory-page-alloc-minor-cleanups.patch
get-rid-of-zone_table.patch
get-rid-of-zone_table-fix-3.patch
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
remove-bio_cachep-from-slabh.patch
move-sighand_cachep-to-include-signalh.patch
move-vm_area_cachep-to-include-mmh.patch
move-files_cachep-to-include-fileh.patch
move-filep_cachep-to-include-fileh.patch
move-fs_cachep-to-linux-fs_structh.patch
move-names_cachep-to-linux-fsh.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh.patch
drain_node_page-drain-pages-in-batch-units.patch
slab-remove-slab_no_grow.patch
slab-remove-slab_level_mask.patch
slab-remove-slab_noio.patch
slab-remove-slab_nofs.patch
slab-remove-slab_user.patch
slab-remove-slab_atomic.patch
slab-remove-slab_kernel.patch
slab-remove-slab_dma.patch
slab-remove-kmem_cache_t.patch
slab-deprecate-kmem_cache-t.patch
slab-fixup-two-issues-in-kmalloc_node--__cache_alloc_node.patch
gfp_thisnode-must-not-trigger-global-reclaim.patch
slab-better-fallback-allocation-behavior.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch
radix-tree-rcu-lockless-readside.patch
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

