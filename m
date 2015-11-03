From: akpm@linux-foundation.org
Subject: +
 mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch added to -mm tree
Date: Tue, 03 Nov 2015 15:05:20 -0800
Message-ID: <56393db0.aeY1M6F7WrHqzcXl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967AbbKCXFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2015 18:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hughd@google.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, sasha.levin@oracle.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prepare page_referenced() and page_idle to new THP refcounting
has been added to the -mm tree.  Its filename is
     mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

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
Subject: mm: prepare page_referenced() and page_idle to new THP refcounting

Both page_referenced() and page_idle_clear_pte_refs_one() assume that THP
can only be mapped with PMD, so there's no reason to look on PTEs for
PageTransHuge() pages.  That's no true anymore: THP can be mapped with
PTEs too.

The patch removes PageTransHuge() test from the functions and opencode
page table check.

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
 include/linux/mm.h      |   19 ++++++
 mm/huge_memory.c        |   54 -----------------
 mm/page_idle.c          |   64 +++++++++++++++++---
 mm/rmap.c               |  118 ++++++++++++++++++++++++++------------
 5 files changed, 156 insertions(+), 104 deletions(-)

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
@@ -433,6 +433,25 @@ static inline int page_mapcount(struct p
 	return ret;
 }
 
+static inline int total_mapcount(struct page *page)
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
 static inline int page_count(struct page *page)
 {
 	return atomic_read(&compound_head(page)->_count);
diff -puN mm/huge_memory.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting mm/huge_memory.c
--- a/mm/huge_memory.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/mm/huge_memory.c
@@ -1679,46 +1679,6 @@ bool __pmd_trans_huge_lock(pmd_t *pmd, s
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
@@ -3139,20 +3099,6 @@ static void unfreeze_page(struct anon_vm
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
diff -puN mm/page_idle.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting mm/page_idle.c
--- a/mm/page_idle.c~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting
+++ a/mm/page_idle.c
@@ -56,23 +56,69 @@ static int page_idle_clear_pte_refs_one(
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
+                if (!pmd_present(*pmd))
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
@@ -812,58 +812,104 @@ static int page_referenced_one(struct pa
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
-
-		/*
-		 * rmap might return false positives; we must filter
-		 * these out using page_check_address().
-		 */
-		pte = page_check_address(page, mm, address, &ptl, 0);
-		if (!pte)
+		pmd_t pmde = *pmd;
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
+		pte_unmap_unlock(pte, ptl);
+		return SWAP_AGAIN;
+	}
+
+	/* THP can be referenced by any subpage */
+	if (pte_pfn(*pte) - page_to_pfn(page) >= hpage_nr_pages(page)) {
 		pte_unmap_unlock(pte, ptl);
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
@@ -910,7 +956,7 @@ int page_referenced(struct page *page,
 	int ret;
 	int we_locked = 0;
 	struct page_referenced_arg pra = {
-		.mapcount = page_mapcount(page),
+		.mapcount = total_mapcount(page),
 		.memcg = memcg,
 	};
 	struct rmap_walk_control rwc = {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch

