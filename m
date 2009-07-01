From: akpm@linux-foundation.org
Subject: + rtc-philips-nxp-pcf2123-driver-v03-update.patch added to -mm tree
Date: Wed, 01 Jul 2009 14:26:25 -0700
Message-ID: <200907012126.n61LQPKo007019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbZGAV0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 17:26:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisv@cyberswitching.com, a.zummo@towertech.it


The patch titled
     rtc-philips-nxp-pcf2123-driver-v03-update
has been added to the -mm tree.  Its filename is
     rtc-philips-nxp-pcf2123-driver-v03-update.patch

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
Subject: rtc-philips-nxp-pcf2123-driver-v03-update
From: "Chris Verges" <chrisv@cyberswitching.com>

> static inline void pcf2123_delay_trec(void)

You're right ... much cleaner.  Proof that one should not code over
vacation.  :-)  Full patch re-created and attached.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-pcf2123.c~rtc-philips-nxp-pcf2123-driver-v03-update drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-philips-nxp-pcf2123-driver-v03-update
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -39,15 +39,22 @@
 #define PCF2123_CMD_W(addr)	(((addr) & 0x0F) | 0x40)  /* single write */
 #define PCF2123_CMD_R(addr)	(((addr) & 0x0F) | 0x90)  /* single read */
 
-/* The Trec (chip enable recovery time) is specified by the PCF2123 */
-#define PCF2123_DELAY_TREC()	do { ndelay(30); } while (0)
-
 static struct spi_driver pcf2123_driver;
 
 struct pcf2123_plat_data {
 	struct rtc_device *rtc;
 };
 
+/*
+ * Causes a 30 nanosecond delay to ensure that the PCF2123 chip select
+ * is released properly after an SPI write.  This function should be
+ * called after EVERY read/write call over SPI.
+ */
+static inline void pcf2123_delay_trec(void)
+{
+	ndelay(30);
+}
+
 static int pcf2123_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
@@ -59,7 +66,7 @@ static int pcf2123_rtc_read_time(struct 
 			rxbuf, sizeof(rxbuf));
 	if (ret < 0)
 		return ret;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	tm->tm_sec = bcd2bin(rxbuf[0] & 0x7F);
 	tm->tm_min = bcd2bin(rxbuf[1] & 0x7F);
@@ -104,7 +111,7 @@ static int pcf2123_rtc_set_time(struct d
 	ret = spi_write(spi, txbuf, 2);
 	if (ret < 0)
 		return ret;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	/* Set the new time */
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_SC);
@@ -119,7 +126,7 @@ static int pcf2123_rtc_set_time(struct d
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
 	if (ret < 0)
 		return ret;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	/* Start the counter */
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
@@ -127,7 +134,7 @@ static int pcf2123_rtc_set_time(struct d
 	ret = spi_write(spi, txbuf, 2);
 	if (ret < 0)
 		return ret;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	return 0;
 }
@@ -155,7 +162,7 @@ static int __devinit pcf2123_probe(struc
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
 	if (ret < 0)
 		return ret;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	/* Stop the counter */
 	txbuf[0] = PCF2123_CMD_W(PCF2123_REG_CTRL1);
@@ -163,14 +170,14 @@ static int __devinit pcf2123_probe(struc
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
 	if (ret < 0)
 		return ret;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	/* See if the counter was actually stopped */
 	txbuf[0] = PCF2123_CMD_R(PCF2123_REG_CTRL1);
 	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, sizeof(rxbuf));
 	if (ret < 0)
 		goto kfree_exit;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "not found.\n");
@@ -187,7 +194,7 @@ static int __devinit pcf2123_probe(struc
 	ret = spi_write(spi, txbuf, sizeof(txbuf));
 	if (ret < 0)
 		goto kfree_exit;
-	PCF2123_DELAY_TREC();
+	pcf2123_delay_trec();
 
 	/* Finalize the initialization */
 	rtc = rtc_device_register(pcf2123_driver.driver.name, &spi->dev,
_

Patches currently in -mm which might be from chrisv@cyberswitching.com are

rtc-philips-nxp-pcf2123-driver.patch
rtc-philips-nxp-pcf2123-driver-v03.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-update.patch

