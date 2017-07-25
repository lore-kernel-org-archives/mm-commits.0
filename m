From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch
 added to -mm tree
Date: Tue, 25 Jul 2017 13:06:25 -0700
Message-ID: <5977a4c1.ZZ1Sn4TDZ/LWxJxu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42752 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753482AbdGYUG0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 16:06:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: punit.agrawal@arm.com, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make huge_pte_offset() consistent and document behaviour
has been added to the -mm tree.  Its filename is
     mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch

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
Subject: mm/hugetlb.c: make huge_pte_offset() consistent and document behaviour

When walking the page tables to resolve an address that points to
!p*d_present() entry, huge_pte_offset() returns inconsistent values
depending on the level of page table (PUD or PMD).

It returns NULL in the case of a PUD entry while in the case of a PMD
entry, it returns a pointer to the page table entry.

A similar inconsitency exists when handling swap entries - returns NULL
for a PUD entry while a pointer to the pte_t is retured for the PMD entry.

Update huge_pte_offset() to make the behaviour consistent - return NULL in
the case of p*d_none() and a pointer to the pte_t for hugepage or swap
entries.

Document the behaviour to clarify the expected behaviour of this function.
This is to set clear semantics for architecture specific implementations
of huge_pte_offset().

Link: http://lkml.kernel.org/r/20170725154114.24131-2-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour
+++ a/mm/hugetlb.c
@@ -4600,6 +4600,13 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
+/*
+ * huge_pte_offset() - Walk the page table to resolve the hugepage
+ * entry at address @addr
+ *
+ * Return: Pointer to page table or swap entry (PUD or PMD) for address @addr
+ * or NULL if the entry is p*d_none().
+ */
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz)
 {
@@ -4614,13 +4621,22 @@ pte_t *huge_pte_offset(struct mm_struct
 	p4d = p4d_offset(pgd, addr);
 	if (!p4d_present(*p4d))
 		return NULL;
+
 	pud = pud_offset(p4d, addr);
-	if (!pud_present(*pud))
+	if (pud_none(*pud))
 		return NULL;
-	if (pud_huge(*pud))
+	/* hugepage or swap? */
+	if (pud_huge(*pud) || !pud_present(*pud))
 		return (pte_t *)pud;
+
 	pmd = pmd_offset(pud, addr);
-	return (pte_t *) pmd;
+	if (pmd_none(*pmd))
+		return NULL;
+	/* hugepage or swap? */
+	if (pmd_huge(*pmd) || !pmd_present(*pmd))
+		return (pte_t *) pmd;
+
+	return NULL;
 }
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
_

Patches currently in -mm which might be from punit.agrawal@arm.com are

mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch

