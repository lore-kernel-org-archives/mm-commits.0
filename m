From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:25:15 -0700
Message-ID: <20120326192517.4D5A2A0517@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33455 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2CZTZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:25:19 -0400
Received: by vbnl22 with SMTP id l22so507682vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:25:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap1/board-ams-delta.c |    9 --------
 arch/arm/mach-omap1/board-h2.c        |    3 --
 arch/arm/mach-omap1/board-nokia770.c  |    3 --
 arch/arm/mach-omap1/board-osk.c       |    4 ---
 arch/arm/mach-omap1/board-palmtt.c    |    3 --
 arch/arm/mach-omap1/board-palmz71.c   |    3 --
 arch/arm/mach-u300/core.c             |    9 --------
 arch/x86/xen/setup.c                  |    3 --
 arch/x86/xen/smp.c                    |    4 ---
 drivers/base/regmap/regmap.c          |   25 ------------------------
 drivers/tty/hvc/hvc_xen.c             |    4 ---
 drivers/video/udlfb.c                 |    7 ------
 drivers/xen/Kconfig                   |    5 ----
 drivers/xen/xen-acpi-processor.c      |    8 -------
 14 files changed, 90 deletions(-)

diff -puN arch/arm/mach-omap1/board-ams-delta.c~linux-next-git-rejects arch/arm/mach-omap1/board-ams-delta.c
--- a/arch/arm/mach-omap1/board-ams-delta.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap1/board-ams-delta.c
@@ -25,10 +25,7 @@
 #include <linux/serial_8250.h>
 #include <linux/export.h>
 #include <linux/omapfb.h>
-<<<<<<< HEAD
-=======
 #include <linux/io.h>
->>>>>>> linux-next/akpm-end
 
 #include <media/soc_camera.h>
 
@@ -169,8 +166,6 @@ static struct omap_usb_config ams_delta_
 	.pins[0]	= 2,
 };
 
-<<<<<<< HEAD
-=======
 #define LATCH1_GPIO_BASE	232
 #define LATCH1_NGPIO		8
 
@@ -312,7 +307,6 @@ void ams_delta_latch_write(int base, int
 }
 EXPORT_SYMBOL(ams_delta_latch_write);
 
->>>>>>> linux-next/akpm-end
 static struct resource ams_delta_nand_resources[] = {
 	[0] = {
 		.start	= OMAP1_MPUIO_BASE,
@@ -499,8 +493,6 @@ static void __init ams_delta_init(void)
 	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
 
 	omapfb_set_lcd_config(&ams_delta_lcd_config);
-<<<<<<< HEAD
-=======
 }
 
 static void modem_pm(struct uart_port *port, unsigned int state, unsigned old)
@@ -517,7 +509,6 @@ static void modem_pm(struct uart_port *p
 		regulator_enable(priv->regulator);
 	else if (old == 0)
 		regulator_disable(priv->regulator);
->>>>>>> linux-next/akpm-end
 }
 
 static struct plat_serial8250_port ams_delta_modem_ports[] = {
diff -puN arch/arm/mach-omap1/board-h2.c~linux-next-git-rejects arch/arm/mach-omap1/board-h2.c
--- a/arch/arm/mach-omap1/board-h2.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap1/board-h2.c
@@ -31,11 +31,8 @@
 #include <linux/i2c/tps65010.h>
 #include <linux/smc91x.h>
 #include <linux/omapfb.h>
-<<<<<<< HEAD
 
 #include <mach/hardware.h>
-=======
->>>>>>> linux-next/akpm-end
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff -puN arch/arm/mach-omap1/board-nokia770.c~linux-next-git-rejects arch/arm/mach-omap1/board-nokia770.c
--- a/arch/arm/mach-omap1/board-nokia770.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap1/board-nokia770.c
@@ -29,10 +29,7 @@
 #include <plat/usb.h>
 #include <plat/board.h>
 #include <plat/keypad.h>
-<<<<<<< HEAD
 #include "common.h"
-=======
->>>>>>> linux-next/akpm-end
 #include <plat/lcd_mipid.h>
 #include <plat/mmc.h>
 #include <plat/clock.h>
diff -puN arch/arm/mach-omap1/board-osk.c~linux-next-git-rejects arch/arm/mach-omap1/board-osk.c
--- a/arch/arm/mach-omap1/board-osk.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap1/board-osk.c
@@ -35,10 +35,6 @@
 #include <linux/leds.h>
 #include <linux/smc91x.h>
 #include <linux/omapfb.h>
-<<<<<<< HEAD
-
-=======
->>>>>>> linux-next/akpm-end
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
diff -puN arch/arm/mach-omap1/board-palmtt.c~linux-next-git-rejects arch/arm/mach-omap1/board-palmtt.c
--- a/arch/arm/mach-omap1/board-palmtt.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap1/board-palmtt.c
@@ -25,11 +25,8 @@
 #include <linux/mtd/physmap.h>
 #include <linux/leds.h>
 #include <linux/omapfb.h>
-<<<<<<< HEAD
-=======
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
->>>>>>> linux-next/akpm-end
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff -puN arch/arm/mach-omap1/board-palmz71.c~linux-next-git-rejects arch/arm/mach-omap1/board-palmz71.c
--- a/arch/arm/mach-omap1/board-palmz71.c~linux-next-git-rejects
+++ a/arch/arm/mach-omap1/board-palmz71.c
@@ -28,11 +28,8 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/omapfb.h>
-<<<<<<< HEAD
-=======
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
->>>>>>> linux-next/akpm-end
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
diff -puN arch/arm/mach-u300/core.c~linux-next-git-rejects arch/arm/mach-u300/core.c
--- a/arch/arm/mach-u300/core.c~linux-next-git-rejects
+++ a/arch/arm/mach-u300/core.c
@@ -1571,21 +1571,12 @@ static struct platform_device dma_device
 
 static unsigned long pin_pullup_conf[] = {
 	PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 1),
-<<<<<<< HEAD
 };
 
 static unsigned long pin_highz_conf[] = {
 	PIN_CONF_PACKED(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0),
 };
 
-=======
-};
-
-static unsigned long pin_highz_conf[] = {
-	PIN_CONF_PACKED(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0),
-};
-
->>>>>>> linux-next/akpm-end
 /* Pin control settings */
 static struct pinctrl_map __initdata u300_pinmux_map[] = {
 	/* anonymous maps for chip power and EMIFs */
diff -puN arch/x86/xen/setup.c~linux-next-git-rejects arch/x86/xen/setup.c
--- a/arch/x86/xen/setup.c~linux-next-git-rejects
+++ a/arch/x86/xen/setup.c
@@ -421,10 +421,7 @@ void __init xen_arch_setup(void)
 	boot_cpu_data.hlt_works_ok = 1;
 #endif
 	disable_cpuidle();
-<<<<<<< HEAD
-=======
 	disable_cpufreq();
->>>>>>> linux-next/akpm-end
 	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
 }
diff -puN arch/x86/xen/smp.c~linux-next-git-rejects arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c~linux-next-git-rejects
+++ a/arch/x86/xen/smp.c
@@ -79,14 +79,10 @@ static void __cpuinit cpu_bringup(void)
 
 	ipi_call_lock();
 	set_cpu_online(cpu, true);
-<<<<<<< HEAD
-	this_cpu_write(cpu_state, CPU_ONLINE);
-=======
 	ipi_call_unlock();
 
 	this_cpu_write(cpu_state, CPU_ONLINE);
 
->>>>>>> linux-next/akpm-end
 	wmb();
 
 	/* We can take interrupts now: we're officially "up". */
diff -puN drivers/base/regmap/regmap.c~linux-next-git-rejects drivers/base/regmap/regmap.c
--- a/drivers/base/regmap/regmap.c~linux-next-git-rejects
+++ a/drivers/base/regmap/regmap.c
@@ -167,8 +167,6 @@ static unsigned int regmap_parse_16(void
 	return b[0];
 }
 
-<<<<<<< HEAD
-=======
 static unsigned int regmap_parse_24(void *buf)
 {
 	u8 *b = buf;
@@ -179,7 +177,6 @@ static unsigned int regmap_parse_24(void
 	return ret;
 }
 
->>>>>>> linux-next/akpm-end
 static unsigned int regmap_parse_32(void *buf)
 {
 	__be32 *b = buf;
@@ -222,10 +219,7 @@ struct regmap *regmap_init(struct device
 	map->format.pad_bytes = config->pad_bits / 8;
 	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
 	map->format.buf_size += map->format.pad_bytes;
-<<<<<<< HEAD
-=======
 	map->reg_shift = config->pad_bits % 8;
->>>>>>> linux-next/akpm-end
 	map->dev = dev;
 	map->bus = bus;
 	map->max_register = config->max_register;
@@ -242,11 +236,7 @@ struct regmap *regmap_init(struct device
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-<<<<<<< HEAD
-	switch (config->reg_bits) {
-=======
 	switch (config->reg_bits + map->reg_shift) {
->>>>>>> linux-next/akpm-end
 	case 2:
 		switch (config->val_bits) {
 		case 6:
@@ -312,13 +302,10 @@ struct regmap *regmap_init(struct device
 		map->format.format_val = regmap_format_16;
 		map->format.parse_val = regmap_parse_16;
 		break;
-<<<<<<< HEAD
-=======
 	case 24:
 		map->format.format_val = regmap_format_24;
 		map->format.parse_val = regmap_parse_24;
 		break;
->>>>>>> linux-next/akpm-end
 	case 32:
 		map->format.format_val = regmap_format_32;
 		map->format.parse_val = regmap_parse_32;
@@ -477,11 +464,7 @@ static int _regmap_raw_write(struct regm
 		}
 	}
 
-<<<<<<< HEAD
-	map->format.format_reg(map->work_buf, reg);
-=======
 	map->format.format_reg(map->work_buf, reg, map->reg_shift);
->>>>>>> linux-next/akpm-end
 
 	u8[0] |= map->write_flag_mask;
 
@@ -556,11 +539,7 @@ int _regmap_write(struct regmap *map, un
 		return ret;
 	} else {
 		map->format.format_val(map->work_buf + map->format.reg_bytes
-<<<<<<< HEAD
-				       + map->format.pad_bytes, val);
-=======
 				       + map->format.pad_bytes, val, 0);
->>>>>>> linux-next/akpm-end
 		return _regmap_raw_write(map, reg,
 					 map->work_buf +
 					 map->format.reg_bytes +
@@ -788,11 +767,7 @@ int regmap_raw_read(struct regmap *map, 
 			if (ret != 0)
 				goto out;
 
-<<<<<<< HEAD
-			map->format.format_val(val + (i * val_bytes), v);
-=======
 			map->format.format_val(val + (i * val_bytes), v, 0);
->>>>>>> linux-next/akpm-end
 		}
 	}
 
diff -puN drivers/tty/hvc/hvc_xen.c~linux-next-git-rejects drivers/tty/hvc/hvc_xen.c
--- a/drivers/tty/hvc/hvc_xen.c~linux-next-git-rejects
+++ a/drivers/tty/hvc/hvc_xen.c
@@ -534,11 +534,7 @@ static int __init xen_hvc_init(void)
 		info->irq = bind_evtchn_to_irq(info->evtchn);
 	}
 	if (info->irq < 0)
-<<<<<<< HEAD
-		info->irq = 0; /* NO_IRQ */
-=======
 		info->irq = 0;
->>>>>>> linux-next/akpm-end
 	else
 		irq_set_noprobe(info->irq);
 
diff -puN drivers/video/udlfb.c~linux-next-git-rejects drivers/video/udlfb.c
--- a/drivers/video/udlfb.c~linux-next-git-rejects
+++ a/drivers/video/udlfb.c
@@ -1753,20 +1753,13 @@ static void dlfb_usb_disconnect(struct u
 	dlfb_free_urb_list(dev);
 
 	if (info) {
-<<<<<<< HEAD
-=======
-
->>>>>>> linux-next/akpm-end
 		/* remove udlfb's sysfs interfaces */
 		for (i = 0; i < ARRAY_SIZE(fb_device_attrs); i++)
 			device_remove_file(info->dev, &fb_device_attrs[i]);
 		device_remove_bin_file(info->dev, &edid_attr);
-<<<<<<< HEAD
-=======
 
 		/* it's safe to uncomment next line if your kernel
 		   doesn't yet have this function exported */
->>>>>>> linux-next/akpm-end
 		unlink_framebuffer(info);
 	}
 
diff -puN drivers/xen/Kconfig~linux-next-git-rejects drivers/xen/Kconfig
--- a/drivers/xen/Kconfig~linux-next-git-rejects
+++ a/drivers/xen/Kconfig
@@ -181,12 +181,7 @@ config XEN_PRIVCMD
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
 	depends on XEN && X86 && ACPI_PROCESSOR
-<<<<<<< HEAD
-	default y if (X86_ACPI_CPUFREQ = y || X86_POWERNOW_K8 = y)
-	default m if (X86_ACPI_CPUFREQ = m || X86_POWERNOW_K8 = m)
-=======
 	default m
->>>>>>> linux-next/akpm-end
 	help
           This ACPI processor uploads Power Management information to the Xen hypervisor.
 
diff -puN drivers/xen/xen-acpi-processor.c~linux-next-git-rejects drivers/xen/xen-acpi-processor.c
--- a/drivers/xen/xen-acpi-processor.c~linux-next-git-rejects
+++ a/drivers/xen/xen-acpi-processor.c
@@ -501,19 +501,11 @@ static int __init xen_acpi_processor_ini
 
 		perf = per_cpu_ptr(acpi_perf_data, i);
 		rc = acpi_processor_register_performance(perf, i);
-<<<<<<< HEAD
-		if (WARN_ON(rc))
-			goto err_out;
-	}
-	rc = acpi_processor_notify_smm(THIS_MODULE);
-	if (WARN_ON(rc))
-=======
 		if (rc)
 			goto err_out;
 	}
 	rc = acpi_processor_notify_smm(THIS_MODULE);
 	if (rc)
->>>>>>> linux-next/akpm-end
 		goto err_unregister;
 
 	for_each_possible_cpu(i) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
sched-fix-compiler-warning-about-declared-inline-after-use.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

