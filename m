From: akpm@linux-foundation.org
Subject: + drivers-misc-add-driver-for-texas-instruments-dac7512.patch added to -mm tree
Date: Fri, 09 Oct 2009 21:53:04 -0700
Message-ID: <200910100453.n9A4r4Qm019691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbZJJEy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Oct 2009 00:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel@caiaq.de, dbrownell@users.sourceforge.net


The patch titled
     drivers/misc: add driver for Texas Instruments DAC7512
has been added to the -mm tree.  Its filename is
     drivers-misc-add-driver-for-texas-instruments-dac7512.patch

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
Subject: drivers/misc: add driver for Texas Instruments DAC7512
From: Daniel Mack <daniel@caiaq.de>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig      |   10 +++
 drivers/misc/Makefile     |    1 
 drivers/misc/ti_dac7512.c |  102 ++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+)

diff -puN drivers/misc/Kconfig~drivers-misc-add-driver-for-texas-instruments-dac7512 drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~drivers-misc-add-driver-for-texas-instruments-dac7512
+++ a/drivers/misc/Kconfig
@@ -301,6 +301,16 @@ config DS1682
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds1682.
 
+config TI_DAC7512
+	tristate "Texas Instruments DAC7512"
+	depends on SPI && SYSFS
+	help
+	  If you say yes here you get support for the Texas Instruments
+	  DAC7512 16-bit digital-to-analog converter.
+
+	  This driver can also be built as a module. If so, the module
+	  will be calles ti_dac7512.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff -puN drivers/misc/Makefile~drivers-misc-add-driver-for-texas-instruments-dac7512 drivers/misc/Makefile
--- a/drivers/misc/Makefile~drivers-misc-add-driver-for-texas-instruments-dac7512
+++ a/drivers/misc/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
+obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_HWLAT_DETECTOR)	+= hwlat_detector.o
 obj-y				+= eeprom/
diff -puN /dev/null drivers/misc/ti_dac7512.c
--- /dev/null
+++ a/drivers/misc/ti_dac7512.c
@@ -0,0 +1,102 @@
+/*
+ *  dac7512.c - Linux kernel module for
+ * 	Texas Instruments DAC7512
+ *
+ *  Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/spi/spi.h>
+
+#define DAC7512_DRV_NAME	"dac7512"
+#define DRIVER_VERSION		"1.0"
+
+static ssize_t dac7512_store_val(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	unsigned char tmp[2];
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	tmp[0] = val >> 8;
+	tmp[1] = val & 0xff;
+	spi_write(spi, tmp, sizeof(tmp));
+	return count;
+}
+
+static DEVICE_ATTR(value, S_IWUSR | S_IRUGO,
+		   NULL, dac7512_store_val);
+
+static struct attribute *dac7512_attributes[] = {
+	&dev_attr_value.attr,
+	NULL
+};
+
+static const struct attribute_group dac7512_attr_group = {
+	.attrs = dac7512_attributes,
+};
+
+static int __devinit dac7512_probe(struct spi_device *spi)
+{
+	int ret;
+
+	spi->bits_per_word = 8;
+	spi->mode = SPI_MODE_0;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	return sysfs_create_group(&spi->dev.kobj, &dac7512_attr_group);
+}
+
+static int __devexit dac7512_remove(struct spi_device *spi)
+{
+	sysfs_remove_group(&spi->dev.kobj, &dac7512_attr_group);
+	return 0;
+}
+
+static struct spi_driver dac7512_driver = {
+	.driver = {
+		.name	= DAC7512_DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= dac7512_probe,
+	.remove	= __devexit_p(dac7512_remove),
+};
+
+static int __init dac7512_init(void)
+{
+	return spi_register_driver(&dac7512_driver);
+}
+
+static void __exit dac7512_exit(void)
+{
+	spi_unregister_driver(&dac7512_driver);
+}
+
+MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
+MODULE_DESCRIPTION("DAC7512 16-bit DAC");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRIVER_VERSION);
+
+module_init(dac7512_init);
+module_exit(dac7512_exit);
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch

