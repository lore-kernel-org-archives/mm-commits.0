From: akpm@linux-foundation.org
Subject: - slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:10 -0700
Message-ID: <200707172301.l6HN1A8Z011359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54005 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936463AbXGQXPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: add some more inlines and #ifdef CONFIG_SLUB_DEBUG
has been removed from the -mm tree.  Its filename was
     slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: add some more inlines and #ifdef CONFIG_SLUB_DEBUG
From: Christoph Lameter <clameter@sgi.com>

Add #ifdefs around data structures only needed if debugging is compiled into
SLUB.

Add inlines to small functions to reduce code size.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    4 ++++
 mm/slub.c                |   13 +++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/slub_def.h~slub-add-some-more-inlines-and-ifdef-config_slub_debug include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-add-some-more-inlines-and-ifdef-config_slub_debug
+++ a/include/linux/slub_def.h
@@ -16,7 +16,9 @@ struct kmem_cache_node {
 	unsigned long nr_partial;
 	atomic_long_t nr_slabs;
 	struct list_head partial;
+#ifdef CONFIG_SLUB_DEBUG
 	struct list_head full;
+#endif
 };
 
 /*
@@ -44,7 +46,9 @@ struct kmem_cache {
 	int align;		/* Alignment */
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
+#ifdef CONFIG_SLUB_DEBUG
 	struct kobject kobj;	/* For sysfs */
+#endif
 
 #ifdef CONFIG_NUMA
 	int defrag_ratio;
diff -puN mm/slub.c~slub-add-some-more-inlines-and-ifdef-config_slub_debug mm/slub.c
--- a/mm/slub.c~slub-add-some-more-inlines-and-ifdef-config_slub_debug
+++ a/mm/slub.c
@@ -252,9 +252,10 @@ static int sysfs_slab_add(struct kmem_ca
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
 static void sysfs_slab_remove(struct kmem_cache *);
 #else
-static int sysfs_slab_add(struct kmem_cache *s) { return 0; }
-static int sysfs_slab_alias(struct kmem_cache *s, const char *p) { return 0; }
-static void sysfs_slab_remove(struct kmem_cache *s) {}
+static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
+static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
+							{ return 0; }
+static inline void sysfs_slab_remove(struct kmem_cache *s) {}
 #endif
 
 /********************************************************************
@@ -1395,7 +1396,7 @@ static void deactivate_slab(struct kmem_
 	unfreeze_slab(s, page);
 }
 
-static void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
+static inline void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
 {
 	slab_lock(page);
 	deactivate_slab(s, page, cpu);
@@ -1405,7 +1406,7 @@ static void flush_slab(struct kmem_cache
  * Flush cpu slab.
  * Called from IPI handler with interrupts disabled.
  */
-static void __flush_cpu_slab(struct kmem_cache *s, int cpu)
+static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct page *page = s->cpu_slab[cpu];
 
@@ -2165,7 +2166,7 @@ static int free_list(struct kmem_cache *
 /*
  * Release all resources used by a slab cache.
  */
-static int kmem_cache_close(struct kmem_cache *s)
+static inline int kmem_cache_close(struct kmem_cache *s)
 {
 	int node;
 
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
