From: akpm@linux-foundation.org
Subject: - slub-core-printk-cleanup-object_err.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:53:01 -0700
Message-ID: <200704301853.l3UIr1if011966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423645AbXD3SxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB printk cleanup: object_err()
has been removed from the -mm tree.  Its filename was
     slub-core-printk-cleanup-object_err.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB printk cleanup: object_err()
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-core-printk-cleanup-object_err mm/slub.c
--- a/mm/slub.c~slub-core-printk-cleanup-object_err
+++ a/mm/slub.c
@@ -357,8 +357,8 @@ static void object_err(struct kmem_cache
 {
 	u8 *addr = page_address(page);
 
-	printk(KERN_ERR "*** SLUB: %s in %s@0x%p slab 0x%p\n",
-			reason, s->name, object, page);
+	printk(KERN_ERR "*** SLUB %s: %s@0x%p slab 0x%p\n",
+			s->name, reason, object, page);
 	printk(KERN_ERR "    offset=%tu flags=0x%04lx inuse=%u freelist=0x%p\n",
 		object - addr, page->flags, page->inuse, page->freelist);
 	if (object > addr + 16)
_

Patches currently in -mm which might be from clameter@sgi.com are

extend-print_symbol-capability.patch
slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-printk-cleanup-object_err.patch
slub-core-printk-cleanup-add-slab_err.patch
slub-core-printk-cleanup-fix-up-printks-in-the-resiliency-check.patch
slub-core-fix-slab-validation-error-in-bootstrap-cache.patch
slub-core-remove-per-cpu-flusher.patch
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
slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-slabinfo-remove-hackname.patch
slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch
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
vmstat-use-our-own-timer-events.patch
readahead-state-based-method-aging-accounting.patch
