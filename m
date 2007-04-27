From: akpm@linux-foundation.org
Subject: - slub-core-explain-the-64k-limits.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:22:03 -0700
Message-ID: <200704270822.l3R8M3G0023287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548AbXD0IWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Explain the 64k limits
has been removed from the -mm tree.  Its filename was
     slub-core-explain-the-64k-limits.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB: Explain the 64k limits
From: Christoph Lameter <clameter@sgi.com>

Note that these limits could now be removed since we no longer use
page->private for compound pages.  But I think this is fine for now.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-core-explain-the-64k-limits mm/slub.c
--- a/mm/slub.c~slub-core-explain-the-64k-limits
+++ a/mm/slub.c
@@ -1571,6 +1571,12 @@ static int calculate_sizes(struct kmem_c
 		return 0;
 
 	s->objects = (PAGE_SIZE << s->order) / size;
+
+	/*
+	 * Verify that the number of objects is within permitted limits.
+	 * The page->inuse field is only 16 bit wide! So we cannot have
+	 * more than 64k objects per slab.
+	 */
 	if (!s->objects || s->objects > 65535)
 		return 0;
 	return 1;
@@ -1593,9 +1599,23 @@ static int kmem_cache_open(struct kmem_c
 
 	BUG_ON(flags & SLUB_UNIMPLEMENTED);
 
-	if (s->size >= 65535 * sizeof(void *))
+	/*
+	 * The page->offset field is only 16 bit wide. This is an offset
+	 * in units of words from the beginning of an object. If the slab
+	 * size is bigger then we cannot move the free pointer behind the
+	 * object anymore.
+	 *
+	 * On 32 bit platforms the limit is 256k. On 64bit platforms
+	 * the limit is 512k.
+	 *
+	 * Debugging or ctor/dtors may create a need to move the free
+	 * pointer. Fail if this happens.
+	 */
+	if (s->size >= 65535 * sizeof(void *)) {
 		BUG_ON(flags & (SLAB_RED_ZONE | SLAB_POISON |
 				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
+		BUG_ON(ctor || dtor);
+	}
 	else
 		/*
 		 * Enable debugging if selected on the kernel commandline.
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
