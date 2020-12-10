Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42958C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DF9E23C31
	for <mm-commits@archiver.kernel.org>; Thu, 10 Dec 2020 00:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgLJAJ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Dec 2020 19:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgLJAJ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 9 Dec 2020 19:09:59 -0500
Date:   Wed, 09 Dec 2020 16:09:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607558958;
        bh=4/apy4EFz2lpaftNEQn2nbLAWa9kYiRlQ5Opz7sSMAI=;
        h=From:To:Subject:From;
        b=cfKQS61w9asFMsuFkmIoN0txPnWnj8W2Z0UA/9imInlraqQqver7vV2Bxo/OkRkvq
         pDHkxlUEQx29LcjkR6smlkJe6zm7Q3HGHSVfI3bT5SfWT/V94+1IMTW8B4wat4ExtR
         Vvuoz/JRL9WuEnQy5TGneFKsYbWkpcXO4wCZxB5g=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        malat@debian.org, keescook@chromium.org, sfr@canb.auug.org.au
Subject:  + ubsan-enable-for-allconfig-builds-fix.patch added to -mm
 tree
Message-ID: <20201210000917.Ny3aZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add .data..Lubsan_data*/.data..Lubsan_type* sections explicitly
has been added to the -mm tree.  Its filename is
     ubsan-enable-for-allconfig-builds-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-enable-for-allconfig-builds-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-enable-for-allconfig-builds-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc: add .data..Lubsan_data*/.data..Lubsan_type* sections explicitly

Similarly to commit

  beba24ac5913 ("powerpc/32: Add .data..Lubsan_data*/.data..Lubsan_type* se=
ctions explicitly")

since CONFIG_UBSAN bits can now be enabled for all*config.

Link: https://lkml.kernel.org/r/20201208230157.42c42789@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/vmlinux.lds.S |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/kernel/vmlinux.lds.S~ubsan-enable-for-allconfig-builds-fix
+++ a/arch/powerpc/kernel/vmlinux.lds.S
@@ -313,6 +313,10 @@ SECTIONS
 #else
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		DATA_DATA
+#ifdef CONFIG_UBSAN
+		*(.data..Lubsan_data*)
+		*(.data..Lubsan_type*)
+#endif
 		*(.data.rel*)
 		*(.toc1)
 		*(.branch_lt)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernelh-split-out-mathematical-helpers-fix.patch
ubsan-enable-for-allconfig-builds-fix.patch
mm-simplify-follow_ptepmd-fix.patch

