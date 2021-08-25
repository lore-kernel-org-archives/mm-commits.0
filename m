Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43574C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 17:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29FA861076
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 17:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhHYROm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Aug 2021 13:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242145AbhHYROg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Aug 2021 13:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6F9661056;
        Wed, 25 Aug 2021 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629911630;
        bh=GviCmURbHCHdbVbBSWqh3M/H10sUIlI+DcZ4VJRWkY4=;
        h=Date:From:To:Subject:From;
        b=GTQM8jkXWMsD6NAHj71KXKkX8EaYuC6QdsEr7Zjw5/he4vQpxDhd2auQfbC+72EpJ
         p46WE3E96RolxpH2oPWQWLeqB4Fx2J+1Q1Ehp6pnEK+bdbugvT9h7P65Lz9UJGm7T8
         nFNubqgIrpm+dIe2qWJUVcHsSCwpl57xGGHnryX4=
Date:   Wed, 25 Aug 2021 10:13:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        npiggin@gmail.com, hch@lst.de
Subject:  +
 riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch added to
 -mm tree
Message-ID: <20210825171350.Q9YCJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv: only select GENERIC_IOREMAP if MMU support is enabled
has been added to the -mm tree.  Its filename is
     riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mmc-jz4740-remove-the-flush_kernel_dcache_page-call-in-jz4740_mmc_read_data.patch
mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
scatterlist-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
mm-remove-flush_kernel_dcache_page.patch
riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch
mm-move-ioremap_page_range-to-vmallocc.patch
mm-dont-allow-executable-ioremap-mappings.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch
kernel-unexport-get_mmtask_exe_file.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

