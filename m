Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A703EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjGJXbU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjGJXbR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:31:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C60E99
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF02B61295
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20762C433CA;
        Mon, 10 Jul 2023 23:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031875;
        bh=o62a9lDiZi6Kcr+6rh/ORVux7w4KUo3CKLTUcbN7EOo=;
        h=Date:To:From:Subject:From;
        b=fy/c8UBGIZJeDAvWrC/190T4BhmuStgOiyf47gtsRJ5fST8UkULdzClBNqhZJdLA5
         ppc0wu/Gcfd+kK9fDZQZHuKtwVKJ/6ewYjNtqW/8hFOaVcNWXiwhSbCCeaCYp4EOYK
         QNSAv8kekgLWy7IajFZ/veTiIAAmGUoBnJ1N8Y9Y=
Date:   Mon, 10 Jul 2023 16:31:14 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jcmvbkbc@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233115.20762C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-implement-the-new-page-table-range-api.patch

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
Subject: xtensa: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:30 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range(), flush_dcache_folio() and
flush_icache_pages().

Link: https://lkml.kernel.org/r/20230710204339.3554919-30-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/cacheflush.h |    9 ++
 arch/xtensa/include/asm/pgtable.h    |   18 ++---
 arch/xtensa/mm/cache.c               |   83 ++++++++++++++-----------
 3 files changed, 63 insertions(+), 47 deletions(-)

--- a/arch/xtensa/include/asm/cacheflush.h~xtensa-implement-the-new-page-table-range-api
+++ a/arch/xtensa/include/asm/cacheflush.h
@@ -119,8 +119,14 @@ void flush_cache_page(struct vm_area_str
 #define flush_cache_vmap(start,end)	flush_cache_all()
 #define flush_cache_vunmap(start,end)	flush_cache_all()
 
+void flush_dcache_folio(struct folio *folio);
+#define flush_dcache_folio flush_dcache_folio
+
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
-void flush_dcache_page(struct page *);
+static inline void flush_dcache_page(struct page *page)
+{
+	flush_dcache_folio(page_folio(page));
+}
 
 void local_flush_cache_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end);
@@ -156,6 +162,7 @@ void local_flush_cache_page(struct vm_ar
 
 /* This is not required, see Documentation/core-api/cachetlb.rst */
 #define	flush_icache_page(vma,page)			do { } while (0)
+#define	flush_icache_pages(vma, page, nr)		do { } while (0)
 
 #define flush_dcache_mmap_lock(mapping)			do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)		do { } while (0)
--- a/arch/xtensa/include/asm/pgtable.h~xtensa-implement-the-new-page-table-range-api
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -274,6 +274,7 @@ static inline pte_t pte_mkwrite(pte_t pt
  * and a page entry and page directory to the page they refer to.
  */
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
 #define pte_same(a,b)		(pte_val(a) == pte_val(b))
 #define pte_page(x)		pfn_to_page(pte_pfn(x))
@@ -301,15 +302,9 @@ static inline void update_pte(pte_t *pte
 
 struct mm_struct;
 
-static inline void
-set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pteval)
-{
-	update_pte(ptep, pteval);
-}
-
-static inline void set_pte(pte_t *ptep, pte_t pteval)
+static inline void set_pte(pte_t *ptep, pte_t pte)
 {
-	update_pte(ptep, pteval);
+	update_pte(ptep, pte);
 }
 
 static inline void
@@ -407,8 +402,11 @@ static inline pte_t pte_swp_clear_exclus
 
 #else
 
-extern  void update_mmu_cache(struct vm_area_struct * vma,
-			      unsigned long address, pte_t *ptep);
+struct vm_fault;
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep, unsigned int nr);
+#define update_mmu_cache(vma, address, ptep) \
+	update_mmu_cache_range(NULL, vma, address, ptep, 1)
 
 typedef pte_t *pte_addr_t;
 
--- a/arch/xtensa/mm/cache.c~xtensa-implement-the-new-page-table-range-api
+++ a/arch/xtensa/mm/cache.c
@@ -121,9 +121,9 @@ EXPORT_SYMBOL(copy_user_highpage);
  *
  */
 
-void flush_dcache_page(struct page *page)
+void flush_dcache_folio(struct folio *folio)
 {
-	struct address_space *mapping = page_mapping_file(page);
+	struct address_space *mapping = folio_flush_mapping(folio);
 
 	/*
 	 * If we have a mapping but the page is not mapped to user-space
@@ -132,14 +132,14 @@ void flush_dcache_page(struct page *page
 	 */
 
 	if (mapping && !mapping_mapped(mapping)) {
-		if (!test_bit(PG_arch_1, &page->flags))
-			set_bit(PG_arch_1, &page->flags);
+		if (!test_bit(PG_arch_1, &folio->flags))
+			set_bit(PG_arch_1, &folio->flags);
 		return;
 
 	} else {
-
-		unsigned long phys = page_to_phys(page);
-		unsigned long temp = page->index << PAGE_SHIFT;
+		unsigned long phys = folio_pfn(folio) * PAGE_SIZE;
+		unsigned long temp = folio_pos(folio);
+		unsigned int i, nr = folio_nr_pages(folio);
 		unsigned long alias = !(DCACHE_ALIAS_EQ(temp, phys));
 		unsigned long virt;
 
@@ -154,22 +154,26 @@ void flush_dcache_page(struct page *page
 			return;
 
 		preempt_disable();
-		virt = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
-		__flush_invalidate_dcache_page_alias(virt, phys);
+		for (i = 0; i < nr; i++) {
+			virt = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
+			__flush_invalidate_dcache_page_alias(virt, phys);
 
-		virt = TLBTEMP_BASE_1 + (temp & DCACHE_ALIAS_MASK);
+			virt = TLBTEMP_BASE_1 + (temp & DCACHE_ALIAS_MASK);
 
-		if (alias)
-			__flush_invalidate_dcache_page_alias(virt, phys);
+			if (alias)
+				__flush_invalidate_dcache_page_alias(virt, phys);
 
-		if (mapping)
-			__invalidate_icache_page_alias(virt, phys);
+			if (mapping)
+				__invalidate_icache_page_alias(virt, phys);
+			phys += PAGE_SIZE;
+			temp += PAGE_SIZE;
+		}
 		preempt_enable();
 	}
 
 	/* There shouldn't be an entry in the cache for this page anymore. */
 }
-EXPORT_SYMBOL(flush_dcache_page);
+EXPORT_SYMBOL(flush_dcache_folio);
 
 /*
  * For now, flush the whole cache. FIXME??
@@ -207,45 +211,52 @@ EXPORT_SYMBOL(local_flush_cache_page);
 
 #endif /* DCACHE_WAY_SIZE > PAGE_SIZE */
 
-void
-update_mmu_cache(struct vm_area_struct * vma, unsigned long addr, pte_t *ptep)
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	unsigned long pfn = pte_pfn(*ptep);
-	struct page *page;
+	struct folio *folio;
+	unsigned int i;
 
 	if (!pfn_valid(pfn))
 		return;
 
-	page = pfn_to_page(pfn);
-
-	/* Invalidate old entry in TLBs */
+	folio = page_folio(pfn_to_page(pfn));
 
-	flush_tlb_page(vma, addr);
+	/* Invalidate old entries in TLBs */
+	for (i = 0; i < nr; i++)
+		flush_tlb_page(vma, addr + i * PAGE_SIZE);
+	nr = folio_nr_pages(folio);
 
 #if (DCACHE_WAY_SIZE > PAGE_SIZE)
 
-	if (!PageReserved(page) && test_bit(PG_arch_1, &page->flags)) {
-		unsigned long phys = page_to_phys(page);
+	if (!folio_test_reserved(folio) && test_bit(PG_arch_1, &folio->flags)) {
+		unsigned long phys = folio_pfn(folio) * PAGE_SIZE;
 		unsigned long tmp;
 
 		preempt_disable();
-		tmp = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
-		__flush_invalidate_dcache_page_alias(tmp, phys);
-		tmp = TLBTEMP_BASE_1 + (addr & DCACHE_ALIAS_MASK);
-		__flush_invalidate_dcache_page_alias(tmp, phys);
-		__invalidate_icache_page_alias(tmp, phys);
+		for (i = 0; i < nr; i++) {
+			tmp = TLBTEMP_BASE_1 + (phys & DCACHE_ALIAS_MASK);
+			__flush_invalidate_dcache_page_alias(tmp, phys);
+			tmp = TLBTEMP_BASE_1 + (addr & DCACHE_ALIAS_MASK);
+			__flush_invalidate_dcache_page_alias(tmp, phys);
+			__invalidate_icache_page_alias(tmp, phys);
+			phys += PAGE_SIZE;
+		}
 		preempt_enable();
 
-		clear_bit(PG_arch_1, &page->flags);
+		clear_bit(PG_arch_1, &folio->flags);
 	}
 #else
-	if (!PageReserved(page) && !test_bit(PG_arch_1, &page->flags)
+	if (!folio_test_reserved(folio) && !test_bit(PG_arch_1, &folio->flags)
 	    && (vma->vm_flags & VM_EXEC) != 0) {
-		unsigned long paddr = (unsigned long)kmap_atomic(page);
-		__flush_dcache_page(paddr);
-		__invalidate_icache_page(paddr);
-		set_bit(PG_arch_1, &page->flags);
-		kunmap_atomic((void *)paddr);
+		for (i = 0; i < nr; i++) {
+			void *paddr = kmap_local_folio(folio, i * PAGE_SIZE);
+			__flush_dcache_page((unsigned long)paddr);
+			__invalidate_icache_page((unsigned long)paddr);
+			kunmap_local(paddr);
+		}
+		set_bit(PG_arch_1, &folio->flags);
 	}
 #endif
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

