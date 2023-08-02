Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F50C04FE0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjHBSxJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjHBSwT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:52:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB842737
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CB6961947
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F58C433C7;
        Wed,  2 Aug 2023 18:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691002336;
        bh=MwpjaLZuwL3kEB/+0KZGYCzQ5qzSJJhRdE7XUMKrUis=;
        h=Date:To:From:Subject:From;
        b=c/V3Fzz7hs4i9GIG76Gh+PgDgbC+YB0qjaZfYHkNF4uWb6JP4KoTn1t6egH85Ksfn
         qYEaR1mo3Abl8C3r/GtoxvvjWz9H4AdxVrYjjVDxGFVGGRRogCN0PP3LgeQiFpvpoE
         nkbXQkW54jdVnplMtN980lcygrAkiOpwjDUDynoY=
Date:   Wed, 02 Aug 2023 11:52:16 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, geert@linux-m68k.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230802185216.A5F58C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-implement-the-new-page-table-range-api.patch

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
Subject: m68k: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:43 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range(), flush_icache_pages() and
flush_dcache_folio().

Link: https://lkml.kernel.org/r/20230802151406.3735276-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/cacheflush_mm.h    |   27 ++++++++++++++-------
 arch/m68k/include/asm/mcf_pgtable.h      |    1 
 arch/m68k/include/asm/motorola_pgtable.h |    1 
 arch/m68k/include/asm/pgtable_mm.h       |   10 ++++---
 arch/m68k/include/asm/sun3_pgtable.h     |    1 
 arch/m68k/mm/motorola.c                  |    2 -
 6 files changed, 28 insertions(+), 14 deletions(-)

--- a/arch/m68k/include/asm/cacheflush_mm.h~m68k-implement-the-new-page-table-range-api
+++ a/arch/m68k/include/asm/cacheflush_mm.h
@@ -220,24 +220,29 @@ static inline void flush_cache_page(stru
 
 /* Push the page at kernel virtual address and clear the icache */
 /* RZ: use cpush %bc instead of cpush %dc, cinv %ic */
-static inline void __flush_page_to_ram(void *vaddr)
+static inline void __flush_pages_to_ram(void *vaddr, unsigned int nr)
 {
 	if (CPU_IS_COLDFIRE) {
 		unsigned long addr, start, end;
 		addr = ((unsigned long) vaddr) & ~(PAGE_SIZE - 1);
 		start = addr & ICACHE_SET_MASK;
-		end = (addr + PAGE_SIZE - 1) & ICACHE_SET_MASK;
+		end = (addr + nr * PAGE_SIZE - 1) & ICACHE_SET_MASK;
 		if (start > end) {
 			flush_cf_bcache(0, end);
 			end = ICACHE_MAX_ADDR;
 		}
 		flush_cf_bcache(start, end);
 	} else if (CPU_IS_040_OR_060) {
-		__asm__ __volatile__("nop\n\t"
-				     ".chip 68040\n\t"
-				     "cpushp %%bc,(%0)\n\t"
-				     ".chip 68k"
-				     : : "a" (__pa(vaddr)));
+		unsigned long paddr = __pa(vaddr);
+
+		do {
+			__asm__ __volatile__("nop\n\t"
+					     ".chip 68040\n\t"
+					     "cpushp %%bc,(%0)\n\t"
+					     ".chip 68k"
+					     : : "a" (paddr));
+			paddr += PAGE_SIZE;
+		} while (--nr);
 	} else {
 		unsigned long _tmp;
 		__asm__ __volatile__("movec %%cacr,%0\n\t"
@@ -249,10 +254,14 @@ static inline void __flush_page_to_ram(v
 }
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
-#define flush_dcache_page(page)		__flush_page_to_ram(page_address(page))
+#define flush_dcache_page(page)	__flush_pages_to_ram(page_address(page), 1)
+#define flush_dcache_folio(folio)		\
+	__flush_pages_to_ram(folio_address(folio), folio_nr_pages(folio))
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-#define flush_icache_page(vma, page)	__flush_page_to_ram(page_address(page))
+#define flush_icache_pages(vma, page, nr)	\
+	__flush_pages_to_ram(page_address(page), nr)
+#define flush_icache_page(vma, page) flush_icache_pages(vma, page, 1)
 
 extern void flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 				    unsigned long addr, int len);
--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-implement-the-new-page-table-range-api
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -291,6 +291,7 @@ static inline pte_t pte_swp_clear_exclus
 	return pte;
 }
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pmd_pfn(pmd)		(pmd_val(pmd) >> PAGE_SHIFT)
 #define pmd_page(pmd)		(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
 
--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-implement-the-new-page-table-range-api
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -112,6 +112,7 @@ static inline void pud_set(pud_t *pudp,
 #define pte_present(pte)	(pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 #define pte_clear(mm,addr,ptep)		({ pte_val(*(ptep)) = 0; })
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_page(pte)		virt_to_page(__va(pte_val(pte)))
 #define pte_pfn(pte)		(pte_val(pte) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
--- a/arch/m68k/include/asm/pgtable_mm.h~m68k-implement-the-new-page-table-range-api
+++ a/arch/m68k/include/asm/pgtable_mm.h
@@ -31,8 +31,6 @@
 	do{							\
 		*(pteptr) = (pteval);				\
 	} while(0)
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
-
 
 /* PMD_SHIFT determines the size of the area a second-level page table can map */
 #if CONFIG_PGTABLE_LEVELS == 3
@@ -138,11 +136,15 @@ extern void kernel_set_cachemode(void *a
  * tables contain all the necessary information.  The Sun3 does, but
  * they are updated on demand.
  */
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-				    unsigned long address, pte_t *ptep)
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
 {
 }
 
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
+
 #endif /* !__ASSEMBLY__ */
 
 /* MMU-specific headers */
--- a/arch/m68k/include/asm/sun3_pgtable.h~m68k-implement-the-new-page-table-range-api
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -105,6 +105,7 @@ static inline void pte_clear (struct mm_
 	pte_val (*ptep) = 0;
 }
 
+#define PFN_PTE_SHIFT		0
 #define pte_pfn(pte)            (pte_val(pte) & SUN3_PAGE_PGNUM_MASK)
 #define pfn_pte(pfn, pgprot) \
 ({ pte_t __pte; pte_val(__pte) = pfn | pgprot_val(pgprot); __pte; })
--- a/arch/m68k/mm/motorola.c~m68k-implement-the-new-page-table-range-api
+++ a/arch/m68k/mm/motorola.c
@@ -81,7 +81,7 @@ static inline void cache_page(void *vadd
 
 void mmu_page_ctor(void *page)
 {
-	__flush_page_to_ram(page);
+	__flush_pages_to_ram(page, 1);
 	flush_tlb_kernel_page(page);
 	nocache_page(page);
 }
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

