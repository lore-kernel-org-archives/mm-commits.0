From: akpm@linux-foundation.org
Subject: + cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch added to -mm tree
Date: Tue, 10 Nov 2009 16:41:11 -0800
Message-ID: <200911110041.nAB0fBS5013802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbZKKAll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 19:41:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, cjb@laptop.org, johnstul@us.ibm.com, jordan@cosmicpenguin.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     cs5535: drop the Geode-specific MFGPT/GPIO code
has been added to the -mm tree.  Its filename is
     cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch

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
Subject: cs5535: drop the Geode-specific MFGPT/GPIO code
From: Andres Salomon <dilinger@collabora.co.uk>

With generic modular drivers handling all of this stuff, the
geode-specific code can go away.  The cs5535-gpio, cs5535-mfgpt, and
cs5535-clockevt drivers now handle this.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/x86/Kconfig~cs5535-drop-the-geode-specific-mfgpt-gpio-code arch/x86/Kconfig
--- a/arch/x86/Kconfig~cs5535-drop-the-geode-specific-mfgpt-gpio-code
+++ a/arch/x86/Kconfig
@@ -2016,16 +2016,6 @@ config SCx200HR_TIMER
 	  processor goes idle (as is done by the scheduler).  The
 	  other workaround is idle=poll boot option.
 
-config GEODE_MFGPT_TIMER
-	def_bool y
-	prompt "Geode Multi-Function General Purpose Timer (MFGPT) events"
-	depends on MGEODE_LX && GENERIC_TIME && GENERIC_CLOCKEVENTS
-	---help---
-	  This driver provides a clock event source based on the MFGPT
-	  timer(s) in the CS5535 and CS5536 companion chip for the geode.
-	  MFGPTs have a better resolution and max interval than the
-	  generic PIT, and are suitable for use as high-res timers.
-
 config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
diff -puN arch/x86/include/asm/geode.h~cs5535-drop-the-geode-specific-mfgpt-gpio-code arch/x86/include/asm/geode.h
--- a/arch/x86/include/asm/geode.h~cs5535-drop-the-geode-specific-mfgpt-gpio-code
+++ a/arch/x86/include/asm/geode.h
@@ -14,98 +14,6 @@
 #include <linux/io.h>
 #include <linux/cs5535.h>
 
-/* Generic southbridge functions */
-
-#define GEODE_DEV_PMS 0
-#define GEODE_DEV_ACPI 1
-#define GEODE_DEV_GPIO 2
-#define GEODE_DEV_MFGPT 3
-
-extern int geode_get_dev_base(unsigned int dev);
-
-/* Useful macros */
-#define geode_pms_base()	geode_get_dev_base(GEODE_DEV_PMS)
-#define geode_acpi_base()	geode_get_dev_base(GEODE_DEV_ACPI)
-#define geode_gpio_base()	geode_get_dev_base(GEODE_DEV_GPIO)
-#define geode_mfgpt_base()	geode_get_dev_base(GEODE_DEV_MFGPT)
-
-/* MSRS */
-
-#define MSR_LBAR_SMB		0x5140000B
-#define MSR_LBAR_GPIO		0x5140000C
-#define MSR_LBAR_MFGPT		0x5140000D
-#define MSR_LBAR_ACPI		0x5140000E
-#define MSR_LBAR_PMS		0x5140000F
-
-/* Resource Sizes */
-
-#define LBAR_GPIO_SIZE		0xFF
-#define LBAR_MFGPT_SIZE		0x40
-#define LBAR_ACPI_SIZE		0x40
-#define LBAR_PMS_SIZE		0x80
-
-/* ACPI registers (PMS block) */
-
-/*
- * PM1_EN is only valid when VSA is enabled for 16 bit reads.
- * When VSA is not enabled, *always* read both PM1_STS and PM1_EN
- * with a 32 bit read at offset 0x0
- */
-
-#define PM1_STS			0x00
-#define PM1_EN			0x02
-#define PM1_CNT			0x08
-#define PM2_CNT			0x0C
-#define PM_TMR			0x10
-#define PM_GPE0_STS		0x18
-#define PM_GPE0_EN		0x1C
-
-/* PMC registers (PMS block) */
-
-#define PM_SSD			0x00
-#define PM_SCXA			0x04
-#define PM_SCYA			0x08
-#define PM_OUT_SLPCTL		0x0C
-#define PM_SCLK			0x10
-#define PM_SED			0x1
-#define PM_SCXD			0x18
-#define PM_SCYD			0x1C
-#define PM_IN_SLPCTL		0x20
-#define PM_WKD			0x30
-#define PM_WKXD			0x34
-#define PM_RD			0x38
-#define PM_WKXA			0x3C
-#define PM_FSD			0x40
-#define PM_TSD			0x44
-#define PM_PSD			0x48
-#define PM_NWKD			0x4C
-#define PM_AWKD			0x50
-#define PM_SSC			0x54
-
-static inline u32 geode_gpio(unsigned int nr)
-{
-	BUG_ON(nr > 28);
-	return 1 << nr;
-}
-
-extern void geode_gpio_set(u32, unsigned int);
-extern void geode_gpio_clear(u32, unsigned int);
-extern int geode_gpio_isset(u32, unsigned int);
-extern void geode_gpio_setup_event(unsigned int, int, int);
-extern void geode_gpio_set_irq(unsigned int, unsigned int);
-
-static inline void geode_gpio_event_irq(unsigned int gpio, int pair)
-{
-	geode_gpio_setup_event(gpio, pair, 0);
-}
-
-static inline void geode_gpio_event_pme(unsigned int gpio, int pair)
-{
-	geode_gpio_setup_event(gpio, pair, 1);
-}
-
-/* Specific geode tests */
-
 static inline int is_geode_gx(void)
 {
 	return ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC) &&
@@ -125,29 +33,4 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
-static inline void geode_mfgpt_write(int timer, u16 reg, u16 value)
-{
-	u32 base = geode_get_dev_base(GEODE_DEV_MFGPT);
-	outw(value, base + reg + (timer * 8));
-}
-
-static inline u16 geode_mfgpt_read(int timer, u16 reg)
-{
-	u32 base = geode_get_dev_base(GEODE_DEV_MFGPT);
-	return inw(base + reg + (timer * 8));
-}
-
-extern int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable);
-extern int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable);
-extern int geode_mfgpt_alloc_timer(int timer, int domain);
-
-#define geode_mfgpt_setup_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 1)
-#define geode_mfgpt_release_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 0)
-
-#ifdef CONFIG_GEODE_MFGPT_TIMER
-extern int __init mfgpt_timer_setup(void);
-#else
-static inline int mfgpt_timer_setup(void) { return 0; }
-#endif
-
 #endif /* _ASM_X86_GEODE_H */
diff -puN arch/x86/kernel/Makefile~cs5535-drop-the-geode-specific-mfgpt-gpio-code arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~cs5535-drop-the-geode-specific-mfgpt-gpio-code
+++ a/arch/x86/kernel/Makefile
@@ -89,7 +89,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 
 obj-$(CONFIG_K8_NB)		+= k8.o
-obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
diff -puN arch/x86/kernel/geode_32.c~cs5535-drop-the-geode-specific-mfgpt-gpio-code /dev/null
--- a/arch/x86/kernel/geode_32.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/*
- * AMD Geode southbridge support code
- * Copyright (C) 2006, Advanced Micro Devices, Inc.
- * Copyright (C) 2007, Andres Salomon <dilinger@debian.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public License
- * as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/ioport.h>
-#include <linux/io.h>
-#include <asm/msr.h>
-#include <asm/geode.h>
-
-static struct {
-	char *name;
-	u32 msr;
-	int size;
-	u32 base;
-} lbars[] = {
-	{ "geode-pms",   MSR_LBAR_PMS, LBAR_PMS_SIZE, 0 },
-	{ "geode-acpi",  MSR_LBAR_ACPI, LBAR_ACPI_SIZE, 0 },
-	{ "geode-gpio",  MSR_LBAR_GPIO, LBAR_GPIO_SIZE, 0 },
-	{ "geode-mfgpt", MSR_LBAR_MFGPT, LBAR_MFGPT_SIZE, 0 }
-};
-
-static void __init init_lbars(void)
-{
-	u32 lo, hi;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(lbars); i++) {
-		rdmsr(lbars[i].msr, lo, hi);
-		if (hi & 0x01)
-			lbars[i].base = lo & 0x0000ffff;
-
-		if (lbars[i].base == 0)
-			printk(KERN_ERR "geode:  Couldn't initialize '%s'\n",
-					lbars[i].name);
-	}
-}
-
-int geode_get_dev_base(unsigned int dev)
-{
-	BUG_ON(dev >= ARRAY_SIZE(lbars));
-	return lbars[dev].base;
-}
-EXPORT_SYMBOL_GPL(geode_get_dev_base);
-
-/* === GPIO API === */
-
-void geode_gpio_set(u32 gpio, unsigned int reg)
-{
-	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
-
-	if (!base)
-		return;
-
-	/* low bank register */
-	if (gpio & 0xFFFF)
-		outl(gpio & 0xFFFF, base + reg);
-	/* high bank register */
-	gpio >>= 16;
-	if (gpio)
-		outl(gpio, base + 0x80 + reg);
-}
-EXPORT_SYMBOL_GPL(geode_gpio_set);
-
-void geode_gpio_clear(u32 gpio, unsigned int reg)
-{
-	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
-
-	if (!base)
-		return;
-
-	/* low bank register */
-	if (gpio & 0xFFFF)
-		outl((gpio & 0xFFFF) << 16, base + reg);
-	/* high bank register */
-	gpio &= (0xFFFF << 16);
-	if (gpio)
-		outl(gpio, base + 0x80 + reg);
-}
-EXPORT_SYMBOL_GPL(geode_gpio_clear);
-
-int geode_gpio_isset(u32 gpio, unsigned int reg)
-{
-	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
-	u32 val;
-
-	if (!base)
-		return 0;
-
-	/* low bank register */
-	if (gpio & 0xFFFF) {
-		val = inl(base + reg) & (gpio & 0xFFFF);
-		if ((gpio & 0xFFFF) == val)
-			return 1;
-	}
-	/* high bank register */
-	gpio >>= 16;
-	if (gpio) {
-		val = inl(base + 0x80 + reg) & gpio;
-		if (gpio == val)
-			return 1;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(geode_gpio_isset);
-
-void geode_gpio_set_irq(unsigned int group, unsigned int irq)
-{
-	u32 lo, hi;
-
-	if (group > 7 || irq > 15)
-		return;
-
-	rdmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
-
-	lo &= ~(0xF << (group * 4));
-	lo |= (irq & 0xF) << (group * 4);
-
-	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
-}
-EXPORT_SYMBOL_GPL(geode_gpio_set_irq);
-
-void geode_gpio_setup_event(unsigned int gpio, int pair, int pme)
-{
-	u32 base = geode_get_dev_base(GEODE_DEV_GPIO);
-	u32 offset, shift, val;
-
-	if (gpio >= 24)
-		offset = GPIO_MAP_W;
-	else if (gpio >= 16)
-		offset = GPIO_MAP_Z;
-	else if (gpio >= 8)
-		offset = GPIO_MAP_Y;
-	else
-		offset = GPIO_MAP_X;
-
-	shift = (gpio % 8) * 4;
-
-	val = inl(base + offset);
-
-	/* Clear whatever was there before */
-	val &= ~(0xF << shift);
-
-	/* And set the new value */
-
-	val |= ((pair & 7) << shift);
-
-	/* Set the PME bit if this is a PME event */
-
-	if (pme)
-		val |= (1 << (shift + 3));
-
-	outl(val, base + offset);
-}
-EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
-
-static int __init geode_southbridge_init(void)
-{
-	if (!is_geode())
-		return -ENODEV;
-
-	init_lbars();
-	(void) mfgpt_timer_setup();
-	return 0;
-}
-
-postcore_initcall(geode_southbridge_init);
diff -puN arch/x86/kernel/mfgpt_32.c~cs5535-drop-the-geode-specific-mfgpt-gpio-code /dev/null
--- a/arch/x86/kernel/mfgpt_32.c
+++ /dev/null
@@ -1,410 +0,0 @@
-/*
- * Driver/API for AMD Geode Multi-Function General Purpose Timers (MFGPT)
- *
- * Copyright (C) 2006, Advanced Micro Devices, Inc.
- * Copyright (C) 2007, Andres Salomon <dilinger@debian.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public License
- * as published by the Free Software Foundation.
- *
- * The MFGPTs are documented in AMD Geode CS5536 Companion Device Data Book.
- */
-
-/*
- * We are using the 32.768kHz input clock - it's the only one that has the
- * ranges we find desirable.  The following table lists the suitable
- * divisors and the associated Hz, minimum interval and the maximum interval:
- *
- *  Divisor   Hz      Min Delta (s)  Max Delta (s)
- *   1        32768   .00048828125      2.000
- *   2        16384   .0009765625       4.000
- *   4         8192   .001953125        8.000
- *   8         4096   .00390625        16.000
- *   16        2048   .0078125         32.000
- *   32        1024   .015625          64.000
- *   64         512   .03125          128.000
- *  128         256   .0625           256.000
- *  256         128   .125            512.000
- */
-
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <asm/geode.h>
-
-#define MFGPT_DEFAULT_IRQ	7
-
-static struct mfgpt_timer_t {
-	unsigned int avail:1;
-} mfgpt_timers[MFGPT_MAX_TIMERS];
-
-/* Selected from the table above */
-
-#define MFGPT_DIVISOR 16
-#define MFGPT_SCALE  4     /* divisor = 2^(scale) */
-#define MFGPT_HZ  (32768 / MFGPT_DIVISOR)
-#define MFGPT_PERIODIC (MFGPT_HZ / HZ)
-
-/* Allow for disabling of MFGPTs */
-static int disable;
-static int __init mfgpt_disable(char *s)
-{
-	disable = 1;
-	return 1;
-}
-__setup("nomfgpt", mfgpt_disable);
-
-/* Reset the MFGPT timers. This is required by some broken BIOSes which already
- * do the same and leave the system in an unstable state. TinyBIOS 0.98 is
- * affected at least (0.99 is OK with MFGPT workaround left to off).
- */
-static int __init mfgpt_fix(char *s)
-{
-	u32 val, dummy;
-
-	/* The following udocumented bit resets the MFGPT timers */
-	val = 0xFF; dummy = 0;
-	wrmsr(MSR_MFGPT_SETUP, val, dummy);
-	return 1;
-}
-__setup("mfgptfix", mfgpt_fix);
-
-/*
- * Check whether any MFGPTs are available for the kernel to use.  In most
- * cases, firmware that uses AMD's VSA code will claim all timers during
- * bootup; we certainly don't want to take them if they're already in use.
- * In other cases (such as with VSAless OpenFirmware), the system firmware
- * leaves timers available for us to use.
- */
-
-
-static int timers = -1;
-
-static void geode_mfgpt_detect(void)
-{
-	int i;
-	u16 val;
-
-	timers = 0;
-
-	if (disable) {
-		printk(KERN_INFO "geode-mfgpt:  MFGPT support is disabled\n");
-		goto done;
-	}
-
-	if (!geode_get_dev_base(GEODE_DEV_MFGPT)) {
-		printk(KERN_INFO "geode-mfgpt:  MFGPT LBAR is not set up\n");
-		goto done;
-	}
-
-	for (i = 0; i < MFGPT_MAX_TIMERS; i++) {
-		val = geode_mfgpt_read(i, MFGPT_REG_SETUP);
-		if (!(val & MFGPT_SETUP_SETUP)) {
-			mfgpt_timers[i].avail = 1;
-			timers++;
-		}
-	}
-
-done:
-	printk(KERN_INFO "geode-mfgpt:  %d MFGPT timers available.\n", timers);
-}
-
-int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable)
-{
-	u32 msr, mask, value, dummy;
-	int shift = (cmp == MFGPT_CMP1) ? 0 : 8;
-
-	if (timer < 0 || timer >= MFGPT_MAX_TIMERS)
-		return -EIO;
-
-	/*
-	 * The register maps for these are described in sections 6.17.1.x of
-	 * the AMD Geode CS5536 Companion Device Data Book.
-	 */
-	switch (event) {
-	case MFGPT_EVENT_RESET:
-		/*
-		 * XXX: According to the docs, we cannot reset timers above
-		 * 6; that is, resets for 7 and 8 will be ignored.  Is this
-		 * a problem?   -dilinger
-		 */
-		msr = MSR_MFGPT_NR;
-		mask = 1 << (timer + 24);
-		break;
-
-	case MFGPT_EVENT_NMI:
-		msr = MSR_MFGPT_NR;
-		mask = 1 << (timer + shift);
-		break;
-
-	case MFGPT_EVENT_IRQ:
-		msr = MSR_MFGPT_IRQ;
-		mask = 1 << (timer + shift);
-		break;
-
-	default:
-		return -EIO;
-	}
-
-	rdmsr(msr, value, dummy);
-
-	if (enable)
-		value |= mask;
-	else
-		value &= ~mask;
-
-	wrmsr(msr, value, dummy);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
-
-int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable)
-{
-	u32 zsel, lpc, dummy;
-	int shift;
-
-	if (timer < 0 || timer >= MFGPT_MAX_TIMERS)
-		return -EIO;
-
-	/*
-	 * Unfortunately, MFGPTs come in pairs sharing their IRQ lines. If VSA
-	 * is using the same CMP of the timer's Siamese twin, the IRQ is set to
-	 * 2, and we mustn't use nor change it.
-	 * XXX: Likewise, 2 Linux drivers might clash if the 2nd overwrites the
-	 * IRQ of the 1st. This can only happen if forcing an IRQ, calling this
-	 * with *irq==0 is safe. Currently there _are_ no 2 drivers.
-	 */
-	rdmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
-	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer % 4) * 4;
-	if (((zsel >> shift) & 0xF) == 2)
-		return -EIO;
-
-	/* Choose IRQ: if none supplied, keep IRQ already set or use default */
-	if (!*irq)
-		*irq = (zsel >> shift) & 0xF;
-	if (!*irq)
-		*irq = MFGPT_DEFAULT_IRQ;
-
-	/* Can't use IRQ if it's 0 (=disabled), 2, or routed to LPC */
-	if (*irq < 1 || *irq == 2 || *irq > 15)
-		return -EIO;
-	rdmsr(MSR_PIC_IRQM_LPC, lpc, dummy);
-	if (lpc & (1 << *irq))
-		return -EIO;
-
-	/* All chosen and checked - go for it */
-	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
-		return -EIO;
-	if (enable) {
-		zsel = (zsel & ~(0xF << shift)) | (*irq << shift);
-		wrmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
-	}
-
-	return 0;
-}
-
-static int mfgpt_get(int timer)
-{
-	mfgpt_timers[timer].avail = 0;
-	printk(KERN_INFO "geode-mfgpt:  Registered timer %d\n", timer);
-	return timer;
-}
-
-int geode_mfgpt_alloc_timer(int timer, int domain)
-{
-	int i;
-
-	if (timers == -1) {
-		/* timers haven't been detected yet */
-		geode_mfgpt_detect();
-	}
-
-	if (!timers)
-		return -1;
-
-	if (timer >= MFGPT_MAX_TIMERS)
-		return -1;
-
-	if (timer < 0) {
-		/* Try to find an available timer */
-		for (i = 0; i < MFGPT_MAX_TIMERS; i++) {
-			if (mfgpt_timers[i].avail)
-				return mfgpt_get(i);
-
-			if (i == 5 && domain == MFGPT_DOMAIN_WORKING)
-				break;
-		}
-	} else {
-		/* If they requested a specific timer, try to honor that */
-		if (mfgpt_timers[timer].avail)
-			return mfgpt_get(timer);
-	}
-
-	/* No timers available - too bad */
-	return -1;
-}
-EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
-
-
-#ifdef CONFIG_GEODE_MFGPT_TIMER
-
-/*
- * The MFPGT timers on the CS5536 provide us with suitable timers to use
- * as clock event sources - not as good as a HPET or APIC, but certainly
- * better than the PIT.  This isn't a general purpose MFGPT driver, but
- * a simplified one designed specifically to act as a clock event source.
- * For full details about the MFGPT, please consult the CS5536 data sheet.
- */
-
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-
-static unsigned int mfgpt_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
-static u16 mfgpt_event_clock;
-
-static int irq;
-static int __init mfgpt_setup(char *str)
-{
-	get_option(&str, &irq);
-	return 1;
-}
-__setup("mfgpt_irq=", mfgpt_setup);
-
-static void mfgpt_disable_timer(u16 clock)
-{
-	/* avoid races by clearing CMP1 and CMP2 unconditionally */
-	geode_mfgpt_write(clock, MFGPT_REG_SETUP, (u16) ~MFGPT_SETUP_CNTEN |
-			MFGPT_SETUP_CMP1 | MFGPT_SETUP_CMP2);
-}
-
-static int mfgpt_next_event(unsigned long, struct clock_event_device *);
-static void mfgpt_set_mode(enum clock_event_mode, struct clock_event_device *);
-
-static struct clock_event_device mfgpt_clockevent = {
-	.name = "mfgpt-timer",
-	.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode = mfgpt_set_mode,
-	.set_next_event = mfgpt_next_event,
-	.rating = 250,
-	.cpumask = cpu_all_mask,
-	.shift = 32
-};
-
-static void mfgpt_start_timer(u16 delta)
-{
-	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_CMP2, (u16) delta);
-	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_COUNTER, 0);
-
-	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP,
-			  MFGPT_SETUP_CNTEN | MFGPT_SETUP_CMP2);
-}
-
-static void mfgpt_set_mode(enum clock_event_mode mode,
-			   struct clock_event_device *evt)
-{
-	mfgpt_disable_timer(mfgpt_event_clock);
-
-	if (mode == CLOCK_EVT_MODE_PERIODIC)
-		mfgpt_start_timer(MFGPT_PERIODIC);
-
-	mfgpt_tick_mode = mode;
-}
-
-static int mfgpt_next_event(unsigned long delta, struct clock_event_device *evt)
-{
-	mfgpt_start_timer(delta);
-	return 0;
-}
-
-static irqreturn_t mfgpt_tick(int irq, void *dev_id)
-{
-	u16 val = geode_mfgpt_read(mfgpt_event_clock, MFGPT_REG_SETUP);
-
-	/* See if the interrupt was for us */
-	if (!(val & (MFGPT_SETUP_SETUP  | MFGPT_SETUP_CMP2 | MFGPT_SETUP_CMP1)))
-		return IRQ_NONE;
-
-	/* Turn off the clock (and clear the event) */
-	mfgpt_disable_timer(mfgpt_event_clock);
-
-	if (mfgpt_tick_mode == CLOCK_EVT_MODE_SHUTDOWN)
-		return IRQ_HANDLED;
-
-	/* Clear the counter */
-	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_COUNTER, 0);
-
-	/* Restart the clock in periodic mode */
-
-	if (mfgpt_tick_mode == CLOCK_EVT_MODE_PERIODIC) {
-		geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP,
-				  MFGPT_SETUP_CNTEN | MFGPT_SETUP_CMP2);
-	}
-
-	mfgpt_clockevent.event_handler(&mfgpt_clockevent);
-	return IRQ_HANDLED;
-}
-
-static struct irqaction mfgptirq  = {
-	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
-	.name = "mfgpt-timer"
-};
-
-int __init mfgpt_timer_setup(void)
-{
-	int timer, ret;
-	u16 val;
-
-	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
-	if (timer < 0) {
-		printk(KERN_ERR
-		       "mfgpt-timer:  Could not allocate a MFPGT timer\n");
-		return -ENODEV;
-	}
-
-	mfgpt_event_clock = timer;
-
-	/* Set up the IRQ on the MFGPT side */
-	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, &irq)) {
-		printk(KERN_ERR "mfgpt-timer:  Could not set up IRQ %d\n", irq);
-		return -EIO;
-	}
-
-	/* And register it with the kernel */
-	ret = setup_irq(irq, &mfgptirq);
-
-	if (ret) {
-		printk(KERN_ERR
-		       "mfgpt-timer:  Unable to set up the interrupt.\n");
-		goto err;
-	}
-
-	/* Set the clock scale and enable the event mode for CMP2 */
-	val = MFGPT_SCALE | (3 << 8);
-
-	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP, val);
-
-	/* Set up the clock event */
-	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC,
-				       mfgpt_clockevent.shift);
-	mfgpt_clockevent.min_delta_ns = clockevent_delta2ns(0xF,
-			&mfgpt_clockevent);
-	mfgpt_clockevent.max_delta_ns = clockevent_delta2ns(0xFFFE,
-			&mfgpt_clockevent);
-
-	printk(KERN_INFO
-	       "mfgpt-timer:  Registering MFGPT timer %d as a clock event, using IRQ %d\n",
-	       timer, irq);
-	clockevents_register_device(&mfgpt_clockevent);
-
-	return 0;
-
-err:
-	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, &irq);
-	printk(KERN_ERR
-	       "mfgpt-timer:  Unable to set up the MFGPT clock source\n");
-	return -EIO;
-}
-
-#endif
diff -puN drivers/gpio/Kconfig~cs5535-drop-the-geode-specific-mfgpt-gpio-code drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~cs5535-drop-the-geode-specific-mfgpt-gpio-code
+++ a/drivers/gpio/Kconfig
@@ -176,7 +176,7 @@ comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
 	tristate "AMD CS5535/CS5536 GPIO support"
-	depends on PCI && !CS5535_GPIO && !MGEODE_LX
+	depends on PCI && !CS5535_GPIO
 	help
 	  The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The CS5535/6 is found on
diff -puN drivers/misc/Kconfig~cs5535-drop-the-geode-specific-mfgpt-gpio-code drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~cs5535-drop-the-geode-specific-mfgpt-gpio-code
+++ a/drivers/misc/Kconfig
@@ -217,7 +217,7 @@ config SGI_XP
 
 config CS5535_MFGPT
 	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT) support"
-	depends on PCI && !MGEODE_LX
+	depends on PCI
 	default n
 	help
 	  This driver provides access to MFGPT functionality for other
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

linux-next.patch
drm-kill-some-unused-drm_proc-macros-from-drmph.patch
drm-kill-more-unused-drm-macros.patch
drm-replace-drm_copy-macro-w-a-function.patch
drm-check-return-values-in-drm_version.patch
cs5535-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs5535-gpio-request-function-mask-names-added.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch

