From: akpm@linux-foundation.org
Subject: - slub-core-missing-inlines-and-statics.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:22:13 -0700
Message-ID: <200704270822.l3R8MDV1023306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755559AbXD0IWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Missing inlines and statics
has been removed from the -mm tree.  Its filename was
     slub-core-missing-inlines-and-statics.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB: Missing inlines and statics
From: Christoph Lameter <clameter@sgi.com>

Fix up a series of missing static and inline attributes.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~slub-core-missing-inlines-and-statics mm/slub.c
--- a/mm/slub.c~slub-core-missing-inlines-and-statics
+++ a/mm/slub.c
@@ -175,7 +175,7 @@ int slab_is_available(void)
 	return slab_state >= UP;
 }
 
-struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
+static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
 {
 #ifdef CONFIG_NUMA
 	return s->node[node];
@@ -250,7 +250,7 @@ struct track {
 
 enum track_item { TRACK_ALLOC, TRACK_FREE };
 
-struct track *get_track(struct kmem_cache *s, void *object,
+static struct track *get_track(struct kmem_cache *s, void *object,
 	enum track_item alloc)
 {
 	struct track *p;
@@ -1448,7 +1448,7 @@ static void init_kmem_cache_node(struct 
  * Note that this function only works on the kmalloc_node_cache
  * when allocating for the kmalloc_node_cache.
  */
-struct kmem_cache_node * __init early_kmem_cache_node_alloc(gfp_t gfpflags,
+static struct kmem_cache_node * __init early_kmem_cache_node_alloc(gfp_t gfpflags,
 								int node)
 {
 	struct page *page;
@@ -2907,7 +2907,7 @@ struct saved_alias {
 
 struct saved_alias *alias_list;
 
-int sysfs_slab_alias(struct kmem_cache *s, const char *name)
+static int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {
 	struct saved_alias *al;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-core-fix-kmem_cache_destroy.patch
slub-core-fix-validation.patch
slub-core-add-after-object-padding.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
slub-core-update-cpu-after-new_slab.patch
slub-core-fix-sysfs-directory-handling.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
