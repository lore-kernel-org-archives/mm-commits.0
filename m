From: akpm@linux-foundation.org
Subject: + gpio-add-mc33880-driver.patch added to -mm tree
Date: Mon, 22 Jun 2009 21:48:24 -0700
Message-ID: <200906230448.n5N4mOYf010939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbZFWEsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 00:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard.rojfors.ext@mocean-labs.com, david-b@pacbell.net


The patch titled
     gpio: add MC33880 driver
has been added to the -mm tree.  Its filename is
     gpio-add-mc33880-driver.patch

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
Subject: gpio: add MC33880 driver
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

A GPIO driver for the Freescale MC33880 High/Low side switch

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |    7 +
 drivers/gpio/Makefile       |    2=20
 drivers/gpio/mc33880.c      |  196 ++++++++++++++++++++++++++++++++++
 include/linux/spi/mc33880.h |   10 +
 4 files changed, 215 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-add-mc33880-driver drivers/gpio/Kco=
nfig
--- a/drivers/gpio/Kconfig~gpio-add-mc33880-driver
+++ a/drivers/gpio/Kconfig
@@ -182,4 +182,11 @@ config GPIO_MCP23S08
 	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
 	  a GPIO interface supporting inputs and outputs.
=20
+config GPIO_MC33880
+	tristate "Freescale MC33880 high-side/low-side switch"
+	depends on SPI_MASTER
+	help
+	  SPI driver for Freescale MC33880 high-side/low-side switch.
+	  This provides GPIO interface supporting inputs and outputs.
+
 endif
diff -puN drivers/gpio/Makefile~gpio-add-mc33880-driver drivers/gpio/Ma=
kefile
--- a/drivers/gpio/Makefile~gpio-add-mc33880-driver
+++ a/drivers/gpio/Makefile
@@ -13,3 +13,5 @@ obj-$(CONFIG_GPIO_PL061)	+=3D pl061.o
 obj-$(CONFIG_GPIO_TWL4030)	+=3D twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+=3D xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+=3D bt8xxgpio.o
+obj-$(CONFIG_GPIO_MC33880)	+=3D mc33880.o
+
diff -puN /dev/null drivers/gpio/mc33880.c
--- /dev/null
+++ a/drivers/gpio/mc33880.c
@@ -0,0 +1,196 @@
+/*
+ * mc33880.c MC33880 high-side/low-side switch GPIO driver
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
+ * Freescale MC33880 high-side/low-side switch
+ */
+
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/mc33880.h>
+#include <linux/gpio.h>
+
+#define DRIVER_NAME "mc33880"
+
+/*
+ * Pin configurations, see MAX7301 datasheet page 6
+ */
+#define PIN_CONFIG_MASK 0x03
+#define PIN_CONFIG_IN_PULLUP 0x03
+#define PIN_CONFIG_IN_WO_PULLUP 0x02
+#define PIN_CONFIG_OUT 0x01
+
+#define PIN_NUMBER 8
+
+
+/*
+ * Some registers must be read back to modify.
+ * To save time we cache them here in memory
+ */
+struct mc33880 {
+	struct mutex	lock;	/* protect from simultanous accesses */
+	u8		port_config;
+	struct gpio_chip chip;
+	struct spi_device *spi;
+};
+
+static int mc33880_write_config(struct mc33880 *mc)
+{
+	return spi_write(mc->spi, &mc->port_config, sizeof(mc->port_config));
+}
+
+
+static int __mc33880_set(struct mc33880 *mc, unsigned offset, int valu=
e)
+{
+	if (value)
+		mc->port_config |=3D 1 << offset;
+	else
+		mc->port_config &=3D ~(1 << offset);
+
+	return mc33880_write_config(mc);
+}
+
+
+static void mc33880_set(struct gpio_chip *chip, unsigned offset, int v=
alue)
+{
+	struct mc33880 *mc =3D container_of(chip, struct mc33880, chip);
+
+	mutex_lock(&mc->lock);
+
+	__mc33880_set(mc, offset, value);
+
+	mutex_unlock(&mc->lock);
+}
+
+static int __devinit mc33880_probe(struct spi_device *spi)
+{
+	struct mc33880 *mc;
+	struct mc33880_platform_data *pdata;
+	int ret;
+
+	pdata =3D spi->dev.platform_data;
+	if (!pdata || !pdata->base) {
+		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * bits_per_word cannot be configured in platform data
+	 */
+	spi->bits_per_word =3D 8;
+
+	ret =3D spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	mc =3D kzalloc(sizeof(struct mc33880), GFP_KERNEL);
+	if (!mc)
+		return -ENOMEM;
+
+	mutex_init(&mc->lock);
+
+	dev_set_drvdata(&spi->dev, mc);
+
+	mc->spi =3D spi;
+
+	mc->chip.label =3D DRIVER_NAME,
+	mc->chip.set =3D mc33880_set;
+	mc->chip.base =3D pdata->base;
+	mc->chip.ngpio =3D PIN_NUMBER;
+	mc->chip.can_sleep =3D 1;
+	mc->chip.dev =3D &spi->dev;
+	mc->chip.owner =3D THIS_MODULE;
+
+	mc->port_config =3D 0x00;
+	/* write twice, because during initialisation the first setting
+	 * is just for testing SPI communication, and the second is the
+	 * "real" configuration
+	 */
+	ret =3D mc33880_write_config(mc);
+	mc->port_config =3D 0x00;
+	if (!ret)
+		ret =3D mc33880_write_config(mc);
+
+	if (ret) {
+		printk(KERN_ERR "Failed writing to " DRIVER_NAME ": %d\n", ret);
+		goto exit_destroy;
+	}
+
+	ret =3D gpiochip_add(&mc->chip);
+	if (ret)
+		goto exit_destroy;
+
+	return ret;
+
+exit_destroy:
+	dev_set_drvdata(&spi->dev, NULL);
+	mutex_destroy(&mc->lock);
+	kfree(mc);
+	return ret;
+}
+
+static int mc33880_remove(struct spi_device *spi)
+{
+	struct mc33880 *mc;
+	int ret;
+
+	mc =3D dev_get_drvdata(&spi->dev);
+	if (mc =3D=3D NULL)
+		return -ENODEV;
+
+	dev_set_drvdata(&spi->dev, NULL);
+
+	ret =3D gpiochip_remove(&mc->chip);
+	if (!ret) {
+		mutex_destroy(&mc->lock);
+		kfree(mc);
+	} else
+		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
+			ret);
+
+	return ret;
+}
+
+static struct spi_driver mc33880_driver =3D {
+	.driver =3D {
+		.name		=3D DRIVER_NAME,
+		.owner		=3D THIS_MODULE,
+	},
+	.probe		=3D mc33880_probe,
+	.remove		=3D __devexit_p(mc33880_remove),
+};
+
+static int __init mc33880_init(void)
+{
+	return spi_register_driver(&mc33880_driver);
+}
+/* register after spi postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(mc33880_init);
+
+static void __exit mc33880_exit(void)
+{
+	spi_unregister_driver(&mc33880_driver);
+}
+module_exit(mc33880_exit);
+
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_LICENSE("GPL v2");
+
diff -puN /dev/null include/linux/spi/mc33880.h
--- /dev/null
+++ a/include/linux/spi/mc33880.h
@@ -0,0 +1,10 @@
+#ifndef LINUX_SPI_MC33880_H
+#define LINUX_SPI_MC33880_H
+
+struct mc33880_platform_data {
+	/* number assigned to the first GPIO */
+	unsigned	base;
+};
+
+#endif
+
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

origin.patch
gpio-add-mc33880-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
