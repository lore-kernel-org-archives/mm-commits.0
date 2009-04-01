From: akpm@linux-foundation.org
Subject: [merged] lis3-spi-transport-layer.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:18 -0700
Message-ID: <200904011841.n31IfIL3009295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351AbZDATlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:41:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, david-b@pacbell.net, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: SPI transport layer
has been removed from the -mm tree.  Its filename was
     lis3-spi-transport-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: SPI transport layer
From: Daniel Mack <daniel@caiaq.de>

Make use of the new abstraction layer and add a new transport layer for
spi.  Works fine on a PXA based board.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig         |   16 ++++
 drivers/hwmon/Makefile        |    1 
 drivers/hwmon/lis3lv02d_spi.c |  114 ++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+)

diff -puN drivers/hwmon/Kconfig~lis3-spi-transport-layer drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~lis3-spi-transport-layer
+++ a/drivers/hwmon/Kconfig
@@ -932,6 +932,22 @@ config SENSORS_LIS3LV02D
 	  Say Y here if you have an applicable laptop and want to experience
 	  the awesome power of lis3lv02d.
 
+config SENSORS_LIS3_SPI
+	tristate "STMicroeletronics LIS3LV02Dx three-axis digital accelerometer (SPI)"
+	depends on !ACPI && SPI_MASTER && INPUT
+	default n
+	help
+	  This driver provides support for the LIS3LV02Dx accelerometer connected
+	  via SPI. The accelerometer data is readable via
+	  /sys/devices/platform/lis3lv02d.
+
+	  This driver also provides an absolute input class device, allowing
+	  the laptop to act as a pinball machine-esque joystick.
+
+	  This driver can also be built as modules.  If so, the core module
+	  will be called lis3lv02d and a specific module for the SPI transport
+	  is called lis3lv02d_spi.
+
 config SENSORS_APPLESMC
 	tristate "Apple SMC (Motion sensor, light sensor, keyboard backlight)"
 	depends on INPUT && X86
diff -puN drivers/hwmon/Makefile~lis3-spi-transport-layer drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~lis3-spi-transport-layer
+++ a/drivers/hwmon/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
 obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
+obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
 obj-$(CONFIG_SENSORS_LM70)	+= lm70.o
 obj-$(CONFIG_SENSORS_LM75)	+= lm75.o
diff -puN /dev/null drivers/hwmon/lis3lv02d_spi.c
--- /dev/null
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -0,0 +1,114 @@
+/*
+ * lis3lv02d_spi - SPI glue layer for lis3lv02d
+ *
+ * Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/spi/spi.h>
+
+#include "lis3lv02d.h"
+
+#define DRV_NAME 	"lis3lv02d_spi"
+#define LIS3_SPI_READ	0x80
+
+static int lis3_spi_read(struct lis3lv02d *lis3, int reg, u8 *v)
+{
+	struct spi_device *spi = lis3->bus_priv;
+	int ret = spi_w8r8(spi, reg | LIS3_SPI_READ);
+	if (ret < 0)
+		return -EINVAL;
+
+	*v = (u8) ret;
+	return 0;
+}
+
+static int lis3_spi_write(struct lis3lv02d *lis3, int reg, u8 val)
+{
+	u8 tmp[2] = { reg, val };
+	struct spi_device *spi = lis3->bus_priv;
+	return spi_write(spi, tmp, sizeof(tmp));
+}
+
+static int lis3_spi_init(struct lis3lv02d *lis3)
+{
+	u8 reg;
+	int ret;
+
+	/* power up the device */
+	ret = lis3->read(lis3, CTRL_REG1, &reg);
+	if (ret < 0)
+		return ret;
+
+	reg |= CTRL1_PD0;
+	return lis3->write(lis3, CTRL_REG1, reg);
+}
+
+static struct axis_conversion lis3lv02d_axis_normal = { 1, 2, 3 };
+
+static int __devinit lis302dl_spi_probe(struct spi_device *spi)
+{
+	int ret;
+
+	spi->bits_per_word = 8;
+	spi->mode = SPI_MODE_0;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	lis3_dev.bus_priv = spi;
+	lis3_dev.init = lis3_spi_init;
+	lis3_dev.read = lis3_spi_read;
+	lis3_dev.write = lis3_spi_write;
+	lis3_dev.irq = spi->irq;
+	lis3_dev.ac = lis3lv02d_axis_normal;
+	spi_set_drvdata(spi, &lis3_dev);
+
+	ret = lis3lv02d_init_device(&lis3_dev);
+	return ret;
+}
+
+static int __devexit lis302dl_spi_remove(struct spi_device *spi)
+{
+	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
+	lis3lv02d_joystick_disable();
+	lis3lv02d_poweroff(lis3);
+	return 0;
+}
+
+static struct spi_driver lis302dl_spi_driver = {
+	.driver	 = {
+		.name   = DRV_NAME,
+		.owner  = THIS_MODULE,
+	},
+	.probe	= lis302dl_spi_probe,
+	.remove	= __devexit_p(lis302dl_spi_remove),
+};
+
+static int __init lis302dl_init(void)
+{
+	return spi_register_driver(&lis302dl_spi_driver);
+}
+
+static void __exit lis302dl_exit(void)
+{
+	spi_unregister_driver(&lis302dl_spi_driver);
+}
+
+module_init(lis302dl_init);
+module_exit(lis302dl_exit);
+
+MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
+MODULE_DESCRIPTION("lis3lv02d SPI glue layer");
+MODULE_LICENSE("GPL");
+
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch
w1-coding-style-cleanups-in-w1_ioc.patch

