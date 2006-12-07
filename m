From: akpm@osdl.org
Subject: - move-filep_cachep-to-include-fileh.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:41 -0800
Message-ID: <200612072257.kB7Mvf0t029313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163615AbWLGW5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Move filep_cachep to include/file.h
has been removed from the -mm tree.  Its filename was
     move-filep_cachep-to-include-fileh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Move filep_cachep to include/file.h
From: Christoph Lameter <clameter@sgi.com>

filp_cachep is only used in fs/file_table.c and in fs/dcache.c where
it is defined.

Move it to related definitions in linux/file.h.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/file.h |    2 ++
 include/linux/slab.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/file.h~move-filep_cachep-to-include-fileh include/linux/file.h
--- a/include/linux/file.h~move-filep_cachep-to-include-fileh
+++ a/include/linux/file.h
@@ -64,6 +64,8 @@ struct files_struct {
 
 #define files_fdtable(files) (rcu_dereference((files)->fdt))
 
+extern struct kmem_cache *filp_cachep;
+
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
 
diff -puN include/linux/slab.h~move-filep_cachep-to-include-fileh include/linux/slab.h
--- a/include/linux/slab.h~move-filep_cachep-to-include-fileh
+++ a/include/linux/slab.h
@@ -310,7 +310,6 @@ static inline void *kcalloc(size_t n, si
 
 /* System wide caches */
 extern kmem_cache_t	*names_cachep;
-extern kmem_cache_t	*filp_cachep;
 extern kmem_cache_t	*fs_cachep;
 
 #endif	/* __KERNEL__ */
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

