From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events.patch added to -mm tree
Date: Mon, 29 Jul 2013 16:17:40 -0700
Message-ID: <51f6f814.q4bVZc49PbIZO0mH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3G2XRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 19:17:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rob.herring@calxeda.com, nsekhar@ti.com, khilman@linaro.org, grant.likely@linaro.org, a.zummo@towertech.it, gururaja.hebbar@ti.com

Subject: + drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events.patch added to -mm tree
To: gururaja.hebbar@ti.com,a.zummo@towertech.it,grant.likely@linaro.org,khilman@linaro.org,nsekhar@ti.com,rob.herring@calxeda.com,rob@landley.net
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 16:17:40 -0700


The patch titled
     Subject: drivers/rtc/rtc-omap.c: add rtc wakeup support to alarm events
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
Subject: drivers/rtc/rtc-omap.c: add rtc wakeup support to alarm events

On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN) is
available to enable Alarm Wakeup feature.  This register needs to be
properly handled for the rtcwake to work properly.

Platforms using such IP should set "ti,am3352-rtc" in rtc device dt
compatibility node.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/rtc-omap.txt |    6 -
 drivers/rtc/rtc-omap.c                             |   60 +++++++++--
 2 files changed, 57 insertions(+), 9 deletions(-)

diff -puN Documentation/devicetree/bindings/rtc/rtc-omap.txt~drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events Documentation/devicetree/bindings/rtc/rtc-omap.txt
--- a/Documentation/devicetree/bindings/rtc/rtc-omap.txt~drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events
+++ a/Documentation/devicetree/bindings/rtc/rtc-omap.txt
@@ -1,7 +1,11 @@
 TI Real Time Clock
 
 Required properties:
-- compatible: "ti,da830-rtc"
+- compatible:
+	- "ti,da830-rtc"  - for RTC IP used similar to that on DA8xx SoC family.
+	- "ti,am3352-rtc" - for RTC IP used similar to that on AM335x SoC family.
+			    This RTC IP has special WAKE-EN Register to enable
+			    Wakeup generation for event Alarm.
 - reg: Address range of rtc register set
 - interrupts: rtc timer, alarm interrupts in order
 - interrupt-parent: phandle for the interrupt controller
diff -puN drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events
+++ a/drivers/rtc/rtc-omap.c
@@ -70,6 +70,8 @@
 #define OMAP_RTC_KICK0_REG		0x6c
 #define OMAP_RTC_KICK1_REG		0x70
 
+#define OMAP_RTC_IRQWAKEEN		0x7c
+
 /* OMAP_RTC_CTRL_REG bit fields: */
 #define OMAP_RTC_CTRL_SPLIT		(1<<7)
 #define OMAP_RTC_CTRL_DISABLE		(1<<6)
@@ -94,12 +96,21 @@
 #define OMAP_RTC_INTERRUPTS_IT_ALARM    (1<<3)
 #define OMAP_RTC_INTERRUPTS_IT_TIMER    (1<<2)
 
+/* OMAP_RTC_IRQWAKEEN bit fields: */
+#define OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN    (1<<1)
+
 /* OMAP_RTC_KICKER values */
 #define	KICK0_VALUE			0x83e70b13
 #define	KICK1_VALUE			0x95a4f1e0
 
 #define	OMAP_RTC_HAS_KICKER		0x1
 
+/*
+ * Few RTC IP revisions has special WAKE-EN Register to enable Wakeup
+ * generation for event Alarm.
+ */
+#define	OMAP_RTC_HAS_IRQWAKEEN		0x2
+
 static void __iomem	*rtc_base;
 
 #define rtc_read(addr)		readb(rtc_base + (addr))
@@ -299,12 +310,18 @@ static struct rtc_class_ops omap_rtc_ops
 static int omap_rtc_alarm;
 static int omap_rtc_timer;
 
-#define	OMAP_RTC_DATA_DA830_IDX	1
+#define	OMAP_RTC_DATA_AM3352_IDX	1
+#define	OMAP_RTC_DATA_DA830_IDX		2
 
 static struct platform_device_id omap_rtc_devtype[] = {
 	{
 		.name	= DRIVER_NAME,
-	}, {
+	},
+	[OMAP_RTC_DATA_AM3352_IDX] = {
+		.name	= "am3352-rtc",
+		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN,
+	},
+	[OMAP_RTC_DATA_DA830_IDX] = {
 		.name	= "da830-rtc",
 		.driver_data = OMAP_RTC_HAS_KICKER,
 	},
@@ -316,6 +333,9 @@ static const struct of_device_id omap_rt
 	{	.compatible	= "ti,da830-rtc",
 		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
 	},
+	{	.compatible	= "ti,am3352-rtc",
+		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_AM3352_IDX],
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, omap_rtc_of_match);
@@ -464,16 +484,28 @@ static u8 irqstat;
 
 static int omap_rtc_suspend(struct device *dev)
 {
+	u8 irqwake_stat;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id_entry =
+					platform_get_device_id(pdev);
+
 	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 
 	/* FIXME the RTC alarm is not currently acting as a wakeup event
-	 * source, and in fact this enable() call is just saving a flag
-	 * that's never used...
+	 * source on some platforms, and in fact this enable() call is just
+	 * saving a flag that's never used...
 	 */
-	if (device_may_wakeup(dev))
+	if (device_may_wakeup(dev)) {
 		enable_irq_wake(omap_rtc_alarm);
-	else
+
+		if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN) {
+			irqwake_stat = rtc_read(OMAP_RTC_IRQWAKEEN);
+			irqwake_stat |= OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+			rtc_write(irqwake_stat, OMAP_RTC_IRQWAKEEN);
+		}
+	} else {
 		rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
+	}
 
 	/* Disable the clock/module */
 	pm_runtime_put_sync(dev);
@@ -483,13 +515,25 @@ static int omap_rtc_suspend(struct devic
 
 static int omap_rtc_resume(struct device *dev)
 {
+	u8 irqwake_stat;
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id_entry =
+				platform_get_device_id(pdev);
+
 	/* Enable the clock/module so that we can access the registers */
 	pm_runtime_get_sync(dev);
 
-	if (device_may_wakeup(dev))
+	if (device_may_wakeup(dev)) {
 		disable_irq_wake(omap_rtc_alarm);
-	else
+
+		if (id_entry->driver_data & OMAP_RTC_HAS_IRQWAKEEN) {
+			irqwake_stat = rtc_read(OMAP_RTC_IRQWAKEEN);
+			irqwake_stat &= ~OMAP_RTC_IRQWAKEEN_ALARM_WAKEEN;
+			rtc_write(irqwake_stat, OMAP_RTC_IRQWAKEEN);
+		}
+	} else {
 		rtc_write(irqstat, OMAP_RTC_INTERRUPTS_REG);
+	}
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from gururaja.hebbar@ti.com are

drivers-rtc-rtc-omapc-add-rtc-wakeup-support-to-alarm-events.patch

