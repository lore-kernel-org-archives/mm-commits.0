From: akpm@linux-foundation.org
Subject: [merged] thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:15 -0800
Message-ID: <201101142251.p0EMp5RG005472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab1ANWvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: avoid breaking huge pmd invariants in case of vma_adjust failures
has been removed from the -mm tree.  Its filename was
     thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: avoid breaking huge pmd invariants in case of vma_adjust failures
From: Andrea Arcangeli <aarcange@redhat.com>

An huge pmd can only be mapped if the corresponding 2M virtual range is
fully contained in the vma.  At times the VM calls split_vma twice, if the
first split_vma succeeds and the second fail, the first split_vma remains
in effect and it's not rolled back.  For split_vma or vma_adjust to fail
an allocation failure is needed so it's a very unlikely event (the out of
memory killer would normally fire before any allocation failure is visible
to kernel and userland and if an out of memory condition happens it's
unlikely to happen exactly here).  Nevertheless it's safer to ensure that
no huge pmd can be left around if the vma is adjusted in a way that can't
fit hugepages anymore at the new vm_start/vm_end address.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   19 +++++++++
 mm/huge_memory.c        |   80 +++++++++++++++++++++++++++++++++++++-
 mm/mmap.c               |    2 
 3 files changed, 99 insertions(+), 2 deletions(-)

diff -puN include/linux/huge_mm.h~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures
+++ a/include/linux/huge_mm.h
@@ -104,6 +104,19 @@ extern void __split_huge_page_pmd(struct
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
 extern int hugepage_madvise(unsigned long *vm_flags);
+extern void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+				    unsigned long start,
+				    unsigned long end,
+				    long adjust_next);
+static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
+					 unsigned long start,
+					 unsigned long end,
+					 long adjust_next)
+{
+	if (!vma->anon_vma || vma->vm_ops || vma->vm_file)
+		return;
+	__vma_adjust_trans_huge(vma, start, end, adjust_next);
+}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUG(); 0; })
 #define HPAGE_PMD_MASK ({ BUG(); 0; })
@@ -125,6 +138,12 @@ static inline int hugepage_madvise(unsig
 	BUG();
 	return 0;
 }
+static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
+					 unsigned long start,
+					 unsigned long end,
+					 long adjust_next)
+{
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN mm/huge_memory.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures mm/huge_memory.c
--- a/mm/huge_memory.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures
+++ a/mm/huge_memory.c
@@ -1075,8 +1075,16 @@ pmd_t *page_check_address_pmd(struct pag
 		goto out;
 	if (pmd_page(*pmd) != page)
 		goto out;
-	VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
-		  pmd_trans_splitting(*pmd));
+	/*
+	 * split_vma() may create temporary aliased mappings. There is
+	 * no risk as long as all huge pmd are found and have their
+	 * splitting bit set before __split_huge_page_refcount
+	 * runs. Finding the same huge pmd more than once during the
+	 * same rmap walk is not a problem.
+	 */
+	if (flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
+	    pmd_trans_splitting(*pmd))
+		goto out;
 	if (pmd_trans_huge(*pmd)) {
 		VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG &&
 			  !pmd_trans_splitting(*pmd));
@@ -2196,3 +2204,71 @@ void __split_huge_page_pmd(struct mm_str
 	put_page(page);
 	BUG_ON(pmd_trans_huge(*pmd));
 }
+
+static void split_huge_page_address(struct mm_struct *mm,
+				    unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		return;
+	/*
+	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
+	 * materialize from under us.
+	 */
+	split_huge_page_pmd(mm, pmd);
+}
+
+void __vma_adjust_trans_huge(struct vm_area_struct *vma,
+			     unsigned long start,
+			     unsigned long end,
+			     long adjust_next)
+{
+	/*
+	 * If the new start address isn't hpage aligned and it could
+	 * previously contain an hugepage: check if we need to split
+	 * an huge pmd.
+	 */
+	if (start & ~HPAGE_PMD_MASK &&
+	    (start & HPAGE_PMD_MASK) >= vma->vm_start &&
+	    (start & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
+		split_huge_page_address(vma->vm_mm, start);
+
+	/*
+	 * If the new end address isn't hpage aligned and it could
+	 * previously contain an hugepage: check if we need to split
+	 * an huge pmd.
+	 */
+	if (end & ~HPAGE_PMD_MASK &&
+	    (end & HPAGE_PMD_MASK) >= vma->vm_start &&
+	    (end & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
+		split_huge_page_address(vma->vm_mm, end);
+
+	/*
+	 * If we're also updating the vma->vm_next->vm_start, if the new
+	 * vm_next->vm_start isn't page aligned and it could previously
+	 * contain an hugepage: check if we need to split an huge pmd.
+	 */
+	if (adjust_next > 0) {
+		struct vm_area_struct *next = vma->vm_next;
+		unsigned long nstart = next->vm_start;
+		nstart += adjust_next << PAGE_SHIFT;
+		if (nstart & ~HPAGE_PMD_MASK &&
+		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
+		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
+			split_huge_page_address(next->vm_mm, nstart);
+	}
+}
diff -puN mm/mmap.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures mm/mmap.c
--- a/mm/mmap.c~thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures
+++ a/mm/mmap.c
@@ -589,6 +589,8 @@ again:			remove_next = 1 + (end > next->
 		}
 	}
 
+	vma_adjust_trans_huge(vma, start, end, adjust_next);
+
 	/*
 	 * When changing only vma->vm_end, we don't really need anon_vma
 	 * lock. This is a fairly rare case by itself, but the anon_vma
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

