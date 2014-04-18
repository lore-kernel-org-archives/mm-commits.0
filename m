From: akpm@linux-foundation.org
Subject: + mm-extract-in_gate_area-case-from-__get_user_pages.patch added
 to -mm tree
Date: Fri, 18 Apr 2014 15:15:59 -0700
Message-ID: <5351a41f.9x06RvXT9/JLzS7T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaDRWQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 18:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-extract-in_gate_area-case-from-__get_user_pages.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 15:15:59 -0700


The patch titled
     Subject: mm: extract in_gate_area() case from __get_user_pages()
has been added to the -mm tree.  Its filename is
     mm-extract-in_gate_area-case-from-__get_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-extract-in_gate_area-case-from-__get_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-extract-in_gate_area-case-from-__get_user_pages.patch

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
Subject: mm: extract in_gate_area() case from __get_user_pages()

The case is special and disturb from reading main __get_user_pages()
code path. Let's move it to separate function.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   95 +++++++++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 43 deletions(-)

diff -puN mm/gup.c~mm-extract-in_gate_area-case-from-__get_user_pages mm/gup.c
--- a/mm/gup.c~mm-extract-in_gate_area-case-from-__get_user_pages
+++ a/mm/gup.c
@@ -207,6 +207,53 @@ static inline int stack_guard_page(struc
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
+	int ret = 0;
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
+	if (pte_none(*pte)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	*vma = get_gate_vma(mm);
+	if (!page)
+		goto out;
+	*page = vm_normal_page(*vma, address, *pte);
+	if (!*page)
+		goto out;
+	if ((gup_flags & FOLL_DUMP) || !is_zero_pfn(pte_pfn(*pte))) {
+		*page = NULL;
+		ret = -EFAULT;
+		goto out;
+	}
+	*page = pte_page(*pte);
+	get_page(*page);
+out:
+	pte_unmap(pte);
+	return 0;
+}
+
 /**
  * __get_user_pages() - pin user pages in memory
  * @tsk:	task_struct of target task
@@ -294,49 +341,11 @@ long __get_user_pages(struct task_struct
 
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
-				return i ? : -EFAULT;
-			if (pg > TASK_SIZE)
-				pgd = pgd_offset_k(pg);
-			else
-				pgd = pgd_offset_gate(mm, pg);
-			BUG_ON(pgd_none(*pgd));
-			pud = pud_offset(pgd, pg);
-			BUG_ON(pud_none(*pud));
-			pmd = pmd_offset(pud, pg);
-			if (pmd_none(*pmd))
-				return i ? : -EFAULT;
-			VM_BUG_ON(pmd_trans_huge(*pmd));
-			pte = pte_offset_map(pmd, pg);
-			if (pte_none(*pte)) {
-				pte_unmap(pte);
-				return i ? : -EFAULT;
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
-						return i ? : -EFAULT;
-					}
-				}
-				pages[i] = page;
-				get_page(page);
-			}
-			pte_unmap(pte);
+			int ret;
+			ret = get_gate_page(mm, start & PAGE_MASK, gup_flags,
+					&vma, pages ? &pages[i] : NULL);
+			if (ret)
+				return i ? : ret;
 			page_mask = 0;
 			goto next_page;
 		}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-close-race-between-split-and-zap-huge-pages.patch
pagewalk-update-page-table-walker-core.patch
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
thp-consolidate-assert-checks-in-__split_huge_page.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

