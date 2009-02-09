From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:15:14 -0800
Message-ID: <200902092215.n19MFExZ009048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbZBIWS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:18:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net


The patch titled
     Blackfin SPI Driver: add timeout while waiting for SPIF in dma irq handler
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch

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
Subject: Blackfin SPI Driver: add timeout while waiting for SPIF in dma irq handler
From: Mike Frysinger <vapier.adi@gmail.com>

The "while" endless loop will cause the system hang if hardware error, so
we add timeout control to make the system alive.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler
+++ a/drivers/spi/spi_bfin5xx.c
@@ -557,6 +557,7 @@ static irqreturn_t dma_irq_handler(int i
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
+	unsigned long timeout;
 	unsigned short dmastat = get_dma_curr_irqstat(drv_data->dma_channel);
 	u16 spistat = read_STAT(drv_data);
 
@@ -582,8 +583,17 @@ static irqreturn_t dma_irq_handler(int i
 			cpu_relax();
 	}
 
+	dev_dbg(&drv_data->pdev->dev,
+		"in dma_irq_handler dmastat:0x%x spistat:0x%x\n",
+		dmastat, read_STAT(drv_data));
+
+	timeout = jiffies + HZ;
 	while (!(read_STAT(drv_data) & SPIF))
-		cpu_relax();
+		if (!time_before(jiffies, timeout)) {
+			dev_warn(&drv_data->pdev->dev, "timeout waiting for SPIF");
+			break;
+		} else
+			cpu_relax();
 
 	if ((dmastat & DMA_ERR) && (spistat & RBSY)) {
 		msg->state = ERROR_STATE;
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

