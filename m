From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-clean-up-probe-error-handling.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:15 -0800
Message-ID: <5489eb27.1rNw2BDFprciN8kO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406AbaLKTGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: clean up probe error handling
has been removed from the -mm tree.  Its filename was
     rtc-omap-clean-up-probe-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: clean up probe error handling

Remove some debug messages and return errors from subsystems rather than
always fail with -EIO.

Note that the class-registration error has already been logged by rtc
core.

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

 drivers/rtc/rtc-omap.c |   41 +++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-clean-up-probe-error-handling drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-clean-up-probe-error-handling
+++ a/drivers/rtc/rtc-omap.c
@@ -379,6 +379,7 @@ static int __init omap_rtc_probe(struct
 	u8			reg, new_ctrl;
 	const struct platform_device_id *id_entry;
 	const struct of_device_id *of_id;
+	int ret;
 
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
 	if (of_id)
@@ -391,16 +392,12 @@ static int __init omap_rtc_probe(struct
 	}
 
 	omap_rtc_timer = platform_get_irq(pdev, 0);
-	if (omap_rtc_timer <= 0) {
-		pr_debug("%s: no update irq?\n", pdev->name);
+	if (omap_rtc_timer <= 0)
 		return -ENOENT;
-	}
 
 	omap_rtc_alarm = platform_get_irq(pdev, 1);
-	if (omap_rtc_alarm <= 0) {
-		pr_debug("%s: no alarm irq?\n", pdev->name);
+	if (omap_rtc_alarm <= 0)
 		return -ENOENT;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	rtc_base = devm_ioremap_resource(&pdev->dev, res);
@@ -421,9 +418,8 @@ static int __init omap_rtc_probe(struct
 	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		pr_debug("%s: can't register RTC device, err %ld\n",
-			pdev->name, PTR_ERR(rtc));
-		goto fail0;
+		ret = PTR_ERR(rtc);
+		goto err;
 	}
 	platform_set_drvdata(pdev, rtc);
 
@@ -451,18 +447,16 @@ static int __init omap_rtc_probe(struct
 		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
 
 	/* handle periodic and alarm irqs */
-	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
-			dev_name(&rtc->dev), rtc)) {
-		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
-			pdev->name, omap_rtc_timer);
-		goto fail0;
-	}
-	if ((omap_rtc_timer != omap_rtc_alarm) &&
-		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
-			dev_name(&rtc->dev), rtc))) {
-		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
-			pdev->name, omap_rtc_alarm);
-		goto fail0;
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
 	}
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
@@ -496,13 +490,14 @@ static int __init omap_rtc_probe(struct
 
 	return 0;
 
-fail0:
+err:
 	device_init_wakeup(&pdev->dev, false);
 	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	return -EIO;
+
+	return ret;
 }
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

