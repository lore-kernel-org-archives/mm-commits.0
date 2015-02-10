From: akpm@linux-foundation.org
Subject: + mips-ip32-add-platform-data-hooks-to-use-ds1685-driver.patch
 added to -mm tree
Date: Mon, 09 Feb 2015 16:21:20 -0800
Message-ID: <54d94f00.VAr/sl+fNhG/6o5j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbbBJAVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2015 19:21:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kumba@gentoo.org, a.zummo@towertech.it, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: ip32: add platform data hooks to use DS1685 driver
has been added to the -mm tree.  Its filename is
     mips-ip32-add-platform-data-hooks-to-use-ds1685-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mips-ip32-add-platform-data-hooks-to-use-ds1685-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mips-ip32-add-platform-data-hooks-to-use-ds1685-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joshua Kinard <kumba@gentoo.org>
Subject: mips: ip32: add platform data hooks to use DS1685 driver

This modifies the IP32 (SGI O2) platform and reset code to utilize the new
rtc-ds1685 driver.  The old mc146818rtc.h header is removed and ip32_defconfig
is updated as well.

Signed-off-by: Joshua Kinard <kumba@gentoo.org>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/configs/ip32_defconfig              |    3 
 arch/mips/include/asm/mach-ip32/mc146818rtc.h |   36 ----
 arch/mips/sgi-ip32/ip32-platform.c            |   52 +++++-
 arch/mips/sgi-ip32/ip32-reset.c               |  130 ++++------------
 4 files changed, 84 insertions(+), 137 deletions(-)

diff -puN arch/mips/configs/ip32_defconfig~mips-ip32-add-platform-data-hooks-to-use-ds1685-driver arch/mips/configs/ip32_defconfig
--- a/arch/mips/configs/ip32_defconfig~mips-ip32-add-platform-data-hooks-to-use-ds1685-driver
+++ a/arch/mips/configs/ip32_defconfig
@@ -105,7 +105,8 @@ CONFIG_RTC_CLASS=y
 # CONFIG_RTC_HCTOSYS is not set
 # CONFIG_RTC_INTF_SYSFS is not set
 # CONFIG_RTC_INTF_PROC is not set
-CONFIG_RTC_DRV_CMOS=y
+CONFIG_RTC_DRV_DS1685_FAMILY=y
+CONFIG_RTC_DRV_DS1685=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_POSIX_ACL=y
diff -puN arch/mips/include/asm/mach-ip32/mc146818rtc.h~mips-ip32-add-platform-data-hooks-to-use-ds1685-driver /dev/null
--- a/arch/mips/include/asm/mach-ip32/mc146818rtc.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1998, 2001, 03 by Ralf Baechle
- * Copyright (C) 2000 Harald Koerfgen
- *
- * RTC routines for IP32 style attached Dallas chip.
- */
-#ifndef __ASM_MACH_IP32_MC146818RTC_H
-#define __ASM_MACH_IP32_MC146818RTC_H
-
-#include <asm/ip32/mace.h>
-
-#define RTC_PORT(x)	(0x70 + (x))
-
-static unsigned char CMOS_READ(unsigned long addr)
-{
-	return mace->isa.rtc[addr << 8];
-}
-
-static inline void CMOS_WRITE(unsigned char data, unsigned long addr)
-{
-	mace->isa.rtc[addr << 8] = data;
-}
-
-/*
- * FIXME: Do it right. For now just assume that no one lives in 20th century
- * and no O2 user in 22th century ;-)
- */
-#define mc146818_decode_year(year) ((year) + 2000)
-
-#define RTC_ALWAYS_BCD	0
-
-#endif /* __ASM_MACH_IP32_MC146818RTC_H */
diff -puN arch/mips/sgi-ip32/ip32-platform.c~mips-ip32-add-platform-data-hooks-to-use-ds1685-driver arch/mips/sgi-ip32/ip32-platform.c
--- a/arch/mips/sgi-ip32/ip32-platform.c~mips-ip32-add-platform-data-hooks-to-use-ds1685-driver
+++ a/arch/mips/sgi-ip32/ip32-platform.c
@@ -9,10 +9,13 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
+#include <linux/rtc/ds1685.h>
 
 #include <asm/ip32/mace.h>
 #include <asm/ip32/ip32_ints.h>
 
+extern void ip32_prepare_poweroff(void);
+
 #define MACEISA_SERIAL1_OFFS   offsetof(struct sgi_mace, isa.serial1)
 #define MACEISA_SERIAL2_OFFS   offsetof(struct sgi_mace, isa.serial2)
 
@@ -90,22 +93,53 @@ static __init int sgio2btns_devinit(void
 
 device_initcall(sgio2btns_devinit);
 
-static struct resource sgio2_cmos_rsrc[] = {
+#define MACE_RTC_RES_START (MACE_BASE + offsetof(struct sgi_mace, isa.rtc))
+#define MACE_RTC_RES_END (MACE_RTC_RES_START + 32767)
+
+static struct resource ip32_rtc_resources[] = {
 	{
-		.start = 0x70,
-		.end   = 0x71,
-		.flags = IORESOURCE_IO
+		.start	= MACEISA_RTC_IRQ,
+		.end	= MACEISA_RTC_IRQ,
+		.flags	= IORESOURCE_IRQ
+	}, {
+		.start	= MACE_RTC_RES_START,
+		.end	= MACE_RTC_RES_END,
+		.flags	= IORESOURCE_MEM,
 	}
 };
 
-static __init int sgio2_cmos_devinit(void)
+
+/* RTC registers on IP32 are each padded by 256 bytes (0x100). */
+static struct ds1685_rtc_platform_data
+ip32_rtc_platform_data[] = {
+	{
+		.regstep = 0x100,
+		.bcd_mode = true,
+		.no_irq = false,
+		.uie_unsupported = false,
+		.alloc_io_resources = true,
+		.plat_prepare_poweroff = ip32_prepare_poweroff,
+	},
+};
+
+struct platform_device ip32_rtc_device = {
+	.name			= "rtc-ds1685",
+	.id			= -1,
+	.dev			= {
+		.platform_data	= ip32_rtc_platform_data,
+	},
+	.num_resources		= ARRAY_SIZE(ip32_rtc_resources),
+	.resource		= ip32_rtc_resources,
+};
+
+static int __init sgio2_rtc_devinit(void)
 {
-	return IS_ERR(platform_device_register_simple("rtc_cmos", -1,
-						      sgio2_cmos_rsrc, 1));
+	return platform_device_register(&ip32_rtc_device);
+
 }
 
-device_initcall(sgio2_cmos_devinit);
+device_initcall(sgio2_rtc_devinit);
 
 MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("8250 UART probe driver for SGI IP32 aka O2");
+MODULE_DESCRIPTION("IP32 platform setup for SGI IP32 aka O2");
diff -puN arch/mips/sgi-ip32/ip32-reset.c~mips-ip32-add-platform-data-hooks-to-use-ds1685-driver arch/mips/sgi-ip32/ip32-reset.c
--- a/arch/mips/sgi-ip32/ip32-reset.c~mips-ip32-add-platform-data-hooks-to-use-ds1685-driver
+++ a/arch/mips/sgi-ip32/ip32-reset.c
@@ -10,10 +10,11 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/notifier.h>
 #include <linux/delay.h>
-#include <linux/ds17287rtc.h>
+#include <linux/rtc/ds1685.h>
 #include <linux/interrupt.h>
 #include <linux/pm.h>
 
@@ -32,53 +33,41 @@
 #define POWERDOWN_FREQ		(HZ / 4)
 #define PANIC_FREQ		(HZ / 8)
 
-static struct timer_list power_timer, blink_timer, debounce_timer;
-static int has_panicked, shuting_down;
+extern struct platform_device ip32_rtc_device;
 
-static void ip32_machine_restart(char *command) __attribute__((noreturn));
-static void ip32_machine_halt(void) __attribute__((noreturn));
-static void ip32_machine_power_off(void) __attribute__((noreturn));
+static struct timer_list power_timer, blink_timer;
+static int has_panicked, shutting_down;
 
-static void ip32_machine_restart(char *cmd)
-{
-	crime->control = CRIME_CONTROL_HARD_RESET;
-	while (1);
-}
-
-static inline void ip32_machine_halt(void)
-{
-	ip32_machine_power_off();
-}
-
-static void ip32_machine_power_off(void)
+static __noreturn void ip32_poweroff(void *data)
 {
-	unsigned char reg_a, xctrl_a, xctrl_b;
+	void (*poweroff_func)(struct platform_device *) =
+		symbol_get(ds1685_rtc_poweroff);
 
-	disable_irq(MACEISA_RTC_IRQ);
-	reg_a = CMOS_READ(RTC_REG_A);
+#ifdef CONFIG_MODULES
+	/* If the first __symbol_get failed, our module wasn't loaded. */
+	if (!poweroff_func) {
+		request_module("rtc-ds1685");
+		poweroff_func = symbol_get(ds1685_rtc_poweroff);
+	}
+#endif
 
-	/* setup for kickstart & wake-up (DS12287 Ref. Man. p. 19) */
-	reg_a &= ~DS_REGA_DV2;
-	reg_a |= DS_REGA_DV1;
+	if (!poweroff_func)
+		pr_emerg("RTC not available for power-off.  Spinning forever ...\n");
+	else {
+		(*poweroff_func)((struct platform_device *)data);
+		symbol_put(ds1685_rtc_poweroff);
+	}
 
-	CMOS_WRITE(reg_a | DS_REGA_DV0, RTC_REG_A);
-	wbflush();
-	xctrl_b = CMOS_READ(DS_B1_XCTRL4B)
-		   | DS_XCTRL4B_ABE | DS_XCTRL4B_KFE;
-	CMOS_WRITE(xctrl_b, DS_B1_XCTRL4B);
-	xctrl_a = CMOS_READ(DS_B1_XCTRL4A) & ~DS_XCTRL4A_IFS;
-	CMOS_WRITE(xctrl_a, DS_B1_XCTRL4A);
-	wbflush();
-	/* adios amigos... */
-	CMOS_WRITE(xctrl_a | DS_XCTRL4A_PAB, DS_B1_XCTRL4A);
-	CMOS_WRITE(reg_a, RTC_REG_A);
-	wbflush();
-	while (1);
+	unreachable();
 }
 
-static void power_timeout(unsigned long data)
+
+static void ip32_machine_restart(char *cmd) __noreturn;
+static void ip32_machine_restart(char *cmd)
 {
-	ip32_machine_power_off();
+	msleep(20);
+	crime->control = CRIME_CONTROL_HARD_RESET;
+	unreachable();
 }
 
 static void blink_timeout(unsigned long data)
@@ -88,44 +77,27 @@ static void blink_timeout(unsigned long
 	mod_timer(&blink_timer, jiffies + data);
 }
 
-static void debounce(unsigned long data)
+static void ip32_machine_halt(void)
 {
-	unsigned char reg_a, reg_c, xctrl_a;
-
-	reg_c = CMOS_READ(RTC_INTR_FLAGS);
-	reg_a = CMOS_READ(RTC_REG_A);
-	CMOS_WRITE(reg_a | DS_REGA_DV0, RTC_REG_A);
-	wbflush();
-	xctrl_a = CMOS_READ(DS_B1_XCTRL4A);
-	if ((xctrl_a & DS_XCTRL4A_IFS) || (reg_c & RTC_IRQF )) {
-		/* Interrupt still being sent. */
-		debounce_timer.expires = jiffies + 50;
-		add_timer(&debounce_timer);
-
-		/* clear interrupt source */
-		CMOS_WRITE(xctrl_a & ~DS_XCTRL4A_IFS, DS_B1_XCTRL4A);
-		CMOS_WRITE(reg_a & ~DS_REGA_DV0, RTC_REG_A);
-		return;
-	}
-	CMOS_WRITE(reg_a & ~DS_REGA_DV0, RTC_REG_A);
-
-	if (has_panicked)
-		ip32_machine_restart(NULL);
+	ip32_poweroff(&ip32_rtc_device);
+}
 
-	enable_irq(MACEISA_RTC_IRQ);
+static void power_timeout(unsigned long data)
+{
+	ip32_poweroff(&ip32_rtc_device);
 }
 
-static inline void ip32_power_button(void)
+void ip32_prepare_poweroff(void)
 {
 	if (has_panicked)
 		return;
 
-	if (shuting_down || kill_cad_pid(SIGINT, 1)) {
+	if (shutting_down || kill_cad_pid(SIGINT, 1)) {
 		/* No init process or button pressed twice.  */
-		ip32_machine_power_off();
+		ip32_poweroff(&ip32_rtc_device);
 	}
 
-	shuting_down = 1;
+	shutting_down = 1;
 	blink_timer.data = POWERDOWN_FREQ;
 	blink_timeout(POWERDOWN_FREQ);
 
@@ -135,27 +107,6 @@ static inline void ip32_power_button(voi
 	add_timer(&power_timer);
 }
 
-static irqreturn_t ip32_rtc_int(int irq, void *dev_id)
-{
-	unsigned char reg_c;
-
-	reg_c = CMOS_READ(RTC_INTR_FLAGS);
-	if (!(reg_c & RTC_IRQF)) {
-		printk(KERN_WARNING
-			"%s: RTC IRQ without RTC_IRQF\n", __func__);
-	}
-	/* Wait until interrupt goes away */
-	disable_irq_nosync(MACEISA_RTC_IRQ);
-	init_timer(&debounce_timer);
-	debounce_timer.function = debounce;
-	debounce_timer.expires = jiffies + 50;
-	add_timer(&debounce_timer);
-
-	printk(KERN_DEBUG "Power button pressed\n");
-	ip32_power_button();
-	return IRQ_HANDLED;
-}
-
 static int panic_event(struct notifier_block *this, unsigned long event,
 		       void *ptr)
 {
@@ -189,15 +140,12 @@ static __init int ip32_reboot_setup(void
 
 	_machine_restart = ip32_machine_restart;
 	_machine_halt = ip32_machine_halt;
-	pm_power_off = ip32_machine_power_off;
+	pm_power_off = ip32_machine_halt;
 
 	init_timer(&blink_timer);
 	blink_timer.function = blink_timeout;
 	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
 
-	if (request_irq(MACEISA_RTC_IRQ, ip32_rtc_int, 0, "rtc", NULL))
-		panic("Can't allocate MACEISA RTC IRQ");
