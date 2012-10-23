From: akpm@linux-foundation.org
Subject: + mm-introduce-mm_find_pmd.patch added to -mm tree
Date: Tue, 23 Oct 2012 14:14:24 -0700
Message-ID: <20121023211425.1987220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36910 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655Ab2JWVO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 17:14:28 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so258917wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 14:14:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com, nizhan.chen@gmail.com


The patch titled
     Subject: mm: introduce mm_find_pmd()
has been added to the -mm tree.  Its filename is
     mm-introduce-mm_find_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: mm: introduce mm_find_pmd()

Several place need to find the pmd by(mm_struct, address), so introduce a
function to simplify it.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   55 ++++++++-------------------------------------
 mm/internal.h    |    5 ++++
 mm/ksm.c         |   14 +----------
 mm/migrate.c     |   14 +----------
 mm/rmap.c        |   46 ++++++++++++++++++++-----------------
 5 files changed, 44 insertions(+), 90 deletions(-)

diff -puN mm/huge_memory.c~mm-introduce-mm_find_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~mm-introduce-mm_find_pmd
+++ a/mm/huge_memory.c
@@ -1299,22 +1299,14 @@ pmd_t *page_check_address_pmd(struct pag
 			      unsigned long address,
 			      enum page_check_address_pmd_flag flag)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd, *ret = NULL;
 
 	if (address & ~HPAGE_PMD_MASK)
 		goto out;
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = mm_find_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		goto out;
 	if (pmd_page(*pmd) != page)
@@ -2059,8 +2051,6 @@ static void collapse_huge_page(struct mm
 				   struct vm_area_struct *vma,
 				   int node)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
 	pgtable_t pgtable;
@@ -2106,17 +2096,10 @@ static void collapse_huge_page(struct mm
 		goto out;
 	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = mm_find_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
-	/* pmd can't go away or become huge under us */
-	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd))
 		goto out;
 
 	anon_vma_lock(vma->anon_vma);
@@ -2199,8 +2182,6 @@ static int khugepaged_scan_pmd(struct mm
 			       unsigned long address,
 			       struct page **hpage)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int ret = 0, referenced = 0, none = 0;
@@ -2211,16 +2192,10 @@ static int khugepaged_scan_pmd(struct mm
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = mm_find_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd))
 		goto out;
 
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
@@ -2512,22 +2487,12 @@ void __split_huge_page_pmd(struct mm_str
 static void split_huge_page_address(struct mm_struct *mm,
 				    unsigned long address)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 
 	VM_BUG_ON(!(address & ~HPAGE_PMD_MASK));
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		return;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
-		return;
-
-	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
+	pmd = mm_find_pmd(mm, address);
+	if (!pmd)
 		return;
 	/*
 	 * Caller holds the mmap_sem write mode, so a huge pmd cannot
diff -puN mm/internal.h~mm-introduce-mm_find_pmd mm/internal.h
--- a/mm/internal.h~mm-introduce-mm_find_pmd
+++ a/mm/internal.h
@@ -92,6 +92,11 @@ extern int isolate_lru_page(struct page 
 extern void putback_lru_page(struct page *page);
 
 /*
+ * in mm/rmap.c:
+ */
+extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
+
+/*
  * in mm/page_alloc.c
  */
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
diff -puN mm/ksm.c~mm-introduce-mm_find_pmd mm/ksm.c
--- a/mm/ksm.c~mm-introduce-mm_find_pmd
+++ a/mm/ksm.c
@@ -778,8 +778,6 @@ static int replace_page(struct vm_area_s
 			struct page *kpage, pte_t orig_pte)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *ptep;
 	spinlock_t *ptl;
@@ -792,18 +790,10 @@ static int replace_page(struct vm_area_s
 	if (addr == -EFAULT)
 		goto out;
 
-	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
+	pmd = mm_find_pmd(mm, addr);
+	if (!pmd)
 		goto out;
-
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		goto out;
-
-	pmd = pmd_offset(pud, addr);
 	BUG_ON(pmd_trans_huge(*pmd));
-	if (!pmd_present(*pmd))
-		goto out;
 
 	mmun_start = addr;
 	mmun_end   = addr + PAGE_SIZE;
diff -puN mm/migrate.c~mm-introduce-mm_find_pmd mm/migrate.c
--- a/mm/migrate.c~mm-introduce-mm_find_pmd
+++ a/mm/migrate.c
@@ -91,8 +91,6 @@ static int remove_migration_pte(struct p
 {
 	struct mm_struct *mm = vma->vm_mm;
 	swp_entry_t entry;
- 	pgd_t *pgd;
- 	pud_t *pud;
  	pmd_t *pmd;
 	pte_t *ptep, pte;
  	spinlock_t *ptl;
@@ -103,19 +101,11 @@ static int remove_migration_pte(struct p
 			goto out;
 		ptl = &mm->page_table_lock;
 	} else {
-		pgd = pgd_offset(mm, addr);
-		if (!pgd_present(*pgd))
+		pmd = mm_find_pmd(mm, addr);
+		if (!pmd)
 			goto out;
-
-		pud = pud_offset(pgd, addr);
-		if (!pud_present(*pud))
-			goto out;
-
-		pmd = pmd_offset(pud, addr);
 		if (pmd_trans_huge(*pmd))
 			goto out;
-		if (!pmd_present(*pmd))
-			goto out;
 
 		ptep = pte_offset_map(pmd, addr);
 
diff -puN mm/rmap.c~mm-introduce-mm_find_pmd mm/rmap.c
--- a/mm/rmap.c~mm-introduce-mm_find_pmd
+++ a/mm/rmap.c
@@ -562,6 +562,27 @@ unsigned long page_address_in_vma(struct
 	return address;
 }
 
+pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd = NULL;
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	pud = pud_offset(pgd, address);
+	if (!pud_present(*pud))
+		goto out;
+
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		pmd = NULL;
+out:
+	return pmd;
+}
+
 /*
  * Check that @page is mapped at @address into @mm.
  *
@@ -574,8 +595,6 @@ unsigned long page_address_in_vma(struct
 pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
 			  unsigned long address, spinlock_t **ptlp, int sync)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	spinlock_t *ptl;
@@ -586,17 +605,10 @@ pte_t *__page_check_address(struct page 
 		goto check;
 	}
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		return NULL;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = mm_find_pmd(mm, address);
+	if (!pmd)
 		return NULL;
 
-	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
-		return NULL;
 	if (pmd_trans_huge(*pmd))
 		return NULL;
 
@@ -1366,16 +1378,8 @@ static int try_to_unmap_cluster(unsigned
 	if (end > vma->vm_end)
 		end = vma->vm_end;
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		return ret;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
-		return ret;
