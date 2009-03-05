From: akpm@linux-foundation.org
Subject: + m68knommu-m528x-build-fix.patch added to -mm tree
Date: Thu, 05 Mar 2009 14:25:18 -0800
Message-ID: <200903052225.n25MPIwn008319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbZCEWZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 17:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfking@fdwdc.com, gerg@snapgear.com


The patch titled
     m68knommu: m528x build fix
has been added to the -mm tree.  Its filename is
     m68knommu-m528x-build-fix.patch

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
Subject: m68knommu: m528x build fix
From: Steven King <sfking@fdwdc.com>

There isn't any mcfqspi.h in the tree, and without it everything inside the
#ifdef CONFIG_SPI is uncompilable.

Signed-off-by: Steven King <sfking@fdwdc.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/528x/config.c |  228 ------------------------
 1 file changed, 228 deletions(-)

diff -puN arch/m68knommu/platform/528x/config.c~m68knommu-m528x-build-fix arch/m68knommu/platform/528x/config.c
--- a/arch/m68knommu/platform/528x/config.c~m68knommu-m528x-build-fix
+++ a/arch/m68knommu/platform/528x/config.c
@@ -24,7 +24,6 @@
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfuart.h>
-#include <asm/mcfqspi.h>
 
 #ifdef CONFIG_MTD_PARTITIONS
 #include <linux/mtd/partitions.h>
@@ -33,233 +32,6 @@
 /***************************************************************************/
 
 void coldfire_reset(void);
-static void coldfire_qspi_cs_control(u8 cs, u8 command);
-
-/***************************************************************************/
-
-#if defined(CONFIG_SPI)
-
-#if defined(CONFIG_WILDFIRE)
-#define SPI_NUM_CHIPSELECTS 	0x02
-#define SPI_PAR_VAL		0x07  /* Enable DIN, DOUT, CLK */
-#define SPI_CS_MASK		0x18
-
-#define FLASH_BLOCKSIZE		(1024*64)
-#define FLASH_NUMBLOCKS		16
-#define FLASH_TYPE		"m25p80"
-
-#define M25P80_CS		0
-#define MMC_CS			1
-
-#ifdef CONFIG_MTD_PARTITIONS
-static struct mtd_partition stm25p_partitions[] = {
-	/* sflash */
-	[0] = {
-		.name = "stm25p80",
-		.offset = 0x00000000,
-		.size = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS,
-		.mask_flags = 0
-	}
-};
-
-#endif
-
-#elif defined(CONFIG_WILDFIREMOD)
-
-#define SPI_NUM_CHIPSELECTS	0x08
-#define SPI_PAR_VAL		0x07  /* Enable DIN, DOUT, CLK */
-#define SPI_CS_MASK		0x78
-
-#define FLASH_BLOCKSIZE		(1024*64)
-#define FLASH_NUMBLOCKS		64
-#define FLASH_TYPE		"m25p32"
-/* Reserve 1M for the kernel parition */
-#define FLASH_KERNEL_SIZE   (1024 * 1024)
-
-#define M25P80_CS		5
-#define MMC_CS			6
-
-#ifdef CONFIG_MTD_PARTITIONS
-static struct mtd_partition stm25p_partitions[] = {
-	/* sflash */
-	[0] = {
-		.name = "kernel",
-		.offset = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS - FLASH_KERNEL_SIZE,
-		.size = FLASH_KERNEL_SIZE,
-		.mask_flags = 0
-	},
-	[1] = {
-		.name = "image",
-		.offset = 0x00000000,
-		.size = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS - FLASH_KERNEL_SIZE,
-		.mask_flags = 0
-	},
-	[2] = {
-		.name = "all",
-		.offset = 0x00000000,
-		.size = FLASH_BLOCKSIZE * FLASH_NUMBLOCKS,
-		.mask_flags = 0
-	}
-};
-#endif
-
-#else
-#define SPI_NUM_CHIPSELECTS 	0x04
-#define SPI_PAR_VAL		0x7F  /* Enable DIN, DOUT, CLK, CS0 - CS4 */
-#endif
-
-#ifdef MMC_CS
-static struct coldfire_spi_chip flash_chip_info = {
-	.mode = SPI_MODE_0,
-	.bits_per_word = 16,
-	.del_cs_to_clk = 17,
-	.del_after_trans = 1,
-	.void_write_data = 0
-};
-
-static struct coldfire_spi_chip mmc_chip_info = {
-	.mode = SPI_MODE_0,
-	.bits_per_word = 16,
-	.del_cs_to_clk = 17,
-	.del_after_trans = 1,
-	.void_write_data = 0xFFFF
-};
-#endif
-
-#ifdef M25P80_CS
-static struct flash_platform_data stm25p80_platform_data = {
-	.name = "ST M25P80 SPI Flash chip",
-#ifdef CONFIG_MTD_PARTITIONS
-	.parts = stm25p_partitions,
-	.nr_parts = sizeof(stm25p_partitions) / sizeof(*stm25p_partitions),
-#endif
-	.type = FLASH_TYPE
-};
-#endif
-
-static struct spi_board_info spi_board_info[] __initdata = {
-#ifdef M25P80_CS
-	{
-		.modalias = "m25p80",
-		.max_speed_hz = 16000000,
-		.bus_num = 1,
-		.chip_select = M25P80_CS,
-		.platform_data = &stm25p80_platform_data,
-		.controller_data = &flash_chip_info
-	},
-#endif
-#ifdef MMC_CS
-	{
-		.modalias = "mmc_spi",
-		.max_speed_hz = 16000000,
-		.bus_num = 1,
-		.chip_select = MMC_CS,
-		.controller_data = &mmc_chip_info
-	}
-#endif
-};
-
-static struct coldfire_spi_master coldfire_master_info = {
-	.bus_num = 1,
-	.num_chipselect = SPI_NUM_CHIPSELECTS,
-	.irq_source = MCF5282_QSPI_IRQ_SOURCE,
-	.irq_vector = MCF5282_QSPI_IRQ_VECTOR,
-	.irq_mask = ((0x01 << MCF5282_QSPI_IRQ_SOURCE) | 0x01),
-	.irq_lp = 0x2B,  /* Level 5 and Priority 3 */
-	.par_val = SPI_PAR_VAL,
-	.cs_control = coldfire_qspi_cs_control,
-};
-
-static struct resource coldfire_spi_resources[] = {
-	[0] = {
-		.name = "qspi-par",
-		.start = MCF5282_QSPI_PAR,
-		.end = MCF5282_QSPI_PAR,
-		.flags = IORESOURCE_MEM
-	},
-
-	[1] = {
-		.name = "qspi-module",
-		.start = MCF5282_QSPI_QMR,
-		.end = MCF5282_QSPI_QMR + 0x18,
-		.flags = IORESOURCE_MEM
-	},
-
-	[2] = {
-		.name = "qspi-int-level",
-		.start = MCF5282_INTC0 + MCFINTC_ICR0 + MCF5282_QSPI_IRQ_SOURCE,
-		.end = MCF5282_INTC0 + MCFINTC_ICR0 + MCF5282_QSPI_IRQ_SOURCE,
-		.flags = IORESOURCE_MEM
-	},
-
-	[3] = {
-		.name = "qspi-int-mask",
-		.start = MCF5282_INTC0 + MCFINTC_IMRL,
-		.end = MCF5282_INTC0 + MCFINTC_IMRL,
-		.flags = IORESOURCE_MEM
-	}
-};
-
-static struct platform_device coldfire_spi = {
-	.name = "spi_coldfire",
-	.id = -1,
-	.resource = coldfire_spi_resources,
-	.num_resources = ARRAY_SIZE(coldfire_spi_resources),
-	.dev = {
-		.platform_data = &coldfire_master_info,
-	}
-};
-
-static void coldfire_qspi_cs_control(u8 cs, u8 command)
-{
-	u8 cs_bit = ((0x01 << cs) << 3) & SPI_CS_MASK;
-
-#if defined(CONFIG_WILDFIRE)
-	u8 cs_mask = ~(((0x01 << cs) << 3) & SPI_CS_MASK);
-#endif
-#if defined(CONFIG_WILDFIREMOD)
-	u8 cs_mask = (cs << 3) & SPI_CS_MASK;
-#endif
-
-	/*
-	 * Don't do anything if the chip select is not
-	 * one of the port qs pins.
-	 */
-	if (command & QSPI_CS_INIT) {
-#if defined(CONFIG_WILDFIRE)
-		MCF5282_GPIO_DDRQS  |= cs_bit;
-		MCF5282_GPIO_PQSPAR &= ~cs_bit;
-#endif
-
-#if defined(CONFIG_WILDFIREMOD)
-		MCF5282_GPIO_DDRQS  |= SPI_CS_MASK;
-		MCF5282_GPIO_PQSPAR &= ~SPI_CS_MASK;
-#endif
-	}
-
-	if (command & QSPI_CS_ASSERT) {
-		MCF5282_GPIO_PORTQS &= ~SPI_CS_MASK;
-		MCF5282_GPIO_PORTQS |= cs_mask;
-	} else if (command & QSPI_CS_DROP) {
-		MCF5282_GPIO_PORTQS |= SPI_CS_MASK;
-	}
-}
-
-static int __init spi_dev_init(void)
-{
-	int retval;
-
-	retval = platform_device_register(&coldfire_spi);
-	if (retval < 0)
-		return retval;
-
-	if (ARRAY_SIZE(spi_board_info))
-		retval = spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
-
-	return retval;
-}
