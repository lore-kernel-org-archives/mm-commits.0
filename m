Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3960AC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A8561CCC
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGHAiK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAiK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:38:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32B4061C7F;
        Thu,  8 Jul 2021 00:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704528;
        bh=syibbDwBo91REPzaxqy+qv0jdVivtMwaiAECy041JXI=;
        h=Date:From:To:Subject:From;
        b=UcwojtS9FoUTZbXkRPdNpyXWI7+aV56CFaHWM7gTBOWMwGcrvGy98c+0Ti+xNQ1Y7
         B/tlnJsp1MbhC/vSj1ICk+c74+/7Vc9trdpV6vc9eiJVgbaBCBtmh4JcxbPZCtMoIr
         zTUOi1I37IEaGgOaKWDcD7Ktge6V0n8vpF5EG/OQ=
Date:   Wed, 07 Jul 2021 17:35:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        npiggin@gmail.com, mpe@ellerman.id.au,
        kirill.shutemov@linux.intel.com, kaleshsingh@google.com,
        joel@joelfernandes.org, hughd@google.com,
        christophe.leroy@csgroup.eu, aneesh.kumar@linux.ibm.com
Subject:  [folded-merged]
 mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
 removed from -mm tree
Message-ID: <20210708003527.UYeya%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

This patch was dropped because it was folded into mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix

m68k build error reported by kernel robot.

  We may want to fixup pgd_page_vaddr correctly later. pgd_page_vaddr() gets
  cast to different pointer types based on architecture. But for now this
  should work? This ensure we keep the pgd_page_vaddr() same as before.

Link: https://lkml.kernel.org/r/87tulxnb2v.fsf@linux.ibm.com
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

 include/asm-generic/pgtable-nop4d.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/pgtable-nop4d.h~mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix
+++ a/include/asm-generic/pgtable-nop4d.h
@@ -41,7 +41,7 @@ static inline p4d_t *p4d_offset(pgd_t *p
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
 #define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(p4d_pgtable((p4d_t){ pgd }))
+#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
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

