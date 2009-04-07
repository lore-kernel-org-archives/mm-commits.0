From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:44 -0700
Message-ID: <200904071906.n37J6iDp010954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760778AbZDGTKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: tweak magic spi dma sequence to get it working on BF54x
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: tweak magic spi dma sequence to get it working on BF54x
From: Mike Frysinger <vapier.adi@gmail.com>

Without this change, SPI DMA is not reliably under stress tests. 
Obiviously it's a hardware issue which is not addressed by any document.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x
+++ a/drivers/spi/spi_bfin5xx.c
@@ -862,8 +862,9 @@ static void pump_transfers(unsigned long
 		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
 		set_dma_config(drv_data->dma_channel, dma_config);
 		local_irq_save(flags);
-		enable_dma(drv_data->dma_channel);
+		SSYNC();
 		write_CTRL(drv_data, cr);
+		enable_dma(drv_data->dma_channel);
 		dma_enable_irq(drv_data->dma_channel);
 		local_irq_restore(flags);
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

