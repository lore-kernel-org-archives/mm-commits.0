From: akpm@linux-foundation.org
Subject: [to-be-updated] dmaengine-dma40-u8500-platform-configuration-v3.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:54:13 -0700
Message-ID: <201004271921.o3RJLcHR014853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755931Ab0D0TWO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 15:22:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@stericsson.com, dan.j.williams@intel.com, rubini@unipv.it, srinidhi.kasagar@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     dmaengine: DMA40 U8500 platform configuration
has been removed from the -mm tree.  Its filename was
     dmaengine-dma40-u8500-platform-configuration-v3.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmaengine: DMA40 U8500 platform configuration
From: Linus Walleij <linus.walleij@stericsson.com>

This completes the DMA40 support with the platform-specific configuration
for U8500/DB8500.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ux500/board-mop500.c          |  222 ++++++++++++++++++
 arch/arm/mach-ux500/clock.c                 |    2 
 arch/arm/mach-ux500/include/mach/hardware.h |   16 +
 arch/arm/mach-ux500/ste-dma40-db8500.h      |  133 ++++++++++
 4 files changed, 371 insertions(+), 2 deletions(-)

diff -puN arch/arm/mach-ux500/board-mop500.c~dmaengine-dma40-u8500-platform-configuration-v3 arch/arm/mach-ux500/board-mop500.c
--- a/arch/arm/mach-ux500/board-mop500.c~dmaengine-dma40-u8500-platform-configuration-v3
+++ a/arch/arm/mach-ux500/board-mop500.c
@@ -20,11 +20,14 @@
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+#include <plat/ste_dma40.h>
 #include <plat/i2c.h>
 
 #include <mach/hardware.h>
 #include <mach/setup.h>
 
+#include "ste-dma40-db8500.h"
+
 #define __MEM_4K_RESOURCE(x) \
 	.res = {.start = (x), .end = (x) + SZ_4K - 1, .flags = IORESOURCE_MEM}
 
@@ -183,6 +186,221 @@ U8500_I2C_PDEVICE(1);
 U8500_I2C_PDEVICE(2);
 U8500_I2C_PDEVICE(3);
 
+static struct resource dma40_resources[] = {
+	[0] = {
+		.start = U8500_DMA_BASE_V1,
+		.end = U8500_DMA_BASE_V1 + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "base",
+	},
+	[1] = {
+		.start = U8500_DMA_LCPA_BASE,
+		.end = U8500_DMA_LCPA_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "lcpa",
+	},
+	[2] = {
+		.start = U8500_DMA_LCLA_BASE,
+		.end = U8500_DMA_LCLA_BASE + 16 * 1024 - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "lcla",
+	},
+	[3] = {
+		.start = IRQ_DMA,
+		.end = IRQ_DMA,
+		.flags = IORESOURCE_IRQ}
+};
+
+/* Default configuration for physcial memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
+	.channel_type = (STEDMA40_CHANNEL_IN_PHY_MODE |
+			 STEDMA40_LOW_PRIORITY_CHANNEL |
+			 STEDMA40_PCHAN_BASIC_MODE),
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_PHY_1,
+
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
+
+};
+/* Default configuration for logical memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_log = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE |
+			 STEDMA40_LOW_PRIORITY_CHANNEL |
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG |
+			 STEDMA40_NO_TIM_FOR_LINK),
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_LOG_1,
+
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
+
+};
+
+/*
+ * Mapping between destination event lines and physical device address.
+ * The event line is tied to a device and therefor the address is constant.
+ */
+const static dma_addr_t dma40_tx_map[STEDMA40_DEV_MAX] = {
+	[STEDMA40_DEV_SPI0_TX] = 0,
+	[STEDMA40_DEV_SD_MMC0_TX] = 0,
+	[STEDMA40_DEV_SD_MMC1_TX] = 0,
+	[STEDMA40_DEV_SD_MMC2_TX] = 0,
+	[STEDMA40_DEV_I2C1_TX] = 0,
+	[STEDMA40_DEV_I2C3_TX] = 0,
+	[STEDMA40_DEV_I2C2_TX] = 0,
+	[STEDMA40_DEV_SSP0_TX] = 0,
+	[STEDMA40_DEV_SSP1_TX] = 0,
+	[STEDMA40_DEV_UART2_TX] = 0,
+	[STEDMA40_DEV_UART1_TX] = 0,
+	[STEDMA40_DEV_UART0_TX] = 0,
+	[STEDMA40_DEV_MSP2_TX] = 0,
+	[STEDMA40_DEV_I2C0_TX] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_8] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_1_9] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_2_10] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_3_11] = 0,
+	[STEDMA40_DEV_SLIM0_CH0_TX_HSI_TX_CH0] = 0,
+	[STEDMA40_DEV_SLIM0_CH1_TX_HSI_TX_CH1] = 0,
+	[STEDMA40_DEV_SLIM0_CH2_TX_HSI_TX_CH2] = 0,
+	[STEDMA40_DEV_SLIM0_CH3_TX_HSI_TX_CH3] = 0,
+	[STEDMA40_DEV_DST_SXA0_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA1_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA2_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA3_RX_TX] = 0,
+	[STEDMA40_DEV_SD_MM2_TX] = 0,
+	[STEDMA40_DEV_SD_MM0_TX] = 0,
+	[STEDMA40_DEV_MSP1_TX] = 0,
+	[STEDMA40_SLIM0_CH0_TX] = 0,
+	[STEDMA40_DEV_MSP0_TX] = 0,
+	[STEDMA40_DEV_SD_MM1_TX] = 0,
+	[STEDMA40_DEV_SPI2_TX] = 0,
+	[STEDMA40_DEV_I2C3_TX2] = 0,
+	[STEDMA40_DEV_SPI1_TX] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_4_12] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_5_13] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_6_14] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_7_15] = 0,
+	[STEDMA40_DEV_SPI3_TX] = 0,
+	[STEDMA40_DEV_SD_MM3_TX] = 0,
+	[STEDMA40_DEV_SD_MM4_TX] = 0,
+	[STEDMA40_DEV_SD_MM5_TX] = 0,
+	[STEDMA40_DEV_DST_SXA4_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA5_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA6_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA7_RX_TX] = 0,
+	[STEDMA40_DEV_CAC1_TX] = 0,
+	[STEDMA40_DEV_CAC1_TX_HAC1_TX] = 0,
+	[STEDMA40_DEV_HAC1_TX] = 0,
+	[STEDMA40_DEV_CAC0_TX] = 0,
+	[STEDMA40_DEV_CAC0_TX_HAC0_TX] = 0,
+	[STEDMA40_DEV_HAC0_TX] = 0,
+};
+
+/* Mapping between source event lines and physical device address */
+const static dma_addr_t dma40_rx_map[STEDMA40_DEV_MAX] = {
+	[STEDMA40_DEV_SPI0_RX] = 0,
+	[STEDMA40_DEV_SD_MMC0_RX] = 0,
+	[STEDMA40_DEV_SD_MMC1_RX] = 0,
+	[STEDMA40_DEV_SD_MMC2_RX] = 0,
+	[STEDMA40_DEV_I2C1_RX] = 0,
+	[STEDMA40_DEV_I2C3_RX] = 0,
+	[STEDMA40_DEV_I2C2_RX] = 0,
+	[STEDMA40_DEV_SSP0_RX] = 0,
+	[STEDMA40_DEV_SSP1_RX] = 0,
+	[STEDMA40_DEV_MCDE_RX] = 0,
+	[STEDMA40_DEV_UART2_RX] = 0,
+	[STEDMA40_DEV_UART1_RX] = 0,
+	[STEDMA40_DEV_UART0_RX] = 0,
+	[STEDMA40_DEV_MSP2_RX] = 0,
+	[STEDMA40_DEV_I2C0_RX] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_8] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_1_9] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_2_10] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_3_11] = 0,
+	[STEDMA40_DEV_SLIM0_CH0_RX_HSI_RX_CH0] = 0,
+	[STEDMA40_DEV_SLIM0_CH1_RX_HSI_RX_CH1] = 0,
+	[STEDMA40_DEV_SLIM0_CH2_RX_HSI_RX_CH2] = 0,
+	[STEDMA40_DEV_SLIM0_CH3_RX_HSI_RX_CH3] = 0,
+	[STEDMA40_DEV_SRC_SXA0_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA1_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA2_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA3_RX_TX] = 0,
+	[STEDMA40_DEV_SD_MM2_RX] = 0,
+	[STEDMA40_DEV_SD_MM0_RX] = 0,
+	[STEDMA40_DEV_MSP1_RX] = 0,
+	[STEDMA40_SLIM0_CH0_RX] = 0,
+	[STEDMA40_DEV_MSP0_RX] = 0,
+	[STEDMA40_DEV_SD_MM1_RX] = 0,
+	[STEDMA40_DEV_SPI2_RX] = 0,
+	[STEDMA40_DEV_I2C3_RX2] = 0,
+	[STEDMA40_DEV_SPI1_RX] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_4_12] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_5_13] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_6_14] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_7_15] = 0,
+	[STEDMA40_DEV_SPI3_RX] = 0,
+	[STEDMA40_DEV_SD_MM3_RX] = 0,
+	[STEDMA40_DEV_SD_MM4_RX] = 0,
+	[STEDMA40_DEV_SD_MM5_RX] = 0,
+	[STEDMA40_DEV_SRC_SXA4_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA5_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA6_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA7_RX_TX] = 0,
+	[STEDMA40_DEV_CAC1_RX] = 0,
+	[STEDMA40_DEV_MSHC_RX] = 0,
+	[STEDMA40_DEV_SLIM1_CH0_RX_HSI_RX_CH4] = 0,
+	[STEDMA40_DEV_SLIM1_CH1_RX_HSI_RX_CH5] = 0,
+	[STEDMA40_DEV_SLIM1_CH2_RX_HSI_RX_CH6] = 0,
+	[STEDMA40_DEV_SLIM1_CH3_RX_HSI_RX_CH7] = 0,
+	[STEDMA40_DEV_CAC0_RX] = 0,
+};
+
+/* Reserved event lines for memcpy only */
+static int dma40_memcpy_event[] = {
+	STEDMA40_MEMCPY_TX_1,
+	STEDMA40_MEMCPY_TX_2,
+	STEDMA40_MEMCPY_TX_3,
+	STEDMA40_MEMCPY_TX_4,
+};
+
+static struct stedma40_platform_data dma40_plat_data = {
+	.dev_len = STEDMA40_DEV_MAX,
+	.dev_rx = dma40_rx_map,
+	.dev_tx = dma40_tx_map,
+	.memcpy = dma40_memcpy_event,
+	.memcpy_len = ARRAY_SIZE(dma40_memcpy_event),
+	.memcpy_conf_phy = &dma40_memcpy_conf_phy,
+	.memcpy_conf_log = &dma40_memcpy_conf_log,
+	.llis_per_log = 8,
+};
+
+static struct platform_device dma40_device = {
+	.dev = {
+		.platform_data = &dma40_plat_data,
+	},
+	.name = "dma40",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(dma40_resources),
+	.resource = dma40_resources
+};
+
+static void dma40_u8500ed_updates(void)
+{
+	dma40_plat_data.memcpy = NULL;
+	dma40_plat_data.memcpy_len = 0;
+	dma40_resources[0].start = U8500_DMA_BASE_ED;
+	dma40_resources[0].end = U8500_DMA_BASE_ED + SZ_4K - 1;
+}
+
 static struct amba_device *amba_devs[] __initdata = {
 	&uart0_device,
 	&uart1_device,
@@ -197,12 +415,16 @@ static struct platform_device *platform_
 	&i2c_controller1,
 	&i2c_controller2,
 	&i2c_controller3,
+	&dma40_device,
 };
 
 static void __init u8500_init_machine(void)
 {
 	int i;
 
+	if (cpu_is_u8500ed())
+		dma40_u8500ed_updates();
+
 	/* Register the active AMBA devices on this board */
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++)
 		amba_device_register(amba_devs[i], &iomem_resource);
diff -puN arch/arm/mach-ux500/clock.c~dmaengine-dma40-u8500-platform-configuration-v3 arch/arm/mach-ux500/clock.c
--- a/arch/arm/mach-ux500/clock.c~dmaengine-dma40-u8500-platform-configuration-v3
+++ a/arch/arm/mach-ux500/clock.c
@@ -407,7 +407,7 @@ static struct clk_lookup u8500_common_cl
 	CLK(apetraceclk,	"apetrace",	NULL),
 	CLK(mcdeclk,	"mcde",		NULL),
 	CLK(ipi2clk,	"ipi2",		NULL),
-	CLK(dmaclk,	"dma40",	NULL),
+	CLK(dmaclk,	"dma40.0",	NULL),
 	CLK(b2r2clk,	"b2r2",		NULL),
 	CLK(tvclk,	"tv",		NULL),
 };
diff -puN arch/arm/mach-ux500/include/mach/hardware.h~dmaengine-dma40-u8500-platform-configuration-v3 arch/arm/mach-ux500/include/mach/hardware.h
--- a/arch/arm/mach-ux500/include/mach/hardware.h~dmaengine-dma40-u8500-platform-configuration-v3
+++ a/arch/arm/mach-ux500/include/mach/hardware.h
@@ -26,6 +26,19 @@
 /* used by some plat-nomadik code */
 #define io_p2v(n)		__io_address(n)
 
+
+/* Base address and bank offsets for ESRAM */
+#define U8500_ESRAM_BASE	0x40000000
+#define U8500_ESRAM_BANK_SIZE	0x00020000
+#define U8500_ESRAM_BANK0	U8500_ESRAM_BASE
+#define U8500_ESRAM_BANK1	(U8500_ESRAM_BASE + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK2	(U8500_ESRAM_BANK1 + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK3	(U8500_ESRAM_BANK2 + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK4	(U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
+/* Use bank 4 for DMA LCLA and LCPA */
+#define U8500_DMA_LCLA_BASE	U8500_ESRAM_BANK4
+#define U8500_DMA_LCPA_BASE	(U8500_ESRAM_BANK4 + 0x4000)
+
 /*
  * Base address definitions for U8500 Onchip IPs. All the
  * peripherals are contained in a single 1 Mbyte region, with
@@ -47,7 +60,8 @@
 
 #define U8500_SGA_BASE		0xa0300000
 #define U8500_MCDE_BASE		0xa0350000
-#define U8500_DMA_BASE		0xa0362000
+#define U8500_DMA_BASE_ED	0xa0362000
+#define U8500_DMA_BASE_V1	0x801C0000
 
 #define U8500_SCU_BASE		0xa0410000
 #define U8500_GIC_CPU_BASE	0xa0410100
diff -puN /dev/null arch/arm/mach-ux500/ste-dma40-db8500.h
--- /dev/null
+++ a/arch/arm/mach-ux500/ste-dma40-db8500.h
@@ -0,0 +1,133 @@
+/*
+ * arch/arm/mach-ux500/ste_dma40_db8500.h
+ * DB8500-SoC-specific configuration for DMA40
+ *
+ * Copyright (C) ST-Ericsson 2007-2010
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Per Friden <per.friden@stericsson.com>
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
+ */
+#ifndef STE_DMA40_DB8500_H
+#define STE_DMA40_DB8500_H
+
+#define STEDMA40_DEV_MAX 64
+
+enum dma_src_dev_type {
+	STEDMA40_DEV_SPI0_RX = 0,
+	STEDMA40_DEV_SD_MMC0_RX,
+	STEDMA40_DEV_SD_MMC1_RX,
+	STEDMA40_DEV_SD_MMC2_RX,
+	STEDMA40_DEV_I2C1_RX,
+	STEDMA40_DEV_I2C3_RX,
+	STEDMA40_DEV_I2C2_RX,
+	STEDMA40_DEV_SSP0_RX = 8,
+	STEDMA40_DEV_SSP1_RX,
+	STEDMA40_DEV_MCDE_RX,
+	STEDMA40_DEV_UART2_RX,
+	STEDMA40_DEV_UART1_RX,
+	STEDMA40_DEV_UART0_RX,
+	STEDMA40_DEV_MSP2_RX,
+	STEDMA40_DEV_I2C0_RX,	/*15*/
+	STEDMA40_DEV_USB_OTG_IEP_8,
+	STEDMA40_DEV_USB_OTG_IEP_1_9,
+	STEDMA40_DEV_USB_OTG_IEP_2_10,
+	STEDMA40_DEV_USB_OTG_IEP_3_11,
+	STEDMA40_DEV_SLIM0_CH0_RX_HSI_RX_CH0,
+	STEDMA40_DEV_SLIM0_CH1_RX_HSI_RX_CH1,
+	STEDMA40_DEV_SLIM0_CH2_RX_HSI_RX_CH2,
+	STEDMA40_DEV_SLIM0_CH3_RX_HSI_RX_CH3,
+	STEDMA40_DEV_SRC_SXA0_RX_TX,
+	STEDMA40_DEV_SRC_SXA1_RX_TX,
+	STEDMA40_DEV_SRC_SXA2_RX_TX,
+	STEDMA40_DEV_SRC_SXA3_RX_TX,
+	STEDMA40_DEV_SD_MM2_RX,
+	STEDMA40_DEV_SD_MM0_RX,
+	STEDMA40_DEV_MSP1_RX,
+	STEDMA40_SLIM0_CH0_RX,
+	STEDMA40_DEV_MSP0_RX = STEDMA40_SLIM0_CH0_RX,
+	STEDMA40_DEV_SD_MM1_RX,
+	STEDMA40_DEV_SPI2_RX,
+	STEDMA40_DEV_I2C3_RX2,
+	STEDMA40_DEV_SPI1_RX,
+	STEDMA40_DEV_USB_OTG_IEP_4_12,
+	STEDMA40_DEV_USB_OTG_IEP_5_13,
+	STEDMA40_DEV_USB_OTG_IEP_6_14,
+	STEDMA40_DEV_USB_OTG_IEP_7_15,
+	STEDMA40_DEV_SPI3_RX,
+	STEDMA40_DEV_SD_MM3_RX,
+	STEDMA40_DEV_SD_MM4_RX,
+	STEDMA40_DEV_SD_MM5_RX,
+	STEDMA40_DEV_SRC_SXA4_RX_TX,
+	STEDMA40_DEV_SRC_SXA5_RX_TX,
+	STEDMA40_DEV_SRC_SXA6_RX_TX,
+	STEDMA40_DEV_SRC_SXA7_RX_TX,
+	STEDMA40_DEV_CAC1_RX,
+	STEDMA40_DEV_MSHC_RX = 51,
+	STEDMA40_DEV_SLIM1_CH0_RX_HSI_RX_CH4,
+	STEDMA40_DEV_SLIM1_CH1_RX_HSI_RX_CH5,
+	STEDMA40_DEV_SLIM1_CH2_RX_HSI_RX_CH6,
+	STEDMA40_DEV_SLIM1_CH3_RX_HSI_RX_CH7,
+	STEDMA40_DEV_CAC0_RX = 61,
+};
+
+enum dma_dest_dev_type {
+	STEDMA40_DEV_SPI0_TX = 0,
+	STEDMA40_DEV_SD_MMC0_TX,
+	STEDMA40_DEV_SD_MMC1_TX,
+	STEDMA40_DEV_SD_MMC2_TX,
+	STEDMA40_DEV_I2C1_TX,
+	STEDMA40_DEV_I2C3_TX,
+	STEDMA40_DEV_I2C2_TX,
+	STEDMA40_DEV_SSP0_TX = 8,
+	STEDMA40_DEV_SSP1_TX,
+	STEDMA40_DEV_UART2_TX = 11,
+	STEDMA40_DEV_UART1_TX,
+	STEDMA40_DEV_UART0_TX,
+	STEDMA40_DEV_MSP2_TX,
+	STEDMA40_DEV_I2C0_TX,
+	STEDMA40_DEV_USB_OTG_OEP_8,
+	STEDMA40_DEV_USB_OTG_OEP_1_9,
+	STEDMA40_DEV_USB_OTG_OEP_2_10,
+	STEDMA40_DEV_USB_OTG_OEP_3_11,
+	STEDMA40_DEV_SLIM0_CH0_TX_HSI_TX_CH0,
+	STEDMA40_DEV_SLIM0_CH1_TX_HSI_TX_CH1,
+	STEDMA40_DEV_SLIM0_CH2_TX_HSI_TX_CH2,
+	STEDMA40_DEV_SLIM0_CH3_TX_HSI_TX_CH3,
+	STEDMA40_DEV_DST_SXA0_RX_TX,
+	STEDMA40_DEV_DST_SXA1_RX_TX,
+	STEDMA40_DEV_DST_SXA2_RX_TX,
+	STEDMA40_DEV_DST_SXA3_RX_TX,
+	STEDMA40_DEV_SD_MM2_TX,
+	STEDMA40_DEV_SD_MM0_TX,
+	STEDMA40_DEV_MSP1_TX,
+	STEDMA40_SLIM0_CH0_TX,
+	STEDMA40_DEV_MSP0_TX = STEDMA40_SLIM0_CH0_TX,
+	STEDMA40_DEV_SD_MM1_TX,
+	STEDMA40_DEV_SPI2_TX,
+	STEDMA40_DEV_I2C3_TX2,
+	STEDMA40_DEV_SPI1_TX,
+	STEDMA40_DEV_USB_OTG_OEP_4_12,
+	STEDMA40_DEV_USB_OTG_OEP_5_13,
+	STEDMA40_DEV_USB_OTG_OEP_6_14,
+	STEDMA40_DEV_USB_OTG_OEP_7_15,
+	STEDMA40_DEV_SPI3_TX,
+	STEDMA40_DEV_SD_MM3_TX,
+	STEDMA40_DEV_SD_MM4_TX,
+	STEDMA40_DEV_SD_MM5_TX,
+	STEDMA40_DEV_DST_SXA4_RX_TX,
+	STEDMA40_DEV_DST_SXA5_RX_TX,
+	STEDMA40_DEV_DST_SXA6_RX_TX,
+	STEDMA40_DEV_DST_SXA7_RX_TX,
+	STEDMA40_DEV_CAC1_TX,
+	STEDMA40_DEV_CAC1_TX_HAC1_TX,
+	STEDMA40_DEV_HAC1_TX,
+	STEDMA40_MEMCPY_TX_1 = 56,
+	STEDMA40_MEMCPY_TX_2,
+	STEDMA40_MEMCPY_TX_3,
+	STEDMA40_MEMCPY_TX_4,
+	STEDMA40_DEV_CAC0_TX = 61,
+	STEDMA40_DEV_CAC0_TX_HAC0_TX,
+	STEDMA40_DEV_HAC0_TX,
+};
+
+#endif
_

Patches currently in -mm which might be from linus.walleij@stericsson.com are

linux-next.patch
dmaengine-dma40-u8500-platform-configuration-v3.patch

