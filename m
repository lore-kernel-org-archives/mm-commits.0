From: akpm@linux-foundation.org
Subject: + rtc-rtc-max6902-fixes-v3.patch added to -mm tree
Date: Tue, 18 Nov 2008 23:57:36 -0800
Message-ID: <200811190757.mAJ7vao0028214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbYKSH5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 02:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net, raph@raphnet.net


The patch titled
     rtc: rtc-max6902 fixes
has been added to the -mm tree.  Its filename is
     rtc-rtc-max6902-fixes-v3.patch

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
Subject: rtc: rtc-max6902 fixes
From: Alessandro Zummo <a.zummo@towertech.it>

- no changelogs in code
- no banners
- use local buffers
- fix probe sequence
- fixed style issues
- fix spi_write call
- removed old debug code

replaces http://patchwork.ozlabs.org/patch/9421/
and http://patchwork.ozlabs.org/patch/9455/

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Raphael Assenat <raph@raphnet.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6902.c |  176 +++++++-----------------------------
 1 file changed, 38 insertions(+), 138 deletions(-)

diff -puN drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-fixes-v3 drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-fixes-v3
+++ a/drivers/rtc/rtc-max6902.c
@@ -9,14 +9,6 @@
  *
  * Driver for MAX6902 spi RTC
  *
- * Changelog:
- *
- * 24-May-2006: Raphael Assenat <raph@8d.com>
- *                - Major rework
- *				Converted to rtc_device and uses the SPI layer.
- *
- * ??-???-2005: Someone at Compulab
- *                - Initial driver creation.
  */
 
 #include <linux/module.h>
@@ -26,7 +18,6 @@
 #include <linux/rtc.h>
 #include <linux/spi/spi.h>
 #include <linux/bcd.h>
-#include <linux/delay.h>
 
 #define MAX6902_REG_SECONDS		0x01
 #define MAX6902_REG_MINUTES		0x03
@@ -38,16 +29,7 @@
 #define MAX6902_REG_CONTROL		0x0F
 #define MAX6902_REG_CENTURY		0x13
 
-#undef MAX6902_DEBUG
-
-struct max6902 {
-	struct rtc_device *rtc;
-	u8 buf[9]; /* Burst read cmd + 8 registers */
-	u8 tx_buf[2];
-	u8 rx_buf[2];
-};
-
-static void max6902_set_reg(struct device *dev, unsigned char address,
+static int max6902_set_reg(struct device *dev, unsigned char address,
 				unsigned char data)
 {
 	struct spi_device *spi = to_spi_device(dev);
@@ -57,113 +39,58 @@ static void max6902_set_reg(struct devic
 	buf[0] = address & 0x7f;
 	buf[1] = data;
 
-	spi_write(spi, buf, 2);
+	return spi_write_then_read(spi, buf, 2, NULL, 0);
 }
 
 static int max6902_get_reg(struct device *dev, unsigned char address,
 				unsigned char *data)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	struct max6902 *chip = dev_get_drvdata(dev);
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
-	xfer.len = 2;
-	/* Can tx_buf and rx_buf be equal? The doc in spi.h is not sure... */
-	xfer.tx_buf = chip->tx_buf;
-	xfer.rx_buf = chip->rx_buf;
 
 	/* Set MSB to indicate read */
-	chip->tx_buf[0] = address | 0x80;
-
-	spi_message_add_tail(&xfer, &message);
+	*data = address | 0x80;
 
-	/* do the i/o */
-	status = spi_sync(spi, &message);
-
-	if (status == 0)
-		*data = chip->rx_buf[1];
-	return status;
+	return spi_write_then_read(spi, data, 1, data, 1);
 }
 
-static int max6902_get_datetime(struct device *dev, struct rtc_time *dt)
+static int max6902_read_time(struct device *dev, struct rtc_time *dt)
 {
-	unsigned char tmp;
-	int century;
-	int err;
+	int err, century;
 	struct spi_device *spi = to_spi_device(dev);
-	struct max6902 *chip = dev_get_drvdata(dev);
-	struct spi_message message;
-	struct spi_transfer xfer;
-	int status;
+	unsigned char buf[8];
 
-	err = max6902_get_reg(dev, MAX6902_REG_CENTURY, &tmp);
-	if (err)
-		return err;
+	buf[0] = 0xbf;	/* Burst read */
 
-	/* build the message */
-	spi_message_init(&message);
-	memset(&xfer, 0, sizeof(xfer));
-	xfer.len = 1 + 7;	/* Burst read command + 7 registers */
-	xfer.tx_buf = chip->buf;
-	xfer.rx_buf = chip->buf;
-	chip->buf[0] = 0xbf;	/* Burst read */
-	spi_message_add_tail(&xfer, &message);
-
-	/* do the i/o */
-	status = spi_sync(spi, &message);
-	if (status)
-		return status;
+	err = spi_write_then_read(spi, buf, 1, buf, 8);
+	if (err != 0)
+		return err;
 
 	/* The chip sends data in this order:
 	 * Seconds, Minutes, Hours, Date, Month, Day, Year */
-	dt->tm_sec	= bcd2bin(chip->buf[1]);
-	dt->tm_min	= bcd2bin(chip->buf[2]);
-	dt->tm_hour	= bcd2bin(chip->buf[3]);
-	dt->tm_mday	= bcd2bin(chip->buf[4]);
-	dt->tm_mon	= bcd2bin(chip->buf[5]) - 1;
-	dt->tm_wday	= bcd2bin(chip->buf[6]);
-	dt->tm_year = bcd2bin(chip->buf[7]);
+	dt->tm_sec	= bcd2bin(buf[0]);
+	dt->tm_min	= bcd2bin(buf[1]);
+	dt->tm_hour	= bcd2bin(buf[2]);
+	dt->tm_mday	= bcd2bin(buf[3]);
+	dt->tm_mon	= bcd2bin(buf[4]) - 1;
+	dt->tm_wday	= bcd2bin(buf[5]);
+	dt->tm_year	= bcd2bin(buf[6]);
+
+	/* Read century */
+	err = max6902_get_reg(dev, MAX6902_REG_CENTURY, &buf[0]);
+	if (err != 0)
+		return err;
 
-	century = bcd2bin(tmp) * 100;
+	century = bcd2bin(buf[0]) * 100;
 
 	dt->tm_year += century;
 	dt->tm_year -= 1900;
 
-#ifdef MAX6902_DEBUG
-	printk("\n%s : Read RTC values\n",__func__);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_year: %i\n",dt->tm_year);
-	printk("tm_mon : %i\n",dt->tm_mon);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
-#endif
-
-	return 0;
+	return rtc_valid_tm(dt);
 }
 
-static int max6902_set_datetime(struct device *dev, struct rtc_time *dt)
+static int max6902_set_time(struct device *dev, struct rtc_time *dt)
 {
-	dt->tm_year = dt->tm_year+1900;
-
-#ifdef MAX6902_DEBUG
-	printk("\n%s : Setting RTC values\n",__func__);
-	printk("tm_sec : %i\n",dt->tm_sec);
-	printk("tm_min : %i\n",dt->tm_min);
-	printk("tm_hour: %i\n",dt->tm_hour);
-	printk("tm_mday: %i\n",dt->tm_mday);
-	printk("tm_wday: %i\n",dt->tm_wday);
-	printk("tm_year: %i\n",dt->tm_year);
-#endif
+	dt->tm_year = dt->tm_year + 1900;
 
 	/* Remove write protection */
 	max6902_set_reg(dev, 0xF, 0);
@@ -173,10 +100,10 @@ static int max6902_set_datetime(struct d
 	max6902_set_reg(dev, 0x05, bin2bcd(dt->tm_hour));
 
 	max6902_set_reg(dev, 0x07, bin2bcd(dt->tm_mday));
-	max6902_set_reg(dev, 0x09, bin2bcd(dt->tm_mon+1));
+	max6902_set_reg(dev, 0x09, bin2bcd(dt->tm_mon + 1));
 	max6902_set_reg(dev, 0x0B, bin2bcd(dt->tm_wday));
-	max6902_set_reg(dev, 0x0D, bin2bcd(dt->tm_year%100));
-	max6902_set_reg(dev, 0x13, bin2bcd(dt->tm_year/100));
+	max6902_set_reg(dev, 0x0D, bin2bcd(dt->tm_year % 100));
+	max6902_set_reg(dev, 0x13, bin2bcd(dt->tm_year / 100));
 
 	/* Compulab used a delay here. However, the datasheet
 	 * does not mention a delay being required anywhere... */
@@ -188,16 +115,6 @@ static int max6902_set_datetime(struct d
 	return 0;
 }
 
-static int max6902_read_time(struct device *dev, struct rtc_time *tm)
-{
-	return max6902_get_datetime(dev, tm);
-}
-
-static int max6902_set_time(struct device *dev, struct rtc_time *tm)
-{
-	return max6902_set_datetime(dev, tm);
-}
-
 static const struct rtc_class_ops max6902_rtc_ops = {
 	.read_time	= max6902_read_time,
 	.set_time	= max6902_set_time,
@@ -207,45 +124,29 @@ static int __devinit max6902_probe(struc
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
-	struct max6902 *chip;
 	int res;
 
-	rtc = rtc_device_register("max6902",
-				&spi->dev, &max6902_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
-
 	spi->mode = SPI_MODE_3;
 	spi->bits_per_word = 8;
 	spi_setup(spi);
 
-	chip = kzalloc(sizeof *chip, GFP_KERNEL);
-	if (!chip) {
-		rtc_device_unregister(rtc);
-		return -ENOMEM;
-	}
-	chip->rtc = rtc;
-	dev_set_drvdata(&spi->dev, chip);
-
 	res = max6902_get_reg(&spi->dev, MAX6902_REG_SECONDS, &tmp);
-	if (res) {
-		rtc_device_unregister(rtc);
+	if (res != 0)
 		return res;
-	}
+
+	rtc = rtc_device_register("max6902",
+				&spi->dev, &max6902_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
 	return 0;
 }
 
 static int __devexit max6902_remove(struct spi_device *spi)
 {
-	struct max6902 *chip = platform_get_drvdata(spi);
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
 
@@ -261,7 +162,6 @@ static struct spi_driver max6902_driver 
 
 static __init int max6902_init(void)
 {
-	printk("max6902 spi driver\n");
 	return spi_register_driver(&max6902_driver);
 }
 module_init(max6902_init);
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

