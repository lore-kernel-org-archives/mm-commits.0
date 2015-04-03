From: akpm@linux-foundation.org
Subject: +
 rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes.patch added to -mm tree
Date: Fri, 03 Apr 2015 14:39:40 -0700
Message-ID: <551f089c.UYg95C+NFRPPyJ1c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbDCVjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 17:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lokeshvutla@ti.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, nsekhar@ti.com, paul@pwsan.com, t-kristo@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-omap.c: unlock and lock rtc registers before and after register writes
has been added to the -mm tree.  Its filename is
     rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes.patch

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
Subject: drivers/rtc/rtc-omap.c: unlock and lock rtc registers before and after register writes

RTC module contains a kicker mechanism to prevent any spurious writes from
changing the register values.  This mechanism requires two MMR writes to
the KICK0 and KICK1 registers with exact data values before the kicker
lock mechanism is released.

Currently the driver release the lock in the probe and leaves it enabled
until the rtc driver removal.  This eliminates the idea of preventing
spurious writes when RTC driver is loaded.  So implement rtc lock and
unlock functions before and after register writes.

This is as advised by Paul to implement lock and unlock functions in the
driver and not to unlock and leave it in probe.  The same discussion can
be seen here:
http://www.mail-archive.com/linux-omap%40vger.kernel.org/msg111588.html

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   63 ++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes
+++ a/drivers/rtc/rtc-omap.c
@@ -120,13 +120,16 @@
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
 
+struct omap_rtc;
+
 struct omap_rtc_device_type {
 	bool has_32kclk_en;
 	bool has_osc_ext_32k;
-	bool has_kicker;
 	bool has_irqwakeen;
 	bool has_pmic_mode;
 	bool has_power_up_reset;
+	void (*lock)(struct omap_rtc *rtc);
+	void (*unlock)(struct omap_rtc *rtc);
 };
 
 struct omap_rtc {
@@ -159,6 +162,26 @@ static inline void rtc_writel(struct oma
 	writel(val, rtc->base + reg);
 }
 
+static void am3352_rtc_unlock(struct omap_rtc *rtc)
+{
+	rtc_writel(rtc, OMAP_RTC_KICK0_REG, KICK0_VALUE);
+	rtc_writel(rtc, OMAP_RTC_KICK1_REG, KICK1_VALUE);
+}
+
+static void am3352_rtc_lock(struct omap_rtc *rtc)
+{
+	rtc_writel(rtc, OMAP_RTC_KICK0_REG, 0);
+	rtc_writel(rtc, OMAP_RTC_KICK1_REG, 0);
+}
+
+static void default_rtc_unlock(struct omap_rtc *rtc)
+{
+}
+
+static void default_rtc_lock(struct omap_rtc *rtc)
+{
+}
+
 /*
  * We rely on the rtc framework to handle locking (rtc->ops_lock),
  * so the only other requirement is that register accesses which
@@ -189,7 +212,9 @@ static irqreturn_t rtc_irq(int irq, void
 
 	/* alarm irq? */
 	if (irq_data & OMAP_RTC_STATUS_ALARM) {
+		rtc->type->unlock(rtc);
 		rtc_write(rtc, OMAP_RTC_STATUS_REG, OMAP_RTC_STATUS_ALARM);
+		rtc->type->lock(rtc);
 		events |= RTC_IRQF | RTC_AF;
 	}
 
@@ -221,9 +246,11 @@ static int omap_rtc_alarm_irq_enable(str
 		irqwake_reg &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
 	}
 	rtc_wait_not_busy(rtc);
+	rtc->type->unlock(rtc);
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, reg);
 	if (rtc->type->has_irqwakeen)
 		rtc_write(rtc, OMAP_RTC_IRQWAKEEN, irqwake_reg);
+	rtc->type->lock(rtc);
 	local_irq_enable();
 
 	return 0;
@@ -296,12 +323,14 @@ static int omap_rtc_set_time(struct devi
 	local_irq_disable();
 	rtc_wait_not_busy(rtc);
 
+	rtc->type->unlock(rtc);
 	rtc_write(rtc, OMAP_RTC_YEARS_REG, tm->tm_year);
 	rtc_write(rtc, OMAP_RTC_MONTHS_REG, tm->tm_mon);
 	rtc_write(rtc, OMAP_RTC_DAYS_REG, tm->tm_mday);
 	rtc_write(rtc, OMAP_RTC_HOURS_REG, tm->tm_hour);
 	rtc_write(rtc, OMAP_RTC_MINUTES_REG, tm->tm_min);
 	rtc_write(rtc, OMAP_RTC_SECONDS_REG, tm->tm_sec);
+	rtc->type->lock(rtc);
 
 	local_irq_enable();
 
@@ -344,6 +373,7 @@ static int omap_rtc_set_alarm(struct dev
 	local_irq_disable();
 	rtc_wait_not_busy(rtc);
 
+	rtc->type->unlock(rtc);
 	rtc_write(rtc, OMAP_RTC_ALARM_YEARS_REG, alm->time.tm_year);
 	rtc_write(rtc, OMAP_RTC_ALARM_MONTHS_REG, alm->time.tm_mon);
 	rtc_write(rtc, OMAP_RTC_ALARM_DAYS_REG, alm->time.tm_mday);
@@ -365,6 +395,7 @@ static int omap_rtc_set_alarm(struct dev
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, reg);
 	if (rtc->type->has_irqwakeen)
 		rtc_write(rtc, OMAP_RTC_IRQWAKEEN, irqwake_reg);
+	rtc->type->lock(rtc);
 
 	local_irq_enable();
 
@@ -394,6 +425,7 @@ static void omap_rtc_power_off(void)
 	unsigned long now;
 	u32 val;
 
+	rtc->type->unlock(rtc);
 	/* enable pmic_power_en control */
 	val = rtc_readl(rtc, OMAP_RTC_PMIC_REG);
 	rtc_writel(rtc, OMAP_RTC_PMIC_REG, val | OMAP_RTC_PMIC_POWER_EN_EN);
@@ -426,6 +458,7 @@ static void omap_rtc_power_off(void)
 	val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
 			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
+	rtc->type->lock(rtc);
 
 	/*
 	 * Wait for alarm to trigger (within two seconds) and external PMIC to
@@ -445,18 +478,22 @@ static struct rtc_class_ops omap_rtc_ops
 
 static const struct omap_rtc_device_type omap_rtc_default_type = {
 	.has_power_up_reset = true,
+	.lock		= default_rtc_lock,
+	.unlock		= default_rtc_unlock,
 };
 
 static const struct omap_rtc_device_type omap_rtc_am3352_type = {
 	.has_32kclk_en	= true,
 	.has_osc_ext_32k = true,
-	.has_kicker	= true,
 	.has_irqwakeen	= true,
 	.has_pmic_mode	= true,
+	.lock		= am3352_rtc_lock,
+	.unlock		= am3352_rtc_unlock,
 };
 
 static const struct omap_rtc_device_type omap_rtc_da830_type = {
-	.has_kicker	= true,
+	.lock		= am3352_rtc_lock,
+	.unlock		= am3352_rtc_unlock,
 };
 
 static const struct platform_device_id omap_rtc_id_table[] = {
@@ -531,10 +568,7 @@ static int __init omap_rtc_probe(struct
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (rtc->type->has_kicker) {
-		rtc_writel(rtc, OMAP_RTC_KICK0_REG, KICK0_VALUE);
-		rtc_writel(rtc, OMAP_RTC_KICK1_REG, KICK1_VALUE);
-	}
+	rtc->type->unlock(rtc);
 
 	/*
 	 * disable interrupts
@@ -605,6 +639,8 @@ static int __init omap_rtc_probe(struct
 	if (reg != new_ctrl)
 		rtc_write(rtc, OMAP_RTC_CTRL_REG, new_ctrl);
 
+	rtc->type->lock(rtc);
+
 	device_init_wakeup(&pdev->dev, true);
 
 	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
@@ -638,8 +674,7 @@ static int __init omap_rtc_probe(struct
 
 err:
 	device_init_wakeup(&pdev->dev, false);
-	if (rtc->type->has_kicker)
-		rtc_writel(rtc, OMAP_RTC_KICK0_REG, 0);
+	rtc->type->lock(rtc);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -658,11 +693,11 @@ static int __exit omap_rtc_remove(struct
 
 	device_init_wakeup(&pdev->dev, 0);
 
+	rtc->type->unlock(rtc);
 	/* leave rtc running, but disable irqs */
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 
-	if (rtc->type->has_kicker)
-		rtc_writel(rtc, OMAP_RTC_KICK0_REG, 0);
+	rtc->type->lock(rtc);
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(&pdev->dev);
@@ -678,6 +713,7 @@ static int omap_rtc_suspend(struct devic
 
 	rtc->interrupts_reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 
+	rtc->type->unlock(rtc);
 	/*
 	 * FIXME: the RTC alarm is not currently acting as a wakeup event
 	 * source on some platforms, and in fact this enable() call is just
@@ -687,6 +723,7 @@ static int omap_rtc_suspend(struct devic
 		enable_irq_wake(rtc->irq_alarm);
 	else
 		rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
+	rtc->type->lock(rtc);
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(dev);
@@ -701,10 +738,12 @@ static int omap_rtc_resume(struct device
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_get_sync(dev);
 
+	rtc->type->unlock(rtc);
 	if (device_may_wakeup(dev))
 		disable_irq_wake(rtc->irq_alarm);
 	else
 		rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, rtc->interrupts_reg);
+	rtc->type->lock(rtc);
 
 	return 0;
 }
@@ -721,9 +760,11 @@ static void omap_rtc_shutdown(struct pla
 	 * Keep the ALARM interrupt enabled to allow the system to power up on
 	 * alarm events.
 	 */
+	rtc->type->unlock(rtc);
 	mask = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 	mask &= OMAP_RTC_INTERRUPTS_IT_ALARM;
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, mask);
+	rtc->type->lock(rtc);
 }
 
 static struct platform_driver omap_rtc_driver = {
_

Patches currently in -mm which might be from lokeshvutla@ti.com are

rtc-omap-unlock-and-lock-rtc-registers-before-and-after-register-writes.patch
rtc-omap-update-kconfig-for-omap-rtc.patch
rtc-omap-use-module_platform_driver.patch
linux-next.patch

