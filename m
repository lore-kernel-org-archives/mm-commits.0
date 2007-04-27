From: akpm@linux-foundation.org
Subject: + slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch added to -mm tree
Date: Thu, 26 Apr 2007 23:31:32 -0700
Message-ID: <200704270631.l3R6VWtr021305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387AbXD0Gbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 02:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mel@skynet.ie


The patch titled
     SLUB: Reduce the order of allocations to avoid fragmentation
has been added to the -mm tree.  Its filename is
     slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Reduce the order of allocations to avoid fragmentation
From: Christoph Lameter <clameter@sgi.com>

Seems that fragmentation is an important subject. So be safe.

If an arch supports 4k page size then assume that defragmentation may be
a major problem. Reduce the minimum number of objects in a slab and
limit the order of slabs. Be a little bit more lenient for larger
page sizes.

Change the bootup message of SLUB to show the parameters so that
log is reviewed.

Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation mm/slub.c
--- a/mm/slub.c~slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation
+++ a/mm/slub.c
@@ -115,6 +115,25 @@
 /* Enable to test recovery from slab corruption on boot */
 #undef SLUB_RESILIENCY_TEST
 
+#if PAGE_SHIFT <= 12
+
+/*
+ * Small page size. Make sure that we do not fragment memory
+ */
+#define DEFAULT_MAX_ORDER 1
+#define DEFAULT_MIN_OBJECTS 4
+
+#else
+
+/*
+ * Large page machines are customarily able to handle larger
+ * page orders.
+ */
+#define DEFAULT_MAX_ORDER 2
+#define DEFAULT_MIN_OBJECTS 8
+
+#endif
+
 /*
  * Flags from the regular SLAB that SLUB does not support:
  */
@@ -1401,13 +1420,13 @@ static struct page *get_object_page(cons
  * take the list_lock.
  */
 static int slub_min_order;
-static int slub_max_order = 4;
+static int slub_max_order = DEFAULT_MAX_ORDER;
 
 /*
  * Minimum number of objects per slab. This is necessary in order to
  * reduce locking overhead. Similar to the queue size in SLAB.
  */
-static int slub_min_objects = 8;
+static int slub_min_objects = DEFAULT_MIN_OBJECTS;
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
@@ -2239,9 +2258,10 @@ void __init kmem_cache_init(void)
 		kmem_size = offsetof(struct kmem_cache, cpu_slab)
 			 + nr_cpu_ids * sizeof(struct page *);
 
-	printk(KERN_INFO "SLUB: General Slabs=%d, HW alignment=%d, "
-		"Processors=%d, Nodes=%d\n",
+	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
+		" Processors=%d, Nodes=%d\n",
 		KMALLOC_SHIFT_HIGH, L1_CACHE_BYTES,
+		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
extend-print_symbol-capability-fix-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
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
slub-i386-support.patch
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
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
