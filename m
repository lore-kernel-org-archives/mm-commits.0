From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-rtc-rtc-stmp3xxxc-get-rid-of-mach-specific-accessors.patch removed from -mm tree
Date: Fri, 03 Jun 2011 16:08:46 -0700
Message-ID: <201106032308.p53N8klY013288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab1FCXJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, a.zummo@towertech.it, johnstul@us.ibm.com, shawn.guo@freescale.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-stmp3xxx.c: get rid of mach-specific accessors
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-stmp3xxxc-get-rid-of-mach-specific-accessors.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-stmp3xxx.c: get rid of mach-specific accessors
From: Wolfram Sang <w.sang@pengutronix.de>

Replace the accessors with standard readl/writel to remove their
platform-dependency.  Also, drop __raw_(read|write)l-accessors while we
are here.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Tested-by: Shawn Guo <shawn.guo@freescale.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |   62 +++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 28 deletions(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-get-rid-of-mach-specific-accessors drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-get-rid-of-mach-specific-accessors
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -18,6 +18,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
@@ -25,9 +26,10 @@
 #include <linux/slab.h>
 
 #include <mach/common.h>
-#include <mach/mxs.h>
 
 #define STMP3XXX_RTC_CTRL		0x0
+#define STMP3XXX_RTC_CTRL_SET		0x4
+#define STMP3XXX_RTC_CTRL_CLR		0x8
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ_EN		0x00000001
 #define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN	0x00000002
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ		0x00000004
@@ -42,6 +44,8 @@
 #define STMP3XXX_RTC_ALARM		0x40
 
 #define STMP3XXX_RTC_PERSISTENT0	0x60
+#define STMP3XXX_RTC_PERSISTENT0_SET	0x64
+#define STMP3XXX_RTC_PERSISTENT0_CLR	0x68
 #define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN	0x00000002
 #define STMP3XXX_RTC_PERSISTENT0_ALARM_EN	0x00000004
 #define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE	0x00000080
@@ -60,7 +64,7 @@ static void stmp3xxx_wait_time(struct st
 	 * NEW_REGS/STALE_REGS bitfields go. In fact it's 0x1=P0,
 	 * 0x2=P1, .., 0x20=P5, 0x40=ALARM, 0x80=SECONDS
 	 */
-	while (__raw_readl(rtc_data->io + STMP3XXX_RTC_STAT) &
+	while (readl(rtc_data->io + STMP3XXX_RTC_STAT) &
 			(0x80 << STMP3XXX_RTC_STAT_STALE_SHIFT))
 		cpu_relax();
 }
@@ -71,7 +75,7 @@ static int stmp3xxx_rtc_gettime(struct d
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	stmp3xxx_wait_time(rtc_data);
-	rtc_time_to_tm(__raw_readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
+	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
 	return 0;
 }
 
@@ -79,7 +83,7 @@ static int stmp3xxx_rtc_set_mmss(struct 
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	__raw_writel(t, rtc_data->io + STMP3XXX_RTC_SECONDS);
+	writel(t, rtc_data->io + STMP3XXX_RTC_SECONDS);
 	stmp3xxx_wait_time(rtc_data);
 	return 0;
 }
@@ -91,18 +95,18 @@ static irqreturn_t stmp3xxx_rtc_interrup
 	u32 status;
 	u32 events = 0;
 
-	status = __raw_readl(rtc_data->io + STMP3XXX_RTC_CTRL) &
+	status = readl(rtc_data->io + STMP3XXX_RTC_CTRL) &
 			(STMP3XXX_RTC_CTRL_ALARM_IRQ | STMP3XXX_RTC_CTRL_ONEMSEC_IRQ);
 
 	if (status & STMP3XXX_RTC_CTRL_ALARM_IRQ) {
-		__mxs_clrl(STMP3XXX_RTC_CTRL_ALARM_IRQ,
-				rtc_data->io + STMP3XXX_RTC_CTRL);
+		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ,
+				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 		events |= RTC_AF | RTC_IRQF;
 	}
 
 	if (status & STMP3XXX_RTC_CTRL_ONEMSEC_IRQ) {
-		__mxs_clrl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ,
-				rtc_data->io + STMP3XXX_RTC_CTRL);
+		writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ,
+				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 		if (++rtc_data->irq_count % 1000 == 0) {
 			events |= RTC_UF | RTC_IRQF;
 			rtc_data->irq_count = 0;
@@ -118,17 +122,19 @@ static irqreturn_t stmp3xxx_rtc_interrup
 static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
-	void __iomem *p = rtc_data->io + STMP3XXX_RTC_PERSISTENT0,
-		     *ctl = rtc_data->io + STMP3XXX_RTC_CTRL;
 
 	if (enabled) {
-		__mxs_setl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
-			      STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		__mxs_setl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+				STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN,
+				rtc_data->io + STMP3XXX_RTC_PERSISTENT0_SET);
+		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+				rtc_data->io + STMP3XXX_RTC_CTRL_SET);
 	} else {
-		__mxs_clrl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
-			      STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN, p);
-		__mxs_clrl(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN, ctl);
+		writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+				STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN,
+				rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
+		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 	}
 	return 0;
 }
@@ -137,7 +143,7 @@ static int stmp3xxx_rtc_read_alarm(struc
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(__raw_readl(rtc_data->io + STMP3XXX_RTC_ALARM), &alm->time);
+	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_ALARM), &alm->time);
 	return 0;
 }
 
@@ -147,7 +153,7 @@ static int stmp3xxx_rtc_set_alarm(struct
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	rtc_tm_to_time(&alm->time, &t);
-	__raw_writel(t, rtc_data->io + STMP3XXX_RTC_ALARM);
+	writel(t, rtc_data->io + STMP3XXX_RTC_ALARM);
 	return 0;
 }
 
@@ -167,8 +173,8 @@ static int stmp3xxx_rtc_remove(struct pl
 	if (!rtc_data)
 		return 0;
 
-	__mxs_clrl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
-			rtc_data->io + STMP3XXX_RTC_CTRL);
+	writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
 	free_irq(rtc_data->irq_1msec, &pdev->dev);
 	rtc_device_unregister(rtc_data->rtc);
@@ -206,7 +212,7 @@ static int stmp3xxx_rtc_probe(struct pla
 	rtc_data->irq_alarm = platform_get_irq(pdev, 0);
 	rtc_data->irq_1msec = platform_get_irq(pdev, 1);
 
-	if (!(__raw_readl(STMP3XXX_RTC_STAT + rtc_data->io) &
+	if (!(readl(STMP3XXX_RTC_STAT + rtc_data->io) &
 			STMP3XXX_RTC_STAT_RTC_PRESENT)) {
 		dev_err(&pdev->dev, "no device onboard\n");
 		err = -ENODEV;
@@ -216,10 +222,10 @@ static int stmp3xxx_rtc_probe(struct pla
 	platform_set_drvdata(pdev, rtc_data);
 
 	mxs_reset_block(rtc_data->io);
-	__mxs_clrl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
-			rtc_data->io + STMP3XXX_RTC_PERSISTENT0);
+			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
 
 	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
@@ -249,8 +255,8 @@ static int stmp3xxx_rtc_probe(struct pla
 out_irq1:
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
 out_irq_alarm:
-	__mxs_clrl(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
-			rtc_data->io + STMP3XXX_RTC_CTRL);
+	writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 	rtc_device_unregister(rtc_data->rtc);
 out_remap:
 	platform_set_drvdata(pdev, NULL);
@@ -271,10 +277,10 @@ static int stmp3xxx_rtc_resume(struct pl
 	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
 
 	mxs_reset_block(rtc_data->io);
-	__mxs_clrl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
-			rtc_data->io + STMP3XXX_RTC_PERSISTENT0);
+			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
rtc-driver-for-pt7c4338-chip.patch
drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers.patch

