From: akpm@linux-foundation.org
Subject: + s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages.patch
 added to -mm tree
Date: Thu, 28 May 2015 13:35:09 -0700
Message-ID: <55677bfd.POvSdzQ0dd4uGk8h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbbE1UfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 16:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/hugetlb: remove dead code for sw emulated huge pages
has been added to the -mm tree.  Its filename is
     s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: s390/hugetlb: remove dead code for sw emulated huge pages

We now support only hugepages on hardware with EDAT1 support.  So we
remove the prepare/release_hugepage hooks and simplify set_huge_pte_at and
huge_ptep_get.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |    3 -
 arch/s390/mm/hugetlbpage.c      |   60 +-----------------------------
 2 files changed, 3 insertions(+), 60 deletions(-)

diff -puN arch/s390/include/asm/hugetlb.h~s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages
+++ a/arch/s390/include/asm/hugetlb.h
@@ -37,9 +37,6 @@ static inline int prepare_hugepage_range
 
 #define arch_clear_hugepage_flags(page)		do { } while (0)
 
-int arch_prepare_hugepage(struct page *page);
-void arch_release_hugepage(struct page *page);
-
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 				  pte_t *ptep)
 {
diff -puN arch/s390/mm/hugetlbpage.c~s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~s390-hugetlb-remove-dead-code-for-sw-emulated-huge-pages
+++ a/arch/s390/mm/hugetlbpage.c
@@ -86,31 +86,16 @@ static inline pte_t __pmd_to_pte(pmd_t p
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte)
 {
-	pmd_t pmd;
+	pmd_t pmd = __pte_to_pmd(pte);
 
-	pmd = __pte_to_pmd(pte);
-	if (!MACHINE_HAS_HPAGE) {
-		/* Emulated huge ptes loose the dirty and young bit */
-		pmd_val(pmd) &= ~_SEGMENT_ENTRY_ORIGIN;
-		pmd_val(pmd) |= pte_page(pte)[1].index;
-	} else
-		pmd_val(pmd) |= _SEGMENT_ENTRY_LARGE;
+	pmd_val(pmd) |= _SEGMENT_ENTRY_LARGE;
 	*(pmd_t *) ptep = pmd;
 }
 
 pte_t huge_ptep_get(pte_t *ptep)
 {
-	unsigned long origin;
-	pmd_t pmd;
+	pmd_t pmd = *(pmd_t *) ptep;
 
-	pmd = *(pmd_t *) ptep;
-	if (!MACHINE_HAS_HPAGE && pmd_present(pmd)) {
-		origin = pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN;
-		pmd_val(pmd) &= ~_SEGMENT_ENTRY_ORIGIN;
-		pmd_val(pmd) |= *(unsigned long *) origin;
-		/* Emulated huge ptes are young and dirty by definition */
-		pmd_val(pmd) |= _SEGMENT_ENTRY_YOUNG | _SEGMENT_ENTRY_DIRTY;
-	}
 	return __pmd_to_pte(pmd);
 }
 
@@ -125,45 +110,6 @@ pte_t huge_ptep_get_and_clear(struct mm_
 	return pte;
 }
 
-int arch_prepare_hugepage(struct page *page)
-{
-	unsigned long addr = page_to_phys(page);
-	pte_t pte;
-	pte_t *ptep;
-	int i;
-
-	if (MACHINE_HAS_HPAGE)
-		return 0;
-
-	ptep = (pte_t *) pte_alloc_one(&init_mm, addr);
-	if (!ptep)
-		return -ENOMEM;
-
-	pte_val(pte) = addr;
-	for (i = 0; i < PTRS_PER_PTE; i++) {
-		set_pte_at(&init_mm, addr + i * PAGE_SIZE, ptep + i, pte);
-		pte_val(pte) += PAGE_SIZE;
-	}
-	page[1].index = (unsigned long) ptep;
-	return 0;
-}
-
-void arch_release_hugepage(struct page *page)
-{
-	pte_t *ptep;
-
-	if (MACHINE_HAS_HPAGE)
-		return;
-
-	ptep = (pte_t *) page[1].index;
-	if (!ptep)
-		return;
-	clear_table((unsigned long *) ptep, _PAGE_INVALID,
-		    PTRS_PER_PTE * sizeof(pte_t));
-	page_table_free(&init_mm, (unsigned long *) ptep);
-	page[1].index = 0;
-}
