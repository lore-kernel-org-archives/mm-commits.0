Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD32C2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 233DE611CE
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhFQEHV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhFQEHV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 00:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E199E61026;
        Thu, 17 Jun 2021 04:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623902713;
        bh=3nPYR0djHKu5pVYlJnomEkO3afoRa5/EveX/y5q25Bk=;
        h=Date:From:To:Subject:From;
        b=Mi5UHGXOancrdND0yLzDO/FHwcYXSD/Jx1KYzK00NHznh7pHTqj1jcqkkXt/3E3kD
         mXqMQlIUMiKAcge0hlm6OhiKZZt/Jnk2PZdHZANOhRD5JnIB8Cw5uPrL0XhK3VL4/p
         kq+Q4irUphnAWKhQxiAcsFAElUHOCaW9iGX+NVbw=
Date:   Wed, 16 Jun 2021 21:05:12 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  +
 =?US-ASCII?Q?mm-rename-pud=5Fpage=5Fvaddr-to-pud=5Fpgtable-and-make-it-?=
 =?US-ASCII?Q?return-pmd=5Ft-fix-2.patch?= added to -mm tree
Message-ID: <20210617040512.mobQmfKq4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2
has been added to the -mm tree.  Its filename is
     mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2

Link: https://lkml.kernel.org/r/87wnqtnb60.fsf@linux.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2
+++ a/arch/alpha/include/asm/pgtable.h
@@ -236,7 +236,7 @@ pmd_page_vaddr(pmd_t pmd)
 #define pmd_page(pmd)	(pfn_to_page(pmd_val(pmd) >> 32))
 #define pud_page(pud)	(pfn_to_page(pud_val(pud) >> 32))
 
-static inline pmd_t *pud_pgtable(pud_t pgd)
+extern inline pmd_t *pud_pgtable(pud_t pgd)
 {
 	return (pmd_t *)(PAGE_OFFSET + ((pud_val(pgd) & _PFN_MASK) >> (32-PAGE_SHIFT)));
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

