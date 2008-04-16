From: akpm@linux-foundation.org
Subject: - spi-spi_s3c24xx-must-initialize-bus_num.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:18 -0700
Message-ID: <200804162255.m3GMtIDX011103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbYDPW4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_s3c24xx must initialize bus_num
has been removed from the -mm tree.  Its filename was
     spi-spi_s3c24xx-must-initialize-bus_num.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_s3c24xx must initialize bus_num
From: Ben Dooks <ben-linux@fluff.org>

Pass the bus number we expect the S3C24XX SPI driver to attach to via the
platform data.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-must-initialize-bus_num drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-must-initialize-bus_num
+++ a/drivers/spi/spi_s3c24xx.c
@@ -238,6 +238,7 @@ static irqreturn_t s3c24xx_spi_irq(int i
 
 static int __init s3c24xx_spi_probe(struct platform_device *pdev)
 {
+	struct s3c2410_spi_info *pdata;
 	struct s3c24xx_spi *hw;
 	struct spi_master *master;
 	struct resource *res;
@@ -254,10 +255,10 @@ static int __init s3c24xx_spi_probe(stru
 	memset(hw, 0, sizeof(struct s3c24xx_spi));
 
 	hw->master = spi_master_get(master);
-	hw->pdata = pdev->dev.platform_data;
+	hw->pdata = pdata = pdev->dev.platform_data;
 	hw->dev = &pdev->dev;
 
-	if (hw->pdata == NULL) {
+	if (pdata == NULL) {
 		dev_err(&pdev->dev, "No platform data supplied\n");
 		err = -ENOENT;
 		goto err_no_pdata;
@@ -333,13 +334,13 @@ static int __init s3c24xx_spi_probe(stru
 
 	/* setup any gpio we can */
 
-	if (!hw->pdata->set_cs) {
+	if (!pdata->set_cs) {
 		hw->set_cs = s3c24xx_spi_gpiocs;
 
-		s3c2410_gpio_setpin(hw->pdata->pin_cs, 1);
-		s3c2410_gpio_cfgpin(hw->pdata->pin_cs, S3C2410_GPIO_OUTPUT);
+		s3c2410_gpio_setpin(pdata->pin_cs, 1);
+		s3c2410_gpio_cfgpin(pdata->pin_cs, S3C2410_GPIO_OUTPUT);
 	} else
-		hw->set_cs = hw->pdata->set_cs;
+		hw->set_cs = pdata->set_cs;
 
 	/* register our spi controller */
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
sm501-add-uart-support.patch
video-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

