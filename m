Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20814EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjGJXa5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjGJXaw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:30:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F78AA8
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09E5161262
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4B4C433C7;
        Mon, 10 Jul 2023 23:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031849;
        bh=6N5taymf946DXkkPh/o3CKGM7YoWEjeZMayvzf3T13Y=;
        h=Date:To:From:Subject:From;
        b=15uFdriWZ7sHLNe08vB1A/kCdtWSNfJ2oQpGLmQ/EoNOC+9JQA3AeY3biEHmSrZc/
         Omhi/KyH+zWoZj1C34cak1N5vT1wacR9+kDxQFNqv8DrUr6jE08ewyz44saINk1UMg
         HFib1CGBl81xuYKOki9/4MKGc/wdjkG7ul2buLd8=
Date:   Mon, 10 Jul 2023 16:30:48 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, alexghiti@rivosinc.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233049.5F4B4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-implement-the-new-page-table-range-api.patch

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
Subject: riscv: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:23 +0100

Add set_ptes(), update_mmu_cache_range() and flush_dcache_folio().  Change
the PG_dcache_clean flag from being per-page to per-folio.

Link: https://lkml.kernel.org/r/20230710204339.3554919-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/cacheflush.h |   19 ++++++-------
 arch/riscv/include/asm/pgtable.h    |   38 +++++++++++++++++---------
 arch/riscv/mm/cacheflush.c          |   13 ++------
 3 files changed, 37 insertions(+), 33 deletions(-)

--- a/arch/riscv/include/asm/cacheflush.h~riscv-implement-the-new-page-table-range-api
+++ a/arch/riscv/include/asm/cacheflush.h
@@ -15,20 +15,19 @@ static inline void local_flush_icache_al
 
 #define PG_dcache_clean PG_arch_1
 
-static inline void flush_dcache_page(struct page *page)
+static inline void flush_dcache_folio(struct folio *folio)
 {
-	/*
-	 * HugeTLB pages are always fully mapped and only head page will be
-	 * set PG_dcache_clean (see comments in flush_icache_pte()).
-	 */
-	if (PageHuge(page))
-		page = compound_head(page);
-
-	if (test_bit(PG_dcache_clean, &page->flags))
-		clear_bit(PG_dcache_clean, &page->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags))
+		clear_bit(PG_dcache_clean, &folio->flags);
 }
+#define flush_dcache_folio flush_dcache_folio
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 
+static inline void flush_dcache_page(struct page *page)
+{
+	flush_dcache_folio(page_folio(page));
+}
+
 /*
  * RISC-V doesn't have an instruction to flush parts of the instruction cache,
  * so instead we just flush the whole thing.
--- a/arch/riscv/include/asm/pgtable.h~riscv-implement-the-new-page-table-range-api
+++ a/arch/riscv/include/asm/pgtable.h
@@ -445,8 +445,9 @@ static inline pte_t pte_modify(pte_t pte
 
 
 /* Commit new configuration to MMU hardware */
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-	unsigned long address, pte_t *ptep)
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
 {
 	/*
 	 * The kernel assumes that TLBs don't cache invalid entries, but
@@ -455,8 +456,11 @@ static inline void update_mmu_cache(stru
 	 * Relying on flush_tlb_fix_spurious_fault would suffice, but
 	 * the extra traps reduce performance.  So, eagerly SFENCE.VMA.
 	 */
-	local_flush_tlb_page(address);
+	while (nr--)
+		local_flush_tlb_page(address + nr * PAGE_SIZE);
 }
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
 #define __HAVE_ARCH_UPDATE_MMU_TLB
 #define update_mmu_tlb update_mmu_cache
@@ -487,8 +491,7 @@ static inline void set_pte(pte_t *ptep,
 
 void flush_icache_pte(pte_t pte);
 
-static inline void __set_pte_at(struct mm_struct *mm,
-	unsigned long addr, pte_t *ptep, pte_t pteval)
+static inline void __set_pte_at(pte_t *ptep, pte_t pteval)
 {
 	if (pte_present(pteval) && pte_exec(pteval))
 		flush_icache_pte(pteval);
@@ -496,17 +499,26 @@ static inline void __set_pte_at(struct m
 	set_pte(ptep, pteval);
 }
 
-static inline void set_pte_at(struct mm_struct *mm,
-	unsigned long addr, pte_t *ptep, pte_t pteval)
+static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pteval, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, addr, ptep, pteval, 1);
-	__set_pte_at(mm, addr, ptep, pteval);
+	page_table_check_ptes_set(mm, addr, ptep, pteval, nr);
+
+	for (;;) {
+		__set_pte_at(ptep, pteval);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+		pte_val(pteval) += 1 << _PAGE_PFN_SHIFT;
+	}
 }
+#define set_ptes set_ptes
 
 static inline void pte_clear(struct mm_struct *mm,
 	unsigned long addr, pte_t *ptep)
 {
-	__set_pte_at(mm, addr, ptep, __pte(0));
+	__set_pte_at(ptep, __pte(0));
 }
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
@@ -515,7 +527,7 @@ static inline int ptep_set_access_flags(
 					pte_t entry, int dirty)
 {
 	if (!pte_same(*ptep, entry))
-		set_pte_at(vma->vm_mm, address, ptep, entry);
+		__set_pte_at(ptep, entry);
 	/*
 	 * update_mmu_cache will unconditionally execute, handling both
 	 * the case that the PTE changed and the spurious fault case.
@@ -688,14 +700,14 @@ static inline void set_pmd_at(struct mm_
 				pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(mm, addr, pmdp, pmd);
-	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
+	return __set_pte_at((pte_t *)pmdp, pmd_pte(pmd));
 }
 
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
 	page_table_check_pud_set(mm, addr, pudp, pud);
-	return __set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud));
+	return __set_pte_at((pte_t *)pudp, pud_pte(pud));
 }
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
--- a/arch/riscv/mm/cacheflush.c~riscv-implement-the-new-page-table-range-api
+++ a/arch/riscv/mm/cacheflush.c
@@ -82,18 +82,11 @@ void flush_icache_mm(struct mm_struct *m
 #ifdef CONFIG_MMU
 void flush_icache_pte(pte_t pte)
 {
-	struct page *page = pte_page(pte);
+	struct folio *folio = page_folio(pte_page(pte));
 
-	/*
-	 * HugeTLB pages are always fully mapped, so only setting head page's
-	 * PG_dcache_clean flag is enough.
-	 */
-	if (PageHuge(page))
-		page = compound_head(page);
-
-	if (!test_bit(PG_dcache_clean, &page->flags)) {
+	if (!test_bit(PG_dcache_clean, &folio->flags)) {
 		flush_icache_all();
-		set_bit(PG_dcache_clean, &page->flags);
+		set_bit(PG_dcache_clean, &folio->flags);
 	}
 }
 #endif /* CONFIG_MMU */
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

