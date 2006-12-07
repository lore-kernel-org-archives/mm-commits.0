From: akpm@osdl.org
Subject: - move-vm_area_cachep-to-include-mmh.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:36 -0800
Message-ID: <200612072257.kB7MvaRD029303@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50624 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163613AbWLGW5j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Move vm_area_cachep to include/mm.h
has been removed from the -mm tree.  Its filename was
     move-vm_area_cachep-to-include-mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Move vm_area_cachep to include/mm.h
From: Christoph Lameter <clameter@sgi.com>

vm_area_cachep is used to store vm_area_structs. So move to mm.h.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/mm.h   |    2 ++
 include/linux/slab.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~move-vm_area_cachep-to-include-mmh include/linux/mm.h
--- a/include/linux/mm.h~move-vm_area_cachep-to-include-mmh
+++ a/include/linux/mm.h
@@ -114,6 +114,8 @@ struct vm_area_struct {
 #endif
 };
 
+extern struct kmem_cache *vm_area_cachep;
+
 /*
  * This struct defines the per-mm list of VMAs for uClinux. If CONFIG_MMU is
  * disabled, then there's a single shared list of VMAs maintained by the
diff -puN include/linux/slab.h~move-vm_area_cachep-to-include-mmh include/linux/slab.h
--- a/include/linux/slab.h~move-vm_area_cachep-to-include-mmh
+++ a/include/linux/slab.h
@@ -309,7 +309,6 @@ static inline void *kcalloc(size_t n, si
 #endif /* CONFIG_SLOB */
 
 /* System wide caches */
-extern kmem_cache_t	*vm_area_cachep;
 extern kmem_cache_t	*names_cachep;
 extern kmem_cache_t	*files_cachep;
 extern kmem_cache_t	*filp_cachep;
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

