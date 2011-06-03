From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-rtc-rtc-stmp3xxxc-get-rid-of-platform-specific-include-for-register-names.patch removed from -mm tree
Date: Fri, 03 Jun 2011 16:08:38 -0700
Message-ID: <201106032308.p53N8c4X013276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756552Ab1FCXJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, a.zummo@towertech.it, johnstul@us.ibm.com, shawn.guo@freescale.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-stmp3xxx.c: get rid of platform-specific include for register names
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-stmp3xxxc-get-rid-of-platform-specific-include-for-register-names.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-stmp3xxx.c: get rid of platform-specific include for register names
From: Wolfram Sang <w.sang@pengutronix.de>

plat-stmp has now been removed and merged with mach-mxs, this patch series
will convert the stmp-rtc driver for usage with mach-mxs, so the driver
will become selectable and usable again (it broke twice after the UIE
conversion, by the way).  Quite some platform-specific dependencies have
been removed, too.

The driver has successfully been tested by me on an MX28-board and passed
the RTC test program.  Shawn Guo tested it on his MX23 and MX28 boards.


This patch:

Move the register names into the driver and rename them to kernel style.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Tested-by: Shawn Guo <shawn.guo@freescale.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |   92 ++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 37 deletions(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-get-rid-of-platform-specific-include-for-register-names drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-get-rid-of-platform-specific-include-for-register-names
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -26,7 +26,25 @@
 
 #include <mach/platform.h>
 #include <mach/stmp3xxx.h>
-#include <mach/regs-rtc.h>
+
+#define STMP3XXX_RTC_CTRL		0x0
+#define STMP3XXX_RTC_CTRL_ALARM_IRQ_EN		0x00000001
+#define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN	0x00000002
+#define STMP3XXX_RTC_CTRL_ALARM_IRQ		0x00000004
+#define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ		0x00000008
+
+#define STMP3XXX_RTC_STAT		0x10
+#define STMP3XXX_RTC_STAT_STALE_SHIFT		16
+#define STMP3XXX_RTC_STAT_RTC_PRESENT		0x80000000
+
+#define STMP3XXX_RTC_SECONDS		0x30
+
+#define STMP3XXX_RTC_ALARM		0x40
+
+#define STMP3XXX_RTC_PERSISTENT0	0x60
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN	0x00000002
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_EN	0x00000004
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE	0x00000080
 
 struct stmp3xxx_rtc_data {
 	struct rtc_device *rtc;
@@ -42,8 +60,8 @@ static void stmp3xxx_wait_time(struct st
 	 * NEW_REGS/STALE_REGS bitfields go. In fact it's 0x1=P0,
 	 * 0x2=P1, .., 0x20=P5, 0x40=ALARM, 0x80=SECONDS
 	 */
-	while (__raw_readl(rtc_data->io + HW_RTC_STAT) &
-			BF(0x80, RTC_STAT_STALE_REGS))
+	while (__raw_readl(rtc_data->io + STMP3XXX_RTC_STAT) &
+			(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT))
 		cpu_relax();
 }
 
@@ -53,7 +71,7 @@ static int stmp3xxx_rtc_gettime(struct d
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	stmp3xxx_wait_time(rtc_data);
-	rtc_time_to_tm(__raw_readl(rtc_data->io + HW_RTC_SECONDS), rtc_tm);
+	rtc_time_to_tm(__raw_readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
 	return 0;
 }
 
@@ -61,7 +79,7 @@ static int stmp3xxx_rtc_set_mmss(struct 
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	__raw_writel(t, rtc_data->io + HW_RTC_SECONDS);
+	__raw_writel(t, rtc_data->io + STMP3XXX_RTC_SECONDS);
 	stmp3xxx_wait_time(rtc_data);
 	return 0;
 }
@@ -73,18 +91,18 @@ static irqreturn_t stmp3xxx_rtc_interrup
 	u32 status;
 	u32 events = 0;
 
-	status = __raw_readl(rtc_data->io + HW_RTC_CTRL) &
-			(BM_RTC_CTRL_ALARM_IRQ | BM_RTC_CTRL_ONEMSEC_IRQ);
+	status = __raw_readl(rtc_data->io + STMP3XXX_RTC_CTRL) &
+			(STMP3XXX_RTC_CTRL_ALARM_IRQ | STMP3XXX_RTC_CTRL_ONEMSEC_IRQ);
 
-	if (status & BM_RTC_CTRL_ALARM_IRQ) {
-		stmp3xxx_clearl(BM_RTC_CTRL_ALARM_IRQ,
-				rtc_data->io + HW_RTC_CTRL);
+	if (status & STMP3XXX_RTC_CTRL_ALARM_IRQ) {
+		stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ALARM_IRQ,
+				rtc_data->io + STMP3XXX_RTC_CTRL);
 		events |= RTC_AF | RTC_IRQF;
 	}
 
-	if (status & BM_RTC_CTRL_ONEMSEC_IRQ) {
-		stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ,
-				rtc_data->io + HW_RTC_CTRL);
+	if (status & STMP3XXX_RTC_CTRL_ONEMSEC_IRQ) {
+		stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ,
+				rtc_data->io + STMP3XXX_RTC_CTRL);
 		if (++rtc_data->irq_count % 1000 == 0) {
 			events |= RTC_UF | RTC_IRQF;
 			rtc_data->irq_count = 0;
@@ -100,17 +118,17 @@ static irqreturn_t stmp3xxx_rtc_interrup
 static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
-	void __iomem *p = rtc_data->io + HW_RTC_PERSISTENT0,
-		     *ctl = rtc_data->io + HW_RTC_CTRL;
+	void __iomem *p = rtc_data->io + STMP3XXX_RTC_PERSISTENT0,
+		     *ctl = rtc_data->io + STMP3XXX_RTC_CTRL;
 
 	if (enabled) {
-		stmp3xxx_setl(BM_RTC_PERSISTENT0_ALARM_EN |
-			      BM_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		stmp3xxx_setl(BM_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		stmp3xxx_setl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+			      STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
+		stmp3xxx_setl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
 	} else {
-		stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
-			      BM_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		stmp3xxx_clearl(BM_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		stmp3xxx_clearl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+			      STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
+		stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
 	}
 	return 0;
 }
@@ -119,7 +137,7 @@ static int stmp3xxx_rtc_read_alarm(struc
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(__raw_readl(rtc_data->io + HW_RTC_ALARM), &alm->time);
+	rtc_time_to_tm(__raw_readl(rtc_data->io + STMP3XXX_RTC_ALARM), &alm->time);
 	return 0;
 }
 
@@ -129,7 +147,7 @@ static int stmp3xxx_rtc_set_alarm(struct
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(&alm->time, &t);
-	__raw_writel(t, rtc_data->io + HW_RTC_ALARM);
+	__raw_writel(t, rtc_data->io + STMP3XXX_RTC_ALARM);
 	return 0;
 }
 
@@ -149,8 +167,8 @@ static int stmp3xxx_rtc_remove(struct pl
 	if (!rtc_data)
 		return 0;
 
-	stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN | BM_RTC_CTRL_ALARM_IRQ_EN,
-			rtc_data->io + HW_RTC_CTRL);
+	stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + STMP3XXX_RTC_CTRL);
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
 	free_irq(rtc_data->irq_1msec, &pdev->dev);
 	rtc_device_unregister(rtc_data->rtc);
@@ -187,18 +205,18 @@ static int stmp3xxx_rtc_probe(struct pla
 	rtc_data->irq_alarm = platform_get_irq(pdev, 0);
 	rtc_data->irq_1msec = platform_get_irq(pdev, 1);
 
-	if (!(__raw_readl(HW_RTC_STAT + rtc_data->io) &
-			BM_RTC_STAT_RTC_PRESENT)) {
+	if (!(__raw_readl(STMP3XXX_RTC_STAT + rtc_data->io) &
+			STMP3XXX_RTC_STAT_RTC_PRESENT)) {
 		dev_err(&pdev->dev, "no device onboard\n");
 		err = -ENODEV;
 		goto out_remap;
 	}
 
 	stmp3xxx_reset_block(rtc_data->io, true);
-	stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE,
-			rtc_data->io + HW_RTC_PERSISTENT0);
+	stmp3xxx_clearl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
+			rtc_data->io + STMP3XXX_RTC_PERSISTENT0);
 	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_data->rtc)) {
@@ -229,8 +247,8 @@ static int stmp3xxx_rtc_probe(struct pla
 out_irq1:
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
 out_irq_alarm:
-	stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN | BM_RTC_CTRL_ALARM_IRQ_EN,
-			rtc_data->io + HW_RTC_CTRL);
+	stmp3xxx_clearl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + STMP3XXX_RTC_CTRL);
 	rtc_device_unregister(rtc_data->rtc);
 out_remap:
 	iounmap(rtc_data->io);
@@ -250,10 +268,10 @@ static int stmp3xxx_rtc_resume(struct pl
 	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
 
 	stmp3xxx_reset_block(rtc_data->io, true);
-	stmp3xxx_clearl(BM_RTC_PERSISTENT0_ALARM_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE_EN |
-			BM_RTC_PERSISTENT0_ALARM_WAKE,
-			rtc_data->io + HW_RTC_PERSISTENT0);
+	stmp3xxx_clearl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
+			rtc_data->io + STMP3XXX_RTC_PERSISTENT0);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
rtc-driver-for-pt7c4338-chip.patch
drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents.patch
drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device.patch
drivers-rtc-rtc-stmp3xxxc-get-rid-of-mach-specific-accessors.patch
drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers.patch

