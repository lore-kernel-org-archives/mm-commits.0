From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch added to -mm tree
Date: Tue, 08 Jan 2013 14:03:57 -0800
Message-ID: <20130108220358.25A6210008A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61813 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3AHWD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 17:03:59 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so139757vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 14:03:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: enable/disable wake in suspend/resume
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch
drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore.patch
drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch
drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch

