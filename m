From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-support-loopback-mode.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:09 -0700
Message-ID: <200707312357.l6VNv99H029373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760515AbXHAAQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: support loopback mode
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-support-loopback-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
