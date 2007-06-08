From: akpm@linux-foundation.org
Subject: + atmel_spi-minor-updates.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:56:04 -0700
Message-ID: <200706080556.l585u4oL020522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbXFHF4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com


The patch titled
     atmel_spi: minor updates
has been added to the -mm tree.  Its filename is
     atmel_spi-minor-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_spi: minor updates
From: David Brownell <david-b@pacbell.net>

Minor updates to atmel_spi:

 - DMA:
    * Comments to explain the DMA policies
    * Report any mapping errors from spi_transfer()
    * Remove extra loop for DMA mapping

 - Diagnostics:  report minimum clock rate, if we need to reject a
   spi_setup() request because that rate is too low.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   57 ++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 12 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-minor-updates drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-minor-updates
+++ a/drivers/spi/atmel_spi.c
@@ -184,18 +184,39 @@ static void atmel_spi_next_message(struc
 	atmel_spi_next_xfer(master, msg);
 }
 
-static void
+/*
+ * For DMA, tx_buf/tx_dma have the same relationship as rx_buf/rx_dma:
+ *  - The buffer is either valid for CPU access, else NULL
+ *  - If the buffer is valid, so is its DMA addresss
+ *
+ * This driver manages the dma addresss unless message->is_dma_mapped.
+ */
+static int
 atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
 {
+	struct device	*dev = &as->pdev->dev;
+
 	xfer->tx_dma = xfer->rx_dma = INVALID_DMA_ADDRESS;
-	if (xfer->tx_buf)
-		xfer->tx_dma = dma_map_single(&as->pdev->dev,
+	if (xfer->tx_buf) {
+		xfer->tx_dma = dma_map_single(dev,
 				(void *) xfer->tx_buf, xfer->len,
 				DMA_TO_DEVICE);
-	if (xfer->rx_buf)
-		xfer->rx_dma = dma_map_single(&as->pdev->dev,
+		if (dma_mapping_error(xfer->tx_dma))
+			return -ENOMEM;
+	}
+	if (xfer->rx_buf) {
+		xfer->rx_dma = dma_map_single(dev,
 				xfer->rx_buf, xfer->len,
 				DMA_FROM_DEVICE);
+		if (dma_mapping_error(xfer->tx_dma)) {
+			if (xfer->tx_buf)
+				dma_unmap_single(dev,
+						xfer->tx_dma, xfer->len,
+						DMA_TO_DEVICE);
+			return -ENOMEM;
+		}
+	}
+	return 0;
 }
 
 static void atmel_spi_dma_unmap_xfer(struct spi_master *master,
@@ -398,8 +419,9 @@ static int atmel_spi_setup(struct spi_de
 		scbr = ((bus_hz + spi->max_speed_hz - 1)
 			/ spi->max_speed_hz);
 		if (scbr >= (1 << SPI_SCBR_SIZE)) {
-			dev_dbg(&spi->dev, "setup: %d Hz too slow, scbr %u\n",
-					spi->max_speed_hz, scbr);
+			dev_dbg(&spi->dev,
+				"setup: %d Hz too slow, scbr %u; min %ld Hz\n",
+				spi->max_speed_hz, scbr, bus_hz/255);
 			return -EINVAL;
 		}
 	} else
@@ -465,12 +487,19 @@ static int atmel_spi_transfer(struct spi
 			dev_dbg(&spi->dev, "no protocol options yet\n");
 			return -ENOPROTOOPT;
 		}
-	}
 
-	/* scrub dcache "early" */
-	if (!msg->is_dma_mapped) {
-		list_for_each_entry(xfer, &msg->transfers, transfer_list)
-			atmel_spi_dma_map_xfer(as, xfer);
+		/*
+		 * DMA map early, for performance (empties dcache ASAP) and
+		 * better fault reporting.  This is a DMA-only driver.
+		 *
+		 * NOTE that if dma_unmap_single() ever starts to do work on
+		 * platforms supported by this driver, we would need to clean
+		 * up mappings for previously-mapped transfers.
+		 */
+		if (!msg->is_dma_mapped) {
+			if (atmel_spi_dma_map_xfer(as, xfer) < 0)
+				return -ENOMEM;
+		}
 	}
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
@@ -537,6 +566,10 @@ static int __init atmel_spi_probe(struct
 
 	as = spi_master_get_devdata(master);
 
+	/*
+	 * Scratch buffer is used for throwaway rx and tx data.
+	 * It's coherent to minimize dcache pollution.
+	 */
 	as->buffer = dma_alloc_coherent(&pdev->dev, BUFFER_SIZE,
 					&as->buffer_dma, GFP_KERNEL);
 	if (!as->buffer)
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
git-leds.patch
git-mmc.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-controller-drivers-check-for-unsupported-modes-update.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
spi_lm70llp-parport-adapter-driver-correction.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
