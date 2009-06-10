From: akpm@linux-foundation.org
Subject: - mfd-timberdale-add-timberdale-driver.patch removed from -mm tree
Date: Tue, 09 Jun 2009 17:24:03 -0700
Message-ID: <200906100043.n5A0hwlW012666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbZFJAoC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 20:44:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors.ext@mocean-labs.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: timberdale: add Timberdale driver
has been removed from the -mm tree.  Its filename was
     mfd-timberdale-add-timberdale-driver.patch

This patch was dropped because of build problems due to the missing xil=
inx patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mfd: timberdale: add Timberdale driver
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

MFD driver for the Timberdale FPGA The FPGA can be found on the Intel A=
tom
development board, Russellville for in-vechicle infotainment

The FPGA is connected via PCIe

The driver basically exposes a lot of platform devices for the

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig      |   10=20
 drivers/mfd/Makefile     |    1=20
 drivers/mfd/timberdale.c |  686 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/timberdale.h |  123 ++++++
 4 files changed, 820 insertions(+)

diff -puN drivers/mfd/Kconfig~mfd-timberdale-add-timberdale-driver driv=
ers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-timberdale-add-timberdale-driver
+++ a/drivers/mfd/Kconfig
@@ -262,6 +262,16 @@ config EZX_PCAP
 	  This enables the PCAP ASIC present on EZX Phones. This is
 	  needed for MMC, TouchScreen, Sound, USB, etc..
=20
+config MFD_TIMBERDALE
+	bool "Support for the Timberdale FPGA"
+	select MFD_CORE
+	---help---
+	This is the core driver for the timberdale FPGA. This device is a
+	multifunctioanl device which may provide numerous interfaces.
+
+	The timberdale FPGA can be found on the Intel Atom development board
+	for automotive in-vehicle infontainment board called Russellville.
+
 config MFD_TIMBERDALE_DMA
 	tristate "Support for timberdale DMA"
 	depends on MFD_TIMBERDALE
diff -puN drivers/mfd/Makefile~mfd-timberdale-add-timberdale-driver dri=
vers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-timberdale-add-timberdale-driver
+++ a/drivers/mfd/Makefile
@@ -44,5 +44,6 @@ obj-$(CONFIG_MFD_PCF50633)	+=3D pcf50633-c
 obj-$(CONFIG_PCF50633_ADC)	+=3D pcf50633-adc.o
 obj-$(CONFIG_PCF50633_GPIO)	+=3D pcf50633-gpio.o
=20
+obj-$(CONFIG_MFD_TIMBERDALE)		+=3D timberdale.o
 obj-$(CONFIG_MFD_TIMBERDALE_DMA)	+=3D timbdma.o
 obj-$(CONFIG_AB3100_CORE)	+=3D ab3100-core.o
diff -puN /dev/null drivers/mfd/timberdale.c
--- /dev/null
+++ a/drivers/mfd/timberdale.c
@@ -0,0 +1,686 @@
+/*
+ * timberdale.c timberdale FPGA mfd shim driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+/* Supports:
+ * Timberdale FPGA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/msi.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/irq.h>
+
+#include <linux/i2c.h>
+#include <linux/i2c-ocores.h>
+#include <linux/i2c/tsc2007.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/xilinx_spi.h>
+#include <linux/spi/max7301.h>
+#include <linux/spi/mc33880.h>
+
+#include <media/timb_video.h>
+
+#include "timberdale.h"
+
+struct timberdale_device {
+	resource_size_t		intc_mapbase;
+	resource_size_t		ctl_mapbase;
+	unsigned char __iomem   *intc_membase;
+	unsigned char __iomem   *ctl_membase;
+	int			irq_base;
+	u32			irq_ack_mask;
+	/* locking from interrupts while modifiying registers */
+	spinlock_t		lock;
+};
+
+/*--------------------------------------------------------------------=
------*/
+
+struct tsc2007_platform_data timberdale_tsc2007_platform_data =3D {
+	.model =3D 2003,
+	.x_plate_ohms =3D 100
+};
+
+struct i2c_board_info timberdale_i2c_board_info[] =3D {
+	{
+		I2C_BOARD_INFO("tsc2003", 0x48),
+		.platform_data =3D &timberdale_tsc2007_platform_data,
+		.irq =3D IRQ_TIMBERDALE_TSC_INT
+	},
+	{
+		/* Requires jumper JP9 to be off */
+		I2C_BOARD_INFO("adv7180", 0x42 >> 1),
+		.irq =3D IRQ_TIMBERDALE_ADV7180
+	}
+};
+
+static __devinitdata struct ocores_i2c_platform_data
+timberdale_i2c_platform_data =3D {
+	.regstep =3D 4,
+	.clock_khz =3D 62500,
+	.devices =3D timberdale_i2c_board_info,
+	.num_devices =3D ARRAY_SIZE(timberdale_i2c_board_info)
+};
+
+const static __devinitconst struct resource timberdale_i2c_resources[]=
 =3D {
+	{
+		.start	=3D I2COFFSET,
+		.end	=3D I2CEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start 	=3D IRQ_TIMBERDALE_I2C,
+		.end	=3D IRQ_TIMBERDALE_I2C,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+const struct max7301_platform_data timberdale_max7301_platform_data =3D=
 {
+	.base =3D -1
+};
+
+const struct mc33880_platform_data timberdale_mc33880_platform_data =3D=
 {
+	.base =3D -1
+};
+
+struct spi_board_info timberdale_spi_16bit_board_info[] =3D {
+	{
+		.modalias =3D "max7301",
+		.max_speed_hz =3D 26000,
+		.chip_select =3D 2,
+		.mode =3D SPI_MODE_0,
+		.platform_data =3D &timberdale_max7301_platform_data
+	},
+};
+
+struct spi_board_info timberdale_spi_8bit_board_info[] =3D {
+	{
+		.modalias =3D "mc33880",
+		.max_speed_hz =3D 4000,
+		.chip_select =3D 1,
+		.mode =3D SPI_MODE_1,
+		.platform_data =3D &timberdale_mc33880_platform_data
+	},
+};
+
+static __devinitdata struct xspi_platform_data timberdale_xspi_platfor=
m_data =3D {
+	.bus_num =3D -1,
+	/* Current(2009-03-06) revision of
+	 * Timberdale we can handle 3 chip selects
+	 */
+	.num_chipselect =3D 3,
+	.model =3D XILINX_SPI_MODEL_DS570,
+	/* bits per word and devices will be filled in runtime depending
+	 * on the HW config
+	 */
+};
+
+const static __devinitconst struct resource timberdale_spi_resources[]=
 =3D {
+	{
+		.start 	=3D SPIOFFSET,
+		.end	=3D SPIEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_SPI,
+		.end	=3D IRQ_TIMBERDALE_SPI,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+const static __devinitconst struct resource timberdale_eth_resources[]=
 =3D {
+	{
+		.start	=3D ETHOFFSET,
+		.end	=3D ETHEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_ETHSW_IF,
+		.end	=3D IRQ_TIMBERDALE_ETHSW_IF,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+const static __devinitconst struct resource timberdale_gpio_resources[=
] =3D {
+	{
+		.start	=3D GPIOOFFSET,
+		.end	=3D GPIOEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_GPIO,
+		.end	=3D IRQ_TIMBERDALE_GPIO,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+const static __devinitconst struct resource timberdale_most_resources[=
] =3D {
+	{
+		.start	=3D MOSTOFFSET,
+		.end	=3D MOSTEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_MLB,
+		.end	=3D IRQ_TIMBERDALE_MLB,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+const static __devinitconst struct resource timberdale_uart_resources[=
] =3D {
+	{
+		.start	=3D UARTOFFSET,
+		.end	=3D UARTEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_UART,
+		.end	=3D IRQ_TIMBERDALE_UART,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+const static __devinitconst struct resource timberdale_i2s_resources[]=
 =3D {
+	{
+		.start	=3D I2SOFFSET,
+		.end	=3D I2SEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_I2S,
+		.end	=3D IRQ_TIMBERDALE_I2S,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+static __devinitdata struct timb_video_platform_data
+	timberdale_video_platform_data =3D {
+	.i2c_adapter =3D 0,
+	.encoder =3D "adv7180"
+};
+
+const static __devinitconst struct resource timberdale_video_resources=
[] =3D {
+	{
+		.start	=3D LOGIWOFFSET,
+		.end	=3D LOGIWEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	/*
+	note that the "frame buffer" is located in DMA area
+	starting at 0x1200000
+	*/
+};
+
+const static __devinitconst struct resource timberdale_dma_resources[]=
 =3D {
+	{
+		.start	=3D DMAOFFSET,
+		.end	=3D DMAEND,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_DMA,
+		.end	=3D IRQ_TIMBERDALE_DMA,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+static __devinitdata struct mfd_cell timberdale_cells_bar0[] =3D {
+	{
+		.name =3D "timb-uart",
+		.num_resources =3D ARRAY_SIZE(timberdale_uart_resources),
+		.resources =3D timberdale_uart_resources,
+	},
+	{
+		.name =3D "ocores-i2c",
+		.num_resources =3D ARRAY_SIZE(timberdale_i2c_resources),
+		.resources =3D timberdale_i2c_resources,
+		.platform_data =3D &timberdale_i2c_platform_data,
+		.data_size =3D sizeof(timberdale_i2c_platform_data),
+	},
+	{
+		.name =3D "timb-gpio",
+		.num_resources =3D ARRAY_SIZE(timberdale_gpio_resources),
+		.resources =3D timberdale_gpio_resources,
+	},
+	{
+		.name =3D "timb-i2s",
+		.num_resources =3D ARRAY_SIZE(timberdale_i2s_resources),
+		.resources =3D timberdale_i2s_resources,
+	},
+	{
+		.name =3D "timb-most",
+		.num_resources =3D ARRAY_SIZE(timberdale_most_resources),
+		.resources =3D timberdale_most_resources,
+	},
+	{
+		.name =3D "timb-video",
+		.num_resources =3D ARRAY_SIZE(timberdale_video_resources),
+		.resources =3D timberdale_video_resources,
+		.platform_data =3D &timberdale_video_platform_data,
+		.data_size =3D sizeof(timberdale_video_platform_data),
+	},
+	{
+		.name =3D "xilinx_spi",
+		.num_resources =3D ARRAY_SIZE(timberdale_spi_resources),
+		.resources =3D timberdale_spi_resources,
+		.platform_data =3D &timberdale_xspi_platform_data,
+		.data_size =3D sizeof(timberdale_xspi_platform_data),
+	},
+	{
+		.name =3D "ks8842",
+		.num_resources =3D ARRAY_SIZE(timberdale_eth_resources),
+		.resources =3D timberdale_eth_resources,
+	},
+	{
+		.name =3D "timb-dma",
+		.num_resources =3D ARRAY_SIZE(timberdale_dma_resources),
+		.resources =3D timberdale_dma_resources,
+	},
+};
+
+static const __devinitconst struct resource timberdale_sdhc_resources[=
] =3D {
+	/* located in bar 1 and bar 2 */
+	{
+		.start	=3D SDHC0OFFSET,
+		.end	=3D SDHC0END,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	{
+		.start	=3D IRQ_TIMBERDALE_SDHC,
+		.end	=3D IRQ_TIMBERDALE_SDHC,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+static __devinitdata struct mfd_cell timberdale_cells_bar1[] =3D {
+	{
+		.name =3D "sdhci",
+		.num_resources =3D ARRAY_SIZE(timberdale_sdhc_resources),
+		.resources =3D timberdale_sdhc_resources,
+	},
+};
+
+static __devinitdata struct mfd_cell timberdale_cells_bar2[] =3D {
+	{
+		.name =3D "sdhci",
+		.num_resources =3D ARRAY_SIZE(timberdale_sdhc_resources),
+		.resources =3D timberdale_sdhc_resources,
+	},
+};
+
+/*--------------------------------------------------------------------=
------*/
+
+
+/* Handle the timberdale interrupt mux */
+static void timberdale_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct timberdale_device *priv =3D get_irq_data(irq);
+	unsigned int i, ipr;
+
+	desc->chip->ack(irq);
+
+	while ((ipr =3D ioread32(priv->intc_membase + IPR))) {
+		for (i =3D 0; i < TIMBERDALE_NR_IRQS; i++)
+			if (ipr & (1 << i)) {
+				priv->irq_ack_mask =3D 0;
+				generic_handle_irq(priv->irq_base + i);
+				if (priv->irq_ack_mask)
+					iowrite32(priv->irq_ack_mask,
+						priv->intc_membase + IAR);
+			}
+	}
+}
+
+static void timberdale_irq_mask(unsigned int irq)
+{
+	struct timberdale_device *priv =3D get_irq_chip_data(irq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iowrite32(1 << (irq - priv->irq_base), priv->intc_membase + CIE);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static void timberdale_irq_unmask(unsigned int irq)
+{
+	struct timberdale_device *priv =3D get_irq_chip_data(irq);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iowrite32(1 << (irq - priv->irq_base), priv->intc_membase + SIE);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static void timberdale_irq_ack(unsigned int irq)
+{
+	struct timberdale_device *priv =3D get_irq_chip_data(irq);
+	unsigned long flags;
+	u32 ack_mask =3D 1 << (irq - priv->irq_base);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	/* if edge triggered, ack directly. Otherwhise ack in the end of
+	 * irq handler
+	 */
+	if (ack_mask & IRQ_TIMBERDALE_EDGE_MASK)
+		iowrite32(ack_mask, priv->intc_membase + IAR);
+	else
+		priv->irq_ack_mask |=3D ack_mask;
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static struct irq_chip timberdale_chip =3D {
+	.name		=3D "timberdale",
+	.ack		=3D timberdale_irq_ack,
+	.mask		=3D timberdale_irq_mask,
+	.unmask		=3D timberdale_irq_unmask,
+	.disable	=3D timberdale_irq_mask,
+	.enable		=3D timberdale_irq_unmask,
+};
+
+/*--------------------------------------------------------------------=
------*/
+
+/* Install the IRQ handler */
+static void timberdale_attach_irq(struct pci_dev *dev)
+{
+	struct timberdale_device *priv =3D pci_get_drvdata(dev);
+	unsigned int irq, irq_base;
+
+	irq_base =3D priv->irq_base;
+	for (irq =3D irq_base; irq < irq_base + TIMBERDALE_NR_IRQS; irq++) {
+		set_irq_chip_and_handler_name(irq, &timberdale_chip,
+			handle_edge_irq, "mux");
+
+		set_irq_chip_data(irq, priv);
+
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+#endif
+	}
+
+	set_irq_data(dev->irq, priv);
+	set_irq_chained_handler(dev->irq, timberdale_irq);
+}
+
+static void timberdale_detach_irq(struct pci_dev *dev)
+{
+	struct timberdale_device *priv =3D pci_get_drvdata(dev);
+	unsigned int irq, irq_base;
+
+	irq_base =3D priv->irq_base;
+
+	set_irq_chained_handler(dev->irq, NULL);
+	set_irq_data(dev->irq, NULL);
+
+	for (irq =3D irq_base; irq < irq_base + TIMBERDALE_NR_IRQS; irq++) {
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, 0);
+#endif
+		set_irq_chip(irq, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
+
+static int irq_range_free(int irq_start, int num_irq)
+{
+	int i;
+
+	for (i =3D 0; i < num_irq; i++)
+		if (get_irq_chip(irq_start + i) !=3D &no_irq_chip)
+			return 0;
+
+	return 1;
+}
+
+static int __devinit timb_probe(struct pci_dev *dev,
+	const struct pci_device_id *id)
+{
+	struct timberdale_device *priv;
+	int err, i;
+	resource_size_t mapbase;
+	u32 hw_config;
+
+	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	spin_lock_init(&priv->lock);
+	pci_set_drvdata(dev, priv);
+
+	err =3D pci_enable_device(dev);
+	if (err)
+		goto err_enable;
+
+	mapbase =3D pci_resource_start(dev, 0);
+	if (!mapbase) {
+		printk(KERN_ERR "timberdale: No resource\n");
+		goto err_start;
+	}
+
+	/* create a resource for the Interrupt controller registers */
+	priv->intc_mapbase =3D mapbase + INTCOFFSET;
+	if (!request_mem_region(priv->intc_mapbase, INTCSIZE, "timb-intc")) {
+		printk(KERN_ERR "timberdale: Failed to request intc mem\n");
+		goto err_request;
+	}
+
+	/* create a resource for the PCI master register */
+	priv->ctl_mapbase =3D mapbase + CHIPCTLOFFSET;
+	if (!request_mem_region(priv->ctl_mapbase, CHIPCTLSIZE, "timb-intc"))=
 {
+		printk(KERN_ERR "timberdale: Failed to request ctl mem\n");
+		goto err_request_ctl;
+	}
+
+	priv->intc_membase =3D ioremap(priv->intc_mapbase, INTCSIZE);
+	if (!priv->intc_membase) {
+		printk(KERN_ALERT "timberdale: Map error, intc\n");
+		goto err_ioremap;
+	}
+
+	priv->ctl_membase =3D ioremap(priv->ctl_mapbase, CHIPCTLSIZE);
+	if (!priv->ctl_membase) {
+		printk(KERN_ALERT "timberdale: Map error, ctl\n");
+		goto err_ioremap_ctl;
+	}
+
+	err =3D pci_enable_msi(dev);
+	if (err) {
+		printk(KERN_WARNING "timberdale: MSI init failed: %d\n", err);
+		goto err_msi;
+	}
+
+	/* Reset all FPGA PLB peripherals */
+	iowrite32(0x1, priv->ctl_membase + MAYSVILLERST);
+
+	/* read the HW config */
+	hw_config =3D ioread32(priv->ctl_membase + TIMB_HW_CONFIG);
+
+	/* at this stage the FPGA does not generate a
+	 * unique interrupt per function, to emulate real interrupts
+	 * we assign them a faked interrupt which we issue in the
+	 * interrupt handler. For now just hard code a base number
+	 */
+	priv->irq_base =3D NR_IRQS - TIMBERDALE_NR_IRQS - 1;
+	while (priv->irq_base >=3D 0)
+		if (irq_range_free(priv->irq_base, TIMBERDALE_NR_IRQS))
+			break;
+		else
+			priv->irq_base -=3D TIMBERDALE_NR_IRQS;
+
+	if (priv->irq_base < 0)
+		goto err_msi;
+
+	timberdale_attach_irq(dev);
+
+	/* update IRQ offsets in I2C board info */
+	for (i =3D 0; i < ARRAY_SIZE(timberdale_i2c_board_info); i++)
+		timberdale_i2c_board_info[i].irq +=3D priv->irq_base;
+
+	/* Update the SPI configuration depending on the HW (8 or 16 bit) */
+	if (hw_config & TIMB_HW_CONFIG_SPI_8BIT) {
+		timberdale_xspi_platform_data.bits_per_word =3D 8;
+		timberdale_xspi_platform_data.devices =3D
+			timberdale_spi_8bit_board_info;
+		timberdale_xspi_platform_data.num_devices =3D
+			ARRAY_SIZE(timberdale_spi_8bit_board_info);
+	} else {
+		timberdale_xspi_platform_data.bits_per_word =3D 16;
+		timberdale_xspi_platform_data.devices =3D
+			timberdale_spi_16bit_board_info;
+		timberdale_xspi_platform_data.num_devices =3D
+			ARRAY_SIZE(timberdale_spi_16bit_board_info);
+	}
+
+	err =3D mfd_add_devices(&dev->dev, 0,
+		timberdale_cells_bar0, ARRAY_SIZE(timberdale_cells_bar0),
+		&dev->resource[0], priv->irq_base);
+	if (err) {
+		printk(KERN_WARNING
+			"timberdale: mfd_add_devices failed: %d\n", err);
+		goto err_mfd;
+	}
+
+	err =3D mfd_add_devices(&dev->dev, 1,
+		timberdale_cells_bar1, ARRAY_SIZE(timberdale_cells_bar1),
+		&dev->resource[1], priv->irq_base);
+	if (err) {
+		printk(KERN_WARNING
+			"timberdale: mfd_add_devices failed: %d\n", err);
+		goto err_mfd2;
+	}
+
+	err =3D mfd_add_devices(&dev->dev, 2,
+		timberdale_cells_bar2, ARRAY_SIZE(timberdale_cells_bar2),
+		&dev->resource[2], priv->irq_base);
+	if (err) {
+		printk(KERN_WARNING
+			"timberdale: mfd_add_devices failed: %d\n", err);
+		goto err_mfd2;
+	}
+
+	printk(KERN_INFO
+		"Found Timberdale Card. Rev: %d.%d, HW config: 0x%02x\n",
+		ioread32(priv->ctl_membase + TIMB_REV_MAJOR),
+		ioread32(priv->ctl_membase + TIMB_REV_MINOR), hw_config);
+
+	/* Enable interrupts and wire the hardware interrupts */
+	iowrite32(0x3, priv->intc_membase + MER);
+
+	return 0;
+
+err_mfd2:
+	mfd_remove_devices(&dev->dev);
+err_mfd:
+	timberdale_detach_irq(dev);
+	pci_disable_msi(dev);
+err_msi:
+	iounmap(priv->ctl_membase);
+err_ioremap_ctl:
+	iounmap(priv->intc_membase);
+err_ioremap:
+	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
+err_request_ctl:
+	release_mem_region(priv->intc_mapbase, INTCSIZE);
+err_request:
+	pci_set_drvdata(dev, NULL);
+err_start:
+	pci_disable_device(dev);
+err_enable:
+	kfree(priv);
+	pci_set_drvdata(dev, NULL);
+	return -ENODEV;
+}
+
+static void __devexit timb_remove(struct pci_dev *dev)
+{
+	/* clean up any allocated resources and stuff here.
+	 * like call release_region();
+	 */
+	struct timberdale_device *priv;
+
+	priv =3D pci_get_drvdata(dev);
+
+	mfd_remove_devices(&dev->dev);
+
+	timberdale_detach_irq(dev);
+
+	iowrite32(0xffffffff, priv->intc_membase + IAR);
+	iowrite32(0, priv->intc_membase + MER);
+	iowrite32(0, priv->intc_membase + IER);
+
+	iounmap(priv->ctl_membase);
+	iounmap(priv->intc_membase);
+	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
+	release_mem_region(priv->intc_mapbase, INTCSIZE);
+
+	pci_disable_msi(dev);
+	pci_disable_device(dev);
+	pci_set_drvdata(dev, NULL);
+	kfree(priv);
+}
+
+static struct pci_device_id timberdale_pci_tbl[] =3D {
+	{ PCI_DEVICE(PCI_VENDOR_ID_TIMB, PCI_DEVICE_ID_TIMB) },
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, timberdale_pci_tbl);
+
+static struct pci_driver timberdale_pci_driver =3D {
+	.name =3D "timberdale",
+	.id_table =3D timberdale_pci_tbl,
+	.probe =3D timb_probe,
+	.remove =3D timb_remove,
+};
+
+static int __init timberdale_init(void)
+{
+	int err;
+
+	err =3D pci_register_driver(&timberdale_pci_driver);
+	if (err < 0) {
+		printk(KERN_ERR
+			"Failed to register PCI driver for %s device.\n",
+			timberdale_pci_driver.name);
+		return -ENODEV;
+	}
+
+	printk(KERN_INFO "Driver for %s has been successfully registered.\n",
+		timberdale_pci_driver.name);
+
+	return 0;
+}
+
+static void __exit timberdale_exit(void)
+{
+	pci_unregister_driver(&timberdale_pci_driver);
+
+	printk(KERN_INFO "Driver for %s has been successfully unregistered.\n=
",
+				timberdale_pci_driver.name);
+}
+
+module_init(timberdale_init);
+module_exit(timberdale_exit);
+
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL v2");
+
diff -puN /dev/null drivers/mfd/timberdale.h
--- /dev/null
+++ a/drivers/mfd/timberdale.h
@@ -0,0 +1,123 @@
+/*
+ * timberdale.h timberdale FPGA mfd shim driver defines
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+/* Supports:
+ * Timberdale FPGA
+ */
+
+#ifndef MFD_TIMBERDALE_H
+#define MFD_TIMBERDALE_H
+
+/* Registers of the interrupt controller */
+#define ISR		0x00
+#define IPR		0x04
+#define IER		0x08
+#define IAR		0x0c
+#define SIE		0x10
+#define CIE		0x14
+#define MER		0x1c
+
+/* Registers of the control area */
+#define TIMB_REV_MAJOR	0x00
+#define TIMB_REV_MINOR	0x04
+#define TIMB_HW_CONFIG	0x08
+#define MAYSVILLERST	0x40
+
+/* bits in the TIMB_HW_CONFIG register */
+#define TIMB_HW_CONFIG_SPI_8BIT	0x80
+
+#define I2COFFSET	0x0
+#define I2CEND		0x1f
+
+#define SPIOFFSET	0x80
+#define SPIEND		0xff
+
+#define ETHOFFSET	0x300
+#define ETHEND		0x3ff
+
+#define GPIOOFFSET	0x400
+#define GPIOEND		0x7ff
+
+#define CHIPCTLOFFSET	0x800
+#define CHIPCTLEND	0x8ff
+#define CHIPCTLSIZE	(CHIPCTLEND - CHIPCTLOFFSET)
+
+#define INTCOFFSET	0xc00
+#define INTCEND		0xfff
+#define INTCSIZE	(INTCEND - INTCOFFSET)
+
+#define MOSTOFFSET	0x1000
+#define MOSTEND		0x13ff
+
+#define UARTOFFSET	0x1400
+#define UARTEND		0x17ff
+
+#define I2SOFFSET	0x1C00
+#define I2SEND		0x1fff
+
+#define LOGIWOFFSET	0x30000
+#define LOGIWEND	0x37fff
+
+#define DMAOFFSET	0x01000000
+#define DMAEND		0x013fffff
+
+/* SDHC0 is placed in PCI bar 1 */
+#define SDHC0OFFSET	0x00
+#define SDHC0END	0xff
+
+/* SDHC1 is placed in PCI bar 2 */
+#define SDHC1OFFSET	0x00
+#define SDHC1END	0xff
+
+#define PCI_VENDOR_ID_TIMB	0x10ee
+#define PCI_DEVICE_ID_TIMB	0xa123
+#define DRV_VERSION		"0.1"
+
+
+#define IRQ_TIMBERDALE_INIC	0
+#define IRQ_TIMBERDALE_MLB	1
+#define IRQ_TIMBERDALE_GPIO	2
+#define IRQ_TIMBERDALE_I2C	3
+#define IRQ_TIMBERDALE_UART	4
+#define IRQ_TIMBERDALE_DMA	5
+#define IRQ_TIMBERDALE_I2S	6
+#define IRQ_TIMBERDALE_TSC_INT	7
+#define IRQ_TIMBERDALE_SDHC	8
+#define IRQ_TIMBERDALE_ADV7180	9
+#define IRQ_TIMBERDALE_ETHSW_IF	10
+#define IRQ_TIMBERDALE_SPI	11
+
+#define TIMBERDALE_NR_IRQS	12
+
+/* Some of the interrupts are level triggered, some are edge triggered=
 */
+#define IRQ_TIMBERDALE_EDGE_MASK ((1 << IRQ_TIMBERDALE_ADV7180) | \
+	(1 << IRQ_TIMBERDALE_TSC_INT) | \
+	(1 << IRQ_TIMBERDALE_MLB) | (1 << IRQ_TIMBERDALE_INIC))
+
+#define IRQ_TIMBERDALE_LEVEL_MASK ((1 << IRQ_TIMBERDALE_SPI) | \
+	(1 << IRQ_TIMBERDALE_ETHSW_IF) | (1 << IRQ_TIMBERDALE_SDHC) | \
+	(1 << IRQ_TIMBERDALE_I2S) | (1 << IRQ_TIMBERDALE_UART) | \
+	(1 << IRQ_TIMBERDALE_I2C) | (1 << IRQ_TIMBERDALE_GPIO) | \
+	(1 << IRQ_TIMBERDALE_DMA))
+
+#define GPIO_PIN_INIC_RST	14
+#define GPIO_PIN_BT_RST		15
+
+
+#endif
+
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
mfd-timberdale-add-timberdale-driver.patch
serial-timberdale-add-timberdale-uart-driver.patch
gpio-timberdale-add-timbgpio.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
