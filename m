From: akpm@linux-foundation.org
Subject: + rtc-omap-fix-minor-coding-style-issues.patch added to -mm tree
Date: Wed, 22 Oct 2014 12:04:45 -0700
Message-ID: <5447ffcd.UXENsn+1VrZswkit%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbaJVTEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: fix minor coding style issues
has been added to the -mm tree.  Its filename is
     rtc-omap-fix-minor-coding-style-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-fix-minor-coding-style-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-fix-minor-coding-style-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Felipe Balbi <balbi@ti.com>
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
@@ -472,9 +478,9 @@ MODULE_DEVICE_TABLE(of, omap_rtc_of_matc
 
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
@@ -551,14 +557,15 @@ static int __init omap_rtc_probe(struct
 
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
@@ -572,7 +579,7 @@ static int __init omap_rtc_probe(struct
 	 *    is write-only, and always reads as zero...)
 	 */
 
-	if (new_ctrl & (u8) OMAP_RTC_CTRL_SPLIT)
+	if (new_ctrl & OMAP_RTC_CTRL_SPLIT)
 		dev_info(&pdev->dev, "split power mode\n");
 
 	if (reg != new_ctrl)
@@ -651,7 +658,8 @@ static int omap_rtc_suspend(struct devic
 
 	rtc->interrupts_reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 
-	/* FIXME the RTC alarm is not currently acting as a wakeup event
+	/*
+	 * FIXME: the RTC alarm is not currently acting as a wakeup event
 	 * source on some platforms, and in fact this enable() call is just
 	 * saving a flag that's never used...
 	 */
_

Patches currently in -mm which might be from johan@kernel.org are

rtc-omap-fix-clock-source-configuration.patch
rtc-omap-fix-missing-wakealarm-attribute.patch
rtc-omap-fix-interrupt-disable-at-probe.patch
rtc-omap-clean-up-probe-error-handling.patch
rtc-omap-fix-class-device-registration.patch
rtc-omap-remove-unused-register-base-define.patch
rtc-omap-use-dev_info.patch
rtc-omap-make-platform-device-id-table-const.patch
rtc-omap-add-device-abstraction.patch
rtc-omap-remove-driver_name-macro.patch
rtc-omap-add-structured-device-type-info.patch
rtc-omap-silence-bogus-power-up-reset-message-at-probe.patch
rtc-omap-add-helper-to-read-raw-bcd-time.patch
rtc-omap-add-helper-to-read-32-bit-registers.patch
rtc-omap-add-support-for-pmic_power_en.patch
rtc-omap-enable-wake-up-from-power-off.patch
rtc-omap-fix-minor-coding-style-issues.patch
rtc-omap-add-copyright-entry.patch
arm-dts-am33xx-update-rtc-node-compatible-property.patch
arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch
linux-next.patch

