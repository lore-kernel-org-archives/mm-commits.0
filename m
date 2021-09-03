Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D032C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2693E6112E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349713AbhICU70 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350542AbhICU7X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8407E610FD;
        Fri,  3 Sep 2021 20:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702703;
        bh=FBqXfH12wAogdBknEeF9KBFNvJrOFrttiJL+qL5UrZk=;
        h=Date:From:To:Subject:From;
        b=rfwYsALmQN8EV0i4SaiDJwuv69KnmzWehc4NmG6v5G3fJN74RBUEivbE3Qe27banp
         uqwcoTz3a1+/BiRKoOTY4zxl3fD1mdKJkB3ySplB2onndapWDdImXoWUNPFZ4EDD9p
         U4HMeWikyroPj3XGM9rF3xeeN9EItk2Y7vS4TJz8=
Date:   Fri, 03 Sep 2021 13:58:22 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, dalias@libc.org, deanbo422@gmail.com,
        deller@gmx.de, geoff@infradead.org, green.hu@gmail.com,
        guoren@kernel.org, hch@lst.de,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mm-commits@vger.kernel.org, nickhu@andestech.com,
        paul@crapouillou.net, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, ulf.hansson@linaro.org,
        ysato@users.osdn.me
Subject:  [merged]
 mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch
 removed from -mm tree
Message-ID: <20210903205822.rlIpRhVZ_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmc: mmc_spi: replace flush_kernel_dcache_page with flush_dcache_page
has been removed from the -mm tree.  Its filename was
     mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mmc: mmc_spi: replace flush_kernel_dcache_page with flush_dcache_page

Pages passed to block drivers can be mapped page cache pages, so we must
use flush_dcache_page here instead of the more limited
flush_kernel_dcache_page that is intended for highmem pages only.

Link: https://lkml.kernel.org/r/20210712060928.4161649-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mmc_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/mmc_spi.c~mmc-mmc_spi-replace-flush_kernel_dcache_page-with-flush_dcache_page
+++ a/drivers/mmc/host/mmc_spi.c
@@ -948,7 +948,7 @@ mmc_spi_data_do(struct mmc_spi_host *hos
 
 		/* discard mappings */
 		if (direction == DMA_FROM_DEVICE)
-			flush_kernel_dcache_page(sg_page(sg));
+			flush_dcache_page(sg_page(sg));
 		kunmap(sg_page(sg));
 		if (dma_dev)
 			dma_unmap_page(dma_dev, dma_addr, PAGE_SIZE, dir);
_

Patches currently in -mm which might be from hch@lst.de are

riscv-only-select-generic_ioremap-if-mmu-support-is-enabled.patch
mm-move-ioremap_page_range-to-vmallocc.patch
mm-dont-allow-executable-ioremap-mappings.patch
proc-stop-using-seq_get_buf-in-proc_task_name.patch
kernel-unexport-get_mmtask_exe_file.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

