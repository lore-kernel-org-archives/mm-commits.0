From: akpm@linux-foundation.org
Subject: [merged] thp-fix-zap_huge_pmd-for-dax.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:43:29 -0700
Message-ID: <55f08be1.I0gIIbviZgD88nmB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbbIITn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix zap_huge_pmd() for DAX
has been removed from the -mm tree.  Its filename was
     thp-fix-zap_huge_pmd-for-dax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
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
mm-mark-most-vm_operations_struct-const.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

