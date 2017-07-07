From: akpm@linux-foundation.org
Subject: [merged]
 arm64-hugetlb-remove-spurious-calls-to-huge_ptep_offset.patch removed from
 -mm tree
Date: Fri, 07 Jul 2017 12:10:26 -0700
Message-ID: <20170707191026.bRrRQc1Zz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbdGGTKv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, dwoods@mellanox.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, steve.capper@arm.com


The patch titled
     Subject: arm64: hugetlb: remove spurious calls to huge_ptep_offset()
has been removed from the -mm tree.  Its filename was
     arm64-hugetlb-remove-spurious-calls-to-huge_ptep_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steve Capper <steve.capper@arm.com>
Subject: arm64: hugetlb: remove spurious calls to huge_ptep_offset()

We don't need to call huge_ptep_offset as our accessors are already
supplied with the pte_t *.  This patch removes those spurious calls.

[punit.agrawal@arm.com: resolve rebase conflicts due to patch re-ordering]
Link: http://lkml.kernel.org/r/20170524115409.31309-3-punit.agrawal@arm.com
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

 arch/arm64/mm/hugetlbpage.c |   37 ++++++++++++----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff -puN arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-remove-spurious-calls-to-huge_ptep_offset arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~arm64-hugetlb-remove-spurious-calls-to-huge_ptep_offset
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -183,21 +183,19 @@ pte_t huge_ptep_get_and_clear(struct mm_
 	if (pte_cont(*ptep)) {
 		int ncontig, i;
 		size_t pgsize;
-		pte_t *cpte;
 		bool is_dirty = false;
 
-		cpte = huge_pte_offset(mm, addr);
-		ncontig = find_num_contig(mm, addr, cpte, &pgsize);
+		ncontig = find_num_contig(mm, addr, ptep, &pgsize);
 		/* save the 1st pte to return */
-		pte = ptep_get_and_clear(mm, addr, cpte);
+		pte = ptep_get_and_clear(mm, addr, ptep);
 		for (i = 1, addr += pgsize; i < ncontig; ++i, addr += pgsize) {
 			/*
 			 * If HW_AFDBM is enabled, then the HW could
 			 * turn on the dirty bit for any of the page
 			 * in the set, so check them all.
 			 */
-			++cpte;
-			if (pte_dirty(ptep_get_and_clear(mm, addr, cpte)))
+			++ptep;
+			if (pte_dirty(ptep_get_and_clear(mm, addr, ptep)))
 				is_dirty = true;
 		}
 		if (is_dirty)
@@ -213,8 +211,6 @@ int huge_ptep_set_access_flags(struct vm
 			       unsigned long addr, pte_t *ptep,
 			       pte_t pte, int dirty)
 {
-	pte_t *cpte;
-
 	if (pte_cont(pte)) {
 		int ncontig, i, changed = 0;
 		size_t pgsize = 0;
@@ -224,12 +220,11 @@ int huge_ptep_set_access_flags(struct vm
 			__pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^
 				 pte_val(pte));
 
-		cpte = huge_pte_offset(vma->vm_mm, addr);
-		pfn = pte_pfn(*cpte);
-		ncontig = find_num_contig(vma->vm_mm, addr, cpte,
+		pfn = pte_pfn(pte);
+		ncontig = find_num_contig(vma->vm_mm, addr, ptep,
 					  &pgsize);
-		for (i = 0; i < ncontig; ++i, ++cpte, addr += pgsize) {
-			changed |= ptep_set_access_flags(vma, addr, cpte,
+		for (i = 0; i < ncontig; ++i, ++ptep, addr += pgsize) {
+			changed |= ptep_set_access_flags(vma, addr, ptep,
 							pfn_pte(pfn,
 								hugeprot),
 							dirty);
@@ -246,13 +241,11 @@ void huge_ptep_set_wrprotect(struct mm_s
 {
 	if (pte_cont(*ptep)) {
 		int ncontig, i;
-		pte_t *cpte;
 		size_t pgsize = 0;
 
-		cpte = huge_pte_offset(mm, addr);
-		ncontig = find_num_contig(mm, addr, cpte, &pgsize);
-		for (i = 0; i < ncontig; ++i, ++cpte, addr += pgsize)
-			ptep_set_wrprotect(mm, addr, cpte);
+		ncontig = find_num_contig(mm, addr, ptep, &pgsize);
+		for (i = 0; i < ncontig; ++i, ++ptep, addr += pgsize)
+			ptep_set_wrprotect(mm, addr, ptep);
 	} else {
 		ptep_set_wrprotect(mm, addr, ptep);
 	}
@@ -263,14 +256,12 @@ void huge_ptep_clear_flush(struct vm_are
 {
 	if (pte_cont(*ptep)) {
 		int ncontig, i;
-		pte_t *cpte;
 		size_t pgsize = 0;
 
-		cpte = huge_pte_offset(vma->vm_mm, addr);
-		ncontig = find_num_contig(vma->vm_mm, addr, cpte,
+		ncontig = find_num_contig(vma->vm_mm, addr, ptep,
 					  &pgsize);
-		for (i = 0; i < ncontig; ++i, ++cpte, addr += pgsize)
-			ptep_clear_flush(vma, addr, cpte);
+		for (i = 0; i < ncontig; ++i, ++ptep, addr += pgsize)
+			ptep_clear_flush(vma, addr, ptep);
 	} else {
 		ptep_clear_flush(vma, addr, ptep);
 	}
_

Patches currently in -mm which might be from steve.capper@arm.com are


