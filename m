From: akpm@linux-foundation.org
Subject: - w1-add-1-wire-master-driver-for-imx27-imx31.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:42 -0800
Message-ID: <200901082250.n08Mog3l029881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763416AbZAHWvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, l.fu@pengutronix.de, rmk@arm.linux.org.uk, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     w1: add 1-wire master driver for i.MX27 / i.MX31
has been removed from the -mm tree.  Its filename was
     w1-add-1-wire-master-driver-for-imx27-imx31.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: add 1-wire master driver for i.MX27 / i.MX31
From: Sascha Hauer <s.hauer@pengutronix.de>

This patch adds support for the 1-wire master interface for i.MX27 and
i.MX31.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/w1/masters/00-INDEX |    2 
 Documentation/w1/masters/mxc-w1   |   11 +
 drivers/w1/masters/Kconfig        |    6 
 drivers/w1/masters/Makefile       |    2 
 drivers/w1/masters/mxc_w1.c       |  211 ++++++++++++++++++++++++++++
 5 files changed, 232 insertions(+)

diff -puN Documentation/w1/masters/00-INDEX~w1-add-1-wire-master-driver-for-imx27-imx31 Documentation/w1/masters/00-INDEX
--- a/Documentation/w1/masters/00-INDEX~w1-add-1-wire-master-driver-for-imx27-imx31
+++ a/Documentation/w1/masters/00-INDEX
@@ -4,5 +4,7 @@ ds2482
 	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
 ds2490
 	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
+mxc_w1
+	- W1 master controller driver found on Freescale MX2/MX3 SoCs
 w1-gpio
 	- GPIO 1-wire bus master driver.
diff -puN /dev/null Documentation/w1/masters/mxc-w1
--- /dev/null
+++ a/Documentation/w1/masters/mxc-w1
@@ -0,0 +1,11 @@
+Kernel driver mxc_w1
+====================
+
+Supported chips:
+  * Freescale MX27, MX31 and probably other i.MX SoCs
+    Datasheets:
+        http://www.freescale.com/files/32bit/doc/data_sheet/MCIMX31.pdf?fpsp=1
+	http://www.freescale.com/files/dsp/MCIMX27.pdf?fpsp=1
+
+Author: Originally based on Freescale code, prepared for mainline by
+	Sascha Hauer <s.hauer@pengutronix.de>
diff -puN drivers/w1/masters/Kconfig~w1-add-1-wire-master-driver-for-imx27-imx31 drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~w1-add-1-wire-master-driver-for-imx27-imx31
+++ a/drivers/w1/masters/Kconfig
@@ -34,6 +34,12 @@ config W1_MASTER_DS2482
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds2482.
 
+config W1_MASTER_MXC
+	tristate "Freescale MXC 1-wire busmaster"
+	depends on W1 && ARCH_MXC
+	help
+	  Say Y here to enable MXC 1-wire host
+
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
 	depends on W1 && ARM && HAVE_CLK
diff -puN drivers/w1/masters/Makefile~w1-add-1-wire-master-driver-for-imx27-imx31 drivers/w1/masters/Makefile
--- a/drivers/w1/masters/Makefile~w1-add-1-wire-master-driver-for-imx27-imx31
+++ a/drivers/w1/masters/Makefile
@@ -5,6 +5,8 @@
 obj-$(CONFIG_W1_MASTER_MATROX)		+= matrox_w1.o
 obj-$(CONFIG_W1_MASTER_DS2490)		+= ds2490.o
 obj-$(CONFIG_W1_MASTER_DS2482)		+= ds2482.o
+obj-$(CONFIG_W1_MASTER_MXC)		+= mxc_w1.o
+
 obj-$(CONFIG_W1_MASTER_DS1WM)		+= ds1wm.o
 obj-$(CONFIG_W1_MASTER_GPIO)		+= w1-gpio.o
 obj-$(CONFIG_HDQ_MASTER_OMAP)		+= omap_hdq.o
diff -puN /dev/null drivers/w1/masters/mxc_w1.c
--- /dev/null
+++ a/drivers/w1/masters/mxc_w1.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright 2005-2008 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008 Luotao Fu, kernel@pengutronix.de
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_log.h"
+
+/* According to the mx27 Datasheet the reset procedure should take up to about
+ * 1350us. We set the timeout to 500*100us = 50ms for sure */
+#define MXC_W1_RESET_TIMEOUT 500
+
+/*
+ * MXC W1 Register offsets
+ */
+#define MXC_W1_CONTROL          0x00
+#define MXC_W1_TIME_DIVIDER     0x02
+#define MXC_W1_RESET            0x04
+#define MXC_W1_COMMAND          0x06
+#define MXC_W1_TXRX             0x08
+#define MXC_W1_INTERRUPT        0x0A
+#define MXC_W1_INTERRUPT_EN     0x0C
+
+struct mxc_w1_device {
+	void __iomem *regs;
+	unsigned int clkdiv;
+	struct clk *clk;
+	struct w1_bus_master bus_master;
+};
+
+/*
+ * this is the low level routine to
+ * reset the device on the One Wire interface
+ * on the hardware
+ */
+static u8 mxc_w1_ds2_reset_bus(void *data)
+{
+	u8 reg_val;
+	unsigned int timeout_cnt = 0;
+	struct mxc_w1_device *dev = data;
+
+	__raw_writeb(0x80, (dev->regs + MXC_W1_CONTROL));
+
+	while (1) {
+		reg_val = __raw_readb(dev->regs + MXC_W1_CONTROL);
+
+		if (((reg_val >> 7) & 0x1) == 0 ||
+		    timeout_cnt > MXC_W1_RESET_TIMEOUT)
+			break;
+		else
+			timeout_cnt++;
+
+		udelay(100);
+	}
+	return (reg_val >> 7) & 0x1;
+}
+
+/*
+ * this is the low level routine to read/write a bit on the One Wire
+ * interface on the hardware. It does write 0 if parameter bit is set
+ * to 0, otherwise a write 1/read.
+ */
+static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
+{
+	struct mxc_w1_device *mdev = data;
+	void __iomem *ctrl_addr = mdev->regs + MXC_W1_CONTROL;
+	unsigned int timeout_cnt = 400; /* Takes max. 120us according to
+					 * datasheet.
+					 */
+
+	__raw_writeb((1 << (5 - bit)), ctrl_addr);
+
+	while (timeout_cnt--) {
+		if (!((__raw_readb(ctrl_addr) >> (5 - bit)) & 0x1))
+			break;
+
+		udelay(1);
+	}
+
+	return ((__raw_readb(ctrl_addr)) >> 3) & 0x1;
+}
+
+static int __init mxc_w1_probe(struct platform_device *pdev)
+{
+	struct mxc_w1_device *mdev;
+	struct resource *res;
+	int err = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	mdev = kzalloc(sizeof(struct mxc_w1_device), GFP_KERNEL);
+	if (!mdev)
+		return -ENOMEM;
+
+	mdev->clk = clk_get(&pdev->dev, "owire_clk");
+	if (!mdev->clk) {
+		err = -ENODEV;
+		goto failed_clk;
+	}
+
+	mdev->clkdiv = (clk_get_rate(mdev->clk) / 1000000) - 1;
+
+	res = request_mem_region(res->start, resource_size(res),
+				"mxc_w1");
+	if (!res) {
+		err = -EBUSY;
+		goto failed_req;
+	}
+
+	mdev->regs = ioremap(res->start, resource_size(res));
+	if (!mdev->regs) {
+		printk(KERN_ERR "Cannot map frame buffer registers\n");
+		goto failed_ioremap;
+	}
+
+	clk_enable(mdev->clk);
+	__raw_writeb(mdev->clkdiv, mdev->regs + MXC_W1_TIME_DIVIDER);
+
+	mdev->bus_master.data = mdev;
+	mdev->bus_master.reset_bus = mxc_w1_ds2_reset_bus;
+	mdev->bus_master.touch_bit = mxc_w1_ds2_touch_bit;
+
+	err = w1_add_master_device(&mdev->bus_master);
+
+	if (err)
+		goto failed_add;
+
+	platform_set_drvdata(pdev, mdev);
+	return 0;
+
+failed_add:
+	iounmap(mdev->regs);
+failed_ioremap:
+	release_mem_region(res->start, resource_size(res));
+failed_req:
+	clk_put(mdev->clk);
+failed_clk:
+	kfree(mdev);
+	return err;
+}
+
+/*
+ * disassociate the w1 device from the driver
+ */
+static int mxc_w1_remove(struct platform_device *pdev)
+{
+	struct mxc_w1_device *mdev = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	w1_remove_master_device(&mdev->bus_master);
+
+	iounmap(mdev->regs);
+	release_mem_region(res->start, resource_size(res));
+	clk_disable(mdev->clk);
+	clk_put(mdev->clk);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver mxc_w1_driver = {
+	.driver = {
+		   .name = "mxc_w1",
+	},
+	.probe = mxc_w1_probe,
+	.remove = mxc_w1_remove,
+};
+
+static int __init mxc_w1_init(void)
+{
+	return platform_driver_register(&mxc_w1_driver);
+}
+
+static void mxc_w1_exit(void)
+{
+	platform_driver_unregister(&mxc_w1_driver);
+}
+
+module_init(mxc_w1_init);
+module_exit(mxc_w1_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Freescale Semiconductors Inc");
+MODULE_DESCRIPTION("Driver for One-Wire on MXC");
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

origin.patch

