From: akpm@linux-foundation.org
Subject: + rtc-pm8xxx-fixup-checkpatch-style-issues.patch added to -mm
 tree
Date: Mon, 10 Mar 2014 13:48:01 -0700
Message-ID: <531e2501.kdp89BY+QxCxlaYd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaCJUsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:48:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: + rtc-pm8xxx-fixup-checkpatch-style-issues.patch added to -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,sboyd@codeaurora.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:48:01 -0700


The patch titled
     Subject: rtc: pm8xxx: fixup checkpatch/style issues
has been added to the -mm tree.  Its filename is
     rtc-pm8xxx-fixup-checkpatch-style-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pm8xxx-fixup-checkpatch-style-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pm8xxx-fixup-checkpatch-style-issues.patch

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
Subject: rtc: pm8xxx: fixup checkpatch/style issues

This patchset is based on Stephen Boyd's PM8921 modernization/cleanups
(http://lkml.kernel.org/g/1393441166-32692-1-git-send-email-sboyd@codeaurora.org),
and allows for this RTC driver to be usable again.


This patch (of 6):

Before performing additional cleanups to this driver, do the easy cleanups
first.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pm8xxx.c |   97 ++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 44 deletions(-)

diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-fixup-checkpatch-style-issues drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-fixup-checkpatch-style-issues
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -53,7 +53,7 @@ struct pm8xxx_rtc {
 	int rtc_read_base;
 	int rtc_write_base;
 	int alarm_rw_base;
-	u8  ctrl_reg;
+	u8 ctrl_reg;
 	struct device *rtc_dev;
 	spinlock_t ctrl_reg_lock;
 };
@@ -63,7 +63,7 @@ struct pm8xxx_rtc {
  * hardware limitation.
  */
 static int pm8xxx_read_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-		int base, int count)
+			       int base, int count)
 {
 	int i, rc;
 	struct device *parent = rtc_dd->rtc_dev->parent;
@@ -80,7 +80,7 @@ static int pm8xxx_read_wrapper(struct pm
 }
 
 static int pm8xxx_write_wrapper(struct pm8xxx_rtc *rtc_dd, u8 *rtc_val,
-		int base, int count)
+				int base, int count)
 {
 	int i, rc;
 	struct device *parent = rtc_dd->rtc_dev->parent;
@@ -126,15 +126,15 @@ static int pm8xxx_rtc_set_time(struct de
 		alarm_enabled = 1;
 		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-				1);
+					  1);
 		if (rc < 0) {
-			dev_err(dev, "Write to RTC control register "
-								"failed\n");
+			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
 		rtc_dd->ctrl_reg = ctrl_reg;
-	} else
+	} else {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
+	}
 
 	/* Write 0 to Byte[0] */
 	reg = 0;
@@ -146,7 +146,7 @@ static int pm8xxx_rtc_set_time(struct de
 
 	/* Write Byte[1], Byte[2], Byte[3] */
 	rc = pm8xxx_write_wrapper(rtc_dd, value + 1,
-					rtc_dd->rtc_write_base + 1, 3);
+				  rtc_dd->rtc_write_base + 1, 3);
 	if (rc < 0) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
@@ -162,10 +162,9 @@ static int pm8xxx_rtc_set_time(struct de
 	if (alarm_enabled) {
 		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
 		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
-									1);
+					  1);
 		if (rc < 0) {
-			dev_err(dev, "Write to RTC control register "
-								"failed\n");
+			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
 		rtc_dd->ctrl_reg = ctrl_reg;
@@ -186,7 +185,7 @@ static int pm8xxx_rtc_read_time(struct d
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
 	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->rtc_read_base,
-							NUM_8_BIT_RTC_REGS);
+				 NUM_8_BIT_RTC_REGS);
 	if (rc < 0) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
@@ -204,7 +203,8 @@ static int pm8xxx_rtc_read_time(struct d
 
 	if (unlikely(reg < value[0])) {
 		rc = pm8xxx_read_wrapper(rtc_dd, value,
-				rtc_dd->rtc_read_base, NUM_8_BIT_RTC_REGS);
+					 rtc_dd->rtc_read_base,
+					 NUM_8_BIT_RTC_REGS);
 		if (rc < 0) {
 			dev_err(dev, "RTC read data register failed\n");
 			return rc;
@@ -222,8 +222,8 @@ static int pm8xxx_rtc_read_time(struct d
 	}
 
 	dev_dbg(dev, "secs = %lu, h:m:s == %d:%d:%d, d/m/y = %d/%d/%d\n",
-				secs, tm->tm_hour, tm->tm_min, tm->tm_sec,
-				tm->tm_mday, tm->tm_mon, tm->tm_year);
+		secs, tm->tm_hour, tm->tm_min, tm->tm_sec,
+		tm->tm_mday, tm->tm_mon, tm->tm_year);
 
 	return 0;
 }
@@ -245,15 +245,18 @@ static int pm8xxx_rtc_set_alarm(struct d
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = pm8xxx_write_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-							NUM_8_BIT_RTC_REGS);
+				  NUM_8_BIT_RTC_REGS);
 	if (rc < 0) {
 		dev_err(dev, "Write to RTC ALARM register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	ctrl_reg = rtc_dd->ctrl_reg;
-	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
-					(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
+
+	if (alarm->enabled)
+		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
+	else
+		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
@@ -264,9 +267,9 @@ static int pm8xxx_rtc_set_alarm(struct d
 	rtc_dd->ctrl_reg = ctrl_reg;
 
 	dev_dbg(dev, "Alarm Set for h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
-				alarm->time.tm_hour, alarm->time.tm_min,
-				alarm->time.tm_sec, alarm->time.tm_mday,
-				alarm->time.tm_mon, alarm->time.tm_year);
+		alarm->time.tm_hour, alarm->time.tm_min,
+		alarm->time.tm_sec, alarm->time.tm_mday,
+		alarm->time.tm_mon, alarm->time.tm_year);
 rtc_rw_fail:
 	spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 	return rc;
@@ -280,7 +283,7 @@ static int pm8xxx_rtc_read_alarm(struct
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 
 	rc = pm8xxx_read_wrapper(rtc_dd, value, rtc_dd->alarm_rw_base,
-			NUM_8_BIT_RTC_REGS);
+				 NUM_8_BIT_RTC_REGS);
 	if (rc < 0) {
 		dev_err(dev, "RTC alarm time read failed\n");
 		return rc;
@@ -297,9 +300,9 @@ static int pm8xxx_rtc_read_alarm(struct
 	}
 
 	dev_dbg(dev, "Alarm set for - h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
-				alarm->time.tm_hour, alarm->time.tm_min,
-				alarm->time.tm_sec, alarm->time.tm_mday,
-				alarm->time.tm_mon, alarm->time.tm_year);
+		alarm->time.tm_hour, alarm->time.tm_min,
+		alarm->time.tm_sec, alarm->time.tm_mday,
+		alarm->time.tm_mon, alarm->time.tm_year);
 
 	return 0;
 }
@@ -312,9 +315,13 @@ static int pm8xxx_rtc_alarm_irq_enable(s
 	u8 ctrl_reg;
 
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
+
 	ctrl_reg = rtc_dd->ctrl_reg;
-	ctrl_reg = (enable) ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
-				(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
+
+	if (enable)
+		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
+	else
+		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
 
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
@@ -354,8 +361,8 @@ static irqreturn_t pm8xxx_alarm_trigger(
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
 	if (rc < 0) {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
-		dev_err(rtc_dd->rtc_dev, "Write to RTC control register "
-								"failed\n");
+		dev_err(rtc_dd->rtc_dev,
+			"Write to RTC control register failed\n");
 		goto rtc_alarm_handled;
 	}
 
@@ -364,19 +371,19 @@ static irqreturn_t pm8xxx_alarm_trigger(
 
 	/* Clear RTC alarm register */
 	rc = pm8xxx_read_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-						PM8XXX_ALARM_CTRL_OFFSET, 1);
+				 PM8XXX_ALARM_CTRL_OFFSET, 1);
 	if (rc < 0) {
-		dev_err(rtc_dd->rtc_dev, "RTC Alarm control register read "
-								"failed\n");
+		dev_err(rtc_dd->rtc_dev,
+			"RTC Alarm control register read failed\n");
 		goto rtc_alarm_handled;
 	}
 
 	ctrl_reg &= ~PM8xxx_RTC_ALARM_CLEAR;
 	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base +
-						PM8XXX_ALARM_CTRL_OFFSET, 1);
+				  PM8XXX_ALARM_CTRL_OFFSET, 1);
 	if (rc < 0)
-		dev_err(rtc_dd->rtc_dev, "Write to RTC Alarm control register"
-								" failed\n");
+		dev_err(rtc_dd->rtc_dev,
+			"Write to RTC Alarm control register failed\n");
 
 rtc_alarm_handled:
 	return IRQ_HANDLED;
@@ -409,7 +416,7 @@ static int pm8xxx_rtc_probe(struct platf
 	}
 
 	rtc_resource = platform_get_resource_byname(pdev, IORESOURCE_IO,
-							"pmic_rtc_base");
+						    "pmic_rtc_base");
 	if (!(rtc_resource && rtc_resource->start)) {
 		dev_err(&pdev->dev, "RTC IO resource absent!\n");
 		return -ENXIO;
@@ -436,31 +443,31 @@ static int pm8xxx_rtc_probe(struct platf
 		rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base,
 									1);
 		if (rc < 0) {
-			dev_err(&pdev->dev, "Write to RTC control register "
-								"failed\n");
+			dev_err(&pdev->dev,
+				"Write to RTC control register failed\n");
 			return rc;
 		}
 	}
 
 	rtc_dd->ctrl_reg = ctrl_reg;
-	if (rtc_write_enable == true)
+	if (rtc_write_enable)
 		pm8xxx_rtc_ops.set_time = pm8xxx_rtc_set_time;
 
 	platform_set_drvdata(pdev, rtc_dd);
 
 	/* Register the RTC device */
 	rtc_dd->rtc = devm_rtc_device_register(&pdev->dev, "pm8xxx_rtc",
-				&pm8xxx_rtc_ops, THIS_MODULE);
+					       &pm8xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_dd->rtc)) {
 		dev_err(&pdev->dev, "%s: RTC registration failed (%ld)\n",
-					__func__, PTR_ERR(rtc_dd->rtc));
+			__func__, PTR_ERR(rtc_dd->rtc));
 		return PTR_ERR(rtc_dd->rtc);
 	}
 
 	/* Request the alarm IRQ */
 	rc = request_any_context_irq(rtc_dd->rtc_alarm_irq,
-				 pm8xxx_alarm_trigger, IRQF_TRIGGER_RISING,
-				 "pm8xxx_rtc_alarm", rtc_dd);
+				     pm8xxx_alarm_trigger, IRQF_TRIGGER_RISING,
+				     "pm8xxx_rtc_alarm", rtc_dd);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Request IRQ failed (%d)\n", rc);
 		return rc;
@@ -505,7 +512,9 @@ static int pm8xxx_rtc_suspend(struct dev
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops, pm8xxx_rtc_suspend, pm8xxx_rtc_resume);
+static SIMPLE_DEV_PM_OPS(pm8xxx_rtc_pm_ops,
+			 pm8xxx_rtc_suspend,
+			 pm8xxx_rtc_resume);
 
 static struct platform_driver pm8xxx_rtc_driver = {
 	.probe		= pm8xxx_rtc_probe,
_

Patches currently in -mm which might be from joshc@codeaurora.org are

rtc-pm8xxx-fixup-checkpatch-style-issues.patch
rtc-pm8xxx-use-regmap-api-for-register-accesses.patch
rtc-pm8xxx-use-devm_request_any_context_irq.patch
rtc-pm8xxx-add-support-for-devicetree.patch
rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch
documentation-bindings-document-pmic8921-8058-rtc.patch
linux-next.patch

