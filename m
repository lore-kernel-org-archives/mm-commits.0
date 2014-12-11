From: akpm@linux-foundation.org
Subject: [merged] rtc-omap-add-support-for-pmic_power_en.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:06:48 -0800
Message-ID: <5489eb48.yRFlLsmEey0dG+Og%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500AbaLKTGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, anilkumar@ti.com, balbi@ti.com, bcousson@baylibre.com, colin.foeparker@logicpd.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add support for pmic_power_en
has been removed from the -mm tree.  Its filename was
     rtc-omap-add-support-for-pmic_power_en.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: rtc: omap: add support for pmic_power_en

Add new property "ti,system-power-controller" to register the RTC as a
power-off handler.

Some RTC IP revisions can control an external PMIC via the pmic_power_en
pin, which can be configured to transition to OFF on ALARM2 events and
back to ON on subsequent ALARM (wakealarm) events.

This is based on earlier work by Colin Foe-Parker and AnilKumar Ch. [1]

[1] https://www.mail-archive.com/linux-omap@vger.kernel.org/msg82127.html

[akpm@linux-foundation.org: add comment]
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Colin Foe-Parker <colin.foeparker@logicpd.com>
Cc: AnilKumar Ch <anilkumar@ti.com>
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

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    9 
 drivers/rtc/rtc-omap.c                             |  100 +++++++++++
 2 files changed, 108 insertions(+), 1 deletion(-)

diff -puN Documentation/devicetree/bindings/rtc/rtc-omap.txt~rtc-omap-add-support-for-pmic_power_en Documentation/devicetree/bindings/rtc/rtc-omap.txt
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt~rtc-omap-add-support-for-pmic_power_en
+++ a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -5,11 +5,17 @@ Required properties:
 	- "ti,da830-rtc"  - for RTC IP used similar to that on DA8xx SoC family.
 	- "ti,am3352-rtc" - for RTC IP used similar to that on AM335x SoC family.
 			    This RTC IP has special WAKE-EN Register to enable
-			    Wakeup generation for event Alarm.
+			    Wakeup generation for event Alarm. It can also be
+			    used to control an external PMIC via the
+			    pmic_power_en pin.
 - reg: Address range of rtc register set
 - interrupts: rtc timer, alarm interrupts in order
 - interrupt-parent: phandle for the interrupt controller
 
+Optional properties:
+- ti,system-power-controller: whether the rtc is controlling the system power
+  through pmic_power_en
+
 Example:
 
 rtc@1c23000 {
@@ -18,4 +24,5 @@ rtc@1c23000 {
 	interrupts = <19
 		      19>;
 	interrupt-parent = <&intc>;
+	ti,system-power-controller;
 };
diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en
+++ a/drivers/rtc/rtc-omap.c
@@ -68,6 +68,15 @@
 
 #define OMAP_RTC_IRQWAKEEN		0x7c
 
+#define OMAP_RTC_ALARM2_SECONDS_REG	0x80
+#define OMAP_RTC_ALARM2_MINUTES_REG	0x84
+#define OMAP_RTC_ALARM2_HOURS_REG	0x88
+#define OMAP_RTC_ALARM2_DAYS_REG	0x8c
+#define OMAP_RTC_ALARM2_MONTHS_REG	0x90
+#define OMAP_RTC_ALARM2_YEARS_REG	0x94
+
+#define OMAP_RTC_PMIC_REG		0x98
+
 /* OMAP_RTC_CTRL_REG bit fields: */
 #define OMAP_RTC_CTRL_SPLIT		BIT(7)
 #define OMAP_RTC_CTRL_DISABLE		BIT(6)
@@ -80,6 +89,7 @@
 
 /* OMAP_RTC_STATUS_REG bit fields: */
 #define OMAP_RTC_STATUS_POWER_UP	BIT(7)
+#define OMAP_RTC_STATUS_ALARM2		BIT(7)
 #define OMAP_RTC_STATUS_ALARM		BIT(6)
 #define OMAP_RTC_STATUS_1D_EVENT	BIT(5)
 #define OMAP_RTC_STATUS_1H_EVENT	BIT(4)
@@ -89,6 +99,7 @@
 #define OMAP_RTC_STATUS_BUSY		BIT(0)
 
 /* OMAP_RTC_INTERRUPTS_REG bit fields: */
+#define OMAP_RTC_INTERRUPTS_IT_ALARM2	BIT(4)
 #define OMAP_RTC_INTERRUPTS_IT_ALARM	BIT(3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER	BIT(2)
 
@@ -98,6 +109,9 @@
 /* OMAP_RTC_IRQWAKEEN bit fields: */
 #define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN	BIT(1)
 
+/* OMAP_RTC_PMIC bit fields: */
+#define OMAP_RTC_PMIC_POWER_EN_EN	BIT(16)
+
 /* OMAP_RTC_KICKER values */
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
@@ -106,6 +120,7 @@ struct omap_rtc_device_type {
 	bool has_32kclk_en;
 	bool has_kicker;
 	bool has_irqwakeen;
+	bool has_pmic_mode;
 	bool has_power_up_reset;
 };
 
@@ -115,6 +130,7 @@ struct omap_rtc {
 	int irq_alarm;
 	int irq_timer;
 	u8 interrupts_reg;
+	bool is_pmic_controller;
 	const struct omap_rtc_device_type *type;
 };
 
@@ -345,6 +361,70 @@ static int omap_rtc_set_alarm(struct dev
 	return 0;
 }
 
+static struct omap_rtc *omap_rtc_power_off_rtc;
+
+/*
+ * omap_rtc_poweroff: RTC-controlled power off
+ *
+ * The RTC can be used to control an external PMIC via the pmic_power_en pin,
+ * which can be configured to transition to OFF on ALARM2 events.
+ *
+ * Notes:
+ * The two-second alarm offset is the shortest offset possible as the alarm
+ * registers must be set before the next timer update and the offset
+ * calculation is too heavy for everything to be done within a single access
+ * period (~15 us).
+ *
+ * Called with local interrupts disabled.
+ */
+static void omap_rtc_power_off(void)
+{
+	struct omap_rtc *rtc = omap_rtc_power_off_rtc;
+	struct rtc_time tm;
+	unsigned long now;
+	u32 val;
+
+	/* enable pmic_power_en control */
+	val = rtc_readl(rtc, OMAP_RTC_PMIC_REG);
+	rtc_writel(rtc, OMAP_RTC_PMIC_REG, val | OMAP_RTC_PMIC_POWER_EN_EN);
+
+	/* set alarm two seconds from now */
+	omap_rtc_read_time_raw(rtc, &tm);
+	bcd2tm(&tm);
+	rtc_tm_to_time(&tm, &now);
+	rtc_time_to_tm(now + 2, &tm);
+
+	if (tm2bcd(&tm) < 0) {
+		dev_err(&rtc->rtc->dev, "power off failed\n");
+		return;
+	}
+
+	rtc_wait_not_busy(rtc);
+
+	rtc_write(rtc, OMAP_RTC_ALARM2_SECONDS_REG, tm.tm_sec);
+	rtc_write(rtc, OMAP_RTC_ALARM2_MINUTES_REG, tm.tm_min);
+	rtc_write(rtc, OMAP_RTC_ALARM2_HOURS_REG, tm.tm_hour);
+	rtc_write(rtc, OMAP_RTC_ALARM2_DAYS_REG, tm.tm_mday);
+	rtc_write(rtc, OMAP_RTC_ALARM2_MONTHS_REG, tm.tm_mon);
+	rtc_write(rtc, OMAP_RTC_ALARM2_YEARS_REG, tm.tm_year);
+
+	/*
+	 * enable ALARM2 interrupt
+	 *
+	 * NOTE: this fails on AM3352 if rtc_write (writeb) is used
+	 */
+	val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
+	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
+			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
+
+	/*
+	 * Wait for alarm to trigger (within two seconds) and external PMIC to
+	 * power off the system. Add a 500 ms margin for external latencies
+	 * (e.g. debounce circuits).
+	 */
+	mdelay(2500);
+}
+
 static struct rtc_class_ops omap_rtc_ops = {
 	.read_time	= omap_rtc_read_time,
 	.set_time	= omap_rtc_set_time,
@@ -361,6 +441,7 @@ static const struct omap_rtc_device_type
 	.has_32kclk_en	= true,
 	.has_kicker	= true,
 	.has_irqwakeen	= true,
+	.has_pmic_mode	= true,
 };
 
 static const struct omap_rtc_device_type omap_rtc_da830_type = {
@@ -412,6 +493,9 @@ static int __init omap_rtc_probe(struct
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
 	if (of_id) {
 		rtc->type = of_id->data;
+		rtc->is_pmic_controller = rtc->type->has_pmic_mode &&
+				of_property_read_bool(pdev->dev.of_node,
+						"ti,system-power-controller");
 	} else {
 		id_entry = platform_get_device_id(pdev);
 		rtc->type = (void *)id_entry->driver_data;
@@ -460,6 +544,9 @@ static int __init omap_rtc_probe(struct
 
 	mask = OMAP_RTC_STATUS_ALARM;
 
+	if (rtc->type->has_pmic_mode)
+		mask |= OMAP_RTC_STATUS_ALARM2;
+
 	if (rtc->type->has_power_up_reset) {
 		mask |= OMAP_RTC_STATUS_POWER_UP;
 		if (reg & OMAP_RTC_STATUS_POWER_UP)
@@ -520,6 +607,13 @@ static int __init omap_rtc_probe(struct
 			goto err;
 	}
 
+	if (rtc->is_pmic_controller) {
+		if (!pm_power_off) {
+			omap_rtc_power_off_rtc = rtc;
+			pm_power_off = omap_rtc_power_off;
+		}
+	}
+
 	return 0;
 
 err:
@@ -536,6 +630,12 @@ static int __exit omap_rtc_remove(struct
 {
 	struct omap_rtc *rtc = platform_get_drvdata(pdev);
 
+	if (pm_power_off == omap_rtc_power_off &&
+			omap_rtc_power_off_rtc == rtc) {
+		pm_power_off = NULL;
+		omap_rtc_power_off_rtc = NULL;
+	}
+
 	device_init_wakeup(&pdev->dev, 0);
 
 	/* leave rtc running, but disable irqs */
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

