Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FC4C00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjHAS5W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjHAS45 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:56:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06C12D62
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D9F4616B1
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20F7C433C7;
        Tue,  1 Aug 2023 18:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690916201;
        bh=bCILEza3EFtGIugoVegnLv7Z7iQlGIoSLW3lv2S3JEs=;
        h=Date:To:From:Subject:From;
        b=0oa31PGtQhTgu7CXZQsZQkE/6CRnn4yMmmpKKbIC9yfKDL+zfMLn9adBQcj/e08Vu
         dDrvXyQktswfP9ZrrrEcg7zTUNERW0dk9YAMXSguWzI7d/Ph6y4trCPNgqKNJ9a7LW
         jfYtZPlddeNhk7becD4NL9/UaKVvyG0Lcb1BSnyQ=
Date:   Tue, 01 Aug 2023 11:56:41 -0700
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
Subject: + mm-create-ptdesc-equivalents-for-pgtable_ptepmd_page_ctordtor.patch added to mm-unstable branch
Message-Id: <20230801185641.A20F7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: create ptdesc equivalents for pgtable_{pte,pmd}_page_{ctor,dtor}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-create-ptdesc-equivalents-for-pgtable_ptepmd_page_ctordtor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-create-ptdesc-equivalents-for-pgtable_ptepmd_page_ctordtor.patch

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
Subject: mm: create ptdesc equivalents for pgtable_{pte,pmd}_page_{ctor,dtor}
Date: Mon, 31 Jul 2023 10:03:12 -0700

Create pagetable_pte_ctor(), pagetable_pmd_ctor(), pagetable_pte_dtor(),
and pagetable_pmd_dtor() and make the original pgtable
constructor/destructors wrappers.

Link: https://lkml.kernel.org/r/20230731170332.69404-12-vishal.moola@gmail.com
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

 include/linux/mm.h |   56 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 14 deletions(-)

--- a/include/linux/mm.h~mm-create-ptdesc-equivalents-for-pgtable_ptepmd_page_ctordtor
+++ a/include/linux/mm.h
@@ -2915,20 +2915,34 @@ static inline bool ptlock_init(struct pt
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
-static inline bool pgtable_pte_page_ctor(struct page *page)
+static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
 {
-	if (!ptlock_init(page_ptdesc(page)))
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	if (!ptlock_init(ptdesc))
 		return false;
-	__SetPageTable(page);
-	inc_lruvec_page_state(page, NR_PAGETABLE);
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
 	return true;
 }
 
+static inline bool pgtable_pte_page_ctor(struct page *page)
+{
+	return pagetable_pte_ctor(page_ptdesc(page));
+}
+
+static inline void pagetable_pte_dtor(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	ptlock_free(ptdesc);
+	__folio_clear_pgtable(folio);
+	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+}
+
 static inline void pgtable_pte_page_dtor(struct page *page)
 {
-	ptlock_free(page_ptdesc(page));
-	__ClearPageTable(page);
-	dec_lruvec_page_state(page, NR_PAGETABLE);
+	pagetable_pte_dtor(page_ptdesc(page));
 }
 
 pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
@@ -3026,20 +3040,34 @@ static inline spinlock_t *pmd_lock(struc
 	return ptl;
 }
 
-static inline bool pgtable_pmd_page_ctor(struct page *page)
+static inline bool pagetable_pmd_ctor(struct ptdesc *ptdesc)
 {
-	if (!pmd_ptlock_init(page_ptdesc(page)))
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	if (!pmd_ptlock_init(ptdesc))
 		return false;
-	__SetPageTable(page);
-	inc_lruvec_page_state(page, NR_PAGETABLE);
+	__folio_set_pgtable(folio);
+	lruvec_stat_add_folio(folio, NR_PAGETABLE);
 	return true;
 }
 
+static inline bool pgtable_pmd_page_ctor(struct page *page)
+{
+	return pagetable_pmd_ctor(page_ptdesc(page));
+}
+
+static inline void pagetable_pmd_dtor(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	pmd_ptlock_free(ptdesc);
+	__folio_clear_pgtable(folio);
+	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
+}
+
 static inline void pgtable_pmd_page_dtor(struct page *page)
 {
-	pmd_ptlock_free(page_ptdesc(page));
-	__ClearPageTable(page);
-	dec_lruvec_page_state(page, NR_PAGETABLE);
+	pagetable_pmd_dtor(page_ptdesc(page));
 }
 
 /*
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

