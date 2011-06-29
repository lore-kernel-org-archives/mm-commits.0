From: akpm@linux-foundation.org
Subject: + x86-olpc-add-xo-15-sci-driver.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:29:35 -0700
Message-ID: <201106292129.p5TLTZhu013113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab1F2V3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86, olpc: add XO-1.5 SCI driver
has been added to the -mm tree.  Its filename is
     x86-olpc-add-xo-15-sci-driver.patch

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
Subject: x86, olpc: add XO-1.5 SCI driver
From: Daniel Drake <dsd@laptop.org>

Add a driver for the ACPI-based EC event interface found on the OLPC
XO-1.5 laptop.  This enables notification of battery/AC power events, and
enables various devices to be used as wakeup sources through regular ACPI
mechanisms.

This driver can't be built as a module, because some drivers need to know
at boot-time if SCI-based functionality is available via
olpc_ec_wakeup_available().

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                       |    9 +
 arch/x86/platform/olpc/Makefile        |    1 
 arch/x86/platform/olpc/olpc-xo15-sci.c |  168 +++++++++++++++++++++++
 arch/x86/platform/olpc/olpc.c          |    9 +
 4 files changed, 187 insertions(+)

diff -puN arch/x86/Kconfig~x86-olpc-add-xo-15-sci-driver arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-add-xo-15-sci-driver
+++ a/arch/x86/Kconfig
@@ -2117,6 +2117,15 @@ config OLPC_XO1_SCI
 	   - AC adapter status updates
 	   - Battery status updates
 
+config OLPC_XO15_SCI
+	bool "OLPC XO-1.5 SCI extras"
+	depends on OLPC && ACPI && POWER_SUPPLY
+	---help---
+	  Add support for SCI-based features of the OLPC XO-1.5 laptop:
+	   - EC-driven system wakeups
+	   - AC adapter status updates
+	   - Battery status updates
+
 endif # X86_32
 
 config AMD_NB
diff -puN arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-15-sci-driver arch/x86/platform/olpc/Makefile
--- a/arch/x86/platform/olpc/Makefile~x86-olpc-add-xo-15-sci-driver
+++ a/arch/x86/platform/olpc/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o
 obj-$(CONFIG_OLPC_XO1_PM)		+= olpc-xo1-pm.o xo1-wakeup.o
 obj-$(CONFIG_OLPC_XO1_RTC)	+= olpc-xo1-rtc.o
 obj-$(CONFIG_OLPC_XO1_SCI)	+= olpc-xo1-sci.o
+obj-$(CONFIG_OLPC_XO15_SCI)	+= olpc-xo15-sci.o
diff -puN /dev/null arch/x86/platform/olpc/olpc-xo15-sci.c
--- /dev/null
+++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -0,0 +1,168 @@
+/*
+ * Support for OLPC XO-1.5 System Control Interrupts (SCI)
+ *
+ * Copyright (C) 2009-2010 One Laptop per Child
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/power_supply.h>
+
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME			"olpc-xo15-sci"
+#define PFX				DRV_NAME ": "
+#define XO15_SCI_CLASS			DRV_NAME
+#define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
+
+static unsigned long xo15_sci_gpe;
+
+static void battery_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-battery");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void ac_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-ac");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void process_sci_queue(void)
+{
+	u16 data;
+	int r;
+
+	do {
+		r = olpc_ec_sci_query(&data);
+		if (r || !data)
+			break;
+
+		pr_debug(PFX "SCI 0x%x received\n", data);
+
+		switch (data) {
+		case EC_SCI_SRC_BATERR:
+		case EC_SCI_SRC_BATSOC:
+		case EC_SCI_SRC_BATTERY:
+		case EC_SCI_SRC_BATCRIT:
+			battery_status_changed();
+			break;
+		case EC_SCI_SRC_ACPWR:
+			ac_status_changed();
+			break;
+		}
+	} while (data);
+
+	if (r)
+		pr_err(PFX "Failed to clear SCI queue");
+}
+
+static void process_sci_queue_work(struct work_struct *work)
+{
+	process_sci_queue();
+}
+
+static DECLARE_WORK(sci_work, process_sci_queue_work);
+
+static u32 xo15_sci_gpe_handler(acpi_handle gpe_device, u32 gpe, void *context)
+{
+	schedule_work(&sci_work);
+	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
+}
+
+static int xo15_sci_add(struct acpi_device *device)
+{
+	unsigned long long tmp;
+	acpi_status status;
+
+	if (!device)
+		return -EINVAL;
+
+	strcpy(acpi_device_name(device), XO15_SCI_DEVICE_NAME);
+	strcpy(acpi_device_class(device), XO15_SCI_CLASS);
+
+	/* Get GPE bit assignment (EC events). */
+	status = acpi_evaluate_integer(device->handle, "_GPE", NULL, &tmp);
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	xo15_sci_gpe = tmp;
+	status = acpi_install_gpe_handler(NULL, xo15_sci_gpe,
+					  ACPI_GPE_EDGE_TRIGGERED,
+					  xo15_sci_gpe_handler, device);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
+
+	/* Flush queue, and enable all SCI events */
+	process_sci_queue();
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	acpi_enable_gpe(NULL, xo15_sci_gpe);
+
+	/* Enable wake-on-EC */
+	if (device->wakeup.flags.valid)
+		device_set_wakeup_enable(&device->dev, true);
+
+	return 0;
+}
+
+static int xo15_sci_remove(struct acpi_device *device, int type)
+{
+	acpi_disable_gpe(NULL, xo15_sci_gpe);
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return 0;
+}
+
+static int xo15_sci_resume(struct acpi_device *device)
+{
+	/* Enable all EC events */
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	/* Power/battery status might have changed */
+	battery_status_changed();
+	ac_status_changed();
+
+	return 0;
+}
+
+static const struct acpi_device_id xo15_sci_device_ids[] = {
+	{"XO15EC", 0},
+	{"", 0},
+};
+
+static struct acpi_driver xo15_sci_drv = {
+	.name = DRV_NAME,
+	.class = XO15_SCI_CLASS,
+	.ids = xo15_sci_device_ids,
+	.ops = {
+		.add = xo15_sci_add,
+		.remove = xo15_sci_remove,
+		.resume = xo15_sci_resume,
+	},
+};
+
+static int __init xo15_sci_init(void)
+{
+	return acpi_bus_register_driver(&xo15_sci_drv);
+}
+device_initcall(xo15_sci_init);
diff -puN arch/x86/platform/olpc/olpc.c~x86-olpc-add-xo-15-sci-driver arch/x86/platform/olpc/olpc.c
--- a/arch/x86/platform/olpc/olpc.c~x86-olpc-add-xo-15-sci-driver
+++ a/arch/x86/platform/olpc/olpc.c
@@ -222,6 +222,15 @@ bool olpc_ec_wakeup_available(void)
 		return true;
 #endif
 
+	/*
+	 * XO-1.5 EC wakeups are available when olpc-xo15-sci driver is
+	 * compiled in
+	 */
+#ifdef CONFIG_OLPC_XO15_SCI
+	if (olpc_platform_info.boardrev >= olpc_board_pre(0xd0)) /* XO-1.5 */
+		return true;
+#endif
+
 	return false;
 }
 EXPORT_SYMBOL_GPL(olpc_ec_wakeup_available);
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

