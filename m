From: akpm@linux-foundation.org
Subject: - slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:58:40 -0700
Message-ID: <200704301858.l3UIwe7j012082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423673AbXD3S7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:59:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB printk cleanup: Slab validation printks
has been removed from the -mm tree.  Its filename was
     slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks.patch

This patch was dropped because it was folded into slub-validation-of-slabs-metadata-and-guard-zones.patch

------------------------------------------------------
Subject: SLUB printk cleanup: Slab validation printks
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff -puN mm/slub.c~slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks mm/slub.c
--- a/mm/slub.c~slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks
+++ a/mm/slub.c
@@ -2664,17 +2664,17 @@ static void validate_slab_slab(struct km
 		validate_slab(s, page);
 		slab_unlock(page);
 	} else
-		printk(KERN_INFO "SLUB: %s Skipped busy slab %p\n",
+		printk(KERN_INFO "SLUB %s: Skipped busy slab 0x%p\n",
 			s->name, page);
 
 	if (s->flags & DEBUG_DEFAULT_FLAGS) {
 		if (!PageError(page))
-			printk(KERN_ERR "SLUB: %s PageError not set "
-				"on slab %p\n", s->name, page);
+			printk(KERN_ERR "SLUB %s: PageError not set "
+				"on slab 0x%p\n", s->name, page);
 	} else {
 		if (PageError(page))
-			printk(KERN_ERR "SLUB: %s PageError set on "
-				"slab %p\n", s->name, page);
+			printk(KERN_ERR "SLUB %s: PageError set on "
+				"slab 0x%p\n", s->name, page);
 	}
 }
 
@@ -2691,8 +2691,8 @@ static int validate_slab_node(struct kme
 		count++;
 	}
 	if (count != n->nr_partial)
-		printk("SLUB: %s %ld partial slabs counted but counter=%ld\n",
-			s->name, count, n->nr_partial);
+		printk(KERN_ERR "SLUB %s: %ld partial slabs counted but "
+			"counter=%ld\n", s->name, count, n->nr_partial);
 
 	if (!(s->flags & SLAB_STORE_USER))
 		goto out;
@@ -2702,8 +2702,9 @@ static int validate_slab_node(struct kme
 		count++;
 	}
 	if (count != atomic_long_read(&n->nr_slabs))
-		printk("SLUB: %s %ld slabs counted but counter=%ld\n",
-		s->name, count, atomic_long_read(&n->nr_slabs));
+		printk(KERN_ERR "SLUB: %s %ld slabs counted but "
+			"counter=%ld\n", s->name, count,
+			atomic_long_read(&n->nr_slabs));
 
 out:
 	spin_unlock_irqrestore(&n->list_lock, flags);
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
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
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
