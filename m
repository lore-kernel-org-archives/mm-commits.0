From: akpm@linux-foundation.org
Subject: + slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink.patch added to -mm tree
Date: Fri, 27 Apr 2007 16:18:57 -0700
Message-ID: <200704272318.l3RNIvEP010419@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880AbXD0XTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 19:19:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Fixes to kmem_cache_shrink()
has been added to the -mm tree.  Its filename is
     slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Fixes to kmem_cache_shrink()
From: Christoph Lameter <clameter@sgi.com>

1. Reclaim all empty slabs even if we are below MIN_PARTIAL partial slabs.
   The point here is to recover all possible memory.

2. Fix race condition vs. slab_free. If we want to free a slab then
   we need to acquire the slab lock since slab_free may have freed
   an object and is waiting to acquire the lock to remove the slab.
   We do a trylock. If its unsuccessful then we are racing with
   slab_free. Simply keep the empty slab on the partial lists.
   slab_free will remove the slab as soon as we drop the list_lock.

3. #2 may have the result that we end up with empty slabs on the
   slabs_by_inuse array. So make sure that we also splice in the
   zeroeth element.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink mm/slub.c
--- a/mm/slub.c~slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink
+++ a/mm/slub.c
@@ -2237,7 +2237,7 @@ int kmem_cache_shrink(struct kmem_cache 
 	for_each_online_node(node) {
 		n = get_node(s, node);
 
-		if (n->nr_partial <= MIN_PARTIAL)
+		if (!n->nr_partial)
 			continue;
 
 		for (i = 0; i < s->objects; i++)
@@ -2254,14 +2254,21 @@ int kmem_cache_shrink(struct kmem_cache 
 		 * the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			if (!page->inuse) {
+			if (!page->inuse && slab_trylock(page)) {
+				/*
+				 * Must hold slab lock here because slab_free
+				 * may have freed the last object and be
+				 * waiting to release the slab.
+				 */
 				list_del(&page->lru);
 				n->nr_partial--;
+				slab_unlock(page);
 				discard_slab(s, page);
-			} else
-			if (n->nr_partial > MAX_PARTIAL)
-				list_move(&page->lru,
+			} else {
+				if (n->nr_partial > MAX_PARTIAL)
+					list_move(&page->lru,
 					slabs_by_inuse + page->inuse);
+			}
 		}
 
 		if (n->nr_partial <= MAX_PARTIAL)
@@ -2271,7 +2278,7 @@ int kmem_cache_shrink(struct kmem_cache 
 		 * Rebuild the partial list with the slabs filled up
 		 * most first and the least used slabs at the end.
 		 */
-		for (i = s->objects - 1; i > 0; i--)
+		for (i = s->objects - 1; i >= 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
 	out:
_

Patches currently in -mm which might be from clameter@sgi.com are

extend-print_symbol-capability.patch
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
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
slub-core-sysfs-support-fix-unique-id-generation.patch
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
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-slabinfo-remove-hackname.patch
slub-printk-cleanup-object_err.patch
slub-printk-cleanup-add-slab_err.patch
slub-printk-cleanup-diagnostic-functions.patch
slub-printk-cleanup-fix-up-printks-in-the-resiliency-check.patch
slub-printk-cleanup-slab-validation-printks.patch
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
