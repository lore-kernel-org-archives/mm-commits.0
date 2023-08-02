Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22C8C04FE0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjHBSxP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjHBSwz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:52:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DC6E6F
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AABAE61A7C
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C00C433C7;
        Wed,  2 Aug 2023 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691002372;
        bh=VvnGcgWhqUYmRhs+q9RBl3vtSkZDOKJgsGDJTlHgteI=;
        h=Date:To:From:Subject:From;
        b=USXnH6OkanpqRUK8YQUnajWleqUbCHRJ4qSUv/SyMKIfoVgfw/0QEu+AWNAyHQTS9
         kxtVzBHXc1ITcKFx2eXvynIuvIQFJ/H6aSXVBSajYV+KqZ5usRsZJK7lFwk06wdkVD
         3k5/wOxHfujhFXGhRj5pjJ2BBM8k5iW+LJ5DIRqo=
Date:   Wed, 02 Aug 2023 11:52:51 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        rppt@kernel.org, glaubitz@physik.fu-berlin.de, dalias@libc.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230802185252.09C00C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     sh-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-implement-the-new-page-table-range-api.patch

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
Subject: sh: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:52 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range(), flush_dcache_folio() and
flush_icache_pages().  Change the PG_dcache_clean flag from being per-page
to per-folio.  Flush the entire folio containing the pages in
flush_icache_pages() for ease of implementation.

Link: https://lkml.kernel.org/r/20230802151406.3735276-25-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/cacheflush.h |   21 +++++++----
 arch/sh/include/asm/pgtable.h    |    7 ++-
 arch/sh/include/asm/pgtable_32.h |    5 +-
 arch/sh/mm/cache-j2.c            |    4 +-
 arch/sh/mm/cache-sh4.c           |   26 ++++++++++----
 arch/sh/mm/cache-sh7705.c        |   26 ++++++++------
 arch/sh/mm/cache.c               |   52 ++++++++++++++++-------------
 arch/sh/mm/kmap.c                |    3 +
 8 files changed, 89 insertions(+), 55 deletions(-)

--- a/arch/sh/include/asm/cacheflush.h~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/include/asm/cacheflush.h
@@ -13,9 +13,9 @@
  *  - flush_cache_page(mm, vmaddr, pfn) flushes a single page
  *  - flush_cache_range(vma, start, end) flushes a range of pages
  *
- *  - flush_dcache_page(pg) flushes(wback&invalidates) a page for dcache
+ *  - flush_dcache_folio(folio) flushes(wback&invalidates) a folio for dcache
  *  - flush_icache_range(start, end) flushes(invalidates) a range for icache
- *  - flush_icache_page(vma, pg) flushes(invalidates) a page for icache
+ *  - flush_icache_pages(vma, pg, nr) flushes(invalidates) pages for icache
  *  - flush_cache_sigtramp(vaddr) flushes the signal trampoline
  */
 extern void (*local_flush_cache_all)(void *args);
@@ -23,9 +23,9 @@ extern void (*local_flush_cache_mm)(void
 extern void (*local_flush_cache_dup_mm)(void *args);
 extern void (*local_flush_cache_page)(void *args);
 extern void (*local_flush_cache_range)(void *args);
-extern void (*local_flush_dcache_page)(void *args);
+extern void (*local_flush_dcache_folio)(void *args);
 extern void (*local_flush_icache_range)(void *args);
-extern void (*local_flush_icache_page)(void *args);
+extern void (*local_flush_icache_folio)(void *args);
 extern void (*local_flush_cache_sigtramp)(void *args);
 
 static inline void cache_noop(void *args) { }
@@ -42,11 +42,18 @@ extern void flush_cache_page(struct vm_a
 extern void flush_cache_range(struct vm_area_struct *vma,
 				 unsigned long start, unsigned long end);
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
-void flush_dcache_page(struct page *page);
+void flush_dcache_folio(struct folio *folio);
+#define flush_dcache_folio flush_dcache_folio
+static inline void flush_dcache_page(struct page *page)
+{
+	flush_dcache_folio(page_folio(page));
+}
+
 extern void flush_icache_range(unsigned long start, unsigned long end);
 #define flush_icache_user_range flush_icache_range
-extern void flush_icache_page(struct vm_area_struct *vma,
-				 struct page *page);
+void flush_icache_pages(struct vm_area_struct *vma, struct page *page,
+		unsigned int nr);
+#define flush_icache_page(vma, page) flush_icache_pages(vma, page, 1)
 extern void flush_cache_sigtramp(unsigned long address);
 
 struct flusher_data {
--- a/arch/sh/include/asm/pgtable_32.h~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -307,14 +307,13 @@ static inline void set_pte(pte_t *ptep,
 #define set_pte(pteptr, pteval) (*(pteptr) = pteval)
 #endif
 
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
-
 /*
  * (pmds are folded into pgds so this doesn't get actually called,
  * but the define is needed for a generic inline function.)
  */
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = pmdval)
 
+#define PFN_PTE_SHIFT	PAGE_SHIFT
 #define pfn_pte(pfn, prot) \
 	__pte(((unsigned long long)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot) \
@@ -323,7 +322,7 @@ static inline void set_pte(pte_t *ptep,
 #define pte_none(x)		(!pte_val(x))
 #define pte_present(x)		((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
-#define pte_clear(mm,addr,xp) do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+#define pte_clear(mm, addr, ptep) set_pte(ptep, __pte(0))
 
 #define pmd_none(x)	(!pmd_val(x))
 #define pmd_present(x)	(pmd_val(x))
--- a/arch/sh/include/asm/pgtable.h~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/include/asm/pgtable.h
@@ -102,13 +102,16 @@ extern void __update_cache(struct vm_are
 extern void __update_tlb(struct vm_area_struct *vma,
 			 unsigned long address, pte_t pte);
 
-static inline void
-update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
 {
 	pte_t pte = *ptep;
 	__update_cache(vma, address, pte);
 	__update_tlb(vma, address, pte);
 }
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern void paging_init(void);
--- a/arch/sh/mm/cache.c~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/mm/cache.c
@@ -20,9 +20,9 @@ void (*local_flush_cache_mm)(void *args)
 void (*local_flush_cache_dup_mm)(void *args) = cache_noop;
 void (*local_flush_cache_page)(void *args) = cache_noop;
 void (*local_flush_cache_range)(void *args) = cache_noop;
-void (*local_flush_dcache_page)(void *args) = cache_noop;
+void (*local_flush_dcache_folio)(void *args) = cache_noop;
 void (*local_flush_icache_range)(void *args) = cache_noop;
-void (*local_flush_icache_page)(void *args) = cache_noop;
+void (*local_flush_icache_folio)(void *args) = cache_noop;
 void (*local_flush_cache_sigtramp)(void *args) = cache_noop;
 
 void (*__flush_wback_region)(void *start, int size);
@@ -61,15 +61,17 @@ void copy_to_user_page(struct vm_area_st
 		       unsigned long vaddr, void *dst, const void *src,
 		       unsigned long len)
 {
-	if (boot_cpu_data.dcache.n_aliases && page_mapcount(page) &&
-	    test_bit(PG_dcache_clean, &page->flags)) {
+	struct folio *folio = page_folio(page);
+
+	if (boot_cpu_data.dcache.n_aliases && folio_mapped(folio) &&
+	    test_bit(PG_dcache_clean, &folio->flags)) {
 		void *vto = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(vto, src, len);
 		kunmap_coherent(vto);
 	} else {
 		memcpy(dst, src, len);
 		if (boot_cpu_data.dcache.n_aliases)
-			clear_bit(PG_dcache_clean, &page->flags);
+			clear_bit(PG_dcache_clean, &folio->flags);
 	}
 
 	if (vma->vm_flags & VM_EXEC)
@@ -80,27 +82,30 @@ void copy_from_user_page(struct vm_area_
 			 unsigned long vaddr, void *dst, const void *src,
 			 unsigned long len)
 {
+	struct folio *folio = page_folio(page);
+
 	if (boot_cpu_data.dcache.n_aliases && page_mapcount(page) &&
-	    test_bit(PG_dcache_clean, &page->flags)) {
+	    test_bit(PG_dcache_clean, &folio->flags)) {
 		void *vfrom = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(dst, vfrom, len);
 		kunmap_coherent(vfrom);
 	} else {
 		memcpy(dst, src, len);
 		if (boot_cpu_data.dcache.n_aliases)
-			clear_bit(PG_dcache_clean, &page->flags);
+			clear_bit(PG_dcache_clean, &folio->flags);
 	}
 }
 
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long vaddr, struct vm_area_struct *vma)
 {
+	struct folio *src = page_folio(from);
 	void *vfrom, *vto;
 
 	vto = kmap_atomic(to);
 
-	if (boot_cpu_data.dcache.n_aliases && page_mapcount(from) &&
-	    test_bit(PG_dcache_clean, &from->flags)) {
+	if (boot_cpu_data.dcache.n_aliases && folio_mapped(src) &&
+	    test_bit(PG_dcache_clean, &src->flags)) {
 		vfrom = kmap_coherent(from, vaddr);
 		copy_page(vto, vfrom);
 		kunmap_coherent(vfrom);
@@ -136,27 +141,28 @@ EXPORT_SYMBOL(clear_user_highpage);
 void __update_cache(struct vm_area_struct *vma,
 		    unsigned long address, pte_t pte)
 {
-	struct page *page;
 	unsigned long pfn = pte_pfn(pte);
 
 	if (!boot_cpu_data.dcache.n_aliases)
 		return;
 
-	page = pfn_to_page(pfn);
 	if (pfn_valid(pfn)) {
-		int dirty = !test_and_set_bit(PG_dcache_clean, &page->flags);
+		struct folio *folio = page_folio(pfn_to_page(pfn));
+		int dirty = !test_and_set_bit(PG_dcache_clean, &folio->flags);
 		if (dirty)
-			__flush_purge_region(page_address(page), PAGE_SIZE);
+			__flush_purge_region(folio_address(folio),
+						folio_size(folio));
 	}
 }
 
 void __flush_anon_page(struct page *page, unsigned long vmaddr)
 {
+	struct folio *folio = page_folio(page);
 	unsigned long addr = (unsigned long) page_address(page);
 
 	if (pages_do_alias(addr, vmaddr)) {
-		if (boot_cpu_data.dcache.n_aliases && page_mapcount(page) &&
-		    test_bit(PG_dcache_clean, &page->flags)) {
+		if (boot_cpu_data.dcache.n_aliases && folio_mapped(folio) &&
+		    test_bit(PG_dcache_clean, &folio->flags)) {
 			void *kaddr;
 
 			kaddr = kmap_coherent(page, vmaddr);
@@ -164,7 +170,8 @@ void __flush_anon_page(struct page *page
 			/* __flush_purge_region((void *)kaddr, PAGE_SIZE); */
 			kunmap_coherent(kaddr);
 		} else
-			__flush_purge_region((void *)addr, PAGE_SIZE);
+			__flush_purge_region(folio_address(folio),
+						folio_size(folio));
 	}
 }
 
@@ -215,11 +222,11 @@ void flush_cache_range(struct vm_area_st
 }
 EXPORT_SYMBOL(flush_cache_range);
 
-void flush_dcache_page(struct page *page)
+void flush_dcache_folio(struct folio *folio)
 {
-	cacheop_on_each_cpu(local_flush_dcache_page, page, 1);
+	cacheop_on_each_cpu(local_flush_dcache_folio, folio, 1);
 }
-EXPORT_SYMBOL(flush_dcache_page);
+EXPORT_SYMBOL(flush_dcache_folio);
 
 void flush_icache_range(unsigned long start, unsigned long end)
 {
@@ -233,10 +240,11 @@ void flush_icache_range(unsigned long st
 }
 EXPORT_SYMBOL(flush_icache_range);
 
-void flush_icache_page(struct vm_area_struct *vma, struct page *page)
+void flush_icache_pages(struct vm_area_struct *vma, struct page *page,
+		unsigned int nr)
 {
-	/* Nothing uses the VMA, so just pass the struct page along */
-	cacheop_on_each_cpu(local_flush_icache_page, page, 1);
+	/* Nothing uses the VMA, so just pass the folio along */
+	cacheop_on_each_cpu(local_flush_icache_folio, page_folio(page), 1);
 }
 
 void flush_cache_sigtramp(unsigned long address)
--- a/arch/sh/mm/cache-j2.c~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/mm/cache-j2.c
@@ -55,9 +55,9 @@ void __init j2_cache_init(void)
 	local_flush_cache_dup_mm = j2_flush_both;
 	local_flush_cache_page = j2_flush_both;
 	local_flush_cache_range = j2_flush_both;
-	local_flush_dcache_page = j2_flush_dcache;
+	local_flush_dcache_folio = j2_flush_dcache;
 	local_flush_icache_range = j2_flush_icache;
-	local_flush_icache_page = j2_flush_icache;
+	local_flush_icache_folio = j2_flush_icache;
 	local_flush_cache_sigtramp = j2_flush_icache;
 
 	pr_info("Initial J2 CCR is %.8x\n", __raw_readl(j2_ccr_base));
--- a/arch/sh/mm/cache-sh4.c~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/mm/cache-sh4.c
@@ -107,19 +107,29 @@ static inline void flush_cache_one(unsig
  * Write back & invalidate the D-cache of the page.
  * (To avoid "alias" issues)
  */
-static void sh4_flush_dcache_page(void *arg)
+static void sh4_flush_dcache_folio(void *arg)
 {
-	struct page *page = arg;
-	unsigned long addr = (unsigned long)page_address(page);
+	struct folio *folio = arg;
 #ifndef CONFIG_SMP
-	struct address_space *mapping = page_mapping_file(page);
+	struct address_space *mapping = folio_flush_mapping(folio);
 
 	if (mapping && !mapping_mapped(mapping))
-		clear_bit(PG_dcache_clean, &page->flags);
+		clear_bit(PG_dcache_clean, &folio->flags);
 	else
 #endif
-		flush_cache_one(CACHE_OC_ADDRESS_ARRAY |
-				(addr & shm_align_mask), page_to_phys(page));
+	{
+		unsigned long pfn = folio_pfn(folio);
+		unsigned long addr = (unsigned long)folio_address(folio);
+		unsigned int i, nr = folio_nr_pages(folio);
+
+		for (i = 0; i < nr; i++) {
+			flush_cache_one(CACHE_OC_ADDRESS_ARRAY |
+						(addr & shm_align_mask),
+					pfn * PAGE_SIZE);
+			addr += PAGE_SIZE;
+			pfn++;
+		}
+	}
 
 	wmb();
 }
@@ -379,7 +389,7 @@ void __init sh4_cache_init(void)
 		__raw_readl(CCN_PRR));
 
 	local_flush_icache_range	= sh4_flush_icache_range;
-	local_flush_dcache_page		= sh4_flush_dcache_page;
+	local_flush_dcache_folio	= sh4_flush_dcache_folio;
 	local_flush_cache_all		= sh4_flush_cache_all;
 	local_flush_cache_mm		= sh4_flush_cache_mm;
 	local_flush_cache_dup_mm	= sh4_flush_cache_mm;
--- a/arch/sh/mm/cache-sh7705.c~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/mm/cache-sh7705.c
@@ -132,15 +132,20 @@ static void __flush_dcache_page(unsigned
  * Write back & invalidate the D-cache of the page.
  * (To avoid "alias" issues)
  */
-static void sh7705_flush_dcache_page(void *arg)
+static void sh7705_flush_dcache_folio(void *arg)
 {
-	struct page *page = arg;
-	struct address_space *mapping = page_mapping_file(page);
+	struct folio *folio = arg;
+	struct address_space *mapping = folio_flush_mapping(folio);
 
 	if (mapping && !mapping_mapped(mapping))
-		clear_bit(PG_dcache_clean, &page->flags);
-	else
-		__flush_dcache_page(__pa(page_address(page)));
+		clear_bit(PG_dcache_clean, &folio->flags);
+	else {
+		unsigned long pfn = folio_pfn(folio);
+		unsigned int i, nr = folio_nr_pages(folio);
+
+		for (i = 0; i < nr; i++)
+			__flush_dcache_page((pfn + i) * PAGE_SIZE);
+	}
 }
 
 static void sh7705_flush_cache_all(void *args)
@@ -176,19 +181,20 @@ static void sh7705_flush_cache_page(void
  * Not entirely sure why this is necessary on SH3 with 32K cache but
  * without it we get occasional "Memory fault" when loading a program.
  */
-static void sh7705_flush_icache_page(void *page)
+static void sh7705_flush_icache_folio(void *arg)
 {
-	__flush_purge_region(page_address(page), PAGE_SIZE);
+	struct folio *folio = arg;
+	__flush_purge_region(folio_address(folio), folio_size(folio));
 }
 
 void __init sh7705_cache_init(void)
 {
 	local_flush_icache_range	= sh7705_flush_icache_range;
-	local_flush_dcache_page		= sh7705_flush_dcache_page;
+	local_flush_dcache_folio	= sh7705_flush_dcache_folio;
 	local_flush_cache_all		= sh7705_flush_cache_all;
 	local_flush_cache_mm		= sh7705_flush_cache_all;
 	local_flush_cache_dup_mm	= sh7705_flush_cache_all;
 	local_flush_cache_range		= sh7705_flush_cache_all;
 	local_flush_cache_page		= sh7705_flush_cache_page;
-	local_flush_icache_page		= sh7705_flush_icache_page;
+	local_flush_icache_folio	= sh7705_flush_icache_folio;
 }
--- a/arch/sh/mm/kmap.c~sh-implement-the-new-page-table-range-api
+++ a/arch/sh/mm/kmap.c
@@ -27,10 +27,11 @@ void __init kmap_coherent_init(void)
 
 void *kmap_coherent(struct page *page, unsigned long addr)
 {
+	struct folio *folio = page_folio(page);
 	enum fixed_addresses idx;
 	unsigned long vaddr;
 
-	BUG_ON(!test_bit(PG_dcache_clean, &page->flags));
+	BUG_ON(!test_bit(PG_dcache_clean, &folio->flags));
 
 	preempt_disable();
 	pagefault_disable();
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock-fix.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
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

