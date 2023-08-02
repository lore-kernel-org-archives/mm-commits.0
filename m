Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117D0C001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjHBSwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjHBSwH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:52:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C24030C0
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F8E161A38
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EEDC433C7;
        Wed,  2 Aug 2023 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691002314;
        bh=poUlia8ETYuuZGmkCOW4FX1KsDfAkTE4NBwNw7DG+zw=;
        h=Date:To:From:Subject:From;
        b=1/eFBKEti5rhNBi3QhvpmxEqQBGmMECx6GLvH/GU9cDOnJMj0qJlAjzevmfIjXfYZ
         FyqVAjW2pKOMbGVIu2Uh5YHFmwKO66B/rS0zvWS5e7dv0prPFD6ClvcWR2W/iWie/2
         +6j8bMGc/w+PsUT5/jCiJRMwybe00jv76JaxLTr0=
Date:   Wed, 02 Aug 2023 11:51:54 -0700
To:     mm-commits@vger.kernel.org, vgupta@kernel.org, rppt@kernel.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arc-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230802185154.87EEDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arc: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     arc-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arc-implement-the-new-page-table-range-api.patch

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
Subject: arc: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:36 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range(), flush_dcache_folio()
and flush_icache_pages().

Change the PG_dc_clean flag from being per-page to per-folio (which means
it cannot always be set as we don't know that all pages in this folio were
cleaned).  Enhance the internal flush routines to take the number of pages
to flush.

Link: https://lkml.kernel.org/r/20230802151406.3735276-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/cacheflush.h         |    7 +-
 arch/arc/include/asm/pgtable-bits-arcv2.h |   12 +--
 arch/arc/include/asm/pgtable-levels.h     |    1 
 arch/arc/mm/cache.c                       |   61 ++++++++++++--------
 arch/arc/mm/tlb.c                         |   18 +++--
 5 files changed, 59 insertions(+), 40 deletions(-)

--- a/arch/arc/include/asm/cacheflush.h~arc-implement-the-new-page-table-range-api
+++ a/arch/arc/include/asm/cacheflush.h
@@ -25,17 +25,20 @@
  * in update_mmu_cache()
  */
 #define flush_icache_page(vma, page)
+#define flush_icache_pages(vma, page, nr)
 
 void flush_cache_all(void);
 
 void flush_icache_range(unsigned long kstart, unsigned long kend);
 void __sync_icache_dcache(phys_addr_t paddr, unsigned long vaddr, int len);
-void __inv_icache_page(phys_addr_t paddr, unsigned long vaddr);
-void __flush_dcache_page(phys_addr_t paddr, unsigned long vaddr);
+void __inv_icache_pages(phys_addr_t paddr, unsigned long vaddr, unsigned nr);
+void __flush_dcache_pages(phys_addr_t paddr, unsigned long vaddr, unsigned nr);
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 
 void flush_dcache_page(struct page *page);
+void flush_dcache_folio(struct folio *folio);
+#define flush_dcache_folio flush_dcache_folio
 
 void dma_cache_wback_inv(phys_addr_t start, unsigned long sz);
 void dma_cache_inv(phys_addr_t start, unsigned long sz);
--- a/arch/arc/include/asm/pgtable-bits-arcv2.h~arc-implement-the-new-page-table-range-api
+++ a/arch/arc/include/asm/pgtable-bits-arcv2.h
@@ -100,14 +100,12 @@ static inline pte_t pte_modify(pte_t pte
 	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	set_pte(ptep, pteval);
-}
+struct vm_fault;
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep, unsigned int nr);
 
-void update_mmu_cache(struct vm_area_struct *vma, unsigned long address,
-		      pte_t *ptep);
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
 /*
  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
--- a/arch/arc/include/asm/pgtable-levels.h~arc-implement-the-new-page-table-range-api
+++ a/arch/arc/include/asm/pgtable-levels.h
@@ -169,6 +169,7 @@
 #define pte_ERROR(e) \
 	pr_crit("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_none(x)		(!pte_val(x))
 #define pte_present(x)		(pte_val(x) & _PAGE_PRESENT)
 #define pte_clear(mm,addr,ptep)	set_pte_at(mm, addr, ptep, __pte(0))
--- a/arch/arc/mm/cache.c~arc-implement-the-new-page-table-range-api
+++ a/arch/arc/mm/cache.c
@@ -752,17 +752,17 @@ static inline void arc_slc_enable(void)
  * There's a corollary case, where kernel READs from a userspace mapped page.
  * If the U-mapping is not congruent to K-mapping, former needs flushing.
  */
-void flush_dcache_page(struct page *page)
+void flush_dcache_folio(struct folio *folio)
 {
 	struct address_space *mapping;
 
 	if (!cache_is_vipt_aliasing()) {
-		clear_bit(PG_dc_clean, &page->flags);
+		clear_bit(PG_dc_clean, &folio->flags);
 		return;
 	}
 
 	/* don't handle anon pages here */
-	mapping = page_mapping_file(page);
+	mapping = folio_flush_mapping(folio);
 	if (!mapping)
 		return;
 
@@ -771,17 +771,27 @@ void flush_dcache_page(struct page *page
 	 * Make a note that K-mapping is dirty
 	 */
 	if (!mapping_mapped(mapping)) {
-		clear_bit(PG_dc_clean, &page->flags);
-	} else if (page_mapcount(page)) {
-
+		clear_bit(PG_dc_clean, &folio->flags);
+	} else if (folio_mapped(folio)) {
 		/* kernel reading from page with U-mapping */
-		phys_addr_t paddr = (unsigned long)page_address(page);
-		unsigned long vaddr = page->index << PAGE_SHIFT;
+		phys_addr_t paddr = (unsigned long)folio_address(folio);
+		unsigned long vaddr = folio_pos(folio);
 
+		/*
+		 * vaddr is not actually the virtual address, but is
+		 * congruent to every user mapping.
+		 */
 		if (addr_not_cache_congruent(paddr, vaddr))
-			__flush_dcache_page(paddr, vaddr);
+			__flush_dcache_pages(paddr, vaddr,
+						folio_nr_pages(folio));
 	}
 }
+EXPORT_SYMBOL(flush_dcache_folio);
+
+void flush_dcache_page(struct page *page)
+{
+	return flush_dcache_folio(page_folio(page));
+}
 EXPORT_SYMBOL(flush_dcache_page);
 
 /*
@@ -921,18 +931,18 @@ void __sync_icache_dcache(phys_addr_t pa
 }
 
 /* wrapper to compile time eliminate alignment checks in flush loop */
-void __inv_icache_page(phys_addr_t paddr, unsigned long vaddr)
+void __inv_icache_pages(phys_addr_t paddr, unsigned long vaddr, unsigned nr)
 {
-	__ic_line_inv_vaddr(paddr, vaddr, PAGE_SIZE);
+	__ic_line_inv_vaddr(paddr, vaddr, nr * PAGE_SIZE);
 }
 
 /*
  * wrapper to clearout kernel or userspace mappings of a page
  * For kernel mappings @vaddr == @paddr
  */
-void __flush_dcache_page(phys_addr_t paddr, unsigned long vaddr)
+void __flush_dcache_pages(phys_addr_t paddr, unsigned long vaddr, unsigned nr)
 {
-	__dc_line_op(paddr, vaddr & PAGE_MASK, PAGE_SIZE, OP_FLUSH_N_INV);
+	__dc_line_op(paddr, vaddr & PAGE_MASK, nr * PAGE_SIZE, OP_FLUSH_N_INV);
 }
 
 noinline void flush_cache_all(void)
@@ -962,10 +972,10 @@ void flush_cache_page(struct vm_area_str
 
 	u_vaddr &= PAGE_MASK;
 
-	__flush_dcache_page(paddr, u_vaddr);
+	__flush_dcache_pages(paddr, u_vaddr, 1);
 
 	if (vma->vm_flags & VM_EXEC)
-		__inv_icache_page(paddr, u_vaddr);
+		__inv_icache_pages(paddr, u_vaddr, 1);
 }
 
 void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
@@ -978,9 +988,9 @@ void flush_anon_page(struct vm_area_stru
 		     unsigned long u_vaddr)
 {
 	/* TBD: do we really need to clear the kernel mapping */
-	__flush_dcache_page((phys_addr_t)page_address(page), u_vaddr);
-	__flush_dcache_page((phys_addr_t)page_address(page),
-			    (phys_addr_t)page_address(page));
+	__flush_dcache_pages((phys_addr_t)page_address(page), u_vaddr, 1);
+	__flush_dcache_pages((phys_addr_t)page_address(page),
+			    (phys_addr_t)page_address(page), 1);
 
 }
 
@@ -989,6 +999,8 @@ void flush_anon_page(struct vm_area_stru
 void copy_user_highpage(struct page *to, struct page *from,
 	unsigned long u_vaddr, struct vm_area_struct *vma)
 {
+	struct folio *src = page_folio(from);
+	struct folio *dst = page_folio(to);
 	void *kfrom = kmap_atomic(from);
 	void *kto = kmap_atomic(to);
 	int clean_src_k_mappings = 0;
@@ -1005,7 +1017,7 @@ void copy_user_highpage(struct page *to,
 	 * addr_not_cache_congruent() is 0
 	 */
 	if (page_mapcount(from) && addr_not_cache_congruent(kfrom, u_vaddr)) {
-		__flush_dcache_page((unsigned long)kfrom, u_vaddr);
+		__flush_dcache_pages((unsigned long)kfrom, u_vaddr, 1);
 		clean_src_k_mappings = 1;
 	}
 
@@ -1019,17 +1031,17 @@ void copy_user_highpage(struct page *to,
 	 * non copied user pages (e.g. read faults which wire in pagecache page
 	 * directly).
 	 */
-	clear_bit(PG_dc_clean, &to->flags);
+	clear_bit(PG_dc_clean, &dst->flags);
 
 	/*
 	 * if SRC was already usermapped and non-congruent to kernel mapping
 	 * sync the kernel mapping back to physical page
 	 */
 	if (clean_src_k_mappings) {
-		__flush_dcache_page((unsigned long)kfrom, (unsigned long)kfrom);
-		set_bit(PG_dc_clean, &from->flags);
+		__flush_dcache_pages((unsigned long)kfrom,
+					(unsigned long)kfrom, 1);
 	} else {
-		clear_bit(PG_dc_clean, &from->flags);
+		clear_bit(PG_dc_clean, &src->flags);
 	}
 
 	kunmap_atomic(kto);
@@ -1038,8 +1050,9 @@ void copy_user_highpage(struct page *to,
 
 void clear_user_page(void *to, unsigned long u_vaddr, struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	clear_page(to);
-	clear_bit(PG_dc_clean, &page->flags);
+	clear_bit(PG_dc_clean, &folio->flags);
 }
 EXPORT_SYMBOL(clear_user_page);
 
--- a/arch/arc/mm/tlb.c~arc-implement-the-new-page-table-range-api
+++ a/arch/arc/mm/tlb.c
@@ -467,8 +467,8 @@ void create_tlb(struct vm_area_struct *v
  * Note that flush (when done) involves both WBACK - so physical page is
  * in sync as well as INV - so any non-congruent aliases don't remain
  */
-void update_mmu_cache(struct vm_area_struct *vma, unsigned long vaddr_unaligned,
-		      pte_t *ptep)
+void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
+		unsigned long vaddr_unaligned, pte_t *ptep, unsigned int nr)
 {
 	unsigned long vaddr = vaddr_unaligned & PAGE_MASK;
 	phys_addr_t paddr = pte_val(*ptep) & PAGE_MASK_PHYS;
@@ -491,15 +491,19 @@ void update_mmu_cache(struct vm_area_str
 	 */
 	if ((vma->vm_flags & VM_EXEC) ||
 	     addr_not_cache_congruent(paddr, vaddr)) {
-
-		int dirty = !test_and_set_bit(PG_dc_clean, &page->flags);
+		struct folio *folio = page_folio(page);
+		int dirty = !test_and_set_bit(PG_dc_clean, &folio->flags);
 		if (dirty) {
+			unsigned long offset = offset_in_folio(folio, paddr);
+			nr = folio_nr_pages(folio);
+			paddr -= offset;
+			vaddr -= offset;
 			/* wback + inv dcache lines (K-mapping) */
-			__flush_dcache_page(paddr, paddr);
+			__flush_dcache_pages(paddr, paddr, nr);
 
 			/* invalidate any existing icache lines (U-mapping) */
 			if (vma->vm_flags & VM_EXEC)
-				__inv_icache_page(paddr, vaddr);
+				__inv_icache_pages(paddr, vaddr, nr);
 		}
 	}
 }
@@ -531,7 +535,7 @@ void update_mmu_cache_pmd(struct vm_area
 				 pmd_t *pmd)
 {
 	pte_t pte = __pte(pmd_val(*pmd));
-	update_mmu_cache(vma, addr, &pte);
+	update_mmu_cache_range(NULL, vma, addr, &pte, HPAGE_PMD_NR);
 }
 
 void local_flush_pmd_tlb_range(struct vm_area_struct *vma, unsigned long start,
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

