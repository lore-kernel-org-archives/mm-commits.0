From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-support-for-lsb-first-transfers.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:30:54 -0700
Message-ID: <200707310130.l6V1UsYx008514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762626AbXGaBbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:31:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org


The patch titled
     spi_mpc83xx: support for lsb-first transfers
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-support-for-lsb-first-transfers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi_mpc83xx: support for lsb-first transfers
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This controller supports LSB-first transfers; let drivers use them.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-support-for-lsb-first-transfers drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-support-for-lsb-first-transfers
+++ a/drivers/spi/spi_mpc83xx.c
@@ -153,13 +153,16 @@ static void mpc83xx_spi_chipselect(struc
 			len = len - 1;
 
 		/* mask out bits we are going to set */
-		regval &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH |
-			    SPMODE_LEN(0xF) | SPMODE_DIV16 | SPMODE_PM(0xF));
+		regval &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH
+				| SPMODE_LEN(0xF) | SPMODE_DIV16
+				| SPMODE_PM(0xF) | SPMODE_REV);
 
 		if (spi->mode & SPI_CPHA)
 			regval |= SPMODE_CP_BEGIN_EDGECLK;
 		if (spi->mode & SPI_CPOL)
 			regval |= SPMODE_CI_INACTIVEHIGH;
+		if (!(spi->mode & SPI_LSB_FIRST))
+			regval |= SPMODE_REV;
 
 		regval |= SPMODE_LEN(len);
 
@@ -248,9 +251,11 @@ int mpc83xx_spi_setup_transfer(struct sp
 
 	regval = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
 
-	/* Mask out bits_per_wordgth */
-	regval &= ~SPMODE_LEN(0xF);
+	/* mask out bits we are going to set */
+	regval &= ~(SPMODE_LEN(0xF) | SPMODE_REV);
 	regval |= SPMODE_LEN(bits_per_word);
+	if (!(spi->mode & SPI_LSB_FIRST))
+		regval |= SPMODE_REV;
 
 	/* Turn off SPI unit prior changing mode */
 	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, 0);
@@ -260,7 +265,7 @@ int mpc83xx_spi_setup_transfer(struct sp
 }
 
 /* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST)
 
 static int mpc83xx_spi_setup(struct spi_device *spi)
 {
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch
spi_mpc83xx-get-rid-of-magic-numbers.patch
spi_mpc83xx-support-for-lsb-first-transfers.patch
spi_mpc83xx-fix-qelsb-mode-shifts.patch
