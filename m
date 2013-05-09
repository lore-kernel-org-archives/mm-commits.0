From: akpm@linux-foundation.org
Subject: [to-be-updated] reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch removed from -mm tree
Date: Thu, 09 May 2013 13:51:53 -0700
Message-ID: <20130509205153.95C8831C204@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41525 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3EIUvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:51:55 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so334514yho.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:51:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: arm: change reboot_mode to use enum reboot_mode
has been removed from the -mm tree.  Its filename was
     reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: arm: change reboot_mode to use enum reboot_mode

Preparing to move the parsing of reboot= to generic kernel code forces the
change in reboot_mode handling to use the enum.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/hardware/iop3xx.h         |    3 +-
 arch/arm/include/asm/mach/arch.h               |    2 -
 arch/arm/include/asm/system_misc.h             |    3 +-
 arch/arm/kernel/process.c                      |    5 ++--
 arch/arm/mach-at91/at91rm9200.c                |    3 +-
 arch/arm/mach-at91/generic.h                   |    5 ++--
 arch/arm/mach-bcm2835/bcm2835.c                |    4 +--
 arch/arm/mach-clps711x/common.c                |    2 -
 arch/arm/mach-clps711x/common.h                |    4 ++-
 arch/arm/mach-cns3xxx/core.h                   |    4 ++-
 arch/arm/mach-cns3xxx/pm.c                     |    2 -
 arch/arm/mach-davinci/devices-da8xx.c          |    3 +-
 arch/arm/mach-davinci/devices.c                |    3 +-
 arch/arm/mach-davinci/include/mach/common.h    |    3 +-
 arch/arm/mach-davinci/include/mach/da8xx.h     |    3 +-
 arch/arm/mach-davinci/include/mach/tnetv107x.h |    3 +-
 arch/arm/mach-davinci/tnetv107x.c              |    3 +-
 arch/arm/mach-dove/common.c                    |    2 -
 arch/arm/mach-dove/common.h                    |    4 ++-
 arch/arm/mach-ebsa110/core.c                   |    2 -
 arch/arm/mach-ep93xx/core.c                    |    3 +-
 arch/arm/mach-ep93xx/include/mach/platform.h   |    4 ++-
 arch/arm/mach-exynos/common.c                  |    4 +--
 arch/arm/mach-exynos/common.h                  |    5 ++--
 arch/arm/mach-footbridge/common.c              |    4 +--
 arch/arm/mach-footbridge/common.h              |    3 +-
 arch/arm/mach-footbridge/netwinder-hw.c        |    4 +--
 arch/arm/mach-highbank/core.h                  |    4 ++-
 arch/arm/mach-highbank/system.c                |    5 ++--
 arch/arm/mach-imx/common.h                     |    4 ++-
 arch/arm/mach-imx/mach-imx6q.c                 |    3 +-
 arch/arm/mach-imx/system.c                     |    2 -
 arch/arm/mach-integrator/common.h              |    3 +-
 arch/arm/mach-integrator/core.c                |    2 -
 arch/arm/mach-iop13xx/include/mach/iop13xx.h   |    5 +++-
 arch/arm/mach-iop13xx/setup.c                  |    2 -
 arch/arm/mach-iop32x/n2100.c                   |    2 -
 arch/arm/mach-ixp4xx/common.c                  |    4 +--
 arch/arm/mach-ixp4xx/dsmg600-setup.c           |    1 
 arch/arm/mach-ixp4xx/include/mach/platform.h   |    4 ++-
 arch/arm/mach-ixp4xx/include/mach/timex.h      |    2 -
 arch/arm/mach-kirkwood/board-lsxl.c            |    2 -
 arch/arm/mach-kirkwood/common.c                |    3 +-
 arch/arm/mach-kirkwood/common.h                |    4 ++-
 arch/arm/mach-ks8695/generic.h                 |    2 -
 arch/arm/mach-ks8695/time.c                    |    4 +--
 arch/arm/mach-lpc32xx/common.c                 |    6 ++---
 arch/arm/mach-lpc32xx/common.h                 |    3 +-
 arch/arm/mach-mmp/common.c                     |    2 -
 arch/arm/mach-mmp/common.h                     |    3 +-
 arch/arm/mach-mmp/include/mach/pxa168.h        |    4 ++-
 arch/arm/mach-mmp/pxa168.c                     |    2 -
 arch/arm/mach-mv78xx0/common.c                 |    2 -
 arch/arm/mach-mv78xx0/common.h                 |    4 ++-
 arch/arm/mach-mvebu/common.h                   |    4 ++-
 arch/arm/mach-mvebu/system-controller.c        |    3 +-
 arch/arm/mach-mxs/mach-mxs.c                   |    4 ++-
 arch/arm/mach-netx/generic.c                   |    3 +-
 arch/arm/mach-netx/generic.h                   |    4 ++-
 arch/arm/mach-nomadik/cpu-8815.c               |    2 -
 arch/arm/mach-omap1/board-voiceblue.c          |    3 +-
 arch/arm/mach-omap1/common.h                   |    3 +-
 arch/arm/mach-omap1/reset.c                    |    3 +-
 arch/arm/mach-omap2/am33xx-restart.c           |    3 +-
 arch/arm/mach-omap2/common.h                   |   17 +++++++--------
 arch/arm/mach-omap2/omap2-restart.c            |    2 -
 arch/arm/mach-omap2/omap3-restart.c            |    3 +-
 arch/arm/mach-omap2/omap4-common.c             |    3 +-
 arch/arm/mach-orion5x/common.c                 |    2 -
 arch/arm/mach-orion5x/common.h                 |    4 ++-
 arch/arm/mach-orion5x/ls-chl-setup.c           |    2 -
 arch/arm/mach-orion5x/ls_hgl-setup.c           |    2 -
 arch/arm/mach-orion5x/lsmini-setup.c           |    2 -
 arch/arm/mach-picoxcell/common.c               |    3 +-
 arch/arm/mach-prima2/common.h                  |    4 ++-
 arch/arm/mach-prima2/rstc.c                    |    3 +-
 arch/arm/mach-pxa/corgi.c                      |    6 ++---
 arch/arm/mach-pxa/generic.h                    |    4 ++-
 arch/arm/mach-pxa/mioa701.c                    |    7 +++---
 arch/arm/mach-pxa/poodle.c                     |    2 -
 arch/arm/mach-pxa/reset.c                      |    8 +++----
 arch/arm/mach-pxa/spitz.c                      |    5 ++--
 arch/arm/mach-pxa/tosa.c                       |    5 ++--
 arch/arm/mach-realview/realview_eb.c           |    3 +-
 arch/arm/mach-realview/realview_pb1176.c       |    3 +-
 arch/arm/mach-realview/realview_pb11mp.c       |    3 +-
 arch/arm/mach-realview/realview_pba8.c         |    3 +-
 arch/arm/mach-realview/realview_pbx.c          |    3 +-
 arch/arm/mach-rpc/riscpc.c                     |    3 +-
 arch/arm/mach-s3c24xx/common.h                 |   12 ++++++----
 arch/arm/mach-s3c24xx/s3c2410.c                |    5 ++--
 arch/arm/mach-s3c24xx/s3c2412.c                |    5 ++--
 arch/arm/mach-s3c24xx/s3c2416.c                |    5 ++--
 arch/arm/mach-s3c24xx/s3c2443.c                |    5 ++--
 arch/arm/mach-s3c24xx/s3c244x.c                |    5 ++--
 arch/arm/mach-s3c64xx/common.c                 |    5 ++--
 arch/arm/mach-s3c64xx/common.h                 |    4 ++-
 arch/arm/mach-s5p64x0/common.c                 |    5 ++--
 arch/arm/mach-s5p64x0/common.h                 |    4 ++-
 arch/arm/mach-s5pc100/common.c                 |    5 ++--
 arch/arm/mach-s5pc100/common.h                 |    4 ++-
 arch/arm/mach-s5pv210/common.c                 |    2 -
 arch/arm/mach-s5pv210/common.h                 |    4 ++-
 arch/arm/mach-sa1100/generic.c                 |    5 ++--
 arch/arm/mach-sa1100/generic.h                 |    3 +-
 arch/arm/mach-shark/core.c                     |    3 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c |    3 +-
 arch/arm/mach-shmobile/board-kzm9g.c           |    3 +-
 arch/arm/mach-socfpga/socfpga.c                |    3 +-
 arch/arm/mach-spear/generic.h                  |    4 ++-
 arch/arm/mach-spear/restart.c                  |    5 ++--
 arch/arm/mach-sunxi/sunxi.c                    |    3 +-
 arch/arm/mach-tegra/board.h                    |    3 +-
 arch/arm/mach-tegra/common.c                   |    3 +-
 arch/arm/mach-u300/core.c                      |    6 ++---
 arch/arm/mach-versatile/core.c                 |    3 +-
 arch/arm/mach-versatile/core.h                 |    3 +-
 arch/arm/mach-vt8500/vt8500.c                  |    3 +-
 arch/arm/mach-w90x900/cpu.c                    |    4 +--
 arch/arm/mach-w90x900/nuc9xx.h                 |    5 +++-
 arch/arm/plat-iop/gpio.c                       |    1 
 arch/arm/plat-iop/restart.c                    |    2 -
 drivers/power/reset/restart-poweroff.c         |    3 +-
 drivers/power/reset/vexpress-poweroff.c        |    2 -
 include/linux/reboot.h                         |    1 
 include/linux/vexpress.h                       |    1 
 126 files changed, 283 insertions(+), 167 deletions(-)

diff -puN arch/arm/include/asm/hardware/iop3xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/include/asm/hardware/iop3xx.h
--- a/arch/arm/include/asm/hardware/iop3xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/include/asm/hardware/iop3xx.h
@@ -223,11 +223,12 @@ extern int iop3xx_get_init_atu(void);
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <linux/reboot.h>
 
 void iop3xx_map_io(void);
 void iop_init_cp6_handler(void);
 void iop_init_time(unsigned long tickrate);
-void iop3xx_restart(char, const char *);
+void iop3xx_restart(enum reboot_mode, const char *);
 
 static inline u32 read_tmr0(void)
 {
diff -puN arch/arm/include/asm/mach/arch.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/include/asm/mach/arch.h
--- a/arch/arm/include/asm/mach/arch.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/include/asm/mach/arch.h
@@ -54,7 +54,7 @@ struct machine_desc {
 #ifdef CONFIG_MULTI_IRQ_HANDLER
 	void			(*handle_irq)(struct pt_regs *);
 #endif
-	void			(*restart)(char, const char *);
+	void			(*restart)(enum reboot_mode, const char *);
 };
 
 /*
diff -puN arch/arm/include/asm/system_misc.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/include/asm/system_misc.h
--- a/arch/arm/include/asm/system_misc.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/include/asm/system_misc.h
@@ -6,11 +6,12 @@
 #include <linux/compiler.h>
 #include <linux/linkage.h>
 #include <linux/irqflags.h>
+#include <linux/reboot.h>
 
 extern void cpu_init(void);
 
 void soft_restart(unsigned long);
-extern void (*arm_pm_restart)(char str, const char *cmd);
+extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 extern void (*arm_pm_idle)(void);
 
 #define UDBG_UNDEFINED	(1 << 0)
diff -puN arch/arm/kernel/process.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/kernel/process.c
@@ -32,6 +32,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/cpuidle.h>
 #include <linux/leds.h>
+#include <linux/reboot.h>
 
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
@@ -112,7 +113,7 @@ void soft_restart(unsigned long addr)
 	BUG();
 }
 
-static void null_restart(char mode, const char *cmd)
+static void null_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 }
 
@@ -122,7 +123,7 @@ static void null_restart(char mode, cons
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-void (*arm_pm_restart)(char str, const char *cmd) = null_restart;
+void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
 EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 /*
diff -puN arch/arm/mach-at91/at91rm9200.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-at91/at91rm9200.c
--- a/arch/arm/mach-at91/at91rm9200.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-at91/at91rm9200.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/reboot.h>
 
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
@@ -304,7 +305,7 @@ static void at91rm9200_idle(void)
 	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
 }
 
-static void at91rm9200_restart(char mode, const char *cmd)
+static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 	/*
 	 * Perform a hardware reset with the use of the Watchdog timer.
diff -puN arch/arm/mach-at91/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-at91/generic.h
--- a/arch/arm/mach-at91/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-at91/generic.h
@@ -10,6 +10,7 @@
 
 #include <linux/clkdev.h>
 #include <linux/of.h>
+#include <linux/reboot.h>
 
  /* Map io */
 extern void __init at91_map_io(void);
@@ -60,8 +61,8 @@ extern void at91sam9_idle(void);
 
 /* reset */
 extern void at91_ioremap_rstc(u32 base_addr);
-extern void at91sam9_alt_restart(char, const char *);
-extern void at91sam9g45_restart(char, const char *);
+extern void at91sam9_alt_restart(enum reboot_mode, const char *);
+extern void at91sam9g45_restart(enum reboot_mode, const char *);
 
 /* shutdown */
 extern void at91_ioremap_shdwc(u32 base_addr);
diff -puN arch/arm/mach-bcm2835/bcm2835.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-bcm2835/bcm2835.c
--- a/arch/arm/mach-bcm2835/bcm2835.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-bcm2835/bcm2835.c
@@ -53,7 +53,7 @@ static void bcm2835_setup_restart(void)
 	WARN(!wdt_regs, "failed to remap watchdog regs");
 }
 
-static void bcm2835_restart(char mode, const char *cmd)
+static void bcm2835_restart(enum reboot_mode mode, const char *cmd)
 {
 	u32 val;
 
@@ -91,7 +91,7 @@ static void bcm2835_power_off(void)
 	writel_relaxed(val, wdt_regs + PM_RSTS);
 
 	/* Continue with normal reset mechanism */
-	bcm2835_restart(0, "");
+	bcm2835_restart(REBOOT_COLD, "");
 }
 
 static struct map_desc io_map __initdata = {
diff -puN arch/arm/mach-clps711x/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-clps711x/common.c
--- a/arch/arm/mach-clps711x/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-clps711x/common.c
@@ -345,7 +345,7 @@ void __init clps711x_timer_init(void)
 	setup_irq(IRQ_TC2OI, &clps711x_timer_irq);
 }
 
-void clps711x_restart(char mode, const char *cmd)
+void clps711x_restart(enum reboot_mode mode, const char *cmd)
 {
 	soft_restart(0);
 }
diff -puN arch/arm/mach-clps711x/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-clps711x/common.h
--- a/arch/arm/mach-clps711x/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-clps711x/common.h
@@ -4,6 +4,8 @@
  * Common bits.
  */
 
+#include <linux/reboot.h>
+
 #define CLPS711X_NR_IRQS	(33)
 #define CLPS711X_NR_GPIO	(4 * 8 + 3)
 #define CLPS711X_GPIO(prt, bit)	((prt) * 8 + (bit))
@@ -12,4 +14,4 @@ extern void clps711x_map_io(void);
 extern void clps711x_init_irq(void);
 extern void clps711x_timer_init(void);
 extern void clps711x_handle_irq(struct pt_regs *regs);
-extern void clps711x_restart(char mode, const char *cmd);
+extern void clps711x_restart(enum reboot_mode mode, const char *cmd);
diff -puN arch/arm/mach-cns3xxx/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-cns3xxx/core.h
--- a/arch/arm/mach-cns3xxx/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-cns3xxx/core.h
@@ -11,6 +11,8 @@
 #ifndef __CNS3XXX_CORE_H
 #define __CNS3XXX_CORE_H
 
+#include <linux/reboot.h>
+
 extern void cns3xxx_timer_init(void);
 
 #ifdef CONFIG_CACHE_L2X0
@@ -22,6 +24,6 @@ static inline void cns3xxx_l2x0_init(voi
 void __init cns3xxx_map_io(void);
 void __init cns3xxx_init_irq(void);
 void cns3xxx_power_off(void);
-void cns3xxx_restart(char, const char *);
+void cns3xxx_restart(enum reboot_mode, const char *);
 
 #endif /* __CNS3XXX_CORE_H */
diff -puN arch/arm/mach-cns3xxx/pm.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-cns3xxx/pm.c
--- a/arch/arm/mach-cns3xxx/pm.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-cns3xxx/pm.c
@@ -89,7 +89,7 @@ void cns3xxx_pwr_soft_rst(unsigned int b
 }
 EXPORT_SYMBOL(cns3xxx_pwr_soft_rst);
 
-void cns3xxx_restart(char mode, const char *cmd)
+void cns3xxx_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * To reset, we hit the on-board reset register
diff -puN arch/arm/mach-davinci/devices-da8xx.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-davinci/devices-da8xx.c
--- a/arch/arm/mach-davinci/devices-da8xx.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-davinci/devices-da8xx.c
@@ -16,6 +16,7 @@
 #include <linux/serial_8250.h>
 #include <linux/ahci_platform.h>
 #include <linux/clk.h>
+#include <linux/reboot.h>
 
 #include <mach/cputype.h>
 #include <mach/common.h>
@@ -366,7 +367,7 @@ static struct platform_device da8xx_wdt_
 	.resource	= da8xx_watchdog_resources,
 };
 
-void da8xx_restart(char mode, const char *cmd)
+void da8xx_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device *dev;
 
diff -puN arch/arm/mach-davinci/devices.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-davinci/devices.c
--- a/arch/arm/mach-davinci/devices.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-davinci/devices.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 
 #include <mach/hardware.h>
 #include <linux/platform_data/i2c-davinci.h>
@@ -303,7 +304,7 @@ struct platform_device davinci_wdt_devic
 	.resource	= wdt_resources,
 };
 
-void davinci_restart(char mode, const char *cmd)
+void davinci_restart(enum reboot_mode mode, const char *cmd)
 {
 	davinci_watchdog_reset(&davinci_wdt_device);
 }
diff -puN arch/arm/mach-davinci/include/mach/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-davinci/include/mach/common.h
--- a/arch/arm/mach-davinci/include/mach/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-davinci/include/mach/common.h
@@ -14,6 +14,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/reboot.h>
 
 extern void davinci_timer_init(void);
 
@@ -81,7 +82,7 @@ extern struct davinci_soc_info davinci_s
 
 extern void davinci_common_init(struct davinci_soc_info *soc_info);
 extern void davinci_init_ide(void);
-void davinci_restart(char mode, const char *cmd);
+void davinci_restart(enum reboot_mode mode, const char *cmd);
 void davinci_init_late(void);
 
 #ifdef CONFIG_DAVINCI_RESET_CLOCKS
diff -puN arch/arm/mach-davinci/include/mach/da8xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-davinci/include/mach/da8xx.h
--- a/arch/arm/mach-davinci/include/mach/da8xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-davinci/include/mach/da8xx.h
@@ -17,6 +17,7 @@
 #include <linux/davinci_emac.h>
 #include <linux/spi/spi.h>
 #include <linux/platform_data/davinci_asp.h>
+#include <linux/reboot.h>
 #include <linux/videodev2.h>
 
 #include <mach/serial.h>
@@ -106,7 +107,7 @@ int __init da850_register_vpif_display
 			(struct vpif_display_config *display_config);
 int __init da850_register_vpif_capture
 			(struct vpif_capture_config *capture_config);
-void da8xx_restart(char mode, const char *cmd);
+void da8xx_restart(enum reboot_mode mode, const char *cmd);
 void da8xx_rproc_reserve_cma(void);
 int da8xx_register_rproc(void);
 
diff -puN arch/arm/mach-davinci/include/mach/tnetv107x.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-davinci/include/mach/tnetv107x.h
--- a/arch/arm/mach-davinci/include/mach/tnetv107x.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-davinci/include/mach/tnetv107x.h
@@ -35,6 +35,7 @@
 #include <linux/serial_8250.h>
 #include <linux/input/matrix_keypad.h>
 #include <linux/mfd/ti_ssp.h>
+#include <linux/reboot.h>
 
 #include <linux/platform_data/mmc-davinci.h>
 #include <linux/platform_data/mtd-davinci.h>
@@ -54,7 +55,7 @@ extern struct platform_device tnetv107x_
 extern void __init tnetv107x_init(void);
 extern void __init tnetv107x_devices_init(struct tnetv107x_device_info *);
 extern void __init tnetv107x_irq_init(void);
-void tnetv107x_restart(char mode, const char *cmd);
+void tnetv107x_restart(enum reboot_mode mode, const char *cmd);
 
 #endif
 
diff -puN arch/arm/mach-davinci/tnetv107x.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-davinci/tnetv107x.c
--- a/arch/arm/mach-davinci/tnetv107x.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-davinci/tnetv107x.c
@@ -19,6 +19,7 @@
 #include <linux/io.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 
 #include <asm/mach/map.h>
 
@@ -730,7 +731,7 @@ static void tnetv107x_watchdog_reset(str
 	__raw_writel(1, &regs->kick);
 }
 
-void tnetv107x_restart(char mode, const char *cmd)
+void tnetv107x_restart(enum reboot_mode mode, const char *cmd)
 {
 	tnetv107x_watchdog_reset(&tnetv107x_wdt_device);
 }
diff -puN arch/arm/mach-dove/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-dove/common.c
--- a/arch/arm/mach-dove/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-dove/common.c
@@ -382,7 +382,7 @@ void __init dove_init(void)
 	dove_xor1_init();
 }
 
-void dove_restart(char mode, const char *cmd)
+void dove_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Enable soft reset to assert RSTOUTn.
diff -puN arch/arm/mach-dove/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-dove/common.h
--- a/arch/arm/mach-dove/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-dove/common.h
@@ -11,6 +11,8 @@
 #ifndef __ARCH_DOVE_COMMON_H
 #define __ARCH_DOVE_COMMON_H
 
+#include <linux/reboot.h>
+
 struct mv643xx_eth_platform_data;
 struct mv_sata_platform_data;
 
@@ -42,6 +44,6 @@ void dove_spi1_init(void);
 void dove_i2c_init(void);
 void dove_sdio0_init(void);
 void dove_sdio1_init(void);
-void dove_restart(char, const char *);
+void dove_restart(enum reboot_mode, const char *);
 
 #endif
diff -puN arch/arm/mach-ebsa110/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ebsa110/core.c
--- a/arch/arm/mach-ebsa110/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ebsa110/core.c
@@ -311,7 +311,7 @@ static int __init ebsa110_init(void)
 
 arch_initcall(ebsa110_init);
 
-static void ebsa110_restart(char mode, const char *cmd)
+static void ebsa110_restart(enum reboot_mode mode, const char *cmd)
 {
 	soft_restart(0x80000000);
 }
diff -puN arch/arm/mach-ep93xx/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ep93xx/core.c
--- a/arch/arm/mach-ep93xx/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ep93xx/core.c
@@ -35,6 +35,7 @@
 #include <linux/spi/spi.h>
 #include <linux/export.h>
 #include <linux/irqchip/arm-vic.h>
+#include <linux/reboot.h>
 
 #include <mach/hardware.h>
 #include <linux/platform_data/video-ep93xx.h>
@@ -921,7 +922,7 @@ void __init ep93xx_init_devices(void)
 	gpio_led_register_device(-1, &ep93xx_led_data);
 }
 
-void ep93xx_restart(char mode, const char *cmd)
+void ep93xx_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Set then clear the SWRST bit to initiate a software reset
diff -puN arch/arm/mach-ep93xx/include/mach/platform.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ep93xx/include/mach/platform.h
--- a/arch/arm/mach-ep93xx/include/mach/platform.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ep93xx/include/mach/platform.h
@@ -4,6 +4,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/reboot.h>
+
 struct i2c_gpio_platform_data;
 struct i2c_board_info;
 struct spi_board_info;
@@ -55,7 +57,7 @@ void ep93xx_ide_release_gpio(struct plat
 void ep93xx_init_devices(void);
 extern void ep93xx_timer_init(void);
 
-void ep93xx_restart(char, const char *);
+void ep93xx_restart(enum reboot_mode, const char *);
 void ep93xx_init_late(void);
 
 #ifdef CONFIG_CRUNCH
diff -puN arch/arm/mach-exynos/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-exynos/common.c
--- a/arch/arm/mach-exynos/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-exynos/common.c
@@ -302,12 +302,12 @@ static struct map_desc exynos5440_iodesc
 	},
 };
 
-void exynos4_restart(char mode, const char *cmd)
+void exynos4_restart(enum reboot_mode mode, const char *cmd)
 {
 	__raw_writel(0x1, S5P_SWRESET);
 }
 
-void exynos5_restart(char mode, const char *cmd)
+void exynos5_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val;
diff -puN arch/arm/mach-exynos/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-exynos/common.h
--- a/arch/arm/mach-exynos/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-exynos/common.h
@@ -12,6 +12,7 @@
 #ifndef __ARCH_ARM_MACH_EXYNOS_COMMON_H
 #define __ARCH_ARM_MACH_EXYNOS_COMMON_H
 
+#include <linux/reboot.h>
 #include <linux/of.h>
 
 void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
@@ -22,8 +23,8 @@ struct map_desc;
 void exynos_init_io(struct map_desc *mach_desc, int size);
 void exynos4_init_irq(void);
 void exynos5_init_irq(void);
-void exynos4_restart(char mode, const char *cmd);
-void exynos5_restart(char mode, const char *cmd);
+void exynos4_restart(enum reboot_mode mode, const char *cmd);
+void exynos5_restart(enum reboot_mode mode, const char *cmd);
 void exynos_init_late(void);
 
 /* ToDo: remove these after migrating legacy exynos4 platforms to dt */
diff -puN arch/arm/mach-footbridge/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-footbridge/common.c
--- a/arch/arm/mach-footbridge/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-footbridge/common.c
@@ -198,9 +198,9 @@ void __init footbridge_map_io(void)
 	}
 }
 
-void footbridge_restart(char mode, const char *cmd)
+void footbridge_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's') {
+	if (mode == REBOOT_WARM) {
 		/* Jump into the ROM */
 		soft_restart(0x41000000);
 	} else {
diff -puN arch/arm/mach-footbridge/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-footbridge/common.h
--- a/arch/arm/mach-footbridge/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-footbridge/common.h
@@ -1,3 +1,4 @@
+#include <linux/reboot.h>
 
 extern void footbridge_timer_init(void);
 extern void isa_timer_init(void);
@@ -8,4 +9,4 @@ extern void footbridge_map_io(void);
 extern void footbridge_init_irq(void);
 
 extern void isa_init_irq(unsigned int irq);
-extern void footbridge_restart(char, const char *);
+extern void footbridge_restart(enum reboot_mode, const char *);
diff -puN arch/arm/mach-footbridge/netwinder-hw.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-footbridge/netwinder-hw.c
--- a/arch/arm/mach-footbridge/netwinder-hw.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-footbridge/netwinder-hw.c
@@ -634,9 +634,9 @@ fixup_netwinder(struct tag *tags, char *
 #endif
 }
 
-static void netwinder_restart(char mode, const char *cmd)
+static void netwinder_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's') {
+	if (mode == REBOOT_WARM) {
 		/* Jump into the ROM */
 		soft_restart(0x41000000);
 	} else {
diff -puN arch/arm/mach-highbank/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-highbank/core.h
--- a/arch/arm/mach-highbank/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-highbank/core.h
@@ -1,8 +1,10 @@
 #ifndef __HIGHBANK_CORE_H
 #define __HIGHBANK_CORE_H
 
+#include <linux/reboot.h>
+
 extern void highbank_set_cpu_jump(int cpu, void *jump_addr);
-extern void highbank_restart(char, const char *);
+extern void highbank_restart(enum reboot_mode, const char *);
 extern void __iomem *scu_base_addr;
 
 #ifdef CONFIG_PM_SLEEP
diff -puN arch/arm/mach-highbank/system.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-highbank/system.c
--- a/arch/arm/mach-highbank/system.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-highbank/system.c
@@ -15,13 +15,14 @@
  */
 #include <linux/io.h>
 #include <asm/proc-fns.h>
+#include <linux/reboot.h>
 
 #include "core.h"
 #include "sysregs.h"
 
-void highbank_restart(char mode, const char *cmd)
+void highbank_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 'h')
+	if (mode == REBOOT_COLD)
 		highbank_set_pwr_hard_reset();
 	else
 		highbank_set_pwr_soft_reset();
diff -puN arch/arm/mach-imx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-imx/common.h
--- a/arch/arm/mach-imx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-imx/common.h
@@ -11,6 +11,8 @@
 #ifndef __ASM_ARCH_MXC_COMMON_H__
 #define __ASM_ARCH_MXC_COMMON_H__
 
+#include <linux/reboot.h>
+
 struct platform_device;
 struct clk;
 enum mxc_cpu_pwr_mode;
@@ -71,7 +73,7 @@ extern int mx6q_clocks_init(void);
 extern struct platform_device *mxc_register_gpio(char *name, int id,
 	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high);
 extern void mxc_set_cpu_type(unsigned int type);
-extern void mxc_restart(char, const char *);
+extern void mxc_restart(enum reboot_mode, const char *);
 extern void mxc_arch_reset_init(void __iomem *);
 extern int mx53_revision(void);
 extern int imx6q_revision(void);
diff -puN arch/arm/mach-imx/mach-imx6q.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-imx/mach-imx6q.c
--- a/arch/arm/mach-imx/mach-imx6q.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-imx/mach-imx6q.c
@@ -26,6 +26,7 @@
 #include <linux/of_platform.h>
 #include <linux/opp.h>
 #include <linux/phy.h>
+#include <linux/reboot.h>
 #include <linux/regmap.h>
 #include <linux/micrel_phy.h>
 #include <linux/mfd/syscon.h>
@@ -66,7 +67,7 @@ static void __init imx6q_init_revision(v
 	mxc_set_cpu_type(rev >> 16 & 0xff);
 }
 
-static void imx6q_restart(char mode, const char *cmd)
+static void imx6q_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	void __iomem *wdog_base;
diff -puN arch/arm/mach-imx/system.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-imx/system.c
--- a/arch/arm/mach-imx/system.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-imx/system.c
@@ -34,7 +34,7 @@ static void __iomem *wdog_base;
 /*
  * Reset the system. It is called by machine_restart().
  */
-void mxc_restart(char mode, const char *cmd)
+void mxc_restart(enum reboot_mode mode, const char *cmd)
 {
 	unsigned int wcr_enable;
 
diff -puN arch/arm/mach-integrator/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-integrator/common.h
--- a/arch/arm/mach-integrator/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-integrator/common.h
@@ -1,7 +1,8 @@
+#include <linux/reboot.h>
 #include <linux/amba/serial.h>
 extern struct amba_pl010_data ap_uart_data;
 void integrator_init_early(void);
 int integrator_init(bool is_cp);
 void integrator_reserve(void);
-void integrator_restart(char, const char *);
+void integrator_restart(enum reboot_mode, const char *);
 void integrator_init_sysfs(struct device *parent, u32 id);
diff -puN arch/arm/mach-integrator/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-integrator/core.c
--- a/arch/arm/mach-integrator/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-integrator/core.c
@@ -124,7 +124,7 @@ void __init integrator_reserve(void)
 /*
  * To reset, we hit the on-board reset register in the system FPGA
  */
-void integrator_restart(char mode, const char *cmd)
+void integrator_restart(enum reboot_mode mode, const char *cmd)
 {
 	cm_control(CM_CTRL_RESET, CM_CTRL_RESET);
 }
diff -puN arch/arm/mach-iop13xx/include/mach/iop13xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-iop13xx/include/mach/iop13xx.h
--- a/arch/arm/mach-iop13xx/include/mach/iop13xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-iop13xx/include/mach/iop13xx.h
@@ -2,6 +2,9 @@
 #define _IOP13XX_HW_H_
 
 #ifndef __ASSEMBLY__
+
+#include <linux/reboot.h>
+
 /* The ATU offsets can change based on the strapping */
 extern u32 iop13xx_atux_pmmr_offset;
 extern u32 iop13xx_atue_pmmr_offset;
@@ -11,7 +14,7 @@ void iop13xx_map_io(void);
 void iop13xx_platform_init(void);
 void iop13xx_add_tpmi_devices(void);
 void iop13xx_init_irq(void);
-void iop13xx_restart(char, const char *);
+void iop13xx_restart(enum reboot_mode, const char *);
 
 /* CPUID CP6 R0 Page 0 */
 static inline int iop13xx_cpu_id(void)
diff -puN arch/arm/mach-iop13xx/setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-iop13xx/setup.c
--- a/arch/arm/mach-iop13xx/setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-iop13xx/setup.c
@@ -597,7 +597,7 @@ __setup("iop13xx_init_adma", iop13xx_ini
 __setup("iop13xx_init_uart", iop13xx_init_uart_setup);
 __setup("iop13xx_init_i2c", iop13xx_init_i2c_setup);
 
-void iop13xx_restart(char mode, const char *cmd)
+void iop13xx_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Reset the internal bus (warning both cores are reset)
diff -puN arch/arm/mach-iop32x/n2100.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-iop32x/n2100.c
--- a/arch/arm/mach-iop32x/n2100.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-iop32x/n2100.c
@@ -286,7 +286,7 @@ static void n2100_power_off(void)
 		;
 }
 
-static void n2100_restart(char mode, const char *cmd)
+static void n2100_restart(enum reboot_mode mode, const char *cmd)
 {
 	gpio_line_set(N2100_HARDWARE_RESET, GPIO_LOW);
 	gpio_line_config(N2100_HARDWARE_RESET, GPIO_OUT);
diff -puN arch/arm/mach-ixp4xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -531,9 +531,9 @@ static void __init ixp4xx_clockevent_ini
 					0xf, 0xfffffffe);
 }
 
-void ixp4xx_restart(char mode, const char *cmd)
+void ixp4xx_restart(enum reboot_mode mode, const char *cmd)
 {
-	if ( 1 && mode == 's') {
+	if ( 1 && mode == REBOOT_WARM) {
 		/* Jump into ROM at address 0 */
 		soft_restart(0);
 	} else {
diff -puN arch/arm/mach-ixp4xx/dsmg600-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ixp4xx/dsmg600-setup.c
--- a/arch/arm/mach-ixp4xx/dsmg600-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ixp4xx/dsmg600-setup.c
@@ -27,6 +27,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
 
+#include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
diff -puN arch/arm/mach-ixp4xx/include/mach/platform.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ixp4xx/include/mach/platform.h
--- a/arch/arm/mach-ixp4xx/include/mach/platform.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ixp4xx/include/mach/platform.h
@@ -13,6 +13,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/reboot.h>
+
 #include <asm/types.h>
 
 #ifndef	__ARMEB__
@@ -123,7 +125,7 @@ extern void ixp4xx_init_early(void);
 extern void ixp4xx_init_irq(void);
 extern void ixp4xx_sys_init(void);
 extern void ixp4xx_timer_init(void);
-extern void ixp4xx_restart(char, const char *);
+extern void ixp4xx_restart(enum reboot_mode, const char *);
 extern void ixp4xx_pci_preinit(void);
 struct pci_sys_data;
 extern int ixp4xx_setup(int nr, struct pci_sys_data *sys);
diff -puN arch/arm/mach-ixp4xx/include/mach/timex.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ixp4xx/include/mach/timex.h
--- a/arch/arm/mach-ixp4xx/include/mach/timex.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ixp4xx/include/mach/timex.h
@@ -3,7 +3,7 @@
  * 
  */
 
-#include <mach/hardware.h>
+// #include <mach/hardware.h>
 
 /*
  * We use IXP425 General purpose timer for our timer needs, it runs at 
diff -puN arch/arm/mach-kirkwood/board-lsxl.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-kirkwood/board-lsxl.c
--- a/arch/arm/mach-kirkwood/board-lsxl.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-kirkwood/board-lsxl.c
@@ -35,7 +35,7 @@ static struct mv643xx_eth_platform_data
  */
 static void lsxl_power_off(void)
 {
-	kirkwood_restart('h', NULL);
+	kirkwood_restart(REBOOT_COLD, NULL);
 }
 
 void __init lsxl_init(void)
diff -puN arch/arm/mach-kirkwood/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-kirkwood/common.c
--- a/arch/arm/mach-kirkwood/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-kirkwood/common.c
@@ -20,6 +20,7 @@
 #include <linux/mv643xx_i2c.h>
 #include <linux/timex.h>
 #include <linux/kexec.h>
+#include <linux/reboot.h>
 #include <net/dsa.h>
 #include <asm/page.h>
 #include <asm/mach/map.h>
@@ -729,7 +730,7 @@ void __init kirkwood_init(void)
 #endif
 }
 
-void kirkwood_restart(char mode, const char *cmd)
+void kirkwood_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Enable soft reset to assert RSTOUTn.
diff -puN arch/arm/mach-kirkwood/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-kirkwood/common.h
--- a/arch/arm/mach-kirkwood/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-kirkwood/common.h
@@ -11,6 +11,8 @@
 #ifndef __ARCH_KIRKWOOD_COMMON_H
 #define __ARCH_KIRKWOOD_COMMON_H
 
+#include <linux/reboot.h>
+
 struct dsa_platform_data;
 struct mv643xx_eth_platform_data;
 struct mv_sata_platform_data;
@@ -51,7 +53,7 @@ void kirkwood_nand_init_rnb(struct mtd_p
 			    int (*dev_ready)(struct mtd_info *));
 void kirkwood_audio_init(void);
 void kirkwood_cpuidle_init(void);
-void kirkwood_restart(char, const char *);
+void kirkwood_restart(enum reboot_mode, const char *);
 void kirkwood_clk_init(void);
 
 /* board init functions for boards not fully converted to fdt */
diff -puN arch/arm/mach-ks8695/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ks8695/generic.h
--- a/arch/arm/mach-ks8695/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ks8695/generic.h
@@ -12,5 +12,5 @@
 
 extern __init void ks8695_map_io(void);
 extern __init void ks8695_init_irq(void);
-extern void ks8695_restart(char, const char *);
+extern void ks8695_restart(enum reboot_mode, const char *);
 extern void ks8695_timer_init(void);
diff -puN arch/arm/mach-ks8695/time.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-ks8695/time.c
--- a/arch/arm/mach-ks8695/time.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-ks8695/time.c
@@ -154,11 +154,11 @@ void __init ks8695_timer_init(void)
 	setup_irq(KS8695_IRQ_TIMER1, &ks8695_timer_irq);
 }
 
-void ks8695_restart(char mode, const char *cmd)
+void ks8695_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 	unsigned int reg;
 
-	if (mode == 's')
+	if (reboot_mode == REBOOT_WARM)
 		soft_restart(0);
 
 	/* disable timer0 */
diff -puN arch/arm/mach-lpc32xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-lpc32xx/common.c
--- a/arch/arm/mach-lpc32xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-lpc32xx/common.c
@@ -207,11 +207,11 @@ void __init lpc32xx_map_io(void)
 	iotable_init(lpc32xx_io_desc, ARRAY_SIZE(lpc32xx_io_desc));
 }
 
-void lpc23xx_restart(char mode, const char *cmd)
+void lpc23xx_restart(enum reboot_mode mode, const char *cmd)
 {
 	switch (mode) {
-	case 's':
-	case 'h':
+	case REBOOT_WARM:
+	case REBOOT_COLD:
 		lpc32xx_watchdog_reset();
 		break;
 
diff -puN arch/arm/mach-lpc32xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-lpc32xx/common.h
--- a/arch/arm/mach-lpc32xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-lpc32xx/common.h
@@ -21,6 +21,7 @@
 
 #include <mach/board.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 
 /*
  * Other arch specific structures and functions
@@ -29,7 +30,7 @@ extern void lpc32xx_timer_init(void);
 extern void __init lpc32xx_init_irq(void);
 extern void __init lpc32xx_map_io(void);
 extern void __init lpc32xx_serial_init(void);
-extern void lpc23xx_restart(char, const char *);
+extern void lpc23xx_restart(enum reboot_mode, const char *);
 
 
 /*
diff -puN arch/arm/mach-mmp/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mmp/common.c
--- a/arch/arm/mach-mmp/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mmp/common.c
@@ -47,7 +47,7 @@ void __init mmp_map_io(void)
 	mmp_chip_id = __raw_readl(MMP_CHIPID);
 }
 
-void mmp_restart(char mode, const char *cmd)
+void mmp_restart(enum reboot_mode mode, const char *cmd)
 {
 	soft_restart(0);
 }
diff -puN arch/arm/mach-mmp/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mmp/common.h
--- a/arch/arm/mach-mmp/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mmp/common.h
@@ -1,10 +1,11 @@
+#include <linux/reboot.h>
 #define ARRAY_AND_SIZE(x)	(x), ARRAY_SIZE(x)
 
 extern void timer_init(int irq);
 
 extern void __init icu_init_irq(void);
 extern void __init mmp_map_io(void);
-extern void mmp_restart(char, const char *);
+extern void mmp_restart(enum reboot_mode, const char *);
 extern void __init pxa168_clk_init(void);
 extern void __init pxa910_clk_init(void);
 extern void __init mmp2_clk_init(void);
diff -puN arch/arm/mach-mmp/include/mach/pxa168.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mmp/include/mach/pxa168.h
--- a/arch/arm/mach-mmp/include/mach/pxa168.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mmp/include/mach/pxa168.h
@@ -1,9 +1,11 @@
 #ifndef __ASM_MACH_PXA168_H
 #define __ASM_MACH_PXA168_H
 
+#include <linux/reboot.h>
+
 extern void pxa168_timer_init(void);
 extern void __init pxa168_init_irq(void);
-extern void pxa168_restart(char, const char *);
+extern void pxa168_restart(enum reboot_mode, const char *);
 extern void pxa168_clear_keypad_wakeup(void);
 
 #include <linux/i2c.h>
diff -puN arch/arm/mach-mmp/pxa168.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mmp/pxa168.c
--- a/arch/arm/mach-mmp/pxa168.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mmp/pxa168.c
@@ -172,7 +172,7 @@ int __init pxa168_add_usb_host(struct mv
 	return platform_device_register(&pxa168_device_usb_host);
 }
 
-void pxa168_restart(char mode, const char *cmd)
+void pxa168_restart(enum reboot_mode mode, const char *cmd)
 {
 	soft_restart(0xffff0000);
 }
diff -puN arch/arm/mach-mv78xx0/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mv78xx0/common.c
--- a/arch/arm/mach-mv78xx0/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mv78xx0/common.c
@@ -413,7 +413,7 @@ void __init mv78xx0_init(void)
 	clk_init();
 }
 
-void mv78xx0_restart(char mode, const char *cmd)
+void mv78xx0_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Enable soft reset to assert RSTOUTn.
diff -puN arch/arm/mach-mv78xx0/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mv78xx0/common.h
--- a/arch/arm/mach-mv78xx0/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mv78xx0/common.h
@@ -11,6 +11,8 @@
 #ifndef __ARCH_MV78XX0_COMMON_H
 #define __ARCH_MV78XX0_COMMON_H
 
+#include <linux/reboot.h>
+
 struct mv643xx_eth_platform_data;
 struct mv_sata_platform_data;
 
@@ -45,7 +47,7 @@ void mv78xx0_uart1_init(void);
 void mv78xx0_uart2_init(void);
 void mv78xx0_uart3_init(void);
 void mv78xx0_i2c_init(void);
-void mv78xx0_restart(char, const char *);
+void mv78xx0_restart(enum reboot_mode, const char *);
 
 extern void mv78xx0_timer_init(void);
 
diff -puN arch/arm/mach-mvebu/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mvebu/common.h
--- a/arch/arm/mach-mvebu/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mvebu/common.h
@@ -15,7 +15,9 @@
 #ifndef __ARCH_MVEBU_COMMON_H
 #define __ARCH_MVEBU_COMMON_H
 
-void mvebu_restart(char mode, const char *cmd);
+#include <linux/reboot.h>
+
+void mvebu_restart(enum reboot_mode mode, const char *cmd);
 
 void armada_370_xp_init_irq(void);
 void armada_370_xp_handle_irq(struct pt_regs *regs);
diff -puN arch/arm/mach-mvebu/system-controller.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mvebu/system-controller.c
--- a/arch/arm/mach-mvebu/system-controller.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mvebu/system-controller.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/of_address.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 
 static void __iomem *system_controller_base;
 
@@ -63,7 +64,7 @@ static struct of_device_id of_system_con
 	{ /* end of list */ },
 };
 
-void mvebu_restart(char mode, const char *cmd)
+void mvebu_restart(enum reboot_mode mode, const char *cmd)
 {
 	if (!system_controller_base) {
 		pr_err("Cannot restart, system-controller not available: check the device tree\n");
diff -puN arch/arm/mach-mxs/mach-mxs.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-mxs/mach-mxs.c
--- a/arch/arm/mach-mxs/mach-mxs.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-mxs/mach-mxs.c
@@ -26,6 +26,8 @@
 #include <linux/of_platform.h>
 #include <linux/phy.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/reboot.h>
+
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
@@ -390,7 +392,7 @@ static void __init mxs_machine_init(void
 /*
  * Reset the system. It is called by machine_restart().
  */
-static void mxs_restart(char mode, const char *cmd)
+static void mxs_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	void __iomem *reset_addr;
diff -puN arch/arm/mach-netx/generic.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-netx/generic.c
--- a/arch/arm/mach-netx/generic.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-netx/generic.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/irqchip/arm-vic.h>
+#include <linux/reboot.h>
 #include <mach/hardware.h>
 #include <asm/mach/map.h>
 #include <mach/netx-regs.h>
@@ -187,7 +188,7 @@ static int __init netx_init(void)
 
 subsys_initcall(netx_init);
 
-void netx_restart(char mode, const char *cmd)
+void netx_restart(enum reboot_mode mode, const char *cmd)
 {
 	writel(NETX_SYSTEM_RES_CR_FIRMW_RES_EN | NETX_SYSTEM_RES_CR_FIRMW_RES,
 	       NETX_SYSTEM_RES_CR);
diff -puN arch/arm/mach-netx/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-netx/generic.h
--- a/arch/arm/mach-netx/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-netx/generic.h
@@ -17,8 +17,10 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/reboot.h>
+
 extern void __init netx_map_io(void);
 extern void __init netx_init_irq(void);
-extern void netx_restart(char, const char *);
+extern void netx_restart(enum reboot_mode, const char *);
 
 extern void netx_timer_init(void);
diff -puN arch/arm/mach-nomadik/cpu-8815.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-nomadik/cpu-8815.c
--- a/arch/arm/mach-nomadik/cpu-8815.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-nomadik/cpu-8815.c
@@ -148,7 +148,7 @@ static void __init cpu8815_map_io(void)
 	iotable_init(cpu8815_io_desc, ARRAY_SIZE(cpu8815_io_desc));
 }
 
-static void cpu8815_restart(char mode, const char *cmd)
+static void cpu8815_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *srcbase = ioremap(NOMADIK_SRC_BASE, SZ_4K);
 
diff -puN arch/arm/mach-omap1/board-voiceblue.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap1/board-voiceblue.c
--- a/arch/arm/mach-omap1/board-voiceblue.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap1/board-voiceblue.c
@@ -26,6 +26,7 @@
 #include <linux/serial_reg.h>
 #include <linux/smc91x.h>
 #include <linux/export.h>
+#include <linux/reboot.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -215,7 +216,7 @@ void voiceblue_wdt_ping(void)
 	gpio_set_value(0, wdt_gpio_state);
 }
 
-static void voiceblue_restart(char mode, const char *cmd)
+static void voiceblue_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Workaround for 5912/1611b bug mentioned in sprz209d.pdf p. 28
diff -puN arch/arm/mach-omap1/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap1/common.h
--- a/arch/arm/mach-omap1/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap1/common.h
@@ -28,6 +28,7 @@
 
 #include <linux/mtd/mtd.h>
 #include <linux/i2c-omap.h>
+#include <linux/reboot.h>
 
 #include <plat/i2c.h>
 
@@ -70,7 +71,7 @@ static inline int omap_serial_wakeup_ini
 void omap1_init_early(void);
 void omap1_init_irq(void);
 void omap1_init_late(void);
-void omap1_restart(char, const char *);
+void omap1_restart(enum reboot_mode, const char *);
 
 extern void __init omap_check_revision(void);
 
diff -puN arch/arm/mach-omap1/reset.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap1/reset.c
--- a/arch/arm/mach-omap1/reset.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap1/reset.c
@@ -3,6 +3,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 
 #include <mach/hardware.h>
 
@@ -22,7 +23,7 @@
 #define OMAP_EXTWARM_RST_SRC_ID_SHIFT			5
 
 
-void omap1_restart(char mode, const char *cmd)
+void omap1_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Workaround for 5912/1611b bug mentioned in sprz209d.pdf p. 28
diff -puN arch/arm/mach-omap2/am33xx-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap2/am33xx-restart.c
--- a/arch/arm/mach-omap2/am33xx-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap2/am33xx-restart.c
@@ -6,6 +6,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/kernel.h>
+#include <linux/reboot.h>
 
 #include "common.h"
 #include "prm-regbits-33xx.h"
@@ -19,7 +20,7 @@
  * Resets the SoC.  For @cmd, see the 'reboot' syscall in
  * kernel/sys.c.  No return value.
  */
-void am33xx_restart(char mode, const char *cmd)
+void am33xx_restart(enum reboot_mode mode, const char *cmd)
 {
 	/* TODO: Handle mode and cmd if necessary */
 
diff -puN arch/arm/mach-omap2/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap2/common.h
--- a/arch/arm/mach-omap2/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap2/common.h
@@ -31,6 +31,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c/twl.h>
 #include <linux/i2c-omap.h>
+#include <linux/reboot.h>
 
 #include <asm/proc-fns.h>
 
@@ -118,33 +119,33 @@ static inline void omap_soc_device_init(
 #endif
 
 #if defined(CONFIG_SOC_OMAP2420) || defined(CONFIG_SOC_OMAP2430)
-void omap2xxx_restart(char mode, const char *cmd);
+void omap2xxx_restart(enum reboot_mode mode, const char *cmd);
 #else
-static inline void omap2xxx_restart(char mode, const char *cmd)
+static inline void omap2xxx_restart(enum reboot_mode mode, const char *cmd)
 {
 }
 #endif
 
 #ifdef CONFIG_SOC_AM33XX
-void am33xx_restart(char mode, const char *cmd);
+void am33xx_restart(enum reboot_mode mode, const char *cmd);
 #else
-static inline void am33xx_restart(char mode, const char *cmd)
+static inline void am33xx_restart(enum reboot_mode mode, const char *cmd)
 {
 }
 #endif
 
 #ifdef CONFIG_ARCH_OMAP3
-void omap3xxx_restart(char mode, const char *cmd);
+void omap3xxx_restart(enum reboot_mode mode, const char *cmd);
 #else
-static inline void omap3xxx_restart(char mode, const char *cmd)
+static inline void omap3xxx_restart(enum reboot_mode mode, const char *cmd)
 {
 }
 #endif
 
 #if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5)
-void omap44xx_restart(char mode, const char *cmd);
+void omap44xx_restart(enum reboot_mode mode, const char *cmd);
 #else
-static inline void omap44xx_restart(char mode, const char *cmd)
+static inline void omap44xx_restart(enum reboot_mode mode, const char *cmd)
 {
 }
 #endif
diff -puN arch/arm/mach-omap2/omap2-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap2/omap2-restart.c
--- a/arch/arm/mach-omap2/omap2-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap2/omap2-restart.c
@@ -31,7 +31,7 @@ static struct clk *reset_virt_prcm_set_c
  * Set the DPLL to bypass so that reboot completes successfully.  No
  * return value.
  */
-void omap2xxx_restart(char mode, const char *cmd)
+void omap2xxx_restart(enum reboot_mode mode, const char *cmd)
 {
 	u32 rate;
 
diff -puN arch/arm/mach-omap2/omap3-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap2/omap3-restart.c
--- a/arch/arm/mach-omap2/omap3-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap2/omap3-restart.c
@@ -12,6 +12,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/reboot.h>
 
 #include "iomap.h"
 #include "common.h"
@@ -28,7 +29,7 @@
  * Resets the SoC.  For @cmd, see the 'reboot' syscall in
  * kernel/sys.c.  No return value.
  */
-void omap3xxx_restart(char mode, const char *cmd)
+void omap3xxx_restart(enum reboot_mode mode, const char *cmd)
 {
 	omap3_ctrl_write_boot_mode((cmd ? (u8)*cmd : 0));
 	omap3xxx_prm_dpll3_reset(); /* never returns */
diff -puN arch/arm/mach-omap2/omap4-common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-omap2/omap4-common.c
--- a/arch/arm/mach-omap2/omap4-common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-omap2/omap4-common.c
@@ -23,6 +23,7 @@
 #include <linux/export.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/of_address.h>
+#include <linux/reboot.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach/map.h>
@@ -348,7 +349,7 @@ int __init omap4_twl6030_hsmmc_init(stru
  * Resets the SoC.  For @cmd, see the 'reboot' syscall in
  * kernel/sys.c.  No return value.
  */
-void omap44xx_restart(char mode, const char *cmd)
+void omap44xx_restart(enum reboot_mode mode, const char *cmd)
 {
 	/* XXX Should save 'cmd' into scratchpad for use after reboot */
 	omap4_prminst_global_warm_sw_reset(); /* never returns */
diff -puN arch/arm/mach-orion5x/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-orion5x/common.c
@@ -354,7 +354,7 @@ void __init orion5x_init(void)
 	orion5x_wdt_init();
 }
 
-void orion5x_restart(char mode, const char *cmd)
+void orion5x_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Enable and issue soft reset
diff -puN arch/arm/mach-orion5x/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-orion5x/common.h
--- a/arch/arm/mach-orion5x/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-orion5x/common.h
@@ -1,6 +1,8 @@
 #ifndef __ARCH_ORION5X_COMMON_H
 #define __ARCH_ORION5X_COMMON_H
 
+#include <linux/reboot.h>
+
 struct dsa_platform_data;
 struct mv643xx_eth_platform_data;
 struct mv_sata_platform_data;
@@ -29,7 +31,7 @@ void orion5x_spi_init(void);
 void orion5x_uart0_init(void);
 void orion5x_uart1_init(void);
 void orion5x_xor_init(void);
-void orion5x_restart(char, const char *);
+void orion5x_restart(enum reboot_mode, const char *);
 
 /*
  * PCIe/PCI functions.
diff -puN arch/arm/mach-orion5x/ls-chl-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-orion5x/ls-chl-setup.c
--- a/arch/arm/mach-orion5x/ls-chl-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-orion5x/ls-chl-setup.c
@@ -139,7 +139,7 @@ static struct mv_sata_platform_data lsch
 
 static void lschl_power_off(void)
 {
-	orion5x_restart('h', NULL);
+	orion5x_restart(REBOOT_COLD, NULL);
 }
 
 /*****************************************************************************
diff -puN arch/arm/mach-orion5x/ls_hgl-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-orion5x/ls_hgl-setup.c
--- a/arch/arm/mach-orion5x/ls_hgl-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-orion5x/ls_hgl-setup.c
@@ -185,7 +185,7 @@ static struct mv_sata_platform_data ls_h
 
 static void ls_hgl_power_off(void)
 {
-	orion5x_restart('h', NULL);
+	orion5x_restart(REBOOT_COLD, NULL);
 }
 
 
diff -puN arch/arm/mach-orion5x/lsmini-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-orion5x/lsmini-setup.c
--- a/arch/arm/mach-orion5x/lsmini-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-orion5x/lsmini-setup.c
@@ -185,7 +185,7 @@ static struct mv_sata_platform_data lsmi
 
 static void lsmini_power_off(void)
 {
-	orion5x_restart('h', NULL);
+	orion5x_restart(REBOOT_COLD, NULL);
 }
 
 
diff -puN arch/arm/mach-picoxcell/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-picoxcell/common.c
--- a/arch/arm/mach-picoxcell/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-picoxcell/common.c
@@ -15,6 +15,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/reboot.h>
 #include <linux/dw_apb_timer.h>
 
 #include <asm/mach/arch.h>
@@ -70,7 +71,7 @@ static const char *picoxcell_dt_match[]
 	NULL
 };
 
-static void picoxcell_wdt_restart(char mode, const char *cmd)
+static void picoxcell_wdt_restart(enum reboot_mode mode, const char *cmd)
 {
 	/*
 	 * Configure the watchdog to reset with the shortest possible timeout
diff -puN arch/arm/mach-prima2/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-prima2/common.h
--- a/arch/arm/mach-prima2/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-prima2/common.h
@@ -10,6 +10,8 @@
 #define __MACH_PRIMA2_COMMON_H__
 
 #include <linux/init.h>
+#include <linux/reboot.h>
+
 #include <asm/mach/time.h>
 #include <asm/exception.h>
 
@@ -22,7 +24,7 @@ extern void sirfsoc_cpu_die(unsigned int
 
 extern void __init sirfsoc_of_irq_init(void);
 extern void __init sirfsoc_of_clk_init(void);
-extern void sirfsoc_restart(char, const char *);
+extern void sirfsoc_restart(enum reboot_mode, const char *);
 extern asmlinkage void __exception_irq_entry sirfsoc_handle_irq(struct pt_regs *regs);
 
 #ifndef CONFIG_DEBUG_LL
diff -puN arch/arm/mach-prima2/rstc.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-prima2/rstc.c
--- a/arch/arm/mach-prima2/rstc.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-prima2/rstc.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/reboot.h>
 
 void __iomem *sirfsoc_rstc_base;
 static DEFINE_MUTEX(rstc_lock);
@@ -82,7 +83,7 @@ int sirfsoc_reset_device(struct device *
 
 #define SIRFSOC_SYS_RST_BIT  BIT(31)
 
-void sirfsoc_restart(char mode, const char *cmd)
+void sirfsoc_restart(enum reboot_mode mode, const char *cmd)
 {
 	writel(SIRFSOC_SYS_RST_BIT, sirfsoc_rstc_base);
 }
diff -puN arch/arm/mach-pxa/corgi.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-pxa/corgi.c
--- a/arch/arm/mach-pxa/corgi.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-pxa/corgi.c
@@ -663,16 +663,16 @@ static void corgi_poweroff(void)
 		/* Green LED off tells the bootloader to halt */
 		gpio_set_value(CORGI_GPIO_LED_GREEN, 0);
 
-	pxa_restart('h', NULL);
+	pxa_restart(REBOOT_COLD, NULL);
 }
 
-static void corgi_restart(char mode, const char *cmd)
+static void corgi_restart(enum reboot_mode mode, const char *cmd)
 {
 	if (!machine_is_corgi())
 		/* Green LED on tells the bootloader to reboot */
 		gpio_set_value(CORGI_GPIO_LED_GREEN, 1);
 
-	pxa_restart('h', cmd);
+	pxa_restart(REBOOT_COLD, cmd);
 }
 
 static void __init corgi_init(void)
diff -puN arch/arm/mach-pxa/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-pxa/generic.h
--- a/arch/arm/mach-pxa/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-pxa/generic.h
@@ -9,6 +9,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/reboot.h>
+
 struct irq_data;
 
 extern void pxa_timer_init(void);
@@ -56,4 +58,4 @@ void __init pxa_set_btuart_info(void *in
 void __init pxa_set_stuart_info(void *info);
 void __init pxa_set_hwuart_info(void *info);
 
-void pxa_restart(char, const char *);
+void pxa_restart(enum reboot_mode, const char *);
diff -puN arch/arm/mach-pxa/mioa701.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-pxa/mioa701.c
--- a/arch/arm/mach-pxa/mioa701.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-pxa/mioa701.c
@@ -37,6 +37,7 @@
 #include <linux/wm97xx.h>
 #include <linux/mtd/physmap.h>
 #include <linux/usb/gpio_vbus.h>
+#include <linux/reboot.h>
 #include <linux/regulator/max1586.h>
 #include <linux/slab.h>
 #include <linux/i2c/pxa-i2c.h>
@@ -691,13 +692,13 @@ static void mioa701_machine_exit(void);
 static void mioa701_poweroff(void)
 {
 	mioa701_machine_exit();
-	pxa_restart('s', NULL);
+	pxa_restart(REBOOT_WARM, NULL);
 }
 
-static void mioa701_restart(char c, const char *cmd)
+static void mioa701_restart(enum reboot_mode c, const char *cmd)
 {
 	mioa701_machine_exit();
-	pxa_restart('s', cmd);
+	pxa_restart(REBOOT_WARM, cmd);
 }
 
 static struct gpio global_gpios[] = {
diff -puN arch/arm/mach-pxa/poodle.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-pxa/poodle.c
--- a/arch/arm/mach-pxa/poodle.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-pxa/poodle.c
@@ -422,7 +422,7 @@ static struct i2c_board_info __initdata
 
 static void poodle_poweroff(void)
 {
-	pxa_restart('h', NULL);
+	pxa_restart(REBOOT_COLD, NULL);
 }
 
 static void __init poodle_init(void)
diff -puN arch/arm/mach-pxa/reset.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-pxa/reset.c
--- a/arch/arm/mach-pxa/reset.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-pxa/reset.c
@@ -83,7 +83,7 @@ static void do_hw_reset(void)
 	writel_relaxed(readl_relaxed(OSCR) + 368640, OSMR3);
 }
 
-void pxa_restart(char mode, const char *cmd)
+void pxa_restart(enum reboot_mode mode, const char *cmd)
 {
 	local_irq_disable();
 	local_fiq_disable();
@@ -91,14 +91,14 @@ void pxa_restart(char mode, const char *
 	clear_reset_status(RESET_STATUS_ALL);
 
 	switch (mode) {
-	case 's':
+	case REBOOT_WARM:
 		/* Jump into ROM at address 0 */
 		soft_restart(0);
 		break;
-	case 'g':
+	case REBOOT_GPIO:
 		do_gpio_reset();
 		break;
-	case 'h':
+	case REBOOT_COLD:
 	default:
 		do_hw_reset();
 		break;
diff -puN arch/arm/mach-pxa/spitz.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-pxa/spitz.c
--- a/arch/arm/mach-pxa/spitz.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-pxa/spitz.c
@@ -31,6 +31,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/reboot.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -924,10 +925,10 @@ static inline void spitz_i2c_init(void)
  ******************************************************************************/
 static void spitz_poweroff(void)
 {
-	pxa_restart('g', NULL);
+	pxa_restart(REBOOT_GPIO, NULL);
 }
 
-static void spitz_restart(char mode, const char *cmd)
+static void spitz_restart(enum reboot_mode mode, const char *cmd)
 {
 	uint32_t msc0 = __raw_readl(MSC0);
 	/* Bootloader magic for a reboot */
diff -puN arch/arm/mach-pxa/tosa.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-pxa/tosa.c
--- a/arch/arm/mach-pxa/tosa.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-pxa/tosa.c
@@ -36,6 +36,7 @@
 #include <linux/input/matrix_keypad.h>
 #include <linux/i2c/pxa-i2c.h>
 #include <linux/usb/gpio_vbus.h>
+#include <linux/reboot.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -911,10 +912,10 @@ static struct platform_device *devices[]
 
 static void tosa_poweroff(void)
 {
-	pxa_restart('g', NULL);
+	pxa_restart(REBOOT_GPIO, NULL);
 }
 
-static void tosa_restart(char mode, const char *cmd)
+static void tosa_restart(enum reboot_mode mode, const char *cmd)
 {
 	uint32_t msc0 = __raw_readl(MSC0);
 
diff -puN arch/arm/mach-realview/realview_eb.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-realview/realview_eb.c
--- a/arch/arm/mach-realview/realview_eb.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-realview/realview_eb.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/platform_data/clk-realview.h>
+#include <linux/reboot.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -418,7 +419,7 @@ static void __init realview_eb_timer_ini
 	realview_eb_twd_init();
 }
 
-static void realview_eb_restart(char mode, const char *cmd)
+static void realview_eb_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *reset_ctrl = __io_address(REALVIEW_SYS_RESETCTL);
 	void __iomem *lock_ctrl = __io_address(REALVIEW_SYS_LOCK);
diff -puN arch/arm/mach-realview/realview_pb1176.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-realview/realview_pb1176.c
--- a/arch/arm/mach-realview/realview_pb1176.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-realview/realview_pb1176.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/platform_data/clk-realview.h>
+#include <linux/reboot.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -329,7 +330,7 @@ static void __init realview_pb1176_timer
 	realview_timer_init(IRQ_DC1176_TIMER0);
 }
 
-static void realview_pb1176_restart(char mode, const char *cmd)
+static void realview_pb1176_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *reset_ctrl = __io_address(REALVIEW_SYS_RESETCTL);
 	void __iomem *lock_ctrl = __io_address(REALVIEW_SYS_LOCK);
diff -puN arch/arm/mach-realview/realview_pb11mp.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-realview/realview_pb11mp.c
--- a/arch/arm/mach-realview/realview_pb11mp.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-realview/realview_pb11mp.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/platform_data/clk-realview.h>
+#include <linux/reboot.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -316,7 +317,7 @@ static void __init realview_pb11mp_timer
 	realview_pb11mp_twd_init();
 }
 
-static void realview_pb11mp_restart(char mode, const char *cmd)
+static void realview_pb11mp_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *reset_ctrl = __io_address(REALVIEW_SYS_RESETCTL);
 	void __iomem *lock_ctrl = __io_address(REALVIEW_SYS_LOCK);
diff -puN arch/arm/mach-realview/realview_pba8.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-realview/realview_pba8.c
--- a/arch/arm/mach-realview/realview_pba8.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-realview/realview_pba8.c
@@ -29,6 +29,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/platform_data/clk-realview.h>
+#include <linux/reboot.h>
 
 #include <asm/irq.h>
 #include <asm/mach-types.h>
@@ -264,7 +265,7 @@ static void __init realview_pba8_timer_i
 	realview_timer_init(IRQ_PBA8_TIMER0_1);
 }
 
-static void realview_pba8_restart(char mode, const char *cmd)
+static void realview_pba8_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *reset_ctrl = __io_address(REALVIEW_SYS_RESETCTL);
 	void __iomem *lock_ctrl = __io_address(REALVIEW_SYS_LOCK);
diff -puN arch/arm/mach-realview/realview_pbx.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-realview/realview_pbx.c
--- a/arch/arm/mach-realview/realview_pbx.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-realview/realview_pbx.c
@@ -28,6 +28,7 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/platform_data/clk-realview.h>
+#include <linux/reboot.h>
 
 #include <asm/irq.h>
 #include <asm/mach-types.h>
@@ -344,7 +345,7 @@ static void realview_pbx_fixup(struct ta
 #endif
 }
 
-static void realview_pbx_restart(char mode, const char *cmd)
+static void realview_pbx_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *reset_ctrl = __io_address(REALVIEW_SYS_RESETCTL);
 	void __iomem *lock_ctrl = __io_address(REALVIEW_SYS_LOCK);
diff -puN arch/arm/mach-rpc/riscpc.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-rpc/riscpc.c
--- a/arch/arm/mach-rpc/riscpc.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-rpc/riscpc.c
@@ -20,6 +20,7 @@
 #include <linux/ata_platform.h>
 #include <linux/io.h>
 #include <linux/i2c.h>
+#include <linux/reboot.h>
 
 #include <asm/elf.h>
 #include <asm/mach-types.h>
@@ -201,7 +202,7 @@ static int __init rpc_init(void)
 
 arch_initcall(rpc_init);
 
-static void rpc_restart(char mode, const char *cmd)
+static void rpc_restart(enum reboot_mode mode, const char *cmd)
 {
 	iomd_writeb(0, IOMD_ROMCR0);
 
diff -puN arch/arm/mach-s3c24xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c24xx/common.h
--- a/arch/arm/mach-s3c24xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c24xx/common.h
@@ -12,6 +12,8 @@
 #ifndef __ARCH_ARM_MACH_S3C24XX_COMMON_H
 #define __ARCH_ARM_MACH_S3C24XX_COMMON_H __FILE__
 
+#include <linux/reboot.h>
+
 struct s3c2410_uartcfg;
 
 #ifdef CONFIG_CPU_S3C2410
@@ -20,7 +22,7 @@ extern  int s3c2410a_init(void);
 extern void s3c2410_map_io(void);
 extern void s3c2410_init_uarts(struct s3c2410_uartcfg *cfg, int no);
 extern void s3c2410_init_clocks(int xtal);
-extern void s3c2410_restart(char mode, const char *cmd);
+extern void s3c2410_restart(enum reboot_mode mode, const char *cmd);
 extern void s3c2410_init_irq(void);
 #else
 #define s3c2410_init_clocks NULL
@@ -36,7 +38,7 @@ extern void s3c2412_map_io(void);
 extern void s3c2412_init_uarts(struct s3c2410_uartcfg *cfg, int no);
 extern void s3c2412_init_clocks(int xtal);
 extern  int s3c2412_baseclk_add(void);
-extern void s3c2412_restart(char mode, const char *cmd);
+extern void s3c2412_restart(enum reboot_mode mode, const char *cmd);
 extern void s3c2412_init_irq(void);
 #else
 #define s3c2412_init_clocks NULL
@@ -51,7 +53,7 @@ extern void s3c2416_map_io(void);
 extern void s3c2416_init_uarts(struct s3c2410_uartcfg *cfg, int no);
 extern void s3c2416_init_clocks(int xtal);
 extern  int s3c2416_baseclk_add(void);
-extern void s3c2416_restart(char mode, const char *cmd);
+extern void s3c2416_restart(enum reboot_mode mode, const char *cmd);
 extern void s3c2416_init_irq(void);
 
 extern struct syscore_ops s3c2416_irq_syscore_ops;
@@ -66,7 +68,7 @@ extern struct syscore_ops s3c2416_irq_sy
 extern void s3c244x_map_io(void);
 extern void s3c244x_init_uarts(struct s3c2410_uartcfg *cfg, int no);
 extern void s3c244x_init_clocks(int xtal);
-extern void s3c244x_restart(char mode, const char *cmd);
+extern void s3c244x_restart(enum reboot_mode mode, const char *cmd);
 #else
 #define s3c244x_init_clocks NULL
 #define s3c244x_init_uarts NULL
@@ -96,7 +98,7 @@ extern void s3c2443_map_io(void);
 extern void s3c2443_init_uarts(struct s3c2410_uartcfg *cfg, int no);
 extern void s3c2443_init_clocks(int xtal);
 extern  int s3c2443_baseclk_add(void);
-extern void s3c2443_restart(char mode, const char *cmd);
+extern void s3c2443_restart(enum reboot_mode mode, const char *cmd);
 extern void s3c2443_init_irq(void);
 #else
 #define s3c2443_init_clocks NULL
diff -puN arch/arm/mach-s3c24xx/s3c2410.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c24xx/s3c2410.c
--- a/arch/arm/mach-s3c24xx/s3c2410.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c24xx/s3c2410.c
@@ -22,6 +22,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/io.h>
 
 #include <asm/mach/arch.h>
@@ -195,9 +196,9 @@ int __init s3c2410a_init(void)
 	return s3c2410_init();
 }
 
-void s3c2410_restart(char mode, const char *cmd)
+void s3c2410_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's') {
+	if (mode == REBOOT_WARM) {
 		soft_restart(0);
 	}
 
diff -puN arch/arm/mach-s3c24xx/s3c2412.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c24xx/s3c2412.c
--- a/arch/arm/mach-s3c24xx/s3c2412.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c24xx/s3c2412.c
@@ -22,6 +22,7 @@
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -129,9 +130,9 @@ static void s3c2412_idle(void)
 	cpu_do_idle();
 }
 
-void s3c2412_restart(char mode, const char *cmd)
+void s3c2412_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's')
+	if (mode == REBOOT_WARM)
 		soft_restart(0);
 
 	/* errata "Watch-dog/Software Reset Problem" specifies that
diff -puN arch/arm/mach-s3c24xx/s3c2416.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c24xx/s3c2416.c
--- a/arch/arm/mach-s3c24xx/s3c2416.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c24xx/s3c2416.c
@@ -35,6 +35,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -79,9 +80,9 @@ static struct device s3c2416_dev = {
 	.bus		= &s3c2416_subsys,
 };
 
-void s3c2416_restart(char mode, const char *cmd)
+void s3c2416_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's')
+	if (mode == REBOOT_WARM)
 		soft_restart(0);
 
 	__raw_writel(S3C2443_SWRST_RESET, S3C2443_SWRST);
diff -puN arch/arm/mach-s3c24xx/s3c2443.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c24xx/s3c2443.c
--- a/arch/arm/mach-s3c24xx/s3c2443.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c24xx/s3c2443.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -59,9 +60,9 @@ static struct device s3c2443_dev = {
 	.bus		= &s3c2443_subsys,
 };
 
-void s3c2443_restart(char mode, const char *cmd)
+void s3c2443_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's')
+	if (mode == REBOOT_WARM)
 		soft_restart(0);
 
 	__raw_writel(S3C2443_SWRST_RESET, S3C2443_SWRST);
diff -puN arch/arm/mach-s3c24xx/s3c244x.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c24xx/s3c244x.c
--- a/arch/arm/mach-s3c24xx/s3c244x.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c24xx/s3c244x.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/device.h>
 #include <linux/syscore_ops.h>
 #include <linux/clk.h>
@@ -197,9 +198,9 @@ struct syscore_ops s3c244x_pm_syscore_op
 	.resume		= s3c244x_resume,
 };
 
-void s3c244x_restart(char mode, const char *cmd)
+void s3c244x_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's')
+	if (mode == REBOOT_WARM)
 		soft_restart(0);
 
 	arch_wdt_reset();
diff -puN arch/arm/mach-s3c64xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c64xx/common.c
--- a/arch/arm/mach-s3c64xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c64xx/common.c
@@ -26,6 +26,7 @@
 #include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/irqchip/arm-vic.h>
+#include <linux/reboot.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -375,9 +376,9 @@ static int __init s3c64xx_init_irq_eint(
 }
 arch_initcall(s3c64xx_init_irq_eint);
 
-void s3c64xx_restart(char mode, const char *cmd)
+void s3c64xx_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode != 's')
+	if (mode != REBOOT_WARM)
 		arch_wdt_reset();
 
 	/* if all else fails, or mode was for soft, jump to 0 */
diff -puN arch/arm/mach-s3c64xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s3c64xx/common.h
--- a/arch/arm/mach-s3c64xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s3c64xx/common.h
@@ -17,13 +17,15 @@
 #ifndef __ARCH_ARM_MACH_S3C64XX_COMMON_H
 #define __ARCH_ARM_MACH_S3C64XX_COMMON_H
 
+#include <linux/reboot.h>
+
 void s3c64xx_init_irq(u32 vic0, u32 vic1);
 void s3c64xx_init_io(struct map_desc *mach_desc, int size);
 
 void s3c64xx_register_clocks(unsigned long xtal, unsigned armclk_limit);
 void s3c64xx_setup_clocks(void);
 
-void s3c64xx_restart(char mode, const char *cmd);
+void s3c64xx_restart(enum reboot_mode mode, const char *cmd);
 void s3c64xx_init_late(void);
 
 #ifdef CONFIG_CPU_S3C6400
diff -puN arch/arm/mach-s5p64x0/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s5p64x0/common.c
--- a/arch/arm/mach-s5p64x0/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s5p64x0/common.c
@@ -24,6 +24,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/reboot.h>
 
 #include <asm/irq.h>
 #include <asm/proc-fns.h>
@@ -437,9 +438,9 @@ static int __init s5p64x0_init_irq_eint(
 }
 arch_initcall(s5p64x0_init_irq_eint);
 
-void s5p64x0_restart(char mode, const char *cmd)
+void s5p64x0_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode != 's')
+	if (mode != REBOOT_WARM)
 		arch_wdt_reset();
 
 	soft_restart(0);
diff -puN arch/arm/mach-s5p64x0/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s5p64x0/common.h
--- a/arch/arm/mach-s5p64x0/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s5p64x0/common.h
@@ -12,6 +12,8 @@
 #ifndef __ARCH_ARM_MACH_S5P64X0_COMMON_H
 #define __ARCH_ARM_MACH_S5P64X0_COMMON_H
 
+#include <linux/reboot.h>
+
 void s5p6440_init_irq(void);
 void s5p6450_init_irq(void);
 void s5p64x0_init_io(struct map_desc *mach_desc, int size);
@@ -22,7 +24,7 @@ void s5p6440_setup_clocks(void);
 void s5p6450_register_clocks(void);
 void s5p6450_setup_clocks(void);
 
-void s5p64x0_restart(char mode, const char *cmd);
+void s5p64x0_restart(enum reboot_mode mode, const char *cmd);
 
 #ifdef CONFIG_CPU_S5P6440
 
diff -puN arch/arm/mach-s5pc100/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s5pc100/common.c
--- a/arch/arm/mach-s5pc100/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s5pc100/common.c
@@ -24,6 +24,7 @@
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
+#include <linux/reboot.h>
 
 #include <asm/irq.h>
 #include <asm/proc-fns.h>
@@ -216,9 +217,9 @@ void __init s5pc100_init_uarts(struct s3
 	s3c24xx_init_uartdevs("s3c6400-uart", s5p_uart_resources, cfg, no);
 }
 
-void s5pc100_restart(char mode, const char *cmd)
+void s5pc100_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode != 's')
+	if (mode != REBOOT_WARM)
 		arch_wdt_reset();
 
 	soft_restart(0);
diff -puN arch/arm/mach-s5pc100/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s5pc100/common.h
--- a/arch/arm/mach-s5pc100/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s5pc100/common.h
@@ -12,13 +12,15 @@
 #ifndef __ARCH_ARM_MACH_S5PC100_COMMON_H
 #define __ARCH_ARM_MACH_S5PC100_COMMON_H
 
+#include <linux/reboot.h>
+
 void s5pc100_init_io(struct map_desc *mach_desc, int size);
 void s5pc100_init_irq(void);
 
 void s5pc100_register_clocks(void);
 void s5pc100_setup_clocks(void);
 
-void s5pc100_restart(char mode, const char *cmd);
+void s5pc100_restart(enum reboot_mode mode, const char *cmd);
 
 extern  int s5pc100_init(void);
 extern void s5pc100_map_io(void);
diff -puN arch/arm/mach-s5pv210/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s5pv210/common.c
--- a/arch/arm/mach-s5pv210/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s5pv210/common.c
@@ -143,7 +143,7 @@ static struct map_desc s5pv210_iodesc[]
 	}
 };
 
-void s5pv210_restart(char mode, const char *cmd)
+void s5pv210_restart(enum reboot_mode mode, const char *cmd)
 {
 	__raw_writel(0x1, S5P_SWRESET);
 }
diff -puN arch/arm/mach-s5pv210/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-s5pv210/common.h
--- a/arch/arm/mach-s5pv210/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-s5pv210/common.h
@@ -12,13 +12,15 @@
 #ifndef __ARCH_ARM_MACH_S5PV210_COMMON_H
 #define __ARCH_ARM_MACH_S5PV210_COMMON_H
 
+#include <linux/reboot.h>
+
 void s5pv210_init_io(struct map_desc *mach_desc, int size);
 void s5pv210_init_irq(void);
 
 void s5pv210_register_clocks(void);
 void s5pv210_setup_clocks(void);
 
-void s5pv210_restart(char mode, const char *cmd);
+void s5pv210_restart(enum reboot_mode mode, const char *cmd);
 
 extern  int s5pv210_init(void);
 extern void s5pv210_map_io(void);
diff -puN arch/arm/mach-sa1100/generic.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-sa1100/generic.c
--- a/arch/arm/mach-sa1100/generic.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-sa1100/generic.c
@@ -19,6 +19,7 @@
 #include <linux/cpufreq.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 
 #include <video/sa1100fb.h>
 
@@ -131,9 +132,9 @@ static void sa1100_power_off(void)
 	PMCR = PMCR_SF;
 }
 
-void sa11x0_restart(char mode, const char *cmd)
+void sa11x0_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's') {
+	if (mode == REBOOT_WARM) {
 		/* Jump into ROM at address 0 */
 		soft_restart(0);
 	} else {
diff -puN arch/arm/mach-sa1100/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-sa1100/generic.h
--- a/arch/arm/mach-sa1100/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-sa1100/generic.h
@@ -3,12 +3,13 @@
  *
  * Author: Nicolas Pitre
  */
+#include <linux/reboot.h>
 
 extern void sa1100_timer_init(void);
 extern void __init sa1100_map_io(void);
 extern void __init sa1100_init_irq(void);
 extern void __init sa1100_init_gpio(void);
-extern void sa11x0_restart(char, const char *);
+extern void sa11x0_restart(enum reboot_mode, const char *);
 extern void sa11x0_init_late(void);
 
 #define SET_BANK(__nr,__start,__size) \
diff -puN arch/arm/mach-shark/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-shark/core.c
--- a/arch/arm/mach-shark/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-shark/core.c
@@ -11,6 +11,7 @@
 #include <linux/serial_8250.h>
 #include <linux/io.h>
 #include <linux/cpu.h>
+#include <linux/reboot.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -24,7 +25,7 @@
 #define ROMCARD_SIZE            0x08000000
 #define ROMCARD_START           0x10000000
 
-static void shark_restart(char mode, const char *cmd)
+static void shark_restart(enum reboot_mode mode, const char *cmd)
 {
         short temp;
         /* Reset the Machine via pc[3] of the sequoia chipset */
diff -puN arch/arm/mach-shmobile/board-armadillo800eva.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-shmobile/board-armadillo800eva.c
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -42,6 +42,7 @@
 #include <linux/mmc/sh_mmcif.h>
 #include <linux/mmc/sh_mobile_sdhi.h>
 #include <linux/i2c-gpio.h>
+#include <linux/reboot.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/r8a7740.h>
@@ -1256,7 +1257,7 @@ static void __init eva_add_early_devices
 }
 
 #define RESCNT2 IOMEM(0xe6188020)
-static void eva_restart(char mode, const char *cmd)
+static void eva_restart(enum reboot_mode mode, const char *cmd)
 {
 	/* Do soft power on reset */
 	writel((1 << 31), RESCNT2);
diff -puN arch/arm/mach-shmobile/board-kzm9g.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-shmobile/board-kzm9g.c
--- a/arch/arm/mach-shmobile/board-kzm9g.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-shmobile/board-kzm9g.c
@@ -34,6 +34,7 @@
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinconf-generic.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
 #include <linux/smsc911x.h>
@@ -890,7 +891,7 @@ static void __init kzm_init(void)
 	sh73a0_pm_init();
 }
 
-static void kzm9g_restart(char mode, const char *cmd)
+static void kzm9g_restart(enum reboot_mode mode, const char *cmd)
 {
 #define RESCNT2 IOMEM(0xe6188020)
 	/* Do soft power on reset */
diff -puN arch/arm/mach-socfpga/socfpga.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-socfpga/socfpga.c
--- a/arch/arm/mach-socfpga/socfpga.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-socfpga/socfpga.c
@@ -20,6 +20,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/reboot.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach/arch.h>
@@ -90,7 +91,7 @@ static void __init socfpga_init_irq(void
 	socfpga_sysmgr_init();
 }
 
-static void socfpga_cyclone5_restart(char mode, const char *cmd)
+static void socfpga_cyclone5_restart(enum reboot_mode mode, const char *cmd)
 {
 	u32 temp;
 
diff -puN arch/arm/mach-spear/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-spear/generic.h
--- a/arch/arm/mach-spear/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-spear/generic.h
@@ -16,6 +16,8 @@
 #include <linux/dmaengine.h>
 #include <linux/amba/pl08x.h>
 #include <linux/init.h>
+#include <linux/reboot.h>
+
 #include <asm/mach/time.h>
 
 extern void spear13xx_timer_init(void);
@@ -32,7 +34,7 @@ void __init spear6xx_clk_init(void __iom
 void __init spear13xx_map_io(void);
 void __init spear13xx_l2x0_init(void);
 
-void spear_restart(char, const char *);
+void spear_restart(enum reboot_mode, const char *);
 
 void spear13xx_secondary_startup(void);
 void __cpuinit spear13xx_cpu_die(unsigned int cpu);
diff -puN arch/arm/mach-spear/restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-spear/restart.c
--- a/arch/arm/mach-spear/restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-spear/restart.c
@@ -12,14 +12,15 @@
  */
 #include <linux/io.h>
 #include <linux/amba/sp810.h>
+#include <linux/reboot.h>
 #include <asm/system_misc.h>
 #include <mach/spear.h>
 #include "generic.h"
 
 #define SPEAR13XX_SYS_SW_RES			(VA_MISC_BASE + 0x204)
-void spear_restart(char mode, const char *cmd)
+void spear_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's') {
+	if (mode == REBOOT_WARM) {
 		/* software reset, Jump into ROM at address 0 */
 		soft_restart(0);
 	} else {
diff -puN arch/arm/mach-sunxi/sunxi.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-sunxi/sunxi.c
--- a/arch/arm/mach-sunxi/sunxi.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-sunxi/sunxi.c
@@ -19,6 +19,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 
 #include <linux/clk/sunxi.h>
 
@@ -36,7 +37,7 @@
 
 static void __iomem *wdt_base;
 
-static void sun4i_restart(char mode, const char *cmd)
+static void sun4i_restart(enum reboot_mode mode, const char *cmd)
 {
 	if (!wdt_base)
 		return;
diff -puN arch/arm/mach-tegra/board.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-tegra/board.h
--- a/arch/arm/mach-tegra/board.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-tegra/board.h
@@ -23,8 +23,9 @@
 #define __MACH_TEGRA_BOARD_H
 
 #include <linux/types.h>
+#include <linux/reboot.h>
 
-void tegra_assert_system_reset(char mode, const char *cmd);
+void tegra_assert_system_reset(enum reboot_mode mode, const char *cmd);
 
 void __init tegra_init_early(void);
 void __init tegra_map_common_io(void);
diff -puN arch/arm/mach-tegra/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-tegra/common.c
--- a/arch/arm/mach-tegra/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-tegra/common.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/irqchip.h>
 #include <linux/clk/tegra.h>
+#include <linux/reboot.h>
 
 #include <asm/hardware/cache-l2x0.h>
 
@@ -67,7 +68,7 @@ void __init tegra_dt_init_irq(void)
 }
 #endif
 
-void tegra_assert_system_reset(char mode, const char *cmd)
+void tegra_assert_system_reset(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *reset = IO_ADDRESS(TEGRA_PMC_BASE + 0);
 	u32 reg;
diff -puN arch/arm/mach-u300/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-u300/core.c
--- a/arch/arm/mach-u300/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-u300/core.c
@@ -671,11 +671,11 @@ static void __init u300_init_machine(voi
 /* Forward declare this function from the watchdog */
 void coh901327_watchdog_reset(void);
 
-static void u300_restart(char mode, const char *cmd)
+static void u300_restart(enum reboot_mode mode, const char *cmd)
 {
 	switch (mode) {
-	case 's':
-	case 'h':
+	case REBOOT_WARM:
+	case REBOOT_COLD:
 #ifdef CONFIG_COH901327_WATCHDOG
 		coh901327_watchdog_reset();
 #endif
diff -puN arch/arm/mach-versatile/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-versatile/core.c
--- a/arch/arm/mach-versatile/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-versatile/core.c
@@ -38,6 +38,7 @@
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
 #include <linux/bitops.h>
+#include <linux/reboot.h>
 
 #include <asm/irq.h>
 #include <asm/hardware/arm_timer.h>
@@ -733,7 +734,7 @@ static void versatile_leds_event(led_eve
 }
 #endif	/* CONFIG_LEDS */
 
-void versatile_restart(char mode, const char *cmd)
+void versatile_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *sys = __io_address(VERSATILE_SYS_BASE);
 	u32 val;
diff -puN arch/arm/mach-versatile/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-versatile/core.h
--- a/arch/arm/mach-versatile/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-versatile/core.h
@@ -24,13 +24,14 @@
 
 #include <linux/amba/bus.h>
 #include <linux/of_platform.h>
+#include <linux/reboot.h>
 
 extern void __init versatile_init(void);
 extern void __init versatile_init_early(void);
 extern void __init versatile_init_irq(void);
 extern void __init versatile_map_io(void);
 extern void versatile_timer_init(void);
-extern void versatile_restart(char, const char *);
+extern void versatile_restart(enum reboot_mode, const char *);
 extern unsigned int mmc_status(struct device *dev);
 #ifdef CONFIG_OF
 extern struct of_dev_auxdata versatile_auxdata_lookup[];
diff -puN arch/arm/mach-vt8500/vt8500.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-vt8500/vt8500.c
--- a/arch/arm/mach-vt8500/vt8500.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-vt8500/vt8500.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/irqchip.h>
 #include <linux/pm.h>
+#include <linux/reboot.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -47,7 +48,7 @@
 
 static void __iomem *pmc_base;
 
-void vt8500_restart(char mode, const char *cmd)
+void vt8500_restart(enum reboot_mode mode, const char *cmd)
 {
 	if (pmc_base)
 		writel(1, pmc_base + VT8500_PMSR_REG);
diff -puN arch/arm/mach-w90x900/cpu.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-w90x900/cpu.c
--- a/arch/arm/mach-w90x900/cpu.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-w90x900/cpu.c
@@ -230,9 +230,9 @@ void __init nuc900_init_clocks(void)
 #define	WTE	(1 << 7)
 #define	WTRE	(1 << 1)
 
-void nuc9xx_restart(char mode, const char *cmd)
+void nuc9xx_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == 's') {
+	if (mode == REBOOT_WARM) {
 		/* Jump into ROM at address 0 */
 		soft_restart(0);
 	} else {
diff -puN arch/arm/mach-w90x900/nuc9xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/mach-w90x900/nuc9xx.h
--- a/arch/arm/mach-w90x900/nuc9xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/mach-w90x900/nuc9xx.h
@@ -14,10 +14,13 @@
  * published by the Free Software Foundation.
  *
  */
+
+#include <linux/reboot.h>
+
 struct map_desc;
 
 /* core initialisation functions */
 
 extern void nuc900_init_irq(void);
 extern void nuc900_timer_init(void);
-extern void nuc9xx_restart(char, const char *);
+extern void nuc9xx_restart(enum reboot_mode, const char *);
diff -puN arch/arm/plat-iop/gpio.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/plat-iop/gpio.c
--- a/arch/arm/plat-iop/gpio.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/plat-iop/gpio.c
@@ -17,6 +17,7 @@
 #include <linux/gpio.h>
 #include <linux/export.h>
 #include <asm/hardware/iop3xx.h>
+#include <mach/gpio.h>
 
 void gpio_line_config(int line, int direction)
 {
diff -puN arch/arm/plat-iop/restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode arch/arm/plat-iop/restart.c
--- a/arch/arm/plat-iop/restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/arch/arm/plat-iop/restart.c
@@ -11,7 +11,7 @@
 #include <asm/system_misc.h>
 #include <mach/hardware.h>
 
-void iop3xx_restart(char mode, const char *cmd)
+void iop3xx_restart(enum reboot_mode mode, const char *cmd)
 {
 	*IOP3XX_PCSR = 0x30;
 
diff -puN drivers/power/reset/restart-poweroff.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode drivers/power/reset/restart-poweroff.c
--- a/drivers/power/reset/restart-poweroff.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/drivers/power/reset/restart-poweroff.c
@@ -15,11 +15,12 @@
 #include <linux/platform_device.h>
 #include <linux/of_platform.h>
 #include <linux/module.h>
+#include <linux/reboot.h>
 #include <asm/system_misc.h>
 
 static void restart_poweroff_do_poweroff(void)
 {
-	arm_pm_restart('h', NULL);
+	arm_pm_restart(REBOOT_COLD, NULL);
 }
 
 static int restart_poweroff_probe(struct platform_device *pdev)
diff -puN drivers/power/reset/vexpress-poweroff.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode drivers/power/reset/vexpress-poweroff.c
--- a/drivers/power/reset/vexpress-poweroff.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/drivers/power/reset/vexpress-poweroff.c
@@ -48,7 +48,7 @@ static void vexpress_power_off(void)
 
 static struct device *vexpress_restart_device;
 
-static void vexpress_restart(char str, const char *cmd)
+static void vexpress_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 	vexpress_reset_do(vexpress_restart_device, "restart");
 }
diff -puN include/linux/reboot.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode include/linux/reboot.h
--- a/include/linux/reboot.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/include/linux/reboot.h
@@ -13,6 +13,7 @@
 enum reboot_mode {
 	REBOOT_COLD = 0,
 	REBOOT_WARM,
+	REBOOT_GPIO,
 };
 
 extern int register_reboot_notifier(struct notifier_block *);
diff -puN include/linux/vexpress.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode include/linux/vexpress.h
--- a/include/linux/vexpress.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode
+++ a/include/linux/vexpress.h
@@ -15,6 +15,7 @@
 #define _LINUX_VEXPRESS_H
 
 #include <linux/device.h>
+#include <linux/reboot.h>
 
 #define VEXPRESS_SITE_MB		0
 #define VEXPRESS_SITE_DB1		1
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
migrate-shutdown-reboot-to-boot-cpu.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch

