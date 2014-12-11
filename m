From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-fix-class-device-registration.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:18 -0800
Message-ID: <5489eb2a.zNPFbW4BMdFc0NHB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406AbaLKTGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: fix class-device registration
has been removed from the -mm tree.  Its filename was
     rtc-omap-fix-class-device-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: fix class-device registration

Make sure not to register the class device until after the device has
been configured.

Currently, the device is not fully configured (e.g. 24-hour mode) when
the class device is registered, something which involves driver
callbacks for example to read the current time.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   46 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-fix-class-device-registration drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-fix-class-device-registration
+++ a/drivers/rtc/rtc-omap.c
@@ -413,16 +413,6 @@ static int __init omap_rtc_probe(struct
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
-	device_init_wakeup(&pdev->dev, true);
-
-	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
-			&omap_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto err;
-	}
-	platform_set_drvdata(pdev, rtc);
-
 	/*
 	 * disable interrupts
 	 *
@@ -446,19 +436,6 @@ static int __init omap_rtc_probe(struct
 	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
 		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
 
-	/* handle periodic and alarm irqs */
-	ret = devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
-			dev_name(&rtc->dev), rtc);
-	if (ret)
-		goto err;
-
-	if (omap_rtc_timer != omap_rtc_alarm) {
-		ret = devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
-				dev_name(&rtc->dev), rtc);
-		if (ret)
-			goto err;
-	}
-
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
 	reg = rtc_read(OMAP_RTC_CTRL_REG);
 	if (reg & (u8) OMAP_RTC_CTRL_STOP)
@@ -488,6 +465,29 @@ static int __init omap_rtc_probe(struct
 	if (reg != new_ctrl)
 		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
 
+	device_init_wakeup(&pdev->dev, true);
+
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+			&omap_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		goto err;
+	}
+	platform_set_drvdata(pdev, rtc);
+
+	/* handle periodic and alarm irqs */
+	ret = devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
+			dev_name(&rtc->dev), rtc);
+	if (ret)
+		goto err;
+
+	if (omap_rtc_timer != omap_rtc_alarm) {
+		ret = devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
+				dev_name(&rtc->dev), rtc);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 
 err:
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

