From: akpm@linux-foundation.org
Subject: + slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch added to -mm tree
Date: Tue, 19 Jun 2007 12:19:20 -0700
Message-ID: <200706191919.l5JJJKbc019060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933306AbXFSTT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 15:19:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: add some more inlines and #ifdef CONFIG_SLUB_DEBUG
has been added to the -mm tree.  Its filename is
     slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -259,9 +259,10 @@ static int sysfs_slab_add(struct kmem_ca
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
@@ -1405,7 +1406,7 @@ static void deactivate_slab(struct kmem_
 	unfreeze_slab(s, page);
 }
 
-static void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
+static inline void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
 {
 	slab_lock(page);
 	deactivate_slab(s, page, cpu);
@@ -1415,7 +1416,7 @@ static void flush_slab(struct kmem_cache
  * Flush cpu slab.
  * Called from IPI handler with interrupts disabled.
  */
-static void __flush_cpu_slab(struct kmem_cache *s, int cpu)
+static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct page *page = s->cpu_slab[cpu];
 
@@ -2175,7 +2176,7 @@ static int free_list(struct kmem_cache *
 /*
  * Release all resources used by a slab cache.
  */
-static int kmem_cache_close(struct kmem_cache *s)
+static inline int kmem_cache_close(struct kmem_cache *s)
 {
 	int node;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-support-slub_debug-on-by-default.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
numa-mempolicy-trivial-debug-fixes.patch
add-populated_map-to-account-for-memoryless-nodes.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slub-remove-useless-export_symbol.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
