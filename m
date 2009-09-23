From: akpm@linux-foundation.org
Subject: [merged] spi_s3c24xx-use-dev_pm_ops.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:23 -0700
Message-ID: <200909231958.n8NJwNTb008815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782AbZIWT6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx: use dev_pm_ops
has been removed from the -mm tree.  Its filename was
     spi_s3c24xx-use-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_s3c24xx: use dev_pm_ops
From: Ben Dooks <ben@simtec.co.uk>

Change the spi_s3c24xx driver to use dev_pm_ops to avoid the following
warning during probe:

Platform driver 's3c2410-spi' needs updating - please use dev_pm_ops

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-use-dev_pm_ops drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-use-dev_pm_ops
+++ a/drivers/spi/spi_s3c24xx.c
@@ -418,9 +418,9 @@ static int __exit s3c24xx_spi_remove(str
 
 #ifdef CONFIG_PM
 
-static int s3c24xx_spi_suspend(struct platform_device *pdev, pm_message_t msg)
+static int s3c24xx_spi_suspend(struct device *dev)
 {
-	struct s3c24xx_spi *hw = platform_get_drvdata(pdev);
+	struct s3c24xx_spi *hw = platform_get_drvdata(to_platform_device(dev));
 
 	if (hw->pdata && hw->pdata->gpio_setup)
 		hw->pdata->gpio_setup(hw->pdata, 0);
@@ -429,27 +429,31 @@ static int s3c24xx_spi_suspend(struct pl
 	return 0;
 }
 
-static int s3c24xx_spi_resume(struct platform_device *pdev)
+static int s3c24xx_spi_resume(struct device *dev)
 {
-	struct s3c24xx_spi *hw = platform_get_drvdata(pdev);
+	struct s3c24xx_spi *hw = platform_get_drvdata(to_platform_device(dev));
 
 	s3c24xx_spi_initialsetup(hw);
 	return 0;
 }
 
+static struct dev_pm_ops s3c24xx_spi_pmops = {
+	.suspend	= s3c24xx_spi_suspend,
+	.resume		= s3c24xx_spi_resume,
+};
+
+#define S3C24XX_SPI_PMOPS &s3c24xx_spi_pmops
 #else
-#define s3c24xx_spi_suspend NULL
-#define s3c24xx_spi_resume  NULL
-#endif
+#define S3C24XX_SPI_PMOPS NULL
+#endif /* CONFIG_PM */
 
 MODULE_ALIAS("platform:s3c2410-spi");
 static struct platform_driver s3c24xx_spi_driver = {
 	.remove		= __exit_p(s3c24xx_spi_remove),
-	.suspend	= s3c24xx_spi_suspend,
-	.resume		= s3c24xx_spi_resume,
 	.driver		= {
 		.name	= "s3c2410-spi",
 		.owner	= THIS_MODULE,
+		.pm	= S3C24XX_SPI_PMOPS,
 	},
 };
 
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

