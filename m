From: akpm@linux-foundation.org
Subject: [to-be-updated] reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 09 May 2013 13:51:56 -0700
Message-ID: <20130509205156.9350A31C08F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:36866 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3EIUv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:51:59 -0400
Received: by mail-ve0-f201.google.com with SMTP id cz11so69150veb.4
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:51:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, holt@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes

WARNING: line over 80 characters
#219: FILE: arch/arm/kernel/process.c:126:
+void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;

ERROR: space prohibited after that open parenthesis '('
#807: FILE: arch/arm/mach-ixp4xx/common.c:536:
+	if ( 1 && mode == REBOOT_WARM) {

ERROR: do not use C99 // comments
#851: FILE: arch/arm/mach-ixp4xx/include/mach/timex.h:6:
+// #include <mach/hardware.h>

WARNING: braces {} are not necessary for single statement blocks
#1834: FILE: arch/arm/mach-s3c24xx/s3c2410.c:201:
+	if (mode == REBOOT_WARM) {
 		soft_restart(0);
 	}

total: 2 errors, 2 warnings, 1766 lines checked

./patches/reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/process.c       |    3 ++-
 arch/arm/mach-ixp4xx/common.c   |    2 +-
 arch/arm/mach-s3c24xx/s3c2410.c |    3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/include/asm/hardware/iop3xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/include/asm/hardware/iop3xx.h
diff -puN arch/arm/include/asm/mach/arch.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/include/asm/mach/arch.h
diff -puN arch/arm/include/asm/system_misc.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/include/asm/system_misc.h
diff -puN arch/arm/kernel/process.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes
+++ a/arch/arm/kernel/process.c
@@ -123,7 +123,8 @@ static void null_restart(enum reboot_mod
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
+void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) =
+			null_restart;
 EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 /*
diff -puN arch/arm/mach-at91/at91rm9200.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-at91/at91rm9200.c
diff -puN arch/arm/mach-at91/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-at91/generic.h
diff -puN arch/arm/mach-bcm2835/bcm2835.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-bcm2835/bcm2835.c
diff -puN arch/arm/mach-clps711x/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-clps711x/common.c
diff -puN arch/arm/mach-clps711x/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-clps711x/common.h
diff -puN arch/arm/mach-cns3xxx/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-cns3xxx/core.h
diff -puN arch/arm/mach-cns3xxx/pm.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-cns3xxx/pm.c
diff -puN arch/arm/mach-davinci/devices-da8xx.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-davinci/devices-da8xx.c
diff -puN arch/arm/mach-davinci/devices.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-davinci/devices.c
diff -puN arch/arm/mach-davinci/include/mach/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-davinci/include/mach/common.h
diff -puN arch/arm/mach-davinci/include/mach/da8xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-davinci/include/mach/da8xx.h
diff -puN arch/arm/mach-davinci/include/mach/tnetv107x.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-davinci/include/mach/tnetv107x.h
diff -puN arch/arm/mach-davinci/tnetv107x.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-davinci/tnetv107x.c
diff -puN arch/arm/mach-dove/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-dove/common.c
diff -puN arch/arm/mach-dove/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-dove/common.h
diff -puN arch/arm/mach-ebsa110/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ebsa110/core.c
diff -puN arch/arm/mach-ep93xx/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ep93xx/core.c
diff -puN arch/arm/mach-ep93xx/include/mach/platform.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ep93xx/include/mach/platform.h
diff -puN arch/arm/mach-exynos/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-exynos/common.c
diff -puN arch/arm/mach-exynos/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-exynos/common.h
diff -puN arch/arm/mach-footbridge/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-footbridge/common.c
diff -puN arch/arm/mach-footbridge/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-footbridge/common.h
diff -puN arch/arm/mach-footbridge/netwinder-hw.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-footbridge/netwinder-hw.c
diff -puN arch/arm/mach-highbank/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-highbank/core.h
diff -puN arch/arm/mach-highbank/system.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-highbank/system.c
diff -puN arch/arm/mach-imx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-imx/common.h
diff -puN arch/arm/mach-imx/mach-imx6q.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-imx/mach-imx6q.c
diff -puN arch/arm/mach-imx/system.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-imx/system.c
diff -puN arch/arm/mach-integrator/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-integrator/common.h
diff -puN arch/arm/mach-integrator/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-integrator/core.c
diff -puN arch/arm/mach-iop13xx/include/mach/iop13xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-iop13xx/include/mach/iop13xx.h
diff -puN arch/arm/mach-iop13xx/setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-iop13xx/setup.c
diff -puN arch/arm/mach-iop32x/n2100.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-iop32x/n2100.c
diff -puN arch/arm/mach-ixp4xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -533,7 +533,7 @@ static void __init ixp4xx_clockevent_ini
 
 void ixp4xx_restart(enum reboot_mode mode, const char *cmd)
 {
-	if ( 1 && mode == REBOOT_WARM) {
+	if (mode == REBOOT_WARM) {
 		/* Jump into ROM at address 0 */
 		soft_restart(0);
 	} else {
diff -puN arch/arm/mach-ixp4xx/dsmg600-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ixp4xx/dsmg600-setup.c
diff -puN arch/arm/mach-ixp4xx/include/mach/platform.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ixp4xx/include/mach/platform.h
diff -puN arch/arm/mach-ixp4xx/include/mach/timex.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ixp4xx/include/mach/timex.h
diff -puN arch/arm/mach-kirkwood/board-lsxl.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-kirkwood/board-lsxl.c
diff -puN arch/arm/mach-kirkwood/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-kirkwood/common.c
diff -puN arch/arm/mach-kirkwood/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-kirkwood/common.h
diff -puN arch/arm/mach-ks8695/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ks8695/generic.h
diff -puN arch/arm/mach-ks8695/time.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-ks8695/time.c
diff -puN arch/arm/mach-lpc32xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-lpc32xx/common.c
diff -puN arch/arm/mach-lpc32xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-lpc32xx/common.h
diff -puN arch/arm/mach-mmp/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mmp/common.c
diff -puN arch/arm/mach-mmp/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mmp/common.h
diff -puN arch/arm/mach-mmp/include/mach/pxa168.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mmp/include/mach/pxa168.h
diff -puN arch/arm/mach-mmp/pxa168.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mmp/pxa168.c
diff -puN arch/arm/mach-mv78xx0/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mv78xx0/common.c
diff -puN arch/arm/mach-mv78xx0/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mv78xx0/common.h
diff -puN arch/arm/mach-mvebu/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mvebu/common.h
diff -puN arch/arm/mach-mvebu/system-controller.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mvebu/system-controller.c
diff -puN arch/arm/mach-mxs/mach-mxs.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-mxs/mach-mxs.c
diff -puN arch/arm/mach-netx/generic.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-netx/generic.c
diff -puN arch/arm/mach-netx/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-netx/generic.h
diff -puN arch/arm/mach-nomadik/cpu-8815.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-nomadik/cpu-8815.c
diff -puN arch/arm/mach-omap1/board-voiceblue.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap1/board-voiceblue.c
diff -puN arch/arm/mach-omap1/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap1/common.h
diff -puN arch/arm/mach-omap1/reset.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap1/reset.c
diff -puN arch/arm/mach-omap2/am33xx-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap2/am33xx-restart.c
diff -puN arch/arm/mach-omap2/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap2/common.h
diff -puN arch/arm/mach-omap2/omap2-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap2/omap2-restart.c
diff -puN arch/arm/mach-omap2/omap3-restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap2/omap3-restart.c
diff -puN arch/arm/mach-omap2/omap4-common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-omap2/omap4-common.c
diff -puN arch/arm/mach-orion5x/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-orion5x/common.c
diff -puN arch/arm/mach-orion5x/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-orion5x/common.h
diff -puN arch/arm/mach-orion5x/ls-chl-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-orion5x/ls-chl-setup.c
diff -puN arch/arm/mach-orion5x/ls_hgl-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-orion5x/ls_hgl-setup.c
diff -puN arch/arm/mach-orion5x/lsmini-setup.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-orion5x/lsmini-setup.c
diff -puN arch/arm/mach-picoxcell/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-picoxcell/common.c
diff -puN arch/arm/mach-prima2/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-prima2/common.h
diff -puN arch/arm/mach-prima2/rstc.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-prima2/rstc.c
diff -puN arch/arm/mach-pxa/corgi.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-pxa/corgi.c
diff -puN arch/arm/mach-pxa/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-pxa/generic.h
diff -puN arch/arm/mach-pxa/mioa701.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-pxa/mioa701.c
diff -puN arch/arm/mach-pxa/poodle.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-pxa/poodle.c
diff -puN arch/arm/mach-pxa/reset.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-pxa/reset.c
diff -puN arch/arm/mach-pxa/spitz.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-pxa/spitz.c
diff -puN arch/arm/mach-pxa/tosa.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-pxa/tosa.c
diff -puN arch/arm/mach-realview/realview_eb.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-realview/realview_eb.c
diff -puN arch/arm/mach-realview/realview_pb1176.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-realview/realview_pb1176.c
diff -puN arch/arm/mach-realview/realview_pb11mp.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-realview/realview_pb11mp.c
diff -puN arch/arm/mach-realview/realview_pba8.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-realview/realview_pba8.c
diff -puN arch/arm/mach-realview/realview_pbx.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-realview/realview_pbx.c
diff -puN arch/arm/mach-rpc/riscpc.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-rpc/riscpc.c
diff -puN arch/arm/mach-s3c24xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c24xx/common.h
diff -puN arch/arm/mach-s3c24xx/s3c2410.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c24xx/s3c2410.c
--- a/arch/arm/mach-s3c24xx/s3c2410.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes
+++ a/arch/arm/mach-s3c24xx/s3c2410.c
@@ -198,9 +198,8 @@ int __init s3c2410a_init(void)
 
 void s3c2410_restart(enum reboot_mode mode, const char *cmd)
 {
-	if (mode == REBOOT_WARM) {
+	if (mode == REBOOT_WARM)
 		soft_restart(0);
-	}
 
 	arch_wdt_reset();
 
diff -puN arch/arm/mach-s3c24xx/s3c2412.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c24xx/s3c2412.c
diff -puN arch/arm/mach-s3c24xx/s3c2416.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c24xx/s3c2416.c
diff -puN arch/arm/mach-s3c24xx/s3c2443.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c24xx/s3c2443.c
diff -puN arch/arm/mach-s3c24xx/s3c244x.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c24xx/s3c244x.c
diff -puN arch/arm/mach-s3c64xx/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c64xx/common.c
diff -puN arch/arm/mach-s3c64xx/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s3c64xx/common.h
diff -puN arch/arm/mach-s5p64x0/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s5p64x0/common.c
diff -puN arch/arm/mach-s5p64x0/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s5p64x0/common.h
diff -puN arch/arm/mach-s5pc100/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s5pc100/common.c
diff -puN arch/arm/mach-s5pc100/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s5pc100/common.h
diff -puN arch/arm/mach-s5pv210/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s5pv210/common.c
diff -puN arch/arm/mach-s5pv210/common.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-s5pv210/common.h
diff -puN arch/arm/mach-sa1100/generic.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-sa1100/generic.c
diff -puN arch/arm/mach-sa1100/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-sa1100/generic.h
diff -puN arch/arm/mach-shark/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-shark/core.c
diff -puN arch/arm/mach-shmobile/board-armadillo800eva.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-shmobile/board-armadillo800eva.c
diff -puN arch/arm/mach-shmobile/board-kzm9g.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-shmobile/board-kzm9g.c
diff -puN arch/arm/mach-socfpga/socfpga.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-socfpga/socfpga.c
diff -puN arch/arm/mach-spear/generic.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-spear/generic.h
diff -puN arch/arm/mach-spear/restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-spear/restart.c
diff -puN arch/arm/mach-sunxi/sunxi.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-sunxi/sunxi.c
diff -puN arch/arm/mach-tegra/board.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-tegra/board.h
diff -puN arch/arm/mach-tegra/common.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-tegra/common.c
diff -puN arch/arm/mach-u300/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-u300/core.c
diff -puN arch/arm/mach-versatile/core.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-versatile/core.c
diff -puN arch/arm/mach-versatile/core.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-versatile/core.h
diff -puN arch/arm/mach-vt8500/vt8500.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-vt8500/vt8500.c
diff -puN arch/arm/mach-w90x900/cpu.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-w90x900/cpu.c
diff -puN arch/arm/mach-w90x900/nuc9xx.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/mach-w90x900/nuc9xx.h
diff -puN arch/arm/plat-iop/gpio.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/plat-iop/gpio.c
diff -puN arch/arm/plat-iop/restart.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes arch/arm/plat-iop/restart.c
diff -puN drivers/power/reset/restart-poweroff.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes drivers/power/reset/restart-poweroff.c
diff -puN drivers/power/reset/vexpress-poweroff.c~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes drivers/power/reset/vexpress-poweroff.c
diff -puN include/linux/reboot.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes include/linux/reboot.h
diff -puN include/linux/vexpress.h~reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes include/linux/vexpress.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

