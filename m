From: akpm@linux-foundation.org
Subject: - pata_platform-for-arm-riscpc.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:30 -0700
Message-ID: <200704302144.l3ULiUEZ015603@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031140AbXD3VpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+lkml@arm.linux.org.uk, jeff@garzik.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pata_platform for ARM RiscPC
has been removed from the -mm tree.  Its filename was
     pata_platform-for-arm-riscpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_platform for ARM RiscPC
From: Russell King <rmk+lkml@arm.linux.org.uk>

Add pata_platform device for RiscPC, thereby converting the primary
IDE channel on the machine to PATA.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-rpc/riscpc.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/ata/Kconfig        |    2 +-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-rpc/riscpc.c~pata_platform-for-arm-riscpc arch/arm/mach-rpc/riscpc.c
--- a/arch/arm/mach-rpc/riscpc.c~pata_platform-for-arm-riscpc
+++ a/arch/arm/mach-rpc/riscpc.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/serial_8250.h>
+#include <linux/pata_platform.h>
 
 #include <asm/elf.h>
 #include <asm/io.h>
@@ -159,11 +160,45 @@ static struct platform_device serial_dev
 	},
 };
 
+static struct pata_platform_info pata_platform_data = {
+	.ioport_shift		= 2,
+};
+
+static struct resource pata_resources[] = {
+	[0] = {
+		.start		= 0x030107c0,
+		.end		= 0x030107df,
+		.flags		= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start		= 0x03010fd8,
+		.end		= 0x03010fdb,
+		.flags		= IORESOURCE_MEM,
+	},
+	[2] = {
+		.start		= IRQ_HARDDISK,
+		.end		= IRQ_HARDDISK,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device pata_device = {
+	.name			= "pata_platform",
+	.id			= -1,
+	.num_resources		= ARRAY_SIZE(pata_resources),
+	.resource		= pata_resources,
+	.dev			= {
+		.platform_data	= &pata_platform_data,
+		.coherent_dma_mask = ~0,	/* grumble */
+	},
+};
+
 static struct platform_device *devs[] __initdata = {
 	&iomd_device,
 	&kbd_device,
 	&serial_device,
 	&acornfb_device,
+	&pata_device,
 };
 
 static int __init rpc_init(void)
diff -puN drivers/ata/Kconfig~pata_platform-for-arm-riscpc drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~pata_platform-for-arm-riscpc
+++ a/drivers/ata/Kconfig
@@ -545,7 +545,7 @@ config PATA_WINBOND_VLB
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED
+	depends on EMBEDDED || ARCH_RPC
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
_

Patches currently in -mm which might be from rmk+lkml@arm.linux.org.uk are

git-kbuild.patch
pata_icside-driver.patch
driver_bfin_serial_core.patch
make-dev-port-conditional-on-config-symbol.patch
