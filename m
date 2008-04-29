From: akpm@linux-foundation.org
Subject: + atmel_spi-clean-up-baud-rate-divisor-calculation.patch added to -mm tree
Date: Tue, 29 Apr 2008 13:15:42 -0700
Message-ID: <200804292015.m3TKFgbX007580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556AbYD2UP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 16:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, david-b@pacbell.net, jramakrishnan@neuropace.com


The patch titled
     atmel_spi: Clean up baud rate divisor calculation
has been added to the -mm tree.  Its filename is
     atmel_spi-clean-up-baud-rate-divisor-calculation.patch

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
Subject: atmel_spi: Clean up baud rate divisor calculation
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Make the baud rate divisor calculation code a bit more readable and add a
few comments.

Also fix wrong debug information being displayed when !new_1 and
max_speed_hz == 0.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: "Janesh Ramakrishnan" <jramakrishnan@neuropace.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-clean-up-baud-rate-divisor-calculation drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-clean-up-baud-rate-divisor-calculation
+++ a/drivers/spi/atmel_spi.c
@@ -536,14 +536,25 @@ static int atmel_spi_setup(struct spi_de
 		return -EINVAL;
 	}
 
-	/* speed zero convention is used by some upper layers */
+	/*
+	 * Pre-new_1 chips start out at half the peripheral
+	 * bus speed.
+	 */
 	bus_hz = clk_get_rate(as->clk);
+	if (!as->new_1)
+		bus_hz /= 2;
+
 	if (spi->max_speed_hz) {
-		/* assume div32/fdiv/mbz == 0 */
-		if (!as->new_1)
-			bus_hz /= 2;
-		scbr = ((bus_hz + spi->max_speed_hz - 1)
-			/ spi->max_speed_hz);
+		/*
+		 * Calculate the lowest divider that satisfies the
+		 * constraint, assuming div32/fdiv/mbz == 0.
+		 */
+		scbr = DIV_ROUND_UP(bus_hz, spi->max_speed_hz);
+
+		/*
+		 * If the resulting divider doesn't fit into the
+		 * register bitfield, we can't satisfy the constraint.
+		 */
 		if (scbr >= (1 << SPI_SCBR_SIZE)) {
 			dev_dbg(&spi->dev,
 				"setup: %d Hz too slow, scbr %u; min %ld Hz\n",
@@ -551,8 +562,8 @@ static int atmel_spi_setup(struct spi_de
 			return -EINVAL;
 		}
 	} else
+		/* speed zero means "as slow as possible" */
 		scbr = 0xff;
-	sck_hz = bus_hz / scbr;
 
 	csr = SPI_BF(SCBR, scbr) | SPI_BF(BITS, bits - 8);
 	if (spi->mode & SPI_CPOL)
@@ -587,6 +598,7 @@ static int atmel_spi_setup(struct spi_de
 		spin_unlock_irqrestore(&as->lock, flags);
 	}
 
+	sck_hz = bus_hz / scbr;
 	dev_dbg(&spi->dev,
 		"setup: %lu Hz bpw %u mode 0x%x -> csr%d %08x\n",
 		sck_hz, bits, spi->mode, spi->chip_select, csr);
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

origin.patch
atmel_spi-clean-up-baud-rate-divisor-calculation.patch

