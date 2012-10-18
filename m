From: akpm@linux-foundation.org
Subject: + thp-introduce-hugepage_get_pmd.patch added to -mm tree
Date: Thu, 18 Oct 2012 13:10:38 -0700
Message-ID: <20121018201038.95EE8100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56459 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2JRUKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 16:10:39 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so1123266qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 13:10:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, aarcange@redhat.com, mhocko@suse.cz, minchan.kim@gmail.com


The patch titled
     Subject: thp: introduce hugepage_get_pmd()
has been added to the -mm tree.  Its filename is
     thp-introduce-hugepage_get_pmd.patch

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
Subject: thp: introduce hugepage_get_pmd()

Introduce hugepage_get_pmd() to simple code.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   68 +++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 41 deletions(-)

diff -puN mm/huge_memory.c~thp-introduce-hugepage_get_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-hugepage_get_pmd
+++ a/mm/huge_memory.c
@@ -1185,6 +1185,25 @@ int change_huge_pmd(struct vm_area_struc
 	return ret;
 }
 
+static pmd_t *hugepage_get_pmd(struct mm_struct *mm, unsigned long address)
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
+out:
+	return pmd;
+}
+
 /*
  * Returns 1 if a given pmd maps a stable (not under splitting) thp.
  * Returns -1 if it maps a thp under splitting. Returns 0 otherwise.
@@ -1215,22 +1234,14 @@ pmd_t *page_check_address_pmd(struct pag
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
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
 		goto out;
 	if (pmd_page(*pmd) != page)
@@ -1975,8 +1986,6 @@ static void collapse_huge_page(struct mm
 				   struct vm_area_struct *vma,
 				   int node)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd, _pmd;
 	pte_t *pte;
 	pgtable_t pgtable;
@@ -2022,16 +2031,9 @@ static void collapse_huge_page(struct mm
 		goto out;
 	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
-	/* pmd can't go away or become huge under us */
 	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
 		goto out;
 
@@ -2115,8 +2117,6 @@ static int khugepaged_scan_pmd(struct mm
 			       unsigned long address,
 			       struct page **hpage)
 {
-	pgd_t *pgd;
-	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
 	int ret = 0, referenced = 0, none = 0;
@@ -2127,15 +2127,9 @@ static int khugepaged_scan_pmd(struct mm
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
-	pgd = pgd_offset(mm, address);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, address);
-	if (!pud_present(*pud))
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		goto out;
-
-	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
 		goto out;
 
@@ -2428,21 +2422,13 @@ void __split_huge_page_pmd(struct mm_str
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
+	pmd = hugepage_get_pmd(mm, address);
+	if (!pmd)
 		return;
