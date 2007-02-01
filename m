From: akpm@osdl.org
Subject: + spi-eeprom-driver.patch added to -mm tree
Date: Thu, 01 Feb 2007 14:48:53 -0800
Message-ID: <200702012248.l11Mmrlh025252@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45777 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422681AbXBAWs7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Feb 2007 17:48:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI eeprom driver
has been added to the -mm tree.  Its filename is
     spi-eeprom-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI eeprom driver
From: David Brownell <david-b@pacbell.net>

This is adds a simple SPI EEPROM driver, providing access to the EEPROM
through sysfs much like the I2C "eeprom" driver ...  except this driver
supports write access, and multiple EEPROM sizes.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/Kconfig        |   10 
 drivers/spi/Makefile       |    1 
 drivers/spi/at25.c         |  354 +++++++++++++++++++++++++++++++++++
 include/linux/spi/eeprom.h |   22 ++
 4 files changed, 387 insertions(+)

diff -puN drivers/spi/Kconfig~spi-eeprom-driver drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-eeprom-driver
+++ a/drivers/spi/Kconfig
@@ -135,6 +135,16 @@ config SPI_S3C24XX_GPIO
 comment "SPI Protocol Masters"
 	depends on SPI_MASTER
 
+config SPI_AT25
+	tristate "SPI EEPROMs from most vendors"
+	depends on SPI_MASTER && SYSFS
+	help
+	  Enable this driver to get read/write support to most SPI EEPROMs,
+	  after you configure the board init code to know about each eeprom
+	  on your target board.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called at25.
 
 #
 # Add new SPI protocol masters in alphabetical order above this line
diff -puN drivers/spi/Makefile~spi-eeprom-driver drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-eeprom-driver
+++ a/drivers/spi/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24x
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
+obj-$(CONFIG_SPI_AT25)		+= at25.o
 # 	... add above this line ...
 
 # SPI slave controller drivers (upstream link)
diff -puN /dev/null drivers/spi/at25.c
--- /dev/null
+++ a/drivers/spi/at25.c
@@ -0,0 +1,354 @@
+/*
+ * at25.c -- support most SPI EEPROMs, such as Atmel AT25 models
+ *
+ * Copyright (C) 2006 David Brownell
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/sched.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/eeprom.h>
+
+
+struct at25_data {
+	struct spi_device	*spi;
+	struct mutex		lock;
+	struct spi_eeprom	chip;
+	struct bin_attribute	bin;
+};
+
+#define	AT25_WREN	0x06		/* latch the write enable */
+#define	AT25_WRDI	0x04		/* reset the write enable */
+#define	AT25_RDSR	0x05		/* read status register */
+#define	AT25_WRSR	0x01		/* write status register */
+#define	AT25_READ	0x03		/* read byte(s) */
+#define	AT25_WRITE	0x02		/* write byte(s)/sector */
+
+#define	AT25_SR_nRDY	0x01		/* nRDY = write-in-progress */
+#define	AT25_SR_WEN	0x02		/* write enable (latched) */
+#define	AT25_SR_BP0	0x04		/* BP for software writeprotect */
+#define	AT25_SR_BP1	0x08
+#define	AT25_SR_WPEN	0x80		/* writeprotect enable */
+
+
+/* Specs often allow 5 msec for a page write, sometimes 20 msec;
+ * it's important to recover from write timeouts.
+ */
+#define	EE_TIMEOUT	25
+
+/*-------------------------------------------------------------------------*/
+
+#define	io_limit	PAGE_SIZE	/* bytes */
+
+static ssize_t
+at25_ee_read(
+	struct at25_data	*at25,
+	char			*buf,
+	unsigned		offset,
+	size_t			count
+)
+{
+	u8			command[3];
+	ssize_t			status;
+	struct spi_transfer	t[2];
+	struct spi_message	m;
+
+	/* 16-bit address is written MSB first */
+	command[0] = AT25_READ;
+	command[1] = (u8) (offset >> 8);
+	command[2] = (u8) (offset >> 0);
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof t);
+
+	t[0].tx_buf = command;
+	t[0].len = 3;
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].rx_buf = buf;
+	t[1].len = count;
+	spi_message_add_tail(&t[1], &m);
+
+	mutex_lock(&at25->lock);
+
+	/* Read it all at once.
+	 *
+	 * REVISIT that's potentially a problem with large chips, if
+	 * other devices on the bus need to be accessed regularly or
+	 * this chip is clocked very slowly
+	 */
+	status = spi_sync(at25->spi, &m);
+	dev_dbg(&at25->spi->dev,
+		"read %Zd bytes at %d --> %d\n",
+		count, offset, (int) status);
+
+	mutex_unlock(&at25->lock);
+	return status ? status : count;
+}
+
+static ssize_t
+at25_bin_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+{
+	struct device		*dev;
+	struct at25_data	*at25;
+
+	dev = container_of(kobj, struct device, kobj);
+	at25 = dev_get_drvdata(dev);
+
+	if (unlikely(off >= at25->bin.size))
+		return 0;
+	if ((off + count) > at25->bin.size)
+		count = at25->bin.size - off;
+	if (unlikely(!count))
+		return count;
+
+	return at25_ee_read(at25, buf, off, count);
+}
+
+
+static ssize_t
+at25_ee_write(struct at25_data *at25, char *buf, loff_t off, size_t count)
+{
+	ssize_t			status = 0;
+	unsigned		written = 0;
+	unsigned		buf_size;
+	u8			*bounce;
+
+	/* Temp buffer starts with command and address */
+	buf_size = at25->chip.page_size;
+	if (buf_size > io_limit)
+		buf_size = io_limit;
+	bounce = kmalloc(buf_size + 3, GFP_KERNEL);
+	if (!bounce)
+		return -ENOMEM;
+
+	/* For write, rollover is within the page ... so we write at
+	 * most one page, then manually roll over to the next page.
+	 */
+	bounce[0] = AT25_WRITE;
+	mutex_lock(&at25->lock);
+	do {
+		unsigned long	timeout, retries;
+		unsigned	segment;
+		unsigned	offset = (unsigned) off;
+
+		bounce[3] = AT25_WREN;
+		status = spi_write(at25->spi, bounce + 3, 1);
+		if (status < 0) {
+			dev_dbg(&at25->spi->dev, "WREN --> %d\n",
+					(int) status);
+			break;
+		}
+
+		/* 16-bit address is written MSB first */
+		bounce[1] = (u8)(offset >> 8);
+		bounce[2] = (u8)(offset >> 0);
+
+		/* Write as much of a page as we can */
+		segment = buf_size - (offset % buf_size);
+		if (segment > count)
+			segment = count;
+		memcpy(&bounce[3], buf, segment);
+		status = spi_write(at25->spi, bounce, segment + 3);
+		dev_dbg(&at25->spi->dev,
+			"write %u bytes at %u --> %d\n",
+			segment, offset, (int) status);
+		if (status < 0)
+			break;
+
+		/* REVISIT this should detect (or prevent) failed writes
+		 * to readonly sections of the EEPROM...
+		 */
+
+		/* Wait for non-busy status, to avoid a potentially
+		 * slooow msleep() but always checking a few times.
+		 */
+		timeout = jiffies + msecs_to_jiffies(EE_TIMEOUT);
+		retries = 0;
+		yield();
+		do {
+			int	sr;
+
+			sr = spi_w8r8(at25->spi, AT25_RDSR);
+			if (sr < 0 || (sr & AT25_SR_nRDY)) {
+				dev_dbg(&at25->spi->dev,
+					"rdsr --> %d (%02x)\n", sr, sr);
+				/* at HZ=100, this is sloooow */
+				msleep(1);
+				continue;
+			}
+			if (!(sr & AT25_SR_nRDY))
+				break;
+		} while (retries++ < 3 || time_before_eq(jiffies, timeout));
+
+		if (time_after(jiffies, timeout)) {
+			dev_err(&at25->spi->dev,
+				"write %d bytes offset %d, "
+				"timeout after %u msecs\n",
+				segment, offset,
+				jiffies_to_msecs(jiffies -
+					(timeout - EE_TIMEOUT)));
+			status = -ETIMEDOUT;
+			break;
+		}
+
+		off += segment;
+		buf += segment;
+		count -= segment;
+		written += segment;
+
+	} while (count > 0);
+
+	mutex_unlock(&at25->lock);
+
+	kfree(bounce);
+	return written ? written : status;
+}
+
+static ssize_t
+at25_bin_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+{
+	struct device		*dev;
+	struct at25_data	*at25;
+
+	dev = container_of(kobj, struct device, kobj);
+	at25 = dev_get_drvdata(dev);
+
+	if (unlikely(off >= at25->bin.size))
+		return -EFBIG;
+	if ((off + count) > at25->bin.size)
+		count = at25->bin.size - off;
+	if (unlikely(!count))
+		return count;
+
+	return at25_ee_write(at25, buf, off, count);
+}
+
+/*-------------------------------------------------------------------------*/
+
+static int at25_probe(struct spi_device *spi)
+{
+	struct at25_data	*at25 = NULL;
+	const struct spi_eeprom *chip;
+	int			err;
+	int			sr;
+
+	/* Chip description */
+	chip = spi->dev.platform_data;
+	if (!chip) {
+		dev_dbg(&spi->dev, "no chip description\n");
+		err = -ENODEV;
+		goto fail;
+	}
+
+	/* For now we only support 16 bit addressing, for
+	 * chips from 512 bytes to 64 Kbytes (4-512 Kbits).
+	 *
+	 * REVISIT some chips use 8 or 24 bit addressing
+	 */
+	if (!chip->flags & EE_ADDR2) {
+		dev_dbg(&spi->dev, "unsupported address type\n");
+		err = -EINVAL;
+		goto fail;
+	}
+
+	/* Ping the chip ... the status register is pretty portable,
+	 * unlike probing manufacturer ides.  We do expect that system
+	 * firmware didn't write it in the past few milliseconds!
+	 */
+	sr = spi_w8r8(spi, AT25_RDSR);
+	if (sr < 0 || sr & AT25_SR_nRDY) {
+		dev_dbg(&at25->spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
+		err = -ENXIO;
+		goto fail;
+	}
+
+	if (!(at25 = kzalloc(sizeof *at25, GFP_KERNEL))) {
+		err = -ENOMEM;
+		goto fail;
+	}
+
+	mutex_init(&at25->lock);
+	at25->chip = *chip;
+	at25->spi = spi_dev_get(spi);
+	dev_set_drvdata(&spi->dev, at25);
+
+	/* Export the EEPROM bytes through sysfs, since that's convenient.
+	 * Default to root-only access to the data; EEPROMs often hold data
+	 * that's sensitive for read and/or write, like ethernet addresses,
+	 * security codes, board-specific manufacturing calibrations, etc.
+	 */
+	at25->bin.attr.name = "eeprom";
+	at25->bin.attr.mode = S_IRUSR;
+	at25->bin.attr.owner = THIS_MODULE;
+	at25->bin.read = at25_bin_read;
+
+	at25->bin.size = at25->chip.byte_len;
+	if (!(chip->flags & EE_READONLY)) {
+		at25->bin.write = at25_bin_write;
+		at25->bin.attr.mode |= S_IWUSR;
+	}
+
+	err = sysfs_create_bin_file(&spi->dev.kobj, &at25->bin);
+	if (err)
+		goto fail;
+
+	dev_info(&spi->dev, "%Zd KByte %s eeprom%s, pagesize %u\n",
+		at25->bin.size / 1024, at25->chip.name,
+		(chip->flags & EE_READONLY) ? " (readonly)" : "",
+		at25->chip.page_size);
+	return 0;
+fail:
+	dev_dbg(&spi->dev, "probe err %d\n", err);
+	kfree(at25);
+	return err;
+}
+
+static int __devexit at25_remove(struct spi_device *spi)
+{
+	struct at25_data	*at25;
+
+	at25 = dev_get_drvdata(&spi->dev);
+	(void) sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
+	kfree(at25);
+	return 0;
+}
+
+/*-------------------------------------------------------------------------*/
+
+static struct spi_driver at25_driver = {
+	.driver = {
+		.name		= "at25",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= at25_probe,
+	.remove		= __devexit_p(at25_remove),
+};
+
+static int __init at25_init(void)
+{
+	return spi_register_driver(&at25_driver);
+}
+module_init(at25_init);
+
+static void __exit at25_exit(void)
+{
+	spi_unregister_driver(&at25_driver);
+}
+module_exit(at25_exit);
+
+MODULE_DESCRIPTION("Driver for most SPI EEPROMs");
+MODULE_AUTHOR("David Brownell");
+MODULE_LICENSE("GPL");
+
diff -puN /dev/null include/linux/spi/eeprom.h
--- /dev/null
+++ a/include/linux/spi/eeprom.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_SPI_EEPROM_H
+#define __LINUX_SPI_EEPROM_H
+
+/*
+ * Put one of these structures in platform_data for SPI EEPROMS handled
+ * by the "at25" driver.  On SPI, most EEPROMS understand the same core
+ * command set.  If you need to support EEPROMs that don't yet fit, add
+ * flags to support those protocol options.  These values all come from
+ * the chip datasheets.
+ */
+struct spi_eeprom {
+	u32		byte_len;
+	char		name[10];
+	u16		page_size;		/* for writes */
+	u16		flags;
+#define	EE_ADDR1	0x0001			/*  8 bit addrs */
+#define	EE_ADDR2	0x0002			/* 16 bit addrs */
+#define	EE_ADDR3	0x0004			/* 24 bit addrs */
+#define	EE_READONLY	0x0008			/* disallow writes */
+};
+
+#endif /* __LINUX_SPI_EEPROM_H */
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-updates-rtc-cmos-device-platform_data.patch
git-mmc.patch
8250-make-probing-for-txen-bug-a-config-option.patch
pnp-export-pnp_bus_type.patch
rtc-framework-driver-for-cmos-rtcs.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
spi-freescale-imx-spi-controller-driver-v5.patch
spi-doc-clarifications.patch
rtc-gets-sysfs-wakealarm-attribute.patch
spi-eeprom-driver.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
