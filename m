From: akpm@linux-foundation.org
Subject: - rtc-rtc-s3c-add-__devexit-and-__devinit-markers.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:25 -0700
Message-ID: <200807242330.m6ONUPUk011505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756719AbYGXXbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc-s3c: add __devexit and __devinit markers
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s3c-add-__devexit-and-__devinit-markers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc-s3c: add __devexit and __devinit markers
From: Ben Dooks <ben-linux@fluff.org>

Add the relevant __devinit and __devexit attributes to the rtc-s3c driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-add-__devexit-and-__devinit-markers drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-add-__devexit-and-__devinit-markers
+++ a/drivers/rtc/rtc-s3c.c
@@ -430,7 +430,7 @@ static void s3c_rtc_enable(struct platfo
 	}
 }
 
-static int s3c_rtc_remove(struct platform_device *dev)
+static int __devexit s3c_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
@@ -447,7 +447,7 @@ static int s3c_rtc_remove(struct platfor
 	return 0;
 }
 
-static int s3c_rtc_probe(struct platform_device *pdev)
+static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
@@ -560,7 +560,7 @@ static int s3c_rtc_resume(struct platfor
 
 static struct platform_driver s3c2410_rtcdrv = {
 	.probe		= s3c_rtc_probe,
-	.remove		= s3c_rtc_remove,
+	.remove		= __devexit_p(s3c_rtc_remove),
 	.suspend	= s3c_rtc_suspend,
 	.resume		= s3c_rtc_resume,
 	.driver		= {
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

