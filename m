Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2CAC727A5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244112AbjHXXWN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244057AbjHXXVn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0614FB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595DB64B19
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F2FC433C7;
        Thu, 24 Aug 2023 23:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919292;
        bh=WcBEZaBm1iZPAt7Z1ynWy//sr6bf7iQHsWef58idcP8=;
        h=Date:To:From:Subject:From;
        b=bSdIxVY1jzDLEY11txnPkOdfxeyOapWOvSwn3vjvCGycjx9BvaBPzSwbbj3vY9hql
         C/b05EDSsJIilbz94o/HwKEkXqOmo2aqAchfcO6MmRsgu4dmoIK5+HBN4IWgUNw6MQ
         q4ezgrPKkVAnNysAGF/JBGHdV0AUNmGDzbXzvodU=
Date:   Thu, 24 Aug 2023 16:21:32 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, dinguyen@kernel.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232132.B0F2FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     nios2-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nios2: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:46 +0100

Add set_ptes(), update_mmu_cache_range(), flush_icache_pages() and
flush_dcache_folio().  Change the PG_arch_1 (aka PG_dcache_dirty) flag
from being per-page to per-folio.

Link: https://lkml.kernel.org/r/20230802151406.3735276-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/include/asm/cacheflush.h |    6 +
 arch/nios2/include/asm/pgtable.h    |   26 +++++---
 arch/nios2/mm/cacheflush.c          |   81 ++++++++++++++------------
 3 files changed, 67 insertions(+), 46 deletions(-)

--- a/arch/nios2/include/asm/cacheflush.h~nios2-implement-the-new-page-table-range-api
+++ a/arch/nios2/include/asm/cacheflush.h
@@ -29,9 +29,13 @@ extern void flush_cache_page(struct vm_a
 	unsigned long pfn);
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 void flush_dcache_page(struct page *page);
+void flush_dcache_folio(struct folio *folio);
+#define flush_dcache_folio flush_dcache_folio
 
 extern void flush_icache_range(unsigned long start, unsigned long end);
-extern void flush_icache_page(struct vm_area_struct *vma, struct page *page);
+void flush_icache_pages(struct vm_area_struct *vma, struct page *page,
+		unsigned int nr);
+#define flush_icache_page(vma, page) flush_icache_pages(vma, page, 1);
 
 #define flush_cache_vmap(start, end)		flush_dcache_range(start, end)
 #define flush_cache_vunmap(start, end)		flush_dcache_range(start, end)
--- a/arch/nios2/include/asm/pgtable.h~nios2-implement-the-new-page-table-range-api
+++ a/arch/nios2/include/asm/pgtable.h
@@ -178,14 +178,21 @@ static inline void set_pte(pte_t *ptep,
 	*ptep = pteval;
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
+static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	unsigned long paddr = (unsigned long)page_to_virt(pte_page(pteval));
+	unsigned long paddr = (unsigned long)page_to_virt(pte_page(pte));
 
-	flush_dcache_range(paddr, paddr + PAGE_SIZE);
-	set_pte(ptep, pteval);
+	flush_dcache_range(paddr, paddr + nr * PAGE_SIZE);
+	for (;;) {
+		set_pte(ptep, pte);
+		if (--nr == 0)
+			break;
+		ptep++;
+		pte_val(pte) += 1;
+	}
 }
+#define set_ptes set_ptes
 
 static inline int pmd_none(pmd_t pmd)
 {
@@ -202,7 +209,7 @@ static inline void pte_clear(struct mm_s
 
 	pte_val(null) = (addr >> PAGE_SHIFT) & 0xf;
 
-	set_pte_at(mm, addr, ptep, null);
+	set_pte(ptep, null);
 }
 
 /*
@@ -273,7 +280,10 @@ static inline pte_t pte_swp_clear_exclus
 extern void __init paging_init(void);
 extern void __init mmu_init(void);
 
-extern void update_mmu_cache(struct vm_area_struct *vma,
-			     unsigned long address, pte_t *pte);
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep, unsigned int nr);
+
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
 #endif /* _ASM_NIOS2_PGTABLE_H */
--- a/arch/nios2/mm/cacheflush.c~nios2-implement-the-new-page-table-range-api
+++ a/arch/nios2/mm/cacheflush.c
@@ -71,26 +71,26 @@ static void __flush_icache(unsigned long
 	__asm__ __volatile(" flushp\n");
 }
 
-static void flush_aliases(struct address_space *mapping, struct page *page)
+static void flush_aliases(struct address_space *mapping, struct folio *folio)
 {
 	struct mm_struct *mm = current->active_mm;
-	struct vm_area_struct *mpnt;
+	struct vm_area_struct *vma;
 	pgoff_t pgoff;
+	unsigned long nr = folio_nr_pages(folio);
 
-	pgoff = page->index;
+	pgoff = folio->index;
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_foreach(mpnt, &mapping->i_mmap, pgoff, pgoff) {
-		unsigned long offset;
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff + nr - 1) {
+		unsigned long start;
 
-		if (mpnt->vm_mm != mm)
+		if (vma->vm_mm != mm)
 			continue;
-		if (!(mpnt->vm_flags & VM_MAYSHARE))
+		if (!(vma->vm_flags & VM_MAYSHARE))
 			continue;
 
-		offset = (pgoff - mpnt->vm_pgoff) << PAGE_SHIFT;
-		flush_cache_page(mpnt, mpnt->vm_start + offset,
-			page_to_pfn(page));
+		start = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		flush_cache_range(vma, start, start + nr * PAGE_SIZE);
 	}
 	flush_dcache_mmap_unlock(mapping);
 }
@@ -138,10 +138,11 @@ void flush_cache_range(struct vm_area_st
 		__flush_icache(start, end);
 }
 
-void flush_icache_page(struct vm_area_struct *vma, struct page *page)
+void flush_icache_pages(struct vm_area_struct *vma, struct page *page,
+		unsigned int nr)
 {
 	unsigned long start = (unsigned long) page_address(page);
-	unsigned long end = start + PAGE_SIZE;
+	unsigned long end = start + nr * PAGE_SIZE;
 
 	__flush_dcache(start, end);
 	__flush_icache(start, end);
@@ -158,19 +159,19 @@ void flush_cache_page(struct vm_area_str
 		__flush_icache(start, end);
 }
 
-void __flush_dcache_page(struct address_space *mapping, struct page *page)
+static void __flush_dcache_folio(struct folio *folio)
 {
 	/*
 	 * Writeback any data associated with the kernel mapping of this
 	 * page.  This ensures that data in the physical page is mutually
 	 * coherent with the kernels mapping.
 	 */
-	unsigned long start = (unsigned long)page_address(page);
+	unsigned long start = (unsigned long)folio_address(folio);
 
-	__flush_dcache(start, start + PAGE_SIZE);
+	__flush_dcache(start, start + folio_size(folio));
 }
 
-void flush_dcache_page(struct page *page)
+void flush_dcache_folio(struct folio *folio)
 {
 	struct address_space *mapping;
 
@@ -178,32 +179,38 @@ void flush_dcache_page(struct page *page
 	 * The zero page is never written to, so never has any dirty
 	 * cache lines, and therefore never needs to be flushed.
 	 */
-	if (page == ZERO_PAGE(0))
+	if (is_zero_pfn(folio_pfn(folio)))
 		return;
 
-	mapping = page_mapping_file(page);
+	mapping = folio_flush_mapping(folio);
 
 	/* Flush this page if there are aliases. */
 	if (mapping && !mapping_mapped(mapping)) {
-		clear_bit(PG_dcache_clean, &page->flags);
+		clear_bit(PG_dcache_clean, &folio->flags);
 	} else {
-		__flush_dcache_page(mapping, page);
+		__flush_dcache_folio(folio);
 		if (mapping) {
-			unsigned long start = (unsigned long)page_address(page);
-			flush_aliases(mapping,  page);
-			flush_icache_range(start, start + PAGE_SIZE);
+			unsigned long start = (unsigned long)folio_address(folio);
+			flush_aliases(mapping, folio);
+			flush_icache_range(start, start + folio_size(folio));
 		}
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
 
-void update_mmu_cache(struct vm_area_struct *vma,
-		      unsigned long address, pte_t *ptep)
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep, unsigned int nr)
 {
 	pte_t pte = *ptep;
 	unsigned long pfn = pte_pfn(pte);
-	struct page *page;
+	struct folio *folio;
 	struct address_space *mapping;
 
 	reload_tlb_page(vma, address, pte);
@@ -215,19 +222,19 @@ void update_mmu_cache(struct vm_area_str
 	* The zero page is never written to, so never has any dirty
 	* cache lines, and therefore never needs to be flushed.
 	*/
-	page = pfn_to_page(pfn);
-	if (page == ZERO_PAGE(0))
+	if (is_zero_pfn(pfn))
 		return;
 
-	mapping = page_mapping_file(page);
-	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
-		__flush_dcache_page(mapping, page);
-
-	if(mapping)
-	{
-		flush_aliases(mapping, page);
+	folio = page_folio(pfn_to_page(pfn));
+	if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
+		__flush_dcache_folio(folio);
+
+	mapping = folio_flush_mapping(folio);
+	if (mapping) {
+		flush_aliases(mapping, folio);
 		if (vma->vm_flags & VM_EXEC)
-			flush_icache_page(vma, page);
+			flush_icache_pages(vma, &folio->page,
+					folio_nr_pages(folio));
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are


