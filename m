From: akpm@linux-foundation.org
Subject: - fb-add-support-for-the-ili9320-video-display-controller.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:51 -0700
Message-ID: <200807242332.m6ONWp3P011872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860AbYGXXd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     fb: add support for the ILI9320 video display controller
has been removed from the -mm tree.  Its filename was
     fb-add-support-for-the-ili9320-video-display-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: add support for the ILI9320 video display controller
From: Ben Dooks <ben-linux@fluff.org>

Provide support for the ILI9320 display controller chip which is found in
many LCD displays.  Included with this is support for an example LCD using
this chip, the VGG2432A4.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig     |   17 +
 drivers/video/backlight/Makefile    |    4 
 drivers/video/backlight/ili9320.c   |  330 ++++++++++++++++++++++++++
 drivers/video/backlight/ili9320.h   |   80 ++++++
 drivers/video/backlight/vgg2432a4.c |  284 ++++++++++++++++++++++
 include/video/ili9320.h             |  201 +++++++++++++++
 6 files changed, 915 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/Kconfig~fb-add-support-for-the-ili9320-video-display-controller drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~fb-add-support-for-the-ili9320-video-display-controller
+++ a/drivers/video/backlight/Kconfig
@@ -36,6 +36,23 @@ config LCD_LTV350QV
 
 	  The LTV350QV panel is present on all ATSTK1000 boards.
 
+config LCD_ILI9320
+	tristate
+	depends on LCD_CLASS_DEVICE && BACKLIGHT_LCD_SUPPORT
+	default n
+	help
+	  If you have a panel based on the ILI9320 controller chip
+	  then say y to include a power driver for it.
+
+config LCD_VGG2432A4
+	tristate "VGG2432A4 LCM device support"
+	depends on BACKLIGHT_LCD_SUPPORT && LCD_CLASS_DEVICE && SPI_MASTER
+	select LCD_ILI9320
+	default n
+	help
+	  If you have a VGG2432A4 panel based on the ILI9320 controller chip
+	  then say y to include a power driver for it.
+
 #
 # Backlight
 #
diff -puN drivers/video/backlight/Makefile~fb-add-support-for-the-ili9320-video-display-controller drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~fb-add-support-for-the-ili9320-video-display-controller
+++ a/drivers/video/backlight/Makefile
@@ -1,7 +1,9 @@
 # Backlight & LCD drivers
 
 obj-$(CONFIG_LCD_CLASS_DEVICE)     += lcd.o
-obj-$(CONFIG_LCD_LTV350QV)	+= ltv350qv.o
+obj-$(CONFIG_LCD_LTV350QV)	   += ltv350qv.o
+obj-$(CONFIG_LCD_ILI9320)	   += ili9320.o
+obj-$(CONFIG_LCD_VGG2432A4)	   += vgg2432a4.o
 
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
 obj-$(CONFIG_BACKLIGHT_CORGI)	+= corgi_bl.o
diff -puN /dev/null drivers/video/backlight/ili9320.c
--- /dev/null
+++ a/drivers/video/backlight/ili9320.c
@@ -0,0 +1,330 @@
+/* drivers/video/backlight/ili9320.c
+ *
+ * ILI9320 LCD controller driver core.
+ *
+ * Copyright 2007 Simtec Electronics
+ *	http://armlinux.simtec.co.uk/
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/lcd.h>
+#include <linux/module.h>
+
+#include <linux/spi/spi.h>
+
+#include <video/ili9320.h>
+
+#include "ili9320.h"
+
+
+static inline int ili9320_write_spi(struct ili9320 *ili,
+				    unsigned int reg,
+				    unsigned int value)
+{
+	struct ili9320_spi *spi = &ili->access.spi;
+	unsigned char *addr = spi->buffer_addr;
+	unsigned char *data = spi->buffer_data;
+
+	/* spi message consits of:
+	 * first byte: ID and operation
+	 */
+
+	addr[0] = spi->id | ILI9320_SPI_INDEX | ILI9320_SPI_WRITE;
+	addr[1] = reg >> 8;
+	addr[2] = reg;
+
+	/* second message is the data to transfer */
+
+	data[0] = spi->id | ILI9320_SPI_DATA  | ILI9320_SPI_WRITE;
+ 	data[1] = value >> 8;
+	data[2] = value;
+
+	return spi_sync(spi->dev, &spi->message);
+}
+
+int ili9320_write(struct ili9320 *ili, unsigned int reg, unsigned int value)
+{
+	dev_dbg(ili->dev, "write: reg=%02x, val=%04x\n", reg, value);
+	return ili->write(ili, reg, value);
+}
+
+EXPORT_SYMBOL_GPL(ili9320_write);
+
+int ili9320_write_regs(struct ili9320 *ili,
+		       struct ili9320_reg *values,
+		       int nr_values)
+{
+	int index;
+	int ret;
+
+	for (index = 0; index < nr_values; index++, values++) {
+		ret = ili9320_write(ili, values->address, values->value);
+		if (ret != 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ili9320_write_regs);
+
+static void ili9320_reset(struct ili9320 *lcd)
+{
+	struct ili9320_platdata *cfg = lcd->platdata;
+
+	cfg->reset(1);
+	mdelay(50);
+
+	cfg->reset(0);
+	mdelay(50);
+
+	cfg->reset(1);
+	mdelay(100);
+}
+
+static inline int ili9320_init_chip(struct ili9320 *lcd)
+{
+	int ret;
+
+	ili9320_reset(lcd);
+
+	ret = lcd->client->init(lcd, lcd->platdata);
+	if (ret != 0) {
+		dev_err(lcd->dev, "failed to initialise display\n");
+		return ret;
+	}
+
+	lcd->initialised = 1;
+	return 0;
+}
+
+static inline int ili9320_power_on(struct ili9320 *lcd)
+{
+	if (!lcd->initialised)
+		ili9320_init_chip(lcd);
+
+	lcd->display1 |= (ILI9320_DISPLAY1_D(3) | ILI9320_DISPLAY1_BASEE);
+	ili9320_write(lcd, ILI9320_DISPLAY1, lcd->display1);
+
+	return 0;
+}
+
+static inline int ili9320_power_off(struct ili9320 *lcd)
+{
+	lcd->display1 &= ~(ILI9320_DISPLAY1_D(3) | ILI9320_DISPLAY1_BASEE);
+	ili9320_write(lcd, ILI9320_DISPLAY1, lcd->display1);
+
+	return 0;
+}
+
+#define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
+
+static int ili9320_power(struct ili9320 *lcd, int power)
+{
+	int ret = 0;
+
+	dev_dbg(lcd->dev, "power %d => %d\n", lcd->power, power);
+
+	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
+		ret = ili9320_power_on(lcd);
+	else if (!POWER_IS_ON(power) && POWER_IS_ON(lcd->power))
+		ret = ili9320_power_off(lcd);
+
+	if (ret == 0)
+		lcd->power = power;
+	else
+		dev_warn(lcd->dev, "failed to set power mode %d\n", power);
+
+	return ret;
+}
+
+static inline struct ili9320 *to_our_lcd(struct lcd_device *lcd)
+{
+	return lcd_get_data(lcd);
+}
+
+static int ili9320_set_power(struct lcd_device *ld, int power)
+{
+	struct ili9320 *lcd = to_our_lcd(ld);
+
+	return ili9320_power(lcd, power);
+}
+
+static int ili9320_get_power(struct lcd_device *ld)
+{
+	struct ili9320 *lcd = to_our_lcd(ld);
+
+	return lcd->power;
+}
+
+static struct lcd_ops ili9320_ops = {
+	.get_power	= ili9320_get_power,
+	.set_power	= ili9320_set_power,
+};
+
+static void __devinit ili9320_setup_spi(struct ili9320 *ili,
+					struct spi_device *dev)
+{
+	struct ili9320_spi *spi = &ili->access.spi;
+
+	ili->write = ili9320_write_spi;
+	spi->dev = dev;
+
+	/* fill the two messages we are going to use to send the data
+	 * with, the first the address followed by the data. The datasheet
+	 * says they should be done as two distinct cycles of the SPI CS line.
+	 */
+
+	spi->xfer[0].tx_buf = spi->buffer_addr;
+	spi->xfer[1].tx_buf = spi->buffer_data;
+	spi->xfer[0].len = 3;
+	spi->xfer[1].len = 3;
+	spi->xfer[0].bits_per_word = 8;
+	spi->xfer[1].bits_per_word = 8;
+	spi->xfer[0].cs_change = 1;
+
+	spi_message_init(&spi->message);
+	spi_message_add_tail(&spi->xfer[0], &spi->message);
+	spi_message_add_tail(&spi->xfer[1], &spi->message);
+}
+
+int __devinit ili9320_probe_spi(struct spi_device *spi,
+				struct ili9320_client *client)
+{
+	struct ili9320_platdata *cfg = spi->dev.platform_data;
+	struct device *dev = &spi->dev;
+	struct ili9320 *ili;
+	struct lcd_device *lcd;
+	int ret = 0;
+
+	/* verify we where given some information */
+
+	if (cfg == NULL) {
+		dev_err(dev, "no platform data supplied\n");
+		return -EINVAL;
+	}
+
+	if (cfg->hsize <= 0 || cfg->vsize <= 0 || cfg->reset == NULL) {
+		dev_err(dev, "invalid platform data supplied\n");
+		return -EINVAL;
+	}
+
+	/* allocate and initialse our state */
+
+	ili = kzalloc(sizeof(struct ili9320), GFP_KERNEL);
+	if (ili == NULL) {
+		dev_err(dev, "no memory for device\n");
+		return -ENOMEM;
+	}
+
+	ili->access.spi.id = ILI9320_SPI_IDCODE | ILI9320_SPI_ID(1);
+
+	ili->dev = dev;
+	ili->client = client;
+	ili->power = FB_BLANK_POWERDOWN;
+	ili->platdata = cfg;
+
+	dev_set_drvdata(&spi->dev, ili);
+
+	ili9320_setup_spi(ili, spi);
+
+	lcd = lcd_device_register("ili9320", dev, ili, &ili9320_ops);
+	if (IS_ERR(lcd)) {
+		dev_err(dev, "failed to register lcd device\n");
+		ret = PTR_ERR(lcd);
+		goto err_free;
+	}
+
+	ili->lcd = lcd;
+
+	dev_info(dev, "initialising %s\n", client->name);
+
+	ret = ili9320_power(ili, FB_BLANK_UNBLANK);
+	if (ret != 0) {
+		dev_err(dev, "failed to set lcd power state\n");
+		goto err_unregister;
+	}
+
+	return 0;
+
+ err_unregister:
+	lcd_device_unregister(lcd);
+
+ err_free:
+	kfree(ili);
+
+	return ret;
+}
+
+EXPORT_SYMBOL_GPL(ili9320_probe_spi);
+
+int __devexit ili9320_remove(struct ili9320 *ili)
+{
+	ili9320_power(ili, FB_BLANK_POWERDOWN);
+
+	lcd_device_unregister(ili->lcd);
+	kfree(ili);
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ili9320_remove);
+
+#ifdef CONFIG_PM
+int ili9320_suspend(struct ili9320 *lcd, pm_message_t state)
+{
+	int ret;
+
+	dev_dbg(lcd->dev, "%s: event %d\n", __func__, state.event);
+
+	if (state.event == PM_EVENT_SUSPEND) {
+		ret = ili9320_power(lcd, FB_BLANK_POWERDOWN);
+
+		if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
+			ili9320_write(lcd, ILI9320_POWER1, lcd->power1 |
+				      ILI9320_POWER1_SLP |
+				      ILI9320_POWER1_DSTB);
+			lcd->initialised = 0;
+		}
+
+		return ret;
+	}
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(ili9320_suspend);
+
+int ili9320_resume(struct ili9320 *lcd)
+{
+	dev_info(lcd->dev, "resuming from power state %d\n", lcd->power);
+
+	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
+		ili9320_write(lcd, ILI9320_POWER1, 0x00);
+	}
+
+	return ili9320_power(lcd, FB_BLANK_UNBLANK);
+}
+
+EXPORT_SYMBOL_GPL(ili9320_resume);
+#endif
+
+/* Power down all displays on reboot, poweroff or halt */
+void ili9320_shutdown(struct ili9320 *lcd)
+{
+	ili9320_power(lcd, FB_BLANK_POWERDOWN);
+}
+
+EXPORT_SYMBOL_GPL(ili9320_shutdown);
+
+MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
+MODULE_DESCRIPTION("ILI9320 LCD Driver");
+MODULE_LICENSE("GPL v2");
diff -puN /dev/null drivers/video/backlight/ili9320.h
--- /dev/null
+++ a/drivers/video/backlight/ili9320.h
@@ -0,0 +1,80 @@
+/* drivers/video/backlight/ili9320.h
+ *
+ * ILI9320 LCD controller driver core.
+ *
+ * Copyright 2007 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * http://armlinux.simtec.co.uk/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/* Holder for register and value pairs. */
+struct ili9320_reg {
+	unsigned short		address;
+	unsigned short		value;
+};
+
+struct ili9320;
+
+struct ili9320_client {
+	const char	*name;
+	int	(*init)(struct ili9320 *ili, struct ili9320_platdata *cfg);
+
+};
+/* Device attached via an SPI bus. */
+struct  ili9320_spi {
+	struct spi_device	*dev;
+	struct spi_message	message;
+	struct spi_transfer	xfer[2];
+
+	unsigned char		id;
+	unsigned char		buffer_addr[4];
+	unsigned char		buffer_data[4];
+};
+
+/* ILI9320 device state. */
+struct ili9320 {
+	union {
+		struct ili9320_spi	spi;	/* SPI attachged device. */
+	} access;				/* Register access method. */
+
+	struct device			*dev;
+	struct lcd_device		*lcd;	/* LCD device we created. */
+	struct ili9320_client		*client;
+	struct ili9320_platdata		*platdata;
+
+	int				 power; /* current power state. */
+	int				 initialised;
+
+	unsigned short			 display1;
+	unsigned short			 power1;
+
+	int (*write)(struct ili9320 *ili, unsigned int reg, unsigned int val);
+};
+
+
+/* ILI9320 register access routines */
+
+extern int ili9320_write(struct ili9320 *ili,
+			 unsigned int reg, unsigned int value);
+
+extern int ili9320_write_regs(struct ili9320 *ili,
+			      struct ili9320_reg *values,
+			      int nr_values);
+
+/* Device probe */
+
+extern int ili9320_probe_spi(struct spi_device *spi,
+			     struct ili9320_client *cli);
+
+extern int ili9320_remove(struct ili9320 *lcd);
+extern void ili9320_shutdown(struct ili9320 *lcd);
+
+/* PM */
+
+extern int ili9320_suspend(struct ili9320 *lcd, pm_message_t state);
+extern int ili9320_resume(struct ili9320 *lcd);
diff -puN /dev/null drivers/video/backlight/vgg2432a4.c
--- /dev/null
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -0,0 +1,284 @@
+/* drivers/video/backlight/vgg2432a4.c
+ *
+ * VGG2432A4 (ILI9320) LCD controller driver.
+ *
+ * Copyright 2007 Simtec Electronics
+ *	http://armlinux.simtec.co.uk/
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/lcd.h>
+#include <linux/module.h>
+
+#include <linux/spi/spi.h>
+
+#include <video/ili9320.h>
+
+#include "ili9320.h"
+
+/* Device initialisation sequences */
+
+static struct ili9320_reg vgg_init1[] = {
+	{
+		.address = ILI9320_POWER1,
+		.value	 = ILI9320_POWER1_AP(0) | ILI9320_POWER1_BT(0),
+	}, {
+		.address = ILI9320_POWER2,
+		.value	 = (ILI9320_POWER2_VC(7) |
+			    ILI9320_POWER2_DC0(0) | ILI9320_POWER2_DC1(0)),
+	}, {
+		.address = ILI9320_POWER3,
+		.value	 = ILI9320_POWER3_VRH(0),
+	}, {
+		.address = ILI9320_POWER4,
+		.value	 = ILI9320_POWER4_VREOUT(0),
+	},
+};
+
+static struct ili9320_reg vgg_init2[] = {
+	{
+		.address = ILI9320_POWER1,
+		.value   = (ILI9320_POWER1_AP(3) | ILI9320_POWER1_APE |
+			    ILI9320_POWER1_BT(7) | ILI9320_POWER1_SAP),
+	}, {
+		.address = ILI9320_POWER2,
+		.value   = ILI9320_POWER2_VC(7) | ILI9320_POWER2_DC0(3),
+	}
+};
+
+static struct ili9320_reg vgg_gamma[] = {
+	{
+		.address = ILI9320_GAMMA1,
+		.value	 = 0x0000,
+	}, {
+		.address = ILI9320_GAMMA2,
+		.value   = 0x0505,
+	}, {
+		.address = ILI9320_GAMMA3,
+		.value	 = 0x0004,
+	}, {
+		.address = ILI9320_GAMMA4,
+		.value	 = 0x0006,
+	}, {
+		.address = ILI9320_GAMMA5,
+		.value	 = 0x0707,
+	}, {
+		.address = ILI9320_GAMMA6,
+		.value	 = 0x0105,
+	}, {
+		.address = ILI9320_GAMMA7,
+		.value	 = 0x0002,
+	}, {
+		.address = ILI9320_GAMMA8,
+		.value	 = 0x0707,
+	}, {
+		.address = ILI9320_GAMMA9,
+		.value	 = 0x0704,
+	}, {
+		.address = ILI9320_GAMMA10,
+		.value	 = 0x807,
+	}
+
+};
+
+static struct ili9320_reg vgg_init0[] = {
+	[0]	= {
+		/* set direction and scan mode gate */
+		.address = ILI9320_DRIVER,
+		.value	 = ILI9320_DRIVER_SS,
+	}, {
+		.address = ILI9320_DRIVEWAVE,
+		.value	 = (ILI9320_DRIVEWAVE_MUSTSET |
+			    ILI9320_DRIVEWAVE_EOR | ILI9320_DRIVEWAVE_BC),
+	}, {
+		.address = ILI9320_ENTRYMODE,
+		.value	 = ILI9320_ENTRYMODE_ID(3) | ILI9320_ENTRYMODE_BGR,
+	}, {
+		.address = ILI9320_RESIZING,
+		.value	 = 0x0,
+	},
+};
+
+
+static int vgg2432a4_lcd_init(struct ili9320 *lcd,
+			      struct ili9320_platdata *cfg)
+{
+	unsigned int addr;
+	int ret;
+
+	/* Set VCore before anything else (VGG243237-6UFLWA) */
+	ret = ili9320_write(lcd, 0x00e5, 0x8000);
+	if (ret)
+		goto err_initial;
+
+	/* Start the oscillator up before we can do anything else. */
+	ret = ili9320_write(lcd, ILI9320_OSCILATION, ILI9320_OSCILATION_OSC);
+	if (ret)
+		goto err_initial;
+
+	/* must wait at-lesat 10ms after starting */
+	mdelay(15);
+
+	ret = ili9320_write_regs(lcd, vgg_init0, ARRAY_SIZE(vgg_init0));
+	if (ret != 0)
+		goto err_initial;
+
+	ili9320_write(lcd, ILI9320_DISPLAY2, cfg->display2);
+	ili9320_write(lcd, ILI9320_DISPLAY3, cfg->display3);
+	ili9320_write(lcd, ILI9320_DISPLAY4, cfg->display4);
+
+	ili9320_write(lcd, ILI9320_RGB_IF1, cfg->rgb_if1);
+	ili9320_write(lcd, ILI9320_FRAMEMAKER, 0x0);
+	ili9320_write(lcd, ILI9320_RGB_IF2, ILI9320_RGBIF2_DPL);
+
+	ret = ili9320_write_regs(lcd, vgg_init1, ARRAY_SIZE(vgg_init1));
+	if (ret != 0)
+		goto err_vgg;
+
+	mdelay(300);
+
+	ret = ili9320_write_regs(lcd, vgg_init2, ARRAY_SIZE(vgg_init2));
+	if (ret != 0)
+		goto err_vgg2;
+
+	mdelay(100);
+
+	ili9320_write(lcd, ILI9320_POWER3, 0x13c);
+
+	mdelay(100);
+
+	ili9320_write(lcd, ILI9320_POWER4, 0x1c00);
+	ili9320_write(lcd, ILI9320_POWER7, 0x000e);
+
+	mdelay(100);
+
+	ili9320_write(lcd, ILI9320_GRAM_HORIZ_ADDR, 0x00);
+	ili9320_write(lcd, ILI9320_GRAM_VERT_ADD, 0x00);
+
+	ret = ili9320_write_regs(lcd, vgg_gamma, ARRAY_SIZE(vgg_gamma));
+	if (ret != 0)
+		goto err_vgg3;
+
+	ili9320_write(lcd, ILI9320_HORIZ_START, 0x0);
+	ili9320_write(lcd, ILI9320_HORIZ_END, cfg->hsize - 1);
+	ili9320_write(lcd, ILI9320_VERT_START, 0x0);
+	ili9320_write(lcd, ILI9320_VERT_END, cfg->vsize - 1);
+
+	ili9320_write(lcd, ILI9320_DRIVER2,
+		      ILI9320_DRIVER2_NL(((cfg->vsize - 240) / 8) + 0x1D));
+
+	ili9320_write(lcd, ILI9320_BASE_IMAGE, 0x1);
+	ili9320_write(lcd, ILI9320_VERT_SCROLL, 0x00);
+
+	for (addr = ILI9320_PARTIAL1_POSITION; addr <= ILI9320_PARTIAL2_END;
+	     addr++) {
+		ili9320_write(lcd, addr, 0x0);
+	}
+
+	ili9320_write(lcd, ILI9320_INTERFACE1, 0x10);
+	ili9320_write(lcd, ILI9320_INTERFACE2, cfg->interface2);
+	ili9320_write(lcd, ILI9320_INTERFACE3, cfg->interface3);
+	ili9320_write(lcd, ILI9320_INTERFACE4, cfg->interface4);
+	ili9320_write(lcd, ILI9320_INTERFACE5, cfg->interface5);
+	ili9320_write(lcd, ILI9320_INTERFACE6, cfg->interface6);
+
+	lcd->display1 = (ILI9320_DISPLAY1_D(3) | ILI9320_DISPLAY1_DTE |
+			 ILI9320_DISPLAY1_GON | ILI9320_DISPLAY1_BASEE |
+			 0x40);
+
+	ili9320_write(lcd, ILI9320_DISPLAY1, lcd->display1);
+
+	return 0;
+
+ err_vgg3:
+ err_vgg2:
+ err_vgg:
+ err_initial:
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int vgg2432a4_suspend(struct spi_device *spi, pm_message_t state)
+{
+	return ili9320_suspend(dev_get_drvdata(&spi->dev), state);
+}
+
+static int vgg2432a4_resume(struct spi_device *spi)
+{
+	return ili9320_resume(dev_get_drvdata(&spi->dev));
+}
+#else
+#define vgg2432a4_suspend	NULL
+#define vgg2432a4_resume 	NULL
+#endif
+
+static struct ili9320_client vgg2432a4_client = {
+	.name	= "VGG2432A4",
+	.init	= vgg2432a4_lcd_init,
+};
+
+/* Device probe */
+
+static int __devinit vgg2432a4_probe(struct spi_device *spi)
+{
+	int ret;
+
+	ret = ili9320_probe_spi(spi, &vgg2432a4_client);
+	if (ret != 0) {
+		dev_err(&spi->dev, "failed to initialise ili9320\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devexit vgg2432a4_remove(struct spi_device *spi)
+{
+	return ili9320_remove(dev_get_drvdata(&spi->dev));
+}
+
+static void vgg2432a4_shutdown(struct spi_device *spi)
+{
+	ili9320_shutdown(dev_get_drvdata(&spi->dev));
+}
+
+static struct spi_driver vgg2432a4_driver = {
+	.driver = {
+		.name		= "VGG2432A4",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= vgg2432a4_probe,
+	.remove		= __devexit_p(vgg2432a4_remove),
+	.shutdown	= vgg2432a4_shutdown,
+	.suspend	= vgg2432a4_suspend,
+	.resume		= vgg2432a4_resume,
+};
+
+/* Device driver initialisation */
+
+static int __init vgg2432a4_init(void)
+{
+	return spi_register_driver(&vgg2432a4_driver);
+}
+
+static void __exit vgg2432a4_exit(void)
+{
+	spi_unregister_driver(&vgg2432a4_driver);
+}
+
+module_init(vgg2432a4_init);
+module_exit(vgg2432a4_exit);
+
+MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
+MODULE_DESCRIPTION("VGG2432A4 LCD Driver");
+MODULE_LICENSE("GPL v2");
+
+
diff -puN /dev/null include/video/ili9320.h
--- /dev/null
+++ a/include/video/ili9320.h
@@ -0,0 +1,201 @@
+/* include/video/ili9320.c
+ *
+ * ILI9320 LCD controller configuration control.
+ *
+ * Copyright 2007 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * http://armlinux.simtec.co.uk/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#define ILI9320_REG(x)	(x)
+
+#define ILI9320_INDEX			ILI9320_REG(0x00)
+
+#define ILI9320_OSCILATION		ILI9320_REG(0x00)
+#define ILI9320_DRIVER			ILI9320_REG(0x01)
+#define ILI9320_DRIVEWAVE		ILI9320_REG(0x02)
+#define ILI9320_ENTRYMODE		ILI9320_REG(0x03)
+#define ILI9320_RESIZING		ILI9320_REG(0x04)
+#define ILI9320_DISPLAY1		ILI9320_REG(0x07)
+#define ILI9320_DISPLAY2		ILI9320_REG(0x08)
+#define ILI9320_DISPLAY3		ILI9320_REG(0x09)
+#define ILI9320_DISPLAY4		ILI9320_REG(0x0A)
+#define ILI9320_RGB_IF1			ILI9320_REG(0x0C)
+#define ILI9320_FRAMEMAKER		ILI9320_REG(0x0D)
+#define ILI9320_RGB_IF2			ILI9320_REG(0x0F)
+
+#define ILI9320_POWER1			ILI9320_REG(0x10)
+#define ILI9320_POWER2			ILI9320_REG(0x11)
+#define ILI9320_POWER3			ILI9320_REG(0x12)
+#define ILI9320_POWER4			ILI9320_REG(0x13)
+#define ILI9320_GRAM_HORIZ_ADDR		ILI9320_REG(0x20)
+#define ILI9320_GRAM_VERT_ADD		ILI9320_REG(0x21)
+#define ILI9320_POWER7			ILI9320_REG(0x29)
+#define ILI9320_FRAME_RATE_COLOUR	ILI9320_REG(0x2B)
+
+#define ILI9320_GAMMA1			ILI9320_REG(0x30)
+#define ILI9320_GAMMA2			ILI9320_REG(0x31)
+#define ILI9320_GAMMA3			ILI9320_REG(0x32)
+#define ILI9320_GAMMA4			ILI9320_REG(0x35)
+#define ILI9320_GAMMA5			ILI9320_REG(0x36)
+#define ILI9320_GAMMA6			ILI9320_REG(0x37)
+#define ILI9320_GAMMA7			ILI9320_REG(0x38)
+#define ILI9320_GAMMA8			ILI9320_REG(0x39)
+#define ILI9320_GAMMA9			ILI9320_REG(0x3C)
+#define ILI9320_GAMMA10			ILI9320_REG(0x3D)
+
+#define ILI9320_HORIZ_START		ILI9320_REG(0x50)
+#define ILI9320_HORIZ_END		ILI9320_REG(0x51)
+#define ILI9320_VERT_START		ILI9320_REG(0x52)
+#define ILI9320_VERT_END		ILI9320_REG(0x53)
+
+#define ILI9320_DRIVER2			ILI9320_REG(0x60)
+#define ILI9320_BASE_IMAGE		ILI9320_REG(0x61)
+#define ILI9320_VERT_SCROLL		ILI9320_REG(0x6a)
+
+#define ILI9320_PARTIAL1_POSITION	ILI9320_REG(0x80)
+#define ILI9320_PARTIAL1_START		ILI9320_REG(0x81)
+#define ILI9320_PARTIAL1_END		ILI9320_REG(0x82)
+#define ILI9320_PARTIAL2_POSITION	ILI9320_REG(0x83)
+#define ILI9320_PARTIAL2_START		ILI9320_REG(0x84)
+#define ILI9320_PARTIAL2_END		ILI9320_REG(0x85)
+
+#define ILI9320_INTERFACE1		ILI9320_REG(0x90)
+#define ILI9320_INTERFACE2		ILI9320_REG(0x92)
+#define ILI9320_INTERFACE3		ILI9320_REG(0x93)
+#define ILI9320_INTERFACE4		ILI9320_REG(0x95)
+#define ILI9320_INTERFACE5		ILI9320_REG(0x97)
+#define ILI9320_INTERFACE6		ILI9320_REG(0x98)
+
+/* Register contents definitions. */
+
+#define ILI9320_OSCILATION_OSC		(1 << 0)
+
+#define ILI9320_DRIVER_SS		(1 << 8)
+#define ILI9320_DRIVER_SM		(1 << 10)
+
+#define ILI9320_DRIVEWAVE_EOR		(1 << 8)
+#define ILI9320_DRIVEWAVE_BC		(1 << 9)
+#define ILI9320_DRIVEWAVE_MUSTSET	(1 << 10)
+
+#define ILI9320_ENTRYMODE_AM		(1 << 3)
+#define ILI9320_ENTRYMODE_ID(x)		((x) << 4)
+#define ILI9320_ENTRYMODE_ORG		(1 << 7)
+#define ILI9320_ENTRYMODE_HWM		(1 << 8)
+#define ILI9320_ENTRYMODE_BGR		(1 << 12)
+#define ILI9320_ENTRYMODE_DFM		(1 << 14)
+#define ILI9320_ENTRYMODE_TRI		(1 << 15)
+
+
+#define ILI9320_RESIZING_RSZ(x)		((x) << 0)
+#define ILI9320_RESIZING_RCH(x)		((x) << 4)
+#define ILI9320_RESIZING_RCV(x)		((x) << 8)
+
+
+#define ILI9320_DISPLAY1_D(x)		((x) << 0)
+#define ILI9320_DISPLAY1_CL		(1 << 3)
+#define ILI9320_DISPLAY1_DTE		(1 << 4)
+#define ILI9320_DISPLAY1_GON		(1 << 5)
+#define ILI9320_DISPLAY1_BASEE		(1 << 8)
+#define ILI9320_DISPLAY1_PTDE(x)	((x) << 12)
+
+
+#define ILI9320_DISPLAY2_BP(x)		((x) << 0)
+#define ILI9320_DISPLAY2_FP(x)		((x) << 8)
+
+
+#define ILI9320_RGBIF1_RIM_RGB18	(0 << 0)
+#define ILI9320_RGBIF1_RIM_RGB16	(1 << 0)
+#define ILI9320_RGBIF1_RIM_RGB6		(2 << 0)
+
+#define ILI9320_RGBIF1_CLK_INT		(0 << 4)
+#define ILI9320_RGBIF1_CLK_RGBIF	(1 << 4)
+#define ILI9320_RGBIF1_CLK_VSYNC	(2 << 4)
+
+#define ILI9320_RGBIF1_RM		(1 << 8)
+
+#define ILI9320_RGBIF1_ENC_FRAMES(x)	(((x) - 1)<< 13)
+
+#define ILI9320_RGBIF2_DPL		(1 << 0)
+#define ILI9320_RGBIF2_EPL		(1 << 1)
+#define ILI9320_RGBIF2_HSPL		(1 << 3)
+#define ILI9320_RGBIF2_VSPL		(1 << 4)
+
+
+#define ILI9320_POWER1_SLP		(1 << 1)
+#define ILI9320_POWER1_DSTB		(1 << 2)
+#define ILI9320_POWER1_AP(x)		((x) << 4)
+#define ILI9320_POWER1_APE		(1 << 7)
+#define ILI9320_POWER1_BT(x)		((x) << 8)
+#define ILI9320_POWER1_SAP		(1 << 12)
+
+
+#define ILI9320_POWER2_VC(x)		((x) << 0)
+#define ILI9320_POWER2_DC0(x)		((x) << 4)
+#define ILI9320_POWER2_DC1(x)		((x) << 8)
+
+
+#define ILI9320_POWER3_VRH(x)		((x) << 0)
+#define ILI9320_POWER3_PON		(1 << 4)
+#define ILI9320_POWER3_VCMR		(1 << 8)
+
+
+#define ILI9320_POWER4_VREOUT(x)	((x) << 8)
+
+
+#define ILI9320_DRIVER2_SCNL(x)		((x) << 0)
+#define ILI9320_DRIVER2_NL(x)		((x) << 8)
+#define ILI9320_DRIVER2_GS		(1 << 15)
+
+
+#define ILI9320_BASEIMAGE_REV		(1 << 0)
+#define ILI9320_BASEIMAGE_VLE		(1 << 1)
+#define ILI9320_BASEIMAGE_NDL		(1 << 2)
+
+
+#define ILI9320_INTERFACE4_RTNE(x)	(x)
+#define ILI9320_INTERFACE4_DIVE(x)	((x) << 8)
+
+/* SPI interface definitions */
+
+#define ILI9320_SPI_IDCODE		(0x70)
+#define ILI9320_SPI_ID(x)		((x) << 2)
+#define ILI9320_SPI_READ		(0x01)
+#define ILI9320_SPI_WRITE		(0x00)
+#define ILI9320_SPI_DATA		(0x02)
+#define ILI9320_SPI_INDEX		(0x00)
+
+/* platform data to pass configuration from lcd */
+
+enum ili9320_suspend {
+	ILI9320_SUSPEND_OFF,
+	ILI9320_SUSPEND_DEEP,
+};
+
+struct ili9320_platdata {
+	unsigned short	hsize;
+	unsigned short	vsize;
+
+	enum ili9320_suspend suspend;
+
+	/* set the reset line, 0 = reset asserted, 1 = normal */
+	void		(*reset)(unsigned int val);
+
+	unsigned short	entry_mode;
+	unsigned short	display2;
+	unsigned short	display3;
+	unsigned short	display4;
+	unsigned short	rgb_if1;
+	unsigned short	rgb_if2;
+	unsigned short	interface2;
+	unsigned short	interface3;
+	unsigned short	interface4;
+	unsigned short	interface5;
+	unsigned short	interface6;
+};
+
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

