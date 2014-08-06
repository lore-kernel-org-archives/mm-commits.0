From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:49:17 -0700
Message-ID: <53e2b0ed.UeGOVd7j6pHEo0oF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:44222 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaHFWtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:49:18 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so840325pab.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:49:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, n-horiguchi@ah.jp.nec.com, zhong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix potential infinite loop in dissolve_free_huge_pages() fix
has been removed from the -mm tree.  Its filename was
     mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix.patch

This patch was dropped because it was folded into mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm: fix potential infinite loop in dissolve_free_huge_pages() fix

No legitimate reason to call dissolve_free_huge_pages() when
!hugepages_supported().

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c        |    3 +++
 mm/memory_hotplug.c |    3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix
+++ a/mm/hugetlb.c
@@ -1088,6 +1088,9 @@ void dissolve_free_huge_pages(unsigned l
 	unsigned long pfn;
 	struct hstate *h;
 
+	if (!hugepages_supported())
+		return;
+
 	/* Set scan step to minimum hugepage size */
 	for_each_hstate(h)
 		if (order > huge_page_order(h))
diff -puN mm/memory_hotplug.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix
+++ a/mm/memory_hotplug.c
@@ -1726,8 +1726,7 @@ repeat:
 	 * dissolve free hugepages in the memory block before doing offlining
 	 * actually in order to make hugetlbfs's object counting consistent.
 	 */
-	if (hugepages_supported())
-		dissolve_free_huge_pages(start_pfn, end_pfn);
+	dissolve_free_huge_pages(start_pfn, end_pfn);
 	/* check again */
 	offlined_pages = check_pages_isolated(start_pfn, end_pfn);
 	if (offlined_pages < 0) {
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
score-ptrace-remove-the-macros-which-not-be-used-currently.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-trivial-comment-cleanup-in-slabc.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-make-copy_pte_range-static-again.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch
mm-oom-remove-unnecessary-exit_state-check.patch
mm-close-race-between-do_fault_around-and-fault_around_bytes_set.patch
mm-mark-fault_around_bytes-__read_mostly.patch
kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch
mm-bug-when-__kmap_atomic_idx-equals-km_type_nr.patch
mm-highmem-make-kmap-cache-coloring-aware.patch
lib-add-size-unit-t-p-e-to-memparse.patch

