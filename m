From: akpm@linux-foundation.org
Subject: + powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value.patch added to -mm tree
Date: Wed, 13 Dec 2017 16:11:20 -0800
Message-ID: <5a31c1a8.cdyfItUsJm992AEI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdLNALW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: update pmdp_invalidate to return old pmd value
has been added to the -mm tree.  Its filename is
     powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory.patch
powerpc-mm-update-pmdp_invalidate-to-return-old-pmd-value.patch
mm-thp-remove-pmd_huge_split_prepare.patch

