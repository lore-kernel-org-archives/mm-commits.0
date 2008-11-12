From: akpm@linux-foundation.org
Subject: + rtc-pxa27x-pxa3xx-driver-fixes-revised.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:09:36 -0800
Message-ID: <200811122309.mACN9apW013347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279AbYKLXKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net, jic23@cam.ac.uk, robert.jarzmik@free.fr


The patch titled
     rtc: pxa27x/pxa3xx driver fixes, revised
has been added to the -mm tree.  Its filename is
     rtc-pxa27x-pxa3xx-driver-fixes-revised.patch

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
Subject: rtc: pxa27x/pxa3xx driver fixes, revised
From: Alessandro Zummo <a.zummo@towertech.it>

Small fixes for the pxa27x/pxa3xx driver

- use platform_driver_probe
- fixed exit paths
- fixed probe sequence
- added missing include
- using linux/io.h instead of asm/io.h

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |   50 ++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~rtc-pxa27x-pxa3xx-driver-fixes-revised drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-pxa27x-pxa3xx-driver-fixes-revised
+++ a/drivers/rtc/rtc-pxa.c
@@ -19,13 +19,13 @@
  *
  */
 
+#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
-
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define TIMER_FREQ		CLOCK_TICK_RATE
 #define RTC_DEF_DIVIDER		(32768 - 1)
@@ -347,17 +347,19 @@ static const struct rtc_class_ops pxa_rt
 	.irq_set_freq = pxa_periodic_irq_set_freq,
 };
 
-static int __devinit pxa_rtc_probe(struct platform_device *pdev)
+static int __init pxa_rtc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct pxa_rtc *pxa_rtc;
 	int ret;
 	u32 rttr;
 
-	ret = -ENOMEM;
 	pxa_rtc = kzalloc(sizeof(struct pxa_rtc), GFP_KERNEL);
 	if (!pxa_rtc)
-		goto err_alloc;
+		return -ENOMEM;
+
+	spin_lock_init(&pxa_rtc->lock);
+	platform_set_drvdata(pdev, pxa_rtc);
 
 	ret = -ENXIO;
 	pxa_rtc->ress = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -377,20 +379,9 @@ static int __devinit pxa_rtc_probe(struc
 		goto err_ress;
 	}
 
-	pxa_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev, &pxa_rtc_ops,
-					   THIS_MODULE);
-	ret = PTR_ERR(pxa_rtc->rtc);
-	if (IS_ERR(pxa_rtc->rtc)) {
-		dev_err(dev, "Failed to register RTC device -> %d\n", ret);
-		goto err_rtc_reg;
-	}
-
-	spin_lock_init(&pxa_rtc->lock);
-	platform_set_drvdata(pdev, pxa_rtc);
-
 	ret = -ENOMEM;
 	pxa_rtc->base = ioremap(pxa_rtc->ress->start,
-				pxa_rtc->ress->end - pxa_rtc->ress->start + 1);
+				resource_size(pxa_rtc->ress));
 	if (!pxa_rtc->base) {
 		dev_err(&pdev->dev, "Unable to map pxa RTC I/O memory\n");
 		goto err_map;
@@ -408,31 +399,37 @@ static int __devinit pxa_rtc_probe(struc
 	}
 
 	rtsr_clear_bits(pxa_rtc, RTSR_PIALE | RTSR_RDALE1 | RTSR_HZE);
+
+	pxa_rtc->rtc = rtc_device_register("pxa-rtc", &pdev->dev, &pxa_rtc_ops,
+					   THIS_MODULE);
+	ret = PTR_ERR(pxa_rtc->rtc);
+	if (IS_ERR(pxa_rtc->rtc)) {
+		dev_err(dev, "Failed to register RTC device -> %d\n", ret);
+		goto err_rtc_reg;
+	}
+
 	device_init_wakeup(dev, 1);
 
 	return 0;
 
-err_map:
-	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(pxa_rtc->rtc);
 err_rtc_reg:
+	 iounmap(pxa_rtc->base);
 err_ress:
+err_map:
 	kfree(pxa_rtc);
-err_alloc:
 	return ret;
 }
 
-static int __devexit pxa_rtc_remove(struct platform_device *pdev)
+static int __exit pxa_rtc_remove(struct platform_device *pdev)
 {
 	struct pxa_rtc *pxa_rtc = platform_get_drvdata(pdev);
 
+	rtc_device_unregister(pxa_rtc->rtc);
+
 	spin_lock_irq(&pxa_rtc->lock);
 	iounmap(pxa_rtc->base);
-	pxa_rtc->base = NULL;
-	platform_set_drvdata(pdev, NULL);
 	spin_unlock_irq(&pxa_rtc->lock);
 
-	rtc_device_unregister(pxa_rtc->rtc);
 	kfree(pxa_rtc);
 
 	return 0;
@@ -462,7 +459,6 @@ static int pxa_rtc_resume(struct platfor
 #endif
 
 static struct platform_driver pxa_rtc_driver = {
-	.probe		= pxa_rtc_probe,
 	.remove		= __exit_p(pxa_rtc_remove),
 	.suspend	= pxa_rtc_suspend,
 	.resume		= pxa_rtc_resume,
@@ -474,7 +470,7 @@ static struct platform_driver pxa_rtc_dr
 static int __init pxa_rtc_init(void)
 {
 	if (cpu_is_pxa27x() || cpu_is_pxa3xx())
-		return platform_driver_register(&pxa_rtc_driver);
+		return platform_driver_probe(&pxa_rtc_driver, pxa_rtc_probe);
 
 	return -ENODEV;
 }
_

Patches currently in -mm which might be from a.zummo@towertech.it are

rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
add-dallas-ds1390-93-94-rtc-chips.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
rtc-add-alarm-update-irq-interfaces-version-2.patch
rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2.patch
rtc-driver-for-pxa27x-and-pxa3xx-soc.patch
rtc-pxa27x-pxa3xx-driver-fixes-revised.patch

