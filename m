From: akpm@linux-foundation.org
Subject: + arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch added to -mm tree
Date: Wed, 12 May 2010 15:55:59 -0700
Message-ID: <201005122255.o4CMtxlX025673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab0ELXCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 19:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, dan.j.williams@intel.com, ian@mnementh.co.uk, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, sameo@linux.intel.com


The patch titled
     arm: add DMA support to sh7372, enable DMA for SDHI
has been added to the -mm tree.  Its filename is
     arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch

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
Subject: arm: add DMA support to sh7372, enable DMA for SDHI
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

This adds DMA support for the sh7372 sh-mobile ARM core, using the shdma
dmaengine driver, and uses DMA for the SDHI SD-card controller on this SoC.

This patch depends on patch series from Magnus for shmobile, adding INTC
and clock support.  This patch wasn't there in the first version of this
series.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-shmobile/board-ap4evb.c        |    9 
 arch/arm/mach-shmobile/include/mach/sh7372.h |   10 
 arch/arm/mach-shmobile/setup-sh7372.c        |  223 +++++++++++++++++
 3 files changed, 242 insertions(+)

diff -puN arch/arm/mach-shmobile/board-ap4evb.c~arm-add-dma-support-to-sh7372-enable-dma-for-sdhi arch/arm/mach-shmobile/board-ap4evb.c
--- a/arch/arm/mach-shmobile/board-ap4evb.c~arm-add-dma-support-to-sh7372-enable-dma-for-sdhi
+++ a/arch/arm/mach-shmobile/board-ap4evb.c
@@ -23,6 +23,7 @@
 #include <linux/irq.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <linux/mfd/sh_mobile_sdhi.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
@@ -223,6 +224,11 @@ static struct platform_device keysc_devi
 };
 
 /* SDHI0 */
+static struct sh_mobile_sdhi_info sdhi0_info = {
+	.dma_slave_tx = SHDMA_SLAVE_SDHI0_TX,
+	.dma_slave_rx = SHDMA_SLAVE_SDHI0_RX,
+};
+
 static struct resource sdhi0_resources[] = {
 	[0] = {
 		.name	= "SDHI0",
@@ -241,6 +247,9 @@ static struct platform_device sdhi0_devi
 	.num_resources  = ARRAY_SIZE(sdhi0_resources),
 	.resource       = sdhi0_resources,
 	.id             = 0,
+	.dev	= {
+		.platform_data	= &sdhi0_info,
+	},
 };
 
 /* USB1 */
diff -puN arch/arm/mach-shmobile/include/mach/sh7372.h~arm-add-dma-support-to-sh7372-enable-dma-for-sdhi arch/arm/mach-shmobile/include/mach/sh7372.h
--- a/arch/arm/mach-shmobile/include/mach/sh7372.h~arm-add-dma-support-to-sh7372-enable-dma-for-sdhi
+++ a/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -431,4 +431,14 @@ enum {
 	GPIO_FN_SDENC_DV_CLKI,
 };
 
+/* DMA slave IDs */
+enum {
+	SHDMA_SLAVE_SDHI0_RX,
+	SHDMA_SLAVE_SDHI0_TX,
+	SHDMA_SLAVE_SDHI1_RX,
+	SHDMA_SLAVE_SDHI1_TX,
+	SHDMA_SLAVE_SDHI2_RX,
+	SHDMA_SLAVE_SDHI2_TX,
+};
+
 #endif /* __ASM_SH7372_H__ */
diff -puN arch/arm/mach-shmobile/setup-sh7372.c~arm-add-dma-support-to-sh7372-enable-dma-for-sdhi arch/arm/mach-shmobile/setup-sh7372.c
--- a/arch/arm/mach-shmobile/setup-sh7372.c~arm-add-dma-support-to-sh7372-enable-dma-for-sdhi
+++ a/arch/arm/mach-shmobile/setup-sh7372.c
@@ -26,9 +26,11 @@
 #include <linux/input.h>
 #include <linux/io.h>
 #include <linux/serial_sci.h>
+#include <linux/sh_dma.h>
 #include <linux/sh_intc.h>
 #include <linux/sh_timer.h>
 #include <mach/hardware.h>
+#include <mach/sh7372.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
@@ -214,6 +216,224 @@ static struct platform_device iic1_devic
 	.resource       = iic1_resources,
 };
 
+/* DMA */
+/* Transmit sizes and respective CHCR register values */
+enum {
+	XMIT_SZ_8BIT		= 0,
+	XMIT_SZ_16BIT		= 1,
+	XMIT_SZ_32BIT		= 2,
+	XMIT_SZ_64BIT		= 7,
+	XMIT_SZ_128BIT		= 3,
+	XMIT_SZ_256BIT		= 4,
+	XMIT_SZ_512BIT		= 5,
+};
+
+/* log2(size / 8) - used to calculate number of transfers */
+#define TS_SHIFT {			\
+	[XMIT_SZ_8BIT]		= 0,	\
+	[XMIT_SZ_16BIT]		= 1,	\
+	[XMIT_SZ_32BIT]		= 2,	\
+	[XMIT_SZ_64BIT]		= 3,	\
+	[XMIT_SZ_128BIT]	= 4,	\
+	[XMIT_SZ_256BIT]	= 5,	\
+	[XMIT_SZ_512BIT]	= 6,	\
+}
+
+#define TS_INDEX2VAL(i) ((((i) & 3) << 3) | \
+			 (((i) & 0xc) << (20 - 2)))
+
+static const struct sh_dmae_slave_config sh7724_dmae_slaves[] = {
+	{
+		.slave_id	= SHDMA_SLAVE_SDHI0_TX,
+		.addr		= 0xe6850030,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc1,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI0_RX,
+		.addr		= 0xe6850030,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc2,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI1_TX,
+		.addr		= 0xe6860030,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xc9,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI1_RX,
+		.addr		= 0xe6860030,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xca,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI2_TX,
+		.addr		= 0xe6870030,
+		.chcr		= DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xcd,
+	}, {
+		.slave_id	= SHDMA_SLAVE_SDHI2_RX,
+		.addr		= 0xe6870030,
+		.chcr		= DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL(XMIT_SZ_16BIT),
+		.mid_rid	= 0xce,
+	},
+};
+
+static const struct sh_dmae_channel sh7724_dmae_channels[] = {
+	{
+		.offset = 0,
+		.dmars = 0,
+		.dmars_bit = 0,
+	}, {
+		.offset = 0x10,
+		.dmars = 0,
+		.dmars_bit = 8,
+	}, {
+		.offset = 0x20,
+		.dmars = 4,
+		.dmars_bit = 0,
+	}, {
+		.offset = 0x30,
+		.dmars = 4,
+		.dmars_bit = 8,
+	}, {
+		.offset = 0x50,
+		.dmars = 8,
+		.dmars_bit = 0,
+	}, {
+		.offset = 0x60,
+		.dmars = 8,
+		.dmars_bit = 8,
+	}
+};
+
+static const unsigned int ts_shift[] = TS_SHIFT;
+
+static struct sh_dmae_pdata dma_platform_data = {
+	.slave		= sh7724_dmae_slaves,
+	.slave_num	= ARRAY_SIZE(sh7724_dmae_slaves),
+	.channel	= sh7724_dmae_channels,
+	.channel_num	= ARRAY_SIZE(sh7724_dmae_channels),
+	.ts_low_shift	= 3,
+	.ts_low_mask	= 0x18,
+	.ts_high_shift	= (20 - 2),	/* 2 bits for shifted low TS */
+	.ts_high_mask	= 0x00300000,
+	.ts_shift	= ts_shift,
+	.ts_shift_num	= ARRAY_SIZE(ts_shift),
+	.dmaor_init	= DMAOR_DME,
+};
+
+/* Resource order important! */
+static struct resource sh7724_dmae0_resources[] = {
+	{
+		/* Channel registers and DMAOR */
+		.start	= 0xfe008020,
+		.end	= 0xfe00808f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMARSx */
+		.start	= 0xfe009000,
+		.end	= 0xfe00900b,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMA error IRQ */
+		.start	= 246,
+		.end	= 246,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		/* IRQ for channels 0-5 */
+		.start	= 240,
+		.end	= 245,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+/* Resource order important! */
+static struct resource sh7724_dmae1_resources[] = {
+	{
+		/* Channel registers and DMAOR */
+		.start	= 0xfe018020,
+		.end	= 0xfe01808f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMARSx */
+		.start	= 0xfe019000,
+		.end	= 0xfe01900b,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMA error IRQ */
+		.start	= 254,
+		.end	= 254,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		/* IRQ for channels 0-5 */
+		.start	= 248,
+		.end	= 253,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+/* Resource order important! */
+static struct resource sh7724_dmae2_resources[] = {
+	{
+		/* Channel registers and DMAOR */
+		.start	= 0xfe028020,
+		.end	= 0xfe02808f,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMARSx */
+		.start	= 0xfe029000,
+		.end	= 0xfe02900b,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		/* DMA error IRQ */
+		.start	= 262,
+		.end	= 262,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		/* IRQ for channels 0-5 */
+		.start	= 256,
+		.end	= 261,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device dma0_device = {
+	.name		= "sh-dma-engine",
+	.id		= 0,
+	.resource	= sh7724_dmae0_resources,
+	.num_resources	= ARRAY_SIZE(sh7724_dmae0_resources),
+	.dev		= {
+		.platform_data	= &dma_platform_data,
+	},
+};
+
+static struct platform_device dma1_device = {
+	.name		= "sh-dma-engine",
+	.id		= 1,
+	.resource	= sh7724_dmae1_resources,
+	.num_resources	= ARRAY_SIZE(sh7724_dmae1_resources),
+	.dev		= {
+		.platform_data	= &dma_platform_data,
+	},
+};
+
+static struct platform_device dma2_device = {
+	.name		= "sh-dma-engine",
+	.id		= 2,
+	.resource	= sh7724_dmae2_resources,
+	.num_resources	= ARRAY_SIZE(sh7724_dmae2_resources),
+	.dev		= {
+		.platform_data	= &dma_platform_data,
+	},
+};
+
 static struct platform_device *sh7372_early_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
@@ -225,6 +445,9 @@ static struct platform_device *sh7372_ea
 	&cmt10_device,
 	&iic0_device,
 	&iic1_device,
+	&dma0_device,
+	&dma1_device,
+	&dma2_device,
 };
 
 void __init sh7372_add_standard_devices(void)
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch
sh-add-dma-slaves-for-two-sdhi-controllers-to-sh7722.patch
sh-add-dma-slave-definitions-to-sh7724.patch
sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch
mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch
sh-add-sdhi-dma-support-to-ecovec.patch
sh-add-sdhi-dma-support-to-ms7724se.patch
sh-add-sdhi-dma-support-to-kfr2r09.patch
sh-add-sdhi-dma-support-to-migor.patch
arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch

