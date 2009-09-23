From: akpm@linux-foundation.org
Subject: [merged] hwmon-adxx-convert-to-device-table-matching.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:59 -0700
Message-ID: <200909231957.n8NJvxpx008009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbZIWT7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org, marc.pign


The patch titled
     hwmon: adxx: convert to device table matching
has been removed from the -mm tree.  Its filename was
     hwmon-adxx-convert-to-device-table-matching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: adxx: convert to device table matching
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Make the code a little bit nicer, and shorter.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adcxx.c |  101 ++++++----------------------------------
 1 file changed, 16 insertions(+), 85 deletions(-)

diff -puN drivers/hwmon/adcxx.c~hwmon-adxx-convert-to-device-table-matching drivers/hwmon/adcxx.c
--- a/drivers/hwmon/adcxx.c~hwmon-adxx-convert-to-device-table-matching
+++ a/drivers/hwmon/adcxx.c
@@ -43,6 +43,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
 
 #define DRVNAME		"adcxx"
@@ -157,8 +158,9 @@ static struct sensor_device_attribute ad
 
 /*----------------------------------------------------------------------*/
 
-static int __devinit adcxx_probe(struct spi_device *spi, int channels)
+static int __devinit adcxx_probe(struct spi_device *spi)
 {
+	int channels = spi_get_device_id(spi)->driver_data;
 	struct adcxx *adc;
 	int status;
 	int i;
@@ -204,26 +206,6 @@ out_err:
 	return status;
 }
 
-static int __devinit adcxx1s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 1);
-}
-
-static int __devinit adcxx2s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 2);
-}
-
-static int __devinit adcxx4s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 4);
-}
-
-static int __devinit adcxx8s_probe(struct spi_device *spi)
-{
-	return adcxx_probe(spi, 8);
-}
-
 static int __devexit adcxx_remove(struct spi_device *spi)
 {
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
@@ -241,79 +223,33 @@ static int __devexit adcxx_remove(struct
 	return 0;
 }
 
-static struct spi_driver adcxx1s_driver = {
-	.driver = {
-		.name	= "adcxx1s",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= adcxx1s_probe,
-	.remove	= __devexit_p(adcxx_remove),
-};
-
-static struct spi_driver adcxx2s_driver = {
-	.driver = {
-		.name	= "adcxx2s",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= adcxx2s_probe,
-	.remove	= __devexit_p(adcxx_remove),
+static const struct spi_device_id adcxx_ids[] = {
+	{ "adcxx1s", 1 },
+	{ "adcxx2s", 2 },
+	{ "adcxx4s", 4 },
+	{ "adcxx8s", 8 },
+	{ },
 };
+MODULE_DEVICE_TABLE(spi, adcxx_ids);
 
-static struct spi_driver adcxx4s_driver = {
+static struct spi_driver adcxx_driver = {
 	.driver = {
-		.name	= "adcxx4s",
+		.name	= "adcxx",
 		.owner	= THIS_MODULE,
 	},
-	.probe	= adcxx4s_probe,
-	.remove	= __devexit_p(adcxx_remove),
-};
-
-static struct spi_driver adcxx8s_driver = {
-	.driver = {
-		.name	= "adcxx8s",
-		.owner	= THIS_MODULE,
-	},
-	.probe	= adcxx8s_probe,
+	.id_table = adcxx_ids,
+	.probe	= adcxx_probe,
 	.remove	= __devexit_p(adcxx_remove),
 };
 
 static int __init init_adcxx(void)
 {
-	int status;
-	status = spi_register_driver(&adcxx1s_driver);
-	if (status)
-		goto reg_1_failed;
-
-	status = spi_register_driver(&adcxx2s_driver);
-	if (status)
-		goto reg_2_failed;
-
-	status = spi_register_driver(&adcxx4s_driver);
-	if (status)
-		goto reg_4_failed;
-
-	status = spi_register_driver(&adcxx8s_driver);
-	if (status)
-		goto reg_8_failed;
-
-	return status;
-
-reg_8_failed:
-	spi_unregister_driver(&adcxx4s_driver);
-reg_4_failed:
-	spi_unregister_driver(&adcxx2s_driver);
-reg_2_failed:
-	spi_unregister_driver(&adcxx1s_driver);
-reg_1_failed:
-	return status;
+	return spi_register_driver(&adcxx_driver);
 }
 
 static void __exit exit_adcxx(void)
 {
-	spi_unregister_driver(&adcxx1s_driver);
-	spi_unregister_driver(&adcxx2s_driver);
-	spi_unregister_driver(&adcxx4s_driver);
-	spi_unregister_driver(&adcxx8s_driver);
+	spi_unregister_driver(&adcxx_driver);
 }
 
 module_init(init_adcxx);
@@ -322,8 +258,3 @@ module_exit(exit_adcxx);
 MODULE_AUTHOR("Marc Pignat");
 MODULE_DESCRIPTION("National Semiconductor adcxx8sxxx Linux driver");
 MODULE_LICENSE("GPL");
