From: akpm@linux-foundation.org
Subject: + rtc-pm8xxx-add-support-for-devicetree.patch added to -mm tree
Date: Mon, 10 Mar 2014 13:48:05 -0700
Message-ID: <531e2505.Erkzm5tHuHY3csov%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaCJUsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, lee.jones@linaro.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: + rtc-pm8xxx-add-support-for-devicetree.patch added to -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,lee.jones@linaro.org,sboyd@codeaurora.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:48:05 -0700


The patch titled
     Subject: rtc: pm8xxx: add support for devicetree
has been added to the -mm tree.  Its filename is
     rtc-pm8xxx-add-support-for-devicetree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pm8xxx-add-support-for-devicetree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pm8xxx-add-support-for-devicetree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Cartwright <joshc@codeaurora.org>
Subject: rtc: pm8xxx: add support for devicetree

Add support for describing the PM8921/PM8058 RTC in device tree.

Additionally:
   - drop support for describing the RTC using platform data,
     as there are no current in tree users who do so.
   - make allow_set_time a device-specific flag, instead of mucking
     with the rtc_ops

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c       |   52 +++++++++++++++++--------------
 include/linux/mfd/pm8xxx/rtc.h |   25 --------------
 2 files changed, 29 insertions(+), 48 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-add-support-for-devicetree drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-add-support-for-devicetree
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -9,7 +9,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-
+#include <linux/of.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/rtc.h>
@@ -19,9 +19,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <linux/mfd/pm8xxx/rtc.h>
-
-
 /* RTC Register offsets from RTC CTRL REG */
 #define PM8XXX_ALARM_CTRL_OFFSET	0x01
 #define PM8XXX_RTC_WRITE_OFFSET		0x02
@@ -39,6 +36,7 @@
  * struct pm8xxx_rtc -  rtc driver internal structure
  * @rtc:		rtc device for this driver.
  * @regmap:		regmap used to access RTC registers
+ * @allow_set_time:	indicates whether writing to the RTC is allowed
  * @rtc_alarm_irq:	rtc alarm irq number.
  * @rtc_base:		address of rtc control register.
  * @rtc_read_base:	base address of read registers.
@@ -51,6 +49,7 @@
 struct pm8xxx_rtc {
 	struct rtc_device *rtc;
 	struct regmap *regmap;
+	bool allow_set_time;
 	int rtc_alarm_irq;
 	int rtc_base;
 	int rtc_read_base;
@@ -75,6 +74,9 @@ static int pm8xxx_rtc_set_time(struct de
 	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0, ctrl_reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
+	if (!rtc_dd->allow_set_time)
+		return -EACCES;
+
 	rtc_tm_to_time(tm, &secs);
 
 	for (i = 0; i < NUM_8_BIT_RTC_REGS; i++) {
@@ -298,8 +300,9 @@ rtc_rw_fail:
 	return rc;
 }
 
-static struct rtc_class_ops pm8xxx_rtc_ops = {
+static const struct rtc_class_ops pm8xxx_rtc_ops = {
 	.read_time	= pm8xxx_rtc_read_time,
+	.set_time	= pm8xxx_rtc_set_time,
 	.set_alarm	= pm8xxx_rtc_set_alarm,
 	.read_alarm	= pm8xxx_rtc_read_alarm,
 	.alarm_irq_enable = pm8xxx_rtc_alarm_irq_enable,
@@ -353,18 +356,26 @@ rtc_alarm_handled:
 	return IRQ_HANDLED;
 }
 
+/*
+ * Hardcoded RTC bases until IORESOURCE_REG mapping is figured out
+ */
+static const struct of_device_id pm8xxx_id_table[] = {
+	{ .compatible = "qcom,pm8921-rtc", .data = (void *) 0x11D },
+	{ .compatible = "qcom,pm8058-rtc", .data = (void *) 0x1E8 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pm8xxx_id_table);
+
 static int pm8xxx_rtc_probe(struct platform_device *pdev)
 {
 	int rc;
 	unsigned int ctrl_reg;
-	bool rtc_write_enable = false;
 	struct pm8xxx_rtc *rtc_dd;
-	struct resource *rtc_resource;
-	const struct pm8xxx_rtc_platform_data *pdata =
-						dev_get_platdata(&pdev->dev);
+	const struct of_device_id *match;
 
-	if (pdata != NULL)
-		rtc_write_enable = pdata->rtc_write_enable;
+	match = of_match_node(pm8xxx_id_table, pdev->dev.of_node);
+	if (!match)
+		return -ENXIO;
 
 	rtc_dd = devm_kzalloc(&pdev->dev, sizeof(*rtc_dd), GFP_KERNEL);
 	if (rtc_dd == NULL)
@@ -385,14 +396,10 @@ static int pm8xxx_rtc_probe(struct platf
 		return -ENXIO;
 	}
 
-	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
-						    "pmic_rtc_base");
-	if (!(rtc_resource && rtc_resource->start)) {
-		dev_err(&pdev->dev, "RTC IO resource absent!\n");
-		return -ENXIO;
-	}
+	rtc_dd->allow_set_time = of_property_read_bool(pdev->dev.of_node,
+						      "allow-set-time");
 
-	rtc_dd->rtc_base = rtc_resource->start;
+	rtc_dd->rtc_base = (long) match->data;
 
 	/* Setup RTC register addresses */
 	rtc_dd->rtc_write_base = rtc_dd->rtc_base + PM8XXX_RTC_WRITE_OFFSET;
@@ -419,8 +426,6 @@ static int pm8xxx_rtc_probe(struct platf
 	}
 
 	rtc_dd->ctrl_reg = ctrl_reg;
-	if (rtc_write_enable)
-		pm8xxx_rtc_ops.set_time = pm8xxx_rtc_set_time;
 
 	platform_set_drvdata(pdev, rtc_dd);
 
@@ -479,9 +484,10 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_o
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
 	.driver	= {
-		.name	= PM8XXX_RTC_DEV_NAME,
-		.owner	= THIS_MODULE,
-		.pm	= &pm8xxx_rtc_pm_ops,
+		.name		= "rtc-pm8xxx",
+		.owner		= THIS_MODULE,
+		.pm		= &pm8xxx_rtc_pm_ops,
+		.of_match_table	= pm8xxx_id_table,
 	},
 };
 
diff -puN include/linux/mfd/pm8xxx/rtc.h~rtc-pm8xxx-add-support-for-devicetree /dev/null
--- a/include/linux/mfd/pm8xxx/rtc.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __RTC_PM8XXX_H__
-#define __RTC_PM8XXX_H__
-
-#define PM8XXX_RTC_DEV_NAME     "rtc-pm8xxx"
-/**
- * struct pm8xxx_rtc_pdata - RTC driver platform data
- * @rtc_write_enable: variable stating RTC write capability
- */
-struct pm8xxx_rtc_platform_data {
-	bool rtc_write_enable;
-};
