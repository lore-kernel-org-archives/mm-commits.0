From: akpm@linux-foundation.org
Subject: + mm-cleanup-follow_page_mask.patch added to -mm tree
Date: Fri, 02 May 2014 13:47:17 -0700
Message-ID: <53640455.9rgdSkmFi77JSYpN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaEBUrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 16:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-cleanup-follow_page_mask.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 13:47:17 -0700


The patch titled
     Subject: mm: cleanup follow_page_mask()
has been added to the -mm tree.  Its filename is
     mm-cleanup-follow_page_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-follow_page_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-follow_page_mask.patch

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
Subject: mm: cleanup follow_page_mask()

Cleanups:
 - move pte-related code to separate function. It's about half of the
   function;
 - get rid of some goto-logic;
 - use 'return NULL' instead of 'return page' where page can only be
   NULL;

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  231 +++++++++++++++++++++++++++--------------------------
 1 file changed, 119 insertions(+), 112 deletions(-)

diff -puN mm/gup.c~mm-cleanup-follow_page_mask mm/gup.c
--- a/mm/gup.c~mm-cleanup-follow_page_mask
+++ a/mm/gup.c
@@ -12,105 +12,35 @@
 
 #include "internal.h"
 
-/**
- * follow_page_mask - look up a page descriptor from a user-virtual address
- * @vma: vm_area_struct mapping @address
- * @address: virtual address to look up
- * @flags: flags modifying lookup behaviour
- * @page_mask: on output, *page_mask is set according to the size of the page
- *
- * @flags can have FOLL_ flags set, defined in <linux/mm.h>
- *
- * Returns the mapped (struct page *), %NULL if no mapping exists, or
- * an error pointer if there is a mapping to something not represented
- * by a page descriptor (see also vm_normal_page()).
- */
-struct page *follow_page_mask(struct vm_area_struct *vma,
-			      unsigned long address, unsigned int flags,
-			      unsigned int *page_mask)
+static struct page *no_page_table(struct vm_area_struct *vma,
+		unsigned int flags)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
-	struct page *page;
-	struct mm_struct *mm = vma->vm_mm;
-
-	*page_mask = 0;
-
-	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
-	if (!IS_ERR(page)) {
-		BUG_ON(flags & FOLL_GET);
-		goto out;
-	}
-
-	page = NULL;
-	pgd = pgd_offset(mm, address);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto no_page_table;
+	/*
+	 * When core dumping an enormous anonymous area that nobody
+	 * has touched so far, we don't want to allocate unnecessary pages or
+	 * page tables.  Return error instead of NULL to skip handle_mm_fault,
+	 * then get_dump_page() will return NULL to leave a hole in the dump.
+	 * But we can only make this optimization where a hole would surely
+	 * be zero-filled if handle_mm_fault() actually did handle it.
+	 */
+	if ((flags & FOLL_DUMP) && (!vma->vm_ops || !vma->vm_ops->fault))
+		return ERR_PTR(-EFAULT);
+	return NULL;
+}
 
-	pud = pud_offset(pgd, address);
-	if (pud_none(*pud))
-		goto no_page_table;
-	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
-		if (flags & FOLL_GET)
-			goto out;
-		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
-		goto out;
-	}
-	if (unlikely(pud_bad(*pud)))
-		goto no_page_table;
+static struct page *follow_page_pte(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmd, unsigned int flags)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page *page;
+	spinlock_t *ptl;
+	pte_t *ptep, pte;
 
-	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd))
-		goto no_page_table;
-	if (pmd_huge(*pmd) && vma->vm_flags & VM_HUGETLB) {
-		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
-		if (flags & FOLL_GET) {
-			/*
-			 * Refcount on tail pages are not well-defined and
-			 * shouldn't be taken. The caller should handle a NULL
-			 * return when trying to follow tail pages.
-			 */
-			if (PageHead(page))
-				get_page(page);
-			else {
-				page = NULL;
-				goto out;
-			}
-		}
-		goto out;
-	}
-	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
-		goto no_page_table;
-	if (pmd_trans_huge(*pmd)) {
-		if (flags & FOLL_SPLIT) {
-			split_huge_page_pmd(vma, address, pmd);
-			goto split_fallthrough;
-		}
-		ptl = pmd_lock(mm, pmd);
-		if (likely(pmd_trans_huge(*pmd))) {
-			if (unlikely(pmd_trans_splitting(*pmd))) {
-				spin_unlock(ptl);
-				wait_split_huge_page(vma->anon_vma, pmd);
-			} else {
-				page = follow_trans_huge_pmd(vma, address,
-							     pmd, flags);
-				spin_unlock(ptl);
-				*page_mask = HPAGE_PMD_NR - 1;
-				goto out;
-			}
-		} else
-			spin_unlock(ptl);
-		/* fall through */
-	}
-split_fallthrough:
+retry:
 	if (unlikely(pmd_bad(*pmd)))
-		goto no_page_table;
+		return no_page_table(vma, flags);
 
 	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-
 	pte = *ptep;
 	if (!pte_present(pte)) {
 		swp_entry_t entry;
@@ -128,12 +58,14 @@ split_fallthrough:
 			goto no_page;
 		pte_unmap_unlock(ptep, ptl);
 		migration_entry_wait(mm, pmd, address);
-		goto split_fallthrough;
+		goto retry;
 	}
 	if ((flags & FOLL_NUMA) && pte_numa(pte))
 		goto no_page;
-	if ((flags & FOLL_WRITE) && !pte_write(pte))
-		goto unlock;
+	if ((flags & FOLL_WRITE) && !pte_write(pte)) {
+		pte_unmap_unlock(ptep, ptl);
+		return NULL;
+	}
 
 	page = vm_normal_page(vma, address, pte);
 	if (unlikely(!page)) {
@@ -178,11 +110,8 @@ split_fallthrough:
 			unlock_page(page);
 		}
 	}
-unlock:
 	pte_unmap_unlock(ptep, ptl);
-out:
 	return page;
-
 bad_page:
 	pte_unmap_unlock(ptep, ptl);
 	return ERR_PTR(-EFAULT);
@@ -190,21 +119,99 @@ bad_page:
 no_page:
 	pte_unmap_unlock(ptep, ptl);
 	if (!pte_none(pte))
+		return NULL;
+	return no_page_table(vma, flags);
+}
+
+/**
+ * follow_page_mask - look up a page descriptor from a user-virtual address
+ * @vma: vm_area_struct mapping @address
+ * @address: virtual address to look up
+ * @flags: flags modifying lookup behaviour
+ * @page_mask: on output, *page_mask is set according to the size of the page
+ *
+ * @flags can have FOLL_ flags set, defined in <linux/mm.h>
+ *
+ * Returns the mapped (struct page *), %NULL if no mapping exists, or
+ * an error pointer if there is a mapping to something not represented
+ * by a page descriptor (see also vm_normal_page()).
+ */
+struct page *follow_page_mask(struct vm_area_struct *vma,
+			      unsigned long address, unsigned int flags,
+			      unsigned int *page_mask)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	spinlock_t *ptl;
+	struct page *page;
+	struct mm_struct *mm = vma->vm_mm;
+
+	*page_mask = 0;
+
+	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
+	if (!IS_ERR(page)) {
+		BUG_ON(flags & FOLL_GET);
 		return page;
+	}
 
-no_page_table:
-	/*
-	 * When core dumping an enormous anonymous area that nobody
-	 * has touched so far, we don't want to allocate unnecessary pages or
-	 * page tables.  Return error instead of NULL to skip handle_mm_fault,
-	 * then get_dump_page() will return NULL to leave a hole in the dump.
-	 * But we can only make this optimization where a hole would surely
-	 * be zero-filled if handle_mm_fault() actually did handle it.
-	 */
-	if ((flags & FOLL_DUMP) &&
-	    (!vma->vm_ops || !vma->vm_ops->fault))
-		return ERR_PTR(-EFAULT);
-	return page;
+	pgd = pgd_offset(mm, address);
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		return no_page_table(vma, flags);
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud))
+		return no_page_table(vma, flags);
+	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
+		if (flags & FOLL_GET)
+			return NULL;
+		page = follow_huge_pud(mm, address, pud, flags & FOLL_WRITE);
+		return page;
+	}
+	if (unlikely(pud_bad(*pud)))
+		return no_page_table(vma, flags);
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd))
+		return no_page_table(vma, flags);
+	if (pmd_huge(*pmd) && vma->vm_flags & VM_HUGETLB) {
+		page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
+		if (flags & FOLL_GET) {
+			/*
+			 * Refcount on tail pages are not well-defined and
+			 * shouldn't be taken. The caller should handle a NULL
+			 * return when trying to follow tail pages.
+			 */
+			if (PageHead(page))
+				get_page(page);
+			else
+				page = NULL;
+		}
+		return page;
+	}
+	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
+		return no_page_table(vma, flags);
+	if (pmd_trans_huge(*pmd)) {
+		if (flags & FOLL_SPLIT) {
+			split_huge_page_pmd(vma, address, pmd);
+			return follow_page_pte(vma, address, pmd, flags);
+		}
+		ptl = pmd_lock(mm, pmd);
+		if (likely(pmd_trans_huge(*pmd))) {
+			if (unlikely(pmd_trans_splitting(*pmd))) {
+				spin_unlock(ptl);
+				wait_split_huge_page(vma->anon_vma, pmd);
+			} else {
+				page = follow_trans_huge_pmd(vma, address,
+							     pmd, flags);
+				spin_unlock(ptl);
+				*page_mask = HPAGE_PMD_NR - 1;
+				return page;
+			}
+		} else
+			spin_unlock(ptl);
+	}
+	return follow_page_pte(vma, address, pmd, flags);
 }
 
 static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

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
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

