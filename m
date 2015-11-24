From: akpm@linux-foundation.org
Subject: + mm-add-page_check_address_transhuge-helper.patch added to -mm
 tree
Date: Mon, 23 Nov 2015 16:10:51 -0800
Message-ID: <5653ab0b.O8qnMWMxuE9IF1aN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbKXAKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 19:10:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add page_check_address_transhuge() helper
has been added to the -mm tree.  Its filename is
     mm-add-page_check_address_transhuge-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-page_check_address_transhuge-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-page_check_address_transhuge-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: add page_check_address_transhuge() helper

page_referenced_one() and page_idle_clear_pte_refs_one() duplicate the
code for looking up pte of a (possibly transhuge) page.  Move this code to
a new helper function, page_check_address_transhuge(), and make the above
mentioned functions use it.

This is just a cleanup, no functional changes are intended.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    8 ++
 mm/page_idle.c       |   63 ++---------------------
 mm/rmap.c            |  110 ++++++++++++++++++++++++-----------------
 3 files changed, 81 insertions(+), 100 deletions(-)

diff -puN include/linux/rmap.h~mm-add-page_check_address_transhuge-helper include/linux/rmap.h
--- a/include/linux/rmap.h~mm-add-page_check_address_transhuge-helper
+++ a/include/linux/rmap.h
@@ -216,6 +216,14 @@ static inline pte_t *page_check_address(
 }
 
 /*
+ * Used by idle page tracking to check if a page was referenced via page
+ * tables.
+ */
+bool page_check_address_transhuge(struct page *page, struct mm_struct *mm,
+				  unsigned long address, pmd_t **pmdp,
+				  pte_t **ptep, spinlock_t **ptlp);
+
+/*
  * Used by swapoff to help locate where page is expected in vma.
  */
 unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
diff -puN mm/page_idle.c~mm-add-page_check_address_transhuge-helper mm/page_idle.c
--- a/mm/page_idle.c~mm-add-page_check_address_transhuge-helper
+++ a/mm/page_idle.c
@@ -55,71 +55,22 @@ static int page_idle_clear_pte_refs_one(
 					unsigned long addr, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	spinlock_t *ptl;
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	spinlock_t *ptl;
 	bool referenced = false;
 
-	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
-		return SWAP_AGAIN;
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		return SWAP_AGAIN;
-	pmd = pmd_offset(pud, addr);
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
-		referenced = pmdp_clear_young_notify(vma, addr, pmd);
-		spin_unlock(ptl);
-		goto found;
-unlock_pmd:
-		spin_unlock(ptl);
+	if (!page_check_address_transhuge(page, mm, addr, &pmd, &pte, &ptl))
 		return SWAP_AGAIN;
-	} else {
-		pmd_t pmde = *pmd;
 
-		barrier();
-		if (!pmd_present(pmde) || pmd_trans_huge(pmde))
-			return SWAP_AGAIN;
-
-	}
-map_pte:
-	pte = pte_offset_map(pmd, addr);
-	if (!pte_present(*pte)) {
+	if (pte) {
+		referenced = ptep_clear_young_notify(vma, addr, pte);
 		pte_unmap(pte);
-		return SWAP_AGAIN;
-	}
-
-	ptl = pte_lockptr(mm, pmd);
-	spin_lock(ptl);
-
-	if (!pte_present(*pte)) {
-		pte_unmap_unlock(pte, ptl);
-		return SWAP_AGAIN;
-	}
+	} else
+		referenced = pmdp_clear_young_notify(vma, addr, pmd);
 
-	/* THP can be referenced by any subpage */
-	if (pte_pfn(*pte) - page_to_pfn(page) >= hpage_nr_pages(page)) {
-		pte_unmap_unlock(pte, ptl);
-		return SWAP_AGAIN;
-	}
+	spin_unlock(ptl);
 
-	referenced = ptep_clear_young_notify(vma, addr, pte);
-	pte_unmap_unlock(pte, ptl);
-found:
 	if (referenced) {
 		clear_page_idle(page);
 		/*
diff -puN mm/rmap.c~mm-add-page_check_address_transhuge-helper mm/rmap.c
--- a/mm/rmap.c~mm-add-page_check_address_transhuge-helper
+++ a/mm/rmap.c
@@ -798,48 +798,43 @@ int page_mapped_in_vma(struct page *page
 	return 1;
 }
 
-struct page_referenced_arg {
-	int mapcount;
-	int referenced;
-	unsigned long vm_flags;
-	struct mem_cgroup *memcg;
-};
 /*
- * arg: page_referenced_arg will be passed
+ * Check that @page is mapped at @address into @mm. In contrast to
+ * page_check_address(), this function can handle transparent huge pages.
+ *
+ * On success returns true with pte mapped and locked. For PMD-mapped
+ * transparent huge pages *@ptep is set to NULL.
  */
-static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
-			unsigned long address, void *arg)
+bool page_check_address_transhuge(struct page *page, struct mm_struct *mm,
+				  unsigned long address, pmd_t **pmdp,
+				  pte_t **ptep, spinlock_t **ptlp)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	spinlock_t *ptl;
-	int referenced = 0;
-	struct page_referenced_arg *pra = arg;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	spinlock_t *ptl;
 
 	if (unlikely(PageHuge(page))) {
 		/* when pud is not present, pte will be NULL */
 		pte = huge_pte_offset(mm, address);
 		if (!pte)
-			return SWAP_AGAIN;
+			return false;
 
 		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
+		pmd = NULL;
 		goto check_pte;
 	}
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
-		return SWAP_AGAIN;
+		return false;
 	pud = pud_offset(pgd, address);
 	if (!pud_present(*pud))
-		return SWAP_AGAIN;
+		return false;
 	pmd = pmd_offset(pud, address);
 
 	if (pmd_trans_huge(*pmd)) {
-		int ret = SWAP_AGAIN;
-
 		ptl = pmd_lock(mm, pmd);
 		if (!pmd_present(*pmd))
 			goto unlock_pmd;
@@ -851,31 +846,23 @@ static int page_referenced_one(struct pa
 		if (pmd_page(*pmd) != page)
 			goto unlock_pmd;
 
-		if (vma->vm_flags & VM_LOCKED) {
-			pra->vm_flags |= VM_LOCKED;
-			ret = SWAP_FAIL; /* To break the loop */
-			goto unlock_pmd;
-		}
-
-		if (pmdp_clear_flush_young_notify(vma, address, pmd))
-			referenced++;
-		spin_unlock(ptl);
+		pte = NULL;
 		goto found;
 unlock_pmd:
 		spin_unlock(ptl);
-		return ret;
+		return false;
 	} else {
 		pmd_t pmde = *pmd;
 
 		barrier();
 		if (!pmd_present(pmde) || pmd_trans_huge(pmde))
-			return SWAP_AGAIN;
+			return false;
 	}
 map_pte:
 	pte = pte_offset_map(pmd, address);
 	if (!pte_present(*pte)) {
 		pte_unmap(pte);
-		return SWAP_AGAIN;
+		return false;
 	}
 
 	ptl = pte_lockptr(mm, pmd);
@@ -884,35 +871,70 @@ check_pte:
 
 	if (!pte_present(*pte)) {
 		pte_unmap_unlock(pte, ptl);
-		return SWAP_AGAIN;
+		return false;
 	}
 
 	/* THP can be referenced by any subpage */
 	if (pte_pfn(*pte) - page_to_pfn(page) >= hpage_nr_pages(page)) {
 		pte_unmap_unlock(pte, ptl);
-		return SWAP_AGAIN;
+		return false;
 	}
+found:
+	*ptep = pte;
+	*pmdp = pmd;
+	*ptlp = ptl;
+	return true;
+}
+
+struct page_referenced_arg {
+	int mapcount;
+	int referenced;
+	unsigned long vm_flags;
+	struct mem_cgroup *memcg;
+};
+/*
+ * arg: page_referenced_arg will be passed
+ */
+static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
+			unsigned long address, void *arg)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page_referenced_arg *pra = arg;
+	pmd_t *pmd;
+	pte_t *pte;
+	spinlock_t *ptl;
+	int referenced = 0;
+
+	if (!page_check_address_transhuge(page, mm, address, &pmd, &pte, &ptl))
+		return SWAP_AGAIN;
 
 	if (vma->vm_flags & VM_LOCKED) {
-		pte_unmap_unlock(pte, ptl);
+		if (pte)
+			pte_unmap(pte);
+		spin_unlock(ptl);
 		pra->vm_flags |= VM_LOCKED;
 		return SWAP_FAIL; /* To break the loop */
 	}
 
-	if (ptep_clear_flush_young_notify(vma, address, pte)) {
-		/*
-		 * Don't treat a reference through a sequentially read
-		 * mapping as such.  If the page has been used in
-		 * another mapping, we will catch it; if this other
-		 * mapping is already gone, the unmap path will have
-		 * set PG_referenced or activated the page.
-		 */
-		if (likely(!(vma->vm_flags & VM_SEQ_READ)))
+	if (pte) {
+		if (ptep_clear_flush_young_notify(vma, address, pte)) {
+			/*
+			 * Don't treat a reference through a sequentially read
+			 * mapping as such.  If the page has been used in
+			 * another mapping, we will catch it; if this other
+			 * mapping is already gone, the unmap path will have
+			 * set PG_referenced or activated the page.
+			 */
+			if (likely(!(vma->vm_flags & VM_SEQ_READ)))
+				referenced++;
+		}
+		pte_unmap(pte);
+	} else {
+		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
 	}
-	pte_unmap_unlock(pte, ptl);
+	spin_unlock(ptl);
 
-found:
 	if (referenced)
 		clear_page_idle(page);
 	if (test_and_clear_page_young(page))
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

memcg-fix-memoryhigh-target.patch
revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch

