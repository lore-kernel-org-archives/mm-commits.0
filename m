From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-support-loopback-mode.patch added to -mm tree
Date: Mon, 30 Jul 2007 21:50:03 -0700
Message-ID: <200707310450.l6V4o3av016157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150AbXGaEuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 00:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net


The patch titled
     spi_mpc83xx: support loopback mode
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-support-loopback-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi_mpc83xx: support loopback mode
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This exposes the hardware loopback mode to drivers, primarily for testing.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-support-loopback-mode drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-support-loopback-mode
+++ a/drivers/spi/spi_mpc83xx.c
@@ -39,6 +39,7 @@ struct mpc83xx_spi_reg {
 };
 
 /* SPI Controller mode register definitions */
+#define	SPMODE_LOOP		(1 << 30)
 #define	SPMODE_CI_INACTIVEHIGH	(1 << 29)
 #define	SPMODE_CP_BEGIN_EDGECLK	(1 << 28)
 #define	SPMODE_DIV16		(1 << 27)
@@ -155,7 +156,7 @@ static void mpc83xx_spi_chipselect(struc
 		/* mask out bits we are going to set */
 		regval &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH
 				| SPMODE_LEN(0xF) | SPMODE_DIV16
-				| SPMODE_PM(0xF) | SPMODE_REV);
+				| SPMODE_PM(0xF) | SPMODE_REV | SPMODE_LOOP);
 
 		if (spi->mode & SPI_CPHA)
 			regval |= SPMODE_CP_BEGIN_EDGECLK;
@@ -163,6 +164,8 @@ static void mpc83xx_spi_chipselect(struc
 			regval |= SPMODE_CI_INACTIVEHIGH;
 		if (!(spi->mode & SPI_LSB_FIRST))
 			regval |= SPMODE_REV;
+		if (spi->mode & SPI_LOOP)
+			regval |= SPMODE_LOOP;
 
 		regval |= SPMODE_LEN(len);
 
@@ -273,7 +276,8 @@ int mpc83xx_spi_setup_transfer(struct sp
 }
 
 /* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST)
+#define MODEBITS	(SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
+			| SPI_LSB_FIRST | SPI_LOOP)
 
 static int mpc83xx_spi_setup(struct spi_device *spi)
 {
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch
spi_mpc83xx-get-rid-of-magic-numbers.patch
spi_mpc83xx-support-for-lsb-first-transfers.patch
spi_mpc83xx-fix-qelsb-mode-shifts.patch
spi-loopback-mode-definition.patch
spidev-supports-more-communications-modes.patch
spidev_test-utility.patch
spi_mpc83xx-support-loopback-mode.patch
