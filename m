From: akpm@linux-foundation.org
Subject: + video-mmpdisp-add-spi-port-in-display-controller.patch added to -mm tree
Date: Wed, 30 Jan 2013 13:50:11 -0800
Message-ID: <20130130215011.D52C05A41FB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50603 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3A3VuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jan 2013 16:50:13 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so209688vcd.3
        for <mm-commits@vger.kernel.org>; Wed, 30 Jan 2013 13:50:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zzhu3@marvell.com, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, cldu@marvell.com, grant.likely@secretlab.ca, haojian.zhuang@gmail.com, ligq@marvell.com


The patch titled
     Subject: video: mmpdisp: add spi port in display controller
has been added to the -mm tree.  Its filename is
     video-mmpdisp-add-spi-port-in-display-controller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Zhu <zzhu3@marvell.com>
Subject: video: mmpdisp: add spi port in display controller

Add spi port support in mmp display controller.  This port is from display
controller and for panel usage.  This is driver implemented and registered
as a spi master.

Signed-off-by: Zhou Zhu <zzhu3@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Cc: Lisa Du <cldu@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mmp/hw/Kconfig    |    8 +
 drivers/video/mmp/hw/Makefile   |    1 
 drivers/video/mmp/hw/mmp_ctrl.c |    6 +
 drivers/video/mmp/hw/mmp_ctrl.h |    4 
 drivers/video/mmp/hw/mmp_spi.c  |  180 ++++++++++++++++++++++++++++++
 5 files changed, 199 insertions(+)

diff -puN drivers/video/mmp/hw/Kconfig~video-mmpdisp-add-spi-port-in-display-controller drivers/video/mmp/hw/Kconfig
--- a/drivers/video/mmp/hw/Kconfig~video-mmpdisp-add-spi-port-in-display-controller
+++ a/drivers/video/mmp/hw/Kconfig
@@ -9,4 +9,12 @@ config MMP_DISP_CONTROLLER
 		this controller is used on Marvell PXA910,
 		MMP2, MMP3, PXA988 chips
 
+config MMP_DISP_SPI
+	bool "mmp display controller spi port"
+	depends on MMP_DISP_CONTROLLER && SPI_MASTER
+	default y
+	help
+		Marvell MMP display hw controller spi port support
+		will register as a spi master for panel usage
+
 endif
diff -puN drivers/video/mmp/hw/Makefile~video-mmpdisp-add-spi-port-in-display-controller drivers/video/mmp/hw/Makefile
--- a/drivers/video/mmp/hw/Makefile~video-mmpdisp-add-spi-port-in-display-controller
+++ a/drivers/video/mmp/hw/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_MMP_DISP_CONTROLLER)  += mmp_ctrl.o
+obj-$(CONFIG_MMP_DISP_SPI)	   += mmp_spi.o
diff -puN drivers/video/mmp/hw/mmp_ctrl.c~video-mmpdisp-add-spi-port-in-display-controller drivers/video/mmp/hw/mmp_ctrl.c
--- a/drivers/video/mmp/hw/mmp_ctrl.c~video-mmpdisp-add-spi-port-in-display-controller
+++ a/drivers/video/mmp/hw/mmp_ctrl.c
@@ -535,6 +535,12 @@ static int mmphw_probe(struct platform_d
 		}
 	}
 
+#ifdef CONFIG_MMP_DISP_SPI
+	ret = lcd_spi_register(ctrl);
+	if (ret < 0)
+		goto failed_path_init;
+#endif
+
 	dev_info(ctrl->dev, "device init done\n");
 
 	return 0;
diff -puN drivers/video/mmp/hw/mmp_ctrl.h~video-mmpdisp-add-spi-port-in-display-controller drivers/video/mmp/hw/mmp_ctrl.h
--- a/drivers/video/mmp/hw/mmp_ctrl.h~video-mmpdisp-add-spi-port-in-display-controller
+++ a/drivers/video/mmp/hw/mmp_ctrl.h
@@ -1951,4 +1951,8 @@ static inline struct lcd_regs *path_regs
 		return NULL;
 	}
 }
+
+#ifdef CONFIG_MMP_DISP_SPI
+extern int lcd_spi_register(struct mmphw_ctrl *ctrl);
+#endif
 #endif	/* _MMP_CTRL_H_ */
diff -puN /dev/null drivers/video/mmp/hw/mmp_spi.c
--- /dev/null
+++ a/drivers/video/mmp/hw/mmp_spi.c
@@ -0,0 +1,180 @@
+/*
+ * linux/drivers/video/mmp/hw/mmp_spi.c
+ * using the spi in LCD controler for commands send
+ *
+ * Copyright (C) 2012 Marvell Technology Group Ltd.
+ * Authors:  Guoqing Li <ligq@marvell.com>
+ *          Lisa Du <cldu@marvell.com>
+ *          Zhou Zhu <zzhu3@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/spi/spi.h>
+#include "mmp_ctrl.h"
+
+/**
+ * spi_write - write command to the SPI port
+ * @data: can be 8/16/32-bit, MSB justified data to write.
+ * @len:  data length.
+ *
+ * Wait bus transfer complete IRQ.
+ * The caller is expected to perform the necessary locking.
+ *
+ * Returns:
+ *   %-ETIMEDOUT	timeout occurred
+ *   0			success
+ */
+static inline int lcd_spi_write(struct spi_device *spi, u32 data)
+{
+	int timeout = 100000, isr, ret = 0;
+	u32 tmp;
+	void *reg_base =
+		*(void **)spi_master_get_devdata(spi->master);
+
+	/* clear ISR */
+	writel_relaxed(~SPI_IRQ_MASK, reg_base + SPU_IRQ_ISR);
+
+	switch (spi->bits_per_word) {
+	case 8:
+		writel_relaxed((u8)data, reg_base + LCD_SPU_SPI_TXDATA);
+		break;
+	case 16:
+		writel_relaxed((u16)data, reg_base + LCD_SPU_SPI_TXDATA);
+		break;
+	case 32:
+		writel_relaxed((u32)data, reg_base + LCD_SPU_SPI_TXDATA);
+		break;
+	default:
+		dev_err(&spi->dev, "Wrong spi bit length\n");
+	}
+
+	/* SPI start to send command */
+	tmp = readl_relaxed(reg_base + LCD_SPU_SPI_CTRL);
+	tmp &= ~CFG_SPI_START_MASK;
+	tmp |= CFG_SPI_START(1);
+	writel(tmp, reg_base + LCD_SPU_SPI_CTRL);
+
+	isr = readl_relaxed(reg_base + SPU_IRQ_ISR);
+	while (!(isr & SPI_IRQ_ENA_MASK)) {
+		udelay(100);
+		isr = readl_relaxed(reg_base + SPU_IRQ_ISR);
+		if (!--timeout) {
+			ret = -ETIMEDOUT;
+			dev_err(&spi->dev, "spi cmd send time out\n");
+			break;
+		}
+	}
+
+	tmp = readl_relaxed(reg_base + LCD_SPU_SPI_CTRL);
+	tmp &= ~CFG_SPI_START_MASK;
+	tmp |= CFG_SPI_START(0);
+	writel_relaxed(tmp, reg_base + LCD_SPU_SPI_CTRL);
+
+	writel_relaxed(~SPI_IRQ_MASK, reg_base + SPU_IRQ_ISR);
+
+	return ret;
+}
+
+static int lcd_spi_setup(struct spi_device *spi)
+{
+	void *reg_base =
+		*(void **)spi_master_get_devdata(spi->master);
+	u32 tmp;
+
+	tmp = CFG_SCLKCNT(16) |
+		CFG_TXBITS(spi->bits_per_word) |
+		CFG_SPI_SEL(1) | CFG_SPI_ENA(1) |
+		CFG_SPI_3W4WB(1);
+	writel(tmp, reg_base + LCD_SPU_SPI_CTRL);
+
+	/*
+	 * After set mode it need a time to pull up the spi singals,
+	 * or it would cause the wrong waveform when send spi command,
+	 * especially on pxa910h
+	 */
+	tmp = readl_relaxed(reg_base + SPU_IOPAD_CONTROL);
+	if ((tmp & CFG_IOPADMODE_MASK) != IOPAD_DUMB18SPI)
+		writel_relaxed(IOPAD_DUMB18SPI |
+			(tmp & ~CFG_IOPADMODE_MASK),
+			reg_base + SPU_IOPAD_CONTROL);
+	udelay(20);
+	return 0;
+}
+
+static int lcd_spi_one_transfer(struct spi_device *spi, struct spi_message *m)
+{
+	struct spi_transfer *t;
+	int i;
+
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		switch (spi->bits_per_word) {
+		case 8:
+			for (i = 0; i < t->len; i++)
+				lcd_spi_write(spi, ((u8 *)t->tx_buf)[i]);
+			break;
+		case 16:
+			for (i = 0; i < t->len/2; i++)
+				lcd_spi_write(spi, ((u16 *)t->tx_buf)[i]);
+			break;
+		case 32:
+			for (i = 0; i < t->len/4; i++)
+				lcd_spi_write(spi, ((u32 *)t->tx_buf)[i]);
+			break;
+		default:
+			dev_err(&spi->dev, "Wrong spi bit length\n");
+		}
+	}
+
+	m->status = 0;
+	if (m->complete)
+		m->complete(m->context);
+	return 0;
+}
+
+int lcd_spi_register(struct mmphw_ctrl *ctrl)
+{
+	struct spi_master *master;
+	void **p_regbase;
+	int err;
+
+	master = spi_alloc_master(ctrl->dev, sizeof(void *));
+	if (!master) {
+		dev_err(ctrl->dev, "unable to allocate SPI master\n");
+		return -ENOMEM;
+	}
+	p_regbase = spi_master_get_devdata(master);
+	*p_regbase = ctrl->reg_base;
+
+	/* set bus num to 5 to avoid conflict with other spi hosts */
+	master->bus_num = 5;
+	master->num_chipselect = 1;
+	master->setup = lcd_spi_setup;
+	master->transfer = lcd_spi_one_transfer;
+
+	err = spi_register_master(master);
+	if (err < 0) {
+		dev_err(ctrl->dev, "unable to register SPI master\n");
+		spi_master_put(master);
+		return err;
+	}
+
+	dev_info(&master->dev, "registered\n");
+
+	return 0;
+}
_

Patches currently in -mm which might be from zzhu3@marvell.com are

video-mmp-display-subsystem.patch
video-mmp-fb-support.patch
video-mmp-display-controller-support.patch
video-mmp-add-tpo-hvga-panel-supported.patch
video-mmpdisp-add-spi-port-in-display-controller.patch
arm-mmp-add-device-for-display-controller.patch
arm-mmp-enable-display-in-ttc_dkb.patch
arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch

