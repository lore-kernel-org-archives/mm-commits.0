From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:32:18 -0800
Message-ID: <20180201193218.acIhwKi-5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753556AbeBATcT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: powerpc/mm: update pmdp_invalidate to return old pmd value
has been removed from the -mm tree.  Its filename was
     powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm: update pmdp_invalidate to return old pmd value

It's required to avoid losing dirty and accessed bits.

Link: http://lkml.kernel.org/r/20171213105756.69879-7-kirill.shutemov@linux.intel.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |    4 ++--
 arch/powerpc/mm/pgtable-book3s64.c           |    7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1137,8 +1137,8 @@ static inline pgtable_t pgtable_trans_hu
 }
 
 #define __HAVE_ARCH_PMDP_INVALIDATE
-extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
-			    pmd_t *pmdp);
+extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+			     pmd_t *pmdp);
 
 #define __HAVE_ARCH_PMDP_HUGE_SPLIT_PREPARE
 static inline void pmdp_huge_split_prepare(struct vm_area_struct *vma,
diff -puN arch/powerpc/mm/pgtable-book3s64.c~powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value arch/powerpc/mm/pgtable-book3s64.c
--- a/arch/powerpc/mm/pgtable-book3s64.c~powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value
+++ a/arch/powerpc/mm/pgtable-book3s64.c
@@ -90,16 +90,19 @@ void serialize_against_pte_lookup(struct
  * We use this to invalidate a pmdp entry before switching from a
  * hugepte to regular pmd entry.
  */
-void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, 0);
+	unsigned long old_pmd;
+
+	old_pmd = pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, 0);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	/*
 	 * This ensures that generic code that rely on IRQ disabling
 	 * to prevent a parallel THP split work as expected.
 	 */
 	serialize_against_pte_lookup(vma->vm_mm);
+	return __pmd(old_pmd);
 }
 
 static pmd_t pmd_set_protbits(pmd_t pmd, pgprot_t pgprot)
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


