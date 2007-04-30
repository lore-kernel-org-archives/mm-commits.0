From: akpm@linux-foundation.org
Subject: - blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:15:19 -0700
Message-ID: <200704301915.l3UJFKdQ012601@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946701AbXD3TPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin: spi driver fix reboot kernel mounting spi flash print error bug
has been removed from the -mm tree.  Its filename was
     blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch

This patch was dropped because it was folded into blackfin-blackfin-on-chip-spi-controller-driver.patch

------------------------------------------------------
Subject: Blackfin: spi driver fix reboot kernel mounting spi flash print error bug
From: "Wu, Bryan" <bryan.wu@analog.com>

This patch fix a printing error bug when reboot kernel mounting on SPI flash.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1203,14 +1203,6 @@ static int bfin5xx_spi_remove(struct pla
 	return 0;
 }
 
-static void bfin5xx_spi_shutdown(struct platform_device *pdev)
-{
-	int status = 0;
-
-	if ((status = bfin5xx_spi_remove(pdev)) != 0)
-		dev_err(&pdev->dev, "shutdown failed with %d\n", status);
-}
-
 /* PM, do nothing now */
 #ifdef CONFIG_PM
 static int suspend_devices(struct device *dev, void *pm_message)
@@ -1276,7 +1268,6 @@ static struct platform_driver driver = {
 		   },
 	.probe = bfin5xx_spi_probe,
 	.remove = __devexit_p(bfin5xx_spi_remove),
-	.shutdown = bfin5xx_spi_shutdown,
 	.suspend = bfin5xx_spi_suspend,
 	.resume = bfin5xx_spi_resume,
 };
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
