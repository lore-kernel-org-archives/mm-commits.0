From: akpm@linux-foundation.org
Subject: + x86-olpc-add-xo-1-rtc-driver.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:29:32 -0700
Message-ID: <201106292129.p5TLTXxa013110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab1F2V3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, bigeasy@linutronix.de, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86, olpc: add XO-1 RTC driver
has been added to the -mm tree.  Its filename is
     x86-olpc-add-xo-1-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86, olpc: add XO-1 RTC driver
From: Daniel Drake <dsd@laptop.org>

Add a driver to configure the XO-1 RTC via CS5536 MSRs, to be used as a
system wakeup source via olpc-xo1-pm.

Device detection is based on finding the relevant device tree node.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt |    5 
 arch/x86/Kconfig                                       |    7 
 arch/x86/platform/olpc/Makefile                        |    1 
 arch/x86/platform/olpc/olpc-xo1-rtc.c                  |   82 ++++++++++
 include/linux/cs5535.h                                 |    5 
 5 files changed, 100 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/olpc-xo1-rtc.txt
@@ -0,0 +1,5 @@
+OLPC XO-1 RTC
+~~~~~~~~~~~~~
+
+Required properties:
+ - compatible : "olpc,xo1-rtc"
diff -puN arch/x86/Kconfig~x86-olpc-add-xo-1-rtc-driver arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-add-xo-1-rtc-driver
+++ a/arch/x86/Kconfig
@@ -2096,6 +2096,13 @@ config ALIX
 
 	  Note: You have to set alix.force=1 for boards with Award BIOS.
 
+config OLPC_XO1_RTC
+	bool "OLPC XO-1 Real Time Clock"
+	depends on OLPC_XO1_PM && RTC_DRV_CMOS
+	---help---
+	  Add support for the XO-1 real time clock, which can be used as a
+	  programmable wakeup source.
+
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
 	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
diff -puN arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-rtc-driver arch/x86/platform/olpc/Makefile
--- a/arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-rtc-driver
+++ a/arch/x86/platform/olpc/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
 obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
+obj-$(CONFIG_OLPC_XO1_RTC)	+= olpc-xo1-rtc.o
 obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
diff -puN /dev/null arch/x86/platform/olpc/olpc-xo1-rtc.c
--- /dev/null
+++ a/arch/x86/platform/olpc/olpc-xo1-rtc.c
@@ -0,0 +1,82 @@
+/*
+ * Support for OLPC XO-1 Real Time Clock (RTC)
+ *
+ * Copyright (C) 2011 One Laptop per Child
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/mc146818rtc.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/of.h>
+
+#include <asm/msr.h>
+#include <asm/olpc.h>
+
+static void rtc_wake_on(struct device *dev)
+{
+	olpc_xo1_pm_wakeup_set(CS5536_PM_RTC);
+}
+
+static void rtc_wake_off(struct device *dev)
+{
+	olpc_xo1_pm_wakeup_clear(CS5536_PM_RTC);
+}
+
+static struct resource rtc_platform_resource[] = {
+	[0] = {
+		.start	= RTC_PORT(0),
+		.end	= RTC_PORT(1),
+		.flags	= IORESOURCE_IO,
+	},
+	[1] = {
+		.start	= RTC_IRQ,
+		.end	= RTC_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct cmos_rtc_board_info rtc_info = {
+	.rtc_day_alarm = 0,
+	.rtc_mon_alarm = 0,
+	.rtc_century = 0,
+	.wake_on = rtc_wake_on,
+	.wake_off = rtc_wake_off,
+};
+
+static struct platform_device xo1_rtc_device = {
+	.name = "rtc_cmos",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(rtc_platform_resource),
+	.dev.platform_data = &rtc_info,
+	.resource = rtc_platform_resource,
+};
+
+static int __init xo1_rtc_init(void)
+{
+	int r;
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "olpc,xo1-rtc");
+	if (!node)
+		return 0;
+	of_node_put(node);
+
+	pr_info("olpc-xo1-rtc: Initializing OLPC XO-1 RTC\n");
+	rdmsrl(MSR_RTC_DOMA_OFFSET, rtc_info.rtc_day_alarm);
+	rdmsrl(MSR_RTC_MONA_OFFSET, rtc_info.rtc_mon_alarm);
+	rdmsrl(MSR_RTC_CEN_OFFSET, rtc_info.rtc_century);
+
+	r = platform_device_register(&xo1_rtc_device);
+	if (r)
+		return r;
+
+	device_init_wakeup(&xo1_rtc_device.dev, 1);
+	return 0;
+}
+arch_initcall(xo1_rtc_init);
+
diff -puN include/linux/cs5535.h~x86-olpc-add-xo-1-rtc-driver include/linux/cs5535.h
--- a/include/linux/cs5535.h~x86-olpc-add-xo-1-rtc-driver
+++ a/include/linux/cs5535.h
@@ -40,6 +40,10 @@
 #define MSR_MFGPT_NR		0x51400029
 #define MSR_MFGPT_SETUP		0x5140002B
 
+#define MSR_RTC_DOMA_OFFSET	0x51400055
+#define MSR_RTC_MONA_OFFSET	0x51400056
+#define MSR_RTC_CEN_OFFSET	0x51400057
+
 #define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
 
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
@@ -95,6 +99,7 @@ static inline int cs5535_pic_unreqz_sele
 
 /* CS5536_PM1_EN bits */
 #define CS5536_PM_PWRBTN	(1 << 8)
+#define CS5536_PM_RTC		(1 << 10)
 
 /* CS5536_PM_GPE0_STS bits */
 #define CS5536_GPIOM7_PME_FLAG	(1 << 31)
_

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
x86-olpc-add-missing-elements-to-device-tree.patch
x86-olpc-move-cs5536-related-constants-to-cs5535h.patch
x86-olpc-rename-olpc-xo1-to-olpc-xo1-pm.patch
x86-olpc-add-xo-1-suspend-resume-support.patch
x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch
x86-olpc-ec-sci-wakeup-mask-functionality.patch
x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch
x86-olpc-xo1-sci-add-lid-switch-functionality.patch
x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch
x86-olpc-add-xo-1-rtc-driver.patch
x86-olpc-add-xo-15-sci-driver.patch

