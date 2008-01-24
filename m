From: akpm@linux-foundation.org
Subject: + spi-omap2_mcspi-pio-rx-fix.patch added to -mm tree
Date: Thu, 24 Jan 2008 14:00:21 -0800
Message-ID: <200801242200.m0OM0GeQ015604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755908AbYAXWBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jan 2008 17:01:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kalle.valo@nokia.com, dbrownell@users.sourceforge.net, stable@kernel.org


The patch titled
     spi: omap2_mcspi PIO RX fix
has been added to the -mm tree.  Its filename is
     spi-omap2_mcspi-pio-rx-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spi-omap2_mcspi-pio-rx-fix.patch
