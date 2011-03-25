From: akpm@linux-foundation.org
Subject: [merged] rapidio-modify-configuration-to-support-pci-srio-controller.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:08 -0700
Message-ID: <201103250726.p2P7Q2c6026105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab1CYH0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, benh@kernel.crashing.org, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com, mm-commi


The patch titled
     rapidio: modify configuration to support PCI-SRIO controller
has been removed from the -mm tree.  Its filename was
     rapidio-modify-configuration-to-support-pci-srio-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: modify configuration to support PCI-SRIO controller
From: Alexandre Bounine <alexandre.bounine@idt.com>

1. Add an option to include RapidIO support if the PCI is available.
2. Add FSL_RIO configuration option to enable controller selection.
3. Add RapidIO support option into x86 and MIPS architectures.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig                         |   10 ++++++++++
 arch/powerpc/Kconfig                      |   10 +++++++++-
 arch/powerpc/kernel/cpu_setup_fsl_booke.S |    2 +-
 arch/powerpc/sysdev/Makefile              |    2 +-
 arch/x86/Kconfig                          |   10 ++++++++++
 drivers/net/rionet.c                      |    4 ++--
 drivers/rapidio/rio-sysfs.c               |    1 +
 7 files changed, 34 insertions(+), 5 deletions(-)

diff -puN arch/mips/Kconfig~rapidio-modify-configuration-to-support-pci-srio-controller arch/mips/Kconfig
--- a/arch/mips/Kconfig~rapidio-modify-configuration-to-support-pci-srio-controller
+++ a/arch/mips/Kconfig
@@ -2344,6 +2344,16 @@ source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
 
+config RAPIDIO
+	bool "RapidIO support"
+	depends on PCI
+	default n
+	help
+	  If you say Y here, the kernel will include drivers and
+	  infrastructure code to support RapidIO interconnect devices.
+
+source "drivers/rapidio/Kconfig"
+
 endmenu
 
 menu "Executable file formats"
diff -puN arch/powerpc/Kconfig~rapidio-modify-configuration-to-support-pci-srio-controller arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~rapidio-modify-configuration-to-support-pci-srio-controller
+++ a/arch/powerpc/Kconfig
@@ -772,11 +772,19 @@ config HAS_RAPIDIO
 
 config RAPIDIO
 	bool "RapidIO support"
-	depends on HAS_RAPIDIO
+	depends on HAS_RAPIDIO || PCI
 	help
 	  If you say Y here, the kernel will include drivers and
 	  infrastructure code to support RapidIO interconnect devices.
 
+config FSL_RIO
+	bool "Freescale Embedded SRIO Controller support"
+	depends on RAPIDIO && HAS_RAPIDIO
+	default "n"
+	---help---
+	  Include support for RapidIO controller on Freescale embedded
+	  processors (MPC8548, MPC8641, etc).
+
 source "drivers/rapidio/Kconfig"
 
 endmenu
diff -puN arch/powerpc/kernel/cpu_setup_fsl_booke.S~rapidio-modify-configuration-to-support-pci-srio-controller arch/powerpc/kernel/cpu_setup_fsl_booke.S
--- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S~rapidio-modify-configuration-to-support-pci-srio-controller
+++ a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
@@ -64,7 +64,7 @@ _GLOBAL(__setup_cpu_e500v2)
 	bl	__e500_icache_setup
 	bl	__e500_dcache_setup
 	bl	__setup_e500_ivors
-#ifdef CONFIG_RAPIDIO
+#ifdef CONFIG_FSL_RIO
 	/* Ensure that RFXE is set */
 	mfspr	r3,SPRN_HID1
 	oris	r3,r3,HID1_RFXE@h
diff -puN arch/powerpc/sysdev/Makefile~rapidio-modify-configuration-to-support-pci-srio-controller arch/powerpc/sysdev/Makefile
--- a/arch/powerpc/sysdev/Makefile~rapidio-modify-configuration-to-support-pci-srio-controller
+++ a/arch/powerpc/sysdev/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
 obj-$(CONFIG_MPC8xxx_GPIO)	+= mpc8xxx_gpio.o
 obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
 obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
-obj-$(CONFIG_RAPIDIO)		+= fsl_rio.o
+obj-$(CONFIG_FSL_RIO)		+= fsl_rio.o
 obj-$(CONFIG_TSI108_BRIDGE)	+= tsi108_pci.o tsi108_dev.o
 obj-$(CONFIG_QUICC_ENGINE)	+= qe_lib/
 obj-$(CONFIG_PPC_BESTCOMM)	+= bestcomm/
diff -puN arch/x86/Kconfig~rapidio-modify-configuration-to-support-pci-srio-controller arch/x86/Kconfig
--- a/arch/x86/Kconfig~rapidio-modify-configuration-to-support-pci-srio-controller
+++ a/arch/x86/Kconfig
@@ -2096,6 +2096,16 @@ source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
 
+config RAPIDIO
+	bool "RapidIO support"
+	depends on PCI
+	default n
+	help
+	  If you say Y here, the kernel will include drivers and
+	  infrastructure code to support RapidIO interconnect devices.
+
+source "drivers/rapidio/Kconfig"
+
 endmenu
 
 
diff -puN drivers/net/rionet.c~rapidio-modify-configuration-to-support-pci-srio-controller drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-modify-configuration-to-support-pci-srio-controller
+++ a/drivers/net/rionet.c
@@ -382,7 +382,7 @@ static void rionet_remove(struct rio_dev
 	struct rionet_peer *peer, *tmp;
 
 	free_pages((unsigned long)rionet_active, rdev->net->hport->sys_size ?
-					__ilog2(sizeof(void *)) + 4 : 0);
+					__fls(sizeof(void *)) + 4 : 0);
 	unregister_netdev(ndev);
 	free_netdev(ndev);
 
@@ -450,7 +450,7 @@ static int rionet_setup_netdev(struct ri
 	}
 
 	rionet_active = (struct rio_dev **)__get_free_pages(GFP_KERNEL,
-			mport->sys_size ? __ilog2(sizeof(void *)) + 4 : 0);
+			mport->sys_size ? __fls(sizeof(void *)) + 4 : 0);
 	if (!rionet_active) {
 		rc = -ENOMEM;
 		goto out;
diff -puN drivers/rapidio/rio-sysfs.c~rapidio-modify-configuration-to-support-pci-srio-controller drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-modify-configuration-to-support-pci-srio-controller
+++ a/drivers/rapidio/rio-sysfs.c
@@ -14,6 +14,7 @@
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
 #include <linux/stat.h>
+#include <linux/capability.h>
 
 #include "rio.h"
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

