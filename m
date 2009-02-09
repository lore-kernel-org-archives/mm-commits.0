From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-get-dma-working-for-spi-flashes.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:15:12 -0800
Message-ID: <200902092215.n19MFCiG009044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbZBIWSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     Blackfin SPI Driver: get dma working for SPI flashes
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-get-dma-working-for-spi-flashes.patch

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
Subject: Blackfin SPI Driver: get dma working for SPI flashes
From: Mike Frysinger <vapier.adi@gmail.com>

When using a BF533-STAMP here with a W25X10 SPI flash.  It works fine when
enable_dma is disabled, but doesn't work at all when turning DMA on.  We
get just 0xff bytes back when trying to read the device.

Change the code around so that it programs the SPI first and then enables
DMA, it seems to work a lot better ...

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-get-dma-working-for-spi-flashes drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-get-dma-working-for-spi-flashes
+++ a/drivers/spi/spi_bfin5xx.c
@@ -761,11 +761,10 @@ static void pump_transfers(unsigned long
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
 
-		unsigned long dma_start_addr;
+		unsigned long dma_start_addr, flags;
 
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
-		bfin_spi_disable(drv_data);
 
 		/* config dma channel */
 		dev_dbg(&drv_data->pdev->dev, "doing dma transfer\n");
@@ -796,8 +795,7 @@ static void pump_transfers(unsigned long
 			enable_dma(drv_data->dma_channel);
 
 			/* start SPI transfer */
-			write_CTRL(drv_data,
-				(cr | BIT_CTL_TIMOD_DMA_TX | BIT_CTL_ENABLE));
+			write_CTRL(drv_data, cr | BIT_CTL_TIMOD_DMA_TX);
 
 			/* just return here, there can only be one transfer
 			 * in this mode
@@ -842,14 +840,22 @@ static void pump_transfers(unsigned long
 		} else
 			BUG();
 
-		/* start dma */
-		dma_enable_irq(drv_data->dma_channel);
-		set_dma_config(drv_data->dma_channel, dma_config);
+		/* oh man, here there be monsters ... and i dont mean the
+		 * fluffy cute ones from pixar, i mean the kind that'll eat
+		 * your data, kick your dog, and love it all.  do *not* try
+		 * and change these lines unless you (1) heavily test DMA
+		 * with SPI flashes on a loaded system (e.g. ping floods),
+		 * (2) know just how broken the DMA engine interaction with
+		 * the SPI peripheral is, and (3) have someone else to blame
+		 * when you screw it all up anyways.
+		 */
 		set_dma_start_addr(drv_data->dma_channel, dma_start_addr);
+		set_dma_config(drv_data->dma_channel, dma_config);
+		local_irq_save(flags);
 		enable_dma(drv_data->dma_channel);
-
-		/* start SPI transfer */
-		write_CTRL(drv_data, (cr | BIT_CTL_ENABLE));
+		write_CTRL(drv_data, cr);
+		dma_enable_irq(drv_data->dma_channel);
+		local_irq_restore(flags);
 
 	} else {
 		/* IO mode write then read */
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

