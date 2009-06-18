From: akpm@linux-foundation.org
Subject: [merged] mpc52xx_psc_spi-convert-to-cs_control-callback.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:07 -0700
Message-ID: <200906182244.n5IMi7kG003124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758897AbZFRWoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     mpc52xx_psc_spi: convert to cs_control callback
has been removed from the -mm tree.  Its filename was
     mpc52xx_psc_spi-convert-to-cs_control-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpc52xx_psc_spi: convert to cs_control callback
From: Anton Vorontsov <avorontsov@ru.mvista.com>

mpc52xx_psc_spi driver is the last user of the legacy activate_cs and
deactivate_cs callbacks, so convert the driver to the cs_control hook and
remove the legacy callbacks from fsl_spi_platform_data struct.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |   22 +++++++++-------------
 include/linux/fsl_devices.h   |    4 ----
 2 files changed, 9 insertions(+), 17 deletions(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-convert-to-cs_control-callback drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-convert-to-cs_control-callback
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
@@ -30,8 +31,7 @@
 
 struct mpc52xx_psc_spi {
 	/* fsl_spi_platform data */
-	void (*activate_cs)(u8, u8);
-	void (*deactivate_cs)(u8, u8);
+	void (*cs_control)(struct spi_device *spi, bool on);
 	u32 sysclk;
 
 	/* driver internal data */
@@ -111,18 +111,16 @@ static void mpc52xx_psc_spi_activate_cs(
 	out_be16((u16 __iomem *)&psc->ccr, ccr);
 	mps->bits_per_word = cs->bits_per_word;
 
-	if (mps->activate_cs)
-		mps->activate_cs(spi->chip_select,
-				(spi->mode & SPI_CS_HIGH) ? 1 : 0);
+	if (mps->cs_control)
+		mps->cs_control(spi, (spi->mode & SPI_CS_HIGH) ? 1 : 0);
 }
 
 static void mpc52xx_psc_spi_deactivate_cs(struct spi_device *spi)
 {
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
 
-	if (mps->deactivate_cs)
-		mps->deactivate_cs(spi->chip_select,
-				(spi->mode & SPI_CS_HIGH) ? 1 : 0);
+	if (mps->cs_control)
+		mps->cs_control(spi, (spi->mode & SPI_CS_HIGH) ? 0 : 1);
 }
 
 #define MPC52xx_PSC_BUFSIZE (MPC52xx_PSC_RFNUM_MASK + 1)
@@ -382,15 +380,13 @@ static int __init mpc52xx_psc_spi_do_pro
 	mps->irq = irq;
 	if (pdata == NULL) {
 		dev_warn(dev, "probe called without platform data, no "
-				"(de)activate_cs function will be called\n");
-		mps->activate_cs = NULL;
-		mps->deactivate_cs = NULL;
+				"cs_control function will be called\n");
+		mps->cs_control = NULL;
 		mps->sysclk = 0;
 		master->bus_num = bus_num;
 		master->num_chipselect = 255;
 	} else {
-		mps->activate_cs = pdata->activate_cs;
-		mps->deactivate_cs = pdata->deactivate_cs;
+		mps->cs_control = pdata->cs_control;
 		mps->sysclk = pdata->sysclk;
 		master->bus_num = pdata->bus_num;
 		master->num_chipselect = pdata->max_chipselect;
diff -puN include/linux/fsl_devices.h~mpc52xx_psc_spi-convert-to-cs_control-callback include/linux/fsl_devices.h
--- a/include/linux/fsl_devices.h~mpc52xx_psc_spi-convert-to-cs_control-callback
+++ a/include/linux/fsl_devices.h
@@ -79,10 +79,6 @@ struct fsl_spi_platform_data {
 	u16	max_chipselect;
 	void	(*cs_control)(struct spi_device *spi, bool on);
 	u32	sysclk;
