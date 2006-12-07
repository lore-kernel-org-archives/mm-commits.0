From: akpm@osdl.org
Subject: - gfp_thisnode-must-not-trigger-global-reclaim.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:26 -0800
Message-ID: <200612072258.kB7MwQDY029398@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50744 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163645AbWLGW63 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     GFP_THISNODE must not trigger global reclaim
has been removed from the -mm tree.  Its filename was
     gfp_thisnode-must-not-trigger-global-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: GFP_THISNODE must not trigger global reclaim
From: Christoph Lameter <clameter@sgi.com>

The intent of GFP_THISNODE is to make sure that an allocation occurs on a
particular node.  If this is not possible then NULL needs to be returned so
that the caller can choose what to do next on its own (the slab allocator
depends on that).

However, GFP_THISNODE currently triggers reclaim before returning a failure
(GFP_THISNODE means GFP_NORETRY is set).  If we have over allocated a node
then we will currently do some reclaim before returning NULL.  The caller
may want memory from other nodes before reclaim should be triggered.  (If
the caller wants reclaim then he can directly use __GFP_THISNODE instead).

There is no flag to avoid reclaim in the page allocator and adding yet
another GFP_xx flag would be difficult given that we are out of available
flags.

So just compare and see if all bits for GFP_THISNODE (__GFP_THISNODE,
__GFP_NORETRY and __GFP_NOWARN) are set.  If so then we return NULL before
waking up kswapd.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/page_alloc.c~gfp_thisnode-must-not-trigger-global-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~gfp_thisnode-must-not-trigger-global-reclaim
+++ a/mm/page_alloc.c
@@ -1151,6 +1151,17 @@ restart:
 	if (page)
 		goto got_pg;
 
+	/*
+	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
+	 * __GFP_NOWARN set) should not cause reclaim since the subsystem
+	 * (f.e. slab) using GFP_THISNODE may choose to trigger reclaim
+	 * using a larger set of nodes after it has established that the
+	 * allowed per node queues are empty and that nodes are
+	 * over allocated.
+	 */
+	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
+		goto nopage;
+
 	for (z = zonelist->zones; *z; z++)
 		wakeup_kswapd(*z, order);
 
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

