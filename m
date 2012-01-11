From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mxcc-make-alarm-work.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:02 -0800
Message-ID: <20120111213203.10C4A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43465 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:05 -0500
Received: by eekd41 with SMTP id d41so44375eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jekhor@gmail.com, a.zummo@towertech.it, daniel@caiaq.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: make alarm work
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-make-alarm-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Yauhen Kharuzhy <jekhor@gmail.com>
Subject: drivers/rtc/rtc-mxc.c: make alarm work

Fix alarm IRQ handling, make the alarm one-shot.  Cleanup black magick
with a validation of already validated time data.

Add ability to wake the system with alarm.

[akpm@linux-foundation.org: fix CONFIG_PM=n build]
Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |  112 +++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 53 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-make-alarm-work drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-make-alarm-work
+++ a/drivers/rtc/rtc-mxc.c
@@ -155,7 +155,6 @@ static int rtc_update_alarm(struct devic
 {
 	struct rtc_time alarm_tm, now_tm;
 	unsigned long now, time;
-	int ret;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
@@ -168,21 +167,33 @@ static int rtc_update_alarm(struct devic
 	alarm_tm.tm_hour = alrm->tm_hour;
 	alarm_tm.tm_min = alrm->tm_min;
 	alarm_tm.tm_sec = alrm->tm_sec;
-	rtc_tm_to_time(&now_tm, &now);
 	rtc_tm_to_time(&alarm_tm, &time);
 
-	if (time < now) {
-		time += 60 * 60 * 24;
-		rtc_time_to_tm(time, &alarm_tm);
-	}
-
-	ret = rtc_tm_to_time(&alarm_tm, &time);
-
 	/* clear all the interrupt status bits */
 	writew(readw(ioaddr + RTC_RTCISR), ioaddr + RTC_RTCISR);
 	set_alarm_or_time(dev, MXC_RTC_ALARM, time);
 
-	return ret;
+	return 0;
+}
+
+static void mxc_rtc_irq_enable(struct device *dev, unsigned int bit,
+				unsigned int enabled)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32 reg;
+
+	spin_lock_irq(&pdata->rtc->irq_lock);
+	reg = readw(ioaddr + RTC_RTCIENR);
+
+	if (enabled)
+		reg |= bit;
+	else
+		reg &= ~bit;
+
+	writew(reg, ioaddr + RTC_RTCIENR);
+	spin_unlock_irq(&pdata->rtc->irq_lock);
 }
 
 /* This function is the RTC interrupt service routine. */
@@ -199,13 +210,12 @@ static irqreturn_t mxc_rtc_interrupt(int
 	/* clear interrupt sources */
 	writew(status, ioaddr + RTC_RTCISR);
 
-	/* clear alarm interrupt if it has occurred */
-	if (status & RTC_ALM_BIT)
-		status &= ~RTC_ALM_BIT;
-
 	/* update irq data & counter */
-	if (status & RTC_ALM_BIT)
+	if (status & RTC_ALM_BIT) {
 		events |= (RTC_AF | RTC_IRQF);
+		/* RTC alarm should be one-shot */
+		mxc_rtc_irq_enable(&pdev->dev, RTC_ALM_BIT, 0);
+	}
 
 	if (status & RTC_1HZ_BIT)
 		events |= (RTC_UF | RTC_IRQF);
@@ -213,9 +223,6 @@ static irqreturn_t mxc_rtc_interrupt(int
 	if (status & PIT_ALL_ON)
 		events |= (RTC_PF | RTC_IRQF);
 
-	if ((status & RTC_ALM_BIT) && rtc_valid_tm(&pdata->g_rtc_alarm))
-		rtc_update_alarm(&pdev->dev, &pdata->g_rtc_alarm);
-
 	rtc_update_irq(pdata->rtc, 1, events);
 	spin_unlock_irq(&pdata->rtc->irq_lock);
 
@@ -242,26 +249,6 @@ static void mxc_rtc_release(struct devic
 	spin_unlock_irq(&pdata->rtc->irq_lock);
 }
 
-static void mxc_rtc_irq_enable(struct device *dev, unsigned int bit,
-				unsigned int enabled)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	void __iomem *ioaddr = pdata->ioaddr;
-	u32 reg;
-
-	spin_lock_irq(&pdata->rtc->irq_lock);
-	reg = readw(ioaddr + RTC_RTCIENR);
-
-	if (enabled)
-		reg |= bit;
-	else
-		reg &= ~bit;
-
-	writew(reg, ioaddr + RTC_RTCIENR);
-	spin_unlock_irq(&pdata->rtc->irq_lock);
-}
-
 static int mxc_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	mxc_rtc_irq_enable(dev, RTC_ALM_BIT, enabled);
@@ -335,21 +322,7 @@ static int mxc_rtc_set_alarm(struct devi
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	int ret;
 
-	if (rtc_valid_tm(&alrm->time)) {
-		if (alrm->time.tm_sec > 59 ||
-		    alrm->time.tm_hour > 23 ||
-		    alrm->time.tm_min > 59)
-			return -EINVAL;
-
-		ret = rtc_update_alarm(dev, &alrm->time);
-	} else {
-		ret = rtc_valid_tm(&alrm->time);
-		if (ret)
-			return ret;
-
-		ret = rtc_update_alarm(dev, &alrm->time);
-	}
-
+	ret = rtc_update_alarm(dev, &alrm->time);
 	if (ret)
 		return ret;
 
@@ -435,6 +408,9 @@ static int __init mxc_rtc_probe(struct p
 		pdata->irq = -1;
 	}
 
+	if (pdata->irq >=0)
+		device_init_wakeup(&pdev->dev, 1);
+
 	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -470,9 +446,39 @@ static int __exit mxc_rtc_remove(struct 
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int mxc_rtc_suspend(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(pdata->irq);
+
+	return 0;
+}
+
+static int mxc_rtc_resume(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(pdata->irq);
+
+	return 0;
+}
+
+static struct dev_pm_ops mxc_rtc_pm_ops = {
+	.suspend	= mxc_rtc_suspend,
+	.resume		= mxc_rtc_resume,
+};
+#endif
+
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
 		   .name	= "mxc_rtc",
+#ifdef CONFIG_PM
+		   .pm		= &mxc_rtc_pm_ops,
+#endif
 		   .owner	= THIS_MODULE,
 	},
 	.remove		= __exit_p(mxc_rtc_remove),
_

Patches currently in -mm which might be from jekhor@gmail.com are

origin.patch

