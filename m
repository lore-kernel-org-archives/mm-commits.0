Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75A9C00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjHAS5f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjHAS5D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:57:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE54D30C2
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DAFF61694
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60554C433C8;
        Tue,  1 Aug 2023 18:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690916206;
        bh=xCBxNOjGRDMUZvePazWh0tP02spxRAONZI/5U70H5gE=;
        h=Date:To:From:Subject:From;
        b=LrGArhbEV2hPlttlwU8kfZ/I7MAzdLOyTiFrU5jnHxfwPBQQBcemYqg/OJm8O9BUr
         H62hnUsrBmdZ4KI5tG5j4y4gt2geWg/R7wgOPJqHegyTmbcbkQawWzpjYWPxKzGODw
         qPOHyBcy+v8eNJjAn+D6WjxSfvFjlh35hCNNoB18=
Date:   Tue, 01 Aug 2023 11:56:45 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        willy@infradead.org, tsbogend@alpha.franken.de, rppt@kernel.org,
        richard@nod.at, paul.walmsley@sifive.com, palmer@rivosinc.com,
        jonas@southpole.se, imbrenda@linux.ibm.com, hughd@google.com,
        guoren@kernel.org, glaubitz@physik.fu-berlin.de,
        geert+renesas@glider.be, geert@linux-m68k.org, dinguyen@kernel.org,
        david@redhat.com, davem@davemloft.net, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, chenhuacai@kernel.org,
        catalin.marinas@arm.com, arnd@arndb.de, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-convert-various-functions-to-use-ptdescs.patch added to mm-unstable branch
Message-Id: <20230801185646.60554C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: convert various functions to use ptdescs
has been added to the -mm mm-unstable branch.  Its filename is
     x86-convert-various-functions-to-use-ptdescs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-convert-various-functions-to-use-ptdescs.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: x86: convert various functions to use ptdescs
Date: Mon, 31 Jul 2023 10:03:14 -0700

In order to split struct ptdesc from struct page, convert various
functions to use ptdescs.

Some of the functions use the *get*page*() helper functions.  Convert
these to use pagetable_alloc() and ptdesc_address() instead to help
standardize page tables further.

Link: https://lkml.kernel.org/r/20230731170332.69404-14-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Guo Ren <guoren@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable.c |   47 +++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 19 deletions(-)

--- a/arch/x86/mm/pgtable.c~x86-convert-various-functions-to-use-ptdescs
+++ a/arch/x86/mm/pgtable.c
@@ -52,7 +52,7 @@ early_param("userpte", setup_userpte);
 
 void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
-	pgtable_pte_page_dtor(pte);
+	pagetable_pte_dtor(page_ptdesc(pte));
 	paravirt_release_pte(page_to_pfn(pte));
 	paravirt_tlb_remove_table(tlb, pte);
 }
@@ -60,7 +60,7 @@ void ___pte_free_tlb(struct mmu_gather *
 #if CONFIG_PGTABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
-	struct page *page = virt_to_page(pmd);
+	struct ptdesc *ptdesc = virt_to_ptdesc(pmd);
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
 	/*
 	 * NOTE! For PAE, any changes to the top page-directory-pointer-table
@@ -69,8 +69,8 @@ void ___pmd_free_tlb(struct mmu_gather *
 #ifdef CONFIG_X86_PAE
 	tlb->need_flush_all = 1;
 #endif
-	pgtable_pmd_page_dtor(page);
-	paravirt_tlb_remove_table(tlb, page);
+	pagetable_pmd_dtor(ptdesc);
+	paravirt_tlb_remove_table(tlb, ptdesc_page(ptdesc));
 }
 
 #if CONFIG_PGTABLE_LEVELS > 3
@@ -92,16 +92,16 @@ void ___p4d_free_tlb(struct mmu_gather *
 
 static inline void pgd_list_add(pgd_t *pgd)
 {
-	struct page *page = virt_to_page(pgd);
+	struct ptdesc *ptdesc = virt_to_ptdesc(pgd);
 
-	list_add(&page->lru, &pgd_list);
+	list_add(&ptdesc->pt_list, &pgd_list);
 }
 
 static inline void pgd_list_del(pgd_t *pgd)
 {
-	struct page *page = virt_to_page(pgd);
+	struct ptdesc *ptdesc = virt_to_ptdesc(pgd);
 
-	list_del(&page->lru);
+	list_del(&ptdesc->pt_list);
 }
 
 #define UNSHARED_PTRS_PER_PGD				\
@@ -112,12 +112,12 @@ static inline void pgd_list_del(pgd_t *p
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
 {
-	virt_to_page(pgd)->pt_mm = mm;
+	virt_to_ptdesc(pgd)->pt_mm = mm;
 }
 
 struct mm_struct *pgd_page_get_mm(struct page *page)
 {
-	return page->pt_mm;
+	return page_ptdesc(page)->pt_mm;
 }
 
 static void pgd_ctor(struct mm_struct *mm, pgd_t *pgd)
@@ -213,11 +213,14 @@ void pud_populate(struct mm_struct *mm,
 static void free_pmds(struct mm_struct *mm, pmd_t *pmds[], int count)
 {
 	int i;
+	struct ptdesc *ptdesc;
 
 	for (i = 0; i < count; i++)
 		if (pmds[i]) {
-			pgtable_pmd_page_dtor(virt_to_page(pmds[i]));
-			free_page((unsigned long)pmds[i]);
+			ptdesc = virt_to_ptdesc(pmds[i]);
+
+			pagetable_pmd_dtor(ptdesc);
+			pagetable_free(ptdesc);
 			mm_dec_nr_pmds(mm);
 		}
 }
@@ -230,18 +233,24 @@ static int preallocate_pmds(struct mm_st
 
 	if (mm == &init_mm)
 		gfp &= ~__GFP_ACCOUNT;
+	gfp &= ~__GFP_HIGHMEM;
 
 	for (i = 0; i < count; i++) {
-		pmd_t *pmd = (pmd_t *)__get_free_page(gfp);
-		if (!pmd)
+		pmd_t *pmd = NULL;
+		struct ptdesc *ptdesc = pagetable_alloc(gfp, 0);
+
+		if (!ptdesc)
 			failed = true;
-		if (pmd && !pgtable_pmd_page_ctor(virt_to_page(pmd))) {
-			free_page((unsigned long)pmd);
-			pmd = NULL;
+		if (ptdesc && !pagetable_pmd_ctor(ptdesc)) {
+			pagetable_free(ptdesc);
+			ptdesc = NULL;
 			failed = true;
 		}
-		if (pmd)
+		if (ptdesc) {
 			mm_inc_nr_pmds(mm);
+			pmd = ptdesc_address(ptdesc);
+		}
+
 		pmds[i] = pmd;
 	}
 
@@ -830,7 +839,7 @@ int pud_free_pmd_page(pud_t *pud, unsign
 
 	free_page((unsigned long)pmd_sv);
 
-	pgtable_pmd_page_dtor(virt_to_page(pmd));
+	pagetable_pmd_dtor(virt_to_ptdesc(pmd));
 	free_page((unsigned long)pmd);
 
 	return 1;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-add-page_type_op-folio-functions.patch
pgtable-create-struct-ptdesc.patch
mm-add-utility-functions-for-ptdesc.patch
mm-convert-pmd_pgtable_page-callers-to-use-pmd_ptdesc.patch
mm-convert-ptlock_alloc-to-use-ptdescs.patch
mm-convert-ptlock_ptr-to-use-ptdescs.patch
mm-convert-pmd_ptlock_init-to-use-ptdescs.patch
mm-convert-ptlock_init-to-use-ptdescs.patch
mm-convert-pmd_ptlock_free-to-use-ptdescs.patch
mm-convert-ptlock_free-to-use-ptdescs.patch
mm-create-ptdesc-equivalents-for-pgtable_ptepmd_page_ctordtor.patch
powerpc-convert-various-functions-to-use-ptdescs.patch
x86-convert-various-functions-to-use-ptdescs.patch
s390-convert-various-pgalloc-functions-to-use-ptdescs.patch
mm-remove-page-table-members-from-struct-page.patch
pgalloc-convert-various-functions-to-use-ptdescs.patch
arm-convert-various-functions-to-use-ptdescs.patch
arm64-convert-various-functions-to-use-ptdescs.patch
csky-convert-__pte_free_tlb-to-use-ptdescs.patch
hexagon-convert-__pte_free_tlb-to-use-ptdescs.patch
loongarch-convert-various-functions-to-use-ptdescs.patch
m68k-convert-various-functions-to-use-ptdescs.patch
mips-convert-various-functions-to-use-ptdescs.patch
nios2-convert-__pte_free_tlb-to-use-ptdescs.patch
openrisc-convert-__pte_free_tlb-to-use-ptdescs.patch
riscv-convert-alloc_pmd-pte_late-to-use-ptdescs.patch
sh-convert-pte_free_tlb-to-use-ptdescs.patch
sparc64-convert-various-functions-to-use-ptdescs.patch
sparc-convert-pgtable_pte_page_ctor-dtor-to-ptdesc-equivalents.patch
um-convert-pmd-pte_free_tlb-to-use-ptdescs.patch
mm-remove-pgtable_pmd-pte_page_ctor-dtor-wrappers.patch

