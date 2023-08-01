Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7373BC04A6A
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbjHAS6W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjHAS5s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:57:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7794226AA
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15C8F616A9
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6994CC433C7;
        Tue,  1 Aug 2023 18:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690916239;
        bh=HvoqLuprU2auYxTkGnY9tbqRpBZLKXCd8T3U4sTXrZ8=;
        h=Date:To:From:Subject:From;
        b=dIFYYkEpFvtPHprMfhJ2SvvqwbCvGkTrG5R5XXdR+IbSuzBJYbUU0AClbXJDyx0R2
         0ld43Q4DWt3mFnVX2pB3XqcXUCnO8ZiuzwB1Uco1u6LybkghTNhbq71wTTT2qZxtuz
         cDSuG/83CLytIWd6S4/uts4ekN5CCSJmB5v0Eelo=
Date:   Tue, 01 Aug 2023 11:57:18 -0700
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
Subject: + sparc64-convert-various-functions-to-use-ptdescs.patch added to mm-unstable branch
Message-Id: <20230801185719.6994CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64: convert various functions to use ptdescs
has been added to the -mm mm-unstable branch.  Its filename is
     sparc64-convert-various-functions-to-use-ptdescs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc64-convert-various-functions-to-use-ptdescs.patch

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
Subject: sparc64: convert various functions to use ptdescs
Date: Mon, 31 Jul 2023 10:03:29 -0700

As part of the conversions to replace pgtable constructor/destructors with
ptdesc equivalents, convert various page table functions to use ptdescs.

Link: https://lkml.kernel.org/r/20230731170332.69404-29-vishal.moola@gmail.com
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

 arch/sparc/mm/init_64.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc64-convert-various-functions-to-use-ptdescs
+++ a/arch/sparc/mm/init_64.c
@@ -2893,14 +2893,15 @@ pte_t *pte_alloc_one_kernel(struct mm_st
 
 pgtable_t pte_alloc_one(struct mm_struct *mm)
 {
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page)
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!ptdesc)
 		return NULL;
-	if (!pgtable_pte_page_ctor(page)) {
-		__free_page(page);
+	if (!pagetable_pte_ctor(ptdesc)) {
+		pagetable_free(ptdesc);
 		return NULL;
 	}
-	return (pte_t *) page_address(page);
+	return ptdesc_address(ptdesc);
 }
 
 void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
@@ -2910,10 +2911,10 @@ void pte_free_kernel(struct mm_struct *m
 
 static void __pte_free(pgtable_t pte)
 {
-	struct page *page = virt_to_page(pte);
+	struct ptdesc *ptdesc = virt_to_ptdesc(pte);
 
-	pgtable_pte_page_dtor(page);
-	__free_page(page);
+	pagetable_pte_dtor(ptdesc);
+	pagetable_free(ptdesc);
 }
 
 void pte_free(struct mm_struct *mm, pgtable_t pte)
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

