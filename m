From: akpm@osdl.org
Subject: - s3c24xx-fix-passing-spi-chipselect-to-select-routine.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:09 -0800
Message-ID: <200701270131.l0R1V921031816@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXA0Bba (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     S3C24XX: fix passing spi chipselect to select routine
has been removed from the -mm tree.  Its filename was
     s3c24xx-fix-passing-spi-chipselect-to-select-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: S3C24XX: fix passing spi chipselect to select routine
From: Ben Dooks <ben-linux@fluff.org>

It turns out that the spi chipselect was not being passed to the set_cs
routine if one was specified in the platform data.

As part of the fix, change to using a set_cs field in the controller state,
and put a default gpio routine in if the data passed does not specify it.

Also remove the //#define DEBUG

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/spi_s3c24xx.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~s3c24xx-fix-passing-spi-chipselect-to-select-routine drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~s3c24xx-fix-passing-spi-chipselect-to-select-routine
+++ a/drivers/spi/spi_s3c24xx.c
@@ -10,9 +10,6 @@
  *
 */
 
-
-//#define DEBUG
-
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -44,6 +41,9 @@ struct s3c24xx_spi {
 	int			 len;
 	int			 count;
 
+	int			(*set_cs)(struct s3c2410_spi_info *spi,
+					  int cs, int pol);
+
 	/* data buffers */
 	const unsigned char	*tx;
 	unsigned char		*rx;
@@ -64,6 +64,11 @@ static inline struct s3c24xx_spi *to_hw(
 	return spi_master_get_devdata(sdev->master);
 }
 
+static void s3c24xx_spi_gpiocs(struct s3c2410_spi_info *spi, int cs, int pol)
+{
+	s3c2410_gpio_setpin(spi->pin_cs, pol);
+}
+
 static void s3c24xx_spi_chipsel(struct spi_device *spi, int value)
 {
 	struct s3c24xx_spi *hw = to_hw(spi);
@@ -72,10 +77,7 @@ static void s3c24xx_spi_chipsel(struct s
 
 	switch (value) {
 	case BITBANG_CS_INACTIVE:
-		if (hw->pdata->set_cs)
-			hw->pdata->set_cs(hw->pdata, value, cspol);
-		else
-			s3c2410_gpio_setpin(hw->pdata->pin_cs, cspol ^ 1);
+		hw->pdata->set_cs(hw->pdata, spi->chip_select, cspol^1);
 		break;
 
 	case BITBANG_CS_ACTIVE:
@@ -96,14 +98,9 @@ static void s3c24xx_spi_chipsel(struct s
 		/* write new configration */
 
 		writeb(spcon, hw->regs + S3C2410_SPCON);
-
-		if (hw->pdata->set_cs)
-			hw->pdata->set_cs(hw->pdata, value, cspol);
-		else
-			s3c2410_gpio_setpin(hw->pdata->pin_cs, cspol);
+		hw->pdata->set_cs(hw->pdata, spi->chip_select, cspol);
 
 		break;
-
 	}
 }
 
@@ -330,9 +327,12 @@ static int s3c24xx_spi_probe(struct plat
 	/* setup any gpio we can */
 
 	if (!hw->pdata->set_cs) {
+		hw->set_cs = s3c24xx_spi_gpiocs;
+
 		s3c2410_gpio_setpin(hw->pdata->pin_cs, 1);
 		s3c2410_gpio_cfgpin(hw->pdata->pin_cs, S3C2410_GPIO_OUTPUT);
-	}
+	} else
+		hw->set_cs = hw->pdata->set_cs;
 
 	/* register our spi controller */
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
git-watchdog.patch
spi-add-spi_set_drvdata-and-spi_get_drvdata.patch
spi-documentation-does-not-need-to-set-drivers-bus_type-field.patch
spi-remove-return-in-spi_unregister_driver.patch
