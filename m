From: akpm@linux-foundation.org
Subject: - slub-use-list_for_each_entry-for-loops-over-all-slabs.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:55 -0700
Message-ID: <200707172300.l6HN0t08011332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936314AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: use list_for_each_entry for loops over all slabs
has been removed from the -mm tree.  Its filename was
     slub-use-list_for_each_entry-for-loops-over-all-slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: use list_for_each_entry for loops over all slabs
From: Christoph Lameter <clameter@sgi.com>

Use list_for_each_entry() instead of list_for_each().

Get rid of for_all_slabs(). It had only one user. So fold it into the
callback. This also gets rid of cpu_slab_flush.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   51 +++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff -puN mm/slub.c~slub-use-list_for_each_entry-for-loops-over-all-slabs mm/slub.c
--- a/mm/slub.c~slub-use-list_for_each_entry-for-loops-over-all-slabs
+++ a/mm/slub.c
@@ -2573,7 +2573,7 @@ static struct kmem_cache *find_mergeable
 		size_t align, unsigned long flags,
 		void (*ctor)(void *, struct kmem_cache *, unsigned long))
 {
-	struct list_head *h;
+	struct kmem_cache *s;
 
 	if (slub_nomerge || (flags & SLUB_NEVER_MERGE))
 		return NULL;
@@ -2585,10 +2585,7 @@ static struct kmem_cache *find_mergeable
 	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
 
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
+	list_for_each_entry(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
 
@@ -2670,33 +2667,6 @@ void *kmem_cache_zalloc(struct kmem_cach
 EXPORT_SYMBOL(kmem_cache_zalloc);
 
 #ifdef CONFIG_SMP
-static void for_all_slabs(void (*func)(struct kmem_cache *, int), int cpu)
-{
-	struct list_head *h;
-
-	down_read(&slub_lock);
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
-		func(s, cpu);
-	}
-	up_read(&slub_lock);
-}
-
-/*
- * Version of __flush_cpu_slab for the case that interrupts
- * are enabled.
- */
-static void cpu_slab_flush(struct kmem_cache *s, int cpu)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__flush_cpu_slab(s, cpu);
-	local_irq_restore(flags);
-}
-
 /*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
@@ -2705,13 +2675,21 @@ static int __cpuinit slab_cpuup_callback
 		unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
+	struct kmem_cache *s;
+	unsigned long flags;
 
 	switch (action) {
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		for_all_slabs(cpu_slab_flush, cpu);
+		down_read(&slub_lock);
+		list_for_each_entry(s, &slab_caches, list) {
+			local_irq_save(flags);
+			__flush_cpu_slab(s, cpu);
+			local_irq_restore(flags);
+		}
+		up_read(&slub_lock);
 		break;
 	default:
 		break;
@@ -3736,7 +3714,7 @@ static int sysfs_slab_alias(struct kmem_
 
 static int __init slab_sysfs_init(void)
 {
-	struct list_head *h;
+	struct kmem_cache *s;
 	int err;
 
 	err = subsystem_register(&slab_subsys);
@@ -3747,10 +3725,7 @@ static int __init slab_sysfs_init(void)
 
 	slab_state = SYSFS;
 
-	list_for_each(h, &slab_caches) {
-		struct kmem_cache *s =
-			container_of(h, struct kmem_cache, list);
-
+	list_for_each_entry(s, &slab_caches, list) {
 		err = sysfs_slab_add(s);
 		BUG_ON(err);
 	}
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
page-owner-tracking-leak-detector.patch
