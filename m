From: akpm@linux-foundation.org
Subject: + thp-fix-zap_huge_pmd-for-dax.patch added to -mm tree
Date: Tue, 04 Aug 2015 14:34:39 -0700
Message-ID: <55c12fef.fVCwir39j8/d1Bxh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbbHDVek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix zap_huge_pmd() for DAX
has been added to the -mm tree.  Its filename is
     thp-fix-zap_huge_pmd-for-dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-fix-zap_huge_pmd-for-dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-fix-zap_huge_pmd-for-dax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix zap_huge_pmd() for DAX

The original DAX code assumed that pgtable_t was a pointer, which isn't
true on all architectures.  Restructure the code to not rely on that
assumption.

[willy@linux.intel.com: further fixes integrated into this patch]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   71 +++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 40 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-zap_huge_pmd-for-dax mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-zap_huge_pmd-for-dax
+++ a/mm/huge_memory.c
@@ -1456,50 +1456,41 @@ out:
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
+	pmd_t orig_pmd;
 	spinlock_t *ptl;
-	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
-		pgtable_t pgtable;
-		pmd_t orig_pmd;
-		/*
-		 * For architectures like ppc64 we look at deposited pgtable
-		 * when calling pmdp_huge_get_and_clear. So do the
-		 * pgtable_trans_huge_withdraw after finishing pmdp related
-		 * operations.
-		 */
-		orig_pmd = pmdp_huge_get_and_clear_full(tlb->mm, addr, pmd,
-							tlb->fullmm);
-		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-		if (vma_is_dax(vma)) {
-			if (is_huge_zero_pmd(orig_pmd)) {
-				pgtable = NULL;
-			} else {
-				spin_unlock(ptl);
-				return 1;
-			}
-		} else {
-			pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
-		}
-		if (is_huge_zero_pmd(orig_pmd)) {
-			atomic_long_dec(&tlb->mm->nr_ptes);
-			spin_unlock(ptl);
+	if (__pmd_trans_huge_lock(pmd, vma, &ptl) != 1)
+		return 0;
+	/*
+	 * For architectures like ppc64 we look at deposited pgtable
+	 * when calling pmdp_huge_get_and_clear. So do the
+	 * pgtable_trans_huge_withdraw after finishing pmdp related
+	 * operations.
+	 */
+	orig_pmd = pmdp_huge_get_and_clear_full(tlb->mm, addr, pmd,
+			tlb->fullmm);
+	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+	if (vma_is_dax(vma)) {
+		spin_unlock(ptl);
+		if (is_huge_zero_pmd(orig_pmd))
 			put_huge_zero_page();
-		} else {
-			struct page *page = pmd_page(orig_pmd);
-			page_remove_rmap(page);
-			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
-			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-			VM_BUG_ON_PAGE(!PageHead(page), page);
-			atomic_long_dec(&tlb->mm->nr_ptes);
-			spin_unlock(ptl);
-			tlb_remove_page(tlb, page);
-		}
-		if (pgtable)
-			pte_free(tlb->mm, pgtable);
-		ret = 1;
+	} else if (is_huge_zero_pmd(orig_pmd)) {
+		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
+		atomic_long_dec(&tlb->mm->nr_ptes);
+		spin_unlock(ptl);
+		put_huge_zero_page();
+	} else {
+		struct page *page = pmd_page(orig_pmd);
+		page_remove_rmap(page);
+		VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
+		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+		VM_BUG_ON_PAGE(!PageHead(page), page);
+		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
+		atomic_long_dec(&tlb->mm->nr_ptes);
+		spin_unlock(ptl);
+		tlb_remove_page(tlb, page);
 	}
-	return ret;
+	return 1;
 }
 
 int move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

user_ns-use-correct-check-for-single-threadedness.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
mm-fix-status-code-move_pages-returns-for-zero-page.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
vm_flags-vm_flags_t-and-__nocast.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
fix-list_poison12-offset.patch
use-poison_pointer_delta-for-poison-pointers.patch
remove-not-used-poison-pointer-macros.patch
mm-mark-most-vm_operations_struct-const.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

