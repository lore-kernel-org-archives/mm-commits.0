From: akpm@linux-foundation.org
Subject: + slub-exploit-page-mobility-to-increase-allocation-order.patch added to -mm tree
Date: Thu, 26 Apr 2007 23:31:43 -0700
Message-ID: <200704270631.l3R6VhZf021333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397AbXD0Gbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 02:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mel@skynet.ie


The patch titled
     SLUB: Exploit page mobility to increase allocation order
has been added to the -mm tree.  Its filename is
     slub-exploit-page-mobility-to-increase-allocation-order.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Exploit page mobility to increase allocation order
From: Christoph Lameter <clameter@sgi.com>

If there is page mobility then we can defragment memory. So its possible to
use higher order of pages for slab allocations.

If the defaults were not overridden set the max order to 4 and guarantee 16
objects per slab. This will put some stress on Mel's antifrag approaches.
If these defaults are too large then they should be later reduced.

Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/slub.c              |   27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff -puN include/linux/mmzone.h~slub-exploit-page-mobility-to-increase-allocation-order include/linux/mmzone.h
--- a/include/linux/mmzone.h~slub-exploit-page-mobility-to-increase-allocation-order
+++ a/include/linux/mmzone.h
@@ -25,6 +25,8 @@
 #endif
 #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
 
+extern int page_group_by_mobility_disabled;
+
 /*
  * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
  * costly to service.  That is between allocation orders which should
diff -puN mm/slub.c~slub-exploit-page-mobility-to-increase-allocation-order mm/slub.c
--- a/mm/slub.c~slub-exploit-page-mobility-to-increase-allocation-order
+++ a/mm/slub.c
@@ -137,6 +137,13 @@
 #define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
 
 /*
+ * If antifragmentation methods are in effect then increase the
+ * slab sizes to increase performance
+ */
+#define DEFAULT_ANTIFRAG_MAX_ORDER 4
+#define DEFAULT_ANTIFRAG_MIN_OBJECTS 16
+
+/*
  * Mininum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
  */
@@ -1464,6 +1471,11 @@ static struct page *get_object_page(cons
  */
 
 /*
+ * Set if the user has overridden any of the order related defaults.
+ */
+static int user_override;
+
+/*
  * Mininum / Maximum order of slab pages. This influences locking overhead
  * and slab fragmentation. A higher order reduces the number of partial slabs
  * and increases the number of allocations possible without having to
@@ -2001,7 +2013,7 @@ static struct kmem_cache *kmalloc_caches
 static int __init setup_slub_min_order(char *str)
 {
 	get_option (&str, &slub_min_order);
-
+	user_override = 1;
 	return 1;
 }
 
@@ -2010,7 +2022,7 @@ __setup("slub_min_order=", setup_slub_mi
 static int __init setup_slub_max_order(char *str)
 {
 	get_option (&str, &slub_max_order);
-
+	user_override = 1;
 	return 1;
 }
 
@@ -2019,7 +2031,7 @@ __setup("slub_max_order=", setup_slub_ma
 static int __init setup_slub_min_objects(char *str)
 {
 	get_option (&str, &slub_min_objects);
-
+	user_override = 1;
 	return 1;
 }
 
@@ -2335,6 +2347,15 @@ void __init kmem_cache_init(void)
 {
 	int i;
 
+	if (!page_group_by_mobility_disabled && !user_override) {
+		/*
+		 * Antifrag support available. Increase usable
+		 * page order and generate slabs with more objects.
+	 	 */
+		slub_max_order = DEFAULT_ANTIFRAG_MAX_ORDER;
+		slub_min_objects = DEFAULT_ANTIFRAG_MIN_OBJECTS;
+	}
+
 #ifdef CONFIG_NUMA
 	/*
 	 * Must first have the slab cache available for the allocations of the
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
