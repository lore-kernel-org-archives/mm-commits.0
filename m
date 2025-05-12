Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695F013AA2E
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010989; cv=none; b=ropfpnT1RXzxlZR6YYZqSE0emhNb0v7s+nWEdUXthQMF6BmYPtOKNZ5zBDtCoYjteyOmHDC72aTZ3UBOyzxJqzvsARwedIY3Vw88mHpRV6hwJ9C89IEycrdi+sG1PvHlC/Zd5BWrb7DRZ6alMA0/82QoUvoeXRBkbUHTjbT7nhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010989; c=relaxed/simple;
	bh=pwsT848SvRmrIJx4DPgyWdNMujPKwr6oiWPyd/7sC28=;
	h=Date:To:From:Subject:Message-Id; b=BaMCUzuMLurz7erAiEKw7flrSTKtMqY0s+F+pLGDJAqfYOqoI/2UuQACR/AFSzzws7JKoF+fNXoGxscj/VMYWiKDdh2aC/7BdQ1kI13yylGxr85L7i2PCf8IM4XzX2gq51NNsehEHvB/wSrQezKErH/aolKT/KEXT/XK91mctD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1zyIlg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1zyIlg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD67C4CEE4;
	Mon, 12 May 2025 00:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010989;
	bh=pwsT848SvRmrIJx4DPgyWdNMujPKwr6oiWPyd/7sC28=;
	h=Date:To:From:Subject:From;
	b=Z1zyIlg1RrCeXqj3pkp7rvuVfD3foLLm1dkXnaYpSXmok1kB45tlKtGkUN9CjPXaf
	 h2jEYdda97D4s5mCporjR9IddkhRk46dBbWMHU0ZwWyzmIIa9TnDKVBcZjPalJETtH
	 xNhqYNeeXfzzK8qmdAyC3NaPOYY2T/JGHaS2AQWU=
Date: Sun, 11 May 2025 17:49:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arch-remove-mk_pmd.patch removed from -mm tree
Message-Id: <20250512004949.3DD67C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch: remove mk_pmd()
has been removed from the -mm tree.  Its filename was
     arch-remove-mk_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: arch: remove mk_pmd()
Date: Wed, 2 Apr 2025 19:17:05 +0100

There are now no callers of mk_huge_pmd() and mk_pmd().  Remove them.

Link: https://lkml.kernel.org/r/20250402181709.2386022-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/hugepage.h              |    2 --
 arch/arc/include/asm/pgtable-levels.h        |    1 -
 arch/arm/include/asm/pgtable-3level.h        |    1 -
 arch/arm64/include/asm/pgtable.h             |    1 -
 arch/loongarch/include/asm/pgtable.h         |    1 -
 arch/loongarch/mm/pgtable.c                  |    9 ---------
 arch/mips/include/asm/pgtable.h              |    3 ---
 arch/mips/mm/pgtable-32.c                    |   10 ----------
 arch/mips/mm/pgtable-64.c                    |    9 ---------
 arch/powerpc/include/asm/book3s/64/pgtable.h |    1 -
 arch/powerpc/mm/book3s64/pgtable.c           |    5 -----
 arch/riscv/include/asm/pgtable-64.h          |    2 --
 arch/s390/include/asm/pgtable.h              |    1 -
 arch/sparc/include/asm/pgtable_64.h          |    1 -
 arch/x86/include/asm/pgtable.h               |    2 --
 include/linux/huge_mm.h                      |    2 --
 16 files changed, 51 deletions(-)

--- a/arch/arc/include/asm/hugepage.h~arch-remove-mk_pmd
+++ a/arch/arc/include/asm/hugepage.h
@@ -40,8 +40,6 @@ static inline pmd_t pte_pmd(pte_t pte)
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 
-#define mk_pmd(page, prot)	pte_pmd(mk_pte(page, prot))
-
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) & _PAGE_HW_SZ)
 
 #define pfn_pmd(pfn, prot)	(__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot)))
--- a/arch/arc/include/asm/pgtable-levels.h~arch-remove-mk_pmd
+++ a/arch/arc/include/asm/pgtable-levels.h
@@ -142,7 +142,6 @@
 
 #define pmd_pfn(pmd)		((pmd_val(pmd) & PMD_MASK) >> PAGE_SHIFT)
 #define pfn_pmd(pfn,prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
 #endif
 
--- a/arch/arm64/include/asm/pgtable.h~arch-remove-mk_pmd
+++ a/arch/arm64/include/asm/pgtable.h
@@ -609,7 +609,6 @@ static inline pmd_t pmd_mkspecial(pmd_t
 #define __phys_to_pmd_val(phys)	__phys_to_pte_val(phys)
 #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
 #define pfn_pmd(pfn,prot)	__pmd(__phys_to_pmd_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
 #define pud_young(pud)		pte_young(pud_pte(pud))
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
--- a/arch/arm/include/asm/pgtable-3level.h~arch-remove-mk_pmd
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -209,7 +209,6 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 
 #define pmd_pfn(pmd)		(((pmd_val(pmd) & PMD_MASK) & PHYS_MASK) >> PAGE_SHIFT)
 #define pfn_pmd(pfn,prot)	(__pmd(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
-#define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
 /* No hardware dirty/accessed bits -- generic_pmdp_establish() fits */
 #define pmdp_establish generic_pmdp_establish
--- a/arch/loongarch/include/asm/pgtable.h~arch-remove-mk_pmd
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -255,7 +255,6 @@ static inline void pmd_clear(pmd_t *pmdp
 
 #define pmd_page_vaddr(pmd)	pmd_val(pmd)
 
-extern pmd_t mk_pmd(struct page *page, pgprot_t prot);
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr, pmd_t *pmdp, pmd_t pmd);
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
--- a/arch/loongarch/mm/pgtable.c~arch-remove-mk_pmd
+++ a/arch/loongarch/mm/pgtable.c
@@ -135,15 +135,6 @@ void kernel_pte_init(void *addr)
 	} while (p != end);
 }
 
-pmd_t mk_pmd(struct page *page, pgprot_t prot)
-{
-	pmd_t pmd;
-
-	pmd_val(pmd) = (page_to_pfn(page) << PFN_PTE_SHIFT) | pgprot_val(prot);
-
-	return pmd;
-}
-
 void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		pmd_t *pmdp, pmd_t pmd)
 {
--- a/arch/mips/include/asm/pgtable.h~arch-remove-mk_pmd
+++ a/arch/mips/include/asm/pgtable.h
@@ -713,9 +713,6 @@ static inline pmd_t pmd_clear_soft_dirty
 
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-/* Extern to avoid header file madness */
-extern pmd_t mk_pmd(struct page *page, pgprot_t prot);
-
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 {
 	pmd_val(pmd) = (pmd_val(pmd) & (_PAGE_CHG_MASK | _PAGE_HUGE)) |
--- a/arch/mips/mm/pgtable-32.c~arch-remove-mk_pmd
+++ a/arch/mips/mm/pgtable-32.c
@@ -31,16 +31,6 @@ void pgd_init(void *addr)
 }
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-pmd_t mk_pmd(struct page *page, pgprot_t prot)
-{
-	pmd_t pmd;
-
-	pmd_val(pmd) = (page_to_pfn(page) << PFN_PTE_SHIFT) | pgprot_val(prot);
-
-	return pmd;
-}
-
-
 void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		pmd_t *pmdp, pmd_t pmd)
 {
--- a/arch/mips/mm/pgtable-64.c~arch-remove-mk_pmd
+++ a/arch/mips/mm/pgtable-64.c
@@ -90,15 +90,6 @@ void pud_init(void *addr)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-pmd_t mk_pmd(struct page *page, pgprot_t prot)
-{
-	pmd_t pmd;
-
-	pmd_val(pmd) = (page_to_pfn(page) << PFN_PTE_SHIFT) | pgprot_val(prot);
-
-	return pmd;
-}
-
 void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		pmd_t *pmdp, pmd_t pmd)
 {
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~arch-remove-mk_pmd
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1096,7 +1096,6 @@ static inline bool pmd_access_permitted(
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pfn_pmd(unsigned long pfn, pgprot_t pgprot);
 extern pud_t pfn_pud(unsigned long pfn, pgprot_t pgprot);
-extern pmd_t mk_pmd(struct page *page, pgprot_t pgprot);
 extern pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot);
 extern pud_t pud_modify(pud_t pud, pgprot_t newprot);
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr,
--- a/arch/powerpc/mm/book3s64/pgtable.c~arch-remove-mk_pmd
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -269,11 +269,6 @@ pud_t pfn_pud(unsigned long pfn, pgprot_
 	return __pud_mkhuge(pud_set_protbits(__pud(pudv), pgprot));
 }
 
-pmd_t mk_pmd(struct page *page, pgprot_t pgprot)
-{
-	return pfn_pmd(page_to_pfn(page), pgprot);
-}
-
 pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 {
 	unsigned long pmdv;
--- a/arch/riscv/include/asm/pgtable-64.h~arch-remove-mk_pmd
+++ a/arch/riscv/include/asm/pgtable-64.h
@@ -262,8 +262,6 @@ static inline unsigned long _pmd_pfn(pmd
 	return __page_val_to_pfn(pmd_val(pmd));
 }
 
-#define mk_pmd(page, prot)    pfn_pmd(page_to_pfn(page), prot)
-
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
 
--- a/arch/s390/include/asm/pgtable.h~arch-remove-mk_pmd
+++ a/arch/s390/include/asm/pgtable.h
@@ -1869,7 +1869,6 @@ static inline pmd_t pmdp_collapse_flush(
 #define pmdp_collapse_flush pmdp_collapse_flush
 
 #define pfn_pmd(pfn, pgprot)	mk_pmd_phys(((pfn) << PAGE_SHIFT), (pgprot))
-#define mk_pmd(page, pgprot)	pfn_pmd(page_to_pfn(page), (pgprot))
 
 static inline int pmd_trans_huge(pmd_t pmd)
 {
--- a/arch/sparc/include/asm/pgtable_64.h~arch-remove-mk_pmd
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -233,7 +233,6 @@ static inline pmd_t pfn_pmd(unsigned lon
 
 	return __pmd(pte_val(pte));
 }
-#define mk_pmd(page, pgprot)	pfn_pmd(page_to_pfn(page), (pgprot))
 #endif
 
 /* This one can be done with two shifts.  */
--- a/arch/x86/include/asm/pgtable.h~arch-remove-mk_pmd
+++ a/arch/x86/include/asm/pgtable.h
@@ -1347,8 +1347,6 @@ static inline void ptep_set_wrprotect(st
 
 #define flush_tlb_fix_spurious_fault(vma, address, ptep) do { } while (0)
 
-#define mk_pmd(page, pgprot)   pfn_pmd(page_to_pfn(page), (pgprot))
-
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp,
--- a/include/linux/huge_mm.h~arch-remove-mk_pmd
+++ a/include/linux/huge_mm.h
@@ -495,8 +495,6 @@ static inline bool is_huge_zero_pmd(pmd_
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_folio(struct mm_struct *mm);
 
-#define mk_huge_pmd(page, prot) pmd_mkhuge(mk_pmd(page, prot))
-
 static inline bool thp_migration_supported(void)
 {
 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
_

Patches currently in -mm which might be from willy@infradead.org are


