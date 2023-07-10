Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C6AEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjGJXal (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjGJXai (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5715D99
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9279A61262
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E758EC433C7;
        Mon, 10 Jul 2023 23:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031836;
        bh=2sSVcDD6ek6xmRw1MdTlTEmY72i1NldA9LjOMSbd85g=;
        h=Date:To:From:Subject:From;
        b=YyRjr2R+5cAlu0QnnU2LNIk12a7snnNSyULXkENb8YLNZLUsqNEseR6iDsb2H1TTf
         9kmbft4Yx/1LV2+/nlDbFDQex36O0WHGk/5meDoA3j5hCqaR7uNKKqXN/RPz+DULAu
         Vi6wDX8eOkV7ulvPwcT+vlJtMoWNJocwYIRD77v8=
Date:   Mon, 10 Jul 2023 16:30:35 -0700
To:     mm-commits@vger.kernel.org, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, rppt@kernel.org, jonas@southpole.se,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + openrisc-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233035.E758EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     openrisc-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/openrisc-implement-the-new-page-table-range-api.patch

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
Subject: openrisc: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:20 +0100

Add PFN_PTE_SHIFT, update_mmu_cache_range() and flush_dcache_folio(). 
Change the PG_arch_1 (aka PG_dcache_dirty) flag from being per-page to
per-folio.

Link: https://lkml.kernel.org/r/20230710204339.3554919-20-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/cacheflush.h |    8 +++++++-
 arch/openrisc/include/asm/pgtable.h    |   15 ++++++++++-----
 arch/openrisc/mm/cache.c               |   12 ++++++++----
 3 files changed, 25 insertions(+), 10 deletions(-)

--- a/arch/openrisc/include/asm/cacheflush.h~openrisc-implement-the-new-page-table-range-api
+++ a/arch/openrisc/include/asm/cacheflush.h
@@ -56,10 +56,16 @@ static inline void sync_icache_dcache(st
  */
 #define PG_dc_clean                  PG_arch_1
 
+static inline void flush_dcache_folio(struct folio *folio)
+{
+	clear_bit(PG_dc_clean, &folio->flags);
+}
+#define flush_dcache_folio flush_dcache_folio
+
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_page(struct page *page)
 {
-	clear_bit(PG_dc_clean, &page->flags);
+	flush_dcache_folio(page_folio(page));
 }
 
 #define flush_icache_user_page(vma, page, addr, len)	\
--- a/arch/openrisc/include/asm/pgtable.h~openrisc-implement-the-new-page-table-range-api
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -46,7 +46,7 @@ extern void paging_init(void);
  * hook is made available.
  */
 #define set_pte(pteptr, pteval) ((*(pteptr)) = (pteval))
-#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
 /*
  * (pmds are folded into pgds so this doesn't get actually called,
  * but the define is needed for a generic inline function.)
@@ -357,6 +357,7 @@ static inline unsigned long pmd_page_vad
 #define __pmd_offset(address) \
 	(((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
 #define pte_pfn(x)		((unsigned long)(((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)  __pte((((pfn) << PAGE_SHIFT)) | pgprot_val(prot))
 
@@ -379,13 +380,17 @@ static inline void update_tlb(struct vm_
 extern void update_cache(struct vm_area_struct *vma,
 	unsigned long address, pte_t *pte);
 
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-	unsigned long address, pte_t *pte)
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
 {
-	update_tlb(vma, address, pte);
-	update_cache(vma, address, pte);
+	update_tlb(vma, address, ptep);
+	update_cache(vma, address, ptep);
 }
 
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
+
 /* __PHX__ FIXME, SWAP, this probably doesn't work */
 
 /*
--- a/arch/openrisc/mm/cache.c~openrisc-implement-the-new-page-table-range-api
+++ a/arch/openrisc/mm/cache.c
@@ -43,15 +43,19 @@ void update_cache(struct vm_area_struct
 	pte_t *pte)
 {
 	unsigned long pfn = pte_val(*pte) >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(pfn);
-	int dirty = !test_and_set_bit(PG_dc_clean, &page->flags);
+	struct folio *folio = page_folio(pfn_to_page(pfn));
+	int dirty = !test_and_set_bit(PG_dc_clean, &folio->flags);
 
 	/*
 	 * Since icaches do not snoop for updated data on OpenRISC, we
 	 * must write back and invalidate any dirty pages manually. We
 	 * can skip data pages, since they will not end up in icaches.
 	 */
-	if ((vma->vm_flags & VM_EXEC) && dirty)
-		sync_icache_dcache(page);
+	if ((vma->vm_flags & VM_EXEC) && dirty) {
+		unsigned int nr = folio_nr_pages(folio);
+
+		while (nr--)
+			sync_icache_dcache(folio_page(folio, nr));
+	}
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

