From: akpm@linux-foundation.org
Subject: + rtc-pm8xxx-rework-to-support-pm8941-rtc.patch added to -mm tree
Date: Fri, 19 Sep 2014 16:02:45 -0700
Message-ID: <541cb615.MxfWE/dLi+BlFhXX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaISXCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 19:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svarbanov@mm-sol.com, a.zummo@towertech.it, joshc@codeaurora.org, sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pm8xxx.c: rework to support pm8941 rtc
has been added to the -mm tree.  Its filename is
     rtc-pm8xxx-rework-to-support-pm8941-rtc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-pm8xxx-rework-to-support-pm8941-rtc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-pm8xxx-rework-to-support-pm8941-rtc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: drivers/rtc/rtc-pm8xxx.c: rework to support pm8941 rtc

Adds support for RTC device inside PM8941 PMIC.  The RTC in this PMIC have
two register spaces.  Thus the rtc-pm8xxx is slightly reworked to reflect
these differences.

The register set for different PMIC chips are selected on DT compatible
string base.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    2 
 drivers/rtc/rtc-pm8xxx.c |  217 ++++++++++++++++++++++---------------
 2 files changed, 134 insertions(+), 85 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-pm8xxx-rework-to-support-pm8941-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-pm8xxx-rework-to-support-pm8941-rtc
+++ a/drivers/rtc/Kconfig
@@ -1303,7 +1303,7 @@ config RTC_DRV_LPC32XX
 
 config RTC_DRV_PM8XXX
 	tristate "Qualcomm PMIC8XXX RTC"
-	depends on MFD_PM8XXX
+	depends on MFD_PM8XXX || MFD_SPMI_PMIC
 	help
 	  If you say yes here you get support for the
 	  Qualcomm PMIC8XXX RTC.
diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-rework-to-support-pm8941-rtc drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-pm8xxx-rework-to-support-pm8941-rtc
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -27,21 +27,36 @@
 
 /* RTC_CTRL register bit fields */
 #define PM8xxx_RTC_ENABLE		BIT(7)
-#define PM8xxx_RTC_ALARM_ENABLE		BIT(1)
 #define PM8xxx_RTC_ALARM_CLEAR		BIT(0)
 
 #define NUM_8_BIT_RTC_REGS		0x4
 
 /**
+ * struct pm8xxx_rtc_regs - describe RTC registers per PMIC versions
+ * @ctrl: base address of control register
+ * @write: base address of write register
+ * @read: base address of read register
+ * @alarm_ctrl: base address of alarm control register
+ * @alarm_ctrl2: base address of alarm control2 register
+ * @alarm_rw: base address of alarm read-write register
+ * @alarm_en: alarm enable mask
+ */
+struct pm8xxx_rtc_regs {
+	unsigned int ctrl;
+	unsigned int write;
+	unsigned int read;
+	unsigned int alarm_ctrl;
+	unsigned int alarm_ctrl2;
+	unsigned int alarm_rw;
+	unsigned int alarm_en;
+};
+
+/**
  * struct pm8xxx_rtc -  rtc driver internal structure
  * @rtc:		rtc device for this driver.
  * @regmap:		regmap used to access RTC registers
  * @allow_set_time:	indicates whether writing to the RTC is allowed
  * @rtc_alarm_irq:	rtc alarm irq number.
- * @rtc_base:		address of rtc control register.
- * @rtc_read_base:	base address of read registers.
- * @rtc_write_base:	base address of write registers.
- * @alarm_rw_base:	base address of alarm registers.
  * @ctrl_reg:		rtc control register.
  * @rtc_dev:		device structure.
  * @ctrl_reg_lock:	spinlock protecting access to ctrl_reg.
@@ -51,11 +66,7 @@ struct pm8xxx_rtc {
 	struct regmap *regmap;
 	bool allow_set_time;
 	int rtc_alarm_irq;
-	int rtc_base;
-	int rtc_read_base;
-	int rtc_write_base;
-	int alarm_rw_base;
-	u8 ctrl_reg;
+	const struct pm8xxx_rtc_regs *regs;
 	struct device *rtc_dev;
 	spinlock_t ctrl_reg_lock;
 };
@@ -71,8 +82,10 @@ static int pm8xxx_rtc_set_time(struct de
 {
 	int rc, i;
 	unsigned long secs, irq_flags;
-	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0, ctrl_reg;
+	u8 value[NUM_8_BIT_RTC_REGS], alarm_enabled = 0;
+	unsigned int ctrl_reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
+	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
 
 	if (!rtc_dd->allow_set_time)
 		return -EACCES;
@@ -87,30 +100,32 @@ static int pm8xxx_rtc_set_time(struct de
 	dev_dbg(dev, "Seconds value to be written to RTC = %lu\n", secs);
 
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
-	ctrl_reg = rtc_dd->ctrl_reg;
 
-	if (ctrl_reg & PM8xxx_RTC_ALARM_ENABLE) {
+	rc = regmap_read(rtc_dd->regmap, regs->ctrl, &ctrl_reg);
+	if (rc)
+		goto rtc_rw_fail;
+
+	if (ctrl_reg & regs->alarm_en) {
 		alarm_enabled = 1;
-		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
-		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		ctrl_reg &= ~regs->alarm_en;
+		rc = regmap_write(rtc_dd->regmap, regs->ctrl, ctrl_reg);
 		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
-		rtc_dd->ctrl_reg = ctrl_reg;
 	} else {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 	}
 
 	/* Write 0 to Byte[0] */
-	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_write_base, 0);
+	rc = regmap_write(rtc_dd->regmap, regs->write, 0);
 	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	/* Write Byte[1], Byte[2], Byte[3] */
-	rc = regmap_bulk_write(rtc_dd->regmap, rtc_dd->rtc_write_base + 1,
+	rc = regmap_bulk_write(rtc_dd->regmap, regs->write + 1,
 			       &value[1], sizeof(value) - 1);
 	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
@@ -118,20 +133,19 @@ static int pm8xxx_rtc_set_time(struct de
 	}
 
 	/* Write Byte[0] */
-	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_write_base, value[0]);
+	rc = regmap_write(rtc_dd->regmap, regs->write, value[0]);
 	if (rc) {
 		dev_err(dev, "Write to RTC write data register failed\n");
 		goto rtc_rw_fail;
 	}
 
 	if (alarm_enabled) {
-		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
-		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+		ctrl_reg |= regs->alarm_en;;
+		rc = regmap_write(rtc_dd->regmap, regs->ctrl, ctrl_reg);
 		if (rc) {
 			dev_err(dev, "Write to RTC control register failed\n");
 			goto rtc_rw_fail;
 		}
-		rtc_dd->ctrl_reg = ctrl_reg;
 	}
 
 rtc_rw_fail:
@@ -148,9 +162,9 @@ static int pm8xxx_rtc_read_time(struct d
 	unsigned long secs;
 	unsigned int reg;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
+	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
 
-	rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->rtc_read_base,
-			      value, sizeof(value));
+	rc = regmap_bulk_read(rtc_dd->regmap, regs->read, value, sizeof(value));
 	if (rc) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
@@ -160,14 +174,14 @@ static int pm8xxx_rtc_read_time(struct d
 	 * Read the LSB again and check if there has been a carry over.
 	 * If there is, redo the read operation.
 	 */
-	rc = regmap_read(rtc_dd->regmap, rtc_dd->rtc_read_base, &reg);
+	rc = regmap_read(rtc_dd->regmap, regs->read, &reg);
 	if (rc < 0) {
 		dev_err(dev, "RTC read data register failed\n");
 		return rc;
 	}
 
 	if (unlikely(reg < value[0])) {
-		rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->rtc_read_base,
+		rc = regmap_bulk_read(rtc_dd->regmap, regs->read,
 				      value, sizeof(value));
 		if (rc) {
 			dev_err(dev, "RTC read data register failed\n");
@@ -195,9 +209,11 @@ static int pm8xxx_rtc_read_time(struct d
 static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	int rc, i;
-	u8 value[NUM_8_BIT_RTC_REGS], ctrl_reg;
+	u8 value[NUM_8_BIT_RTC_REGS];
+	unsigned int ctrl_reg;
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
+	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
 
 	rtc_tm_to_time(&alarm->time, &secs);
 
@@ -208,28 +224,28 @@ static int pm8xxx_rtc_set_alarm(struct d
 
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
-	rc = regmap_bulk_write(rtc_dd->regmap, rtc_dd->alarm_rw_base, value,
+	rc = regmap_bulk_write(rtc_dd->regmap, regs->alarm_rw, value,
 			       sizeof(value));
 	if (rc) {
 		dev_err(dev, "Write to RTC ALARM register failed\n");
 		goto rtc_rw_fail;
 	}
 
-	ctrl_reg = rtc_dd->ctrl_reg;
+	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl, &ctrl_reg);
+	if (rc)
+		goto rtc_rw_fail;
 
 	if (alarm->enabled)
-		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
+		ctrl_reg |= regs->alarm_en;
 	else
-		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
+		ctrl_reg &= ~regs->alarm_en;
 
-	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
 	if (rc) {
-		dev_err(dev, "Write to RTC control register failed\n");
+		dev_err(dev, "Write to RTC alarm control register failed\n");
 		goto rtc_rw_fail;
 	}
 
-	rtc_dd->ctrl_reg = ctrl_reg;
-
 	dev_dbg(dev, "Alarm Set for h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
 		alarm->time.tm_hour, alarm->time.tm_min,
 		alarm->time.tm_sec, alarm->time.tm_mday,
@@ -245,8 +261,9 @@ static int pm8xxx_rtc_read_alarm(struct
 	u8 value[NUM_8_BIT_RTC_REGS];
 	unsigned long secs;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
+	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
 
-	rc = regmap_bulk_read(rtc_dd->regmap, rtc_dd->alarm_rw_base, value,
+	rc = regmap_bulk_read(rtc_dd->regmap, regs->alarm_rw, value,
 			      sizeof(value));
 	if (rc) {
 		dev_err(dev, "RTC alarm time read failed\n");
@@ -276,25 +293,26 @@ static int pm8xxx_rtc_alarm_irq_enable(s
 	int rc;
 	unsigned long irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
-	u8 ctrl_reg;
+	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
+	unsigned int ctrl_reg;
 
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
-	ctrl_reg = rtc_dd->ctrl_reg;
+	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl, &ctrl_reg);
+	if (rc)
+		goto rtc_rw_fail;
 
 	if (enable)
-		ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
+		ctrl_reg |= regs->alarm_en;
 	else
-		ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
+		ctrl_reg &= ~regs->alarm_en;
 
-	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
 	if (rc) {
 		dev_err(dev, "Write to RTC control register failed\n");
 		goto rtc_rw_fail;
 	}
 
-	rtc_dd->ctrl_reg = ctrl_reg;
-
 rtc_rw_fail:
 	spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 	return rc;
@@ -311,6 +329,7 @@ static const struct rtc_class_ops pm8xxx
 static irqreturn_t pm8xxx_alarm_trigger(int irq, void *dev_id)
 {
 	struct pm8xxx_rtc *rtc_dd = dev_id;
+	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
 	unsigned int ctrl_reg;
 	int rc;
 	unsigned long irq_flags;
@@ -320,48 +339,100 @@ static irqreturn_t pm8xxx_alarm_trigger(
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	/* Clear the alarm enable bit */
-	ctrl_reg = rtc_dd->ctrl_reg;
-	ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;
+	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl, &ctrl_reg);
+	if (rc) {
+		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
+		goto rtc_alarm_handled;
+	}
+
+	ctrl_reg &= ~regs->alarm_en;;
 
-	rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
+	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
 	if (rc) {
 		spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 		dev_err(rtc_dd->rtc_dev,
-			"Write to RTC control register failed\n");
+			"Write to alarm control register failed\n");
 		goto rtc_alarm_handled;
 	}
 
-	rtc_dd->ctrl_reg = ctrl_reg;
 	spin_unlock_irqrestore(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	/* Clear RTC alarm register */
-	rc = regmap_read(rtc_dd->regmap,
-			 rtc_dd->rtc_base + PM8XXX_ALARM_CTRL_OFFSET,
-			 &ctrl_reg);
+	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl2, &ctrl_reg);
 	if (rc) {
 		dev_err(rtc_dd->rtc_dev,
-			"RTC Alarm control register read failed\n");
+			"RTC Alarm control2 register read failed\n");
 		goto rtc_alarm_handled;
 	}
 
-	ctrl_reg &= ~PM8xxx_RTC_ALARM_CLEAR;
-	rc = regmap_write(rtc_dd->regmap,
-			  rtc_dd->rtc_base + PM8XXX_ALARM_CTRL_OFFSET,
-			  ctrl_reg);
+	ctrl_reg |= PM8xxx_RTC_ALARM_CLEAR;
+	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl2, ctrl_reg);
 	if (rc)
 		dev_err(rtc_dd->rtc_dev,
-			"Write to RTC Alarm control register failed\n");
+			"Write to RTC Alarm control2 register failed\n");
 
 rtc_alarm_handled:
 	return IRQ_HANDLED;
 }
 
+static int pm8xxx_rtc_enable(struct pm8xxx_rtc *rtc_dd)
+{
+	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
+	unsigned int ctrl_reg;
+	int rc;
+
+	/* Check if the RTC is on, else turn it on */
+	rc = regmap_read(rtc_dd->regmap, regs->ctrl, &ctrl_reg);
+	if (rc)
+		return rc;
+
+	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
+		ctrl_reg |= PM8xxx_RTC_ENABLE;
+		rc = regmap_write(rtc_dd->regmap, regs->ctrl, ctrl_reg);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static const struct pm8xxx_rtc_regs pm8921_regs = {
+	.ctrl		= 0x11d,
+	.write		= 0x11f,
+	.read		= 0x123,
+	.alarm_rw	= 0x127,
+	.alarm_ctrl	= 0x11d,
+	.alarm_ctrl2	= 0x11e,
+	.alarm_en	= BIT(1),
+};
+
+static const struct pm8xxx_rtc_regs pm8058_regs = {
+	.ctrl		= 0x1e8,
+	.write		= 0x1ea,
+	.read		= 0x1ee,
+	.alarm_rw	= 0x1f2,
+	.alarm_ctrl	= 0x1e8,
+	.alarm_ctrl2	= 0x1e9,
+	.alarm_en	= BIT(1),
+};
+
+static const struct pm8xxx_rtc_regs pm8941_regs = {
+	.ctrl		= 0x6046,
+	.write		= 0x6040,
+	.read		= 0x6048,
+	.alarm_rw	= 0x6140,
+	.alarm_ctrl	= 0x6146,
+	.alarm_ctrl2	= 0x6148,
+	.alarm_en	= BIT(7),
+};
+
 /*
  * Hardcoded RTC bases until IORESOURCE_REG mapping is figured out
  */
 static const struct of_device_id pm8xxx_id_table[] = {
-	{ .compatible = "qcom,pm8921-rtc", .data = (void *) 0x11D },
-	{ .compatible = "qcom,pm8058-rtc", .data = (void *) 0x1E8 },
+	{ .compatible = "qcom,pm8921-rtc", .data = &pm8921_regs },
+	{ .compatible = "qcom,pm8058-rtc", .data = &pm8058_regs },
+	{ .compatible = "qcom,pm8941-rtc", .data = &pm8941_regs },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, pm8xxx_id_table);
@@ -369,7 +440,6 @@ MODULE_DEVICE_TABLE(of, pm8xxx_id_table)
 static int pm8xxx_rtc_probe(struct platform_device *pdev)
 {
 	int rc;
-	unsigned int ctrl_reg;
 	struct pm8xxx_rtc *rtc_dd;
 	const struct of_device_id *match;
 
@@ -399,33 +469,12 @@ static int pm8xxx_rtc_probe(struct platf
 	rtc_dd->allow_set_time = of_property_read_bool(pdev->dev.of_node,
 						      "allow-set-time");
 
-	rtc_dd->rtc_base = (long) match->data;
-
-	/* Setup RTC register addresses */
-	rtc_dd->rtc_write_base = rtc_dd->rtc_base + PM8XXX_RTC_WRITE_OFFSET;
-	rtc_dd->rtc_read_base = rtc_dd->rtc_base + PM8XXX_RTC_READ_OFFSET;
-	rtc_dd->alarm_rw_base = rtc_dd->rtc_base + PM8XXX_ALARM_RW_OFFSET;
-
+	rtc_dd->regs = match->data;
 	rtc_dd->rtc_dev = &pdev->dev;
 
-	/* Check if the RTC is on, else turn it on */
-	rc = regmap_read(rtc_dd->regmap, rtc_dd->rtc_base, &ctrl_reg);
-	if (rc) {
-		dev_err(&pdev->dev, "RTC control register read failed!\n");
+	rc = pm8xxx_rtc_enable(rtc_dd);
+	if (rc)
 		return rc;
-	}
-
-	if (!(ctrl_reg & PM8xxx_RTC_ENABLE)) {
-		ctrl_reg |= PM8xxx_RTC_ENABLE;
-		rc = regmap_write(rtc_dd->regmap, rtc_dd->rtc_base, ctrl_reg);
-		if (rc) {
-			dev_err(&pdev->dev,
-				"Write to RTC control register failed\n");
-			return rc;
-		}
-	}
