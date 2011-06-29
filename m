From: akpm@linux-foundation.org
Subject: + x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:29:19 -0700
Message-ID: <201106292129.p5TLTJia013095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab1F2V3h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:29:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86, olpc: add XO-1 SCI driver and power button control
has been added to the -mm tree.  Its filename is
     x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch

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
Subject: x86, olpc: add XO-1 SCI driver and power button control
From: Daniel Drake <dsd@laptop.org>

The System Control Interrupt is used in the OLPC XO-1 to control various
features of the laptop.  Add the driver base and the power button
functionality.

This driver can't be built as a module, because functionality added in
future patches means that some drivers need to know at boot-time whether
SCI-based functionality is available.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                      |    9 +
 arch/x86/platform/olpc/Makefile       |    1 
 arch/x86/platform/olpc/olpc-xo1-sci.c |  191 ++++++++++++++++++++++++
 include/linux/cs5535.h                |    8 +
 4 files changed, 209 insertions(+)

diff -puN arch/x86/Kconfig~x86-olpc-add-xo-1-sci-driver-and-power-button-control arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-add-xo-1-sci-driver-and-power-button-control
+++ a/arch/x86/Kconfig
@@ -2096,6 +2096,15 @@ config ALIX
 
 	  Note: You have to set alix.force=1 for boards with Award BIOS.
 
+config OLPC_XO1_SCI
+	bool "OLPC XO-1 SCI extras"
+	depends on OLPC && OLPC_XO1_PM
+	select GPIO_CS5535
+	select MFD_CORE
+	---help---
+	  Add support for SCI-based features of the OLPC XO-1 laptop:
+	   - Power button
+
 endif # X86_32
 
 config AMD_NB
diff -puN arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-sci-driver-and-power-button-control arch/x86/platform/olpc/Makefile
--- a/arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-1-sci-driver-and-power-button-control
+++ a/arch/x86/platform/olpc/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
 obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
+obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
diff -puN /dev/null arch/x86/platform/olpc/olpc-xo1-sci.c
--- /dev/null
+++ a/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -0,0 +1,191 @@
+/*
+ * Support for OLPC XO-1 System Control Interrupts (SCI)
+ *
+ * Copyright (C) 2010 One Laptop per Child
+ * Copyright (C) 2006 Red Hat, Inc.
+ * Copyright (C) 2006 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/cs5535.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/mfd/core.h>
+#include <linux/suspend.h>
+
+#include <asm/io.h>
+#include <asm/msr.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME	"olpc-xo1-sci"
+#define PFX		DRV_NAME ": "
+
+static unsigned long acpi_base;
+static struct input_dev *power_button_idev;
+static int sci_irq;
+
+static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
+{
+	struct platform_device *pdev = dev_id;
+	u32 sts;
+	u32 gpe;
+
+	sts = inl(acpi_base + CS5536_PM1_STS);
+	outl(sts | 0xffff, acpi_base + CS5536_PM1_STS);
+
+	gpe = inl(acpi_base + CS5536_PM_GPE0_STS);
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
+
+	dev_dbg(&pdev->dev, "sts %x gpe %x\n", sts, gpe);
+
+	if (sts & CS5536_PWRBTN_FLAG && !(sts & CS5536_WAK_FLAG)) {
+		input_report_key(power_button_idev, KEY_POWER, 1);
+		input_sync(power_button_idev);
+		input_report_key(power_button_idev, KEY_POWER, 0);
+		input_sync(power_button_idev);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int xo1_sci_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	if (device_may_wakeup(&power_button_idev->dev))
+		olpc_xo1_pm_wakeup_set(CS5536_PM_PWRBTN);
+	else
+		olpc_xo1_pm_wakeup_clear(CS5536_PM_PWRBTN);
+	return 0;
+}
+
+static int __devinit setup_sci_interrupt(struct platform_device *pdev)
+{
+	u32 lo, hi;
+	u32 sts;
+	int r;
+
+	rdmsr(0x51400020, lo, hi);
+	sci_irq = (lo >> 20) & 15;
+
+	if (sci_irq) {
+		dev_info(&pdev->dev, "SCI is mapped to IRQ %d\n", sci_irq);
+	} else {
+		/* Zero means masked */
+		dev_info(&pdev->dev, "SCI unmapped. Mapping to IRQ 3\n");
+		sci_irq = 3;
+		lo |= 0x00300000;
+		wrmsrl(0x51400020, lo);
+	}
+
+	/* Select level triggered in PIC */
+	if (sci_irq < 8) {
+		lo = inb(CS5536_PIC_INT_SEL1);
+		lo |= 1 << sci_irq;
+		outb(lo, CS5536_PIC_INT_SEL1);
+	} else {
+		lo = inb(CS5536_PIC_INT_SEL2);
+		lo |= 1 << (sci_irq - 8);
+		outb(lo, CS5536_PIC_INT_SEL2);
+	}
+
+	/* Enable SCI from power button, and clear pending interrupts */
+	sts = inl(acpi_base + CS5536_PM1_STS);
+	outl((CS5536_PM_PWRBTN << 16) | 0xffff, acpi_base + CS5536_PM1_STS);
+
+	r = request_irq(sci_irq, xo1_sci_intr, 0, DRV_NAME, pdev);
+	if (r)
+		dev_err(&pdev->dev, "can't request interrupt\n");
+
+	return r;
+}
+
+static int __devinit setup_power_button(struct platform_device *pdev)
+{
+	int r;
+
+	power_button_idev = input_allocate_device();
+	if (!power_button_idev)
+		return -ENOMEM;
+
+	power_button_idev->name = "Power Button";
+	power_button_idev->phys = DRV_NAME "/input0";
+	set_bit(EV_KEY, power_button_idev->evbit);
+	set_bit(KEY_POWER, power_button_idev->keybit);
+
+	power_button_idev->dev.parent = &pdev->dev;
+	device_init_wakeup(&power_button_idev->dev, 1);
+
+	r = input_register_device(power_button_idev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register power button: %d\n", r);
+		input_free_device(power_button_idev);
+	}
+
+	return r;
+}
+
+static void free_power_button(void)
+{
+	input_unregister_device(power_button_idev);
+	input_free_device(power_button_idev);
+}
+
+static int __devinit xo1_sci_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int r;
+
+	/* don't run on non-XOs */
+	if (!machine_is_olpc())
+		return -ENODEV;
+
+	r = mfd_cell_enable(pdev);
+	if (r)
+		return r;
+
+	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't fetch device resource info\n");
+		return -EIO;
+	}
+	acpi_base = res->start;
+
+	r = setup_power_button(pdev);
+	if (r)
+		return r;
+
+	r = setup_sci_interrupt(pdev);
+	if (r)
+		free_power_button();
+
+	return r;
+}
+
+static int __devexit xo1_sci_remove(struct platform_device *pdev)
+{
+	mfd_cell_disable(pdev);
+	free_irq(sci_irq, pdev);
+	free_power_button();
+	acpi_base = 0;
+	return 0;
+}
+
+static struct platform_driver xo1_sci_driver = {
+	.driver = {
+		.name = "olpc-xo1-sci-acpi",
+	},
+	.probe = xo1_sci_probe,
+	.remove = __devexit_p(xo1_sci_remove),
+	.suspend = xo1_sci_suspend,
+};
+
+static int __init xo1_sci_init(void)
+{
+	return platform_driver_register(&xo1_sci_driver);
+}
+arch_initcall(xo1_sci_init);
diff -puN include/linux/cs5535.h~x86-olpc-add-xo-1-sci-driver-and-power-button-control include/linux/cs5535.h
--- a/include/linux/cs5535.h~x86-olpc-add-xo-1-sci-driver-and-power-button-control
+++ a/include/linux/cs5535.h
@@ -43,6 +43,10 @@
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
 #define MSR_GX_MSR_PADSEL	0xC0002011
 
+/* PIC registers */
+#define CS5536_PIC_INT_SEL1	0x4d0
+#define CS5536_PIC_INT_SEL2	0x4d1
+
 /* resource sizes */
 #define LBAR_GPIO_SIZE		0xFF
 #define LBAR_MFGPT_SIZE		0x40
@@ -70,6 +74,10 @@
 #define CS5536_PM1_CNT		0x08
 #define CS5536_PM_GPE0_STS	0x18
 
+/* CS5536_PM1_STS bits */
+#define CS5536_WAK_FLAG		(1 << 15)
+#define CS5536_PWRBTN_FLAG	(1 << 8)
+
 /* CS5536_PM1_EN bits */
 #define CS5536_PM_PWRBTN	(1 << 8)
 
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

