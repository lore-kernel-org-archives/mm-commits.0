Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69636C00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjHAS64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjHAS52 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:57:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467883585
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D22B1616A1
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31492C433C8;
        Tue,  1 Aug 2023 18:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690916224;
        bh=lNoz8fq+sfyf8n5sKJbCtgHWbwA5q3iWDnr7bKEq1CE=;
        h=Date:To:From:Subject:From;
        b=oKRRZABIvd99nEECPxMiBv5vlWmptEaYREtOd2DRWN9lVKVk66CoVVO7lbLcEzuM+
         pjaZTp9qTRbexhUyHVMWYn9ggnt4NMdPvCcLdBw01c6cERoOORbud9xo/7TP3FfYFC
         AW2jDnRsFgyyJMJS3YP2pQYHUebPEbEq/4XFxBz0=
Date:   Tue, 01 Aug 2023 11:57:03 -0700
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
Subject: + loongarch-convert-various-functions-to-use-ptdescs.patch added to mm-unstable branch
Message-Id: <20230801185704.31492C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: loongarch: convert various functions to use ptdescs
has been added to the -mm mm-unstable branch.  Its filename is
     loongarch-convert-various-functions-to-use-ptdescs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-convert-various-functions-to-use-ptdescs.patch

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
Subject: loongarch: convert various functions to use ptdescs
Date: Mon, 31 Jul 2023 10:03:22 -0700

As part of the conversions to replace pgtable constructor/destructors with
ptdesc equivalents, convert various page table functions to use ptdescs.

Some of the functions use the *get*page*() helper functions.  Convert
these to use pagetable_alloc() and ptdesc_address() instead to help
standardize page tables further.

Link: https://lkml.kernel.org/r/20230731170332.69404-22-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
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
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgalloc.h |   27 +++++++++++++------------
 arch/loongarch/mm/pgtable.c          |    7 +++---
 2 files changed, 19 insertions(+), 15 deletions(-)

--- a/arch/loongarch/include/asm/pgalloc.h~loongarch-convert-various-functions-to-use-ptdescs
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -45,9 +45,9 @@ extern void pagetable_init(void);
 extern pgd_t *pgd_alloc(struct mm_struct *mm);
 
 #define __pte_free_tlb(tlb, pte, address)			\
-do {							\
-	pgtable_pte_page_dtor(pte);			\
-	tlb_remove_page((tlb), pte);			\
+do {								\
+	pagetable_pte_dtor(page_ptdesc(pte));			\
+	tlb_remove_page_ptdesc((tlb), page_ptdesc(pte));	\
 } while (0)
 
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -55,18 +55,18 @@ do {							\
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	pmd_t *pmd;
-	struct page *pg;
+	struct ptdesc *ptdesc;
 
-	pg = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!pg)
+	ptdesc = pagetable_alloc(GFP_KERNEL_ACCOUNT, 0);
+	if (!ptdesc)
 		return NULL;
 
-	if (!pgtable_pmd_page_ctor(pg)) {
-		__free_page(pg);
+	if (!pagetable_pmd_ctor(ptdesc)) {
+		pagetable_free(ptdesc);
 		return NULL;
 	}
 
-	pmd = (pmd_t *)page_address(pg);
+	pmd = ptdesc_address(ptdesc);
 	pmd_init(pmd);
 	return pmd;
 }
@@ -80,10 +80,13 @@ static inline pmd_t *pmd_alloc_one(struc
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	pud_t *pud;
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL & ~__GFP_HIGHMEM, 0);
 
-	pud = (pud_t *) __get_free_page(GFP_KERNEL);
-	if (pud)
-		pud_init(pud);
+	if (!ptdesc)
+		return NULL;
+	pud = ptdesc_address(ptdesc);
+
+	pud_init(pud);
 	return pud;
 }
 
--- a/arch/loongarch/mm/pgtable.c~loongarch-convert-various-functions-to-use-ptdescs
+++ a/arch/loongarch/mm/pgtable.c
@@ -11,10 +11,11 @@
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *ret, *init;
+	pgd_t *init, *ret = NULL;
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL & ~__GFP_HIGHMEM, 0);
 
-	ret = (pgd_t *) __get_free_page(GFP_KERNEL);
-	if (ret) {
+	if (ptdesc) {
+		ret = (pgd_t *)ptdesc_address(ptdesc);
 		init = pgd_offset(&init_mm, 0UL);
 		pgd_init(ret);
 		memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
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

