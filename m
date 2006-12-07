From: akpm@osdl.org
Subject: - slab-fixup-two-issues-in-kmalloc_node--__cache_alloc_node.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:24 -0800
Message-ID: <200612072258.kB7MwOvA029395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163646AbWLGW61 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: fix two issues in kmalloc_node / __cache_alloc_node
has been removed from the -mm tree.  Its filename was
     slab-fixup-two-issues-in-kmalloc_node--__cache_alloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: fix two issues in kmalloc_node / __cache_alloc_node
From: Christoph Lameter <clameter@sgi.com>

This addresses two issues:

1. Kmalloc_node() may intermittently return NULL if we are allocating
   from the current node and are unable to obtain memory for the current
   node from the page allocator.  This is because we call ___cache_alloc()
   if nodeid == numa_node_id() and ____cache_alloc is not able to fallback
   to other nodes.

   This was introduced in the 2.6.19 development cycle.  <= 2.6.18 in
   that case does not do a restricted allocation and blindly trusts the
   page allocator to have given us memory from the indicated node.  It
   inserts the page regardless of the node it came from into the queues for
   the current node.

2. If kmalloc_node() is used on a node that has not been bootstrapped
   yet then we may try to pass an invalid node number to
   ____cache_alloc_node() triggering a BUG().

   Change the function to call fallback_alloc() instead.  Only call
   fallback_alloc() if we are allowed to fallback at all.  The need to
   handle a node not bootstrapped yet also first surfaced in the 2.6.19
   cycle.

Update the comments since they were still describing the old kmalloc_node
from 2.6.12.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/slab.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff -puN mm/slab.c~slab-fixup-two-issues-in-kmalloc_node--__cache_alloc_node mm/slab.c
--- a/mm/slab.c~slab-fixup-two-issues-in-kmalloc_node--__cache_alloc_node
+++ a/mm/slab.c
@@ -3459,29 +3459,45 @@ out:
  * @flags: See kmalloc().
  * @nodeid: node number of the target node.
  *
- * Identical to kmem_cache_alloc, except that this function is slow
- * and can sleep. And it will allocate memory on the given node, which
- * can improve the performance for cpu bound structures.
- * New and improved: it will now make sure that the object gets
- * put on the correct node list so that there is no false sharing.
+ * Identical to kmem_cache_alloc but it will allocate memory on the given
+ * node, which can improve the performance for cpu bound structures.
+ *
+ * Fallback to other node is possible if __GFP_THISNODE is not set.
  */
 static __always_inline void *
 __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 		int nodeid, void *caller)
 {
 	unsigned long save_flags;
-	void *ptr;
+	void *ptr = NULL;
 
 	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
-	if (nodeid == -1 || nodeid == numa_node_id() ||
-			!cachep->nodelists[nodeid])
-		ptr = ____cache_alloc(cachep, flags);
-	else
-		ptr = ____cache_alloc_node(cachep, flags, nodeid);
-	local_irq_restore(save_flags);
+	if (unlikely(nodeid == -1))
+		nodeid = numa_node_id();
+
+	if (likely(cachep->nodelists[nodeid])) {
+		if (nodeid == numa_node_id()) {
+			/*
+			 * Use the locally cached objects if possible.
+			 * However ____cache_alloc does not allow fallback
+			 * to other nodes. It may fail while we still have
+			 * objects on other nodes available.
+			 */
+			ptr = ____cache_alloc(cachep, flags);
+		}
+		if (!ptr) {
+			/* ___cache_alloc_node can fall back to other nodes */
+			ptr = ____cache_alloc_node(cachep, flags, nodeid);
+		}
+	} else {
+		/* Node not bootstrapped yet */
+		if (!(flags & __GFP_THISNODE))
+			ptr = fallback_alloc(cachep, flags);
+	}
 
+	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
 	return ptr;
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

