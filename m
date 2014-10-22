From: akpm@linux-foundation.org
Subject: + rtc-omap-add-device-abstraction.patch added to -mm tree
Date: Wed, 22 Oct 2014 12:04:34 -0700
Message-ID: <5447ffc2.DOa0R/RU8Wrd1HMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaJVTEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add device abstraction
has been added to the -mm tree.  Its filename is
     rtc-omap-add-device-abstraction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-add-device-abstraction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-add-device-abstraction.patch

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
Subject: rtc: omap: add device abstraction

Add struct omap_rtc to hold previously global data as well as the
IP-block feature flags.

Also convert the register-access macros to proper inline helper functions.

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

 drivers/rtc/rtc-omap.c |  241 +++++++++++++++++++++------------------
 1 file changed, 134 insertions(+), 107 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-device-abstraction drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-device-abstraction
+++ a/drivers/rtc/rtc-omap.c
@@ -118,26 +118,42 @@
  */
 #define OMAP_RTC_HAS_32KCLK_EN		BIT(2)
 
-static void __iomem	*rtc_base;
+struct omap_rtc {
+	struct rtc_device *rtc;
+	void __iomem *base;
+	int irq_alarm;
+	int irq_timer;
+	u8 interrupts_reg;
+	unsigned long flags;
+};
 
-#define rtc_read(addr)		readb(rtc_base + (addr))
-#define rtc_write(val, addr)	writeb(val, rtc_base + (addr))
+static inline u8 rtc_read(struct omap_rtc *rtc, unsigned int reg)
+{
+	return readb(rtc->base + reg);
+}
 
-#define rtc_writel(val, addr)	writel(val, rtc_base + (addr))
+static inline void rtc_write(struct omap_rtc *rtc, unsigned int reg, u8 val)
+{
+	writeb(val, rtc->base + reg);
+}
 
+static inline void rtc_writel(struct omap_rtc *rtc, unsigned int reg, u32 val)
+{
+	writel(val, rtc->base + reg);
+}
 
 /* we rely on the rtc framework to handle locking (rtc->ops_lock),
  * so the only other requirement is that register accesses which
  * require BUSY to be clear are made with IRQs locally disabled
  */
-static void rtc_wait_not_busy(void)
+static void rtc_wait_not_busy(struct omap_rtc *rtc)
 {
 	int	count = 0;
 	u8	status;
 
 	/* BUSY may stay active for 1/32768 second (~30 usec) */
 	for (count = 0; count < 50; count++) {
-		status = rtc_read(OMAP_RTC_STATUS_REG);
+		status = rtc_read(rtc, OMAP_RTC_STATUS_REG);
 		if ((status & (u8)OMAP_RTC_STATUS_BUSY) == 0)
 			break;
 		udelay(1);
@@ -145,16 +161,17 @@ static void rtc_wait_not_busy(void)
 	/* now we have ~15 usec to read/write various registers */
 }
 
-static irqreturn_t rtc_irq(int irq, void *rtc)
+static irqreturn_t rtc_irq(int irq, void *dev_id)
 {
+	struct omap_rtc		*rtc = dev_id;
 	unsigned long		events = 0;
 	u8			irq_data;
 
-	irq_data = rtc_read(OMAP_RTC_STATUS_REG);
+	irq_data = rtc_read(rtc, OMAP_RTC_STATUS_REG);
 
 	/* alarm irq? */
 	if (irq_data & OMAP_RTC_STATUS_ALARM) {
-		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
+		rtc_write(rtc, OMAP_RTC_STATUS_REG, OMAP_RTC_STATUS_ALARM);
 		events |= RTC_IRQF | RTC_AF;
 	}
 
@@ -162,23 +179,21 @@ static irqreturn_t rtc_irq(int irq, void
 	if (irq_data & OMAP_RTC_STATUS_1S_EVENT)
 		events |= RTC_IRQF | RTC_UF;
 
-	rtc_update_irq(rtc, 1, events);
+	rtc_update_irq(rtc->rtc, 1, events);
 
 	return IRQ_HANDLED;
 }
 
 static int omap_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
 	u8 reg, irqwake_reg = 0;
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct platform_device_id *id_entry =
-					platform_get_device_id(pdev);
 
 	local_irq_disable();
-	rtc_wait_not_busy();
-	reg = rtc_read(OMAP_RTC_INTERRUPTS_REG);
-	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
-		irqwake_reg = rtc_read(OMAP_RTC_IRQWAKEEN);
+	rtc_wait_not_busy(rtc);
+	reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
+	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+		irqwake_reg = rtc_read(rtc, OMAP_RTC_IRQWAKEEN);
 
 	if (enabled) {
 		reg |= OMAP_RTC_INTERRUPTS_IT_ALARM;
@@ -187,10 +202,10 @@ static int omap_rtc_alarm_irq_enable(str
 		reg &= ~OMAP_RTC_INTERRUPTS_IT_ALARM;
 		irqwake_reg &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
 	}
-	rtc_wait_not_busy();
-	rtc_write(reg, OMAP_RTC_INTERRUPTS_REG);
-	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
-		rtc_write(irqwake_reg, OMAP_RTC_IRQWAKEEN);
+	rtc_wait_not_busy(rtc);
+	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, reg);
+	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+		rtc_write(rtc, OMAP_RTC_IRQWAKEEN, irqwake_reg);
 	local_irq_enable();
 
 	return 0;
@@ -231,16 +246,18 @@ static void bcd2tm(struct rtc_time *tm)
 
 static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
+
 	/* we don't report wday/yday/isdst ... */
 	local_irq_disable();
-	rtc_wait_not_busy();
+	rtc_wait_not_busy(rtc);
 
-	tm->tm_sec = rtc_read(OMAP_RTC_SECONDS_REG);
-	tm->tm_min = rtc_read(OMAP_RTC_MINUTES_REG);
-	tm->tm_hour = rtc_read(OMAP_RTC_HOURS_REG);
-	tm->tm_mday = rtc_read(OMAP_RTC_DAYS_REG);
-	tm->tm_mon = rtc_read(OMAP_RTC_MONTHS_REG);
-	tm->tm_year = rtc_read(OMAP_RTC_YEARS_REG);
+	tm->tm_sec = rtc_read(rtc, OMAP_RTC_SECONDS_REG);
+	tm->tm_min = rtc_read(rtc, OMAP_RTC_MINUTES_REG);
+	tm->tm_hour = rtc_read(rtc, OMAP_RTC_HOURS_REG);
+	tm->tm_mday = rtc_read(rtc, OMAP_RTC_DAYS_REG);
+	tm->tm_mon = rtc_read(rtc, OMAP_RTC_MONTHS_REG);
+	tm->tm_year = rtc_read(rtc, OMAP_RTC_YEARS_REG);
 
 	local_irq_enable();
 
@@ -250,17 +267,19 @@ static int omap_rtc_read_time(struct dev
 
 static int omap_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
+
 	if (tm2bcd(tm) < 0)
 		return -EINVAL;
 	local_irq_disable();
-	rtc_wait_not_busy();
+	rtc_wait_not_busy(rtc);
 
-	rtc_write(tm->tm_year, OMAP_RTC_YEARS_REG);
-	rtc_write(tm->tm_mon, OMAP_RTC_MONTHS_REG);
-	rtc_write(tm->tm_mday, OMAP_RTC_DAYS_REG);
-	rtc_write(tm->tm_hour, OMAP_RTC_HOURS_REG);
-	rtc_write(tm->tm_min, OMAP_RTC_MINUTES_REG);
-	rtc_write(tm->tm_sec, OMAP_RTC_SECONDS_REG);
+	rtc_write(rtc, OMAP_RTC_YEARS_REG, tm->tm_year);
+	rtc_write(rtc, OMAP_RTC_MONTHS_REG, tm->tm_mon);
+	rtc_write(rtc, OMAP_RTC_DAYS_REG, tm->tm_mday);
+	rtc_write(rtc, OMAP_RTC_HOURS_REG, tm->tm_hour);
+	rtc_write(rtc, OMAP_RTC_MINUTES_REG, tm->tm_min);
+	rtc_write(rtc, OMAP_RTC_SECONDS_REG, tm->tm_sec);
 
 	local_irq_enable();
 
@@ -269,20 +288,22 @@ static int omap_rtc_set_time(struct devi
 
 static int omap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
+
 	local_irq_disable();
-	rtc_wait_not_busy();
+	rtc_wait_not_busy(rtc);
 
-	alm->time.tm_sec = rtc_read(OMAP_RTC_ALARM_SECONDS_REG);
-	alm->time.tm_min = rtc_read(OMAP_RTC_ALARM_MINUTES_REG);
-	alm->time.tm_hour = rtc_read(OMAP_RTC_ALARM_HOURS_REG);
-	alm->time.tm_mday = rtc_read(OMAP_RTC_ALARM_DAYS_REG);
-	alm->time.tm_mon = rtc_read(OMAP_RTC_ALARM_MONTHS_REG);
-	alm->time.tm_year = rtc_read(OMAP_RTC_ALARM_YEARS_REG);
+	alm->time.tm_sec = rtc_read(rtc, OMAP_RTC_ALARM_SECONDS_REG);
+	alm->time.tm_min = rtc_read(rtc, OMAP_RTC_ALARM_MINUTES_REG);
+	alm->time.tm_hour = rtc_read(rtc, OMAP_RTC_ALARM_HOURS_REG);
+	alm->time.tm_mday = rtc_read(rtc, OMAP_RTC_ALARM_DAYS_REG);
+	alm->time.tm_mon = rtc_read(rtc, OMAP_RTC_ALARM_MONTHS_REG);
+	alm->time.tm_year = rtc_read(rtc, OMAP_RTC_ALARM_YEARS_REG);
 
 	local_irq_enable();
 
 	bcd2tm(&alm->time);
-	alm->enabled = !!(rtc_read(OMAP_RTC_INTERRUPTS_REG)
+	alm->enabled = !!(rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG)
 			& OMAP_RTC_INTERRUPTS_IT_ALARM);
 
 	return 0;
@@ -290,27 +311,25 @@ static int omap_rtc_read_alarm(struct de
 
 static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
 	u8 reg, irqwake_reg = 0;
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct platform_device_id *id_entry =
-					platform_get_device_id(pdev);
 
 	if (tm2bcd(&alm->time) < 0)
 		return -EINVAL;
 
 	local_irq_disable();
-	rtc_wait_not_busy();
+	rtc_wait_not_busy(rtc);
 
-	rtc_write(alm->time.tm_year, OMAP_RTC_ALARM_YEARS_REG);
-	rtc_write(alm->time.tm_mon, OMAP_RTC_ALARM_MONTHS_REG);
-	rtc_write(alm->time.tm_mday, OMAP_RTC_ALARM_DAYS_REG);
-	rtc_write(alm->time.tm_hour, OMAP_RTC_ALARM_HOURS_REG);
-	rtc_write(alm->time.tm_min, OMAP_RTC_ALARM_MINUTES_REG);
-	rtc_write(alm->time.tm_sec, OMAP_RTC_ALARM_SECONDS_REG);
-
-	reg = rtc_read(OMAP_RTC_INTERRUPTS_REG);
-	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
-		irqwake_reg = rtc_read(OMAP_RTC_IRQWAKEEN);
+	rtc_write(rtc, OMAP_RTC_ALARM_YEARS_REG, alm->time.tm_year);
+	rtc_write(rtc, OMAP_RTC_ALARM_MONTHS_REG, alm->time.tm_mon);
+	rtc_write(rtc, OMAP_RTC_ALARM_DAYS_REG, alm->time.tm_mday);
+	rtc_write(rtc, OMAP_RTC_ALARM_HOURS_REG, alm->time.tm_hour);
+	rtc_write(rtc, OMAP_RTC_ALARM_MINUTES_REG, alm->time.tm_min);
+	rtc_write(rtc, OMAP_RTC_ALARM_SECONDS_REG, alm->time.tm_sec);
+
+	reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
+	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+		irqwake_reg = rtc_read(rtc, OMAP_RTC_IRQWAKEEN);
 
 	if (alm->enabled) {
 		reg |= OMAP_RTC_INTERRUPTS_IT_ALARM;
@@ -319,9 +338,9 @@ static int omap_rtc_set_alarm(struct dev
 		reg &= ~OMAP_RTC_INTERRUPTS_IT_ALARM;
 		irqwake_reg &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
 	}
-	rtc_write(reg, OMAP_RTC_INTERRUPTS_REG);
-	if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN)
-		rtc_write(irqwake_reg, OMAP_RTC_IRQWAKEEN);
+	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, reg);
+	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+		rtc_write(rtc, OMAP_RTC_IRQWAKEEN, irqwake_reg);
 
 	local_irq_enable();
 
@@ -336,9 +355,6 @@ static struct rtc_class_ops omap_rtc_ops
 	.alarm_irq_enable = omap_rtc_alarm_irq_enable,
 };
 
-static int omap_rtc_alarm;
-static int omap_rtc_timer;
-
 #define	OMAP_RTC_DATA_AM3352_IDX	1
 #define	OMAP_RTC_DATA_DA830_IDX		2
 
@@ -372,13 +388,17 @@ MODULE_DEVICE_TABLE(of, omap_rtc_of_matc
 
 static int __init omap_rtc_probe(struct platform_device *pdev)
 {
+	struct omap_rtc		*rtc;
 	struct resource		*res;
-	struct rtc_device	*rtc;
 	u8			reg, new_ctrl;
 	const struct platform_device_id *id_entry;
 	const struct of_device_id *of_id;
 	int ret;
 
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
 	if (of_id)
 		pdev->id_entry = of_id->data;
@@ -389,26 +409,30 @@ static int __init omap_rtc_probe(struct
 		return -ENODEV;
 	}
 
-	omap_rtc_timer = platform_get_irq(pdev, 0);
-	if (omap_rtc_timer <= 0)
+	rtc->flags = id_entry->driver_data;
+
+	rtc->irq_timer = platform_get_irq(pdev, 0);
+	if (rtc->irq_timer <= 0)
 		return -ENOENT;
 
-	omap_rtc_alarm = platform_get_irq(pdev, 1);
-	if (omap_rtc_alarm <= 0)
+	rtc->irq_alarm = platform_get_irq(pdev, 1);
+	if (rtc->irq_alarm <= 0)
 		return -ENOENT;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	rtc_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(rtc_base))
-		return PTR_ERR(rtc_base);
+	rtc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtc->base))
+		return PTR_ERR(rtc->base);
+
+	platform_set_drvdata(pdev, rtc);
 
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER) {
-		rtc_writel(KICK0_VALUE, OMAP_RTC_KICK0_REG);
-		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
+	if (rtc->flags & OMAP_RTC_HAS_KICKER) {
+		rtc_writel(rtc, OMAP_RTC_KICK0_REG, KICK0_VALUE);
+		rtc_writel(rtc, OMAP_RTC_KICK1_REG, KICK1_VALUE);
 	}
 
 	/*
@@ -416,25 +440,26 @@ static int __init omap_rtc_probe(struct
 	 *
 	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is used
 	 */
-	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);
+	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 
 	/* enable RTC functional clock */
-	if (id_entry->driver_data & OMAP_RTC_HAS_32KCLK_EN) {
-		reg = rtc_read(OMAP_RTC_OSC_REG);
-		rtc_writel(reg | OMAP_RTC_OSC_32KCLK_EN, OMAP_RTC_OSC_REG);
+	if (rtc->flags & OMAP_RTC_HAS_32KCLK_EN) {
+		reg = rtc_read(rtc, OMAP_RTC_OSC_REG);
+		rtc_writel(rtc, OMAP_RTC_OSC_REG,
+				reg | OMAP_RTC_OSC_32KCLK_EN);
 	}
 
 	/* clear old status */
-	reg = rtc_read(OMAP_RTC_STATUS_REG);
+	reg = rtc_read(rtc, OMAP_RTC_STATUS_REG);
 	if (reg & (u8) OMAP_RTC_STATUS_POWER_UP) {
 		dev_info(&pdev->dev, "RTC power up reset detected\n");
-		rtc_write(OMAP_RTC_STATUS_POWER_UP, OMAP_RTC_STATUS_REG);
+		rtc_write(rtc, OMAP_RTC_STATUS_REG, OMAP_RTC_STATUS_POWER_UP);
 	}
 	if (reg & (u8) OMAP_RTC_STATUS_ALARM)
-		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
+		rtc_write(rtc, OMAP_RTC_STATUS_REG, OMAP_RTC_STATUS_ALARM);
 
 	/* On boards with split power, RTC_ON_NOFF won't reset the RTC */
-	reg = rtc_read(OMAP_RTC_CTRL_REG);
+	reg = rtc_read(rtc, OMAP_RTC_CTRL_REG);
 	if (reg & (u8) OMAP_RTC_CTRL_STOP)
 		dev_info(&pdev->dev, "already running\n");
 
@@ -460,27 +485,26 @@ static int __init omap_rtc_probe(struct
 		dev_info(&pdev->dev, "split power mode\n");
 
 	if (reg != new_ctrl)
-		rtc_write(new_ctrl, OMAP_RTC_CTRL_REG);
+		rtc_write(rtc, OMAP_RTC_CTRL_REG, new_ctrl);
 
 	device_init_wakeup(&pdev->dev, true);
 
-	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 			&omap_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
+	if (IS_ERR(rtc->rtc)) {
+		ret = PTR_ERR(rtc->rtc);
 		goto err;
 	}
-	platform_set_drvdata(pdev, rtc);
 
 	/* handle periodic and alarm irqs */
-	ret = devm_request_irq(&pdev->dev, omap_rtc_timer, rtc_irq, 0,
-			dev_name(&rtc->dev), rtc);
+	ret = devm_request_irq(&pdev->dev, rtc->irq_timer, rtc_irq, 0,
+			dev_name(&rtc->rtc->dev), rtc);
 	if (ret)
 		goto err;
 
-	if (omap_rtc_timer != omap_rtc_alarm) {
-		ret = devm_request_irq(&pdev->dev, omap_rtc_alarm, rtc_irq, 0,
-				dev_name(&rtc->dev), rtc);
+	if (rtc->irq_timer != rtc->irq_alarm) {
+		ret = devm_request_irq(&pdev->dev, rtc->irq_alarm, rtc_irq, 0,
+				dev_name(&rtc->rtc->dev), rtc);
 		if (ret)
 			goto err;
 	}
@@ -489,8 +513,8 @@ static int __init omap_rtc_probe(struct
 
 err:
 	device_init_wakeup(&pdev->dev, false);
-	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
-		rtc_writel(0, OMAP_RTC_KICK0_REG);
+	if (rtc->flags & OMAP_RTC_HAS_KICKER)
+		rtc_writel(rtc, OMAP_RTC_KICK0_REG, 0);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -499,16 +523,15 @@ err:
 
 static int __exit omap_rtc_remove(struct platform_device *pdev)
 {
-	const struct platform_device_id *id_entry =
-				platform_get_device_id(pdev);
+	struct omap_rtc *rtc = platform_get_drvdata(pdev);
 
 	device_init_wakeup(&pdev->dev, 0);
 
 	/* leave rtc running, but disable irqs */
-	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 
-	if (id_entry->driver_data & OMAP_RTC_HAS_KICKER)
-		rtc_writel(0, OMAP_RTC_KICK0_REG);
+	if (rtc->flags & OMAP_RTC_HAS_KICKER)
+		rtc_writel(rtc, OMAP_RTC_KICK0_REG, 0);
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(&pdev->dev);
@@ -518,20 +541,20 @@ static int __exit omap_rtc_remove(struct
 }
 
 #ifdef CONFIG_PM_SLEEP
-static u8 irqstat;
-
 static int omap_rtc_suspend(struct device *dev)
 {
-	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
+
+	rtc->interrupts_reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
 
 	/* FIXME the RTC alarm is not currently acting as a wakeup event
 	 * source on some platforms, and in fact this enable() call is just
 	 * saving a flag that's never used...
 	 */
 	if (device_may_wakeup(dev))
-		enable_irq_wake(omap_rtc_alarm);
+		enable_irq_wake(rtc->irq_alarm);
 	else
-		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+		rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(dev);
@@ -541,13 +564,15 @@ static int omap_rtc_suspend(struct devic
 
 static int omap_rtc_resume(struct device *dev)
 {
+	struct omap_rtc *rtc = dev_get_drvdata(dev);
+
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_get_sync(dev);
 
 	if (device_may_wakeup(dev))
-		disable_irq_wake(omap_rtc_alarm);
+		disable_irq_wake(rtc->irq_alarm);
 	else
-		rtc_write(irqstat, OMAP_RTC_INTERRUPTS_REG);
+		rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, rtc->interrupts_reg);
 
 	return 0;
 }
@@ -557,7 +582,9 @@ static SIMPLE_DEV_PM_OPS(omap_rtc_pm_ops
 
 static void omap_rtc_shutdown(struct platform_device *pdev)
 {
-	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	struct omap_rtc *rtc = platform_get_drvdata(pdev);
+
+	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 }
 
 MODULE_ALIAS("platform:omap_rtc");
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

