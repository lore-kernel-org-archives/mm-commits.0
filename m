From: akpm@linux-foundation.org
Subject: - rtc-rtc-omap-footprint-shrinkage.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:13 -0700
Message-ID: <200807242330.m6ONUDRJ011477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756906AbYGXXa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-omap footprint shrinkage
has been removed from the -mm tree.  Its filename was
     rtc-rtc-omap-footprint-shrinkage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-omap footprint shrinkage
From: David Brownell <david-b@pacbell.net>

Shrink the runtime footprint of the OMAP1 RTC driver a bunch by removing
some old hacks and switching to platform_driver_probe().

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-rtc-omap-footprint-shrinkage drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-rtc-omap-footprint-shrinkage
+++ a/drivers/rtc/rtc-omap.c
@@ -92,18 +92,6 @@
 #define rtc_write(val, addr)	omap_writeb(val, OMAP_RTC_BASE + (addr))
 
 
-/* platform_bus isn't hotpluggable, so for static linkage it'd be safe
- * to get rid of probe() and remove() code ... too bad the driver struct
- * remembers probe(), that's about 25% of the runtime footprint!!
- */
-#ifndef	MODULE
-#undef	__devexit
-#undef	__devexit_p
-#define	__devexit	__exit
-#define	__devexit_p	__exit_p
-#endif
-
-
 /* we rely on the rtc framework to handle locking (rtc->ops_lock),
  * so the only other requirement is that register accesses which
  * require BUSY to be clear are made with IRQs locally disabled
@@ -324,7 +312,7 @@ static struct rtc_class_ops omap_rtc_ops
 static int omap_rtc_alarm;
 static int omap_rtc_timer;
 
-static int __devinit omap_rtc_probe(struct platform_device *pdev)
+static int __init omap_rtc_probe(struct platform_device *pdev)
 {
 	struct resource		*res, *mem;
 	struct rtc_device	*rtc;
@@ -440,7 +428,7 @@ fail:
 	return -EIO;
 }
 
-static int __devexit omap_rtc_remove(struct platform_device *pdev)
+static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device	*rtc = platform_get_drvdata(pdev);;
 
@@ -498,8 +486,7 @@ static void omap_rtc_shutdown(struct pla
 
 MODULE_ALIAS("platform:omap_rtc");
 static struct platform_driver omap_rtc_driver = {
-	.probe		= omap_rtc_probe,
-	.remove		= __devexit_p(omap_rtc_remove),
+	.remove		= __exit_p(omap_rtc_remove),
 	.suspend	= omap_rtc_suspend,
 	.resume		= omap_rtc_resume,
 	.shutdown	= omap_rtc_shutdown,
@@ -511,7 +498,7 @@ static struct platform_driver omap_rtc_d
 
 static int __init rtc_init(void)
 {
-	return platform_driver_register(&omap_rtc_driver);
+	return platform_driver_probe(&omap_rtc_driver, omap_rtc_probe);
 }
 module_init(rtc_init);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

