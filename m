From: akpm@linux-foundation.org
Subject: + rtc-rtc-ds3234-fixes-v2.patch added to -mm tree
Date: Wed, 19 Nov 2008 00:07:05 -0800
Message-ID: <200811190807.mAJ875a9000621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbYKSIHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 03:07:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net, denzzzhome@yahoo.com


The patch titled
     rtc: rtc-ds3234 fixes
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds3234-fixes-v2.patch

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
Subject: rtc: rtc-ds3234 fixes
From: Alessandro Zummo <a.zummo@towertech.it>

- no changelogs in code
- no banners
- use local buffers
- fix probe sequence
- do not init .driver.bus

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Dennis Aberilla <denzzzhome@yahoo.com>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3234.c |  170 +++++++------------------------------
 1 file changed, 35 insertions(+), 135 deletions(-)

diff -puN drivers/rtc/rtc-ds3234.c~rtc-rtc-ds3234-fixes-v2 drivers/rtc/rtc-ds3234.c
--- a/drivers/rtc/rtc-ds3234.c~rtc-rtc-ds3234-fixes-v2
+++ a/drivers/rtc/rtc-ds3234.c
@@ -1,4 +1,4 @@
-/* drivers/rtc/rtc-ds3234.c
+/* rtc-ds3234.c
  *
  * Driver for Dallas Semiconductor (DS3234) SPI RTC with Integrated Crystal
  * and SRAM.
@@ -9,13 +9,10 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * Changelog:
- *
- * 07-May-2008: Dennis Aberilla <denzzzhome@yahoo.com>
- *		- Created based on the max6902 code. Only implements the
- *		  date/time keeping functions; no SRAM yet.
  */
 
+#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
@@ -34,16 +31,7 @@
 #define DS3234_REG_CONTROL	0x0E
 #define DS3234_REG_CONT_STAT	0x0F
 
-#undef DS3234_DEBUG
-
-struct ds3234 {
-	struct rtc_device *rtc;
-	u8 buf[8]; /* Burst read: addr + 7 regs */
-	u8 tx_buf[2];
-	u8 rx_buf[2];
-};
-
-static void ds3234_set_reg(struct device *dev, unsigned char address,
+static int ds3234_set_reg(struct device *dev, unsigned char address,
 				unsigned char data)
 {
 	struct spi_device *spi = to_spi_device(dev);
@@ -53,107 +41,45 @@ static void ds3234_set_reg(struct device
 	buf[0] = address | 0x80;
 	buf[1] = data;
 
-	spi_write(spi, buf, 2);
+	return spi_write_then_read(spi, buf, 2, NULL, 0);
 }
 
 static int ds3234_get_reg(struct device *dev, unsigned char address,
 				unsigned char *data)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	struct ds3234 *chip = dev_get_drvdata(dev);
-	struct spi_message message;
-	struct spi_transfer xfer;
-	int status;
-
-	if (!data)
-		return -EINVAL;
-
-	/* Build our spi message */
-	spi_message_init(&message);
-	memset(&xfer, 0, sizeof(xfer));
-
-	/* Address + dummy tx byte */
-	xfer.len = 2;
-	xfer.tx_buf = chip->tx_buf;
-	xfer.rx_buf = chip->rx_buf;
-
-	chip->tx_buf[0] = address;
-	chip->tx_buf[1] = 0xff;
-
-	spi_message_add_tail(&xfer, &message);
-
-	/* do the i/o */
-	status = spi_sync(spi, &message);
-	if (status == 0)
-		status = message.status;
-	else
-		return status;
 
-	*data = chip->rx_buf[1];
+	*data = address & 0x7f;
 
-	return status;
+	return spi_write_then_read(spi, data, 1, data, 1);
 }
 
-static int ds3234_get_datetime(struct device *dev, struct rtc_time *dt)
+static int ds3234_read_time(struct device *dev, struct rtc_time *dt)
 {
+	int err;
+	unsigned char buf[8];
 	struct spi_device *spi = to_spi_device(dev);
-	struct ds3234 *chip = dev_get_drvdata(dev);
-	struct spi_message message;
-	struct spi_transfer xfer;
-	int status;
-
-	/* build the message */
-	spi_message_init(&message);
-	memset(&xfer, 0, sizeof(xfer));
-	xfer.len = 1 + 7;	/* Addr + 7 registers */
-	xfer.tx_buf = chip->buf;
-	xfer.rx_buf = chip->buf;
-	chip->buf[0] = 0x00;	/* Start address */
-	spi_message_add_tail(&xfer, &message);
-
-	/* do the i/o */
-	status = spi_sync(spi, &message);
-	if (status == 0)
-		status = message.status;
-	else
-		return status;
+
+	buf[0] = 0x00; /* Start address */
+
+	err = spi_write_then_read(spi, buf, 1, buf, 8);
+	if (err != 0)
+		return err;
 
 	/* Seconds, Minutes, Hours, Day, Date, Month, Year */
-	dt->tm_sec	= bcd2bin(chip->buf[1]);
-	dt->tm_min	= bcd2bin(chip->buf[2]);
-	dt->tm_hour	= bcd2bin(chip->buf[3] & 0x3f);
-	dt->tm_wday	= bcd2bin(chip->buf[4]) - 1; /* 0 = Sun */
-	dt->tm_mday	= bcd2bin(chip->buf[5]);
-	dt->tm_mon	= bcd2bin(chip->buf[6] & 0x1f) - 1; /* 0 = Jan */
-	dt->tm_year 	= bcd2bin(chip->buf[7] & 0xff) + 100; /* Assume 20YY */
-
-#ifdef DS3234_DEBUG
-	dev_dbg(dev, "\n%s : Read RTC values\n", __func__);
-	dev_dbg(dev, "tm_hour: %i\n", dt->tm_hour);
-	dev_dbg(dev, "tm_min : %i\n", dt->tm_min);
-	dev_dbg(dev, "tm_sec : %i\n", dt->tm_sec);
-	dev_dbg(dev, "tm_wday: %i\n", dt->tm_wday);
-	dev_dbg(dev, "tm_mday: %i\n", dt->tm_mday);
-	dev_dbg(dev, "tm_mon : %i\n", dt->tm_mon);
-	dev_dbg(dev, "tm_year: %i\n", dt->tm_year);
-#endif
+	dt->tm_sec	= bcd2bin(buf[0]);
+	dt->tm_min	= bcd2bin(buf[1]);
+	dt->tm_hour	= bcd2bin(buf[2] & 0x3f);
+	dt->tm_wday	= bcd2bin(buf[3]) - 1; /* 0 = Sun */
+	dt->tm_mday	= bcd2bin(buf[4]);
+	dt->tm_mon	= bcd2bin(buf[5] & 0x1f) - 1; /* 0 = Jan */
+	dt->tm_year 	= bcd2bin(buf[6] & 0xff) + 100; /* Assume 20YY */
 
-	return 0;
+	return rtc_valid_tm(dt);
 }
 
-static int ds3234_set_datetime(struct device *dev, struct rtc_time *dt)
+static int ds3234_set_time(struct device *dev, struct rtc_time *dt)
 {
-#ifdef DS3234_DEBUG
-	dev_dbg(dev, "\n%s : Setting RTC values\n", __func__);
-	dev_dbg(dev, "tm_sec : %i\n", dt->tm_sec);
-	dev_dbg(dev, "tm_min : %i\n", dt->tm_min);
-	dev_dbg(dev, "tm_hour: %i\n", dt->tm_hour);
-	dev_dbg(dev, "tm_wday: %i\n", dt->tm_wday);
-	dev_dbg(dev, "tm_mday: %i\n", dt->tm_mday);
-	dev_dbg(dev, "tm_mon : %i\n", dt->tm_mon);
-	dev_dbg(dev, "tm_year: %i\n", dt->tm_year);
-#endif
-
 	ds3234_set_reg(dev, DS3234_REG_SECONDS, bin2bcd(dt->tm_sec));
 	ds3234_set_reg(dev, DS3234_REG_MINUTES, bin2bcd(dt->tm_min));
 	ds3234_set_reg(dev, DS3234_REG_HOURS, bin2bcd(dt->tm_hour) & 0x3f);
@@ -174,16 +100,6 @@ static int ds3234_set_datetime(struct de
 	return 0;
 }
 
-static int ds3234_read_time(struct device *dev, struct rtc_time *tm)
-{
-	return ds3234_get_datetime(dev, tm);
-}
-
-static int ds3234_set_time(struct device *dev, struct rtc_time *tm)
-{
-	return ds3234_set_datetime(dev, tm);
-}
-
 static const struct rtc_class_ops ds3234_rtc_ops = {
 	.read_time	= ds3234_read_time,
 	.set_time	= ds3234_set_time,
@@ -193,31 +109,15 @@ static int __devinit ds3234_probe(struct
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
-	struct ds3234 *chip;
 	int res;
 
-	rtc = rtc_device_register("ds3234",
-				&spi->dev, &ds3234_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
-
 	spi->mode = SPI_MODE_3;
 	spi->bits_per_word = 8;
 	spi_setup(spi);
 
-	chip = kzalloc(sizeof(struct ds3234), GFP_KERNEL);
-	if (!chip) {
-		rtc_device_unregister(rtc);
-		return -ENOMEM;
-	}
-	chip->rtc = rtc;
-	dev_set_drvdata(&spi->dev, chip);
-
 	res = ds3234_get_reg(&spi->dev, DS3234_REG_SECONDS, &tmp);
-	if (res) {
-		rtc_device_unregister(rtc);
+	if (res != 0)
 		return res;
-	}
 
 	/* Control settings
 	 *
@@ -246,26 +146,27 @@ static int __devinit ds3234_probe(struct
 	ds3234_get_reg(&spi->dev, DS3234_REG_CONT_STAT, &tmp);
 	dev_info(&spi->dev, "Ctrl/Stat Reg: 0x%02x\n", tmp);
 
+	rtc = rtc_device_register("ds3234",
+				&spi->dev, &ds3234_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	dev_set_drvdata(&spi->dev, rtc);
+
 	return 0;
 }
 
 static int __devexit ds3234_remove(struct spi_device *spi)
 {
-	struct ds3234 *chip = platform_get_drvdata(spi);
-	struct rtc_device *rtc = chip->rtc;
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
-	kfree(chip);
+	struct rtc_device *rtc = platform_get_drvdata(spi);
 
+	rtc_device_unregister(rtc);
 	return 0;
 }
 
 static struct spi_driver ds3234_driver = {
 	.driver = {
 		.name	 = "ds3234",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	 = ds3234_probe,
@@ -274,7 +175,6 @@ static struct spi_driver ds3234_driver =
 
 static __init int ds3234_init(void)
 {
-	printk(KERN_INFO "DS3234 SPI RTC Driver\n");
 	return spi_register_driver(&ds3234_driver);
 }
 module_init(ds3234_init);
_

Patches currently in -mm which might be from a.zummo@towertech.it are

genrtc-disable-genrtc-on-blackfin-systems.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2.patch
rtc-driver-for-pxa27x-and-pxa3xx-soc.patch
rtc-pxa27x-pxa3xx-driver-fixes-revised.patch
rtc-add-alarm-update-irq-interfaces-version-2.patch
rtc-add-alarm-update-irq-interfaces-version-3.patch
rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch
rtc-kconfig-cleanup.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
rtc-rtc-max6902-fixes-v3.patch
rtc-rtc-ds3234-fixes-v2.patch

