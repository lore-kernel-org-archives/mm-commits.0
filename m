From: akpm@linux-foundation.org
Subject: - spi-omap2_mcspi-pio-rx-fix.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:47:59 -0800
Message-ID: <200801290148.m0T1m0td027313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbYA2Bs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kalle.valo@nokia.com, dbrownell@users.sourceforge.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     spi: omap2_mcspi PIO RX fix
has been removed from the -mm tree.  Its filename was
     spi-omap2_mcspi-pio-rx-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: omap2_mcspi PIO RX fix
From: Kalle Valo <kalle.valo@nokia.com>

Before transmission of the last word in PIO RX_ONLY mode rx+tx mode
is enabled:

	/* prevent last RX_ONLY read from triggering
	 * more word i/o: switch to rx+tx
	 */
	if (c == 0 && tx == NULL)
		mcspi_write_cs_reg(spi,
				OMAP2_MCSPI_CHCONF0, l);

But because c is decremented after the test, c will never be zero and
rx+tx will not be enabled. This breaks RX_ONLY mode PIO transfers.

Fix it by decrementing c in the beginning of the various I/O loops.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-pio-rx-fix drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-pio-rx-fix
+++ a/drivers/spi/omap2_mcspi.c
@@ -350,6 +350,7 @@ omap2_mcspi_txrx_pio(struct spi_device *
 		tx = xfer->tx_buf;
 
 		do {
+			c -= 1;
 			if (tx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
 						OMAP2_MCSPI_CHSTAT_TXS) < 0) {
@@ -380,7 +381,6 @@ omap2_mcspi_txrx_pio(struct spi_device *
 						word_len, *(rx - 1));
 #endif
 			}
-			c -= 1;
 		} while (c);
 	} else if (word_len <= 16) {
 		u16		*rx;
@@ -389,6 +389,7 @@ omap2_mcspi_txrx_pio(struct spi_device *
 		rx = xfer->rx_buf;
 		tx = xfer->tx_buf;
 		do {
+			c -= 2;
 			if (tx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
 						OMAP2_MCSPI_CHSTAT_TXS) < 0) {
@@ -419,7 +420,6 @@ omap2_mcspi_txrx_pio(struct spi_device *
 						word_len, *(rx - 1));
 #endif
 			}
-			c -= 2;
 		} while (c);
 	} else if (word_len <= 32) {
 		u32		*rx;
@@ -428,6 +428,7 @@ omap2_mcspi_txrx_pio(struct spi_device *
 		rx = xfer->rx_buf;
 		tx = xfer->tx_buf;
 		do {
+			c -= 4;
 			if (tx != NULL) {
 				if (mcspi_wait_for_reg_bit(chstat_reg,
 						OMAP2_MCSPI_CHSTAT_TXS) < 0) {
@@ -458,7 +459,6 @@ omap2_mcspi_txrx_pio(struct spi_device *
 						word_len, *(rx - 1));
 #endif
 			}
-			c -= 4;
 		} while (c);
 	}
 
_

Patches currently in -mm which might be from kalle.valo@nokia.com are
