From: akpm@linux-foundation.org
Subject: + rtc-omap-add-support-for-pmic_power_en.patch added to -mm tree
Date: Wed, 22 Oct 2014 12:04:42 -0700
Message-ID: <5447ffca.d/LdFpY/Wo97+Wn6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaJVTEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, anilkumar@ti.com, balbi@ti.com, bcousson@baylibre.com, colin.foeparker@logicpd.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: omap: add support for pmic_power_en
has been added to the -mm tree.  Its filename is
     rtc-omap-add-support-for-pmic_power_en.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-omap-add-support-for-pmic_power_en.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-omap-add-support-for-pmic_power_en.patch

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
Subject: rtc: omap: add support for pmic_power_en

Add new property "ti,system-power-controller" to register the RTC as a
power-off handler.

Some RTC IP revisions can control an external PMIC via the pmic_power_en
pin, which can be configured to transition to OFF on ALARM2 events and
back to ON on subsequent ALARM (wakealarm) events.

This is based on earlier work by Colin Foe-Parker and AnilKumar Ch. [1]

[1] https://www.mail-archive.com/linux-omap@vger.kernel.org/msg82127.html

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
Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    9 -
 drivers/rtc/rtc-omap.c                             |   93 +++++++++++
 2 files changed, 101 insertions(+), 1 deletion(-)

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
 
@@ -345,6 +361,63 @@ static int omap_rtc_set_alarm(struct dev
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
+ * period (~15us).
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
+}
+
 static struct rtc_class_ops omap_rtc_ops = {
 	.read_time	= omap_rtc_read_time,
 	.set_time	= omap_rtc_set_time,
@@ -361,6 +434,7 @@ static const struct omap_rtc_device_type
 	.has_32kclk_en	= true,
 	.has_kicker	= true,
 	.has_irqwakeen	= true,
+	.has_pmic_mode	= true,
 };
 
 static const struct omap_rtc_device_type omap_rtc_da830_type = {
@@ -412,6 +486,9 @@ static int __init omap_rtc_probe(struct
 	of_id = of_match_device(omap_rtc_of_match, &pdev->dev);
 	if (of_id) {
 		rtc->type = of_id->data;
+		rtc->is_pmic_controller = rtc->type->has_pmic_mode &&
+				of_property_read_bool(pdev->dev.of_node,
+						"ti,system-power-controller");
 	} else {
 		id_entry = platform_get_device_id(pdev);
 		rtc->type = (void *)id_entry->driver_data;
@@ -460,6 +537,9 @@ static int __init omap_rtc_probe(struct
 
 	mask = OMAP_RTC_STATUS_ALARM;
 
+	if (rtc->type->has_pmic_mode)
+		mask |= OMAP_RTC_STATUS_ALARM2;
+
 	if (rtc->type->has_power_up_reset) {
 		mask |= OMAP_RTC_STATUS_POWER_UP;
 		if (reg & OMAP_RTC_STATUS_POWER_UP)
@@ -520,6 +600,13 @@ static int __init omap_rtc_probe(struct
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
@@ -536,6 +623,12 @@ static int __exit omap_rtc_remove(struct
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

