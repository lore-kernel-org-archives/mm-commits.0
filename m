From: akpm@linux-foundation.org
Subject: + gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch added to -mm tree
Date: Sun, 29 Jun 2008 00:17:58 -0700
Message-ID: <200806290717.m5T7Hwm1009820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbYF2HSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jun 2008 03:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net


The patch titled
     gpio max7301: check spi_setup() return code, cleanup
has been added to the -mm tree.  Its filename is
     gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch

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
Subject: gpio max7301: check spi_setup() return code, cleanup
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Fix inaccuracies in comments, check spi_setup() return code, mask off high
byte in max7301_read().  Thanks to David Brownell for the review.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN drivers/gpio/max7301.c~gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup
+++ a/drivers/gpio/max7301.c
@@ -71,7 +71,7 @@ struct max7301 {
  *
  * A write to the MAX7301 means one message with one transfer
  *
- * Returns 0 if successfull or a negative value on error
+ * Returns 0 if successful or a negative value on error
  */
 static int max7301_write(struct spi_device *spi, unsigned int reg, unsigned int val)
 {
@@ -84,9 +84,9 @@ static int max7301_write(struct spi_devi
  * @spi: The SPI device
  * @reg: Register offset
  *
- * A read from the MAX7301 means one message with two transfers
+ * A read from the MAX7301 means two transfers; here, one message each
  *
- * Returns positive 8 bit value from device if successfull or a
+ * Returns positive 8 bit value from device if successful or a
  * negative value on error
  */
 static int max7301_read(struct spi_device *spi, unsigned int reg)
@@ -99,12 +99,13 @@ static int max7301_read(struct spi_devic
 	if (ret)
 		return ret;
 	/*
-	 * FIXME: This read should write 0x0000 (=NOOP at MAX7301 side)
+	 * This relies on the fact, that a transfer with NULL tx_buf shifts out
+	 * zero bytes (=NOOP for MAX7301)
 	 */
 	ret = spi_read(spi, (u8 *)&word, sizeof(word));
 	if (ret)
 		return ret;
-	return word;
+	return word & 0xff;
 }
 
 static int max7301_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -224,7 +225,9 @@ static int __devinit max7301_probe(struc
 	 */
 	spi->bits_per_word = 16;
 
-	spi->master->setup(spi);
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
 
 	ts = kzalloc(sizeof(struct max7301), GFP_KERNEL);
 	if (!ts)
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch
gpio-sysfs-interface-updated.patch

