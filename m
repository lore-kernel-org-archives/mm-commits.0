From: akpm@linux-foundation.org
Subject: + mfd-timberdale-add-timberdale-dma-driver.patch added to -mm tree
Date: Tue, 09 Jun 2009 16:10:10 -0700
Message-ID: <200906092310.n59NAAul001405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbZFIXMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 19:12:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, sameo@openedhand.com


The patch titled
     mfd: timberdale: add Timberdale DMA driver
has been added to the -mm tree.  Its filename is
     mfd-timberdale-add-timberdale-dma-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mfd: timberdale: add Timberdale DMA driver
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

Support for the Timberdale FPGA internal DMA engine

This driver gives other drivers the possibility to start DMA directly
between IP block inside the FPGA and the main memory

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig         |    7=20
 drivers/mfd/Makefile        |    2=20
 drivers/mfd/timbdma.c       |  302 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/timbdma.h |   76 ++++++++
 4 files changed, 387 insertions(+)

diff -puN drivers/mfd/Kconfig~mfd-timberdale-add-timberdale-dma-driver =
drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-timberdale-add-timberdale-dma-driver
+++ a/drivers/mfd/Kconfig
@@ -262,6 +262,13 @@ config EZX_PCAP
 	  This enables the PCAP ASIC present on EZX Phones. This is
 	  needed for MMC, TouchScreen, Sound, USB, etc..
=20
+config MFD_TIMBERDALE_DMA
+	tristate "Support for timberdale DMA"
+	depends on MFD_TIMBERDALE
+	---help---
+	Add support the DMA block inside the timberdale FPGA. This to be able
+	to do DMA transfers directly to some of the blocks inside the FPGA
+
 endmenu
=20
 menu "Multimedia Capabilities Port drivers"
diff -puN drivers/mfd/Makefile~mfd-timberdale-add-timberdale-dma-driver=
 drivers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-timberdale-add-timberdale-dma-driver
+++ a/drivers/mfd/Makefile
@@ -43,4 +43,6 @@ obj-$(CONFIG_PMIC_DA903X)	+=3D da903x.o
 obj-$(CONFIG_MFD_PCF50633)	+=3D pcf50633-core.o
 obj-$(CONFIG_PCF50633_ADC)	+=3D pcf50633-adc.o
 obj-$(CONFIG_PCF50633_GPIO)	+=3D pcf50633-gpio.o
+
+obj-$(CONFIG_MFD_TIMBERDALE_DMA)	+=3D timbdma.o
 obj-$(CONFIG_AB3100_CORE)	+=3D ab3100-core.o
diff -puN /dev/null drivers/mfd/timbdma.c
--- /dev/null
+++ a/drivers/mfd/timbdma.c
@@ -0,0 +1,302 @@
+/*
+ * timbdma.c timberdale FPGA DMA driver
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
+ * Timberdale FPGA DMA engine
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+#include <linux/mfd/timbdma.h>
+
+static struct timbdma_dev *self_g;
+
+static irqreturn_t timbdma_handleinterrupt(int irq, void *devid)
+{
+	struct timbdma_dev *dev =3D (struct timbdma_dev *)devid;
+	int ipr;
+	int i;
+
+	ipr =3D ioread32(dev->membase + timbdma_ctrlmap_TIMBPEND);
+
+	/* ack */
+	iowrite32(ipr, dev->membase + timbdma_ctrlmap_TIMBSTATUS);
+
+	/* call the callbacks */
+	for (i =3D 0; i < DMA_IRQS; i++) {
+		int mask =3D 1 << i;
+		if ((ipr & mask) && dev->callbacks[i])
+			dev->callbacks[i](mask, dev->callback_data[i]);
+	}
+
+	if (ipr)
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
+}
+
+
+void timb_start_dma(u32 flag, unsigned long buf, int len, int bytes_pe=
r_row)
+{
+	int i;
+	unsigned long irqflags;
+	struct timbdma_dev *dev =3D self_g;
+
+	spin_lock_irqsave(&dev->lock, irqflags);
+
+	/* now enable the DMA transfer */
+	for (i =3D 0; i < DMA_IRQS; i++)
+		if (flag & (1 << i)) {
+			u32 offset =3D i / 2 * 0x40;
+
+			if (!(i % 2)) {
+				/* RX */
+				/* bytes per row */
+				iowrite32(bytes_per_row, dev->membase + offset +
+					timbdma_dmacfg_BPERROW);
+				/* address high */
+				iowrite32(0, dev->membase + offset +
+					timbdma_dmacfg_RXSTARTH);
+				/* address low */
+				iowrite32(buf, dev->membase + offset +
+					timbdma_dmacfg_RXSTARTL);
+				/* Length */
+				iowrite32(len, dev->membase + offset +
+					timbdma_dmacfg_RXLENGTH);
+				/* Clear rx sw read pointer */
+				iowrite32(0, dev->membase + offset +
+					timbdma_dmacfg_RXSWRP);
+				/* enable the transfer */
+				iowrite32(1, dev->membase + offset +
+					timbdma_dmacfg_RXENABLE);
+			} else {
+				/* TX */
+				/* address high */
+				iowrite32(0, dev->membase + offset +
+					timbdma_dmacfg_TXSTARTH);
+				/* address low */
+				iowrite32(buf, dev->membase + offset +
+					timbdma_dmacfg_TXSTARTL);
+				/* Length */
+				iowrite32(len, dev->membase + offset +
+					timbdma_dmacfg_TXLENGTH);
+				/* Set tx sw write pointer */
+				iowrite32(len, dev->membase + offset +
+					timbdma_dmacfg_TXSWWP);
+			}
+
+			/* only allow one bit in the flag field */
+			break;
+		}
+	spin_unlock_irqrestore(&dev->lock, irqflags);
+}
+EXPORT_SYMBOL(timb_start_dma);
+
+void *timb_stop_dma(u32 flags)
+{
+	int i;
+	unsigned long irqflags;
+	struct timbdma_dev *dev =3D self_g;
+	void *result =3D 0;
+
+	spin_lock_irqsave(&dev->lock, irqflags);
+
+	/* now disable the DMA transfers */
+	for (i =3D 0; i < DMA_IRQS; i++)
+		if (flags & (1 << i)) {
+			/*
+				RX enable registers are located at:
+				0x14
+				0x54
+				0x94
+
+				TX SW pointer registers are located at:
+				0x24
+				0x64
+			*/
+			u32 offset =3D i / 2 * 0x40;
+			u32 result_offset =3D offset;
+			if (!(i % 2)) {
+				/* even -> RX enable */
+				offset +=3D timbdma_dmacfg_RXENABLE;
+				result_offset +=3D timbdma_dmacfg_RXFPGAWP;
+			} else {
+				/* odd -> TX SW pointer reg */
+				offset +=3D timbdma_dmacfg_TXSWWP;
+				result_offset =3D timbdma_dmacfg_TXFPGARP;
+			}
+
+			iowrite32(0, dev->membase + offset);
+			/* check how far the FPGA has written/read */
+			result =3D (void *)ioread32(dev->membase + result_offset);
+		}
+
+	/* ack any pending IRQs */
+	iowrite32(flags, dev->membase + timbdma_ctrlmap_TIMBSTATUS);
+
+	spin_unlock_irqrestore(&dev->lock, irqflags);
+
+	return result;
+}
+EXPORT_SYMBOL(timb_stop_dma);
+
+void timb_set_dma_interruptcb(u32 flags, timbdma_interruptcb icb, void=
 *data)
+{
+	int i;
+	unsigned long irqflags;
+	struct timbdma_dev *dev =3D self_g;
+	u32 ier;
+
+	spin_lock_irqsave(&dev->lock, irqflags);
+
+	for (i =3D 0; i < DMA_IRQS; i++)
+		if (flags & (1 << i)) {
+			dev->callbacks[i] =3D icb;
+			dev->callback_data[i] =3D data;
+		}
+
+	/* Ack any pending IRQ */
+	iowrite32(flags, dev->membase + timbdma_ctrlmap_TIMBSTATUS);
+
+	/* if a null callback is given -> clear interrupt, else -> enable */
+	ier =3D ioread32(dev->membase + timbdma_ctrlmap_TIMBENABLE);
+	if (icb !=3D NULL)
+		ier |=3D flags;
+	else
+		ier &=3D ~flags;
+	iowrite32(ier, dev->membase + timbdma_ctrlmap_TIMBENABLE);
+
+	spin_unlock_irqrestore(&dev->lock, irqflags);
+}
+EXPORT_SYMBOL(timb_set_dma_interruptcb);
+
+static int timbdma_probe(struct platform_device *dev)
+{
+	int err, irq;
+	struct timbdma_dev *self;
+	struct resource *iomem;
+
+	iomem =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+
+	self =3D kzalloc(sizeof(*self), GFP_KERNEL);
+	if (!self) {
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+
+	spin_lock_init(&self->lock);
+
+	if (!request_mem_region(iomem->start,
+		resource_size(iomem), "timb-dma")) {
+		err =3D -EBUSY;
+		goto err_request;
+	}
+
+	self->membase =3D ioremap(iomem->start, resource_size(iomem));
+	if (!self->membase) {
+		printk(KERN_ERR "timbdma: Failed to remap I/O memory\n");
+		err =3D -ENOMEM;
+		goto err_ioremap;
+	}
+
+	/* register interrupt */
+	irq =3D platform_get_irq(dev, 0);
+	if (irq < 0) {
+		err =3D irq;
+		goto err_get_irq;
+	}
+
+	/* request IRQ */
+	err =3D request_irq(irq, timbdma_handleinterrupt, IRQF_SHARED,
+			  "timb-dma", self);
+	if (err) {
+		printk(KERN_ERR "timbdma: Failed to request IRQ\n");
+		goto err_get_irq;
+	}
+
+	platform_set_drvdata(dev, self);
+
+	/* assign the global pointer */
+	self_g =3D self;
+
+	return 0;
+
+err_get_irq:
+	iounmap(self->membase);
+err_ioremap:
+	release_mem_region(iomem->start, resource_size(iomem));
+err_request:
+	kfree(self);
+err_mem:
+	printk(KERN_ERR "timberdale: Failed to register Timberdale DMA: %d\n"=
,
+		err);
+
+	return err;
+}
+
+static int timbdma_remove(struct platform_device *dev)
+{
+	struct timbdma_dev *self =3D platform_get_drvdata(dev);
+	struct resource *iomem =3D platform_get_resource(dev, IORESOURCE_MEM,=
 0);
+
+	free_irq(platform_get_irq(dev, 0), self);
+	iounmap(self->membase);
+	release_mem_region(iomem->start, resource_size(iomem));
+	kfree(self);
+	self_g =3D NULL;
+	return 0;
+}
+
+static struct platform_driver timbdma_platform_driver =3D {
+	.driver =3D {
+		.name	=3D "timb-dma",
+		.owner	=3D THIS_MODULE,
+	},
+	.probe		=3D timbdma_probe,
+	.remove		=3D timbdma_remove,
+};
+
+/*--------------------------------------------------------------------=
------*/
+
+static int __init timbdma_init(void)
+{
+	self_g =3D NULL;
+	return platform_driver_register(&timbdma_platform_driver);
+}
+
+static void __exit timbdma_exit(void)
+{
+	platform_driver_unregister(&timbdma_platform_driver);
+}
+
+module_init(timbdma_init);
+module_exit(timbdma_exit);
+
+MODULE_DESCRIPTION("Timberdale DMA driver");
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:timb-dma");
+
diff -puN /dev/null include/linux/mfd/timbdma.h
--- /dev/null
+++ a/include/linux/mfd/timbdma.h
@@ -0,0 +1,76 @@
+/*
+ * timbdma.h timberdale FPGA DMA driver defines
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
+ * Timberdale FPGA DMA engine
+ */
+
+#ifndef _TIMBDMA_H
+#define _TIMBDMA_H
+
+#include <linux/spinlock.h>
+
+
+#define DMA_IRQ_UART_RX		0x01
+#define DMA_IRQ_UART_TX		0x02
+#define DMA_IRQ_MLB_RX		0x04
+#define DMA_IRQ_MLB_TX		0x08
+#define DMA_IRQ_VIDEO_RX	0x10
+#define DMA_IRQ_VIDEO_DROP	0x20
+#define DMA_IRQS		6
+
+
+typedef int (*timbdma_interruptcb)(u32 flag, void *data);
+
+#define timbdma_ctrlmap_DMACFGBTUART	0x000000
+#define timbdma_ctrlmap_DMACFGMLBSY	0x000040
+#define timbdma_ctrlmap_DMACFGVIDEO	0x000080
+#define timbdma_ctrlmap_TIMBSTATUS	0x080000
+#define timbdma_ctrlmap_TIMBPEND	0x080004
+#define timbdma_ctrlmap_TIMBENABLE	0x080008
+#define timbdma_ctrlmap_VIDEOBUFFER	0x200000
+
+#define timbdma_dmacfg_RXSTARTH	0x00
+#define timbdma_dmacfg_RXSTARTL	0x04
+#define timbdma_dmacfg_RXLENGTH	0x08
+#define timbdma_dmacfg_RXFPGAWP	0x0C
+#define timbdma_dmacfg_RXSWRP	0x10
+#define timbdma_dmacfg_RXENABLE	0x14
+#define timbdma_dmacfg_TXSTARTH	0x18
+#define timbdma_dmacfg_TXSTARTL	0x1C
+#define timbdma_dmacfg_TXLENGTH	0x20
+#define timbdma_dmacfg_TXSWWP	0x24
+#define timbdma_dmacfg_TXFPGARP	0x28
+#define timbdma_dmacfg_TXBEFINT	0x2C
+#define timbdma_dmacfg_BPERROW	0x30
+
+struct timbdma_dev {
+	void __iomem		*membase;
+	timbdma_interruptcb	callbacks[DMA_IRQS];
+	void			*callback_data[DMA_IRQS];
+	spinlock_t		lock; /* mutual exclusion */
+};
+
+void timb_start_dma(u32 flag, unsigned long buf, int len, int bytes_pe=
r_row);
+
+void *timb_stop_dma(u32 flags);
+
+void timb_set_dma_interruptcb(u32 flags, timbdma_interruptcb icb, void=
 *data);
+
+#endif /* _TIMBDMA_H */
+
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
gpio-timberdale-add-mc33880-driver.patch
i2c-timberdale-i2c-ocores-can-add-i2c-devices-to-the-bus.patch
mfd-timberdale-add-timberdale-dma-driver.patch
v4l2-timberdale-add-timberdale-logiwin-driver.patch
v4l2-timberdale-add-timberdale-logiwin-driver-in-kconfig-and-makefile.p=
atch
mfd-timberdale-add-timberdale-driver.patch
serial-timberdale-add-timberdale-uart-driver.patch
gpio-timberdale-add-timbgpio.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
