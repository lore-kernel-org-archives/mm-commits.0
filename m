From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:15:00 -0800
Message-ID: <200902092215.n19MF05Q008786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbZBIWPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:15:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     Blackfin SPI Driver: unify duplicated code in dma read/write paths
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: unify duplicated code in dma read/write paths
From: Mike Frysinger <vapier.adi@gmail.com>

For DMA TX/RX operation in pump_transfers, DMA contriguration code in TX
and RX paths are almost the same.  This patch unify the duplicated DMA
code to make it more readable.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   47 ++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths
+++ a/drivers/spi/spi_bfin5xx.c
@@ -756,18 +756,19 @@ static void pump_transfers(unsigned long
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
 
+		unsigned long dma_start_addr;
+
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
 		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
+		set_dma_x_count(drv_data->dma_channel, drv_data->len);
 		if (width == CFG_SPI_WORDSIZE16) {
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
 			set_dma_x_modify(drv_data->dma_channel, 2);
 			dma_width = WDSIZE_16;
 		} else {
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
 			set_dma_x_modify(drv_data->dma_channel, 1);
 			dma_width = WDSIZE_8;
 		}
@@ -802,6 +803,7 @@ static void pump_transfers(unsigned long
 		}
 
 		/* In dma mode, rx or tx must be NULL in one transfer */
+		dma_config = (RESTART | dma_width | DI_EN);
 		if (drv_data->rx != NULL) {
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
@@ -815,19 +817,9 @@ static void pump_transfers(unsigned long
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
 
-			set_dma_x_count(drv_data->dma_channel, drv_data->len);
-
-			/* start dma */
-			dma_enable_irq(drv_data->dma_channel);
-			dma_config = (WNR | RESTART | dma_width | DI_EN);
-			set_dma_config(drv_data->dma_channel, dma_config);
-			set_dma_start_addr(drv_data->dma_channel,
-					(unsigned long)drv_data->rx);
-			enable_dma(drv_data->dma_channel);
-
-			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAREAD | BIT_CTL_ENABLE));
+			dma_config |= WNR;
+			dma_start_addr = (unsigned long)drv_data->rx;
+			cr |= CFG_SPI_DMAREAD;
 
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
@@ -838,18 +830,21 @@ static void pump_transfers(unsigned long
 						(unsigned long) (drv_data->tx +
 						drv_data->len_in_bytes));
 
-			/* start dma */
-			dma_enable_irq(drv_data->dma_channel);
-			dma_config = (RESTART | dma_width | DI_EN);
-			set_dma_config(drv_data->dma_channel, dma_config);
-			set_dma_start_addr(drv_data->dma_channel,
-					(unsigned long)drv_data->tx);
-			enable_dma(drv_data->dma_channel);
+			dma_start_addr = (unsigned long)drv_data->tx;
+			cr |= CFG_SPI_DMAWRITE;
+
+		} else
+			BUG();
+
+		/* start dma */
+		dma_enable_irq(drv_data->dma_channel);
+		set_dma_config(drv_data->dma_channel, dma_config);
+		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
+		enable_dma(drv_data->dma_channel);
+
+		/* start SPI transfer */
+		write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
 
-			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | CFG_SPI_DMAWRITE | BIT_CTL_ENABLE));
-		}
 	} else {
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch
linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch
mtd-maps-blackfin-async-flash-maps-bfin-async-mtd-driver-needs-complex-mappings.patch
mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch
blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-add-a-few-more-dma-debug-messages.patch
blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any.patch
blackfin-spi-driver-use-the-properl-bit_ctl_xxx-defines.patch
blackfin-spi-driver-spi-slave-select-code-cleanup.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch
blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x.patch
blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch
blackfin-spi-driver-fix-null-pointer-crash.patch
blackfin-spi-driver-add-comment-about-full-duplex-dma-according-to-david-brownell.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

