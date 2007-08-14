From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-fix-prescale-modulus-calculation.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:14 -0700
Message-ID: <200708140503.l7E53EnK032040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37174 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932632AbXHNFLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: fix prescale modulus calculation
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-fix-prescale-modulus-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx: fix prescale modulus calculation
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Long ago I've noticed (but didn't pay much attention) that
spi_mpc83xx using PM calculations that differs from what
specs describe. I.e.

u8 pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 4);

While specs says: "The SPI baud rate generator clock source (either
system clock or system clock divided by 16, depending on DIV16 bit) is
divided by 4 * ([PM] + 1), a range from 4 to 64.".

Thus " - 1" is missing in the spi_mpc83xx's formula.

Why nobody noticed that bug? Probably because sysclk usually less then
user expects, e.g. you expect 200 MHz, but real clock is 198 MHz,
and integer rounding helps when this formula is used.

Suppose it's SPI in QE, SYSCLK at 198 MHz, thus SPIBRG at 99MHz, 25 MHz
requested.

PM = (99MHz / ( 25 MHz * 4 )), PM == 0, output SPICLK will be 24.75 MHz

At lower frequencies this bug is more noticeable, though.

And this bug shows itself in all its beauty if SYSCLK is equal or a bit
more than you expect (200 MHz SYSCLK, 100 MHz SPIBRG):
PM = (100MHz / ( 25 MHz * 4 )), PM == 1, output SPICLK will be 12.625 MHz!

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-prescale-modulus-calculation drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-prescale-modulus-calculation
+++ a/drivers/spi/spi_mpc83xx.c
@@ -148,6 +148,8 @@ static void mpc83xx_spi_chipselect(struc
 	if (value == BITBANG_CS_ACTIVE) {
 		u32 regval = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
 		u32 len = spi->bits_per_word;
+		u8 pm;
+
 		if (len == 32)
 			len = 0;
 		else
@@ -170,7 +172,7 @@ static void mpc83xx_spi_chipselect(struc
 		regval |= SPMODE_LEN(len);
 
 		if ((mpc83xx_spi->spibrg / spi->max_speed_hz) >= 64) {
-			u8 pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 64);
+			pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 64) - 1;
 			if (pm > 0x0f) {
 				dev_err(&spi->dev, "Requested speed is too "
 					"low: %d Hz. Will use %d Hz instead.\n",
@@ -180,7 +182,9 @@ static void mpc83xx_spi_chipselect(struc
 			}
 			regval |= SPMODE_PM(pm) | SPMODE_DIV16;
 		} else {
-			u8 pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 4);
+			pm = mpc83xx_spi->spibrg / (spi->max_speed_hz * 4);
+			if (pm)
+				pm--;
 			regval |= SPMODE_PM(pm);
 		}
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are
