From: akpm@linux-foundation.org
Subject: + cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch added to -mm tree
Date: Wed, 19 Aug 2009 15:19:07 -0700
Message-ID: <200908192219.n7JMJ7B8003375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbZHSWTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 18:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, david-b@pacbell.net, jordan@cosmicpenguin.net, tiwai@suse.de


The patch titled
     cs5535-gpio: add AMD CS5535/CS5536 GPIO driver support
has been added to the -mm tree.  Its filename is
     cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch

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
Subject: cs5535-gpio: add AMD CS5535/CS5536 GPIO driver support
From: Andres Salomon <dilinger@collabora.co.uk>

This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip backend
(allowing GPIO users to use the generic GPIO API if desired) while also
allowing architecture-specific users directly (via the cs5535_gpio_*
functions).

Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a mips
cpu), which is why this is in drivers/gpio rather than arch/x86. 
Currently, it conflicts with older geode GPIO support; once MFGPT support
is reworked to also be more generic, the older geode code will be removed.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/geode.h |   28 ---
 drivers/gpio/Kconfig         |   10 +
 drivers/gpio/Makefile        |    1 
 drivers/gpio/cs5535-gpio.c   |  282 +++++++++++++++++++++++++++++++++
 include/linux/cs5535.h       |   58 ++++++
 5 files changed, 352 insertions(+), 27 deletions(-)

diff -puN arch/x86/include/asm/geode.h~cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support arch/x86/include/asm/geode.h
--- a/arch/x86/include/asm/geode.h~cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support
+++ a/arch/x86/include/asm/geode.h
@@ -12,6 +12,7 @@
 
 #include <asm/processor.h>
 #include <linux/io.h>
+#include <linux/cs5535.h>
 
 /* Generic southbridge functions */
 
@@ -115,33 +116,6 @@ extern int geode_get_dev_base(unsigned i
 #define VSA_VR_MEM_SIZE		0x0200
 #define AMD_VSA_SIG		0x4132	/* signature is ascii 'VSA2' */
 #define GSW_VSA_SIG		0x534d  /* General Software signature */
-/* GPIO */
-
-#define GPIO_OUTPUT_VAL		0x00
-#define GPIO_OUTPUT_ENABLE	0x04
-#define GPIO_OUTPUT_OPEN_DRAIN	0x08
-#define GPIO_OUTPUT_INVERT	0x0C
-#define GPIO_OUTPUT_AUX1	0x10
-#define GPIO_OUTPUT_AUX2	0x14
-#define GPIO_PULL_UP		0x18
-#define GPIO_PULL_DOWN		0x1C
-#define GPIO_INPUT_ENABLE	0x20
-#define GPIO_INPUT_INVERT	0x24
-#define GPIO_INPUT_FILTER	0x28
-#define GPIO_INPUT_EVENT_COUNT	0x2C
-#define GPIO_READ_BACK		0x30
-#define GPIO_INPUT_AUX1		0x34
-#define GPIO_EVENTS_ENABLE	0x38
-#define GPIO_LOCK_ENABLE	0x3C
-#define GPIO_POSITIVE_EDGE_EN	0x40
-#define GPIO_NEGATIVE_EDGE_EN	0x44
-#define GPIO_POSITIVE_EDGE_STS	0x48
-#define GPIO_NEGATIVE_EDGE_STS	0x4C
-
-#define GPIO_MAP_X		0xE0
-#define GPIO_MAP_Y		0xE4
-#define GPIO_MAP_Z		0xE8
-#define GPIO_MAP_W		0xEC
 
 static inline u32 geode_gpio(unsigned int nr)
 {
diff -puN drivers/gpio/Kconfig~cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support
+++ a/drivers/gpio/Kconfig
@@ -164,6 +164,16 @@ config GPIO_WM831X
 
 comment "PCI GPIO expanders:"
 
+config GPIO_CS5535
+	tristate "AMD CS5535/CS5536 GPIO support"
+	depends on PCI && !CS5535_GPIO && !MGEODE_LX
+	help
+	  The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
+	  can be used for quite a number of things.  The CS5535/6 is found on
+	  AMD Geode and Lemote Yeeloong devices.
+
+	  If unsure, say N.
+
 config GPIO_BT8XX
 	tristate "BT8XX GPIO abuser"
 	depends on PCI && VIDEO_BT848=n
diff -puN drivers/gpio/Makefile~cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support
+++ a/drivers/gpio/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_UCB1400)	+= ucb1400_gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
+obj-$(CONFIG_GPIO_CS5535)	+= cs5535-gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
 obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
diff -puN /dev/null drivers/gpio/cs5535-gpio.c
--- /dev/null
+++ a/drivers/gpio/cs5535-gpio.c
@@ -0,0 +1,282 @@
+/*
+ * AMD CS5535/CS5536 GPIO driver
+ * Copyright (C) 2006  Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2009  Andres Salomon <dilinger@collabora.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/cs5535.h>
+
+#define DRV_NAME "cs5535-gpio"
+#define GPIO_BAR 1
+
+static struct cs5535_gpio_chip {
+	struct gpio_chip chip;
+	resource_size_t base;
+
+	struct pci_dev *pdev;
+	spinlock_t lock;
+} cs5535_gpio_chip;
+
+/*
+ * The CS5535/CS5536 GPIOs support a number of extra features not defined
+ * by the gpio_chip API, so these are exported.  For a full list of the
+ * registers, see include/linux/cs5535.h.
+ */
+
+static void __cs5535_gpio_set(struct cs5535_gpio_chip *chip, unsigned offset,
+		unsigned int reg)
+{
+	if (offset < 16)
+		/* low bank register */
+		outl(1 << offset, chip->base + reg);
+	else
+		/* high bank register */
+		outl(1 << (offset - 16), chip->base + 0x80 + reg);
+}
+
+void cs5535_gpio_set(unsigned offset, unsigned int reg)
+{
+	struct cs5535_gpio_chip *chip = &cs5535_gpio_chip;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	__cs5535_gpio_set(chip, offset, reg);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+EXPORT_SYMBOL_GPL(cs5535_gpio_set);
+
+static void __cs5535_gpio_clear(struct cs5535_gpio_chip *chip, unsigned offset,
+		unsigned int reg)
+{
+	if (offset < 16)
+		/* low bank register */
+		outl(1 << (offset + 16), chip->base + reg);
+	else
+		/* high bank register */
+		outl(1 << offset, chip->base + 0x80 + reg);
+}
+
+void cs5535_gpio_clear(unsigned offset, unsigned int reg)
+{
+	struct cs5535_gpio_chip *chip = &cs5535_gpio_chip;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	__cs5535_gpio_clear(chip, offset, reg);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+EXPORT_SYMBOL_GPL(cs5535_gpio_clear);
+
+int cs5535_gpio_isset(unsigned offset, unsigned int reg)
+{
+	struct cs5535_gpio_chip *chip = &cs5535_gpio_chip;
+	unsigned long flags;
+	long val;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	if (offset < 16)
+		/* low bank register */
+		val = inl(chip->base + reg);
+	else {
+		/* high bank register */
+		val = inl(chip->base + 0x80 + reg);
+		offset -= 16;
+	}
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return (val & (1 << offset)) ? 1 : 0;
+}
+EXPORT_SYMBOL_GPL(cs5535_gpio_isset);
+
+/*
+ * Generic gpio_chip API support.
+ */
+
+static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
+}
+
+static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	if (val)
+		cs5535_gpio_set(offset, GPIO_OUTPUT_VAL);
+	else
+		cs5535_gpio_clear(offset, GPIO_OUTPUT_VAL);
+}
+
+static int chip_direction_input(struct gpio_chip *c, unsigned offset)
+{
+	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static int chip_direction_output(struct gpio_chip *c, unsigned offset, int val)
+{
+	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+
+	__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
+	if (val)
+		__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
+	else
+		__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_VAL);
+
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static struct cs5535_gpio_chip cs5535_gpio_chip = {
+	.chip = {
+		.owner = THIS_MODULE,
+		.label = DRV_NAME,
+
+		.base = 0,
+		.ngpio = 28,
+
+		.get = chip_gpio_get,
+		.set = chip_gpio_set,
+
+		.direction_input = chip_direction_input,
+		.direction_output = chip_direction_output,
+	},
+};
+
+static int __init cs5535_gpio_probe(struct pci_dev *pdev,
+		const struct pci_device_id *pci_id)
+{
+	int err;
+
+	/* There are two ways to get the GPIO base address; one is by
+	 * fetching it from MSR_LBAR_GPIO, the other is by reading the
+	 * PCI BAR info.  The latter method is easier (especially across
+	 * different architectures), so we'll stick with that for now.  If
+	 * it turns out to be unreliable in the face of crappy BIOSes, we
+	 * can always go back to using MSRs.. */
+
+	err = pci_enable_device_io(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "can't enable device IO\n");
+		goto done;
+	}
+
+	err = pci_request_region(pdev, GPIO_BAR, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", GPIO_BAR);
+		goto done;
+	}
+
+	/* set up the driver-specific struct */
+	cs5535_gpio_chip.base = pci_resource_start(pdev, GPIO_BAR);
+	cs5535_gpio_chip.pdev = pdev;
+	spin_lock_init(&cs5535_gpio_chip.lock);
+
+	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
+			(unsigned long long) cs5535_gpio_chip.base);
+
+	/* finally, register with the generic GPIO API */
+	err = gpiochip_add(&cs5535_gpio_chip.chip);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register gpio chip\n");
+		goto release_region;
+	}
+
+	printk(KERN_INFO DRV_NAME ": GPIO support successfully loaded.\n");
+	return 0;
+
+release_region:
+	pci_release_region(pdev, GPIO_BAR);
+done:
+	return err;
+}
+
+static void __exit cs5535_gpio_remove(struct pci_dev *pdev)
+{
+	int err;
+
+	err = gpiochip_remove(&cs5535_gpio_chip.chip);
+	if (err) {
+		/* uhh? */
+		dev_err(&pdev->dev, "unable to remove gpio_chip?\n");
+	}
+	pci_release_region(pdev, GPIO_BAR);
+}
+
+static struct pci_device_id cs5535_gpio_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, cs5535_gpio_pci_tbl);
+
+/*
+ * We can't use the standard PCI driver registration stuff here, since
+ * that allows only one driver to bind to each PCI device (and we want
+ * multiple drivers to be able to bind to the device).  Instead, manually
+ * scan for the PCI device, request a single region, and keep track of the
+ * devices that we're using.
+ */
+
+static int __init cs5535_gpio_scan_pci(void)
+{
+	struct pci_dev *pdev;
+	int err = -ENODEV;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cs5535_gpio_pci_tbl); i++) {
+		pdev = pci_get_device(cs5535_gpio_pci_tbl[i].vendor,
+				cs5535_gpio_pci_tbl[i].device, NULL);
+		if (pdev) {
+			err = cs5535_gpio_probe(pdev, &cs5535_gpio_pci_tbl[i]);
+			if (err)
+				pci_dev_put(pdev);
+
+			/* we only support a single CS5535/6 southbridge */
+			break;
+		}
+	}
+
+	return err;
+}
+
+static void __exit cs5535_gpio_free_pci(void)
+{
+	cs5535_gpio_remove(cs5535_gpio_chip.pdev);
+	pci_dev_put(cs5535_gpio_chip.pdev);
+}
+
+static int __init cs5535_gpio_init(void)
+{
+	return cs5535_gpio_scan_pci();
+}
+
+static void __exit cs5535_gpio_exit(void)
+{
+	cs5535_gpio_free_pci();
+}
+
+module_init(cs5535_gpio_init);
+module_exit(cs5535_gpio_exit);
+
+MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/cs5535.h
--- /dev/null
+++ a/include/linux/cs5535.h
@@ -0,0 +1,58 @@
+/*
+ * AMD CS5535/CS5536 definitions
+ * Copyright (C) 2006  Advanced Micro Devices, Inc.
+ * Copyright (C) 2009  Andres Salomon <dilinger@collabora.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _CS5535_H
+#define _CS5535_H
+
+/* MSRs */
+#define MSR_LBAR_SMB		0x5140000B
+#define MSR_LBAR_GPIO		0x5140000C
+#define MSR_LBAR_MFGPT		0x5140000D
+#define MSR_LBAR_ACPI		0x5140000E
+#define MSR_LBAR_PMS		0x5140000F
+
+/* resource sizes */
+#define LBAR_GPIO_SIZE		0xFF
+#define LBAR_MFGPT_SIZE		0x40
+#define LBAR_ACPI_SIZE		0x40
+#define LBAR_PMS_SIZE		0x80
+
+/* GPIOs */
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
+void cs5535_gpio_set(unsigned offset, unsigned int reg);
+void cs5535_gpio_clear(unsigned offset, unsigned int reg);
+int cs5535_gpio_isset(unsigned offset, unsigned int reg);
+
+#endif
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

linux-next.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

