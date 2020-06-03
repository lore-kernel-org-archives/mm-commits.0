From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch removed from -mm
 tree
Date: Wed, 03 Jun 2020 15:22:53 -0700
Message-ID: <20200603222253.hQv_PO3s9%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgFCWWz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:22:55 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, catalin.marinas@arm.com, mm-commits@vger.kernel.org, will@kernel.org


The patch titled
     Subject: mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
has been removed from the -mm tree.  Its filename was
     mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2.patch

This patch was dropped because it was folded into mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2

chang pmd_mknotvalid() to pmd_mkinvalid() per Will

Link: http://lkml.kernel.org/r/1587520326-10099-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/hugepage.h       |    2 +-
 arch/arm/include/asm/pgtable-3level.h |    2 +-
 arch/arm64/include/asm/pgtable.h      |    2 +-
 arch/mips/include/asm/pgtable.h       |    2 +-
 arch/x86/include/asm/pgtable.h        |    2 +-
 arch/x86/mm/kmmio.c                   |    2 +-
 mm/pgtable-generic.c                  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/arc/include/asm/hugepage.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
+++ a/arch/arc/include/asm/hugepage.h
@@ -26,7 +26,7 @@ static inline pmd_t pte_pmd(pte_t pte)
 #define pmd_mkold(pmd)		pte_pmd(pte_mkold(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkhuge(pmd)		pte_pmd(pte_mkhuge(pmd_pte(pmd)))
-#define pmd_mknotvalid(pmd)	pte_pmd(pte_mknotpresent(pmd_pte(pmd)))
+#define pmd_mkinvalid(pmd)	pte_pmd(pte_mknotpresent(pmd_pte(pmd)))
 #define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
--- a/arch/arm64/include/asm/pgtable.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
+++ a/arch/arm64/include/asm/pgtable.h
@@ -366,7 +366,7 @@ static inline int pmd_protnone(pmd_t pmd
 #define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 #define pmd_mkdirty(pmd)	pte_pmd(pte_mkdirty(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
-#define pmd_mknotvalid(pmd)	(__pmd(pmd_val(pmd) & ~PMD_SECT_VALID))
+#define pmd_mkinvalid(pmd)	(__pmd(pmd_val(pmd) & ~PMD_SECT_VALID))
 
 #define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
 
--- a/arch/arm/include/asm/pgtable-3level.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -221,7 +221,7 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 #define pmdp_establish generic_pmdp_establish
 
 /* represent a notpresent pmd by faulting entry, this is used by pmdp_invalidate */
-static inline pmd_t pmd_mknotvalid(pmd_t pmd)
+static inline pmd_t pmd_mkinvalid(pmd_t pmd)
 {
 	return __pmd(pmd_val(pmd) & ~L_PMD_SECT_VALID);
 }
--- a/arch/mips/include/asm/pgtable.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
+++ a/arch/mips/include/asm/pgtable.h
@@ -631,7 +631,7 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	return pmd;
 }
 
-static inline pmd_t pmd_mknotvalid(pmd_t pmd)
+static inline pmd_t pmd_mkinvalid(pmd_t pmd)
 {
 	pmd_val(pmd) &= ~(_PAGE_PRESENT | _PAGE_VALID | _PAGE_DIRTY);
 
--- a/arch/x86/include/asm/pgtable.h~mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
+++ a/arch/x86/include/asm/pgtable.h
@@ -624,7 +624,7 @@ static inline pud_t pfn_pud(unsigned lon
 	return __pud(pfn | check_pgprot(pgprot));
 }
 
-static inline pmd_t pmd_mknotvalid(pmd_t pmd)
+static inline pmd_t pmd_mkinvalid(pmd_t pmd)
 {
 	return pfn_pmd(pmd_pfn(pmd),
 		      __pgprot(pmd_flags(pmd) & ~(_PAGE_PRESENT|_PAGE_PROTNONE)));
--- a/arch/x86/mm/kmmio.c~mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
+++ a/arch/x86/mm/kmmio.c
@@ -130,7 +130,7 @@ static void clear_pmd_presence(pmd_t *pm
 	pmdval_t v = pmd_val(*pmd);
 	if (clear) {
 		*old = v;
-		new_pmd = pmd_mknotvalid(*pmd);
+		new_pmd = pmd_mkinvalid(*pmd);
 	} else {
 		/* Presume this has been called with clear==true previously */
 		new_pmd = __pmd(*old);
--- a/mm/pgtable-generic.c~mm-thp-rename-pmd_mknotpresent-as-pmd_mkinvalid-v2
+++ a/mm/pgtable-generic.c
@@ -194,7 +194,7 @@ pgtable_t pgtable_trans_huge_withdraw(st
 pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mknotvalid(*pmdp));
+	pmd_t old = pmdp_establish(vma, address, pmdp, pmd_mkinvalid(*pmdp));
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return old;
 }
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-page_alloc-restrict-and-formalize-compound_page_dtors.patch
arm64-mm-drop-__have_arch_huge_ptep_get.patch
mm-hugetlb-define-a-generic-fallback-for-is_hugepage_only_range.patch
mm-hugetlb-define-a-generic-fallback-for-arch_clear_hugepage_flags.patch
powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v18.patch
