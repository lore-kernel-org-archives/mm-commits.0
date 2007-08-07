From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-in-qe-mode-use-sysclk-2.patch added to -mm tree
Date: Tue, 07 Aug 2007 10:22:20 -0700
Message-ID: <200708071722.l77HMKHM028377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760250AbXHGRXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 13:23:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net


The patch titled
     spi_mpc83xx:  in "QE mode", use sysclk/2
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-in-qe-mode-use-sysclk-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi_mpc83xx:  in "QE mode", use sysclk/2
From: Anton Vorontsov <avorontsov@ru.mvista.com>

For MPC8349E input to the SPI Baud Rate Generator is SYSCLK, but it's
SYSCLK/2 for MPC8323E (SPI in QE).  Fix this, and remove confusion by
renaming the mpc83xx_spi->sysclk member as mpc83xx_spi->spibrg.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-in-qe-mode-use-sysclk-2 drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-in-qe-mode-use-sysclk-2
+++ a/drivers/spi/spi_mpc83xx.c
@@ -86,7 +86,7 @@ struct mpc83xx_spi {
 
 	unsigned nsecs;		/* (clock cycle time)/2 */
 
-	u32 sysclk;
+	u32 spibrg;		/* SPIBRG input clock */
 	u32 rx_shift;		/* RX data reg shift when in qe mode */
 	u32 tx_shift;		/* TX data reg shift when in qe mode */
 
@@ -169,17 +169,18 @@ static void mpc83xx_spi_chipselect(struc
 
 		regval |= SPMODE_LEN(len);
 
-		if ((mpc83xx_spi->sysclk / spi->max_speed_hz) >= 64) {
-			u8 pm = mpc83xx_spi->sysclk / (spi->max_speed_hz * 64);
+		if ((mpc83xx_spi->spibrg / spi->max_speed_hz) >= 64) {
+			u8 pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 64);
 			if (pm > 0x0f) {
-				printk(KERN_WARNING "MPC83xx SPI: SPICLK can't be less then a SYSCLK/1024!\n"
-						"Requested SPICLK is %d Hz. Will use %d Hz instead.\n",
-						spi->max_speed_hz, mpc83xx_spi->sysclk / 1024);
+				dev_err(&spi->dev, "Requested speed is too "
+					"low: %d Hz. Will use %d Hz instead.\n",
+					spi->max_speed_hz,
+					mpc83xx_spi->spibrg / 1024);
 				pm = 0x0f;
 			}
 			regval |= SPMODE_PM(pm) | SPMODE_DIV16;
 		} else {
-			u8 pm = mpc83xx_spi->sysclk / (spi->max_speed_hz * 4);
+			u8 pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 4);
 			regval |= SPMODE_PM(pm);
 		}
 
@@ -429,13 +430,17 @@ static int __init mpc83xx_spi_probe(stru
 	mpc83xx_spi->bitbang.chipselect = mpc83xx_spi_chipselect;
 	mpc83xx_spi->bitbang.setup_transfer = mpc83xx_spi_setup_transfer;
 	mpc83xx_spi->bitbang.txrx_bufs = mpc83xx_spi_bufs;
-	mpc83xx_spi->sysclk = pdata->sysclk;
 	mpc83xx_spi->activate_cs = pdata->activate_cs;
 	mpc83xx_spi->deactivate_cs = pdata->deactivate_cs;
 	mpc83xx_spi->qe_mode = pdata->qe_mode;
 	mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u8;
 	mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u8;
 
+	if (mpc83xx_spi->qe_mode)
+		mpc83xx_spi->spibrg = pdata->sysclk / 2;
+	else
+		mpc83xx_spi->spibrg = pdata->sysclk;
+
 	mpc83xx_spi->rx_shift = 0;
 	mpc83xx_spi->tx_shift = 0;
 	if (mpc83xx_spi->qe_mode) {
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

spi_mpc83xx-in-qe-mode-use-sysclk-2.patch
