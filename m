From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-add-structured-device-type-info.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:36 -0800
Message-ID: <5489eb3c.6OEpkT3k4P8cTbDz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462AbaLKTGh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add structured device-type info
has been removed from the -mm tree.  Its filename was
     rtc-omap-add-structured-device-type-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: add structured device-type info

Add structured device-type info to encode IP-block revision differences.

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

 drivers/rtc/rtc-omap.c |  103 +++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 52 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-structured-device-type-info drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-structured-device-type-info
+++ a/drivers/rtc/rtc-omap.c
@@ -102,19 +102,11 @@
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
 
-#define	OMAP_RTC_HAS_KICKER		BIT(0)
-
-/*
- * Few RTC IP revisions has special WAKE-EN Register to enable Wakeup
- * generation for event Alarm.
- */
-#define	OMAP_RTC_HAS_IRQWAKEEN		BIT(1)
-
-/*
- * Some RTC IP revisions (like those in AM335x and DRA7x) need
- * the 32KHz clock to be explicitly enabled.
- */
-#define OMAP_RTC_HAS_32KCLK_EN		BIT(2)
+struct omap_rtc_device_type {
+	bool has_32kclk_en;
+	bool has_kicker;
+	bool has_irqwakeen;
+};
 
 struct omap_rtc {
 	struct rtc_device *rtc;
@@ -122,7 +114,7 @@ struct omap_rtc {
 	int irq_alarm;
 	int irq_timer;
 	u8 interrupts_reg;
-	unsigned long flags;
+	const struct omap_rtc_device_type *type;
 };
 
 static inline u8 rtc_read(struct omap_rtc *rtc, unsigned int reg)
@@ -190,7 +182,7 @@ static int omap_rtc_alarm_irq_enable(str
 	local_irq_disable();
 	rtc_wait_not_busy(rtc);
 	reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
-	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+	if (rtc->type->has_irqwakeen)
 		irqwake_reg = rtc_read(rtc, OMAP_RTC_IRQWAKEEN);
 
 	if (enabled) {
@@ -202,7 +194,7 @@ static int omap_rtc_alarm_irq_enable(str
 	}
 	rtc_wait_not_busy(rtc);
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, reg);
-	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+	if (rtc->type->has_irqwakeen)
 		rtc_write(rtc, OMAP_RTC_IRQWAKEEN, irqwake_reg);
 	local_irq_enable();
 
@@ -326,7 +318,7 @@ static int omap_rtc_set_alarm(struct dev
 	rtc_write(rtc, OMAP_RTC_ALARM_SECONDS_REG, alm->time.tm_sec);
 
 	reg = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
-	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+	if (rtc->type->has_irqwakeen)
 		irqwake_reg = rtc_read(rtc, OMAP_RTC_IRQWAKEEN);
 
 	if (alm->enabled) {
@@ -337,7 +329,7 @@ static int omap_rtc_set_alarm(struct dev
 		irqwake_reg &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
 	}
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, reg);
-	if (rtc->flags & OMAP_RTC_HAS_IRQWAKEEN)
+	if (rtc->type->has_irqwakeen)
 		rtc_write(rtc, OMAP_RTC_IRQWAKEEN, irqwake_reg);
 
 	local_irq_enable();
@@ -353,34 +345,45 @@ static struct rtc_class_ops omap_rtc_ops
 	.alarm_irq_enable = omap_rtc_alarm_irq_enable,
 };
 
-#define	OMAP_RTC_DATA_AM3352_IDX	1
-#define	OMAP_RTC_DATA_DA830_IDX		2
+static const struct omap_rtc_device_type omap_rtc_default_type = {
+};
 
-static const struct platform_device_id omap_rtc_devtype[] = {
+static const struct omap_rtc_device_type omap_rtc_am3352_type = {
+	.has_32kclk_en	= true,
+	.has_kicker	= true,
+	.has_irqwakeen	= true,
+};
+
+static const struct omap_rtc_device_type omap_rtc_da830_type = {
+	.has_kicker	= true,
+};
+
+static const struct platform_device_id omap_rtc_id_table[] = {
 	{
 		.name	= "omap_rtc",
-	},
-	[OMAP_RTC_DATA_AM3352_IDX] = {
+		.driver_data = (kernel_ulong_t)&omap_rtc_default_type,
+	}, {
 		.name	= "am3352-rtc",
-		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN |
-			       OMAP_RTC_HAS_32KCLK_EN,
-	},
-	[OMAP_RTC_DATA_DA830_IDX] = {
+		.driver_data = (kernel_ulong_t)&omap_rtc_am3352_type,
+	}, {
 		.name	= "da830-rtc",
-		.driver_data = OMAP_RTC_HAS_KICKER,
-	},
-	{},
+		.driver_data = (kernel_ulong_t)&omap_rtc_da830_type,
+	}, {
+		/* sentinel */
+	}
 };
-MODULE_DEVICE_TABLE(platform, omap_rtc_devtype);
+MODULE_DEVICE_TABLE(platform, omap_rtc_id_table);
 
 static const struct of_device_id omap_rtc_of_match[] = {
-	{	.compatible	= "ti,da830-rtc",
-		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
-	},
-	{	.compatible	= "ti,am3352-rtc",
-		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_AM3352_IDX],
-	},
-	{},
+	{
+		.compatible	= "ti,am3352-rtc",
+		.data		= &omap_rtc_am3352_type,
+	}, {
+		.compatible	= "ti,da830-rtc",
+		.data		= &omap_rtc_da830_type,
+	}, {
+		/* sentinel */
+	}
 };
 MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
 
@@ -398,17 +401,13 @@ static int __init omap_rtc_probe(struct
 		return -ENOMEM;
 
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
-	if (of_id)
-		pdev->id_entry = of_id->data;
-
-	id_entry = platform_get_device_id(pdev);
-	if (!id_entry) {
-		dev_err(&pdev->dev, "no matching device entry\n");
-		return -ENODEV;
+	if (of_id) {
+		rtc->type = of_id->data;
+	} else {
+		id_entry = platform_get_device_id(pdev);
+		rtc->type = (void *)id_entry->driver_data;
 	}
 
-	rtc->flags = id_entry->driver_data;
-
 	rtc->irq_timer = platform_get_irq(pdev, 0);
 	if (rtc->irq_timer <= 0)
 		return -ENOENT;
@@ -428,7 +427,7 @@ static int __init omap_rtc_probe(struct
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	if (rtc->flags & OMAP_RTC_HAS_KICKER) {
+	if (rtc->type->has_kicker) {
 		rtc_writel(rtc, OMAP_RTC_KICK0_REG, KICK0_VALUE);
 		rtc_writel(rtc, OMAP_RTC_KICK1_REG, KICK1_VALUE);
 	}
@@ -441,7 +440,7 @@ static int __init omap_rtc_probe(struct
 	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 
 	/* enable RTC functional clock */
-	if (rtc->flags & OMAP_RTC_HAS_32KCLK_EN) {
+	if (rtc->type->has_32kclk_en) {
 		reg = rtc_read(rtc, OMAP_RTC_OSC_REG);
 		rtc_writel(rtc, OMAP_RTC_OSC_REG,
 				reg | OMAP_RTC_OSC_32KCLK_EN);
@@ -511,7 +510,7 @@ static int __init omap_rtc_probe(struct
 
 err:
 	device_init_wakeup(&pdev->dev, false);
-	if (rtc->flags & OMAP_RTC_HAS_KICKER)
+	if (rtc->type->has_kicker)
 		rtc_writel(rtc, OMAP_RTC_KICK0_REG, 0);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -528,7 +527,7 @@ static int __exit omap_rtc_remove(struct
 	/* leave rtc running, but disable irqs */
 	rtc_write(rtc, OMAP_RTC_INTERRUPTS_REG, 0);
 
-	if (rtc->flags & OMAP_RTC_HAS_KICKER)
+	if (rtc->type->has_kicker)
 		rtc_writel(rtc, OMAP_RTC_KICK0_REG, 0);
 
 	/* Disable the clock/module */
@@ -594,7 +593,7 @@ static struct platform_driver omap_rtc_d
 		.pm	= &omap_rtc_pm_ops,
 		.of_match_table = omap_rtc_of_match,
 	},
-	.id_table	= omap_rtc_devtype,
+	.id_table	= omap_rtc_id_table,
 };
 
 module_platform_driver_probe(omap_rtc_driver, omap_rtc_probe);
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

