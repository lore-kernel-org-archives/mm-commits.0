From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:41 -0800
Message-ID: <20130222204341.A707331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:35661 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab3BVUnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:42 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so104200ggn.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: enable/disable wake in suspend/resume
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: enable/disable wake in suspend/resume

Making the rtc driver as wakeup capabale and leaving the wake
enable/disable decision to user space through a sysfs attribute.

In suspend, enable wake if device wakeup enabled.  In resume disable wake
again.

This change is inline with the Documentation/power/devices.txt#
/sys/devices/.../power/wakeup files

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume
+++ a/drivers/rtc/rtc-tps65910.c
@@ -27,6 +27,7 @@
 
 struct tps65910_rtc {
 	struct rtc_device	*rtc;
+	int irq;
 	/* To store the list of enabled interrupts */
 	u32 irqstat;
 };
@@ -273,7 +274,8 @@ static int tps65910_rtc_probe(struct pla
 		dev_err(&pdev->dev, "IRQ is not free.\n");
 		return ret;
 	}
-	device_init_wakeup(&pdev->dev, 1);
+	tps_rtc->irq = irq;
+	device_set_wakeup_capable(&pdev->dev, 1);
 
 	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 		&tps65910_rtc_ops, THIS_MODULE);
@@ -308,9 +310,13 @@ static int tps65910_rtc_remove(struct pl
 static int tps65910_rtc_suspend(struct device *dev)
 {
 	struct tps65910 *tps = dev_get_drvdata(dev->parent);
+	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
 	u8 alarm = TPS65910_RTC_INTERRUPTS_IT_ALARM;
 	int ret;
 
+	if (device_may_wakeup(dev))
+		enable_irq_wake(tps_rtc->irq);
+
 	/* Store current list of enabled interrupts*/
 	ret = regmap_read(tps->regmap, TPS65910_RTC_INTERRUPTS,
 		&tps->rtc->irqstat);
@@ -324,6 +330,10 @@ static int tps65910_rtc_suspend(struct d
 static int tps65910_rtc_resume(struct device *dev)
 {
 	struct tps65910 *tps = dev_get_drvdata(dev->parent);
+	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(tps_rtc->irq);
 
 	/* Restore list of enabled interrupts before suspend */
 	return regmap_write(tps->regmap, TPS65910_RTC_INTERRUPTS,
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch

