From: akpm@linux-foundation.org
Subject: + rtc-pm8xxx-use-regmap-api-for-register-accesses.patch added to
 -mm tree
Date: Mon, 10 Mar 2014 13:48:02 -0700
Message-ID: <531e2502.hnb60bZ3u/+Iq2vX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaCJUsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: + rtc-pm8xxx-use-regmap-api-for-register-accesses.patch added to -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,sboyd@codeaurora.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:48:02 -0700


The patch titled
     Subject: rtc: pm8xxx: use regmap API for register accesses
has been added to the -mm tree.  Its filename is
     rtc-pm8xxx-use-regmap-api-for-register-accesses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pm8xxx-use-regmap-api-for-register-accesses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pm8xxx-use-regmap-api-for-register-accesses.patch

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
Subject: rtc: pm8xxx: use regmap API for register accesses

Now that the parent mfd driver has been made to work again, and has been
reworked to create a regmap instance intended for its children to use,
rework the pm8xxx driver to use the regmap API for its register accesses.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |  145 ++++++++++++++-----------------------
 1 file changed, 57 insertions(+), 88 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-use-regmap-api-for-register-accesses drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-use-regmap-api-for-register-accesses
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -13,11 +13,12 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/rtc.h>
+#include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
-#include <linux/mfd/pm8xxx/core.h>
 #include <linux/mfd/pm8xxx/rtc.h>
 
 
@@ -37,6 +38,7 @@
 /**
  * struct pm8xxx_rtc -  rtc driver internal structure
  * @rtc:		rtc device for this driver.
+ * @regmap:		regmap used to access RTC registers
  * @rtc_alarm_irq:	rtc alarm irq number.
  * @rtc_base:		address of rtc control register.
  * @rtc_read_base:	base address of read registers.
@@ -48,6 +50,7 @@
  */
 struct pm8xxx_rtc {
 	struct rtc_device *rtc;
+	struct regmap *regmap;
 	int rtc_alarm_irq;
 	int rtc_base;
 	int rtc_read_base;
@@ -59,44 +62,6 @@ struct pm8xxx_rtc {
 };
 
 /*
- * The RTC registers need to be read/written one byte at a time. This is a
- * hardware limitation.
- */
-static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-			       int base, int count)
-{
-	int i, rc;
-	struct device *parent = rtc_dd->rtc_dev->parent;
-
-	for (i = 0; i < count; i++) {
-		rc = pm8xxx_readb(parent, base + i, &rtc_val[i]);
-		if (rc < 0) {
-			dev_err(rtc_dd->rtc_dev, "PMIC read failed\n");
-			return rc;
-		}
-	}
-
-	return 0;
-}
-
-static int pm8xxx_write_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-				int base, int count)
-{
-	int i, rc;
-	struct device *parent = rtc_dd->rtc_dev->parent;
-
-	for (i = 0; i < count; i++) {
-		rc = pm8xxx_writeb(parent, base + i, rtc_val[i]);
-		if (rc < 0) {
-			dev_err(rtc_dd->rtc_dev, "PMIC write failed\n");
-			return rc;
-		}
-	}
-
-	return 0;
-}
-
-/*
  * Steps to write the RTC registers.
  * 1. Disable alarm if enabled.
  * 2. Write 0x00 to LSB.
@@ -107,7 +72,7 @@ static int pm8xxx_rtc_set_time(struct de
 {
 	int rc, i;
 	unsigned long secs, irq_flags;
-	u8 value[NUM_8_BIT_RTC_REGS], reg = 0, alarm_enabled = 0, ctrl_reg;
+	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0, ctrl_reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(tm, &secs);
@@ -125,9 +90,8 @@ static int pm8xxx_rtc_set_time(struct de
 	if (ctrl_reg & PM8xxx_RTC_ALARM_ENABLE) {
 		alarm_enabled = 1;
 		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-					  1);
-		if (rc < 0) {
+		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
@@ -137,33 +101,31 @@ static int pm8xxx_rtc_set_time(struct de
 	}
 
 	/* Write 0 to Byte[0] */
-	reg = 0;
-	rc = pm8xxx_write_wrapper(rtc_dd, &reg, rtc_dd->rtc_write_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_write_base, 0);
+	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	/* Write Byte[1], Byte[2], Byte[3] */
-	rc = pm8xxx_write_wrapper(rtc_dd, value + 1,
-				  rtc_dd->rtc_write_base + 1, 3);
-	if (rc < 0) {
+	rc = regmap_bulk_write(rtc_dd->regmap, rtc_dd->rtc_write_base + 1,
+			       &value[1], sizeof(value) - 1);
+	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	/* Write Byte[0] */
-	rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->rtc_write_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_write_base, value[0]);
+	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	if (alarm_enabled) {
 		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-					  1);
-		if (rc < 0) {
+		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
@@ -180,13 +142,14 @@ rtc_rw_fail:
 static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	int rc;
-	u8 value[NUM_8_BIT_RTC_REGS], reg;
+	u8 value[NUM_8_BIT_RTC_REGS];
 	unsigned long secs;
+	unsigned int reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
-	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->rtc_read_base,
-				 NUM_8_BIT_RTC_REGS);
-	if (rc < 0) {
+	rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->rtc_read_base,
+			      value, sizeof(value));
+	if (rc) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
 	}
@@ -195,17 +158,16 @@ static int pm8xxx_rtc_read_time(struct d
 	 * Read the LSB again and check if there has been a carry over.
 	 * If there is, redo the read operation.
 	 */
-	rc = pm8xxx_read_wrapper(rtc_dd, &reg, rtc_dd->rtc_read_base, 1);
+	rc = regmap_read(rtc_dd->regmap, rtc_dd->rtc_read_base, &reg);
 	if (rc < 0) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
 	}
 
 	if (unlikely(reg < value[0])) {
-		rc = pm8xxx_read_wrapper(rtc_dd, value,
-					 rtc_dd->rtc_read_base,
-					 NUM_8_BIT_RTC_REGS);
-		if (rc < 0) {
+		rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->rtc_read_base,
+				      value, sizeof(value));
+		if (rc) {
 			dev_err(dev, "RTC read data register failed\n");
 			return rc;
 		}
@@ -244,9 +206,9 @@ static int pm8xxx_rtc_set_alarm(struct d
 
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
-	rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-				  NUM_8_BIT_RTC_REGS);
-	if (rc < 0) {
+	rc = regmap_bulk_write(rtc_dd->regmap, rtc_dd->alarm_rw_base, value,
+			       sizeof(value));
+	if (rc) {
 		dev_err(dev, "Write to RTC ALARM register failed\n");
 		goto rtc_rw_fail;
 	}
@@ -258,8 +220,8 @@ static int pm8xxx_rtc_set_alarm(struct d
 	else
 		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	if (rc) {
 		dev_err(dev, "Write to RTC control register failed\n");
 		goto rtc_rw_fail;
 	}
@@ -282,9 +244,9 @@ static int pm8xxx_rtc_read_alarm(struct
 	unsigned long secs;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
-	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-				 NUM_8_BIT_RTC_REGS);
-	if (rc < 0) {
+	rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->alarm_rw_base, value,
+			      sizeof(value));
+	if (rc) {
 		dev_err(dev, "RTC alarm time read failed\n");
 		return rc;
 	}
@@ -323,8 +285,8 @@ static int pm8xxx_rtc_alarm_irq_enable(s
 	else
 		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	if (rc) {
 		dev_err(dev, "Write to RTC control register failed\n");
 		goto rtc_rw_fail;
 	}
@@ -346,7 +308,7 @@ static struct rtc_class_ops pm8xxx_rtc_o
 static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 {
 	struct pm8xxx_rtc *rtc_dd = dev_id;
-	u8 ctrl_reg;
+	unsigned int ctrl_reg;
 	int rc;
 	unsigned long irq_flags;
 
@@ -358,8 +320,8 @@ static irqreturn_t pm8xxx_alarm_trigger(
 	ctrl_reg = rtc_dd->ctrl_reg;
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	if (rc) {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 		dev_err(rtc_dd->rtc_dev,
 			"Write to RTC control register failed\n");
@@ -370,18 +332,20 @@ static irqreturn_t pm8xxx_alarm_trigger(
 	spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	/* Clear RTC alarm register */
-	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-				 PM8XXX_ALARM_CTRL_OFFSET, 1);
-	if (rc < 0) {
+	rc = regmap_read(rtc_dd->regmap,
+			 rtc_dd->rtc_base + PM8XXX_ALARM_CTRL_OFFSET,
+			 &ctrl_reg);
+	if (rc) {
 		dev_err(rtc_dd->rtc_dev,
 			"RTC Alarm control register read failed\n");
 		goto rtc_alarm_handled;
 	}
 
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_CLEAR;
-	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-				  PM8XXX_ALARM_CTRL_OFFSET, 1);
-	if (rc < 0)
+	rc = regmap_write(rtc_dd->regmap,
+			  rtc_dd->rtc_base + PM8XXX_ALARM_CTRL_OFFSET,
+			  ctrl_reg);
+	if (rc)
 		dev_err(rtc_dd->rtc_dev,
 			"Write to RTC Alarm control register failed\n");
 
@@ -392,7 +356,7 @@ rtc_alarm_handled:
 static int pm8xxx_rtc_probe(struct platform_device *pdev)
 {
 	int rc;
-	u8 ctrl_reg;
+	unsigned int ctrl_reg;
 	bool rtc_write_enable = false;
 	struct pm8xxx_rtc *rtc_dd;
 	struct resource *rtc_resource;
@@ -409,6 +373,12 @@ static int pm8xxx_rtc_probe(struct platf
 	/* Initialise spinlock to protect RTC control register */
 	spin_lock_init(&rtc_dd->ctrl_reg_lock);
 
+	rtc_dd->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!rtc_dd->regmap) {
+		dev_err(&pdev->dev, "Parent regmap unavailable.\n");
+		return -ENXIO;
+	}
+
 	rtc_dd->rtc_alarm_irq = platform_get_irq(pdev, 0);
 	if (rtc_dd->rtc_alarm_irq < 0) {
 		dev_err(&pdev->dev, "Alarm IRQ resource absent!\n");
@@ -432,17 +402,16 @@ static int pm8xxx_rtc_probe(struct platf
 	rtc_dd->rtc_dev = &pdev->dev;
 
 	/* Check if the RTC is on, else turn it on */
-	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
-	if (rc < 0) {
+	rc = regmap_read(rtc_dd->regmap, rtc_dd->rtc_base, &ctrl_reg);
+	if (rc) {
 		dev_err(&pdev->dev, "RTC control register read failed!\n");
 		return rc;
 	}
 
 	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
 		ctrl_reg |= PM8xxx_RTC_ENABLE;
-		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-									1);
-		if (rc < 0) {
+		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		if (rc) {
 			dev_err(&pdev->dev,
 				"Write to RTC control register failed\n");
 			return rc;
_

Patches currently in -mm which might be from joshc@codeaurora.org are

rtc-pm8xxx-fixup-checkpatch-style-issues.patch
rtc-pm8xxx-use-regmap-api-for-register-accesses.patch
rtc-pm8xxx-use-devm_request_any_context_irq.patch
rtc-pm8xxx-add-support-for-devicetree.patch
rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch
documentation-bindings-document-pmic8921-8058-rtc.patch
linux-next.patch

