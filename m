Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85749C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71296610CE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347628AbhIBV5i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347919AbhIBV53 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CAEF6056B;
        Thu,  2 Sep 2021 21:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619791;
        bh=FljwjJNeb19ng8Itudtmk6i0Nbl1UL1Ee2iUjqLrF0k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cCOAv7BljTyxj9fAgPUXdsih9IEamTewrCJshMPCzddH+Bg1CjB5SUMcXyVYRMhow
         S0IlJpnBzE7NNaALZaImid35t/iyHPtvko6ZSXS+Xcq0IJKYkuFywwWknVcI5QPokz
         hBhci5NNtnMSne92xRehYIohWJxpwk4Vt4hZ5R+k=
Date:   Thu, 02 Sep 2021 14:56:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexs@kernel.org, dalias@libc.org,
        deanbo422@gmail.com, deller@gmx.de, geoff@infradead.org,
        green.hu@gmail.com, guoren@kernel.org, hch@lst.de,
        James.Bottomley@HansenPartnership.com, linux-mm@kvack.org,
        linux@armlinux.org.uk, mm-commits@vger.kernel.org,
        nickhu@andestech.com, paul@crapouillou.net,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        ulf.hansson@linaro.org, ysato@users.osdn.me
Subject:  [patch 122/212] mmc: mmc_spi: replace
 flush_kernel_dcache_page with flush_dcache_page
Message-ID: <20210902215630.PmJBw1Scp%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
