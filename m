From: akpm@linux-foundation.org
Subject: + arm64-hugetlb-refactor-find_num_contig.patch added to -mm tree
Date: Wed, 24 May 2017 14:58:38 -0700
Message-ID: <5926020e.3WOhv6StUTcjUZNi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1036133AbdEXV6p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:58:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve.capper@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, dwoods@mellanox.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: hugetlb: refactor find_num_contig()
has been added to the -mm tree.  Its filename is
     arm64-hugetlb-refactor-find_num_contig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-hugetlb-refactor-find_num_contig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-hugetlb-refactor-find_num_contig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steve Capper <steve.capper@arm.com>
Subject: arm64: hugetlb: refactor find_num_contig()

Patch series "Support for contiguous pte hugepages", v4.

This patchset updates the hugetlb code to fix issues arising from
contiguous pte hugepages (such as on arm64).  Compared to v3, This version
addresses a build failure on arm64 by including two cleanup patches. 
Other than the arm64 cleanups, the rest are generic code changes.  The
remaining arm64 support based on these patches will be posted separately. 
The patches are based on v4.12-rc2.  Previous related postings can be
found at [0], [1], [2], and [3].

The patches fall into three categories -

* Patch 1-2 - arm64 cleanups required to greatly simplify changing
  huge_pte_offset() prototype in Patch 5.

  Catalin, Will - are you happy for these patches to go via mm?

* Patches 3-4 address issues with gup

* Patches 5-8 relate to passing a size argument to hugepage helpers to
  disambiguate the size of the referred page. These changes are
  required to enable arch code to properly handle swap entries for
  contiguous pte hugepages.

  The changes to huge_pte_offset() (patch 5) touch multiple
  architectures but I've managed to minimise these changes for the
  other affected functions - huge_pte_clear() and set_huge_pte_at().

These patches gate the enabling of contiguous hugepages support on arm64
which has been requested for systems using !4k page granule.


This patch (of 8):

As we regularly check for contiguous pte's in the huge accessors, remove
this extra check from find_num_contig.

[punit.agrawal@arm.com: resolve rebase conflicts due to patch re-ordering]
Link: http://lkml.kernel.org/r/20170524115409.31309-2-punit.agrawal@arm.com
Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: David Woods <dwoods@mellanox.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-refactor-find_num_contig arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-refactor-find_num_contig
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -42,15 +42,13 @@ int pud_huge(pud_t pud)
 }
 
 static int find_num_contig(struct mm_struct *mm, unsigned long addr,
-			   pte_t *ptep, pte_t pte, size_t *pgsize)
+			   pte_t *ptep, size_t *pgsize)
 {
 	pgd_t *pgd = pgd_offset(mm, addr);
 	pud_t *pud;
 	pmd_t *pmd;
 
 	*pgsize = PAGE_SIZE;
-	if (!pte_cont(pte))
-		return 1;
 	pud = pud_offset(pgd, addr);
 	pmd = pmd_offset(pud, addr);
 	if ((pte_t *)pmd == ptep) {
@@ -65,15 +63,16 @@ void set_huge_pte_at(struct mm_struct *m
 {
 	size_t pgsize;
 	int i;
-	int ncontig = find_num_contig(mm, addr, ptep, pte, &pgsize);
+	int ncontig;
 	unsigned long pfn;
 	pgprot_t hugeprot;
 
-	if (ncontig == 1) {
+	if (!pte_cont(pte)) {
 		set_pte_at(mm, addr, ptep, pte);
 		return;
 	}
 
+	ncontig = find_num_contig(mm, addr, ptep, &pgsize);
 	pfn = pte_pfn(pte);
 	hugeprot = __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
 	for (i = 0; i < ncontig; i++) {
@@ -197,7 +196,7 @@ pte_t huge_ptep_get_and_clear(struct mm_
 		bool is_dirty = false;
 
 		cpte = huge_pte_offset(mm, addr);
-		ncontig = find_num_contig(mm, addr, cpte, *cpte, &pgsize);
+		ncontig = find_num_contig(mm, addr, cpte, &pgsize);
 		/* save the 1st pte to return */
 		pte = ptep_get_and_clear(mm, addr, cpte);
 		for (i = 1, addr += pgsize; i < ncontig; ++i, addr += pgsize) {
@@ -237,7 +236,7 @@ int huge_ptep_set_access_flags(struct vm
 		cpte = huge_pte_offset(vma->vm_mm, addr);
 		pfn = pte_pfn(*cpte);
 		ncontig = find_num_contig(vma->vm_mm, addr, cpte,
-					  *cpte, &pgsize);
+					  &pgsize);
 		for (i = 0; i < ncontig; ++i, ++cpte, addr += pgsize) {
 			changed |= ptep_set_access_flags(vma, addr, cpte,
 							pfn_pte(pfn,
@@ -260,7 +259,7 @@ void huge_ptep_set_wrprotect(struct mm_s
 		size_t pgsize = 0;
 
 		cpte = huge_pte_offset(mm, addr);
-		ncontig = find_num_contig(mm, addr, cpte, *cpte, &pgsize);
+		ncontig = find_num_contig(mm, addr, cpte, &pgsize);
 		for (i = 0; i < ncontig; ++i, ++cpte, addr += pgsize)
 			ptep_set_wrprotect(mm, addr, cpte);
 	} else {
@@ -278,7 +277,7 @@ void huge_ptep_clear_flush(struct vm_are
 
 		cpte = huge_pte_offset(vma->vm_mm, addr);
 		ncontig = find_num_contig(vma->vm_mm, addr, cpte,
-					  *cpte, &pgsize);
+					  &pgsize);
 		for (i = 0; i < ncontig; ++i, ++cpte, addr += pgsize)
 			ptep_clear_flush(vma, addr, cpte);
 	} else {
_

Patches currently in -mm which might be from steve.capper@arm.com are

arm64-hugetlb-refactor-find_num_contig.patch
arm64-hugetlb-remove-spurious-calls-to-huge_ptep_offset.patch

