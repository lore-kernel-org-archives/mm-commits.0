From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mpc5121c-add-support-for-rtc-on-mpc5200.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:23 -0700
Message-ID: <201107260755.p6Q7tRvW003464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab1GZH4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, a.zummo@towertech.it, agust@denx.de, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-mpc5121.c: add support for RTC on MPC5200
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mpc5121c-add-support-for-rtc-on-mpc5200.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-mpc5121.c: add support for RTC on MPC5200
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

MPC5200B contains a limited version of RTC from MPC5121.  Add support for
the RTC on that CPU.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |    4 -
 drivers/rtc/rtc-mpc5121.c |   81 ++++++++++++++++++++++++++++++++----
 2 files changed, 75 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/Kconfig~drivers-rtc-rtc-mpc5121c-add-support-for-rtc-on-mpc5200 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-rtc-mpc5121c-add-support-for-rtc-on-mpc5200
+++ a/drivers/rtc/Kconfig
@@ -1006,10 +1006,10 @@ config RTC_DRV_MC13XXX
 
 config RTC_DRV_MPC5121
 	tristate "Freescale MPC5121 built-in RTC"
-	depends on PPC_MPC512x && RTC_CLASS
+	depends on PPC_MPC512x || PPC_MPC52xx
 	help
 	  If you say yes here you will get support for the
-	  built-in RTC MPC5121.
+	  built-in RTC on MPC5121 or on MPC5200.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-mpc5121.
diff -puN drivers/rtc/rtc-mpc5121.c~drivers-rtc-rtc-mpc5121c-add-support-for-rtc-on-mpc5200 drivers/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~drivers-rtc-rtc-mpc5121c-add-support-for-rtc-on-mpc5200
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2007, Domen Puncer <domen.puncer@telargo.com>
  * Copyright 2008, Freescale Semiconductor, Inc. All rights reserved.
+ * Copyright 2011, Dmitry Eremin-Solenikov
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -145,6 +146,55 @@ static int mpc5121_rtc_set_time(struct d
 	return 0;
 }
 
+static int mpc5200_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
+	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
+	int tmp;
+
+	tm->tm_sec = in_8(&regs->second);
+	tm->tm_min = in_8(&regs->minute);
+
+	/* 12 hour format? */
+	if (in_8(&regs->hour) & 0x20)
+		tm->tm_hour = (in_8(&regs->hour) >> 1) +
+			(in_8(&regs->hour) & 1 ? 12 : 0);
+	else
+		tm->tm_hour = in_8(&regs->hour);
+
+	tmp = in_8(&regs->wday_mday);
+	tm->tm_mday = tmp & 0x1f;
+	tm->tm_mon = in_8(&regs->month) - 1;
+	tm->tm_year = in_be16(&regs->year) - 1900;
+	tm->tm_wday = (tmp >> 5) % 7;
+	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
+	tm->tm_isdst = 0;
+
+	return 0;
+}
+
+static int mpc5200_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
+	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
+
+	mpc5121_rtc_update_smh(regs, tm);
+
+	/* date */
+	out_8(&regs->month_set, tm->tm_mon + 1);
+	out_8(&regs->weekday_set, tm->tm_wday ? tm->tm_wday : 7);
+	out_8(&regs->date_set, tm->tm_mday);
+	out_be16(&regs->year_set, tm->tm_year + 1900);
+
+	/* set date sequence */
+	out_8(&regs->set_date, 0x1);
+	out_8(&regs->set_date, 0x3);
+	out_8(&regs->set_date, 0x1);
+	out_8(&regs->set_date, 0x0);
+
+	return 0;
+}
+
 static int mpc5121_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
@@ -248,11 +298,18 @@ static const struct rtc_class_ops mpc512
 	.alarm_irq_enable = mpc5121_rtc_alarm_irq_enable,
 };
 
+static const struct rtc_class_ops mpc5200_rtc_ops = {
+	.read_time = mpc5200_rtc_read_time,
+	.set_time = mpc5200_rtc_set_time,
+	.read_alarm = mpc5121_rtc_read_alarm,
+	.set_alarm = mpc5121_rtc_set_alarm,
+	.alarm_irq_enable = mpc5121_rtc_alarm_irq_enable,
+};
+
 static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 {
 	struct mpc5121_rtc_data *rtc;
 	int err = 0;
-	u32 ka;
 
 	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
@@ -287,15 +344,22 @@ static int __devinit mpc5121_rtc_probe(s
 		goto out_dispose2;
 	}
 
-	ka = in_be32(&rtc->regs->keep_alive);
-	if (ka & 0x02) {
-		dev_warn(&op->dev,
-			"mpc5121-rtc: Battery or oscillator failure!\n");
-		out_be32(&rtc->regs->keep_alive, ka);
+	if (of_device_is_compatible(op->dev.of_node, "fsl,mpc5121-rtc")) {
+		u32 ka;
+		ka = in_be32(&rtc->regs->keep_alive);
+		if (ka & 0x02) {
+			dev_warn(&op->dev,
+				"mpc5121-rtc: Battery or oscillator failure!\n");
+			out_be32(&rtc->regs->keep_alive, ka);
+		}
+
+		rtc->rtc = rtc_device_register("mpc5121-rtc", &op->dev,
+						&mpc5121_rtc_ops, THIS_MODULE);
+	} else {
+		rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
+						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
-	rtc->rtc = rtc_device_register("mpc5121-rtc", &op->dev,
-					&mpc5121_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
@@ -340,6 +404,7 @@ static int __devexit mpc5121_rtc_remove(
 
 static struct of_device_id mpc5121_rtc_match[] __devinitdata = {
 	{ .compatible = "fsl,mpc5121-rtc", },
+	{ .compatible = "fsl,mpc5200-rtc", },
 	{},
 };
 
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch
linux-next.patch

