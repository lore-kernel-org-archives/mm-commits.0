Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C30EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjGJXaJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjGJXaI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8250B9E
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17B9761261
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB18C433C8;
        Mon, 10 Jul 2023 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031806;
        bh=Daq6oquTd1sK6f6jLZs6uFNV1xETdYtVhOew2QfRtvo=;
        h=Date:To:From:Subject:From;
        b=TiCUzRtca6OKOYMQWN7fpcmHlYIa5wG5WOwIDFuT+L0HsRdXb+sVBBIA7QHVhP/Ry
         OpBCkhanK7Kd9hIwKOZclquKVx+IdfgH1gsngRs4qD/Y/Id4KdhMaBRCo83awNksbb
         gc97/zuMkd4HcIQOjdkXBDmt7G1yxIgLZD+t1Dy0=
Date:   Mon, 10 Jul 2023 16:30:05 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, bcain@quicinc.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-implement-the-new-page-table-range-api.patch added to mm-unstable branch
Message-Id: <20230710233006.6FB18C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: implement the new page table range API
has been added to the -mm mm-unstable branch.  Its filename is
     hexagon-implement-the-new-page-table-range-api.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-implement-the-new-page-table-range-api.patch

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
Subject: hexagon: implement the new page table range API
Date: Mon, 10 Jul 2023 21:43:13 +0100

Add PFN_PTE_SHIFT and update_mmu_cache_range().

Link: https://lkml.kernel.org/r/20230710204339.3554919-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Brian Cain <bcain@quicinc.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/cacheflush.h |    8 ++++++--
 arch/hexagon/include/asm/pgtable.h    |    9 +--------
 2 files changed, 7 insertions(+), 10 deletions(-)

--- a/arch/hexagon/include/asm/cacheflush.h~hexagon-implement-the-new-page-table-range-api
+++ a/arch/hexagon/include/asm/cacheflush.h
@@ -58,12 +58,16 @@ extern void flush_cache_all_hexagon(void
  * clean the cache when the PTE is set.
  *
  */
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-					unsigned long address, pte_t *ptep)
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long address,
+		pte_t *ptep, unsigned int nr)
 {
 	/*  generic_ptrace_pokedata doesn't wind up here, does it?  */
 }
 
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
+
 void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 		       unsigned long vaddr, void *dst, void *src, int len);
 #define copy_to_user_page copy_to_user_page
--- a/arch/hexagon/include/asm/pgtable.h~hexagon-implement-the-new-page-table-range-api
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -338,6 +338,7 @@ static inline int pte_exec(pte_t pte)
 /* __swp_entry_to_pte - extract PTE from swap entry */
 #define __swp_entry_to_pte(x) ((pte_t) { (x).val })
 
+#define PFN_PTE_SHIFT	PAGE_SHIFT
 /* pfn_pte - convert page number and protection value to page table entry */
 #define pfn_pte(pfn, pgprot) __pte((pfn << PAGE_SHIFT) | pgprot_val(pgprot))
 
@@ -345,14 +346,6 @@ static inline int pte_exec(pte_t pte)
 #define pte_pfn(pte) (pte_val(pte) >> PAGE_SHIFT)
 #define set_pmd(pmdptr, pmdval) (*(pmdptr) = (pmdval))
 
-/*
- * set_pte_at - update page table and do whatever magic may be
- * necessary to make the underlying hardware/firmware take note.
- *
- * VM may require a virtual instruction to alert the MMU.
- */
-#define set_pte_at(mm, addr, ptep, pte) set_pte(ptep, pte)
-
 static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 {
 	return (unsigned long)__va(pmd_val(pmd) & PAGE_MASK);
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

