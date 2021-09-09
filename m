Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124D1C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE277611CE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349005AbhIIVEC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348297AbhIIVDS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B2F2611C0;
        Thu,  9 Sep 2021 21:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221328;
        bh=MtinpRgsCxypvnQWdxCscvS69JX0Lb87l4cjXLzZP6E=;
        h=Date:From:To:Subject:From;
        b=GjtS4sR3t24Nzu0SEMagQSoVzxBOdct+xTd2XDAbRFxyaDfBpoDiVZ9ZVQBLF/By7
         8gXBYFd79eByN54TnkJWL8sFFUHPOhKctGaA+dSrPVwte7yLs1RqDHvvhvcDD2UMZk
         jO4xWJURC/+X3HUqMvDaVgK93IrO28HNcpWt+hLU=
Date:   Thu, 09 Sep 2021 14:02:08 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, mm-commits@vger.kernel.org, npiggin@gmail.com,
        peterz@infradead.org
Subject:  [merged]
 riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch removed
 from -mm tree
Message-ID: <20210909210208.xi6WTrKiX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: only select GENERIC_IOREMAP if MMU support is enabled
has been removed from the -mm tree.  Its filename was
     riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: riscv: only select GENERIC_IOREMAP if MMU support is enabled

nommu ioremap is an inline stub in asm-generic/io.h.

Link: https://lkml.kernel.org/r/20210825072036.GA29161@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig~riscv-only-select-generic_ioremap-if-mmu-support-is-enabled
+++ a/arch/riscv/Kconfig
@@ -48,7 +48,7 @@ config RISCV
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_GETTIMEOFDAY if HAVE_GENERIC_VDSO
-	select GENERIC_IOREMAP
+	select GENERIC_IOREMAP if MMU
 	select GENERIC_IRQ_MULTI_HANDLER
 	select GENERIC_IRQ_SHOW
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

