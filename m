From: akpm@linux-foundation.org
Subject: [merged] mm-extract-in_gate_area-case-from-__get_user_pages.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:17 -0700
Message-ID: <5390ca35.tWF6CFwA9mgNDLtG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaFETvS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-extract-in_gate_area-case-from-__get_user_pages.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:17 -0700


The patch titled
     Subject: mm: extract in_gate_area() case from __get_user_pages()
has been removed from the -mm tree.  Its filename was
     mm-extract-in_gate_area-case-from-__get_user_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: extract in_gate_area() case from __get_user_pages()

The case is special and disturb from reading main __get_user_pages()
code path. Let's move it to separate function.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   90 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 42 deletions(-)

diff -puN mm/gup.c~mm-extract-in_gate_area-case-from-__get_user_pages mm/gup.c
--- a/mm/gup.c~mm-extract-in_gate_area-case-from-__get_user_pages
+++ a/mm/gup.c
@@ -213,6 +213,50 @@ static inline int stack_guard_page(struc
 	       stack_guard_page_end(vma, addr+PAGE_SIZE);
 }
 
+static int get_gate_page(struct mm_struct *mm, unsigned long address,
+		unsigned int gup_flags, struct vm_area_struct **vma,
+		struct page **page)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	int ret = -EFAULT;
+
+	/* user gate pages are read-only */
+	if (gup_flags & FOLL_WRITE)
+		return -EFAULT;
+	if (address > TASK_SIZE)
+		pgd = pgd_offset_k(address);
+	else
+		pgd = pgd_offset_gate(mm, address);
+	BUG_ON(pgd_none(*pgd));
+	pud = pud_offset(pgd, address);
+	BUG_ON(pud_none(*pud));
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd))
+		return -EFAULT;
+	VM_BUG_ON(pmd_trans_huge(*pmd));
+	pte = pte_offset_map(pmd, address);
+	if (pte_none(*pte))
+		goto unmap;
+	*vma = get_gate_vma(mm);
+	if (!page)
+		goto out;
+	*page = vm_normal_page(*vma, address, *pte);
+	if (!*page) {
+		if ((gup_flags & FOLL_DUMP) || !is_zero_pfn(pte_pfn(*pte)))
+			goto unmap;
+		*page = pte_page(*pte);
+	}
+	get_page(*page);
+out:
+	ret = 0;
+unmap:
+	pte_unmap(pte);
+	return ret;
+}
+
 /**
  * __get_user_pages() - pin user pages in memory
  * @tsk:	task_struct of target task
@@ -291,49 +335,11 @@ long __get_user_pages(struct task_struct
 
 		vma = find_extend_vma(mm, start);
 		if (!vma && in_gate_area(mm, start)) {
-			unsigned long pg = start & PAGE_MASK;
-			pgd_t *pgd;
-			pud_t *pud;
-			pmd_t *pmd;
-			pte_t *pte;
-
-			/* user gate pages are read-only */
-			if (gup_flags & FOLL_WRITE)
-				goto efault;
-			if (pg > TASK_SIZE)
-				pgd = pgd_offset_k(pg);
-			else
-				pgd = pgd_offset_gate(mm, pg);
-			BUG_ON(pgd_none(*pgd));
-			pud = pud_offset(pgd, pg);
-			BUG_ON(pud_none(*pud));
-			pmd = pmd_offset(pud, pg);
-			if (pmd_none(*pmd))
-				goto efault;
-			VM_BUG_ON(pmd_trans_huge(*pmd));
-			pte = pte_offset_map(pmd, pg);
-			if (pte_none(*pte)) {
-				pte_unmap(pte);
+			int ret;
+			ret = get_gate_page(mm, start & PAGE_MASK, gup_flags,
+					&vma, pages ? &pages[i] : NULL);
+			if (ret)
 				goto efault;
-			}
-			vma = get_gate_vma(mm);
-			if (pages) {
-				struct page *page;
-
-				page = vm_normal_page(vma, start, *pte);
-				if (!page) {
-					if (!(gup_flags & FOLL_DUMP) &&
-					     is_zero_pfn(pte_pfn(*pte)))
-						page = pte_page(*pte);
-					else {
-						pte_unmap(pte);
-						goto efault;
-					}
-				}
-				pages[i] = page;
-				get_page(page);
-			}
-			pte_unmap(pte);
 			page_mask = 0;
 			goto next_page;
 		}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

