From: akpm@linux-foundation.org
Subject: + spi-davinci-adding-spi-driver-for-davinci.patch added to -mm tree
Date: Wed, 19 Aug 2009 12:02:15 -0700
Message-ID: <200908191902.n7JJ2Fau014953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbZHSTCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 15:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pablo.bitton@gmail.com, david-b@pacbell.net, rmk@arm.linux.org.uk, s-paulraj@ti.com


The patch titled
     spi: DaVinci: add SPI driver for DaVinci
has been added to the -mm tree.  Its filename is
     spi-davinci-adding-spi-driver-for-davinci.patch

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
Subject: spi: DaVinci: add SPI driver for DaVinci
From: Pablo Bitton <pablo.bitton@gmail.com>

Add support for SPI in DaVinci DM6446 (and try to keep support for
DM355/DM365/DM6467 and DA8xx).  Mostly the same as the patch by Sandeep
Paulraj.

This has been tested on the DM6446 by defining a spidev device and using a
scope (to check correctness) and a hardware loopback.

This was NOT tested on DM355, DM365 and DM6467 - in fact, it will probably
not work "as is" because its default mode is CS low-inactive (default mode
of SPI in kernel) - need to set CS_HIGH mode to work as in the previous
patch.

Changes from the patch by Sandeep Paulraj:

Bug fixes:
 * Additional word written with chip select up after each transfer.
   Particulary problematic with NO_CS mode where this word can't be
   distiguished from correct words. Problem was in davinci_chip_select.
 * setup() for one chip select may interfere with transfer for another
 * Small nitpicks (bits that can be changed only on VERSION_2)

Features added:
 * Support DM6446
 * Support CS_HIGH mode (using SPIDEF register). Note that CS low is default.

Other:
 * Less accesses to registers used.
 * Once-per-device configuration is done only in probe(), not each transfer.

Uglyness still there:
 * VERSION_X definitions for different SPI controllers - added VERSION_3
   for the dm6446, which is ugly.

NOTE:
This patch is based on following patches:

SPI: DaVinci: Adding SPI driver for DM3xx/DM6467/DA8xx

 The patch adds support for SPI in DaVinci
 DM355/DM365/DM6467 and DA8xx.

 This has been tested on the DM355, DM365 and DM6467 EVMs using
 the EEPROM connected to SPI0

 Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>

DaVinci: DM646x: Adding Support for SPI

 The patch does the following

 1) Adds a clock for SPI
 2) Defines resources specific to DM646x SOC

 Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>

Signed-off-by: Pablo Bitton <pablo.bitton@gmail.com>
Cc: Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/dm644x.c              |   50 +
 arch/arm/mach-davinci/dm646x.c              |   53 +
 arch/arm/mach-davinci/include/mach/dm644x.h |    2 
 arch/arm/mach-davinci/include/mach/dm646x.h |    2 
 arch/arm/mach-davinci/include/mach/spi.h    |   46 +
 drivers/spi/Kconfig                         |    7 
 drivers/spi/Makefile                        |    1 
 drivers/spi/davinci_spi.c                   |  776 ++++++++++++++++++
 drivers/spi/davinci_spi.h                   |  178 ++++
 9 files changed, 1114 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-davinci/dm644x.c~spi-davinci-adding-spi-driver-for-davinci arch/arm/mach-davinci/dm644x.c
--- a/arch/arm/mach-davinci/dm644x.c~spi-davinci-adding-spi-driver-for-davinci
+++ a/arch/arm/mach-davinci/dm644x.c
@@ -14,6 +14,7 @@
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/spi/spi.h>
 
 #include <asm/mach/map.h>
 
@@ -28,6 +29,7 @@
 #include <mach/serial.h>
 #include <mach/common.h>
 #include <mach/asp.h>
+#include <mach/spi.h>
 
 #include "clock.h"
 #include "mux.h"
@@ -306,7 +308,7 @@ struct davinci_clk dm644x_clks[] = {
 	CLK("palm_bk3710", NULL, &ide_clk),
 	CLK("davinci-asp", NULL, &asp_clk),
 	CLK("davinci_mmc.0", NULL, &mmcsd_clk),
-	CLK(NULL, "spi", &spi_clk),
+	CLK("spi_davinci.0", NULL, &spi_clk),
 	CLK(NULL, "gpio", &gpio_clk),
 	CLK(NULL, "usb", &usb_clk),
 	CLK(NULL, "vlynq", &vlynq_clk),
@@ -320,6 +322,52 @@ struct davinci_clk dm644x_clks[] = {
 	CLK(NULL, NULL, NULL),
 };
 
+
+static u64 dm644x_spi_dma_mask = DMA_BIT_MASK(32);
+
+static struct davinci_spi_platform_data dm644x_spi_pdata = {
+	.version 	= SPI_VERSION_3,
+	.num_chipselect = 2,
+	.clk_internal	= 1,
+	.cs_hold	= 0,
+	.intr_level	= 0,
+	.poll_mode	= 1,
+	.c2tdelay	= 8,
+	.t2cdelay	= 8,
+};
+
+static struct resource dm644x_spi_resources[] = {
+	{
+		.start = 0x01c66800,
+		.end   = 0x01c66fff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_SPINT0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device dm644x_spi_device = {
+	.name = "spi_davinci",
+	.id = 0,
+	.dev = {
+		.dma_mask = &dm644x_spi_dma_mask,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.platform_data = &dm644x_spi_pdata,
+	},
+	.num_resources = ARRAY_SIZE(dm644x_spi_resources),
+	.resource = dm644x_spi_resources,
+};
+
+void __init dm644x_init_spi(struct spi_board_info *info, unsigned len)
+{
+	spi_register_board_info(info, len);
+
+	platform_device_register(&dm644x_spi_device);
+}
+
+
 static struct emac_platform_data dm644x_emac_pdata = {
 	.ctrl_reg_offset	= DM644X_EMAC_CNTRL_OFFSET,
 	.ctrl_mod_reg_offset	= DM644X_EMAC_CNTRL_MOD_OFFSET,
diff -puN arch/arm/mach-davinci/dm646x.c~spi-davinci-adding-spi-driver-for-davinci arch/arm/mach-davinci/dm646x.c
--- a/arch/arm/mach-davinci/dm646x.c~spi-davinci-adding-spi-driver-for-davinci
+++ a/arch/arm/mach-davinci/dm646x.c
@@ -14,6 +14,7 @@
 #include <linux/serial_8250.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/spi/spi.h>
 
 #include <asm/mach/map.h>
 
@@ -28,6 +29,7 @@
 #include <mach/serial.h>
 #include <mach/common.h>
 #include <mach/asp.h>
+#include <mach/spi.h>
 
 #include "clock.h"
 #include "mux.h"
@@ -262,6 +264,12 @@ static struct clk emac_clk = {
 	.lpsc = DM646X_LPSC_EMAC,
 };
 
+static struct clk spi0_clk = {
+	.name = "spi0",
+	.parent = &pll1_sysclk3,
+	.lpsc = DM646X_LPSC_SPI,
+};
+
 static struct clk pwm0_clk = {
 	.name = "pwm0",
 	.parent = &pll1_sysclk3,
@@ -347,6 +355,7 @@ struct davinci_clk dm646x_clks[] = {
 	CLK("davinci-mcasp.1", NULL, &mcasp1_clk),
 	CLK(NULL, "aemif", &aemif_clk),
 	CLK("davinci_emac.1", NULL, &emac_clk),
+	CLK("spi_davinci.0", NULL, &spi0_clk),
 	CLK(NULL, "pwm0", &pwm0_clk),
 	CLK(NULL, "pwm1", &pwm1_clk),
 	CLK(NULL, "timer0", &timer0_clk),
@@ -358,6 +367,50 @@ struct davinci_clk dm646x_clks[] = {
 	CLK(NULL, NULL, NULL),
 };
 
+static u64 dm646x_spi0_dma_mask = DMA_BIT_MASK(32);
+
+static struct davinci_spi_platform_data dm646x_spi0_pdata = {
+	.version 	= SPI_VERSION_1,
+	.num_chipselect = 2,
+	.clk_internal	= 1,
+	.cs_hold	= 1,
+	.intr_level	= 0,
+	.poll_mode	= 1,
+	.c2tdelay	= 8,
+	.t2cdelay	= 8,
+};
+
+static struct resource dm646x_spi0_resources[] = {
+	{
+		.start = 0x01c66800,
+		.end   = 0x01c66fff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = IRQ_DM646X_SPINT0,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device dm646x_spi0_device = {
+	.name = "spi_davinci",
+	.id = 0,
+	.dev = {
+		.dma_mask = &dm646x_spi0_dma_mask,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
+		.platform_data = &dm646x_spi0_pdata,
+	},
+	.num_resources = ARRAY_SIZE(dm646x_spi0_resources),
+	.resource = dm646x_spi0_resources,
+};
+
+void __init dm646x_init_spi0(struct spi_board_info *info, unsigned len)
+{
+	spi_register_board_info(info, len);
+
+	platform_device_register(&dm646x_spi0_device);
+}
+
 static struct emac_platform_data dm646x_emac_pdata = {
 	.ctrl_reg_offset	= DM646X_EMAC_CNTRL_OFFSET,
 	.ctrl_mod_reg_offset	= DM646X_EMAC_CNTRL_MOD_OFFSET,
diff -puN arch/arm/mach-davinci/include/mach/dm644x.h~spi-davinci-adding-spi-driver-for-davinci arch/arm/mach-davinci/include/mach/dm644x.h
--- a/arch/arm/mach-davinci/include/mach/dm644x.h~spi-davinci-adding-spi-driver-for-davinci
+++ a/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -38,5 +38,7 @@
 void __init dm644x_init(void);
 void __init dm644x_init_asp(struct snd_platform_data *pdata);
 void dm644x_set_vpfe_config(struct vpfe_config *cfg);
+struct spi_board_info;
+void __init dm644x_init_spi(struct spi_board_info *info, unsigned len);
 
 #endif /* __ASM_ARCH_DM644X_H */
diff -puN arch/arm/mach-davinci/include/mach/dm646x.h~spi-davinci-adding-spi-driver-for-davinci arch/arm/mach-davinci/include/mach/dm646x.h
--- a/arch/arm/mach-davinci/include/mach/dm646x.h~spi-davinci-adding-spi-driver-for-davinci
+++ a/arch/arm/mach-davinci/include/mach/dm646x.h
@@ -28,6 +28,8 @@ void __init dm646x_init(void);
 void __init dm646x_init_ide(void);
 void __init dm646x_init_mcasp0(struct snd_platform_data *pdata);
 void __init dm646x_init_mcasp1(struct snd_platform_data *pdata);
+struct spi_board_info;
+void dm646x_init_spi0(struct spi_board_info *info, unsigned len);
 
 void dm646x_video_init(void);
 
diff -puN /dev/null arch/arm/mach-davinci/include/mach/spi.h
--- /dev/null
+++ a/arch/arm/mach-davinci/include/mach/spi.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright 2009 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __ARCH_ARM_DAVINCI_SPI_H
+#define __ARCH_ARM_DAVINCI_SPI_H
+
+#define SPI_INTERN_CS	0xFF
+
+enum {
+	SPI_VERSION_1 = 0, /* For DM355/DM365/DM6467*/
+	SPI_VERSION_2, /* For DA8xx */
+	SPI_VERSION_3, /* For DM6446 */
+};
+
+struct davinci_spi_platform_data {
+	u8	version;
+	u16	num_chipselect;
+	u32	wdelay;
+	u32	odd_parity;
+	u32	parity_enable;
+	u32	wait_enable;
+	u32	timer_disable;
+	u32	clk_internal;
+	u32	cs_hold;
+	u32	intr_level;
+	u32	poll_mode;
+	u8	c2tdelay;
+	u8	t2cdelay;
+};
+
+#endif	/* __ARCH_ARM_DAVINCI_SPI_H */
diff -puN drivers/spi/Kconfig~spi-davinci-adding-spi-driver-for-davinci drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-davinci-adding-spi-driver-for-davinci
+++ a/drivers/spi/Kconfig
@@ -77,6 +77,13 @@ config SPI_AU1550
 	  This driver can also be built as a module.  If so, the module
 	  will be called au1550_spi.
 
+config SPI_DAVINCI
+	tristate "SPI controller driver for DaVinci/DA8xx SoC's"
+	depends on SPI_MASTER && ARCH_DAVINCI
+	select SPI_BITBANG
+	help
+	  SPI master controller for DaVinci and DA8xx SPI modules.
+
 config SPI_BITBANG
 	tristate "Utilities for Bitbanging SPI masters"
 	help
diff -puN drivers/spi/Makefile~spi-davinci-adding-spi-driver-for-davinci drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-davinci-adding-spi-driver-for-davinci
+++ a/drivers/spi/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24x
 obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
+obj-$(CONFIG_SPI_DAVINCI)		+= davinci_spi.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff -puN /dev/null drivers/spi/davinci_spi.c
--- /dev/null
+++ a/drivers/spi/davinci_spi.c
@@ -0,0 +1,776 @@
+/*
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+#include <mach/spi.h>
+
+#include "davinci_spi.h"
+
+
+static void davinci_spi_rx_buf_u8(u32 data, struct davinci_spi *davinci_spi)
+{
+	u8 *rx = davinci_spi->rx;
+
+	*rx++ = (u8)data;
+	davinci_spi->rx = rx;
+}
+
+static void davinci_spi_rx_buf_u16(u32 data, struct davinci_spi *davinci_spi)
+{
+	u16 *rx = davinci_spi->rx;
+
+	*rx++ = (u16)data;
+	davinci_spi->rx = rx;
+}
+
+static u32 davinci_spi_tx_buf_u8(struct davinci_spi *davinci_spi)
+{
+	u32 data;
+	const u8 *tx = davinci_spi->tx;
+
+	data = *tx++;
+	davinci_spi->tx = tx;
+	return data;
+}
+
+static u32 davinci_spi_tx_buf_u16(struct davinci_spi *davinci_spi)
+{
+	u32 data;
+	const u16 *tx = davinci_spi->tx;
+
+	data = *tx++;
+	davinci_spi->tx = tx;
+	return data;
+}
+
+static inline void set_io_bits(void __iomem *addr, u32 bits)
+{
+	u32 v = ioread32(addr);
+
+	v |= bits;
+	iowrite32(v, addr);
+}
+
+static inline void clear_io_bits(void __iomem *addr, u32 bits)
+{
+	u32 v = ioread32(addr);
+
+	v &= ~bits;
+	iowrite32(v, addr);
+}
+
+static inline void set_fmt_bits(void __iomem *addr, u32 bits, int cs_num)
+{
+	set_io_bits(addr + SPIFMT0 + (0x4 * cs_num), bits);
+}
+
+static inline void clear_fmt_bits(void __iomem *addr, u32 bits, int cs_num)
+{
+	clear_io_bits(addr + SPIFMT0 + (0x4 * cs_num), bits);
+}
+
+/*
+ * Interface to control the chip select signal
+ */
+static void davinci_spi_chipselect(struct spi_device *spi, int value)
+{
+	struct davinci_spi *davinci_spi;
+	struct davinci_spi_platform_data *pdata;
+
+	davinci_spi = spi_master_get_devdata(spi->master);
+	pdata = davinci_spi->pdata;
+
+	/* Called by spi_bitbang with:
+	 * . CS_ACTIVE in start of transfer
+	 * . CS_INACTIVE in end of transfer
+	 * . CS_INACTIVE between chip select changes during a transfer
+	 * to set up default clock polarity, and activate chip
+	 * in davinci, CS lines are (de)activated per transfer by the CSNR
+	 * field in SPIDAT1 and clock polarity is stored in the SPIFMTx per
+	 * chip select, so nothing needs to be done in this function.
+	*/
+
+}
+
+/*
+ * davinci_spi_setup_transfer - This functions will determine transfer method
+ * @spi: spi device on which data transfer to be done
+ * @t: spi transfer in which transfer info is filled
+ *
+ * This function determines data transfer method (8/16/32 bit transfer).
+ * It will also set the SPI Clock Control register according to
+ * SPI slave device freq.
+ */
+static int davinci_spi_setup_transfer(struct spi_device *spi,
+		struct spi_transfer *t)
+{
+
+	struct davinci_spi *davinci_spi;
+	struct davinci_spi_platform_data *pdata;
+	u8 bits_per_word = 0;
+	u32 hz = 0, prescale;
+
+	davinci_spi = spi_master_get_devdata(spi->master);
+	pdata = davinci_spi->pdata;
+
+	if (t) {
+		bits_per_word = t->bits_per_word;
+		hz = t->speed_hz;
+	}
+
+	/* if bits_per_word is not set then set it default */
+	if (!bits_per_word)
+		bits_per_word = spi->bits_per_word;
+
+	/*
+	 * Assign function pointer to appropriate transfer method
+	 * 8bit, 16bit or 32bit transfer
+	 */
+	if (bits_per_word <= 8 && bits_per_word >= 2) {
+		davinci_spi->get_rx = davinci_spi_rx_buf_u8;
+		davinci_spi->get_tx = davinci_spi_tx_buf_u8;
+		davinci_spi->slave[spi->chip_select].bytes_per_word = 1;
+	} else if (bits_per_word <= 16 && bits_per_word >= 2) {
+		davinci_spi->get_rx = davinci_spi_rx_buf_u16;
+		davinci_spi->get_tx = davinci_spi_tx_buf_u16;
+		davinci_spi->slave[spi->chip_select].bytes_per_word = 2;
+	} else
+		return -EINVAL;
+
+	if (!hz)
+		hz = spi->max_speed_hz;
+
+	clear_fmt_bits(davinci_spi->base, SPIFMT_CHARLEN_MASK,
+			spi->chip_select);
+	set_fmt_bits(davinci_spi->base, bits_per_word & 0x1f,
+			spi->chip_select);
+
+	prescale = ((clk_get_rate(davinci_spi->clk) / hz) - 1) & 0xff;
+
+	clear_fmt_bits(davinci_spi->base, 0x0000ff00, spi->chip_select);
+	set_fmt_bits(davinci_spi->base, prescale << 8, spi->chip_select);
+
+	return 0;
+}
+
+/*
+ * davinci_spi_setup - This functions will set default transfer method
+ * @spi: spi device on which data transfer to be done
+ *
+ * This functions sets the default transfer method.
+ */
+
+static int davinci_spi_setup(struct spi_device *spi)
+{
+	int retval;
+	int op_mode = 0;
+	struct davinci_spi *davinci_spi;
+
+	davinci_spi = spi_master_get_devdata(spi->master);
+
+	/*
+	 * Set up device-specific SPI configuration parameters.
+	 * Most of these would normally be handled in spi_setup(),
+	 * updating the per-chipselect FMT registers, but some of
+	 * them use global controls like SPI_LOOP and SPI_READY.
+	 */
+
+	if (spi->mode & SPI_LSB_FIRST)
+		set_fmt_bits(davinci_spi->base, SPIFMT_SHIFTDIR_MASK,
+				spi->chip_select);
+	else
+		clear_fmt_bits(davinci_spi->base, SPIFMT_SHIFTDIR_MASK,
+				spi->chip_select);
+
+	if (spi->mode & SPI_CPOL)
+		set_fmt_bits(davinci_spi->base, SPIFMT_POLARITY_MASK,
+				spi->chip_select);
+	else
+		clear_fmt_bits(davinci_spi->base, SPIFMT_POLARITY_MASK,
+				spi->chip_select);
+
+	if (!(spi->mode & SPI_CPHA))
+		set_fmt_bits(davinci_spi->base, SPIFMT_PHASE_MASK,
+				spi->chip_select);
+	else
+		clear_fmt_bits(davinci_spi->base, SPIFMT_PHASE_MASK,
+				spi->chip_select);
+
+	if (davinci_spi->version == SPI_VERSION_2) {
+		clear_fmt_bits(davinci_spi->base, SPIFMT_WDELAY_MASK,
+				spi->chip_select);
+		set_fmt_bits(davinci_spi->base,
+				(davinci_spi->pdata->wdelay
+						<< SPIFMT_WDELAY_SHIFT)
+					& SPIFMT_WDELAY_MASK,
+				spi->chip_select);
+
+		if (davinci_spi->pdata->odd_parity)
+			set_fmt_bits(davinci_spi->base,
+					SPIFMT_ODD_PARITY_MASK,
+					spi->chip_select);
+		else
+			clear_fmt_bits(davinci_spi->base,
+					SPIFMT_ODD_PARITY_MASK,
+					spi->chip_select);
+
+		if (davinci_spi->pdata->parity_enable)
+			set_fmt_bits(davinci_spi->base,
+					SPIFMT_PARITYENA_MASK,
+					spi->chip_select);
+		else
+			clear_fmt_bits(davinci_spi->base,
+					SPIFMT_PARITYENA_MASK,
+					spi->chip_select);
+
+		if (davinci_spi->pdata->wait_enable)
+			set_fmt_bits(davinci_spi->base,
+					SPIFMT_WAITENA_MASK,
+					spi->chip_select);
+		else
+			clear_fmt_bits(davinci_spi->base,
+					SPIFMT_WAITENA_MASK,
+					spi->chip_select);
+
+		if (davinci_spi->pdata->timer_disable)
+			set_fmt_bits(davinci_spi->base,
+					SPIFMT_DISTIMER_MASK,
+					spi->chip_select);
+		else
+			clear_fmt_bits(davinci_spi->base,
+					SPIFMT_DISTIMER_MASK,
+					spi->chip_select);
+	}
+
+	if (spi->mode & SPI_CS_HIGH)
+		set_io_bits(davinci_spi->base + SPIDEF, 1<<spi->chip_select);
+	else
+		clear_io_bits(davinci_spi->base + SPIDEF, 1<<spi->chip_select);
+
+	/*
+	 * Version 1 hardware supports two basic SPI modes:
+	 *  - Standard SPI mode uses 4 pins, with chipselect
+	 *  - 3 pin SPI is a 4 pin variant without CS (SPI_NO_CS)
+	 *	(distinct from SPI_3WIRE, with just one data wire;
+	 *	or similar variants without MOSI or without MISO)
+	 *
+	 * Version 2 hardware supports an optional handshaking signal,
+	 * so it can support two more modes:
+	 *  - 5 pin SPI variant is standard SPI plus SPI_READY
+	 *  - 4 pin with enable is (SPI_READY | SPI_NO_CS)
+	 */
+
+	/* Read op mode - so don't touch bits controlling other chip selects */
+	op_mode = ioread32(davinci_spi->base + SPIPC0);
+
+	op_mode |= SPIPC0_DIFUN_MASK
+		| SPIPC0_DOFUN_MASK
+		| SPIPC0_CLKFUN_MASK;
+
+	if (!(spi->mode & SPI_NO_CS)) {
+		/* enable chip select line for given chip select */
+		op_mode |= 1 << spi->chip_select;
+	} else {
+		/* disable chip select line for given chip select */
+		op_mode &= ~(1L << spi->chip_select);
+	}
+
+	/* Note that on version 1 this field must be written with zeros */
+	if (davinci_spi->version == SPI_VERSION_2 && spi->mode & SPI_READY)
+		op_mode |= SPIPC0_SPIENA_MASK;
+
+	iowrite32(op_mode, davinci_spi->base + SPIPC0);
+
+	if (spi->mode & SPI_LOOP)
+		set_io_bits(davinci_spi->base + SPIGCR1,
+				SPIGCR1_LOOPBACK_MASK);
+	else
+		clear_io_bits(davinci_spi->base + SPIGCR1,
+				SPIGCR1_LOOPBACK_MASK);
+
+	/* if bits per word length is zero then set it default 8 */
+	if (!spi->bits_per_word)
+		spi->bits_per_word = 8;
+
+	/*
+	 * SPI in DaVinci and DA8xx operate between
+	 * 600 KHz and 50 MHz
+	 */
+	if (spi->max_speed_hz < 600000 || spi->max_speed_hz > 50000000)
+		return -EINVAL;
+
+	retval = davinci_spi_setup_transfer(spi, NULL);
+
+	return retval;
+}
+
+static int davinci_spi_check_error(struct davinci_spi *davinci_spi,
+				   int int_status)
+{
+	struct device *sdev = davinci_spi->bitbang.master->dev.parent;
+	int supported_flags = 0;
+
+	switch (davinci_spi->version) {
+	case SPI_VERSION_1:
+		supported_flags = SPIFLG_VERSION_1; break;
+	case SPI_VERSION_2:
+		supported_flags = SPIFLG_VERSION_2; break;
+	case SPI_VERSION_3:
+		supported_flags = SPIFLG_VERSION_3; break;
+	}
+
+	if (int_status & supported_flags & SPIFLG_TIMEOUT_MASK) {
+		dev_dbg(sdev, "SPI Time-out Error\n");
+		return -ETIMEDOUT;
+	}
+
+	if (int_status & supported_flags & SPIFLG_DESYNC_MASK) {
+		dev_dbg(sdev, "SPI Desynchronization Error\n");
+		return -EIO;
+	}
+
+	if (int_status & supported_flags & SPIFLG_BITERR_MASK) {
+		dev_dbg(sdev, "SPI Bit error\n");
+		return -EIO;
+	}
+
+	if (int_status & supported_flags & SPIFLG_DLEN_ERR_MASK) {
+		dev_dbg(sdev, "SPI Data Length Error\n");
+		return -EIO;
+	}
+
+	if (int_status & supported_flags & SPIFLG_PARERR_MASK) {
+		dev_dbg(sdev, "SPI Parity Error\n");
+		return -EIO;
+	}
+
+	if (int_status & supported_flags & SPIFLG_TX_INTR_MASK) {
+		dev_dbg(sdev, "SPI TX intr bit set\n");
+		return -EIO;
+	}
+
+	if (int_status & supported_flags & SPIFLG_BUF_INIT_ACTIVE_MASK) {
+		dev_dbg(sdev, "SPI Buffer Init Active\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/*
+ * davinci_spi_bufs - functions which will handle transfer data
+ * @spi: spi device on which data transfer to be done
+ * @t: spi transfer in which transfer info is filled
+ *
+ * This function will put data to be transferred into data register
+ * of SPI controller and then wait untill the completion will be marked
+ * by the IRQ Handler.
+ */
+static int davinci_spi_bufs_pio(struct spi_device *spi, struct spi_transfer *t)
+{
+	/* Note this function was called after chipselect(CS_ACTIVE) or after
+	 * another transfer */
+
+	struct davinci_spi *davinci_spi;
+	int int_status, count, ret;
+	u8 conv, tmp;
+	u32 tx_data, data1_reg_val;
+	u32 buf_val, flg_val;
+	struct davinci_spi_platform_data *pdata;
+
+	davinci_spi = spi_master_get_devdata(spi->master);
+	pdata = davinci_spi->pdata;
+
+	davinci_spi->tx = t->tx_buf;
+	davinci_spi->rx = t->rx_buf;
+
+	/* convert len to words bbased on bits_per_word */
+	conv = davinci_spi->slave[spi->chip_select].bytes_per_word;
+	davinci_spi->count = t->len / conv;
+
+	INIT_COMPLETION(davinci_spi->done);
+
+	/* Enable SPI */
+	set_io_bits(davinci_spi->base + SPIGCR1, SPIGCR1_SPIENA_MASK);
+
+	count = davinci_spi->count;
+	data1_reg_val = pdata->cs_hold << SPIDAT1_CSHOLD_SHIFT;
+
+	/* Set current chip select.  CSNR's value is tied to both chip selects
+	 * default value (as set in SPIDEF) - set per chip with CS_HIGH mode.
+	 */
+	tmp = ioread32(davinci_spi->base + SPIDEF);
+	tmp = (1<<spi->chip_select) ^ (tmp & 3);
+	data1_reg_val |= tmp << SPIDAT1_CSNR_SHIFT;
+
+	/* Set current data format (one per chip select) */
+	data1_reg_val |= spi->chip_select << SPIDAT1_DFSEL_SHIFT;
+
+	/* Wait for spi to be ready (wait until no data is received) */
+	while ((ioread32(davinci_spi->base + SPIBUF) &
+		SPIBUF_RXEMPTY_MASK) == 0)
+		cpu_relax();
+
+	/* Determine the command to execute READ or WRITE */
+	if (t->tx_buf) {
+		clear_io_bits(davinci_spi->base + SPIINT, SPIINT_MASKALL);
+
+		while (1) {
+			tx_data = davinci_spi->get_tx(davinci_spi);
+
+			data1_reg_val &= ~(0xFFFF);
+			data1_reg_val |= (0xFFFF & tx_data);
+
+			buf_val = ioread32(davinci_spi->base + SPIBUF);
+			if ((buf_val & SPIBUF_TXFULL_MASK) == 0) {
+				iowrite32(data1_reg_val,
+					  davinci_spi->base + SPIDAT1);
+				count--;
+			}
+
+			while ((buf_val = ioread32(davinci_spi->base + SPIBUF))
+			       & SPIBUF_RXEMPTY_MASK)
+				cpu_relax();
+
+			/* getting the returned byte */
+			if (t->rx_buf)
+				davinci_spi->get_rx(buf_val, davinci_spi);
+
+			if (count <= 0)
+				break;
+		}
+	} else {
+		if (pdata->poll_mode) {
+			while (1) {
+				/* keeps the serial clock going (write zeros) */
+				if ((ioread32(davinci_spi->base + SPIBUF)
+						& SPIBUF_TXFULL_MASK) == 0)
+					iowrite32(data1_reg_val,
+						davinci_spi->base + SPIDAT1);
+
+				while ((buf_val = ioread32(davinci_spi->base +
+					SPIBUF)) & SPIBUF_RXEMPTY_MASK)
+					cpu_relax();
+
+				flg_val = ioread32(davinci_spi->base + SPIFLG);
+
+				davinci_spi->get_rx(buf_val, davinci_spi);
+
+				count--;
+				if (count <= 0)
+					break;
+			}
+		} else {	/* Receive in Interrupt mode */
+			int i;
+
+			for (i = 0; i < davinci_spi->count; i++) {
+				set_io_bits(davinci_spi->base + SPIINT,
+						SPIINT_BITERR_INTR
+						| SPIINT_OVRRUN_INTR
+						| SPIINT_RX_INTR);
+
+				iowrite32(data1_reg_val,
+						davinci_spi->base + SPIDAT1);
+
+				while (ioread32(davinci_spi->base + SPIINT) &
+						SPIINT_RX_INTR)
+					cpu_relax();
+			}
+			iowrite32((data1_reg_val & 0x0ffcffff),
+					davinci_spi->base + SPIDAT1);
+		}
+	}
+
+	/*
+	 * Check for bit error, desync error,parity error,timeout error and
+	 * receive overflow errors
+	 */
+	int_status = ioread32(davinci_spi->base + SPIFLG);
+
+	ret = davinci_spi_check_error(davinci_spi, int_status);
+	if (ret != 0)
+		return ret;
+
+	/* SPI Framework maintains the count only in bytes so convert back */
+	davinci_spi->count *= conv;
+
+	return t->len;
+}
+
+/*
+ * davinci_spi_irq - probe function for SPI Master Controller
+ * @irq: IRQ number for this SPI Master
+ * @context_data: structure for SPI Master controller davinci_spi
+ *
+ * ISR will determine that interrupt arrives either for READ or WRITE command.
+ * According to command it will do the appropriate action. It will check
+ * transfer length and if it is not zero then dispatch transfer command again.
+ * If transfer length is zero then it will indicate the COMPLETION so that
+ * davinci_spi_bufs function can go ahead.
+ */
+static irqreturn_t davinci_spi_irq(s32 irq, void *context_data)
+{
+	struct davinci_spi *davinci_spi = context_data;
+	u32 int_status, rx_data = 0;
+	irqreturn_t ret = IRQ_NONE;
+
+	int_status = ioread32(davinci_spi->base + SPIFLG);
+	while ((int_status & SPIFLG_MASK) != 0) {
+		ret = IRQ_HANDLED;
+
+		if (likely(int_status & SPIFLG_RX_INTR_MASK)) {
+			rx_data = ioread32(davinci_spi->base + SPIBUF);
+			davinci_spi->get_rx(rx_data, davinci_spi);
+
+			/* Disable Receive Interrupt */
+			iowrite32(~SPIINT_RX_INTR,
+					davinci_spi->base + SPIINT);
+		} else
+			(void)davinci_spi_check_error(davinci_spi, int_status);
+
+		int_status = ioread32(davinci_spi->base + SPIFLG);
+	}
+
+	return ret;
+}
+
+/*
+ * davinci_spi_probe - probe function for SPI Master Controller
+ * @pdev: platform_device structure which contains plateform specific data
+ *
+ * According to Linux Device Model this function will be invoked by Linux
+ * with plateform_device struct which contains the device specific info.
+ * This function will map the SPI controller's memory, register IRQ,
+ * Reset SPI controller and setting its registers to default value.
+ * It will invoke spi_bitbang_start to create work queue so that client driver
+ * can register transfer method to work queue.
+ */
+static int davinci_spi_probe(struct platform_device *pdev)
+{
+	struct spi_master *master;
+	struct davinci_spi *davinci_spi;
+	struct davinci_spi_platform_data *pdata;
+	struct resource *r, *mem;
+	int ret = 0;
+
+	pdata = pdev->dev.platform_data;
+	if (pdata == NULL) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	master = spi_alloc_master(&pdev->dev, sizeof(struct davinci_spi));
+	if (master == NULL) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	dev_set_drvdata(&pdev->dev, master);
+
+	davinci_spi = spi_master_get_devdata(master);
+	if (davinci_spi == NULL) {
+		ret = -ENOENT;
+		goto free_master;
+	}
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		ret = -ENOENT;
+		goto free_master;
+	}
+
+	davinci_spi->pbase = r->start;
+	davinci_spi->region_size = resource_size(r);
+	davinci_spi->pdata = pdata;
+
+	mem = request_mem_region(r->start, davinci_spi->region_size,
+					pdev->name);
+	if (mem == NULL) {
+		ret = -EBUSY;
+		goto free_master;
+	}
+
+	davinci_spi->base = (struct davinci_spi_reg __iomem *)
+			ioremap(r->start, davinci_spi->region_size);
+	if (davinci_spi->base == NULL) {
+		ret = -ENOMEM;
+		goto release_region;
+	}
+
+	davinci_spi->irq = platform_get_irq(pdev, 0);
+	if (davinci_spi->irq <= 0) {
+		ret = -EINVAL;
+		goto unmap_io;
+	}
+
+	ret = request_irq(davinci_spi->irq, davinci_spi_irq, IRQF_DISABLED,
+			  dev_name(&pdev->dev), davinci_spi);
+	if (ret != 0) {
+		ret = -EAGAIN;
+		goto unmap_io;
+	}
+
+	davinci_spi->bitbang.master = spi_master_get(master);
+	if (davinci_spi->bitbang.master == NULL) {
+		ret = -ENODEV;
+		goto err1;
+	}
+
+	davinci_spi->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(davinci_spi->clk)) {
+		ret = -ENODEV;
+		goto put_master;
+	}
+	clk_enable(davinci_spi->clk);
+
+
+	master->bus_num = pdev->id;
+	master->num_chipselect = pdata->num_chipselect;
+	master->setup = davinci_spi_setup;
+
+	davinci_spi->bitbang.chipselect = davinci_spi_chipselect;
+	davinci_spi->bitbang.setup_transfer = davinci_spi_setup_transfer;
+	davinci_spi->bitbang.txrx_bufs = davinci_spi_bufs_pio;
+
+	davinci_spi->bitbang.flags =
+		SPI_NO_CS | SPI_LSB_FIRST | SPI_LOOP | SPI_CS_HIGH;
+
+	if (davinci_spi->version == SPI_VERSION_2)
+		davinci_spi->bitbang.flags |= SPI_READY;
+
+	davinci_spi->version = pdata->version;
+	davinci_spi->get_rx = davinci_spi_rx_buf_u8;
+	davinci_spi->get_tx = davinci_spi_tx_buf_u8;
+
+	init_completion(&davinci_spi->done);
+
+	/* Reset In/OUT SPI modle */
+	iowrite32(0, davinci_spi->base + SPIGCR0);
+	udelay(100);
+	iowrite32(1, davinci_spi->base + SPIGCR0);
+
+	/* Set global SPI parameters */
+
+	/* Clock internal */
+	if (davinci_spi->pdata->clk_internal)
+		set_io_bits(davinci_spi->base + SPIGCR1,
+				SPIGCR1_CLKMOD_MASK);
+	else
+		clear_io_bits(davinci_spi->base + SPIGCR1,
+				SPIGCR1_CLKMOD_MASK);
+
+	/* master mode default */
+	set_io_bits(davinci_spi->base + SPIGCR1, SPIGCR1_MASTER_MASK);
+
+	if (davinci_spi->pdata->intr_level)
+		iowrite32(SPI_INTLVL_1, davinci_spi->base + SPILVL);
+	else
+		iowrite32(SPI_INTLVL_0, davinci_spi->base + SPILVL);
+
+	/* c2t and t2c delays */
+	iowrite32(0 | (pdata->c2tdelay << SPI_C2TDELAY_SHIFT) |
+		  (pdata->t2cdelay << SPI_T2CDELAY_SHIFT),
+		  davinci_spi->base + SPIDELAY);
+
+
+	ret = spi_bitbang_start(&davinci_spi->bitbang);
+	if (ret != 0)
+		goto free_clk;
+
+	dev_info(&pdev->dev, "Controller at 0x%p (irq = %d) \n",
+		davinci_spi->base, davinci_spi->irq);
+
+	return ret;
+
+free_clk:
+	clk_disable(davinci_spi->clk);
+	clk_put(davinci_spi->clk);
+put_master:
+	spi_master_put(master);
+err1:
+	free_irq(davinci_spi->irq, davinci_spi);
+unmap_io:
+	iounmap(davinci_spi->base);
+release_region:
+	release_mem_region(davinci_spi->pbase, davinci_spi->region_size);
+free_master:
+	kfree(master);
+err:
+	return ret;
+}
+
+/*
+ * davinci_spi_remove - remove function for SPI Master Controller
+ * @pdev: platform_device structure which contains plateform specific data
+ *
+ * This function will do the reverse action of davinci_spi_probe function
+ * It will free the IRQ and SPI controller's memory region.
+ * It will also call spi_bitbang_stop to destroy the work queue which was
+ * created by spi_bitbang_start.
+ */
+static int __exit davinci_spi_remove(struct platform_device *pdev)
+{
+	struct davinci_spi *davinci_spi;
+	struct spi_master *master;
+
+	master = dev_get_drvdata(&pdev->dev);
+	davinci_spi = spi_master_get_devdata(master);
+
+	spi_bitbang_stop(&davinci_spi->bitbang);
+
+	clk_disable(davinci_spi->clk);
+	clk_put(davinci_spi->clk);
+	spi_master_put(master);
+	free_irq(davinci_spi->irq, davinci_spi);
+	iounmap(davinci_spi->base);
+	release_mem_region(davinci_spi->pbase, davinci_spi->region_size);
+
+	return 0;
+}
+
+static struct platform_driver davinci_spi_driver = {
+	.driver.name = "spi_davinci",
+	.remove = __exit_p(davinci_spi_remove),
+};
+
+static int __init davinci_spi_init(void)
+{
+	return platform_driver_probe(&davinci_spi_driver, davinci_spi_probe);
+}
+
+static void __exit davinci_spi_exit(void)
+{
+	platform_driver_unregister(&davinci_spi_driver);
+}
+
+module_init(davinci_spi_init);
+module_exit(davinci_spi_exit);
+
+MODULE_DESCRIPTION("TI DaVinci SPI Master Controller Driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/spi/davinci_spi.h
--- /dev/null
+++ a/drivers/spi/davinci_spi.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (C) 2009 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __DAVINCI_SPI_H
+#define __DAVINCI_SPI_H
+
+#define SPI_MAX_CHIPSELECT	2
+
+#define CS_DEFAULT	0xFF
+#define SCS0_SELECT	0x01
+#define SCS1_SELECT	0x02
+#define SCS2_SELECT	0x04
+#define SCS3_SELECT	0x08
+#define SCS4_SELECT	0x10
+#define SCS5_SELECT	0x20
+#define SCS6_SELECT	0x40
+#define SCS7_SELECT	0x80
+
+#define SPIFMT_PHASE_MASK	BIT(16)
+#define SPIFMT_POLARITY_MASK	BIT(17)
+#define SPIFMT_DISTIMER_MASK	BIT(18)
+#define SPIFMT_SHIFTDIR_MASK	BIT(20)
+#define SPIFMT_WAITENA_MASK	BIT(21)
+#define SPIFMT_PARITYENA_MASK	BIT(22)
+#define SPIFMT_ODD_PARITY_MASK	BIT(23)
+#define SPIFMT_WDELAY_MASK	0x3f000000u
+#define SPIFMT_WDELAY_SHIFT	24
+#define SPIFMT_CHARLEN_MASK	0x0000001Fu
+
+/* SPIGCR1 */
+#define SPIGCR1_SPIENA_MASK	0x01000000u
+#define SPIGCR1_CLKMOD_MASK	BIT(1)
+#define SPIGCR1_MASTER_MASK     BIT(0)
+#define SPIGCR1_LOOPBACK_MASK	BIT(16)
+
+/* SPIPC0 */
+#define SPIPC0_DIFUN_MASK	BIT(11)		/* MISO */
+#define SPIPC0_DOFUN_MASK	BIT(10)		/* MOSI */
+#define SPIPC0_CLKFUN_MASK	BIT(9)		/* CLK */
+#define SPIPC0_SPIENA_MASK	BIT(8)		/* nREADY */
+#define SPIPC0_EN1FUN_MASK	BIT(1)
+#define SPIPC0_EN0FUN_MASK	BIT(0)
+
+#define SPIINT_MASKALL		0x0101035F
+#define SPI_INTLVL_1		0x000001FFu
+#define SPI_INTLVL_0		0x00000000u
+
+/* SPIDAT1 */
+#define SPIDAT1_CSHOLD_MASK	BIT(28)
+#define SPIDAT1_CSHOLD_SHIFT	28
+#define SPIDAT1_CSNR_MASK	(BIT(17 | BIT(16))
+#define SPIDAT1_CSNR_SHIFT	16
+#define SPIDAT1_DFSEL_MASK	(BIT(24 | BIT(25))
+#define SPIDAT1_DFSEL_SHIFT	24
+
+/* SPIBUF */
+#define SPIBUF_TXFULL_MASK	BIT(29)
+#define SPIBUF_RXEMPTY_MASK	BIT(31)
+
+/* Error Masks */
+#define SPIFLG_DLEN_ERR_MASK		BIT(0)
+#define SPIFLG_TIMEOUT_MASK		BIT(1)
+#define SPIFLG_PARERR_MASK		BIT(2)
+#define SPIFLG_DESYNC_MASK		BIT(3)
+#define SPIFLG_BITERR_MASK		BIT(4)
+#define SPIFLG_OVRRUN_MASK		BIT(6)
+#define SPIFLG_RX_INTR_MASK		BIT(8)
+#define SPIFLG_TX_INTR_MASK		BIT(9)
+#define SPIFLG_BUF_INIT_ACTIVE_MASK	BIT(24)
+#define SPIFLG_MASK			(SPIFLG_DLEN_ERR_MASK \
+				| SPIFLG_TIMEOUT_MASK | SPIFLG_PARERR_MASK \
+				| SPIFLG_DESYNC_MASK | SPIFLG_BITERR_MASK \
+				| SPIFLG_OVRRUN_MASK | SPIFLG_RX_INTR_MASK \
+				| SPIFLG_TX_INTR_MASK \
+				| SPIFLG_BUF_INIT_ACTIVE_MASK)
+
+
+#define SPIFLG_VERSION_1   (SPIFLG_TIMEOUT_MASK | SPIFLG_DESYNC_MASK	\
+			    | SPIFLG_BITERR_MASK | SPIFLG_RX_INTR_MASK)
+
+#define SPIFLG_VERSION_2   (SPIFLG_DLEN_ERR_MASK | SPIFLG_TIMEOUT_MASK	\
+			    | SPIFLG_PARERR_MASK | SPIFLG_DESYNC_MASK	\
+			    | SPIFLG_BITERR_MASK | SPIFLG_DESYNC_MASK	\
+			    | SPIFLG_RX_INTR_MASK | SPIFLG_TX_INTR_MASK	\
+			    | SPIFLG_BUF_INIT_ACTIVE_MASK)
+
+#define SPIFLG_VERSION_3   (SPIFLG_BITERR_MASK | SPIFLG_OVRRUN_MASK	\
+			    | SPIFLG_RX_INTR_MASK)
+
+
+#define SPIINT_DLEN_ERR_INTR	BIT(0)
+#define SPIINT_TIMEOUT_INTR	BIT(1)
+#define SPIINT_PARERR_INTR	BIT(2)
+#define SPIINT_DESYNC_INTR	BIT(3)
+#define SPIINT_BITERR_INTR	BIT(4)
+#define SPIINT_OVRRUN_INTR	BIT(6)
+#define SPIINT_RX_INTR		BIT(8)
+#define SPIINT_TX_INTR		BIT(9)
+#define SPIINT_DMA_REQ_EN	BIT(16)
+#define SPIINT_ENABLE_HIGHZ	BIT(24)
+
+#define SPI_T2CDELAY_SHIFT	16
+#define SPI_C2TDELAY_SHIFT	24
+
+/* SPI Controller registers */
+#define SPIGCR0		0x00
+#define SPIGCR1		0x04
+#define SPIINT		0x08
+#define SPILVL		0x0c
+#define SPIFLG		0x10
+#define SPIPC0		0x14
+#define SPIPC1		0x18
+#define SPIPC2		0x1c
+#define SPIPC3		0x20
+#define SPIPC4		0x24
+#define SPIPC5		0x28
+#define SPIPC6		0x2c
+#define SPIPC7		0x30
+#define SPIPC8		0x34
+#define SPIDAT0		0x38
+#define SPIDAT1		0x3c
+#define SPIBUF		0x40
+#define SPIEMU		0x44
+#define SPIDELAY	0x48
+#define SPIDEF		0x4c
+#define SPIFMT0		0x50
+#define SPIFMT1		0x54
+#define SPIFMT2		0x58
+#define SPIFMT3		0x5c
+#define TGINTVEC0	0x60
+#define TGINTVEC1	0x64
+
+struct davinci_spi_slave {
+	u32	cmd_to_write;
+	u32	clk_ctrl_to_write;
+	u32	bytes_per_word;
+	u8	active_cs;
+};
+
+/* SPI Controller driver's private data. */
+struct davinci_spi {
+	struct spi_bitbang	bitbang;
+	struct clk		*clk;
+
+	u8			version;
+	resource_size_t		pbase;
+	void __iomem		*base;
+	size_t			region_size;
+	u32			irq;
+	struct completion	done;
+
+	const void		*tx;
+	void			*rx;
+	int			count;
+	struct			davinci_spi_platform_data *pdata;
+
+	void			(*get_rx)(u32 rx_data, struct davinci_spi *);
+	u32			(*get_tx)(struct davinci_spi *);
+
+	struct davinci_spi_slave slave[SPI_MAX_CHIPSELECT];
+};
+
+#endif /* __DAVINCI_SPI_H */
_

Patches currently in -mm which might be from pablo.bitton@gmail.com are

spi-davinci-adding-spi-driver-for-davinci.patch

