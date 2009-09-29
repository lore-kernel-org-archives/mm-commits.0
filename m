From: akpm@linux-foundation.org
Subject: + s3cmci-update-probe-to-use-new-platform-id-list.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:57:05 -0700
Message-ID: <200909292257.n8TMv5tF025558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbZI2W5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:57:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, linux-mmc@vger.kernel.org


The patch titled
     s3cmci: update probe to use new platform id list
has been added to the -mm tree.  Its filename is
     s3cmci-update-probe-to-use-new-platform-id-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: update probe to use new platform id list
From: Ben Dooks <ben@simtec.co.uk>

Use the platform id list to match the three different versions of the
hardware block that this driver supports.

This will change the prefix of the console messages produced by this
driver to be prefixed by s3c-mci instead of the hardware block name, such
as s3c2440-mci.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |   71 ++++++++++++------------------------
 1 file changed, 24 insertions(+), 47 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-update-probe-to-use-new-platform-id-list drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-update-probe-to-use-new-platform-id-list
+++ a/drivers/mmc/host/s3cmci.c
@@ -1244,11 +1244,14 @@ static inline void s3cmci_cpufreq_deregi
 }
 #endif
 
-static int __devinit s3cmci_probe(struct platform_device *pdev, int is2440)
+static int __devinit s3cmci_probe(struct platform_device *pdev)
 {
 	struct s3cmci_host *host;
 	struct mmc_host	*mmc;
 	int ret;
+	int is2440;
+
+	is2440 = platform_get_device_id(pdev)->driver_data;
 
 	mmc = mmc_alloc_host(sizeof(struct s3cmci_host), &pdev->dev);
 	if (!mmc) {
@@ -1473,20 +1476,22 @@ static int __devexit s3cmci_remove(struc
 	return 0;
 }
 
-static int __devinit s3cmci_2410_probe(struct platform_device *dev)
-{
-	return s3cmci_probe(dev, 0);
-}
+static struct platform_device_id s3cmci_driver_ids[] = {
+	{
+		.name	= "s3c2410-sdi",
+		.driver_data	= 0,
+	}, {
+		.name	= "s3c2412-sdi",
+		.driver_data	= 1,
+	}, {
+		.name	= "s3c2440-sdi",
+		.driver_data	= 1,
+	},
+	{ }
+};
 
-static int __devinit s3cmci_2412_probe(struct platform_device *dev)
-{
-	return s3cmci_probe(dev, 1);
-}
+MODULE_DEVICE_TABLE(platform, s3cmci_driver_ids);
 
-static int __devinit s3cmci_2440_probe(struct platform_device *dev)
-{
-	return s3cmci_probe(dev, 1);
-}
 
 #ifdef CONFIG_PM
 
@@ -1510,50 +1515,25 @@ static int s3cmci_resume(struct platform
 #endif /* CONFIG_PM */
 
 
-static struct platform_driver s3cmci_2410_driver = {
-	.driver.name	= "s3c2410-sdi",
-	.driver.owner	= THIS_MODULE,
-	.probe		= s3cmci_2410_probe,
-	.remove		= __devexit_p(s3cmci_remove),
-	.shutdown	= s3cmci_shutdown,
-	.suspend	= s3cmci_suspend,
-	.resume		= s3cmci_resume,
-};
-
-static struct platform_driver s3cmci_2412_driver = {
-	.driver.name	= "s3c2412-sdi",
-	.driver.owner	= THIS_MODULE,
-	.probe		= s3cmci_2412_probe,
-	.remove		= __devexit_p(s3cmci_remove),
-	.shutdown	= s3cmci_shutdown,
-	.suspend	= s3cmci_suspend,
-	.resume		= s3cmci_resume,
-};
-
-static struct platform_driver s3cmci_2440_driver = {
-	.driver.name	= "s3c2440-sdi",
+static struct platform_driver s3cmci_driver = {
+	.driver.name	= "s3c-sdi",
 	.driver.owner	= THIS_MODULE,
-	.probe		= s3cmci_2440_probe,
+	.id_table	= s3cmci_driver_ids,
+	.probe		= s3cmci_probe,
 	.remove		= __devexit_p(s3cmci_remove),
 	.shutdown	= s3cmci_shutdown,
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
 
-
 static int __init s3cmci_init(void)
 {
-	platform_driver_register(&s3cmci_2410_driver);
-	platform_driver_register(&s3cmci_2412_driver);
-	platform_driver_register(&s3cmci_2440_driver);
-	return 0;
+	return platform_driver_register(&s3cmci_driver);
 }
 
 static void __exit s3cmci_exit(void)
 {
-	platform_driver_unregister(&s3cmci_2410_driver);
-	platform_driver_unregister(&s3cmci_2412_driver);
-	platform_driver_unregister(&s3cmci_2440_driver);
+	platform_driver_unregister(&s3cmci_driver);
 }
 
 module_init(s3cmci_init);
@@ -1562,6 +1542,3 @@ module_exit(s3cmci_exit);
 MODULE_DESCRIPTION("Samsung S3C MMC/SD Card Interface driver");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Thomas Kleffel <tk@maintech.de>, Ben Dooks <ben-linux@fluff.org>");
-MODULE_ALIAS("platform:s3c2410-sdi");
-MODULE_ALIAS("platform:s3c2412-sdi");
-MODULE_ALIAS("platform:s3c2440-sdi");
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
s3cmci-use-resource_size-instead-of-local-macro.patch
s3cmci-update-probe-to-use-new-platform-id-list.patch
s3cmci-change-gpio-to-gpiolib-from-s3c24xx-specific-calls.patch
s3cmci-change-to-use-dev_pm_ops.patch
s3cmci-fix-direct-write-to-interrupt-mask.patch
s3cmci-add-debugfs-support-for-examining-driver-and-hardware-state.patch
s3cmci-add-sdio-irq-support.patch
s3cmci-kconfig-selection-for-pio-dma-both.patch
s3cmci-dma-fixes.patch
s3cmci-make-sdio-irq-hardware-irq-support-build-time-configurable.patch
s3cmci-add-better-support-for-no-card-detect-or-write-protect-available.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

