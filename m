From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-epson-rtc-9701je-v4.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:06 -0800
Message-ID: <200801270514.m0R5E3Rd030960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbYA0FOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, a.zummo@towertech.it, damm@igel.co.jp, david-b@pacbell.net


The patch titled
     rtc: add support for Epson RTC-9701JE V4
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-epson-rtc-9701je-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add support for Epson RTC-9701JE V4
From: Magnus Damm <magnus.damm@gmail.com>

Add support for the Epson RTC-9701JE SPI RTC device.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |   37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff -puN drivers/rtc/rtc-r9701.c~rtc-add-support-for-epson-rtc-9701je-v4 drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~rtc-add-support-for-epson-rtc-9701je-v4
+++ a/drivers/rtc/rtc-r9701.c
@@ -1,10 +1,9 @@
-/* drivers/rtc/rtc-r9701.c
- *
+/*
  * Driver for Epson RTC-9701JE
  *
  * Copyright (C) 2008 Magnus Damm
  *
- * Based on drivers/rtc/rtc-max6902.c
+ * Based on rtc-max6902.c
  *
  * Copyright (C) 2006 8D Technologies inc.
  * Copyright (C) 2004 Compulab Ltd.
@@ -72,13 +71,12 @@ static int read_regs(struct device *dev,
 
 static int r9701_get_datetime(struct device *dev, struct rtc_time *dt)
 {
-	struct spi_device *spi = to_spi_device(dev);
 	unsigned long time;
 	int ret;
 	unsigned char buf[] = { RSECCNT, RMINCNT, RHRCNT,
 				RDAYCNT, RMONCNT, RYRCNT };
 
-	ret = read_regs(&spi->dev, buf, ARRAY_SIZE(buf));
+	ret = read_regs(dev, buf, ARRAY_SIZE(buf));
 	if (ret)
 		return ret;
 
@@ -96,17 +94,7 @@ static int r9701_get_datetime(struct dev
 	 * according to the data sheet. make sure they are valid.
 	 */
 
-	ret = rtc_valid_tm(dt);
-	if (ret)
-		return ret;
-
-	/* don't bother with yday, wday and isdst.
-	 * let the rtc core calculate them for us.
-	 */
-
-	rtc_tm_to_time(dt, &time);
-	rtc_time_to_tm(time, dt);
-	return 0;
+	return rtc_valid_tm(dt);
 }
 
 static int r9701_set_datetime(struct device *dev, struct rtc_time *dt)
@@ -118,12 +106,12 @@ static int r9701_set_datetime(struct dev
 		return -EINVAL;
 
 	ret = write_reg(dev, RHRCNT, BIN2BCD(dt->tm_hour));
-	ret |= write_reg(dev, RMINCNT, BIN2BCD(dt->tm_min));
-	ret |= write_reg(dev, RSECCNT, BIN2BCD(dt->tm_sec));
-	ret |= write_reg(dev, RDAYCNT, BIN2BCD(dt->tm_mday));
-	ret |= write_reg(dev, RMONCNT, BIN2BCD(dt->tm_mon + 1));
-	ret |= write_reg(dev, RYRCNT, BIN2BCD(dt->tm_year - 100));
-	ret |= write_reg(dev, RWKCNT, 1 << dt->tm_wday);
+	ret = ret ? ret : write_reg(dev, RMINCNT, BIN2BCD(dt->tm_min));
+	ret = ret ? ret : write_reg(dev, RSECCNT, BIN2BCD(dt->tm_sec));
+	ret = ret ? ret : write_reg(dev, RDAYCNT, BIN2BCD(dt->tm_mday));
+	ret = ret ? ret : write_reg(dev, RMONCNT, BIN2BCD(dt->tm_mon + 1));
+	ret = ret ? ret : write_reg(dev, RYRCNT, BIN2BCD(dt->tm_year - 100));
+	ret = ret ? ret : write_reg(dev, RWKCNT, 1 << dt->tm_wday);
 
 	return ret;
 }
@@ -146,10 +134,6 @@ static int __devinit r9701_probe(struct 
 
 	dev_set_drvdata(&spi->dev, rtc);
 
-	spi->mode = SPI_MODE_3;
-	spi->bits_per_word = 8;
-	spi_setup(spi);
-
 	tmp = R100CNT;
 	res = read_regs(&spi->dev, &tmp, 1);
 	if (res || tmp != 0x20) {
@@ -171,7 +155,6 @@ static int __devexit r9701_remove(struct
 static struct spi_driver r9701_driver = {
 	.driver = {
 		.name	= "rtc-r9701",
-		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
 	.probe	= r9701_probe,
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

usb-dma-bounce-buffer-support-v3.patch
usb-dma-bounce-buffer-support-v3-checkpatch-fixes.patch
usb-dma-bounce-buffer-support-v3-fix.patch
usb-ohci-sm501-driver-v2.patch
usb-ohci-sm501-driver-v2-fix.patch
spi-superh-spi-using-sci.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
