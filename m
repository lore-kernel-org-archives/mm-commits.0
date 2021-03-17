Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F83CC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4396464F68
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCQXDd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCQXDY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:03:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F3EB64F2B;
        Wed, 17 Mar 2021 23:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616022204;
        bh=q35OP8Eb8aUsmez0Wohwi6rAb1PentpXm+BK+6xsDv0=;
        h=Date:From:To:Subject:From;
        b=P6AAsSQJWXoXaAp4/LDQZrlCZq+1NmaTn7+IubdN79DBKBEAES5Je122rYrRQZU+J
         gttYBh4F3Gmjqdk6TNmi7ZX8uanlH+dzmijIo2UZNYfhwVe6gTcEvFIbl5Jua7aZDQ
         GAsZ5QiaWnsl3NGW0evMFo56//KJjjFEu7K/fR7w=
Date:   Wed, 17 Mar 2021 16:03:22 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, catalin.marinas@arm.com, dingtianhong@huawei.com,
        hch@lst.de, hpa@zytor.com, linmiaohe@huawei.com,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        tglx@linutronix.de, urezki@gmail.com, will@kernel.org
Subject:  +
 arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch added to
 -mm tree
Message-ID: <20210317230322.x1alnq-am%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mm: add missing pud_page define to 2-level page tables
has been added to the -mm tree.  Its filename is
     arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: ARM: mm: add missing pud_page define to 2-level page tables

Patch series "huge vmalloc mappings", v13.


This patch (of 14):

ARM uses its own PMD folding scheme which is missing pud_page which should
just pass through to pmd_page.  Move this from the 3-level page table to
common header.

Link: https://lkml.kernel.org/r/20210317062402.533919-2-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    2 --
 arch/arm/include/asm/pgtable.h        |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/pgtable-3level.h~arm-mm-add-missing-pud_page-define-to-2-level-page-tables
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -186,8 +186,6 @@ static inline pte_t pte_mkspecial(pte_t
 
 #define pmd_write(pmd)		(pmd_isclear((pmd), L_PMD_SECT_RDONLY))
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
-#define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
-#define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
 #define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
--- a/arch/arm/include/asm/pgtable.h~arm-mm-add-missing-pud_page-define-to-2-level-page-tables
+++ a/arch/arm/include/asm/pgtable.h
@@ -166,6 +166,9 @@ extern struct page *empty_zero_page;
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
+#define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
+#define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
+
 #define pmd_none(pmd)		(!pmd_val(pmd))
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch
mm-apply_to_pte_range-warn-and-fail-if-a-large-pte-is-encountered.patch
mm-vmalloc-rename-vmap__range-vmap_pages__range.patch
mm-ioremap-rename-ioremap__range-to-vmap__range.patch
mm-huge_vmap-arch-support-cleanup.patch
powerpc-inline-huge-vmap-supported-functions.patch
arm64-inline-huge-vmap-supported-functions.patch
x86-inline-huge-vmap-supported-functions.patch
mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch
mm-move-vmap_range-from-mm-ioremapc-to-mm-vmallocc.patch
mm-vmalloc-add-vmap_range_noflush-variant.patch
mm-vmalloc-hugepage-vmalloc-mappings.patch
powerpc-64s-radix-enable-huge-vmalloc-mappings.patch

