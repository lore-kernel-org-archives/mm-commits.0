From: akpm@linux-foundation.org
Subject: [merged] mm-drop-page_check_address_transhuge.patch removed from
 -mm tree
Date: Mon, 27 Feb 2017 12:26:26 -0800
Message-ID: <58b48b72.e/3FUC6lMAAo7PVe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop page_check_address{,_transhuge}
has been removed from the -mm tree.  Its filename was
     mm-drop-page_check_address_transhuge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop page_check_address{,_transhuge}

All users are gone. Let's drop them.

Link: http://lkml.kernel.org/r/20170129173858.45174-12-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   36 ----------
 mm/rmap.c            |  138 -----------------------------------------
 2 files changed, 174 deletions(-)

diff -puN include/linux/rmap.h~mm-drop-page_check_address_transhuge include/linux/rmap.h
--- a/include/linux/rmap.h~mm-drop-page_check_address_transhuge
+++ a/include/linux/rmap.h
@@ -197,42 +197,6 @@ int page_referenced(struct page *, int i
 
 int try_to_unmap(struct page *, enum ttu_flags flags);
 
-/*
- * Used by uprobes to replace a userspace page safely
- */
-pte_t *__page_check_address(struct page *, struct mm_struct *,
-				unsigned long, spinlock_t **, int);
-
-static inline pte_t *page_check_address(struct page *page, struct mm_struct *mm,
-					unsigned long address,
-					spinlock_t **ptlp, int sync)
-{
-	pte_t *ptep;
-
-	__cond_lock(*ptlp, ptep = __page_check_address(page, mm, address,
-						       ptlp, sync));
-	return ptep;
-}
-
-/*
- * Used by idle page tracking to check if a page was referenced via page
- * tables.
- */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-bool page_check_address_transhuge(struct page *page, struct mm_struct *mm,
-				  unsigned long address, pmd_t **pmdp,
-				  pte_t **ptep, spinlock_t **ptlp);
-#else
-static inline bool page_check_address_transhuge(struct page *page,
-				struct mm_struct *mm, unsigned long address,
-				pmd_t **pmdp, pte_t **ptep, spinlock_t **ptlp)
-{
-	*ptep = page_check_address(page, mm, address, ptlp, 0);
-	*pmdp = NULL;
-	return !!*ptep;
-}
-#endif
-
 /* Avoid racy checks */
 #define PVMW_SYNC		(1 << 0)
 /* Look for migarion entries rather than present PTEs */
diff -puN mm/rmap.c~mm-drop-page_check_address_transhuge mm/rmap.c
--- a/mm/rmap.c~mm-drop-page_check_address_transhuge
+++ a/mm/rmap.c
@@ -708,144 +708,6 @@ out:
 	return pmd;
 }
 
-/*
- * Check that @page is mapped at @address into @mm.
- *
- * If @sync is false, page_check_address may perform a racy check to avoid
- * the page table lock when the pte is not present (helpful when reclaiming
- * highly shared pages).
- *
- * On success returns with pte mapped and locked.
- */
-pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
-			  unsigned long address, spinlock_t **ptlp, int sync)
-{
-	pmd_t *pmd;
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	if (unlikely(PageHuge(page))) {
-		/* when pud is not present, pte will be NULL */
-		pte = huge_pte_offset(mm, address);
-		if (!pte)
-			return NULL;
-
-		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
-		goto check;
-	}
-
-	pmd = mm_find_pmd(mm, address);
-	if (!pmd)
-		return NULL;
-
-	pte = pte_offset_map(pmd, address);
-	/* Make a quick check before getting the lock */
-	if (!sync && !pte_present(*pte)) {
-		pte_unmap(pte);
-		return NULL;
-	}
-
-	ptl = pte_lockptr(mm, pmd);
-check:
-	spin_lock(ptl);
-	if (pte_present(*pte) && page_to_pfn(page) == pte_pfn(*pte)) {
-		*ptlp = ptl;
-		return pte;
-	}
-	pte_unmap_unlock(pte, ptl);
-	return NULL;
-}
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/*
- * Check that @page is mapped at @address into @mm. In contrast to
- * page_check_address(), this function can handle transparent huge pages.
- *
- * On success returns true with pte mapped and locked. For PMD-mapped
- * transparent huge pages *@ptep is set to NULL.
- */
-bool page_check_address_transhuge(struct page *page, struct mm_struct *mm,
-				  unsigned long address, pmd_t **pmdp,
-				  pte_t **ptep, spinlock_t **ptlp)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	if (unlikely(PageHuge(page))) {
-		/* when pud is not present, pte will be NULL */
-		pte = huge_pte_offset(mm, address);
-		if (!pte)
-			return false;
-
-		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
-		pmd = NULL;
-		goto check_pte;
-	}
-
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		return false;
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
-		return false;
-	pmd = pmd_offset(pud, address);
-
-	if (pmd_trans_huge(*pmd)) {
-		ptl = pmd_lock(mm, pmd);
-		if (!pmd_present(*pmd))
-			goto unlock_pmd;
-		if (unlikely(!pmd_trans_huge(*pmd))) {
-			spin_unlock(ptl);
-			goto map_pte;
-		}
-
-		if (pmd_page(*pmd) != page)
-			goto unlock_pmd;
-
-		pte = NULL;
-		goto found;
-unlock_pmd:
-		spin_unlock(ptl);
-		return false;
-	} else {
-		pmd_t pmde = *pmd;
-
-		barrier();
-		if (!pmd_present(pmde) || pmd_trans_huge(pmde))
-			return false;
-	}
-map_pte:
-	pte = pte_offset_map(pmd, address);
-	if (!pte_present(*pte)) {
-		pte_unmap(pte);
-		return false;
-	}
-
-	ptl = pte_lockptr(mm, pmd);
-check_pte:
-	spin_lock(ptl);
-
-	if (!pte_present(*pte)) {
-		pte_unmap_unlock(pte, ptl);
-		return false;
-	}
-
-	/* THP can be referenced by any subpage */
-	if (pte_pfn(*pte) - page_to_pfn(page) >= hpage_nr_pages(page)) {
-		pte_unmap_unlock(pte, ptl);
-		return false;
-	}
-found:
-	*ptep = pte;
-	*pmdp = pmd;
-	*ptlp = ptl;
-	return true;
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
