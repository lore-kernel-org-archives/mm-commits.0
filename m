From: akpm@linux-foundation.org
Subject: + spi-superh-spi-using-sci.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:13:51 -0800
Message-ID: <200801270513.m0R5DmV5030948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbYA0FOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, dbrownell@users.sourceforge.net, lethal@linux-sh.org


The patch titled
     spi: SuperH SPI using SCI
has been added to the -mm tree.  Its filename is
     spi-superh-spi-using-sci.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: SuperH SPI using SCI
From: Magnus Damm <magnus.damm@gmail.com>

Add support for SPI over SCI pins.  SCI is a very simple serial controller
block that can be found on older SuperH processors.  In theory it is
possible to use the SCI hardware block in syncronous mode, but this version
of the driver simply hooks up the bit banging code on the SCI pins.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig      |    7 +
 drivers/spi/Makefile     |    1 
 drivers/spi/spi_sh_sci.c |  205 +++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+)

diff -puN drivers/spi/Kconfig~spi-superh-spi-using-sci drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-superh-spi-using-sci
+++ a/drivers/spi/Kconfig
@@ -176,6 +176,13 @@ config SPI_S3C24XX_GPIO
 	  the inbuilt hardware cannot provide the transfer mode, or
 	  where the board is using non hardware connected pins.
 
+config SPI_SH_SCI
+	tristate "SuperH SCI SPI controller"
+	depends on SPI_MASTER && SUPERH
+	select SPI_BITBANG
+	help
+	  SPI driver for SuperH SCI blocks.
+
 config SPI_TXX9
 	tristate "Toshiba TXx9 SPI controller"
 	depends on SPI_MASTER && GENERIC_GPIO && CPU_TX49XX
diff -puN drivers/spi/Makefile~spi-superh-spi-using-sci drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-superh-spi-using-sci
+++ a/drivers/spi/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s
 obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx.o
 obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
+obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff -puN /dev/null drivers/spi/spi_sh_sci.c
--- /dev/null
+++ a/drivers/spi/spi_sh_sci.c
@@ -0,0 +1,205 @@
+/*
+ * SH SCI SPI interface
+ *
+ * Copyright (c) 2008 Magnus Damm
+ *
+ * Based on S3C24XX GPIO based SPI driver, which is:
+ *   Copyright (c) 2006 Ben Dooks
+ *   Copyright (c) 2006 Simtec Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+
+#include <asm/spi.h>
+#include <asm/io.h>
+
+struct sh_sci_spi {
+	struct spi_bitbang bitbang;
+
+	void __iomem *membase;
+	unsigned char val;
+	struct sh_spi_info *info;
+	struct platform_device *dev;
+};
+
+#define SCSPTR(sp)	(sp->membase + 0x1c)
+#define PIN_SCK		(1 << 2)
+#define PIN_TXD		(1 << 0)
+#define PIN_RXD		PIN_TXD
+#define PIN_INIT	((1 << 1) | (1 << 3) | PIN_SCK | PIN_TXD)
+
+static inline void setbits(struct sh_sci_spi *sp, int bits, int on)
+{
+	/*
+	 * We are the only user of SCSPTR so no locking is required.
+	 * Reading bit 2 and 0 in SCSPTR gives pin state as input.
+	 * Writing the same bits sets the output value.
+	 * This makes regular read-modify-write difficult so we
+	 * use sp->val to keep track of the latest register value.
+	 */
+
+	if (on)
+		sp->val |= bits;
+	else
+		sp->val &= ~bits;
+
+	iowrite8(sp->val, SCSPTR(sp));
+}
+
+static inline void setsck(struct spi_device *dev, int on)
+{
+	setbits(spi_master_get_devdata(dev->master), PIN_SCK, on);
+}
+
+static inline void setmosi(struct spi_device *dev, int on)
+{
+	setbits(spi_master_get_devdata(dev->master), PIN_TXD, on);
+}
+
+static inline u32 getmiso(struct spi_device *dev)
+{
+	struct sh_sci_spi *sp = spi_master_get_devdata(dev->master);
+
+	return (ioread8(SCSPTR(sp)) & PIN_RXD) ? 1 : 0;
+}
+
+#define spidelay(x) ndelay(x)
+
+#define EXPAND_BITBANG_TXRX
+#include <linux/spi/spi_bitbang.h>
+
+static u32 sh_sci_spi_txrx_mode0(struct spi_device *spi,
+				      unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha0(spi, nsecs, 0, word, bits);
+}
+
+static u32 sh_sci_spi_txrx_mode1(struct spi_device *spi,
+				      unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha1(spi, nsecs, 0, word, bits);
+}
+
+static u32 sh_sci_spi_txrx_mode2(struct spi_device *spi,
+				      unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha0(spi, nsecs, 1, word, bits);
+}
+
+static u32 sh_sci_spi_txrx_mode3(struct spi_device *spi,
+				      unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha1(spi, nsecs, 1, word, bits);
+}
+
+static void sh_sci_spi_chipselect(struct spi_device *dev, int value)
+{
+	struct sh_sci_spi *sp = spi_master_get_devdata(dev->master);
+
+	if (sp->info && sp->info->chip_select)
+		(sp->info->chip_select)(sp->info, dev->chip_select, value);
+}
+
+static int sh_sci_spi_probe(struct platform_device *dev)
+{
+	struct resource	*r;
+	struct spi_master *master;
+	struct sh_sci_spi *sp;
+	int ret;
+
+	master = spi_alloc_master(&dev->dev, sizeof(struct sh_sci_spi));
+	if (master == NULL) {
+		dev_err(&dev->dev, "failed to allocate spi master\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	sp = spi_master_get_devdata(master);
+
+	platform_set_drvdata(dev, sp);
+	sp->info = dev->dev.platform_data;
+
+	/* setup spi bitbang adaptor */
+	sp->bitbang.master = spi_master_get(master);
+	sp->bitbang.master->bus_num = sp->info->bus_num;
+	sp->bitbang.master->num_chipselect = sp->info->num_chipselect;
+	sp->bitbang.chipselect = sh_sci_spi_chipselect;
+
+	sp->bitbang.txrx_word[SPI_MODE_0] = sh_sci_spi_txrx_mode0;
+	sp->bitbang.txrx_word[SPI_MODE_1] = sh_sci_spi_txrx_mode1;
+	sp->bitbang.txrx_word[SPI_MODE_2] = sh_sci_spi_txrx_mode2;
+	sp->bitbang.txrx_word[SPI_MODE_3] = sh_sci_spi_txrx_mode3;
+
+	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		ret = -ENOENT;
+		goto err1;
+	}
+	sp->membase = ioremap(r->start, r->end - r->start + 1);
+	if (!sp->membase) {
+		ret = -ENXIO;
+		goto err1;
+	}
+	sp->val = ioread8(SCSPTR(sp));
+	setbits(sp, PIN_INIT, 1);
+
+	ret = spi_bitbang_start(&sp->bitbang);
+	if (!ret)
+		return 0;
+
+	setbits(sp, PIN_INIT, 0);
+	iounmap(sp->membase);
+ err1:
+	spi_master_put(sp->bitbang.master);
+ err0:
+	return ret;
+}
+
+static int sh_sci_spi_remove(struct platform_device *dev)
+{
+	struct sh_sci_spi *sp = platform_get_drvdata(dev);
+
+	iounmap(sp->membase);
+	setbits(sp, PIN_INIT, 0);
+	spi_bitbang_stop(&sp->bitbang);
+	spi_master_put(sp->bitbang.master);
+	return 0;
+}
+
+static struct platform_driver sh_sci_spi_drv = {
+	.probe		= sh_sci_spi_probe,
+	.remove		= sh_sci_spi_remove,
+	.driver		= {
+		.name	= "spi_sh_sci",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init sh_sci_spi_init(void)
+{
+	return platform_driver_register(&sh_sci_spi_drv);
+}
+module_init(sh_sci_spi_init);
+
+static void __exit sh_sci_spi_exit(void)
+{
+	platform_driver_unregister(&sh_sci_spi_drv);
+}
+module_exit(sh_sci_spi_exit);
+
+MODULE_DESCRIPTION("SH SCI SPI Driver");
+MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

usb-dma-bounce-buffer-support-v3.patch
usb-dma-bounce-buffer-support-v3-checkpatch-fixes.patch
usb-dma-bounce-buffer-support-v3-fix.patch
usb-ohci-sm501-driver-v2.patch
usb-ohci-sm501-driver-v2-fix.patch
spi-superh-spi-using-sci.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
