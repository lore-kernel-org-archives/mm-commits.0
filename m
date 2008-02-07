From: akpm@linux-foundation.org
Subject: - atmel_spi-fix-dmachain-oops-with-debug-enabled.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:49 -0800
Message-ID: <200802070025.m170PUL4006722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934561AbYBGArE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     atmel_spi: fix dmachain oops with DEBUG enabled
has been removed from the -mm tree.  Its filename was
     atmel_spi-fix-dmachain-oops-with-debug-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
 		spi_writel(as, RCR, len);
 		spi_writel(as, TCR, len);
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
 		spi_writel(as, RNCR, len);
 		spi_writel(as, TNCR, len);
+
+		dev_dbg(&msg->spi->dev,
+			"  next xfer %p: len %u tx %p/%08x rx %p/%08x\n",
+			xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
+			xfer->rx_buf, xfer->rx_dma);
 	} else {
 		spi_writel(as, RNCR, 0);
 		spi_writel(as, TNCR, 0);
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

origin.patch
git-avr32.patch
git-mtd.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
atmel_serial-clean-up-the-code.patch
atmel_serial-use-cpu_relax-when-busy-waiting.patch
atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
atmel_serial-add-dma-support-fix.patch
atmel_serial-fix-broken-rx-buffer-allocation.patch
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
