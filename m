Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1547EEE49BC
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244037AbjHXXV6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244035AbjHXXV2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2CC10D
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4373263778
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D342C433C8;
        Thu, 24 Aug 2023 23:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919284;
        bh=NHj17UoEJBhhgTEY/j8erlspH2L4a2Csnc2gjNX3xtI=;
        h=Date:To:From:Subject:From;
        b=HXkP8XmQFGqE7nPO5KnxFA4JBa+8aV+HxeQQqFzCMmS1pKP0pThd9N0fuO0ZyPjDE
         Mdg+YyVlA6FmaeRYzBZexCqbItP7PYwEG5zh0NGBtXvdEZ8XUeXg5846LOYdlAyRmE
         EkiHaBYMVIht4gL74dsznWLGx4rsPfX3Zstocdxc=
Date:   Thu, 24 Aug 2023 16:21:24 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, guoren@kernel.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232124.9D342C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: csky: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     csky-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: csky: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:39 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range() and flush_dcache_folio().
Change the PG_dcache_clean flag from being per-page to per-folio.

Link: https://lkml.kernel.org/r/20230802151406.3735276-12-willy@infradead.org
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


