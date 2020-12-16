Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90C0C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505BC23118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgLPEP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgLPEP0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:15:26 -0500
Date:   Tue, 15 Dec 2020 20:14:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608092086;
        bh=CNDet1mK47V/+jRLVSUzC/kZ1XInnSf4atJrPMxTpZA=;
        h=From:To:Subject:From;
        b=Hlr/7ebek3Zic7vJLbExQV43vsHLZsD1p5YIpczYg4JnCothnRIH7wQfCBMhwHgRk
         Nqran1y5OJ5I04DAEFcubj1Ld2kKUtCZ/5Ciu7ka2WyQya9ia9bU8fxU6LrkS6jSCr
         WVFb5TOJhIR75LFa71XcjF3NefZA9PXogo3p8j+8=
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, malat@debian.org,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 ubsan-enable-for-allconfig-builds-fix.patch removed from -mm tree
Message-ID: <20201216041445.n9x12_6Pz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add .data..Lubsan_data*/.data..Lubsan_type* sections explicitly
has been removed from the -mm tree.  Its filename was
     ubsan-enable-for-allconfig-builds-fix.patch

This patch was dropped because it was folded into ubsan-enable-for-allconfig-builds.patch

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

ubsan-enable-for-allconfig-builds.patch
mm-simplify-follow_ptepmd-fix.patch

