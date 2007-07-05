From: akpm@linux-foundation.org
Subject: + geode-basic-infrastructure-support-for-amd-geode-class.patch added to -mm tree
Date: Thu, 05 Jul 2007 15:26:26 -0700
Message-ID: <200707052226.l65MQQGv022096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762833AbXGEW1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 18:27:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, ak@suse.de, alan@lxorguk.ukuu.org.uk, david-b@pacbell.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     GEODE: basic infrastructure support for AMD geode-class  machines
has been added to the -mm tree.  Its filename is
     geode-basic-infrastructure-support-for-amd-geode-class.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: GEODE: basic infrastructure support for AMD geode-class  machines
From: Andres Salomon <dilinger@queued.net>

This builds upon the existing geode infrastructure, but adds southbridge
support, some GPIO functions, and a header file (asm-i386/geode.h) with some
useful GX/LX detection tests.

The majority of this code was written by Jordan Crouse.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile |    1 
 arch/i386/kernel/geode.c  |  156 +++++++++++++++++++++++++++++++++++
 include/asm-i386/geode.h  |  159 ++++++++++++++++++++++++++++++++++++
 3 files changed, 316 insertions(+)

diff -puN arch/i386/kernel/Makefile~geode-basic-infrastructure-support-for-amd-geode-class arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~geode-basic-infrastructure-support-for-amd-geode-class
+++ a/arch/i386/kernel/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_VM86)		+= vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
+obj-$(CONFIG_MGEODE_LX)		+= geode.o
 obj-$(CONFIG_STACK_UNWIND)	+= unwind.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmiclock.o
diff -puN /dev/null arch/i386/kernel/geode.c
--- /dev/null
+++ a/arch/i386/kernel/geode.c
@@ -0,0 +1,156 @@
+/*
+ * AMD Geode southbridge support code
+ * Copyright (C) 2006, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <asm/io.h>
+#include <asm/msr.h>
+#include <asm/geode.h>
+
+static struct {
+	char *name;
+	u32 msr;
+	int size;
+	u32 base;
+} lbars[] = {
+	{ "geode-pms",   MSR_LBAR_PMS, LBAR_PMS_SIZE, 0 },
+	{ "geode-acpi",  MSR_LBAR_ACPI, LBAR_ACPI_SIZE, 0 },
+	{ "geode-gpio",  MSR_LBAR_GPIO, LBAR_GPIO_SIZE, 0 },
+	{ "geode-mfgpt", MSR_LBAR_MFGPT, LBAR_MFGPT_SIZE, 0 }
+};
+
+static void __init init_lbars(void)
+{
+	u32 lo, hi;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lbars); i++) {
+		rdmsr(lbars[i].msr, lo, hi);
+		if (hi & 0x01)
+			lbars[i].base = lo & 0x0000ffff;
+
+		if (lbars[i].base == 0)
+			printk(KERN_ERR "geode:  Couldn't initialize '%s'\n", lbars[i].name);
+	}
+}
+
+int geode_get_dev_base(unsigned int dev)
+{
+	BUG_ON(dev >= ARRAY_SIZE(lbars));
+	return lbars[dev].base;
+}
+EXPORT_SYMBOL_GPL(geode_get_dev_base);
+
+/* === GPIO API === */
+
+void geode_gpio_set(unsigned int gpio, unsigned int reg)
+{
+	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
+
+	if (!base)
+		return;
+
+	if (gpio < 16)
+		outl(1 << gpio, base + reg);
+	else
+		outl(1 << (gpio - 16), base + 0x80 + reg);
+}
+EXPORT_SYMBOL_GPL(geode_gpio_set);
+
+void geode_gpio_clear(unsigned int gpio, unsigned int reg)
+{
+	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
+
+	if (!base)
+		return;
+
+	if (gpio < 16)
+		outl(1 << (gpio + 16), base + reg);
+	else
+		outl(1 << gpio, base + 0x80 + reg);
+}
+EXPORT_SYMBOL_GPL(geode_gpio_clear);
+
+int geode_gpio_isset(unsigned int gpio, unsigned int reg)
+{
+	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
+
+	if (!base)
+		return 0;
+
+	if (gpio < 16)
+		return (inl(base + reg) & (1 << gpio)) ? 1 : 0;
+	else
+		return (inl(base + 0x80 + reg) & (1 << (gpio - 16))) ? 1 : 0;
+}
+EXPORT_SYMBOL_GPL(geode_gpio_isset);
+
+void geode_gpio_set_irq(unsigned int group, unsigned int irq)
+{
+	u32 lo, hi;
+
+	if (group > 7 || irq > 15)
+		return;
+
+	rdmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+
+	lo &= ~(0xF << (group * 4));
+	lo |= (irq & 0xF) << (group * 4);
+
+	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+}
+
+EXPORT_SYMBOL_GPL(geode_gpio_set_irq);
+
+void geode_gpio_setup_event(unsigned int gpio, int pair, int pme)
+{
+	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
+	u32 offset, shift, val;
+
+	if (gpio >= 24)
+		offset = GPIO_MAP_W;
+	else if (gpio >= 16)
+		offset = GPIO_MAP_Z;
+	else if (gpio >= 8)
+		offset = GPIO_MAP_Y;
+	else
+		offset = GPIO_MAP_X;
+
+	shift = (gpio % 8) * 4;
+
+	val = inl(base + offset);
+
+	/* Clear whatever was there before */
+	val &= ~(0xF << shift);
+
+	/* And set the new value */
+
+	val |= ((pair & 7) << shift);
+
+	/* Set the PME bit if this is a PME event */
+
+	if (pme)
+		val |= (1 << (shift + 3));
+
+	outl(val, base + offset);
+}
+
+EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
+
+static int __init geode_southbridge_init(void)
+{
+	if (!is_geode())
+		return -ENODEV;
+
+	init_lbars();
+	return 0;
+}
+
+postcore_initcall(geode_southbridge_init);
diff -puN /dev/null include/asm-i386/geode.h
--- /dev/null
+++ a/include/asm-i386/geode.h
@@ -0,0 +1,159 @@
+/*
+ * AMD Geode definitions
+ * Copyright (C) 2006, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_GEODE_H_
+#define _ASM_GEODE_H_
+
+#include <asm/processor.h>
+#include <asm/io.h>
+
+/* Generic southbridge functions */
+
+#define GEODE_DEV_PMS 0
+#define GEODE_DEV_ACPI 1
+#define GEODE_DEV_GPIO 2
+#define GEODE_DEV_MFGPT 3
+
+extern int geode_get_dev_base(unsigned int dev);
+
+/* Useful macros */
+#define geode_pms_base()	geode_get_dev_base(GEODE_DEV_PMS)
+#define geode_acpi_base()	geode_get_dev_base(GEODE_DEV_ACPI)
+#define geode_gpio_base()	geode_get_dev_base(GEODE_DEV_GPIO)
+#define geode_mfgpt_base()	geode_get_dev_base(GEODE_DEV_MFGPT)
+
+/* MSRS */
+
+#define GX_GLCP_SYS_RSTPLL	0x4C000014
+
+#define MSR_LBAR_SMB		0x5140000B
+#define MSR_LBAR_GPIO		0x5140000C
+#define MSR_LBAR_MFGPT		0x5140000D
+#define MSR_LBAR_ACPI		0x5140000E
+#define MSR_LBAR_PMS		0x5140000F
+
+#define MSR_PIC_YSEL_LOW	0x51400020
+#define MSR_PIC_YSEL_HIGH	0x51400021
+#define MSR_PIC_ZSEL_LOW	0x51400022
+#define MSR_PIC_ZSEL_HIGH	0x51400023
+
+#define MFGPT_IRQ_MSR		0x51400028
+#define MFGPT_NR_MSR		0x51400029
+
+/* Resource Sizes */
+
+#define LBAR_GPIO_SIZE		0xFF
+#define LBAR_MFGPT_SIZE		0x40
+#define LBAR_ACPI_SIZE		0x40
+#define LBAR_PMS_SIZE		0x80
+
+/* ACPI registers (PMS block) */
+
+/*
+ * PM1_EN is only valid when VSA is enabled for 16 bit reads.
+ * When VSA is not enabled, *always* read both PM1_STS and PM1_EN
+ * with a 32 bit read at offset 0x0
+ */
+
+#define PM1_STS			0x00
+#define PM1_EN			0x02
+#define PM1_CNT			0x08
+#define PM2_CNT			0x0C
+#define PM_TMR			0x10
+#define PM_GPE0_STS		0x18
+#define PM_GPE0_EN		0x1C
+
+/* PMC registers (PMS block) */
+
+#define PM_SSD			0x00
+#define PM_SCXA			0x04
+#define PM_SCYA			0x08
+#define PM_OUT_SLPCTL		0x0C
+#define PM_SCLK			0x10
+#define PM_SED			0x1
+#define PM_SCXD			0x18
+#define PM_SCYD			0x1C
+#define PM_IN_SLPCTL		0x20
+#define PM_WKD			0x30
+#define PM_WKXD			0x34
+#define PM_RD			0x38
+#define PM_WKXA			0x3C
+#define PM_FSD			0x40
+#define PM_TSD			0x44
+#define PM_PSD			0x48
+#define PM_NWKD			0x4C
+#define PM_AWKD			0x50
+#define PM_SSC			0x54
+
+/* GPIO */
+
+#define GPIO_OUTPUT_VAL		0x00
+#define GPIO_OUTPUT_ENABLE	0x04
+#define GPIO_OUTPUT_OPEN_DRAIN	0x08
+#define GPIO_OUTPUT_INVERT	0x0C
+#define GPIO_OUTPUT_AUX1	0x10
+#define GPIO_OUTPUT_AUX2	0x14
+#define GPIO_PULL_UP		0x18
+#define GPIO_PULL_DOWN		0x1C
+#define GPIO_INPUT_ENABLE	0x20
+#define GPIO_INPUT_INVERT	0x24
+#define GPIO_INPUT_FILTER	0x28
+#define GPIO_INPUT_EVENT_COUNT	0x2C
+#define GPIO_READ_BACK		0x30
+#define GPIO_INPUT_AUX1		0x34
+#define GPIO_EVENTS_ENABLE	0x38
+#define GPIO_LOCK_ENABLE	0x3C
+#define GPIO_POSITIVE_EDGE_EN	0x40
+#define GPIO_NEGATIVE_EDGE_EN	0x44
+#define GPIO_POSITIVE_EDGE_STS	0x48
+#define GPIO_NEGATIVE_EDGE_STS	0x4C
+
+#define GPIO_MAP_X		0xE0
+#define GPIO_MAP_Y		0xE4
+#define GPIO_MAP_Z		0xE8
+#define GPIO_MAP_W		0xEC
+
+extern void geode_gpio_set(unsigned int, unsigned int);
+extern void geode_gpio_clear(unsigned int, unsigned int);
+extern int geode_gpio_isset(unsigned int, unsigned int);
+extern void geode_gpio_setup_event(unsigned int, int, int);
+extern void geode_gpio_set_irq(unsigned int, unsigned int);
+
+static inline void geode_gpio_event_irq(unsigned int gpio, int pair)
+{
+	geode_gpio_setup_event(gpio, pair, 0);
+}
+
+static inline void geode_gpio_event_pme(unsigned int gpio, int pair)
+{
+	geode_gpio_setup_event(gpio, pair, 1);
+}
+
+/* Specific geode tests */
+
+static inline int is_geode_gx(void)
+{
+	return ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC) &&
+		(boot_cpu_data.x86 == 5) &&
+		(boot_cpu_data.x86_model == 5));
+}
+
+static inline int is_geode_lx(void)
+{
+	return ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
+		(boot_cpu_data.x86 == 5) &&
+		(boot_cpu_data.x86_model == 10));
+}
+
+static inline int is_geode(void)
+{
+	return (is_geode_gx() || is_geode_lx());
+}
+
+#endif
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
