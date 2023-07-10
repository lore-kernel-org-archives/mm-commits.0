Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6233DEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjGJXaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjGJXaQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E280898
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BED61275
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75C6C433C8;
        Mon, 10 Jul 2023 23:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031813;
        bh=5C4KNTGCbkMt3/FLIyJ0klHN4PtZtL0X+pOi4i49Iac=;
        h=Date:To:From:Subject:From;
        b=OMQIW/xT5cRYQWSBz8R8zNiBcUq2kqTrogxPbvl4jvkCom+rfX6dg5SHg+8jpv7IA
         4yix07XknIptIKGCSSeByX7VrjDzJ82jwc8Wr0yIdh2PllriG4j+49WAyrYq2o2vJZ
         /nWUIGFdGVQUW70jl+9P5yTCyWk7boJiKEzafQdk=
Date:   Mon, 10 Jul 2023 16:30:13 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, kernel@xen0n.name,
        chenhuacai@kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233013.C75C6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loongarch: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-implement-the-new-page-table-range-api.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: loongarch: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:15 +0100

Add update_mmu_cache_range() and change _PFN_SHIFT to PFN_PTE_SHIFT.  It
would probably be more efficient to implement __update_tlb() by flushing
the entire folio instead of calling __update_tlb() N times, but I'll leave
that for someone who understands the architecture better.

Link: https://lkml.kernel.org/r/20230710204339.3554919-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/cacheflush.h   |    1 
 arch/loongarch/include/asm/pgtable-bits.h |    4 +-
 arch/loongarch/include/asm/pgtable.h      |   35 ++++++++++----------
 arch/loongarch/mm/pgtable.c               |    2 -
 arch/loongarch/mm/tlb.c                   |    2 -
 5 files changed, 24 insertions(+), 20 deletions(-)

--- a/arch/loongarch/include/asm/cacheflush.h~loongarch-implement-the-new-page-table-range-api
+++ a/arch/loongarch/include/asm/cacheflush.h
@@ -47,6 +47,7 @@ void local_flush_icache_range(unsigned l
 #define flush_cache_vmap(start, end)			do { } while (0)
 #define flush_cache_vunmap(start, end)			do { } while (0)
 #define flush_icache_page(vma, page)			do { } while (0)
+#define flush_icache_pages(vma, page)			do { } while (0)
 #define flush_icache_user_page(vma, page, addr, len)	do { } while (0)
 #define flush_dcache_page(page)				do { } while (0)
 #define flush_dcache_mmap_lock(mapping)			do { } while (0)
--- a/arch/loongarch/include/asm/pgtable-bits.h~loongarch-implement-the-new-page-table-range-api
+++ a/arch/loongarch/include/asm/pgtable-bits.h
@@ -50,12 +50,12 @@
 #define _PAGE_NO_EXEC		(_ULCAST_(1) << _PAGE_NO_EXEC_SHIFT)
 #define _PAGE_RPLV		(_ULCAST_(1) << _PAGE_RPLV_SHIFT)
 #define _CACHE_MASK		(_ULCAST_(3) << _CACHE_SHIFT)
-#define _PFN_SHIFT		(PAGE_SHIFT - 12 + _PAGE_PFN_SHIFT)
+#define PFN_PTE_SHIFT		(PAGE_SHIFT - 12 + _PAGE_PFN_SHIFT)
 
 #define _PAGE_USER	(PLV_USER << _PAGE_PLV_SHIFT)
 #define _PAGE_KERN	(PLV_KERN << _PAGE_PLV_SHIFT)
 
-#define _PFN_MASK (~((_ULCAST_(1) << (_PFN_SHIFT)) - 1) & \
+#define _PFN_MASK (~((_ULCAST_(1) << (PFN_PTE_SHIFT)) - 1) & \
 		  ((_ULCAST_(1) << (_PAGE_PFN_END_SHIFT)) - 1))
 
 /*
--- a/arch/loongarch/include/asm/pgtable.h~loongarch-implement-the-new-page-table-range-api
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -237,9 +237,9 @@ extern pmd_t mk_pmd(struct page *page, p
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr, pmd_t *pmdp, pmd_t pmd);
 
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
-#define pte_pfn(x)		((unsigned long)(((x).pte & _PFN_MASK) >> _PFN_SHIFT))
-#define pfn_pte(pfn, prot)	__pte(((pfn) << _PFN_SHIFT) | pgprot_val(prot))
-#define pfn_pmd(pfn, prot)	__pmd(((pfn) << _PFN_SHIFT) | pgprot_val(prot))
+#define pte_pfn(x)		((unsigned long)(((x).pte & _PFN_MASK) >> PFN_PTE_SHIFT))
+#define pfn_pte(pfn, prot)	__pte(((pfn) << PFN_PTE_SHIFT) | pgprot_val(prot))
+#define pfn_pmd(pfn, prot)	__pmd(((pfn) << PFN_PTE_SHIFT) | pgprot_val(prot))
 
 /*
  * Initialize a new pgd / pud / pmd table with invalid pointers.
@@ -334,19 +334,13 @@ static inline void set_pte(pte_t *ptep,
 	}
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	set_pte(ptep, pteval);
-}
-
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	/* Preserve global status for the pair */
 	if (pte_val(*ptep_buddy(ptep)) & _PAGE_GLOBAL)
-		set_pte_at(mm, addr, ptep, __pte(_PAGE_GLOBAL));
+		set_pte(ptep, __pte(_PAGE_GLOBAL));
 	else
-		set_pte_at(mm, addr, ptep, __pte(0));
+		set_pte(ptep, __pte(0));
 }
 
 #define PGD_T_LOG2	(__builtin_ffs(sizeof(pgd_t)) - 1)
@@ -445,11 +439,20 @@ static inline pte_t pte_modify(pte_t pte
 extern void __update_tlb(struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep);
 
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-			unsigned long address, pte_t *ptep)
-{
-	__update_tlb(vma, address, ptep);
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
+{
+	for (;;) {
+		__update_tlb(vma, address, ptep);
+		if (--nr == 0)
+			break;
+		address += PAGE_SIZE;
+		ptep++;
+	}
 }
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
 #define __HAVE_ARCH_UPDATE_MMU_TLB
 #define update_mmu_tlb	update_mmu_cache
@@ -462,7 +465,7 @@ static inline void update_mmu_cache_pmd(
 
 static inline unsigned long pmd_pfn(pmd_t pmd)
 {
-	return (pmd_val(pmd) & _PFN_MASK) >> _PFN_SHIFT;
+	return (pmd_val(pmd) & _PFN_MASK) >> PFN_PTE_SHIFT;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/arch/loongarch/mm/pgtable.c~loongarch-implement-the-new-page-table-range-api
+++ a/arch/loongarch/mm/pgtable.c
@@ -107,7 +107,7 @@ pmd_t mk_pmd(struct page *page, pgprot_t
 {
 	pmd_t pmd;
 
-	pmd_val(pmd) = (page_to_pfn(page) << _PFN_SHIFT) | pgprot_val(prot);
+	pmd_val(pmd) = (page_to_pfn(page) << PFN_PTE_SHIFT) | pgprot_val(prot);
 
 	return pmd;
 }
--- a/arch/loongarch/mm/tlb.c~loongarch-implement-the-new-page-table-range-api
+++ a/arch/loongarch/mm/tlb.c
@@ -252,7 +252,7 @@ static void output_pgtable_bits_defines(
 	pr_define("_PAGE_WRITE_SHIFT %d\n", _PAGE_WRITE_SHIFT);
 	pr_define("_PAGE_NO_READ_SHIFT %d\n", _PAGE_NO_READ_SHIFT);
 	pr_define("_PAGE_NO_EXEC_SHIFT %d\n", _PAGE_NO_EXEC_SHIFT);
-	pr_define("_PFN_SHIFT %d\n", _PFN_SHIFT);
+	pr_define("PFN_PTE_SHIFT %d\n", PFN_PTE_SHIFT);
 	pr_debug("\n");
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

