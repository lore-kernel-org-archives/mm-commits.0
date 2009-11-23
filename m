From: akpm@linux-foundation.org
Subject: + rtc-mv-add-support-for-alarm.patch added to -mm tree
Date: Mon, 23 Nov 2009 13:31:39 -0800
Message-ID: <200911232131.nANLVdsa002589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbZKWVbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 16:31:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: saeed@marvell.com, a.zummo@towertech.it, nico@marvell.com


The patch titled
     rtc-mv: add support for Alarm
has been added to the -mm tree.  Its filename is
     rtc-mv-add-support-for-alarm.patch

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
Subject: rtc-mv: add support for Alarm
From: Saeed Bishara <saeed@marvell.com>

This patch adds the Alarm support, this mode enabled when adding
IORESOURCE_IRQ to the platform device resources.

The patch also enables the wakeup mode, so the wakealarm sysfs file (under
/sys/class/rtc/rtcX/) can be used to configure the alarm clock.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mv.c |  157 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-mv.c~rtc-mv-add-support-for-alarm drivers/rtc/rtc-mv.c
--- a/drivers/rtc/rtc-mv.c~rtc-mv-add-support-for-alarm
+++ a/drivers/rtc/rtc-mv.c
@@ -27,10 +27,17 @@
 #define RTC_MONTH_OFFS		8
 #define RTC_YEAR_OFFS		16
 
+#define RTC_ALARM_TIME_REG_OFFS	8
+#define RTC_ALARM_DATE_REG_OFFS	0xc
+#define RTC_ALARM_VALID		(1 << 7)
+
+#define RTC_ALARM_INTERRUPT_MASK_REG_OFFS	0x10
+#define RTC_ALARM_INTERRUPT_CASUE_REG_OFFS	0x14
 
 struct rtc_plat_data {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
+	int		irq;
 };
 
 static int mv_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -84,12 +91,134 @@ static int mv_rtc_read_time(struct devic
 	return rtc_valid_tm(tm);
 }
 
+static int mv_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32	rtc_time, rtc_date;
+	unsigned int year, month, day, hour, minute, second, wday;
+
+	rtc_time = readl(ioaddr + RTC_ALARM_TIME_REG_OFFS);
+	rtc_date = readl(ioaddr + RTC_ALARM_DATE_REG_OFFS);
+
+	second = rtc_time & 0x7f;
+	minute = (rtc_time >> RTC_MINUTES_OFFS) & 0x7f;
+	hour = (rtc_time >> RTC_HOURS_OFFS) & 0x3f; /* assume 24 hours mode */
+	wday = (rtc_time >> RTC_WDAY_OFFS) & 0x7;
+
+	day = rtc_date & 0x3f;
+	month = (rtc_date >> RTC_MONTH_OFFS) & 0x3f;
+	year = (rtc_date >> RTC_YEAR_OFFS) & 0xff;
+
+	alm->time.tm_sec = bcd2bin(second);
+	alm->time.tm_min = bcd2bin(minute);
+	alm->time.tm_hour = bcd2bin(hour);
+	alm->time.tm_mday = bcd2bin(day);
+	alm->time.tm_wday = bcd2bin(wday);
+	alm->time.tm_mon = bcd2bin(month) - 1;
+	/* hw counts from year 2000, but tm_year is relative to 1900 */
+	alm->time.tm_year = bcd2bin(year) + 100;
+
+	if (rtc_valid_tm(&alm->time) < 0) {
+		dev_err(dev, "retrieved alarm date/time is not valid.\n");
+		rtc_time_to_tm(0, &alm->time);
+	}
+
+	alm->enabled = !!readl(ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
+	return 0;
+}
+
+static int mv_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32 rtc_reg = 0;
+
+	if (alm->time.tm_sec >= 0)
+		rtc_reg |= (RTC_ALARM_VALID | bin2bcd(alm->time.tm_sec))
+			<< RTC_SECONDS_OFFS;
+	if (alm->time.tm_min >= 0)
+		rtc_reg |= (RTC_ALARM_VALID | bin2bcd(alm->time.tm_min))
+			<< RTC_MINUTES_OFFS;
+	if (alm->time.tm_hour >= 0)
+		rtc_reg |= (RTC_ALARM_VALID | bin2bcd(alm->time.tm_hour))
+			<< RTC_HOURS_OFFS;
+
+	writel(rtc_reg, ioaddr + RTC_ALARM_TIME_REG_OFFS);
+
+	if (alm->time.tm_mday >= 0)
+		rtc_reg = (RTC_ALARM_VALID | bin2bcd(alm->time.tm_mday))
+			<< RTC_MDAY_OFFS;
+	else
+		rtc_reg = 0;
+
+	if (alm->time.tm_mon >= 0)
+		rtc_reg |= (RTC_ALARM_VALID | bin2bcd(alm->time.tm_mon + 1))
+			<< RTC_MONTH_OFFS;
+
+	if (alm->time.tm_year >= 0)
+		rtc_reg |= (RTC_ALARM_VALID | bin2bcd(alm->time.tm_year % 100))
+			<< RTC_YEAR_OFFS;
+
+	writel(rtc_reg, ioaddr + RTC_ALARM_DATE_REG_OFFS);
+	writel(0, ioaddr + RTC_ALARM_INTERRUPT_CASUE_REG_OFFS);
+	writel(alm->enabled ? 1 : 0,
+	       ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
+
+	return 0;
+}
+
+static int mv_rtc_ioctl(struct device *dev, unsigned int cmd,
+			unsigned long arg)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+
+	if (pdata->irq < 0)
+		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
+	switch (cmd) {
+	case RTC_AIE_OFF:
+		writel(0, ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
+		break;
+	case RTC_AIE_ON:
+		writel(1, ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return 0;
+}
+
+static irqreturn_t mv_rtc_interrupt(int irq, void *data)
+{
+	struct rtc_plat_data *pdata = data;
+	void __iomem *ioaddr = pdata->ioaddr;
+
+	/* alarm irq? */
+	if (!readl(ioaddr + RTC_ALARM_INTERRUPT_CASUE_REG_OFFS))
+		return IRQ_NONE;
+
+	/* clear interrupt */
+	writel(0, ioaddr + RTC_ALARM_INTERRUPT_CASUE_REG_OFFS);
+	rtc_update_irq(pdata->rtc, 1, RTC_IRQF | RTC_AF);
+	return IRQ_HANDLED;
+}
+
 static const struct rtc_class_ops mv_rtc_ops = {
 	.read_time	= mv_rtc_read_time,
 	.set_time	= mv_rtc_set_time,
 };
 
-static int __init mv_rtc_probe(struct platform_device *pdev)
+static const struct rtc_class_ops mv_rtc_alarm_ops = {
+	.read_time	= mv_rtc_read_time,
+	.set_time	= mv_rtc_set_time,
+	.read_alarm	= mv_rtc_read_alarm,
+	.set_alarm	= mv_rtc_set_alarm,
+	.ioctl		= mv_rtc_ioctl,
+};
+
+static int __devinit mv_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct rtc_plat_data *pdata;
@@ -130,12 +259,31 @@ static int __init mv_rtc_probe(struct pl
 		}
 	}
 
+	pdata->irq = platform_get_irq(pdev, 0);
+
 	platform_set_drvdata(pdev, pdata);
-	pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
-					 &mv_rtc_ops, THIS_MODULE);
+
+	if (pdata->irq >= 0) {
+		device_init_wakeup(&pdev->dev, 1);
+		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+						 &mv_rtc_alarm_ops,
+						 THIS_MODULE);
+	} else
+		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
+						 &mv_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pdata->rtc))
 		return PTR_ERR(pdata->rtc);
 
+	if (pdata->irq >= 0) {
+		writel(0, pdata->ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
+		if (devm_request_irq(&pdev->dev, pdata->irq, mv_rtc_interrupt,
+				     IRQF_DISABLED | IRQF_SHARED,
+				     pdev->name, pdata) < 0) {
+			dev_warn(&pdev->dev, "interrupt not available.\n");
+			pdata->irq = -1;
+		}
+	}
+
 	return 0;
 }
 
@@ -143,6 +291,9 @@ static int __exit mv_rtc_remove(struct p
 {
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
+	if (pdata->irq >= 0)
+		device_init_wakeup(&pdev->dev, 0);
+
 	rtc_device_unregister(pdata->rtc);
 	return 0;
 }
_

Patches currently in -mm which might be from saeed@marvell.com are

rtc-mv-add-support-for-alarm.patch

