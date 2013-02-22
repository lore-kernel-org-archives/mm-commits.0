From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:44 -0800
Message-ID: <20130222204344.A4E4831C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47210 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab3BVUnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:45 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so104086yhz.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: remove unnecessary irq stat save and restore
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: remove unnecessary irq stat save and restore

The driver stores the interrupt enable register before going to suspend
and restore in resume.  Also it enables alarm before going to suspend.

The driver only write the Interrupt enable register for enabling ALARM and
does not enable any other bits.  So it is not require to save complete
register and enable ALARM interrupt before suspend and restore in resume.

Also ALARM interrupt already enable if alarm is enabled before going to
suspend and hence it is not require to enable explictly in suspend.

Removing such above code.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore
+++ a/drivers/rtc/rtc-tps65910.c
@@ -28,8 +28,6 @@
 struct tps65910_rtc {
 	struct rtc_device	*rtc;
 	int irq;
-	/* To store the list of enabled interrupts */
-	u32 irqstat;
 };
 
 /* Total number of RTC registers needed to set time*/
@@ -309,35 +307,20 @@ static int tps65910_rtc_remove(struct pl
 
 static int tps65910_rtc_suspend(struct device *dev)
 {
-	struct tps65910 *tps = dev_get_drvdata(dev->parent);
 	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
-	u8 alarm = TPS65910_RTC_INTERRUPTS_IT_ALARM;
-	int ret;
 
 	if (device_may_wakeup(dev))
 		enable_irq_wake(tps_rtc->irq);
-
-	/* Store current list of enabled interrupts*/
-	ret = regmap_read(tps->regmap, TPS65910_RTC_INTERRUPTS,
-		&tps->rtc->irqstat);
-	if (ret < 0)
-		return ret;
-
-	/* Enable RTC ALARM interrupt only */
-	return regmap_write(tps->regmap, TPS65910_RTC_INTERRUPTS, alarm);
+	return 0;
 }
 
 static int tps65910_rtc_resume(struct device *dev)
 {
-	struct tps65910 *tps = dev_get_drvdata(dev->parent);
 	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev))
 		disable_irq_wake(tps_rtc->irq);
