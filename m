From: akpm@linux-foundation.org
Subject: + s3cmci-change-to-use-dev_pm_ops.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:57:09 -0700
Message-ID: <200909292257.n8TMv9x2025643__24633.5200303749$1254265045$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbZI2W5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, linux-mmc@vger.kernel.org


The patch titled
     s3cmci: change to use dev_pm_ops
has been added to the -mm tree.  Its filename is
     s3cmci-change-to-use-dev_pm_ops.patch

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
Subject: s3cmci: change to use dev_pm_ops
From: Ben Dooks <ben@simtec.co.uk>

Move to using dev_pm_ops for suspend and resume.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-change-to-use-dev_pm_ops drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-change-to-use-dev_pm_ops
+++ a/drivers/mmc/host/s3cmci.c
@@ -1546,35 +1546,42 @@ MODULE_DEVICE_TABLE(platform, s3cmci_dri
 
 #ifdef CONFIG_PM
 
-static int s3cmci_suspend(struct platform_device *dev, pm_message_t state)
+static int s3cmci_suspend(struct device *dev)
 {
-	struct mmc_host *mmc = platform_get_drvdata(dev);
+	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
+	struct pm_message event = { PM_EVENT_SUSPEND };
 
-	return  mmc_suspend_host(mmc, state);
+	return mmc_suspend_host(mmc, event);
 }
 
-static int s3cmci_resume(struct platform_device *dev)
+static int s3cmci_resume(struct device *dev)
 {
-	struct mmc_host *mmc = platform_get_drvdata(dev);
+	struct mmc_host *mmc = platform_get_drvdata(to_platform_device(dev));
 
 	return mmc_resume_host(mmc);
 }
 
+static struct dev_pm_ops s3cmci_pm = {
+	.suspend	= s3cmci_suspend,
+	.resume		= s3cmci_resume,
+};
+
+#define s3cmci_pm_ops &s3cmci_pm
 #else /* CONFIG_PM */
-#define s3cmci_suspend NULL
-#define s3cmci_resume NULL
+#define s3cmci_pm_ops NULL
 #endif /* CONFIG_PM */
 
 
 static struct platform_driver s3cmci_driver = {
-	.driver.name	= "s3c-sdi",
-	.driver.owner	= THIS_MODULE,
+	.driver	= {
+		.name	= "s3c-sdi",
+		.owner	= THIS_MODULE,
+		.pm	= s3cmci_pm_ops,
+	},
 	.id_table	= s3cmci_driver_ids,
 	.probe		= s3cmci_probe,
 	.remove		= __devexit_p(s3cmci_remove),
 	.shutdown	= s3cmci_shutdown,
-	.suspend	= s3cmci_suspend,
-	.resume		= s3cmci_resume,
 };
 
 static int __init s3cmci_init(void)
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

