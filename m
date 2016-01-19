From: akpm@linux-foundation.org
Subject: [merged]
 mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:12:11 -0800
Message-ID: <569e989b.WUezT2ZHjbL0YZ1N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbcASUMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hughd@google.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, sasha.levin@oracle.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prepare page_referenced() and page_idle to new THP refcounting
has been removed from the -mm tree.  Its filename was
     mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: prepare page_referenced() and page_idle to new THP refcounting

Both page_referenced() and page_idle_clear_pte_refs_one() assume that THP
can only be mapped with PMD, so there's no reason to look on PTEs for
PageTransHuge() pages.  That's no true anymore: THP can be mapped with
PTEs too.

The patch removes PageTransHuge() test from the functions and opencode
page table check.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 -
 include/linux/mm.h      |   23 ++++---
 mm/huge_memory.c        |   73 ++++++-----------------
 mm/page_idle.c          |   65 ++++++++++++++++++---
 mm/rmap.c               |  117 ++++++++++++++++++++++++++------------
 mm/util.c               |   14 ++++
 6 files changed, 185 insertions(+), 112 deletions(-)

diff -puN include/linux/huge_mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/include/linux/huge_mm.h
@@ -48,11 +48,6 @@ enum transparent_hugepage_flag {
 #endif
 };
 
-extern pmd_t *page_check_address_pmd(struct page *page,
-				     struct mm_struct *mm,
-				     unsigned long address,
-				     spinlock_t **ptl);
-
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 
diff -puN include/linux/mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting include/linux/mm.h
--- a/include/linux/mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/include/linux/mm.h
@@ -433,20 +433,25 @@ static inline void page_mapcount_reset(s
 	atomic_set(&(page)->_mapcount, -1);
 }
 
+int __page_mapcount(struct page *page);
+
 static inline int page_mapcount(struct page *page)
 {
-	int ret;
 	VM_BUG_ON_PAGE(PageSlab(page), page);
 
-	ret = atomic_read(&page->_mapcount) + 1;
-	if (PageCompound(page)) {
-		page = compound_head(page);
-		ret += atomic_read(compound_mapcount_ptr(page)) + 1;
-		if (PageDoubleMap(page))
-			ret--;
-	}
-	return ret;
+	if (unlikely(PageCompound(page)))
+		return __page_mapcount(page);
+	return atomic_read(&page->_mapcount) + 1;
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+int total_mapcount(struct page *page);
+#else
+static inline int total_mapcount(struct page *page)
+{
+	return page_mapcount(page);
 }
+#endif
 
 static inline int page_count(struct page *page)
 {
diff -puN mm/huge_memory.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting mm/huge_memory.c
--- a/mm/huge_memory.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/mm/huge_memory.c
@@ -1649,46 +1649,6 @@ bool __pmd_trans_huge_lock(pmd_t *pmd, s
 	return false;
 }
 
-/*
- * This function returns whether a given @page is mapped onto the @address
- * in the virtual space of @mm.
- *
- * When it's true, this function returns *pmd with holding the page table lock
- * and passing it back to the caller via @ptl.
- * If it's false, returns NULL without holding the page table lock.
- */
-pmd_t *page_check_address_pmd(struct page *page,
-			      struct mm_struct *mm,
-			      unsigned long address,
-			      spinlock_t **ptl)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	if (address & ~HPAGE_PMD_MASK)
-		return NULL;
-
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		return NULL;
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
-		return NULL;
-	pmd = pmd_offset(pud, address);
-
-	*ptl = pmd_lock(mm, pmd);
-	if (!pmd_present(*pmd))
-		goto unlock;
-	if (pmd_page(*pmd) != page)
-		goto unlock;
-	if (pmd_trans_huge(*pmd))
-		return pmd;
-unlock:
-	spin_unlock(*ptl);
-	return NULL;
-}
-
 #define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -3097,20 +3057,6 @@ static void unfreeze_page(struct anon_vm
 	}
 }
 
-static int total_mapcount(struct page *page)
-{
-	int i, ret;
-
-	ret = compound_mapcount(page);
-	for (i = 0; i < HPAGE_PMD_NR; i++)
-		ret += atomic_read(&page[i]._mapcount) + 1;
-
-	if (PageDoubleMap(page))
-		ret -= HPAGE_PMD_NR;
-
-	return ret;
-}
-
 static int __split_huge_page_tail(struct page *head, int tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
@@ -3211,6 +3157,25 @@ static void __split_huge_page(struct pag
 	}
 }
 
+int total_mapcount(struct page *page)
+{
+	int i, ret;
+
+	VM_BUG_ON_PAGE(PageTail(page), page);
+
+	if (likely(!PageCompound(page)))
+		return atomic_read(&page->_mapcount) + 1;
+
+	ret = compound_mapcount(page);
+	if (PageHuge(page))
+		return ret;
+	for (i = 0; i < HPAGE_PMD_NR; i++)
+		ret += atomic_read(&page[i]._mapcount) + 1;
+	if (PageDoubleMap(page))
+		ret -= HPAGE_PMD_NR;
+	return ret;
+}
+
 /*
  * This function splits huge page into normal pages. @page can point to any
  * subpage of huge page to split. Split doesn't change the position of @page.
diff -puN mm/page_idle.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting mm/page_idle.c
--- a/mm/page_idle.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/mm/page_idle.c
@@ -56,23 +56,70 @@ static int page_idle_clear_pte_refs_one(
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
+	pgd_t *pgd;
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	bool referenced = false;
 
-	if (unlikely(PageTransHuge(page))) {
-		pmd = page_check_address_pmd(page, mm, addr, &ptl);
-		if (pmd) {
-			referenced = pmdp_clear_young_notify(vma, addr, pmd);
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		return SWAP_AGAIN;
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		return SWAP_AGAIN;
+	pmd = pmd_offset(pud, addr);
+
+	if (pmd_trans_huge(*pmd)) {
+		ptl = pmd_lock(mm, pmd);
+		if (!pmd_present(*pmd))
+			goto unlock_pmd;
+		if (unlikely(!pmd_trans_huge(*pmd))) {
 			spin_unlock(ptl);
+			goto map_pte;
 		}
+
+		if (pmd_page(*pmd) != page)
+			goto unlock_pmd;
+
+		referenced = pmdp_clear_young_notify(vma, addr, pmd);
+		spin_unlock(ptl);
+		goto found;
+unlock_pmd:
+		spin_unlock(ptl);
+		return SWAP_AGAIN;
 	} else {
-		pte = page_check_address(page, mm, addr, &ptl, 0);
-		if (pte) {
-			referenced = ptep_clear_young_notify(vma, addr, pte);
-			pte_unmap_unlock(pte, ptl);
-		}
+		pmd_t pmde = *pmd;
+
+		barrier();
+		if (!pmd_present(pmde) || pmd_trans_huge(pmde))
+			return SWAP_AGAIN;
+
+	}
+map_pte:
+	pte = pte_offset_map(pmd, addr);
+	if (!pte_present(*pte)) {
+		pte_unmap(pte);
+		return SWAP_AGAIN;
 	}
+
+	ptl = pte_lockptr(mm, pmd);
+	spin_lock(ptl);
+
+	if (!pte_present(*pte)) {
+		pte_unmap_unlock(pte, ptl);
+		return SWAP_AGAIN;
+	}
+
+	/* THP can be referenced by any subpage */
+	if (pte_pfn(*pte) - page_to_pfn(page) >= hpage_nr_pages(page)) {
+		pte_unmap_unlock(pte, ptl);
+		return SWAP_AGAIN;
+	}
+
+	referenced = ptep_clear_young_notify(vma, addr, pte);
+	pte_unmap_unlock(pte, ptl);
+found:
 	if (referenced) {
 		clear_page_idle(page);
 		/*
diff -puN mm/rmap.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting mm/rmap.c
--- a/mm/rmap.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/mm/rmap.c
@@ -814,58 +814,105 @@ static int page_referenced_one(struct pa
 	spinlock_t *ptl;
 	int referenced = 0;
 	struct page_referenced_arg *pra = arg;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (unlikely(PageHuge(page))) {
+		/* when pud is not present, pte will be NULL */
+		pte = huge_pte_offset(mm, address);
+		if (!pte)
+			return SWAP_AGAIN;
 
-	if (unlikely(PageTransHuge(page))) {
-		pmd_t *pmd;
+		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
+		goto check_pte;
+	}
 
-		/*
-		 * rmap might return false positives; we must filter
-		 * these out using page_check_address_pmd().
-		 */
-		pmd = page_check_address_pmd(page, mm, address, &ptl);
-		if (!pmd)
-			return SWAP_AGAIN;
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return SWAP_AGAIN;
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		return SWAP_AGAIN;
+	pmd = pmd_offset(pud, address);
+
+	if (pmd_trans_huge(*pmd)) {
+		int ret = SWAP_AGAIN;
+
+		ptl = pmd_lock(mm, pmd);
+		if (!pmd_present(*pmd))
+			goto unlock_pmd;
+		if (unlikely(!pmd_trans_huge(*pmd))) {
+			spin_unlock(ptl);
+			goto map_pte;
+		}
+
+		if (pmd_page(*pmd) != page)
+			goto unlock_pmd;
 
 		if (vma->vm_flags & VM_LOCKED) {
-			spin_unlock(ptl);
 			pra->vm_flags |= VM_LOCKED;
-			return SWAP_FAIL; /* To break the loop */
+			ret = SWAP_FAIL; /* To break the loop */
+			goto unlock_pmd;
 		}
 
 		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
 		spin_unlock(ptl);
+		goto found;
+unlock_pmd:
+		spin_unlock(ptl);
+		return ret;
 	} else {
-		pte_t *pte;
+		pmd_t pmde = *pmd;
 
-		/*
-		 * rmap might return false positives; we must filter
-		 * these out using page_check_address().
-		 */
-		pte = page_check_address(page, mm, address, &ptl, 0);
-		if (!pte)
+		barrier();
+		if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 			return SWAP_AGAIN;
+	}
+map_pte:
+	pte = pte_offset_map(pmd, address);
+	if (!pte_present(*pte)) {
+		pte_unmap(pte);
+		return SWAP_AGAIN;
+	}
 
-		if (vma->vm_flags & VM_LOCKED) {
-			pte_unmap_unlock(pte, ptl);
-			pra->vm_flags |= VM_LOCKED;
-			return SWAP_FAIL; /* To break the loop */
-		}
+	ptl = pte_lockptr(mm, pmd);
+check_pte:
+	spin_lock(ptl);
 
-		if (ptep_clear_flush_young_notify(vma, address, pte)) {
-			/*
-			 * Don't treat a reference through a sequentially read
-			 * mapping as such.  If the page has been used in
-			 * another mapping, we will catch it; if this other
-			 * mapping is already gone, the unmap path will have
-			 * set PG_referenced or activated the page.
-			 */
-			if (likely(!(vma->vm_flags & VM_SEQ_READ)))
-				referenced++;
-		}
+	if (!pte_present(*pte)) {
 		pte_unmap_unlock(pte, ptl);
+		return SWAP_AGAIN;
+	}
+
+	/* THP can be referenced by any subpage */
+	if (pte_pfn(*pte) - page_to_pfn(page) >= hpage_nr_pages(page)) {
+		pte_unmap_unlock(pte, ptl);
+		return SWAP_AGAIN;
+	}
+
+	if (vma->vm_flags & VM_LOCKED) {
+		pte_unmap_unlock(pte, ptl);
+		pra->vm_flags |= VM_LOCKED;
+		return SWAP_FAIL; /* To break the loop */
+	}
+
+	if (ptep_clear_flush_young_notify(vma, address, pte)) {
+		/*
+		 * Don't treat a reference through a sequentially read
+		 * mapping as such.  If the page has been used in
+		 * another mapping, we will catch it; if this other
+		 * mapping is already gone, the unmap path will have
+		 * set PG_referenced or activated the page.
+		 */
+		if (likely(!(vma->vm_flags & VM_SEQ_READ)))
+			referenced++;
 	}
+	pte_unmap_unlock(pte, ptl);
 
+found:
 	if (referenced)
 		clear_page_idle(page);
 	if (test_and_clear_page_young(page))
@@ -912,7 +959,7 @@ int page_referenced(struct page *page,
 	int ret;
 	int we_locked = 0;
 	struct page_referenced_arg pra = {
-		.mapcount = page_mapcount(page),
+		.mapcount = total_mapcount(page),
 		.memcg = memcg,
 	};
 	struct rmap_walk_control rwc = {
diff -puN mm/util.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting mm/util.c
--- a/mm/util.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/mm/util.c
@@ -407,6 +407,20 @@ struct address_space *page_mapping(struc
 	return mapping;
 }
 
+/* Slow path of page_mapcount() for compound pages */
+int __page_mapcount(struct page *page)
+{
+	int ret;
+
+	ret = atomic_read(&page->_mapcount) + 1;
+	page = compound_head(page);
+	ret += atomic_read(compound_mapcount_ptr(page)) + 1;
+	if (PageDoubleMap(page))
+		ret--;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__page_mapcount);
+
 int overcommit_ratio_handler(struct ctl_table *table, int write,
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

