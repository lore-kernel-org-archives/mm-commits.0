From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-allow-architectures-to-override-huge_pte_clear.patch removed
 from -mm tree
Date: Fri, 07 Jul 2017 12:10:39 -0700
Message-ID: <20170707191039.IXBxC_-x8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdGGTKz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, arnd@arndb.de, catalin.marinas@arm.com, heiko.carstens@de.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, schwidefsky@de.ibm.com, steve.capper@arm.com, will.deacon@arm.com


The patch titled
     Subject: mm/hugetlb: allow architectures to override huge_pte_clear()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-allow-architectures-to-override-huge_pte_clear.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm/hugetlb: allow architectures to override huge_pte_clear()

When unmapping a hugepage range, huge_pte_clear() is used to clear the
page table entries that are marked as not present.  huge_pte_clear()
internally just ends up calling pte_clear() which does not correctly deal
with hugepages consisting of contiguous page table entries.

Add a size argument to address this issue and allow architectures to
override huge_pte_clear() by wrapping it in a #ifndef block.

Update s390 implementation with the size parameter as well.

Note that the change only affects huge_pte_clear() - the other generic
hugetlb functions don't need any change.

Link: http://lkml.kernel.org/r/20170522162555.4313-1-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>	[s390 bits]
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/hugetlb.h |    2 +-
 include/asm-generic/hugetlb.h   |    4 +++-
 mm/hugetlb.c                    |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/s390/include/asm/hugetlb.h~mm-hugetlb-allow-architectures-to-override-huge_pte_clear arch/s390/include/asm/hugetlb.h
--- a/arch/s390/include/asm/hugetlb.h~mm-hugetlb-allow-architectures-to-override-huge_pte_clear
+++ a/arch/s390/include/asm/hugetlb.h
@@ -39,7 +39,7 @@ static inline int prepare_hugepage_range
 #define arch_clear_hugepage_flags(page)		do { } while (0)
 
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
-				  pte_t *ptep)
+				  pte_t *ptep, unsigned long sz)
 {
 	if ((pte_val(*ptep) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3)
 		pte_val(*ptep) = _REGION3_ENTRY_EMPTY;
diff -puN include/asm-generic/hugetlb.h~mm-hugetlb-allow-architectures-to-override-huge_pte_clear include/asm-generic/hugetlb.h
--- a/include/asm-generic/hugetlb.h~mm-hugetlb-allow-architectures-to-override-huge_pte_clear
+++ a/include/asm-generic/hugetlb.h
@@ -31,10 +31,12 @@ static inline pte_t huge_pte_modify(pte_
 	return pte_modify(pte, newprot);
 }
 
+#ifndef huge_pte_clear
 static inline void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
-				  pte_t *ptep)
+		    pte_t *ptep, unsigned long sz)
 {
 	pte_clear(mm, addr, ptep);
 }
+#endif
 
 #endif /* _ASM_GENERIC_HUGETLB_H */
diff -puN mm/hugetlb.c~mm-hugetlb-allow-architectures-to-override-huge_pte_clear mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-allow-architectures-to-override-huge_pte_clear
+++ a/mm/hugetlb.c
@@ -3351,7 +3351,7 @@ void __unmap_hugepage_range(struct mmu_g
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
-			huge_pte_clear(mm, address, ptep);
+			huge_pte_clear(mm, address, ptep, sz);
 			spin_unlock(ptl);
 			continue;
 		}
_

Patches currently in -mm which might be from punit.agrawal@arm.com are


