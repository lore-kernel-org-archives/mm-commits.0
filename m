From: akpm@linux-foundation.org
Subject: + rtc-omap-update-to-devm_-api.patch added to -mm tree
Date: Wed, 20 Mar 2013 14:20:01 -0700
Message-ID: <20130320212001.765355A42A9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57472 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3CTVUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 17:20:03 -0400
Received: by mail-gg0-f201.google.com with SMTP id l2so200228ggn.4
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 14:20:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manishv.b@ti.com, jg1.han@samsung.com, nsekhar@ti.com


The patch titled
     Subject: drivers/rtc/rtc-omap.c: update to devm_* API
has been added to the -mm tree.  Its filename is
     rtc-omap-update-to-devm_-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
Subject: drivers/rtc/rtc-omap.c: update to devm_* API

Update the code to use devm_* API so that driver core will manage
resources.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
Tested-by: Sekhar Nori <nsekhar@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   45 +++++++--------------------------------
 1 file changed, 9 insertions(+), 36 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-update-to-devm_-api drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-update-to-devm_-api
+++ a/drivers/rtc/rtc-omap.c
@@ -324,7 +324,7 @@ MODULE_DEVICE_TABLE(of, omap_rtc_of_matc
 
 static int __init omap_rtc_probe(struct platform_device *pdev)
 {
-	struct resource		*res, *mem;
+	struct resource		*res;
 	struct rtc_device	*rtc;
 	u8			reg, new_ctrl;
 	const struct platform_device_id *id_entry;
@@ -352,18 +352,9 @@ static int __init omap_rtc_probe(struct
 		return -ENOENT;
 	}
 
-	mem = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!mem) {
-		pr_debug("%s: RTC registers at %08x are not free\n",
-			pdev->name, res->start);
-		return -EBUSY;
-	}
-
-	rtc_base = ioremap(res->start, resource_size(res));
-	if (!rtc_base) {
-		pr_debug("%s: RTC registers can't be mapped\n", pdev->name);
-		goto fail;
-	}
+	rtc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc_base))
+		return PTR_ERR(rtc_base);
 
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_enable(&pdev->dev);
@@ -375,7 +366,7 @@ static int __init omap_rtc_probe(struct
 		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		pr_debug("%s: can't register RTC device, err %ld\n",
@@ -383,7 +374,6 @@ static int __init omap_rtc_probe(struct
 		goto fail0;
 	}
 	platform_set_drvdata(pdev, rtc);
-	dev_set_drvdata(&rtc->dev, mem);
 
 	/* clear pending irqs, and set 1/second periodic,
 	 * which we'll use instead of update irqs
@@ -401,18 +391,18 @@ static int __init omap_rtc_probe(struct
 		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
 
 	/* handle periodic and alarm irqs */
-	if (request_irq(omap_rtc_timer, rtc_irq, 0,
+	if (devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
 			dev_name(&rtc->dev), rtc)) {
 		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_timer);
-		goto fail1;
+		goto fail0;
 	}
 	if ((omap_rtc_timer != omap_rtc_alarm) &&
-		(request_irq(omap_rtc_alarm, rtc_irq, 0,
+		(devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
 			dev_name(&rtc->dev), rtc))) {
 		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_alarm);
-		goto fail2;
+		goto fail0;
 	}
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
@@ -446,25 +436,16 @@ static int __init omap_rtc_probe(struct
 
 	return 0;
 
-fail2:
-	free_irq(omap_rtc_timer, rtc);
-fail1:
-	rtc_device_unregister(rtc);
 fail0:
 	if (id_entry && (id_entry->driver_data & OMAP_RTC_HAS_KICKER))
 		rtc_writel(0, OMAP_RTC_KICK0_REG);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	iounmap(rtc_base);
-fail:
-	release_mem_region(mem->start, resource_size(mem));
 	return -EIO;
 }
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device	*rtc = platform_get_drvdata(pdev);
-	struct resource		*mem = dev_get_drvdata(&rtc->dev);
 	const struct platform_device_id *id_entry =
 				platform_get_device_id(pdev);
 
@@ -473,12 +454,6 @@ static int __exit omap_rtc_remove(struct
 	/* leave rtc running, but disable irqs */
 	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
 
-	free_irq(omap_rtc_timer, rtc);
-
-	if (omap_rtc_timer != omap_rtc_alarm)
-		free_irq(omap_rtc_alarm, rtc);
