From: akpm@linux-foundation.org
Subject: [merged] rtc-tw4030-add-alarm-update-interfaces-v2.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:36 -0800
Message-ID: <200901161916.n0GJGad4025147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932951AbZAPTRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, dbrownell@users.sourceforge.net, sameo@openedhand.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     rtc: tw4030 add alarm/update interfaces
has been removed from the -mm tree.  Its filename was
     rtc-tw4030-add-alarm-update-interfaces-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: tw4030 add alarm/update interfaces
From: Alessandro Zummo <a.zummo@towertech.it>

- implement alarm_irq_enable
- return correct error code when registering fails

[dbrownell@users.sourceforge.net: build fixes, force 1/sec irqs]
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: rtc-linux@googlegroups.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl4030.c |   44 ++++++++----------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff -puN drivers/rtc/rtc-twl4030.c~rtc-tw4030-add-alarm-update-interfaces-v2 drivers/rtc/rtc-twl4030.c
--- a/drivers/rtc/rtc-twl4030.c~rtc-tw4030-add-alarm-update-interfaces-v2
+++ a/drivers/rtc/rtc-twl4030.c
@@ -120,7 +120,7 @@ static int twl4030_rtc_write_u8(u8 data,
 static unsigned char rtc_irq_bits;
 
 /*
- * Enable timer and/or alarm interrupts.
+ * Enable 1/second update and/or alarm interrupts.
  */
 static int set_rtc_irq_bit(unsigned char bit)
 {
@@ -128,6 +128,7 @@ static int set_rtc_irq_bit(unsigned char
 	int ret;
 
 	val = rtc_irq_bits | bit;
+	val &= ~BIT_RTC_INTERRUPTS_REG_EVERY_M;
 	ret = twl4030_rtc_write_u8(val, REG_RTC_INTERRUPTS_REG);
 	if (ret == 0)
 		rtc_irq_bits = val;
@@ -136,7 +137,7 @@ static int set_rtc_irq_bit(unsigned char
 }
 
 /*
- * Disable timer and/or alarm interrupts.
+ * Disable update and/or alarm interrupts.
  */
 static int mask_rtc_irq_bit(unsigned char bit)
 {
@@ -151,7 +152,7 @@ static int mask_rtc_irq_bit(unsigned cha
 	return ret;
 }
 
-static inline int twl4030_rtc_alarm_irq_set_state(int enabled)
+static int twl4030_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
 {
 	int ret;
 
@@ -163,7 +164,7 @@ static inline int twl4030_rtc_alarm_irq_
 	return ret;
 }
 
-static inline int twl4030_rtc_irq_set_state(int enabled)
+static int twl4030_rtc_update_irq_enable(struct device *dev, unsigned enabled)
 {
 	int ret;
 
@@ -292,7 +293,7 @@ static int twl4030_rtc_set_alarm(struct 
 	unsigned char alarm_data[ALL_TIME_REGS + 1];
 	int ret;
 
-	ret = twl4030_rtc_alarm_irq_set_state(0);
+	ret = twl4030_rtc_alarm_irq_enable(dev, 0);
 	if (ret)
 		goto out;
 
@@ -312,35 +313,11 @@ static int twl4030_rtc_set_alarm(struct 
 	}
 
 	if (alm->enabled)
-		ret = twl4030_rtc_alarm_irq_set_state(1);
+		ret = twl4030_rtc_alarm_irq_enable(dev, 1);
 out:
 	return ret;
 }
 
-#ifdef	CONFIG_RTC_INTF_DEV
-
-static int twl4030_rtc_ioctl(struct device *dev, unsigned int cmd,
-			     unsigned long arg)
-{
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		return twl4030_rtc_alarm_irq_set_state(0);
-	case RTC_AIE_ON:
-		return twl4030_rtc_alarm_irq_set_state(1);
-	case RTC_UIE_OFF:
-		return twl4030_rtc_irq_set_state(0);
-	case RTC_UIE_ON:
-		return twl4030_rtc_irq_set_state(1);
-
-	default:
-		return -ENOIOCTLCMD;
-	}
-}
-
-#else
-#define	twl4030_rtc_ioctl	NULL
-#endif
-
 static irqreturn_t twl4030_rtc_interrupt(int irq, void *rtc)
 {
 	unsigned long events = 0;
@@ -400,11 +377,12 @@ out:
 }
 
 static struct rtc_class_ops twl4030_rtc_ops = {
-	.ioctl		= twl4030_rtc_ioctl,
 	.read_time	= twl4030_rtc_read_time,
 	.set_time	= twl4030_rtc_set_time,
 	.read_alarm	= twl4030_rtc_read_alarm,
 	.set_alarm	= twl4030_rtc_set_alarm,
+	.alarm_irq_enable = twl4030_rtc_alarm_irq_enable,
+	.update_irq_enable = twl4030_rtc_update_irq_enable,
 };
 
 /*----------------------------------------------------------------------*/
@@ -422,7 +400,7 @@ static int __devinit twl4030_rtc_probe(s
 	rtc = rtc_device_register(pdev->name,
 				  &pdev->dev, &twl4030_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		ret = -EINVAL;
+		ret = PTR_ERR(rtc);
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 			PTR_ERR(rtc));
 		goto out0;
@@ -432,7 +410,6 @@ static int __devinit twl4030_rtc_probe(s
 	platform_set_drvdata(pdev, rtc);
 
 	ret = twl4030_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
-
 	if (ret < 0)
 		goto out1;
 
@@ -475,7 +452,6 @@ static int __devinit twl4030_rtc_probe(s
 
 	return ret;
 
