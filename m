From: akpm@linux-foundation.org
Subject: +
 mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch
 added to -mm tree
Date: Fri, 03 Apr 2015 14:31:54 -0700
Message-ID: <551f06ca.Wi49B5Lv2YwvvLwI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbbDCVbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 17:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, mhocko@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: sync allocation and memcg charge gfp flags for thp fix fix
has been added to the -mm tree.  Its filename is
     mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: sync allocation and memcg charge gfp flags for thp fix fix

"mm, memcg: sync allocation and memcg charge gfp flags for THP" in -mm
introduces a formal to pass the gfp mask for khugepaged's hugepage
allocation.  This is just too ugly to live.

alloc_hugepage_gfpmask() cannot differ between NUMA and UMA configs by
anything in GFP_RECLAIM_MASK, which is the only thing that matters for
memcg reclaim, so just determine the gfp flags once in
collapse_huge_page() and avoid the complexity.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/huge_memory.c~mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix
+++ a/mm/huge_memory.c
@@ -2322,16 +2322,12 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
-	/* Only allocate from the target node */
-	*gfp = alloc_hugepage_gfpmask(khugepaged_defrag(), __GFP_OTHER_NODE) |
-	        __GFP_THISNODE;
-
 	/*
 	 * Before allocating the hugepage, release the mmap_sem read lock.
 	 * The allocation can take potentially a long time if it involves
@@ -2340,7 +2336,7 @@ khugepaged_alloc_page(struct page **hpag
 	 */
 	up_read(&mm->mmap_sem);
 
-	*hpage = alloc_pages_exact_node(node, *gfp, HPAGE_PMD_ORDER);
+	*hpage = alloc_pages_exact_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
@@ -2394,18 +2390,13 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
 	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
 
-	/*
-	 * khugepaged_alloc_hugepage is doing the preallocation, use the same
-	 * gfp flags here.
-	 */
-	*gfp = alloc_hugepage_gfpmask(khugepaged_defrag(), 0);
 	return  *hpage;
 }
 #endif
@@ -2444,8 +2435,12 @@ static void collapse_huge_page(struct mm
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
+	/* Only allocate from the target node */
+	gfp = alloc_hugepage_gfpmask(khugepaged_defrag(), __GFP_OTHER_NODE) |
+		__GFP_THISNODE;
+
 	/* release the mmap_sem read lock. */
-	new_page = khugepaged_alloc_page(hpage, &gfp, mm, vma, address, node);
+	new_page = khugepaged_alloc_page(hpage, gfp, mm, vma, address, node);
 	if (!new_page)
 		return;
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-move-zone-lock-to-a-different-cache-line-than-order-0-free-page-lists.patch
mm-numa-disable-change-protection-for-vmavm_hugetlb.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-slab-correct-config-option-in-comment.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-refactor-zone_movable_is_highmem.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
allow-compaction-of-unevictable-pages.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix-fix.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
clean-up-goto-just-return-err_ptr.patch
fs-jfs-remove-slab-object-constructor.patch
mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
mm-mempool-poison-elements-backed-by-slab-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix.patch
mm-mempool-poison-elements-backed-by-page-allocator-fix-fix.patch
thp-handle-errors-in-hugepage_init-properly.patch
thp-do-not-adjust-zone-water-marks-if-khugepaged-is-not-started.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory-fix.patch
mm-selftests-test-return-value-of-munmap-for-map_hugetlb-memory.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
thp-cleanup-khugepaged-startup.patch
hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

