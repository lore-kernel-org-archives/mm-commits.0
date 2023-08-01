Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD7EC00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 18:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjHAS5C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjHAS4k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 14:56:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F40A2722
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 11:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C947616AF
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 18:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE590C433C7;
        Tue,  1 Aug 2023 18:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690916190;
        bh=gsGkEIlHxri0yQjQCEw0F+88ADqyud4vk5hz2mJV75I=;
        h=Date:To:From:Subject:From;
        b=PtXNmNMoadda1dMw5nmSAVu+zIDHkYUU8admYQrBJrbZpntE31fHbfedJGH+9CdGF
         MiSbp7zfJCXsxnlDtOtEXYreU1rD95z+OVEJPdOM/IG8vt2d+IBUP2r9/3K8Shn9G6
         d2TTKAD7uqkaWdzuMFJdSOdi8floFAg2oVmtZYD8=
Date:   Tue, 01 Aug 2023 11:56:30 -0700
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
Subject: + mm-convert-ptlock_ptr-to-use-ptdescs.patch added to mm-unstable branch
Message-Id: <20230801185630.CE590C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert ptlock_ptr() to use ptdescs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-ptlock_ptr-to-use-ptdescs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-ptlock_ptr-to-use-ptdescs.patch

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
Subject: mm: convert ptlock_ptr() to use ptdescs
Date: Mon, 31 Jul 2023 10:03:07 -0700

This removes some direct accesses to struct page, working towards
splitting out struct ptdesc from struct page.

Link: https://lkml.kernel.org/r/20230731170332.69404-7-vishal.moola@gmail.com
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

 arch/x86/xen/mmu_pv.c |    2 +-
 include/linux/mm.h    |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/xen/mmu_pv.c~mm-convert-ptlock_ptr-to-use-ptdescs
+++ a/arch/x86/xen/mmu_pv.c
@@ -667,7 +667,7 @@ static spinlock_t *xen_pte_lock(struct p
 	spinlock_t *ptl = NULL;
 
 #if USE_SPLIT_PTE_PTLOCKS
-	ptl = ptlock_ptr(page);
+	ptl = ptlock_ptr(page_ptdesc(page));
 	spin_lock_nest_lock(ptl, &mm->page_table_lock);
 #endif
 
--- a/include/linux/mm.h~mm-convert-ptlock_ptr-to-use-ptdescs
+++ a/include/linux/mm.h
@@ -2857,9 +2857,9 @@ void __init ptlock_cache_init(void);
 bool ptlock_alloc(struct ptdesc *ptdesc);
 extern void ptlock_free(struct page *page);
 
-static inline spinlock_t *ptlock_ptr(struct page *page)
+static inline spinlock_t *ptlock_ptr(struct ptdesc *ptdesc)
 {
-	return page->ptl;
+	return ptdesc->ptl;
 }
 #else /* ALLOC_SPLIT_PTLOCKS */
 static inline void ptlock_cache_init(void)
@@ -2875,15 +2875,15 @@ static inline void ptlock_free(struct pa
 {
 }
 
-static inline spinlock_t *ptlock_ptr(struct page *page)
+static inline spinlock_t *ptlock_ptr(struct ptdesc *ptdesc)
 {
-	return &page->ptl;
+	return &ptdesc->ptl;
 }
 #endif /* ALLOC_SPLIT_PTLOCKS */
 
 static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
-	return ptlock_ptr(pmd_page(*pmd));
+	return ptlock_ptr(page_ptdesc(pmd_page(*pmd)));
 }
 
 static inline bool ptlock_init(struct page *page)
@@ -2898,7 +2898,7 @@ static inline bool ptlock_init(struct pa
 	VM_BUG_ON_PAGE(*(unsigned long *)&page->ptl, page);
 	if (!ptlock_alloc(page_ptdesc(page)))
 		return false;
-	spin_lock_init(ptlock_ptr(page));
+	spin_lock_init(ptlock_ptr(page_ptdesc(page)));
 	return true;
 }
 
@@ -2984,7 +2984,7 @@ static inline struct ptdesc *pmd_ptdesc(
 
 static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
 {
-	return ptlock_ptr(ptdesc_page(pmd_ptdesc(pmd)));
+	return ptlock_ptr(pmd_ptdesc(pmd));
 }
 
 static inline bool pmd_ptlock_init(struct page *page)
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

