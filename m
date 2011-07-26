From: akpm@linux-foundation.org
Subject: [merged] misc-eeprom-add-eeprom-access-driver-for-digsy_mtc-board.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:18 -0700
Message-ID: <201107260755.p6Q7tLgE003452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081Ab1GZH4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, grant.likely@secretlab.ca, jic23@cam.ac.uk, mm-commits@vger.kernel.org


The patch titled
     misc/eeprom: add eeprom access driver for digsy_mtc board
has been removed from the -mm tree.  Its filename was
     misc-eeprom-add-eeprom-access-driver-for-digsy_mtc-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc/eeprom: add eeprom access driver for digsy_mtc board
From: Anatolij Gustschin <agust@denx.de>

Both displays on digsy_mtc board obtain their configuration from microwire
EEPROMs which are connected to the SoC over GPIO lines.  We need an easy
way to access the EEPROMs to write the needed display configuration or to
read out the currently programmed configuration.  The generic
eeprom_93xx46 SPI driver added by previous patch allows EEPROM access over
sysfs.  Using the simple driver added by this patch we provide used GPIO
interface and access control description on the board for generic
eeprom_93xx46 driver and spi_gpio driver.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/Kconfig            |   12 +++
 drivers/misc/eeprom/Makefile           |    1 
 drivers/misc/eeprom/digsy_mtc_eeprom.c |   85 +++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff -puN drivers/misc/eeprom/Kconfig~misc-eeprom-add-eeprom-access-driver-for-digsy_mtc-board drivers/misc/eeprom/Kconfig
--- a/drivers/misc/eeprom/Kconfig~misc-eeprom-add-eeprom-access-driver-for-digsy_mtc-board
+++ a/drivers/misc/eeprom/Kconfig
@@ -83,4 +83,16 @@ config EEPROM_93XX46
 
 	  If unsure, say N.
 
+config EEPROM_DIGSY_MTC_CFG
+	bool "DigsyMTC display configuration EEPROMs device"
+	depends on PPC_MPC5200_GPIO && GPIOLIB && SPI_GPIO
+	help
+	  This option enables access to display configuration EEPROMs
+	  on digsy_mtc board. You have to additionally select Microwire
+	  EEPROM 93XX46 driver. sysfs entries will be created for that
+	  EEPROM allowing to read/write the configuration data or to
+	  erase the whole EEPROM.
+
+	  If unsure, say N.
+
 endmenu
diff -puN drivers/misc/eeprom/Makefile~misc-eeprom-add-eeprom-access-driver-for-digsy_mtc-board drivers/misc/eeprom/Makefile
--- a/drivers/misc/eeprom/Makefile~misc-eeprom-add-eeprom-access-driver-for-digsy_mtc-board
+++ a/drivers/misc/eeprom/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
 obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
 obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
+obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
diff -puN /dev/null drivers/misc/eeprom/digsy_mtc_eeprom.c
--- /dev/null
+++ a/drivers/misc/eeprom/digsy_mtc_eeprom.c
@@ -0,0 +1,85 @@
+/*
+ * EEPROMs access control driver for display configuration EEPROMs
+ * on DigsyMTC board.
+ *
+ * (C) 2011 DENX Software Engineering, Anatolij Gustschin <agust@denx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_gpio.h>
+#include <linux/eeprom_93xx46.h>
+
+#define GPIO_EEPROM_CLK		216
+#define GPIO_EEPROM_CS		210
+#define GPIO_EEPROM_DI		217
+#define GPIO_EEPROM_DO		249
+#define GPIO_EEPROM_OE		255
+#define EE_SPI_BUS_NUM	1
+
+static void digsy_mtc_op_prepare(void *p)
+{
+	/* enable */
+	gpio_set_value(GPIO_EEPROM_OE, 0);
+}
+
+static void digsy_mtc_op_finish(void *p)
+{
+	/* disable */
+	gpio_set_value(GPIO_EEPROM_OE, 1);
+}
+
+struct eeprom_93xx46_platform_data digsy_mtc_eeprom_data = {
+	.flags		= EE_ADDR8,
+	.prepare	= digsy_mtc_op_prepare,
+	.finish		= digsy_mtc_op_finish,
+};
+
+static struct spi_gpio_platform_data eeprom_spi_gpio_data = {
+	.sck		= GPIO_EEPROM_CLK,
+	.mosi		= GPIO_EEPROM_DI,
+	.miso		= GPIO_EEPROM_DO,
+	.num_chipselect	= 1,
+};
+
+static struct platform_device digsy_mtc_eeprom = {
+	.name	= "spi_gpio",
+	.id	= EE_SPI_BUS_NUM,
+	.dev	= {
+		.platform_data	= &eeprom_spi_gpio_data,
+	},
+};
+
+static struct spi_board_info digsy_mtc_eeprom_info[] __initdata = {
+	{
+		.modalias		= "93xx46",
+		.max_speed_hz		= 1000000,
+		.bus_num		= EE_SPI_BUS_NUM,
+		.chip_select		= 0,
+		.mode			= SPI_MODE_0,
+		.controller_data	= (void *)GPIO_EEPROM_CS,
+		.platform_data		= &digsy_mtc_eeprom_data,
+	},
+};
+
+static int __init digsy_mtc_eeprom_devices_init(void)
+{
+	int ret;
+
+	ret = gpio_request_one(GPIO_EEPROM_OE, GPIOF_OUT_INIT_HIGH,
+				"93xx46 EEPROMs OE");
+	if (ret) {
+		pr_err("can't request gpio %d\n", GPIO_EEPROM_OE);
+		return ret;
+	}
+	spi_register_board_info(digsy_mtc_eeprom_info,
+				ARRAY_SIZE(digsy_mtc_eeprom_info));
+	return platform_device_register(&digsy_mtc_eeprom);
+}
+device_initcall(digsy_mtc_eeprom_devices_init);
_

Patches currently in -mm which might be from agust@denx.de are

origin.patch
linux-next.patch

