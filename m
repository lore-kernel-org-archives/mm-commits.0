Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5943C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84D4761CCF
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhGHAhN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAhN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88CB361CCC;
        Thu,  8 Jul 2021 00:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704472;
        bh=1X7wawZc3tGREi6zK8a2EY7lrkhPXl0hdLJKVOxkvsY=;
        h=Date:From:To:Subject:From;
        b=KsFmonGZY+yknr3GA2Qnj/Dl9cQAi6tM7XSPXHl52wyorWvh8M+J0DfOEhGNDftaz
         8DHRuibuDRPt01dFGp2WWQt88ZXFYgMH217/Ftteo+AYJGXAWIhFUk1ePmoLKam7vq
         UUO9+dKT8x+Pw+/fZFAKPXNtUZ/WrStWhL63Tpa4=
Date:   Wed, 07 Jul 2021 17:34:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        npiggin@gmail.com, mpe@ellerman.id.au,
        kirill.shutemov@linux.intel.com, kaleshsingh@google.com,
        joel@joelfernandes.org, hughd@google.com,
        christophe.leroy@csgroup.eu, aneesh.kumar@linux.ibm.com
Subject:  [folded-merged]
 mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
 removed from -mm tree
Message-ID: <20210708003429.R-rkN%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2
has been removed from the -mm tree.  Its filename was
     mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch

This patch was dropped because it was folded into mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch

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
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-convert-huge-pud-move-to-separate-helper-fix.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

