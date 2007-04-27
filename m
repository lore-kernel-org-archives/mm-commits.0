From: akpm@linux-foundation.org
Subject: - slub-core-use-enum-for-tracking-modes-instead-of-integers.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:21:25 -0700
Message-ID: <200704270821.l3R8LPEJ023217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbXD0IV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: use enum for tracking modes instead of integers
has been removed from the -mm tree.  Its filename was
     slub-core-use-enum-for-tracking-modes-instead-of-integers.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: slub: use enum for tracking modes instead of integers
From: Christoph Lameter <clameter@sgi.com>

Integers caused some confusion. This cleans it up and uses symbolic constants
throughout.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-core-use-enum-for-tracking-modes-instead-of-integers mm/slub.c
--- a/mm/slub.c~slub-core-use-enum-for-tracking-modes-instead-of-integers
+++ a/mm/slub.c
@@ -211,7 +211,10 @@ struct track {
 	unsigned long when;	/* When did the operation occur */
 };
 
-struct track *get_track(struct kmem_cache *s, void *object, int alloc)
+enum track_item { TRACK_ALLOC, TRACK_FREE };
+
+struct track *get_track(struct kmem_cache *s, void *object,
+	enum track_item alloc)
 {
 	struct track *p;
 
@@ -224,7 +227,7 @@ struct track *get_track(struct kmem_cach
 }
 
 static void set_track(struct kmem_cache *s, void *object,
-				int alloc, void *addr)
+				enum track_item alloc, void *addr)
 {
 	struct track *p;
 
@@ -249,8 +252,8 @@ static void set_track(struct kmem_cache 
 static void init_tracking(struct kmem_cache *s, void *object)
 {
 	if (s->flags & SLAB_STORE_USER) {
-		set_track(s, object, 0, NULL);
-		set_track(s, object, 1, NULL);
+		set_track(s, object, TRACK_FREE, NULL);
+		set_track(s, object, TRACK_ALLOC, NULL);
 	}
 }
 
@@ -298,8 +301,8 @@ static void print_trailer(struct kmem_ca
 		off = s->inuse;
 
 	if (s->flags & SLAB_STORE_USER) {
-		print_track("Last alloc", get_track(s, p, 0));
-		print_track("Last free ", get_track(s, p, 1));
+		print_track("Last alloc", get_track(s, p, TRACK_ALLOC));
+		print_track("Last free ", get_track(s, p, TRACK_FREE));
 		off += 2 * sizeof(struct track);
 	}
 
@@ -1186,7 +1189,7 @@ debug:
 	if (!alloc_object_checks(s, page, object))
 		goto another_slab;
 	if (s->flags & SLAB_STORE_USER)
-		set_tracking(s, object, 0);
+		set_tracking(s, object, TRACK_ALLOC);
 	goto have_object;
 }
 
@@ -1278,7 +1281,7 @@ void kmem_cache_free(struct kmem_cache *
 
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
-		set_tracking(s, x, 1);
+		set_tracking(s, x, TRACK_FREE);
 	slab_free(s, page, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
@@ -1904,7 +1907,7 @@ void kfree(const void *x)
 	s = page->slab;
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
-		set_tracking(s, (void *)x, 1);
+		set_tracking(s, (void *)x, TRACK_FREE);
 	slab_free(s, page, (void *)x);
 }
 EXPORT_SYMBOL(kfree);
@@ -2267,7 +2270,7 @@ void *__kmalloc_track_caller(size_t size
 	object = kmem_cache_alloc(s, gfpflags);
 
 	if (object && (s->flags & SLAB_STORE_USER))
-		set_track(s, object, 0, caller);
+		set_track(s, object, TRACK_ALLOC, caller);
 
 	return object;
 }
@@ -2284,7 +2287,7 @@ void *__kmalloc_node_track_caller(size_t
 	object = kmem_cache_alloc_node(s, gfpflags, node);
 
 	if (object && (s->flags & SLAB_STORE_USER))
-		set_track(s, object, 0, caller);
+		set_track(s, object, TRACK_ALLOC, caller);
 
 	return object;
 }
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
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
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
