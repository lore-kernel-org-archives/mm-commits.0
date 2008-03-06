From: akpm@linux-foundation.org
Subject: - atmel_tc-library.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:23:45 -0800
Message-ID: <200803062223.m26MNjMk020913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755513AbYCFWYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:24:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, linux@maxim.org.za, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_tc library
has been removed from the -mm tree.  Its filename was
     atmel_tc-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_tc library
From: David Brownell <david-b@pacbell.net>

Create <linux/atmel_tc.h> based on <asm-arm/arch-at91/at91-tc.h> and the
at91sam9263 and at32ap7000 datasheets.  Most AT91 and AT32 SOCs have one or
two of these TC blocks, which include three 16-bit timers that can be
interconnected in various ways.

These TC blocks can be used for external interfacing (such as PWM and
measurement), or used as somewhat quirky sixteen-bit timers.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig       |    8 +
 drivers/misc/Makefile      |    1 
 drivers/misc/atmel_tclib.c |  107 ++++++++++++++++
 include/linux/atmel_tc.h   |  221 +++++++++++++++++++++++++++++++++++
 4 files changed, 337 insertions(+)

diff -puN drivers/misc/Kconfig~atmel_tc-library drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~atmel_tc-library
+++ a/drivers/misc/Kconfig
@@ -22,6 +22,14 @@ config ATMEL_PWM
 	  purposes including software controlled power-efficent backlights
 	  on LCD displays, motor control, and waveform generation.
 
+config ATMEL_TCLIB
+	bool "Atmel AT32/AT91 Timer/Counter Library"
+	depends on (AVR32 || ARCH_AT91)
+	help
+	  Select this if you want a library to allocate the Timer/Counter
+	  blocks found on many Atmel processors.  This facilitates using
+	  these blocks by different drivers despite processor differences.
+
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT && EXPERIMENTAL
diff -puN drivers/misc/Makefile~atmel_tc-library drivers/misc/Makefile
--- a/drivers/misc/Makefile~atmel_tc-library
+++ a/drivers/misc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
 obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
+obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
diff -puN /dev/null drivers/misc/atmel_tclib.c
--- /dev/null
+++ a/drivers/misc/atmel_tclib.c
@@ -0,0 +1,107 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/atmel_tc.h>
+
+
+/*
+ * This is a thin library to solve the problem of how to portably allocate
+ * one of the TC blocks.  For simplicity, it doesn't currently expect to
+ * share individual timers between different drivers.
+ */
+
+#if defined(CONFIG_AVR32)
+/* AVR32 has these divide PBB */
+const u8 atmel_tc_divisors[5] = { 0, 4, 8, 16, 32, };
+EXPORT_SYMBOL(atmel_tc_divisors);
+
+#elif defined(CONFIG_ARCH_AT91)
+/* AT91 has these divide MCK */
+const u8 atmel_tc_divisors[5] = { 2, 8, 32, 128, 0, };
+EXPORT_SYMBOL(atmel_tc_divisors);
+
+#endif
+
+/* we "know" that there will be either one or two TC blocks */
+static struct platform_device *blocks[2];
+
+
+/**
+ * atmel_tc_alloc - allocate a specified TC block
+ * @block: which block to allocate
+ * @iomem: used to return its IO memory resource
+ *
+ * Caller allocates a block.  If it is available, its I/O space is requested
+ * and returned through the iomem pointer, and the device node for the block
+ * is returned.  When it is not available, NULL is returned.
+ *
+ * On some platforms, each TC channel has its own clocks and IRQs.  Drivers
+ * should clk_get() and clk_enable() "t0_clk", "t1_clk, and "t2_clk".
+ * In the same vein, they should platform_get_irq() for irqs 0, 1, and 2.
+ * On other platforms, only irq 0 and "t0_clk" will be available; drivers
+ * should handle with both configurations.
+ */
+struct platform_device *atmel_tc_alloc(unsigned block, struct resource **iomem)
+{
+	struct platform_device	*tc;
+	struct resource		*r;
+
+	if (block >= ARRAY_SIZE(blocks) || !iomem)
+		return NULL;
+
+	tc = blocks[block];
+	if (tc) {
+		r = platform_get_resource(tc, IORESOURCE_MEM, 0);
+		if (r)
+			r = request_mem_region(r->start, 256, NULL);
+		*iomem = r;
+		if (!r)
+			tc = NULL;
+	}
+
+	return tc;
+}
+EXPORT_SYMBOL_GPL(atmel_tc_alloc);
+
+/**
+ * atmel_tc_free - release a specified TC block
+ * @block: which block to release
+ *
+ * This reverses the effect of atmel_tc_alloc(), invalidating the resource
+ * returned by that routine and making the TC available to other drivers.
+ */
+void atmel_tc_free(struct platform_device *tc)
+{
+	if (tc->id >= 0 && tc->id < ARRAY_SIZE(blocks)) {
+		struct resource		*r;
+
+		r = platform_get_resource(tc, IORESOURCE_MEM, 0);
+		release_mem_region(r->start, 256);
+	}
+}
+EXPORT_SYMBOL_GPL(atmel_tc_free);
+
+static int __init tc_probe(struct platform_device *pdev)
+{
+	static char __initdata e2big[] =
+		KERN_ERR "tclib: can't record TC block %d\n";
+
+	if (pdev->id < 0 || pdev->id >= ARRAY_SIZE(blocks)) {
+		printk(e2big, pdev->id);
+		return -ENFILE;
+	}
+	blocks[pdev->id] = pdev;
+	return 0;
+}
+
+static struct platform_driver tc_driver = {
+	.driver.name	= "atmel_tcb",
+};
+
+static int __init tc_init(void)
+{
+	return platform_driver_probe(&tc_driver, tc_probe);
+}
+arch_initcall(tc_init);
diff -puN /dev/null include/linux/atmel_tc.h
--- /dev/null
+++ a/include/linux/atmel_tc.h
@@ -0,0 +1,221 @@
+/*
+ * Timer/Counter Unit (TC) registers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef ATMEL_TC_H
+#define ATMEL_TC_H
+
+/*
+ * Many 32-bit Atmel SOCs include one or more TC blocks, each of which holds
+ * three general-purpose 16-bit timers.  These timers share one register bank.
+ * Depending on the SOC, each timer may have its own clock and IRQ, or those
+ * may be shared by the whole TC block.
+ *
+ * These TC blocks may have up to nine external pins:  TCLK0..2 signals for
+ * clocks or clock gates, and per-timer TIOA and TIOB signals used for PWM
+ * or triggering.  Those pins need to be set up for use with the TC block,
+ * else they will be used as GPIOs or for a different controller.
+ *
+ * Although we expect each TC block to have a platform_device node, those
+ * nodes are not what drivers bind to.  Instead, they ask for a specific
+ * TC block, by number ... which is a common approach on systems with many
+ * timers.  Then they use clk_get() and platform_get_irq() to get clock and
+ * IRQ resources.
+ */
+extern struct platform_device *atmel_tc_alloc(unsigned block,
+		struct resource **iomem);
+extern void atmel_tc_free(struct platform_device *tc);
+
+/* platform-specific ATMEL_TC_TIMER_CLOCKx divisors (0 means 32KiHz) */
+extern const u8 atmel_tc_divisors[5];
+
+
+/*
+ * Two registers have block-wide controls.  These are: configuring the three
+ * "external" clocks (or event sources) used by the timer channels; and
+ * synchronizing the timers by resetting them all at once.
+ *
+ * "External" can mean "external to chip" using the TCLK0, TCLK1, or TCLK2
+ * signals.  Or, it can mean "external to timer", using the TIOA output from
+ * one of the other two timers that's being run in waveform mode.
+ */
+
+#define ATMEL_TC_BCR	0xc0		/* TC Block Control Register */
+#define     ATMEL_TC_SYNC	(1 << 0)	/* synchronize timers */
+
+#define ATMEL_TC_BMR	0xc4		/* TC Block Mode Register */
+#define     ATMEL_TC_TC0XC0S	(3 << 0)	/* external clock 0 source */
+#define        ATMEL_TC_TC0XC0S_TCLK0	(0 << 0)
+#define        ATMEL_TC_TC0XC0S_NONE	(1 << 0)
+#define        ATMEL_TC_TC0XC0S_TIOA1	(2 << 0)
+#define        ATMEL_TC_TC0XC0S_TIOA2	(3 << 0)
+#define     ATMEL_TC_TC1XC1S	(3 << 2)	/* external clock 1 source */
+#define        ATMEL_TC_TC1XC1S_TCLK1	(0 << 2)
+#define        ATMEL_TC_TC1XC1S_NONE	(1 << 2)
+#define        ATMEL_TC_TC1XC1S_TIOA0	(2 << 2)
+#define        ATMEL_TC_TC1XC1S_TIOA2	(3 << 2)
+#define     ATMEL_TC_TC2XC2S	(3 << 4)	/* external clock 2 source */
+#define        ATMEL_TC_TC2XC2S_TCLK2	(0 << 4)
+#define        ATMEL_TC_TC2XC2S_NONE	(1 << 4)
+#define        ATMEL_TC_TC2XC2S_TIOA0	(2 << 4)
+#define        ATMEL_TC_TC2XC2S_TIOA1	(3 << 4)
+
+
+/*
+ * Each TC block has three "channels", each with one counter and controls.
+ *
+ * Note that the semantics of ATMEL_TC_TIMER_CLOCKx (input clock selection
+ * when it's not "external") is silicon-specific.  AT91 platforms use one
+ * set of definitions; AVR32 platforms use a different set.  Don't hard-wire
+ * such knowledge into your code, use the global "atmel_tc_divisors" ...
+ * where index N is the divisor for clock N+1, else zero to indicate it uses
+ * the 32 KiHz clock.
+ *
+ * The timers can be chained in various ways, and operated in "waveform"
+ * generation mode (including PWM) or "capture" mode (to time events).  In
+ * both modes, behavior can be configured in many ways.
+ *
+ * Each timer has two I/O pins, TIOA and TIOB.  Waveform mode uses TIOA as a
+ * PWM output, and TIOB as either another PWM or as a trigger.  Capture mode
+ * uses them only as inputs.
+ */
+#define ATMEL_TC_CHAN(idx)	((idx)*0x40)
+#define ATMEL_TC_REG(idx, reg)	(ATMEL_TC_CHAN(idx) + ATMEL_TC_ ## reg)
+
+#define ATMEL_TC_CCR	0x00		/* Channel Control Register */
+#define     ATMEL_TC_CLKEN	(1 << 0)	/* clock enable */
+#define     ATMEL_TC_CLKDIS	(1 << 1)	/* clock disable */
+#define     ATMEL_TC_SWTRG	(1 << 2)	/* software trigger */
+
+#define ATMEL_TC_CMR	0x04		/* Channel Mode Register */
+
+/* Both modes share some CMR bits */
+#define     ATMEL_TC_TCCLKS	(7 << 0)	/* clock source */
+#define        ATMEL_TC_TIMER_CLOCK1	(0 << 0)
+#define        ATMEL_TC_TIMER_CLOCK2	(1 << 0)
+#define        ATMEL_TC_TIMER_CLOCK3	(2 << 0)
+#define        ATMEL_TC_TIMER_CLOCK4	(3 << 0)
+#define        ATMEL_TC_TIMER_CLOCK5	(4 << 0)
+#define        ATMEL_TC_XC0		(5 << 0)
+#define        ATMEL_TC_XC1		(6 << 0)
+#define        ATMEL_TC_XC2		(7 << 0)
+#define     ATMEL_TC_CLKI	(1 << 3)	/* clock invert */
+#define     ATMEL_TC_BURST	(3 << 4)	/* clock gating */
+#define        ATMEL_TC_GATE_NONE	(0 << 4)
+#define        ATMEL_TC_GATE_XC0	(1 << 4)
+#define        ATMEL_TC_GATE_XC1	(2 << 4)
+#define        ATMEL_TC_GATE_XC2	(3 << 4)
+#define     ATMEL_TC_WAVE	(1 << 15)	/* true = Waveform mode */
+
+/* CAPTURE mode CMR bits */
+#define     ATMEL_TC_LDBSTOP	(1 << 6)	/* counter stops on RB load */
+#define     ATMEL_TC_LDBDIS	(1 << 7)	/* counter disable on RB load */
+#define     ATMEL_TC_ETRGEDG	(3 << 8)	/* external trigger edge */
+#define        ATMEL_TC_ETRGEDG_NONE	(0 << 8)
+#define        ATMEL_TC_ETRGEDG_RISING	(1 << 8)
+#define        ATMEL_TC_ETRGEDG_FALLING	(2 << 8)
+#define        ATMEL_TC_ETRGEDG_BOTH	(3 << 8)
+#define     ATMEL_TC_ABETRG	(1 << 10)	/* external trigger is TIOA? */
+#define     ATMEL_TC_CPCTRG	(1 << 14)	/* RC compare trigger enable */
+#define     ATMEL_TC_LDRA	(3 << 16)	/* RA loading edge (of TIOA) */
+#define        ATMEL_TC_LDRA_NONE	(0 << 16)
+#define        ATMEL_TC_LDRA_RISING	(1 << 16)
+#define        ATMEL_TC_LDRA_FALLING	(2 << 16)
+#define        ATMEL_TC_LDRA_BOTH	(3 << 16)
+#define     ATMEL_TC_LDRB	(3 << 18)	/* RB loading edge (of TIOA) */
+#define        ATMEL_TC_LDRB_NONE	(0 << 18)
+#define        ATMEL_TC_LDRB_RISING	(1 << 18)
+#define        ATMEL_TC_LDRB_FALLING	(2 << 18)
+#define        ATMEL_TC_LDRB_BOTH	(3 << 18)
+
+/* WAVEFORM mode CMR bits */
+#define     ATMEL_TC_CPCSTOP	(1 <<  6)	/* RC compare stops counter */
+#define     ATMEL_TC_CPCDIS	(1 <<  7)	/* RC compare disables counter */
+#define     ATMEL_TC_EEVTEDG	(3 <<  8)	/* external event edge */
+#define        ATMEL_TC_EEVTEDG_NONE	(0 << 8)
+#define        ATMEL_TC_EEVTEDG_RISING	(1 << 8)
+#define        ATMEL_TC_EEVTEDG_FALLING	(2 << 8)
+#define        ATMEL_TC_EEVTEDG_BOTH	(3 << 8)
+#define     ATMEL_TC_EEVT	(3 << 10)	/* external event source */
+#define        ATMEL_TC_EEVT_TIOB	(0 << 10)
+#define        ATMEL_TC_EEVT_XC0	(1 << 10)
+#define        ATMEL_TC_EEVT_XC1	(2 << 10)
+#define        ATMEL_TC_EEVT_XC2	(3 << 10)
+#define     ATMEL_TC_ENETRG	(1 << 12)	/* external event is trigger */
+#define     ATMEL_TC_WAVESEL	(3 << 13)	/* waveform type */
+#define        ATMEL_TC_WAVESEL_UP	(0 << 13)
+#define        ATMEL_TC_WAVESEL_UPDOWN	(1 << 13)
+#define        ATMEL_TC_WAVESEL_UP_AUTO	(2 << 13)
+#define        ATMEL_TC_WAVESEL_UPDOWN_AUTO (3 << 13)
+#define     ATMEL_TC_ACPA	(3 << 16)	/* RA compare changes TIOA */
+#define        ATMEL_TC_ACPA_NONE	(0 << 16)
+#define        ATMEL_TC_ACPA_SET	(1 << 16)
+#define        ATMEL_TC_ACPA_CLEAR	(2 << 16)
+#define        ATMEL_TC_ACPA_TOGGLE	(3 << 16)
+#define     ATMEL_TC_ACPC	(3 << 18)	/* RC compare changes TIOA */
+#define        ATMEL_TC_ACPC_NONE	(0 << 18)
+#define        ATMEL_TC_ACPC_SET	(1 << 18)
+#define        ATMEL_TC_ACPC_CLEAR	(2 << 18)
+#define        ATMEL_TC_ACPC_TOGGLE	(3 << 18)
+#define     ATMEL_TC_AEEVT	(3 << 20)	/* external event changes TIOA */
+#define        ATMEL_TC_AEEVT_NONE	(0 << 20)
+#define        ATMEL_TC_AEEVT_SET	(1 << 20)
+#define        ATMEL_TC_AEEVT_CLEAR	(2 << 20)
+#define        ATMEL_TC_AEEVT_TOGGLE	(3 << 20)
+#define     ATMEL_TC_ASWTRG	(3 << 22)	/* software trigger changes TIOA */
+#define        ATMEL_TC_ASWTRG_NONE	(0 << 22)
+#define        ATMEL_TC_ASWTRG_SET	(1 << 22)
+#define        ATMEL_TC_ASWTRG_CLEAR	(2 << 22)
+#define        ATMEL_TC_ASWTRG_TOGGLE	(3 << 22)
+#define     ATMEL_TC_BCPB	(3 << 24)	/* RB compare changes TIOB */
+#define        ATMEL_TC_BCPB_NONE	(0 << 24)
+#define        ATMEL_TC_BCPB_SET	(1 << 24)
+#define        ATMEL_TC_BCPB_CLEAR	(2 << 24)
+#define        ATMEL_TC_BCPB_TOGGLE	(3 << 24)
+#define     ATMEL_TC_BCPC	(3 << 26)	/* RC compare changes TIOB */
+#define        ATMEL_TC_BCPC_NONE	(0 << 26)
+#define        ATMEL_TC_BCPC_SET	(1 << 26)
+#define        ATMEL_TC_BCPC_CLEAR	(2 << 26)
+#define        ATMEL_TC_BCPC_TOGGLE	(3 << 26)
+#define     ATMEL_TC_BEEVT	(3 << 28)	/* external event changes TIOB */
+#define        ATMEL_TC_BEEVT_NONE	(0 << 28)
+#define        ATMEL_TC_BEEVT_SET	(1 << 28)
+#define        ATMEL_TC_BEEVT_CLEAR	(2 << 28)
+#define        ATMEL_TC_BEEVT_TOGGLE	(3 << 28)
+#define     ATMEL_TC_BSWTRG	(3 << 30)	/* software trigger changes TIOB */
+#define        ATMEL_TC_BSWTRG_NONE	(0 << 30)
+#define        ATMEL_TC_BSWTRG_SET	(1 << 30)
+#define        ATMEL_TC_BSWTRG_CLEAR	(2 << 30)
+#define        ATMEL_TC_BSWTRG_TOGGLE	(3 << 30)
+
+#define ATMEL_TC_CV	0x10		/* counter Value */
+#define ATMEL_TC_RA	0x14		/* register A */
+#define ATMEL_TC_RB	0x18		/* register B */
+#define ATMEL_TC_RC	0x1c		/* register C */
+
+#define ATMEL_TC_SR	0x20		/* status (read-only) */
+/* Status-only flags */
+#define     ATMEL_TC_CLKSTA	(1 << 16)	/* clock enabled */
+#define     ATMEL_TC_MTIOA	(1 << 17)	/* TIOA mirror */
+#define     ATMEL_TC_MTIOB	(1 << 18)	/* TIOB mirror */
+
+#define ATMEL_TC_IER	0x24		/* interrupt enable (write-only) */
+#define ATMEL_TC_IDR	0x28		/* interrupt disable (write-only) */
+#define ATMEL_TC_IMR	0x2c		/* interrupt mask (read-only) */
+
+/* Status and IRQ flags */
+#define     ATMEL_TC_COVFS	(1 <<  0)	/* counter overflow */
+#define     ATMEL_TC_LOVRS	(1 <<  1)	/* load overrun */
+#define     ATMEL_TC_CPAS	(1 <<  2)	/* RA compare */
+#define     ATMEL_TC_CPBS	(1 <<  3)	/* RB compare */
+#define     ATMEL_TC_CPCS	(1 <<  4)	/* RC compare */
+#define     ATMEL_TC_LDRAS	(1 <<  5)	/* RA loading */
+#define     ATMEL_TC_LDRBS	(1 <<  6)	/* RB loading */
+#define     ATMEL_TC_ETRGS	(1 <<  7)	/* external trigger */
+
+#endif
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-arm-master.patch
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

