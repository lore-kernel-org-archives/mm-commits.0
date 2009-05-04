From: akpm@linux-foundation.org
Subject: + powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch added to -mm tree
Date: Mon, 04 May 2009 13:56:15 -0700
Message-ID: <200905042056.n44KuF41016782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbZEDVB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org


The patch titled
     powerpc/86xx: add MMC SPI support for MPC8610HPCD boards
has been added to the -mm tree.  Its filename is
     powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch

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
Subject: powerpc/86xx: add MMC SPI support for MPC8610HPCD boards
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch adds spi and mmc-spi-slot nodes, plus a gpio-controller for
PIXIS' sdcsr bank that is used for managing SPI chip-select and for
reading card's states.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc8610_hpcd.dts     |   32 +++++++++++++++++++
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c |    4 ++
 2 files changed, 36 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc8610_hpcd.dts~powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards arch/powerpc/boot/dts/mpc8610_hpcd.dts
--- a/arch/powerpc/boot/dts/mpc8610_hpcd.dts~powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards
+++ a/arch/powerpc/boot/dts/mpc8610_hpcd.dts
@@ -100,8 +100,18 @@
 		};
 
 		board-control@3,0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
 			compatible = "fsl,fpga-pixis";
 			reg = <3 0 0x20>;
+			ranges = <0 3 0 0x20>;
+
+			sdcsr_pio: gpio-controller@a {
+				#gpio-cells = <2>;
+				compatible = "fsl,fpga-pixis-gpio-bank";
+				reg = <0xa 1>;
+				gpio-controller;
+			};
 		};
 	};
 
@@ -177,6 +187,28 @@
 			interrupt-parent = <&mpic>;
 		};
 
+		spi@7000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc8610-spi", "fsl,spi";
+			reg = <0x7000 0x40>;
+			cell-index = <0>;
+			interrupts = <59 2>;
+			interrupt-parent = <&mpic>;
+			mode = "cpu";
+			gpios = <&sdcsr_pio 7 0>;
+
+			mmc-slot@0 {
+				compatible = "fsl,mpc8610hpcd-mmc-slot",
+					     "mmc-spi-slot";
+				reg = <0>;
+				gpios = <&sdcsr_pio 0 1   /* nCD */
+					 &sdcsr_pio 1 0>; /*  WP */
+				voltage-ranges = <3300 3300>;
+				spi-max-frequency = <50000000>;
+			};
+		};
+
 		display@2c000 {
 			compatible = "fsl,diu";
 			reg = <0x2c000 100>;
diff -puN arch/powerpc/platforms/86xx/mpc8610_hpcd.c~powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards arch/powerpc/platforms/86xx/mpc8610_hpcd.c
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c~powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards
+++ a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -37,6 +37,7 @@
 #include <linux/of_platform.h>
 #include <sysdev/fsl_pci.h>
 #include <sysdev/fsl_soc.h>
+#include <sysdev/simple_gpio.h>
 
 #include "mpc86xx.h"
 
@@ -51,6 +52,9 @@ static struct of_device_id __initdata mp
 
 static int __init mpc8610_declare_of_platform_devices(void)
 {
+	/* Firstly, register PIXIS GPIOs. */
+	simple_gpiochip_init("fsl,fpga-pixis-gpio-bank");
+
 	/* Without this call, the SSI device driver won't get probed. */
 	of_platform_bus_probe(NULL, mpc8610_ids, NULL);
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

linux-next.patch
mpc52xx_psc_spi-convert-to-cs_control-callback.patch
spi_mpc83xx-handle-other-freescale-processors.patch
spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch
spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch
powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch
spi_mpc83xx-fix-checkpatch-issues.patch
spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch
spi_mpc83xx-remove-dead-code.patch
spi_mpc83xx-rename-spi_83xxc-to-spi_8xxxc.patch
spi_mpc8xxx-s-83xx-8xxx-g.patch

