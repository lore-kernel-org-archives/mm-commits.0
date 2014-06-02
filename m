From: akpm@linux-foundation.org
Subject: + rtc-omap-enable-rtc_irqwakeen-bits-when-alarm-is-set.patch
 added to -mm tree
Date: Mon, 02 Jun 2014 15:02:40 -0700
Message-ID: <538cf480.wuMkIXILWEE40aMR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaFBWCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 18:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, robh+dt@kernel.org, nsekhar@ti.com, grant.likely@linaro.org, a.zummo@towertech.it, lokeshvutla@ti.com

Subject: + rtc-omap-enable-rtc_irqwakeen-bits-when-alarm-is-set.patch added to -mm tree
To: lokeshvutla@ti.com,a.zummo@towertech.it,grant.likely@linaro.org,nsekhar@ti.com,robh+dt@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 15:02:40 -0700


The patch titled
     Subject: drivers/rtc/rtc-omap.c: enable RTC_IRQWAKEEN bits when Alarm is set
has been added to the -mm tree.  Its filename is
     rtc-omap-enable-rtc_irqwakeen-bits-when-alarm-is-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-enable-rtc_irqwakeen-bits-when-alarm-is-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-enable-rtc_irqwakeen-bits-when-alarm-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: drivers/rtc/rtc-omap.c: enable RTC_IRQWAKEEN bits when Alarm is set

When RTC CLKTRCTRL bit is configured in HW_AUTO, module goes to sleep in
IDLE state.

The Alarm SWakeup event can be used to wakeup the RTC when it is in IDLE
state.  In order to do so, the alarm needs to be set and enabled before
RTC enters the IDLE state.  Also the wakeup generation for alarm/timer
event needs to be set (bits [1:0] in RTC_IRQWAKEEN register).

Currently RTC_IRQWAKEEN bits are set only in suspend/resume paths.  With
this ALARM interrupts are not generated when it enters IDLE state.  So
programming the RTC_IRQWAKEEN bits when ever ALARM is set.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   67 +++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-enable-rtc_irqwakeen-bits-when-alarm-is-set drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-enable-rtc_irqwakeen-bits-when-alarm-is-set
+++ a/drivers/rtc/rtc-omap.c
@@ -171,17 +171,28 @@ static irqreturn_t rtc_irq(int irq, void
 
 static int omap_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
-	u8 reg;
+	u8 reg, irqwake_reg = 0;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id_entry =
+					platform_get_device_id(pdev);
 
 	local_irq_disable();
 	rtc_wait_not_busy();
 	reg = rtc_read(OMAP_RTC_INTERRUPTS_REG);
-	if (enabled)
+	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
+		irqwake_reg = rtc_read(OMAP_RTC_IRQWAKEEN);
+
+	if (enabled) {
 		reg |= OMAP_RTC_INTERRUPTS_IT_ALARM;
-	else
+		irqwake_reg |= OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+	} else {
 		reg &= ~OMAP_RTC_INTERRUPTS_IT_ALARM;
+		irqwake_reg &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+	}
 	rtc_wait_not_busy();
 	rtc_write(reg, OMAP_RTC_INTERRUPTS_REG);
+	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
+		rtc_write(irqwake_reg, OMAP_RTC_IRQWAKEEN);
 	local_irq_enable();
 
 	return 0;
@@ -281,7 +292,10 @@ static int omap_rtc_read_alarm(struct de
 
 static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
-	u8 reg;
+	u8 reg, irqwake_reg = 0;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id_entry =
+					platform_get_device_id(pdev);
 
 	if (tm2bcd(&alm->time) < 0)
 		return -EINVAL;
@@ -297,11 +311,19 @@ static int omap_rtc_set_alarm(struct dev
 	rtc_write(alm->time.tm_sec, OMAP_RTC_ALARM_SECONDS_REG);
 
 	reg = rtc_read(OMAP_RTC_INTERRUPTS_REG);
-	if (alm->enabled)
+	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
+		irqwake_reg = rtc_read(OMAP_RTC_IRQWAKEEN);
+
+	if (alm->enabled) {
 		reg |= OMAP_RTC_INTERRUPTS_IT_ALARM;
-	else
+		irqwake_reg |= OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+	} else {
 		reg &= ~OMAP_RTC_INTERRUPTS_IT_ALARM;
+		irqwake_reg &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+	}
 	rtc_write(reg, OMAP_RTC_INTERRUPTS_REG);
+	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
+		rtc_write(irqwake_reg, OMAP_RTC_IRQWAKEEN);
 
 	local_irq_enable();
 
@@ -503,28 +525,16 @@ static u8 irqstat;
 
 static int omap_rtc_suspend(struct device *dev)
 {
-	u8 irqwake_stat;
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct platform_device_id *id_entry =
-					platform_get_device_id(pdev);
-
 	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 
 	/* FIXME the RTC alarm is not currently acting as a wakeup event
 	 * source on some platforms, and in fact this enable() call is just
 	 * saving a flag that's never used...
 	 */
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev))
 		enable_irq_wake(omap_rtc_alarm);
-
-		if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN) {
-			irqwake_stat = rtc_read(OMAP_RTC_IRQWAKEEN);
-			irqwake_stat |= OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
-			rtc_write(irqwake_stat, OMAP_RTC_IRQWAKEEN);
-		}
-	} else {
+	else
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
-	}
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(dev);
@@ -534,25 +544,14 @@ static int omap_rtc_suspend(struct devic
 
 static int omap_rtc_resume(struct device *dev)
 {
-	u8 irqwake_stat;
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(pdev);
-
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_get_sync(dev);
 
-	if (device_may_wakeup(dev)) {
+	if (device_may_wakeup(dev))
 		disable_irq_wake(omap_rtc_alarm);
