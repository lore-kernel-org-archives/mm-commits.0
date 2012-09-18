From: akpm@linux-foundation.org
Subject: + mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch added to -mm tree
Date: Tue, 18 Sep 2012 15:12:34 -0700
Message-ID: <20120918221234.C894A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:36500 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab2IRWMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 18:12:36 -0400
Received: by ggnu1 with SMTP id u1so53051ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 15:12:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, stable@vger.kernel.org


The patch titled
     Subject: mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP
has been added to the -mm tree.  Its filename is
     mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

In many places !pmd_present has been converted to pmd_none.  For pmds
that's equivalent and pmd_none is quicker so using pmd_none is better.

However (unless we delete pmd_present) we should provide an accurate
pmd_present too.  This will avoid the risk of code thinking the pmd is non
present because it's under __split_huge_page_map, see the pmd_mknotpresent
there and the comment above it.

If the page has been mprotected as PROT_NONE, it would also lead to a
pmd_present false negative in the same way as the race with
split_huge_page.

Because the PSE bit stays on at all times (both during split_huge_page and
when the _PAGE_PROTNONE bit get set), we could only check for the PSE bit,
but checking the PROTNONE bit too is still good to remember pmd_present
must always keep PROT_NONE into account.

This explains a not reproducible BUG_ON that was seldom reported on the
lists.

The same issue is in pmd_large, it would go wrong with both PROT_NONE and
if it races with split_huge_page.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp
+++ a/arch/x86/include/asm/pgtable.h
@@ -146,8 +146,7 @@ static inline unsigned long pmd_pfn(pmd_
 
 static inline int pmd_large(pmd_t pte)
 {
-	return (pmd_flags(pte) & (_PAGE_PSE | _PAGE_PRESENT)) ==
-		(_PAGE_PSE | _PAGE_PRESENT);
+	return pmd_flags(pte) & _PAGE_PSE;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -415,7 +414,13 @@ static inline int pte_hidden(pte_t pte)
 
 static inline int pmd_present(pmd_t pmd)
 {
-	return pmd_flags(pmd) & _PAGE_PRESENT;
+	/*
+	 * Checking for _PAGE_PSE is needed too because
+	 * split_huge_page will temporarily clear the present bit (but
+	 * the _PAGE_PSE flag will remain set at all times while the
+	 * _PAGE_PRESENT bit is clear).
+	 */
+	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
 static inline int pmd_none(pmd_t pmd)
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
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
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch

