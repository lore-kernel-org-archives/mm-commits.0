Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9FDEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjGJXaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjGJXaF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758381BB
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04B3561268
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9FFC433C7;
        Mon, 10 Jul 2023 23:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031802;
        bh=t73VY3jWAMHHGfqfpumFqg9g2fF5ZGMrexXSY0uHGQI=;
        h=Date:To:From:Subject:From;
        b=0pBS4jXBWptJTwgnY/g5B53pvjTCc9nB5koCXW556/vwWGTrKtxcEuosTvy8ji0BD
         MVtO3Hlayg9+s3r+fE0zmLr/3MYHuf1oaUPSM4XXMKnVoaZsYCxE8g2T+NBepBy4y2
         8vTYIrAe6pYj1sGquyjeS6jx/6UGadZKxRq3vZp4=
Date:   Mon, 10 Jul 2023 16:30:01 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, guoren@kernel.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + csky-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233002.4F9FFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: csky: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     csky-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/csky-implement-the-new-page-table-range-api.patch

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
Subject: csky: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:12 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range() and flush_dcache_folio(). 
Change the PG_dcache_clean flag from being per-page to per-folio.

Link: https://lkml.kernel.org/r/20230710204339.3554919-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Guo Ren <guoren@kernel.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/abiv1/cacheflush.c         |   32 +++++++++++++----------
 arch/csky/abiv1/inc/abi/cacheflush.h |    2 +
 arch/csky/abiv2/cacheflush.c         |   34 ++++++++++++-------------
 arch/csky/abiv2/inc/abi/cacheflush.h |   10 +++++--
 arch/csky/include/asm/pgtable.h      |    8 +++--
 5 files changed, 51 insertions(+), 35 deletions(-)

--- a/arch/csky/abiv1/cacheflush.c~csky-implement-the-new-page-table-range-api
+++ a/arch/csky/abiv1/cacheflush.c
@@ -15,45 +15,51 @@
 
 #define PG_dcache_clean		PG_arch_1
 
-void flush_dcache_page(struct page *page)
+void flush_dcache_folio(struct folio *folio)
 {
 	struct address_space *mapping;
 
-	if (page == ZERO_PAGE(0))
+	if (is_zero_pfn(folio_pfn(folio)))
 		return;
 
-	mapping = page_mapping_file(page);
+	mapping = folio_flush_mapping(folio);
 
-	if (mapping && !page_mapcount(page))
-		clear_bit(PG_dcache_clean, &page->flags);
+	if (mapping && !folio_mapped(folio))
+		clear_bit(PG_dcache_clean, &folio->flags);
 	else {
 		dcache_wbinv_all();
 		if (mapping)
 			icache_inv_all();
-		set_bit(PG_dcache_clean, &page->flags);
+		set_bit(PG_dcache_clean, &folio->flags);
 	}
 }
+EXPORT_SYMBOL(flush_dcache_folio);
+
+void flush_dcache_page(struct page *page)
+{
+	flush_dcache_folio(page_folio(page));
+}
 EXPORT_SYMBOL(flush_dcache_page);
 
-void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr,
-	pte_t *ptep)
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	unsigned long pfn = pte_pfn(*ptep);
-	struct page *page;
+	struct folio *folio;
 
 	flush_tlb_page(vma, addr);
 
 	if (!pfn_valid(pfn))
 		return;
 
-	page = pfn_to_page(pfn);
-	if (page == ZERO_PAGE(0))
+	if (is_zero_pfn(pfn))
 		return;
 
-	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
+	folio = page_folio(pfn_to_page(pfn));
+	if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
 		dcache_wbinv_all();
 
-	if (page_mapping_file(page)) {
+	if (folio_flush_mapping(folio)) {
 		if (vma->vm_flags & VM_EXEC)
 			icache_inv_all();
 	}
--- a/arch/csky/abiv1/inc/abi/cacheflush.h~csky-implement-the-new-page-table-range-api
+++ a/arch/csky/abiv1/inc/abi/cacheflush.h
@@ -9,6 +9,8 @@
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *);
+void flush_dcache_folio(struct folio *);
+#define flush_dcache_folio flush_dcache_folio
 
 #define flush_cache_mm(mm)			dcache_wbinv_all()
 #define flush_cache_page(vma, page, pfn)	cache_wbinv_all()
--- a/arch/csky/abiv2/cacheflush.c~csky-implement-the-new-page-table-range-api
+++ a/arch/csky/abiv2/cacheflush.c
@@ -7,32 +7,32 @@
 #include <asm/cache.h>
 #include <asm/tlbflush.h>
 
-void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
-		      pte_t *pte)
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long address, pte_t *pte, unsigned int nr)
 {
-	unsigned long addr;
-	struct page *page;
+	unsigned long pfn = pte_pfn(*pte);
+	struct folio *folio;
+	unsigned int i;
 
 	flush_tlb_page(vma, address);
 
-	if (!pfn_valid(pte_pfn(*pte)))
+	if (!pfn_valid(pfn))
 		return;
 
-	page = pfn_to_page(pte_pfn(*pte));
-	if (page == ZERO_PAGE(0))
-		return;
+	folio = page_folio(pfn_to_page(pfn));
 
-	if (test_and_set_bit(PG_dcache_clean, &page->flags))
+	if (test_and_set_bit(PG_dcache_clean, &folio->flags))
 		return;
 
-	addr = (unsigned long) kmap_atomic(page);
-
-	dcache_wb_range(addr, addr + PAGE_SIZE);
-
-	if (vma->vm_flags & VM_EXEC)
-		icache_inv_range(addr, addr + PAGE_SIZE);
-
-	kunmap_atomic((void *) addr);
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		unsigned long addr = (unsigned long) kmap_local_folio(folio,
+								i * PAGE_SIZE);
+
+		dcache_wb_range(addr, addr + PAGE_SIZE);
+		if (vma->vm_flags & VM_EXEC)
+			icache_inv_range(addr, addr + PAGE_SIZE);
+		kunmap_local((void *) addr);
+	}
 }
 
 void flush_icache_deferred(struct mm_struct *mm)
--- a/arch/csky/abiv2/inc/abi/cacheflush.h~csky-implement-the-new-page-table-range-api
+++ a/arch/csky/abiv2/inc/abi/cacheflush.h
@@ -18,11 +18,17 @@
 
 #define PG_dcache_clean		PG_arch_1
 
+static inline void flush_dcache_folio(struct folio *folio)
+{
+	if (test_bit(PG_dcache_clean, &folio->flags))
+		clear_bit(PG_dcache_clean, &folio->flags);
+}
+#define flush_dcache_folio flush_dcache_folio
+
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_page(struct page *page)
 {
-	if (test_bit(PG_dcache_clean, &page->flags))
-		clear_bit(PG_dcache_clean, &page->flags);
+	flush_dcache_folio(page_folio(page));
 }
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
--- a/arch/csky/include/asm/pgtable.h~csky-implement-the-new-page-table-range-api
+++ a/arch/csky/include/asm/pgtable.h
@@ -28,6 +28,7 @@
 #define pgd_ERROR(e) \
 	pr_err("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
 
+#define PFN_PTE_SHIFT	PAGE_SHIFT
 #define pmd_pfn(pmd)	(pmd_phys(pmd) >> PAGE_SHIFT)
 #define pmd_page(pmd)	(pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
 #define pte_clear(mm, addr, ptep)	set_pte((ptep), \
@@ -90,7 +91,6 @@ static inline void set_pte(pte_t *p, pte
 	/* prevent out of order excution */
 	smp_mb();
 }
-#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 {
@@ -263,8 +263,10 @@ static inline pte_t pte_modify(pte_t pte
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern void paging_init(void);
 
-void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
-		      pte_t *pte);
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long address, pte_t *pte, unsigned int nr);
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
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

