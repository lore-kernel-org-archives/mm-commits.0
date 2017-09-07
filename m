From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:38:34 -0700
Message-ID: <20170907183834.Rh6WBA-KC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55686 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755660AbdIGSif (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, steve.capper@arm.com, will.deacon@arm.com


The patch titled
     Subject: mm/hugetlb.c: make huge_pte_offset() consistent and document behaviour
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Update huge_pte_offset() to make the behaviour consistent - return a
pointer to the pte_t for hugepage or swap entries.  Only return NULL in
instances where we have a p*d_none() entry and the size parameter doesn't
match the hugepage size at this level of the page table.

Document the behaviour to clarify the expected behaviour of this function.
This is to set clear semantics for architecture specific implementations
of huge_pte_offset().

Discussions on the arm64 implementation of huge_pte_offset()
(http://www.spinics.net/lists/linux-mm/msg133699.html) showed that there
is benefit from returning a pte_t* in the case of p*d_none().

The fault handling code in hugetlb_fault() can handle p*d_none() entries
and saves an extra round trip to huge_pte_alloc().  Other callers of
huge_pte_offset() should be ok as well.

[punit.agrawal@arm.com: v2]
Link: http://lkml.kernel.org/r/20170725154114.24131-2-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-make-huge_pte_offset-consistent-and-document-behaviour
+++ a/mm/hugetlb.c
@@ -4600,6 +4600,15 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
+/*
+ * huge_pte_offset() - Walk the page table to resolve the hugepage
+ * entry at address @addr
+ *
+ * Return: Pointer to page table or swap entry (PUD or PMD) for
+ * address @addr, or NULL if a p*d_none() entry is encountered and the
+ * size @sz doesn't match the hugepage size at this level of the page
+ * table.
+ */
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz)
 {
@@ -4614,13 +4623,22 @@ pte_t *huge_pte_offset(struct mm_struct
 	p4d = p4d_offset(pgd, addr);
 	if (!p4d_present(*p4d))
 		return NULL;
+
 	pud = pud_offset(p4d, addr);
-	if (!pud_present(*pud))
+	if (sz != PUD_SIZE && pud_none(*pud))
 		return NULL;
-	if (pud_huge(*pud))
+	/* hugepage or swap? */
+	if (pud_huge(*pud) || !pud_present(*pud))
 		return (pte_t *)pud;
+
 	pmd = pmd_offset(pud, addr);
-	return (pte_t *) pmd;
+	if (sz != PMD_SIZE && pmd_none(*pmd))
+		return NULL;
+	/* hugepage or swap? */
+	if (pmd_huge(*pmd) || !pmd_present(*pmd))
+		return (pte_t *)pmd;
+
+	return NULL;
 }
 
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
_

Patches currently in -mm which might be from punit.agrawal@arm.com are


