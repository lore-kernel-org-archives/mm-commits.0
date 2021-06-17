Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46CAC2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8837E613E2
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhFQEH1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhFQEH1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 00:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31F261026;
        Thu, 17 Jun 2021 04:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623902720;
        bh=4rQoBO4BaxdOyLPYwDLZY6Myt0KB5EARBfM0iFYMjqI=;
        h=Date:From:To:Subject:From;
        b=Rvqr4iKEeYQzcLoAnwGeN5r46mniiJLr2VzttprCtsBf0QJa2c2dBexa3zK72UWL2
         orvBLHIfxi6m8jH3HMO6sFZO0eoDnJ/avqEbSFTv9gCoiQVr+kcklNTGuJN3wXTKe8
         zoKj3/SL96/Claa8Y7A2OLe23n4Pj27mm5hC6s+M=
Date:   Wed, 16 Jun 2021 21:05:19 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  +
 mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
 added to -mm tree
Message-ID: <20210617040519.QDsoIUvOY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix
has been added to the -mm tree.  Its filename is
     mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch

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
@@ -42,7 +42,7 @@ static inline p4d_t *p4d_offset(pgd_t *p
 #define __p4d(x)				((p4d_t) { __pgd(x) })
 
 #define pgd_page(pgd)				(p4d_page((p4d_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(p4d_pgtable((p4d_t){ pgd }))
+#define pgd_page_vaddr(pgd)			((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
 
 /*
  * allocating and freeing a p4d is trivial: the 1-entry p4d is
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

