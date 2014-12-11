From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-fix-minor-coding-style-issues.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:54 -0800
Message-ID: <5489eb4e.2CpI3q9uBITqwndL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbaLKTGz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: fix minor coding style issues
has been removed from the -mm tree.  Its filename was
     rtc-omap-fix-minor-coding-style-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: fix minor coding style issues

Fix minor coding style issues like comment style, indentation and remove
a few unnecessary casts.

Also drop the 1 from OMAP1 in the driver description.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   46 ++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-fix-minor-coding-style-issues drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-fix-minor-coding-style-issues
+++ a/drivers/rtc/rtc-omap.c
@@ -1,5 +1,5 @@
 /*
- * TI OMAP1 Real Time Clock interface for Linux
+ * TI OMAP Real Time Clock interface for Linux
  *
  * Copyright (C) 2003 MontaVista Software, Inc.
  * Author: George G. Davis <gdavis@mvista.com> or <source@mvista.com>
@@ -25,7 +25,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/io.h>
 
-/* The OMAP1 RTC is a year/month/day/hours/minutes/seconds BCD clock
+/*
+ * The OMAP RTC is a year/month/day/hours/minutes/seconds BCD clock
  * with century-range alarm matching, driven by the 32kHz clock.
  *
  * The main user-visible ways it differs from PC RTCs are by omitting
@@ -154,19 +155,20 @@ static inline void rtc_writel(struct oma
 	writel(val, rtc->base + reg);
 }
 
-/* we rely on the rtc framework to handle locking (rtc->ops_lock),
+/*
+ * We rely on the rtc framework to handle locking (rtc->ops_lock),
  * so the only other requirement is that register accesses which
  * require BUSY to be clear are made with IRQs locally disabled
  */
 static void rtc_wait_not_busy(struct omap_rtc *rtc)
 {
-	int	count = 0;
-	u8	status;
+	int count;
+	u8 status;
 
 	/* BUSY may stay active for 1/32768 second (~30 usec) */
 	for (count = 0; count < 50; count++) {
 		status = rtc_read(rtc, OMAP_RTC_STATUS_REG);
-		if ((status & (u8)OMAP_RTC_STATUS_BUSY) == 0)
+		if (!(status & OMAP_RTC_STATUS_BUSY))
 			break;
 		udelay(1);
 	}
@@ -175,9 +177,9 @@ static void rtc_wait_not_busy(struct oma
 
 static irqreturn_t rtc_irq(int irq, void *dev_id)
 {
-	struct omap_rtc		*rtc = dev_id;
-	unsigned long		events = 0;
-	u8			irq_data;
+	struct omap_rtc	*rtc = dev_id;
+	unsigned long events = 0;
+	u8 irq_data;
 
 	irq_data = rtc_read(rtc, OMAP_RTC_STATUS_REG);
 
@@ -276,6 +278,7 @@ static int omap_rtc_read_time(struct dev
 	local_irq_enable();
 
 	bcd2tm(tm);
+
 	return 0;
 }
 
@@ -285,6 +288,7 @@ static int omap_rtc_set_time(struct devi
 
 	if (tm2bcd(tm) < 0)
 		return -EINVAL;
+
 	local_irq_disable();
 	rtc_wait_not_busy(rtc);
 
@@ -303,6 +307,7 @@ static int omap_rtc_set_time(struct devi
 static int omap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct omap_rtc *rtc = dev_get_drvdata(dev);
+	u8 interrupts;
 
 	local_irq_disable();
 	rtc_wait_not_busy(rtc);
@@ -317,8 +322,9 @@ static int omap_rtc_read_alarm(struct de
 	local_irq_enable();
 
 	bcd2tm(&alm->time);
-	alm->enabled = !!(rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG)
-			& OMAP_RTC_INTERRUPTS_IT_ALARM);
+
+	interrupts = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
+	alm->enabled = !!(interrupts & OMAP_RTC_INTERRUPTS_IT_ALARM);
 
 	return 0;
 }
@@ -479,9 +485,9 @@ MODULE_DEVICE_TABLE(of, omap_rtc_of_matc
 
 static int __init omap_rtc_probe(struct platform_device *pdev)
 {
-	struct omap_rtc		*rtc;
-	struct resource		*res;
-	u8			reg, mask, new_ctrl;
+	struct omap_rtc	*rtc;
+	struct resource	*res;
+	u8 reg, mask, new_ctrl;
 	const struct platform_device_id *id_entry;
 	const struct of_device_id *of_id;
 	int ret;
@@ -558,14 +564,15 @@ static int __init omap_rtc_probe(struct
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
 	reg = rtc_read(rtc, OMAP_RTC_CTRL_REG);
-	if (reg & (u8) OMAP_RTC_CTRL_STOP)
+	if (reg & OMAP_RTC_CTRL_STOP)
 		dev_info(&pdev->dev, "already running\n");
 
 	/* force to 24 hour mode */
-	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT|OMAP_RTC_CTRL_AUTO_COMP);
+	new_ctrl = reg & (OMAP_RTC_CTRL_SPLIT | OMAP_RTC_CTRL_AUTO_COMP);
 	new_ctrl |= OMAP_RTC_CTRL_STOP;
 
-	/* BOARD-SPECIFIC CUSTOMIZATION CAN GO HERE:
+	/*
+	 * BOARD-SPECIFIC CUSTOMIZATION CAN GO HERE:
 	 *
 	 *  - Device wake-up capability setting should come through chip
 	 *    init logic. OMAP1 boards should initialize the "wakeup capable"
@@ -579,7 +586,7 @@ static int __init omap_rtc_probe(struct
 	 *    is write-only, and always reads as zero...)
 	 */
 
-	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
+	if (new_ctrl & OMAP_RTC_CTRL_SPLIT)
 		dev_info(&pdev->dev, "split power mode\n");
 
 	if (reg != new_ctrl)
@@ -658,7 +665,8 @@ static int omap_rtc_suspend(struct devic
 
 	rtc->interrupts_reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 
-	/* FIXME the RTC alarm is not currently acting as a wakeup event
+	/*
+	 * FIXME: the RTC alarm is not currently acting as a wakeup event
 	 * source on some platforms, and in fact this enable() call is just
 	 * saving a flag that's never used...
 	 */
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

