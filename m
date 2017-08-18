From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2.patch added to -mm tree
Date: Fri, 18 Aug 2017 14:25:06 -0700
Message-ID: <59975b32.XMm7thE7AHY7Le4t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbdHRVZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2017 17:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2
+++ a/mm/hugetlb.c
@@ -4604,8 +4604,10 @@ pte_t *huge_pte_alloc(struct mm_struct *
  * huge_pte_offset() - Walk the page table to resolve the hugepage
  * entry at address @addr
  *
- * Return: Pointer to page table or swap entry (PUD or PMD) for address @addr
- * or NULL if the entry is p*d_none().
+ * Return: Pointer to page table or swap entry (PUD or PMD) for
+ * address @addr, or NULL if a p*d_none() entry is encountered and the
+ * size @sz doesn't match the hugepage size at this level of the page
+ * table.
  */
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz)
@@ -4623,18 +4625,18 @@ pte_t *huge_pte_offset(struct mm_struct
 		return NULL;
 
 	pud = pud_offset(p4d, addr);
-	if (pud_none(*pud))
+	if (sz != PUD_SIZE && pud_none(*pud))
 		return NULL;
 	/* hugepage or swap? */
 	if (pud_huge(*pud) || !pud_present(*pud))
 		return (pte_t *)pud;
 
 	pmd = pmd_offset(pud, addr);
-	if (pmd_none(*pmd))
+	if (sz != PMD_SIZE && pmd_none(*pmd))
 		return NULL;
 	/* hugepage or swap? */
 	if (pmd_huge(*pmd) || !pmd_present(*pmd))
-		return (pte_t *) pmd;
+		return (pte_t *)pmd;
 
 	return NULL;
 }
_

Patches currently in -mm which might be from punit.agrawal@arm.com are

mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch
mm-hugetlbc-make-huge_pte_offset-consistent-and-document-behaviour-v2.patch

