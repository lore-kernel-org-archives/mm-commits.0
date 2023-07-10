Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FC8EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjGJXbE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjGJXbE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:31:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21D2AF
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ECEB61252
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AF4C433C8;
        Mon, 10 Jul 2023 23:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031861;
        bh=iyemwxHZN0MB5Yx2lQopMs29FCfui9daQHX0//7UKzY=;
        h=Date:To:From:Subject:From;
        b=iPTZmTFYwT6sDutJ3GNzIYXegwkFzOf1qTka6KnCmaNfe3uV9s6GnDI1cTcQ47idz
         c5Z0Ml1BYPTUZGDCX4azAIao/jH1Me+Bt2Otyz5Wy7UtLNidv8KT95uh9JD/TXlwVw
         8IfPoYWSiK2pxzjIIXgnRpUCQsQorN8pfzvKfNZI=
Date:   Mon, 10 Jul 2023 16:31:00 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, davem@davemloft.net,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc32-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233101.93AF4C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc32: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     sparc32-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc32-implement-the-new-page-table-range-api.patch

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
Subject: sparc32: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:26 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range(), flush_dcache_folio() and
flush_icache_pages().

Link: https://lkml.kernel.org/r/20230710204339.3554919-26-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/cacheflush_32.h |    9 +++++++--
 arch/sparc/include/asm/pgtable_32.h    |    8 ++++----
 arch/sparc/mm/init_32.c                |   13 +++++++++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

--- a/arch/sparc/include/asm/cacheflush_32.h~sparc32-implement-the-new-page-table-range-api
+++ a/arch/sparc/include/asm/cacheflush_32.h
@@ -16,6 +16,7 @@
 	sparc32_cachetlb_ops->cache_page(vma, addr)
 #define flush_icache_range(start, end)		do { } while (0)
 #define flush_icache_page(vma, pg)		do { } while (0)
+#define flush_icache_pages(vma, pg, nr)		do { } while (0)
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
 	do {							\
@@ -35,11 +36,15 @@
 #define flush_page_for_dma(addr) \
 	sparc32_cachetlb_ops->page_for_dma(addr)
 
-struct page;
 void sparc_flush_page_to_ram(struct page *page);
+void sparc_flush_folio_to_ram(struct folio *folio);
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
-#define flush_dcache_page(page)			sparc_flush_page_to_ram(page)
+#define flush_dcache_folio(folio)		sparc_flush_folio_to_ram(folio)
+static inline void flush_dcache_page(struct page *page)
+{
+	flush_dcache_folio(page_folio(page));
+}
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
--- a/arch/sparc/include/asm/pgtable_32.h~sparc32-implement-the-new-page-table-range-api
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -101,8 +101,6 @@ static inline void set_pte(pte_t *ptep,
 	srmmu_swap((unsigned long *)ptep, pte_val(pteval));
 }
 
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
-
 static inline int srmmu_device_memory(unsigned long x)
 {
 	return ((x & 0xF0000000) != 0);
@@ -256,6 +254,7 @@ static inline pte_t pte_mkyoung(pte_t pt
 	return __pte(pte_val(pte) | SRMMU_REF);
 }
 
+#define PFN_PTE_SHIFT			(PAGE_SHIFT - 4)
 #define pfn_pte(pfn, prot)		mk_pte(pfn_to_page(pfn), prot)
 
 static inline unsigned long pte_pfn(pte_t pte)
@@ -268,7 +267,7 @@ static inline unsigned long pte_pfn(pte_
 		 */
 		return ~0UL;
 	}
-	return (pte_val(pte) & SRMMU_PTE_PMASK) >> (PAGE_SHIFT-4);
+	return (pte_val(pte) & SRMMU_PTE_PMASK) >> PFN_PTE_SHIFT;
 }
 
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
@@ -318,6 +317,7 @@ void mmu_info(struct seq_file *m);
 #define FAULT_CODE_USER     0x4
 
 #define update_mmu_cache(vma, address, ptep) do { } while (0)
+#define update_mmu_cache_range(vmf, vma, address, ptep, nr) do { } while (0)
 
 void srmmu_mapiorange(unsigned int bus, unsigned long xpa,
                       unsigned long xva, unsigned int len);
@@ -422,7 +422,7 @@ static inline int io_remap_pfn_range(str
 ({									  \
 	int __changed = !pte_same(*(__ptep), __entry);			  \
 	if (__changed) {						  \
-		set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry); \
+		set_pte(__ptep, __entry);				  \
 		flush_tlb_page(__vma, __address);			  \
 	}								  \
 	__changed;							  \
--- a/arch/sparc/mm/init_32.c~sparc32-implement-the-new-page-table-range-api
+++ a/arch/sparc/mm/init_32.c
@@ -297,11 +297,20 @@ void sparc_flush_page_to_ram(struct page
 {
 	unsigned long vaddr = (unsigned long)page_address(page);
 
-	if (vaddr)
-		__flush_page_to_ram(vaddr);
+	__flush_page_to_ram(vaddr);
 }
 EXPORT_SYMBOL(sparc_flush_page_to_ram);
 
+void sparc_flush_folio_to_ram(struct folio *folio)
+{
+	unsigned long vaddr = (unsigned long)folio_address(folio);
+	unsigned int i, nr = folio_nr_pages(folio);
+
+	for (i = 0; i < nr; i++)
+		__flush_page_to_ram(vaddr + i * PAGE_SIZE);
+}
+EXPORT_SYMBOL(sparc_flush_folio_to_ram);
+
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= PAGE_NONE,
 	[VM_READ]					= PAGE_READONLY,
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

