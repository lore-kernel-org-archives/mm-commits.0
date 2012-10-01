From: akpm@linux-foundation.org
Subject: [nacked] thp-avoid-vm_bug_on-page_countpage-false-positives-in-__collapse_huge_page_copy.patch removed from -mm tree
Date: Mon, 01 Oct 2012 11:32:15 -0700
Message-ID: <20121001183217.5256020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40991 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2JASc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 14:32:28 -0400
Received: by eekb57 with SMTP id b57so384073eek.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 11:32:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, pholasek@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: avoid VM_BUG_ON page_count(page) false positives in __collapse_huge_page_copy
has been removed from the -mm tree.  Its filename was
     thp-avoid-vm_bug_on-page_countpage-false-positives-in-__collapse_huge_page_copy.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thp: avoid VM_BUG_ON page_count(page) false positives in __collapse_huge_page_copy

Some time ago Petr once reproduced a false positive VM_BUG_ON in
khugepaged while running the autonuma-benchmark on a large 8 node system. 
All production kernels out there have DEBUG_VM=n so it was only noticeable
on self built kernels.  It's not easily reproducible even on the 8 nodes
system.

Use page_freeze_refs to prevent speculative pagecache lookups to
trigger the false positives, so we're still able to check the
page_count to be exact.

This patch removes the false positive and it has been tested for a
while and it's good idea to queue it for upstream too. It's not urgent
and probably not worth it for -stable, though it wouldn't hurt. On
smaller systems it's not reproducible AFIK.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-avoid-vm_bug_on-page_countpage-false-positives-in-__collapse_huge_page_copy mm/huge_memory.c
--- a/mm/huge_memory.c~thp-avoid-vm_bug_on-page_countpage-false-positives-in-__collapse_huge_page_copy
+++ a/mm/huge_memory.c
@@ -1701,6 +1701,9 @@ void __khugepaged_exit(struct mm_struct 
 
 static void release_pte_page(struct page *page)
 {
+#ifdef CONFIG_DEBUG_VM
+	page_unfreeze_refs(page, 2);
+#endif
 	/* 0 stands for page_is_file_cache(page) == false */
 	dec_zone_page_state(page, NR_ISOLATED_ANON + 0);
 	unlock_page(page);
@@ -1781,6 +1784,20 @@ static int __collapse_huge_page_isolate(
 		VM_BUG_ON(!PageLocked(page));
 		VM_BUG_ON(PageLRU(page));
 
+#ifdef CONFIG_DEBUG_VM
+		/*
+		 * For the VM_BUG_ON check on page_count(page) in
+		 * __collapse_huge_page_copy not to trigger false
+		 * positives we've to prevent the speculative
+		 * pagecache lookups too with page_freeze_refs. We
+		 * could check for >= 2 instead but this provides for
+		 * a more strict debugging behavior.
+		 */
+		if (!page_freeze_refs(page, 2)) {
+			release_pte_pages(pte, _pte+1);
+			goto out;
+		}
+#endif
 		/* If there is no mapped pte young don't collapse the page */
 		if (pte_young(pteval) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
@@ -1811,7 +1828,7 @@ static void __collapse_huge_page_copy(pt
 			src_page = pte_page(pteval);
 			copy_user_highpage(page, src_page, address, vma);
 			VM_BUG_ON(page_mapcount(src_page) != 1);
-			VM_BUG_ON(page_count(src_page) != 2);
+			VM_BUG_ON(page_count(src_page) != 0);
 			release_pte_page(src_page);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-remove-__gfp_no_kswapd.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-have-mmu_notifiers-use-a-global-srcu-so-they-may-safely-schedule.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch
mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch
ksm-numa-awareness-sysfs-knob.patch

