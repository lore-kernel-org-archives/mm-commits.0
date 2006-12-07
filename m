From: akpm@osdl.org
Subject: - move-names_cachep-to-linux-fsh.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:45 -0800
Message-ID: <200612072257.kB7MvjWO029319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163617AbWLGW5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Move names_cachep to linux/fs.h
has been removed from the -mm tree.  Its filename was
     move-names_cachep-to-linux-fsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Move names_cachep to linux/fs.h
From: Christoph Lameter <clameter@sgi.com>

The names_cachep is used for getname() and putname().  So lets put it into
fs.h near those two definitions.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fs.h   |    2 ++
 include/linux/slab.h |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN include/linux/fs.h~move-names_cachep-to-linux-fsh include/linux/fs.h
--- a/include/linux/fs.h~move-names_cachep-to-linux-fsh
+++ a/include/linux/fs.h
@@ -1481,6 +1481,8 @@ extern char * getname(const char __user 
 extern void __init vfs_caches_init_early(void);
 extern void __init vfs_caches_init(unsigned long);
 
+extern struct kmem_cache *names_cachep;
+
 #define __getname()	kmem_cache_alloc(names_cachep, SLAB_KERNEL)
 #define __putname(name) kmem_cache_free(names_cachep, (void *)(name))
 #ifndef CONFIG_AUDITSYSCALL
diff -puN include/linux/slab.h~move-names_cachep-to-linux-fsh include/linux/slab.h
--- a/include/linux/slab.h~move-names_cachep-to-linux-fsh
+++ a/include/linux/slab.h
@@ -308,9 +308,6 @@ static inline void *kcalloc(size_t n, si
 
 #endif /* CONFIG_SLOB */
 
-/* System wide caches */
-extern kmem_cache_t	*names_cachep;
-
 #endif	/* __KERNEL__ */
 
 #endif	/* _LINUX_SLAB_H */
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

