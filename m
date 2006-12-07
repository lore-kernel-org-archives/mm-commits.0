From: akpm@osdl.org
Subject: - slab-remove-slab_level_mask.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:05 -0800
Message-ID: <200612072258.kB7Mw5Ce029355@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163604AbWLGW6H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slab: remove SLAB_LEVEL_MASK
has been removed from the -mm tree.  Its filename was
     slab-remove-slab_level_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: remove SLAB_LEVEL_MASK
From: Christoph Lameter <clameter@sgi.com>

SLAB_LEVEL_MASK is only used internally to the slab and is
and alias of GFP_LEVEL_MASK.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/slab.h |    2 --
 mm/slab.c            |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/slab.h~slab-remove-slab_level_mask include/linux/slab.h
--- a/include/linux/slab.h~slab-remove-slab_level_mask
+++ a/include/linux/slab.h
@@ -26,8 +26,6 @@ typedef struct kmem_cache kmem_cache_t;
 #define	SLAB_KERNEL		GFP_KERNEL
 #define	SLAB_DMA		GFP_DMA
 
-#define SLAB_LEVEL_MASK		GFP_LEVEL_MASK
-
 /* flags to pass to kmem_cache_create().
  * The first 3 are only valid when the allocator as been build
  * SLAB_DEBUG_SUPPORT.
diff -puN mm/slab.c~slab-remove-slab_level_mask mm/slab.c
--- a/mm/slab.c~slab-remove-slab_level_mask
+++ a/mm/slab.c
@@ -2721,12 +2721,12 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(SLAB_DMA | SLAB_LEVEL_MASK | __GFP_NO_GROW));
+	BUG_ON(flags & ~(SLAB_DMA | GFP_LEVEL_MASK | __GFP_NO_GROW));
 	if (flags & __GFP_NO_GROW)
 		return 0;
 
 	ctor_flags = SLAB_CTOR_CONSTRUCTOR;
-	local_flags = (flags & SLAB_LEVEL_MASK);
+	local_flags = (flags & GFP_LEVEL_MASK);
 	if (!(local_flags & __GFP_WAIT))
 		/*
 		 * Not allowed to sleep.  Need to tell a constructor about
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

