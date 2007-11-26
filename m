From: akpm@linux-foundation.org
Subject: + atmel_spi-fix-dmachain-oops-with-debug-enabled.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:56:06 -0800
Message-ID: <200711262356.lAQNu6ga029647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755709AbXKZX4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:56:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, dbrownell@users.sourceforge.net


The patch titled
     atmel_spi: fix dmachain oops with DEBUG enabled
has been added to the -mm tree.  Its filename is
     atmel_spi-fix-dmachain-oops-with-debug-enabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_spi: fix dmachain oops with DEBUG enabled
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

In atmel_spi_next_xfer, xfer can be NULL because the next transfer may
already have been submitted to the PDC (using DMA chaining).  This can
cause an oops, since the debug message assumed it was never null.  The
fix changes how those debug messages are issued, ensuring that one is
issued each time a transfer is started instead of once per call.

Also, properly indent the "can this transfer be chained" test so it's
not hidden as if it were non-conditional code.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-fix-dmachain-oops-with-debug-enabled drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-fix-dmachain-oops-with-debug-enabled
+++ a/drivers/spi/atmel_spi.c
@@ -198,6 +198,11 @@ static void atmel_spi_next_xfer(struct s
 			len >>= 1;
 		spi_writel(as, TCR, len);
 		spi_writel(as, RCR, len);
+
+		dev_dbg(&msg->spi->dev,
+			"  start xfer %p: len %u tx %p/%08x rx %p/%08x\n",
+			xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
+			xfer->rx_buf, xfer->rx_dma);
 	} else {
 		xfer = as->next_transfer;
 		remaining = as->next_remaining_bytes;
@@ -208,8 +213,8 @@ static void atmel_spi_next_xfer(struct s
 
 	if (remaining > 0)
 		len = remaining;
-	else if (!atmel_spi_xfer_is_last(msg, xfer) &&
-		atmel_spi_xfer_can_be_chained(xfer)) {
+	else if (!atmel_spi_xfer_is_last(msg, xfer)
+			&& atmel_spi_xfer_can_be_chained(xfer)) {
 		xfer = list_entry(xfer->transfer_list.next,
 				struct spi_transfer, transfer_list);
 		len = xfer->len;
@@ -230,6 +235,11 @@ static void atmel_spi_next_xfer(struct s
 			len >>= 1;
 		spi_writel(as, TNCR, len);
 		spi_writel(as, RNCR, len);
+
+		dev_dbg(&msg->spi->dev,
+			"  next xfer %p: len %u tx %p/%08x rx %p/%08x\n",
+			xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
+			xfer->rx_buf, xfer->rx_dma);
 	} else {
 		spi_writel(as, TNCR, 0);
 		spi_writel(as, RNCR, 0);
@@ -246,12 +256,6 @@ static void atmel_spi_next_xfer(struct s
 	 * It should be doable, though. Just not now...
 	 */
 	spi_writel(as, IER, SPI_BIT(ENDRX) | SPI_BIT(OVRES));
-
-	dev_dbg(&msg->spi->dev,
-		"  start xfer %p: len %u tx %p/%08x rx %p/%08x imr %03x\n",
-		xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
-		xfer->rx_buf, xfer->rx_dma, spi_readl(as, IMR));
-
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
 }
 
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

atmel_spi-labels-gpios-better.patch
git-avr32.patch
git-mtd.patch
read_current_time-cleanups.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
generic-gpio-gpio_chip-support.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
