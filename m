Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_RED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C638FC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2CFE61469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbhGAB4b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20B116105A;
        Thu,  1 Jul 2021 01:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104441;
        bh=N8GPMZIdUJaYDtDCOBWihsKK8QEbU2F3Oyipk4s62ig=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Pjw17y9pcpBsMux0HBkGIlEie3X99DjgOoYe1dNYe13pqzD81L8QRqqNZkWTNRHy8
         ZWFahswV7nrJ1kWLh/yJVv5V+avXSpBc4Kb6X/vD2vxtbHDJ92rJPCNRKu6ezvrs6g
         1eaLjmazrpYDtvExQS/K/fTIhB1sQVjztaXRlm6E=
Date:   Wed, 30 Jun 2021 18:53:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        bcain@codeaurora.org, catalin.marinas@arm.com, chris@zankel.net,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        geert@linux-m68k.org, guoren@kernel.org, hca@linux.ibm.com,
        James.Bottomley@HansenPartnership.com, jdike@addtoit.com,
        jonas@southpole.se, ley.foon.tan@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au,
        nickhu@andestech.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
        rppt@linux.ibm.com, rth@twiddle.net, shorne@gmail.com,
        stefan.kristiansson@saunalahti.fi, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        vgupta@synopsys.com, will@kernel.org, ysato@users.sourceforge.jp
Subject:  [patch 128/192] mm/thp: define default pmd_pgtable()
Message-ID: <20210701015359.Pny1e1JSH%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/thp: define default pmd_pgtable()

Currently most platforms define pmd_pgtable() as pmd_page() duplicating
the same code all over.  Instead just define a default value i.e
pmd_page() for pmd_pgtable() and let platforms override when required via
<asm/pgtable.h>.  All the existing platform that override pmd_pgtable()
have been moved into their respective <asm/pgtable.h> header in order to
precede before the new generic definition.  This makes it much cleaner
with reduced code.

Link: https://lkml.kernel.org/r/1623646133-20306-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgalloc.h         |    1 -
 arch/arc/include/asm/pgalloc.h           |    2 --
 arch/arc/include/asm/pgtable.h           |    2 ++
 arch/arm/include/asm/pgalloc.h           |    1 -
 arch/arm64/include/asm/pgalloc.h         |    1 -
 arch/csky/include/asm/pgalloc.h          |    2 --
 arch/hexagon/include/asm/pgtable.h       |    1 -
 arch/ia64/include/asm/pgalloc.h          |    1 -
 arch/m68k/include/asm/mcf_pgalloc.h      |    2 --
 arch/m68k/include/asm/mcf_pgtable.h      |    2 ++
 arch/m68k/include/asm/motorola_pgalloc.h |    1 -
 arch/m68k/include/asm/motorola_pgtable.h |    2 ++
 arch/m68k/include/asm/sun3_pgalloc.h     |    1 -
 arch/microblaze/include/asm/pgalloc.h    |    2 --
 arch/mips/include/asm/pgalloc.h          |    1 -
 arch/nds32/include/asm/pgalloc.h         |    5 -----
 arch/nios2/include/asm/pgalloc.h         |    1 -
 arch/openrisc/include/asm/pgalloc.h      |    2 --
 arch/parisc/include/asm/pgalloc.h        |    1 -
 arch/powerpc/include/asm/pgalloc.h       |    5 -----
 arch/powerpc/include/asm/pgtable.h       |    6 ++++++
 arch/riscv/include/asm/pgalloc.h         |    2 --
 arch/s390/include/asm/pgalloc.h          |    3 ---
 arch/s390/include/asm/pgtable.h          |    3 +++
 arch/sh/include/asm/pgalloc.h            |    1 -
 arch/sparc/include/asm/pgalloc_32.h      |    1 -
 arch/sparc/include/asm/pgalloc_64.h      |    1 -
 arch/sparc/include/asm/pgtable_32.h      |    2 ++
 arch/sparc/include/asm/pgtable_64.h      |    2 ++
 arch/um/include/asm/pgalloc.h            |    1 -
 arch/x86/include/asm/pgalloc.h           |    2 --
 arch/xtensa/include/asm/pgalloc.h        |    2 --
 include/linux/pgtable.h                  |    9 +++++++++
 33 files changed, 28 insertions(+), 43 deletions(-)

--- a/arch/alpha/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/alpha/include/asm/pgalloc.h
@@ -18,7 +18,6 @@ pmd_populate(struct mm_struct *mm, pmd_t
 {
 	pmd_set(pmd, (pte_t *)(page_to_pa(pte) + PAGE_OFFSET));
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 static inline void
 pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
--- a/arch/arc/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/arc/include/asm/pgalloc.h
@@ -129,6 +129,4 @@ static inline void pte_free(struct mm_st
 
 #define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
 
-#define pmd_pgtable(pmd)	((pgtable_t) pmd_page_vaddr(pmd))
-
 #endif /* _ASM_ARC_PGALLOC_H */
--- a/arch/arc/include/asm/pgtable.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/arc/include/asm/pgtable.h
@@ -350,6 +350,8 @@ void update_mmu_cache(struct vm_area_str
 
 #define kern_addr_valid(addr)	(1)
 
+#define pmd_pgtable(pmd)       ((pgtable_t) pmd_page_vaddr(pmd))
+
 /*
  * remap a physical page `pfn' of size `size' with page protection `prot'
  * into virtual address `from'
--- a/arch/arm64/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -86,6 +86,5 @@ pmd_populate(struct mm_struct *mm, pmd_t
 	VM_BUG_ON(mm == &init_mm);
 	__pmd_populate(pmdp, page_to_phys(ptep), PMD_TYPE_TABLE | PMD_TABLE_PXN);
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 #endif
--- a/arch/arm/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/arm/include/asm/pgalloc.h
@@ -143,7 +143,6 @@ pmd_populate(struct mm_struct *mm, pmd_t
 
 	__pmd_populate(pmdp, page_to_phys(ptep), prot);
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 #endif /* CONFIG_MMU */
 
--- a/arch/csky/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/csky/include/asm/pgalloc.h
@@ -22,8 +22,6 @@ static inline void pmd_populate(struct m
 	set_pmd(pmd, __pmd(__pa(page_address(pte))));
 }
 
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
 extern void pgd_init(unsigned long *p);
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
--- a/arch/hexagon/include/asm/pgtable.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -239,7 +239,6 @@ static inline int pmd_bad(pmd_t pmd)
  * pmd_page - converts a PMD entry to a page pointer
  */
 #define pmd_page(pmd)  (pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 /**
  * pte_none - check if pte is mapped
--- a/arch/ia64/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/ia64/include/asm/pgalloc.h
@@ -52,7 +52,6 @@ pmd_populate(struct mm_struct *mm, pmd_t
 {
 	pmd_val(*pmd_entry) = page_to_phys(pte);
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 static inline void
 pmd_populate_kernel(struct mm_struct *mm, pmd_t * pmd_entry, pte_t * pte)
--- a/arch/m68k/include/asm/mcf_pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -32,8 +32,6 @@ extern inline pmd_t *pmd_alloc_kernel(pg
 
 #define pmd_populate_kernel pmd_populate
 
-#define pmd_pgtable(pmd) pfn_to_virt(pmd_val(pmd) >> PAGE_SHIFT)
-
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pgtable,
 				  unsigned long address)
 {
--- a/arch/m68k/include/asm/mcf_pgtable.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -150,6 +150,8 @@
 
 #ifndef __ASSEMBLY__
 
+#define pmd_pgtable(pmd) pfn_to_virt(pmd_val(pmd) >> PAGE_SHIFT)
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
--- a/arch/m68k/include/asm/motorola_pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/m68k/include/asm/motorola_pgalloc.h
@@ -88,7 +88,6 @@ static inline void pmd_populate(struct m
 {
 	pmd_set(pmd, page);
 }
-#define pmd_pgtable(pmd) ((pgtable_t)pmd_page_vaddr(pmd))
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 {
--- a/arch/m68k/include/asm/motorola_pgtable.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -105,6 +105,8 @@ extern unsigned long mm_cachebits;
 #define __S110	PAGE_SHARED_C
 #define __S111	PAGE_SHARED_C
 
+#define pmd_pgtable(pmd) ((pgtable_t)pmd_page_vaddr(pmd))
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
--- a/arch/m68k/include/asm/sun3_pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/m68k/include/asm/sun3_pgalloc.h
@@ -32,7 +32,6 @@ static inline void pmd_populate(struct m
 {
 	pmd_val(*pmd) = __pa((unsigned long)page_address(page));
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 /*
  * allocating and freeing a pmd is trivial: the 1-entry pmd is
--- a/arch/microblaze/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -28,8 +28,6 @@ static inline pgd_t *get_pgd(void)
 
 #define pgd_alloc(mm)		get_pgd()
 
-#define pmd_pgtable(pmd)	pmd_page(pmd)
-
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
 #define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, (pte))
--- a/arch/mips/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/mips/include/asm/pgalloc.h
@@ -28,7 +28,6 @@ static inline void pmd_populate(struct m
 {
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 /*
  * Initialize a new pmd table with invalid pointers.
--- a/arch/nds32/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/nds32/include/asm/pgalloc.h
@@ -12,11 +12,6 @@
 #define __HAVE_ARCH_PTE_ALLOC_ONE
 #include <asm-generic/pgalloc.h>	/* for pte_{alloc,free}_one */
 
-/*
- * Since we have only two-level page tables, these are trivial
- */
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 extern void pgd_free(struct mm_struct *mm, pgd_t * pgd);
 
--- a/arch/nios2/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/nios2/include/asm/pgalloc.h
@@ -25,7 +25,6 @@ static inline void pmd_populate(struct m
 {
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 /*
  * Initialize a new pmd table with invalid pointers.
--- a/arch/openrisc/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -72,6 +72,4 @@ do {					\
 	tlb_remove_page((tlb), (pte));	\
 } while (0)
 
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
 #endif
--- a/arch/parisc/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -69,6 +69,5 @@ pmd_populate_kernel(struct mm_struct *mm
 
 #define pmd_populate(mm, pmd, pte_page) \
 	pmd_populate_kernel(mm, pmd, page_address(pte_page))
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 #endif
--- a/arch/powerpc/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/powerpc/include/asm/pgalloc.h
@@ -70,9 +70,4 @@ extern struct kmem_cache *pgtable_cache[
 #include <asm/nohash/pgalloc.h>
 #endif
 
-static inline pgtable_t pmd_pgtable(pmd_t pmd)
-{
-	return (pgtable_t)pmd_page_vaddr(pmd);
-}
-
 #endif /* _ASM_POWERPC_PGALLOC_H */
--- a/arch/powerpc/include/asm/pgtable.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -152,6 +152,12 @@ static inline bool p4d_is_leaf(p4d_t p4d
 }
 #endif
 
+#define pmd_pgtable pmd_pgtable
+static inline pgtable_t pmd_pgtable(pmd_t pmd)
+{
+	return (pgtable_t)pmd_page_vaddr(pmd);
+}
+
 #ifdef CONFIG_PPC64
 #define is_ioremap_addr is_ioremap_addr
 static inline bool is_ioremap_addr(const void *x)
--- a/arch/riscv/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/riscv/include/asm/pgalloc.h
@@ -38,8 +38,6 @@ static inline void pud_populate(struct m
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-#define pmd_pgtable(pmd)	pmd_page(pmd)
-
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	pgd_t *pgd;
--- a/arch/s390/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/s390/include/asm/pgalloc.h
@@ -134,9 +134,6 @@ static inline void pmd_populate(struct m
 
 #define pmd_populate_kernel(mm, pmd, pte) pmd_populate(mm, pmd, pte)
 
-#define pmd_pgtable(pmd) \
-	((pgtable_t)__va(pmd_val(pmd) & -sizeof(pte_t)*PTRS_PER_PTE))
-
 /*
  * page table entry allocation/free routines.
  */
--- a/arch/s390/include/asm/pgtable.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/s390/include/asm/pgtable.h
@@ -1709,4 +1709,7 @@ extern void s390_reset_cmma(struct mm_st
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
+#define pmd_pgtable(pmd) \
+	((pgtable_t)__va(pmd_val(pmd) & -sizeof(pte_t)*PTRS_PER_PTE))
+
 #endif /* _S390_PAGE_H */
--- a/arch/sh/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/sh/include/asm/pgalloc.h
@@ -30,7 +30,6 @@ static inline void pmd_populate(struct m
 {
 	set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 #define __pte_free_tlb(tlb,pte,addr)			\
 do {							\
--- a/arch/sparc/include/asm/pgalloc_32.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/sparc/include/asm/pgalloc_32.h
@@ -51,7 +51,6 @@ static inline void free_pmd_fast(pmd_t *
 #define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
 
 #define pmd_populate(mm, pmd, pte)	pmd_set(pmd, pte)
-#define pmd_pgtable(pmd)		(pgtable_t)__pmd_page(pmd)
 
 void pmd_set(pmd_t *pmdp, pte_t *ptep);
 #define pmd_populate_kernel		pmd_populate
--- a/arch/sparc/include/asm/pgalloc_64.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -67,7 +67,6 @@ void pte_free(struct mm_struct *mm, pgta
 
 #define pmd_populate_kernel(MM, PMD, PTE)	pmd_set(MM, PMD, PTE)
 #define pmd_populate(MM, PMD, PTE)		pmd_set(MM, PMD, PTE)
-#define pmd_pgtable(PMD)			((pte_t *)pmd_page_vaddr(PMD))
 
 void pgtable_free(void *table, bool is_page);
 
--- a/arch/sparc/include/asm/pgtable_32.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -432,4 +432,6 @@ static inline int io_remap_pfn_range(str
 /* We provide our own get_unmapped_area to cope with VA holes for userland */
 #define HAVE_ARCH_UNMAPPED_AREA
 
+#define pmd_pgtable(pmd)	((pgtable_t)__pmd_page(pmd))
+
 #endif /* !(_SPARC_PGTABLE_H) */
--- a/arch/sparc/include/asm/pgtable_64.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -1117,6 +1117,8 @@ extern unsigned long cmdline_memory_size
 
 asmlinkage void do_sparc64_fault(struct pt_regs *regs);
 
+#define pmd_pgtable(PMD)	((pte_t *)pmd_page_vaddr(PMD))
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #define pud_leaf_size pud_leaf_size
--- a/arch/um/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/um/include/asm/pgalloc.h
@@ -19,7 +19,6 @@
 	set_pmd(pmd, __pmd(_PAGE_TABLE +			\
 		((unsigned long long)page_to_pfn(pte) <<	\
 			(unsigned long long) PAGE_SHIFT)))
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 /*
  * Allocate and free page tables.
--- a/arch/x86/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/x86/include/asm/pgalloc.h
@@ -84,8 +84,6 @@ static inline void pmd_populate(struct m
 	set_pmd(pmd, __pmd(((pteval_t)pfn << PAGE_SHIFT) | _PAGE_TABLE));
 }
 
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
 #if CONFIG_PGTABLE_LEVELS > 2
 extern void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
 
--- a/arch/xtensa/include/asm/pgalloc.h~mm-thp-define-default-pmd_pgtable
+++ a/arch/xtensa/include/asm/pgalloc.h
@@ -25,7 +25,6 @@
 	(pmd_val(*(pmdp)) = ((unsigned long)ptep))
 #define pmd_populate(mm, pmdp, page)					     \
 	(pmd_val(*(pmdp)) = ((unsigned long)page_to_virt(page)))
-#define pmd_pgtable(pmd) pmd_page(pmd)
 
 static inline pgd_t*
 pgd_alloc(struct mm_struct *mm)
@@ -63,7 +62,6 @@ static inline pgtable_t pte_alloc_one(st
 	return page;
 }
 
-#define pmd_pgtable(pmd) pmd_page(pmd)
 #endif /* CONFIG_MMU */
 
 #endif /* _XTENSA_PGALLOC_H */
--- a/include/linux/pgtable.h~mm-thp-define-default-pmd_pgtable
+++ a/include/linux/pgtable.h
@@ -38,6 +38,15 @@
 #endif
 
 /*
+ * This defines the generic helper for accessing PMD page
+ * table page. Although platforms can still override this
+ * via their respective <asm/pgtable.h>.
+ */
+#ifndef pmd_pgtable
+#define pmd_pgtable(pmd) pmd_page(pmd)
+#endif
+
+/*
  * A page table page can be thought of an array like this: pXd_t[PTRS_PER_PxD]
  *
  * The pXx_index() functions return the index of the entry in the page
_
