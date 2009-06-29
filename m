From: akpm@linux-foundation.org
Subject: + rtc-philips-nxp-pcf2123-driver-v03.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:56:49 -0700
Message-ID: <200906291956.n5TJunc7003931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbZF2T47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisv@cyberswitching.com, a.zummo@towertech.it


The patch titled
     rtc-philips-nxp-pcf2123-driver-v03
has been added to the -mm tree.  Its filename is
     rtc-philips-nxp-pcf2123-driver-v03.patch

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
Subject: rtc-philips-nxp-pcf2123-driver-v03
From: "Chris Verges" <chrisv@cyberswitching.com>

Here's an updated patch with the changes requested by Andrew.
Major points of the update include:

   - Moved PCF2123 section in Kconfig to be inside the
     "if SPI_MASTER" blob, to take care of dependencies.

   - Changed udelay() to macro w/ comment, and shifted to
     using ndelay() instead due to 30 nsec requirement,
     not 30 usec as was originally coded.

   - Bypass delay if spi_*() commands fail.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |   18 +++++++++---------
 drivers/rtc/rtc-pcf2123.c |   21 ++++++++++++---------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-philips-nxp-pcf2123-driver-v03 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-philips-nxp-pcf2123-driver-v03
+++ a/drivers/rtc/Kconfig
@@ -224,15 +224,6 @@ config RTC_DRV_PCF8583
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-pcf8583.
 
-config RTC_DRV_PCF2123
-	tristate "NXP PCF2123"
-	help
-	  If you say yes here you get support for the NXP PCF2123
-	  RTC chip.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-pcf2123.
-
 config RTC_DRV_M41T80
 	tristate "ST M41T62/65/M41T80/81/82/83/84/85/87"
 	help
@@ -387,6 +378,15 @@ config RTC_DRV_DS3234
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds3234.
 
+config RTC_DRV_PCF2123
+	tristate "NXP PCF2123"
+	help
+	  If you say yes here you get support for the NXP PCF2123
+	  RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-pcf2123.
+
 endif # SPI_MASTER
 
 comment "Platform RTC drivers"
diff -puN drivers/rtc/rtc-pcf2123.c~rtc-philips-nxp-pcf2123-driver-v03 drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-philips-nxp-pcf2123-driver-v03
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -23,7 +23,7 @@
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 
-#define DRV_VERSION "0.2"
+#define DRV_VERSION "0.3"
 
 #define PCF2123_REG_CTRL1	0x00 /* Control Register 1 */
 #define PCF2123_REG_CTRL2	0x01 /* Control Register 2 */
@@ -39,6 +39,9 @@
 #define PCF2123_CMD_W(addr)	(((addr) & 0x0F) | 0x40)  /* single write */
 #define PCF2123_CMD_R(addr)	(((addr) & 0x0F) | 0x90)  /* single read */
 
+/* The Trec (chip enable recovery time) is specified by the PCF2123 */
+#define PCF2123_DELAY_TREC()	{ ndelay(30); }
+
 static struct spi_driver pcf2123_driver;
 
 struct pcf2123_plat_data {
@@ -54,9 +57,9 @@ static int pcf2123_rtc_read_time(struct 
 	txbuf[0] = PCF2123_CMD_R(PCF2123_REG_SC);
 	ret = spi_write_then_read(spi, txbuf, sizeof(txbuf),
 			rxbuf, sizeof(rxbuf));
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		return ret;
+	PCF2123_DELAY_TREC();
 
 	tm->tm_sec = bcd2bin(rxbuf[0] & 0x7F);
 	tm->tm_min = bcd2bin(rxbuf[1] & 0x7F);
@@ -99,9 +102,9 @@ static int pcf2123_rtc_set_time(struct d
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
 	txbuf[1] = 0x20;
 	ret = spi_write(spi, txbuf, 2);
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		return ret;
+	PCF2123_DELAY_TREC();
 
 	/* Set the new time */
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_SC);
@@ -114,17 +117,17 @@ static int pcf2123_rtc_set_time(struct d
 	txbuf[7] = bin2bcd(tm->tm_year < 100 ? tm->tm_year : tm->tm_year - 100);
 
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		return ret;
+	PCF2123_DELAY_TREC();
 
 	/* Start the counter */
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
 	txbuf[1] = 0x00;
 	ret = spi_write(spi, txbuf, 2);
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		return ret;
+	PCF2123_DELAY_TREC();
 
 	return 0;
 }
@@ -150,24 +153,24 @@ static int __devinit pcf2123_probe(struc
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
 	txbuf[1] = 0x58;
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		return ret;
+	PCF2123_DELAY_TREC();
 
 	/* Stop the counter */
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
 	txbuf[1] = 0x20;
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		return ret;
+	PCF2123_DELAY_TREC();
 
 	/* See if the counter was actually stopped */
 	txbuf[0] = PCF2123_CMD_R(PCF2123_REG_CTRL1);
 	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, sizeof(rxbuf));
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		goto kfree_exit;
+	PCF2123_DELAY_TREC();
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "not found.\n");
@@ -182,9 +185,9 @@ static int __devinit pcf2123_probe(struc
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
 	txbuf[1] = 0x00;
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
-	udelay(30); /* Trec 30us */
 	if (ret < 0)
 		goto kfree_exit;
+	PCF2123_DELAY_TREC();
 
 	/* Finalize the initialization */
 	rtc = rtc_device_register(pcf2123_driver.driver.name, &spi->dev,
_

Patches currently in -mm which might be from chrisv@cyberswitching.com are

rtc-philips-nxp-pcf2123-driver.patch
rtc-philips-nxp-pcf2123-driver-v03.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch

