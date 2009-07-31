From: akpm@linux-foundation.org
Subject: + hwmon-lm70-convert-to-device-table-matching.patch added to -mm tree
Date: Fri, 31 Jul 2009 13:50:03 -0700
Message-ID: <200907312050.n6VKo4OZ000820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbZGaUvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 16:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, kaiwan@designergraphix.com, khali@linux-fr.org


The patch titled
     hwmon: lm70: convert to device table matching
has been added to the -mm tree.  Its filename is
     hwmon-lm70-convert-to-device-table-matching.patch

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
Subject: hwmon: lm70: convert to device table matching
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Make the code a little bit nicer, and shorter.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kaiwan N Billimoria <kaiwan@designergraphix.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm70.c |   55 ++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff -puN drivers/hwmon/lm70.c~hwmon-lm70-convert-to-device-table-matching drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~hwmon-lm70-convert-to-device-table-matching
+++ a/drivers/hwmon/lm70.c
@@ -32,6 +32,7 @@
 #include <linux/sysfs.h>
 #include <linux/hwmon.h>
 #include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
 
 
@@ -130,11 +131,20 @@ static DEVICE_ATTR(name, S_IRUGO, lm70_s
 
 /*----------------------------------------------------------------------*/
 
-static int __devinit common_probe(struct spi_device *spi, int chip)
+static int __devinit lm70_probe(struct spi_device *spi)
 {
+	int chip = spi_get_device_id(spi)->driver_data;
 	struct lm70 *p_lm70;
 	int status;
 
+	/* signaling is SPI_MODE_0 for both LM70 and TMP121 */
+	if (spi->mode & (SPI_CPOL | SPI_CPHA))
+		return -EINVAL;
+
+	/* 3-wire link (shared SI/SO) for LM70 */
+	if (chip == LM70_CHIP_LM70 && !(spi->mode & SPI_3WIRE))
+		return -EINVAL;
+
 	/* NOTE:  we assume 8-bit words, and convert to 16 bits manually */
 
 	p_lm70 = kzalloc(sizeof *p_lm70, GFP_KERNEL);
@@ -170,24 +180,6 @@ out_dev_reg_failed:
 	return status;
 }
 
-static int __devinit lm70_probe(struct spi_device *spi)
-{
-	/* signaling is SPI_MODE_0 on a 3-wire link (shared SI/SO) */
-	if ((spi->mode & (SPI_CPOL | SPI_CPHA)) || !(spi->mode & SPI_3WIRE))
-		return -EINVAL;
-
-	return common_probe(spi, LM70_CHIP_LM70);
-}
-
-static int __devinit tmp121_probe(struct spi_device *spi)
-{
-	/* signaling is SPI_MODE_0 with only MISO connected */
-	if (spi->mode & (SPI_CPOL | SPI_CPHA))
-		return -EINVAL;
-
-	return common_probe(spi, LM70_CHIP_TMP121);
-}
-
 static int __devexit lm70_remove(struct spi_device *spi)
 {
 	struct lm70 *p_lm70 = dev_get_drvdata(&spi->dev);
@@ -201,41 +193,32 @@ static int __devexit lm70_remove(struct 
 	return 0;
 }
 
-static struct spi_driver tmp121_driver = {
-	.driver = {
-		.name	= "tmp121",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= tmp121_probe,
-	.remove	= __devexit_p(lm70_remove),
+
+static const struct spi_device_id lm70_ids[] = {
+	{ "lm70",   LM70_CHIP_LM70 },
+	{ "tmp121", LM70_CHIP_TMP121 },
+	{ },
 };
+MODULE_DEVICE_TABLE(spi, lm70_ids);
 
 static struct spi_driver lm70_driver = {
 	.driver = {
 		.name	= "lm70",
 		.owner	= THIS_MODULE,
 	},
+	.id_table = lm70_ids,
 	.probe	= lm70_probe,
 	.remove	= __devexit_p(lm70_remove),
 };
 
 static int __init init_lm70(void)
 {
-	int ret = spi_register_driver(&lm70_driver);
-	if (ret)
-		return ret;
-
-	ret = spi_register_driver(&tmp121_driver);
-	if (ret)
-		spi_unregister_driver(&lm70_driver);
-
-	return ret;
+	return spi_register_driver(&lm70_driver);
 }
 
 static void __exit cleanup_lm70(void)
 {
 	spi_unregister_driver(&lm70_driver);
-	spi_unregister_driver(&tmp121_driver);
 }
 
 module_init(init_lm70);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
spi-merge-probe-and-probe_id-callbacks.patch

