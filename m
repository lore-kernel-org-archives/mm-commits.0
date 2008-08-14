From: akpm@linux-foundation.org
Subject: - hwmon-adc124s501-generic-driver-update.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:49:56 -0700
Message-ID: <200808150003.m7F0347q004355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbYHOAEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 20:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marc.pignat@hevs.ch, david-b@pacbell.net, khali@linux-fr.org, mhoffman@lightlink.com, tobias@himmer-online.de, mm-commits@vger.kernel.org


The patch titled
     hwmon: ADC124S501 generic driver
has been removed from the -mm tree.  Its filename was
     hwmon-adc124s501-generic-driver-update.patch

This patch was dropped because it was folded into hwmon-adc124s501-generic-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: ADC124S501 generic driver
From: Marc Pignat <marc.pignat@hevs.ch>

SPI driver for analog to digital converters national semiconductor ADC081S101,
ADC124S501, ...

Code for 8 channels by : Tobias Himmer <tobias@himmer-online.de>

---

Hi all!

the message named '[RFC,PATCH v2] hwmon: ADC124S501 generic driver' contains the
v1 patch!

Andrew, you're working too fast and I'm too dumb to verify what is inside my
clipboard..., sorry for that.

patch against 2.6.27-rc1, tested on a custom arm board and only compile-tested
on x86.

This driver add support for National Semiconductor ADC<bb><c>S<sss> chip family,
where:
 * bb  is the resolution in number of bits (8, 10, 12)
 * c   is the number of channels (1, 2, 4, 8)
 * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
   kSPS and 101 for 1 MSPS)

Changes from v2:
 * the attatched patch is the right version

Changes from v1:
 * error recovery fixed
 * support for 8 channels, thanks to Tobias
 * better CodingStyle

Thanks for your comments and testing ;)

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Cc: Tobias Himmer <tobias@himmer-online.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig |   32 ++++++++--------
 drivers/hwmon/adcxx.c |   76 ++++++++++++++++++++++++++++++----------
 2 files changed, 74 insertions(+), 34 deletions(-)

diff -puN drivers/hwmon/Kconfig~hwmon-adc124s501-generic-driver-update drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-adc124s501-generic-driver-update
+++ a/drivers/hwmon/Kconfig
@@ -67,6 +67,22 @@ config SENSORS_AD7418
 	  This driver can also be built as a module. If so, the module
 	  will be called ad7418.
 
+config SENSORS_ADCXX
+	tristate "National Semiconductor ADCxxxSxxx"
+	depends on SPI_MASTER && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  ADC<bb><c>S<sss> chip family, where
+	  * bb  is the resolution in number of bits (8, 10, 12)
+	  * c   is the number of channels (1, 2, 4, 8)
+	  * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
+	    kSPS and 101 for 1 MSPS)
+
+	  Examples : ADC081S101, ADC124S501, ...
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called adcxx.
+
 config SENSORS_ADM1021
 	tristate "Analog Devices ADM1021 and compatibles"
 	depends on I2C
@@ -390,22 +406,6 @@ config SENSORS_LM70
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm70.
 
-config SENSORS_ADCXX
-	tristate "National Semiconductor ADCxxxSxxx"
-	depends on SPI_MASTER && EXPERIMENTAL
-	help
-	  If you say yes here you get support for the National Semiconductor
-	  ADC<bb><c>S<sss> chip family, where
-	  * bb  is the resolution in number of bits (8, 10, 12)
-	  * c   is the number of channels (1, 2, 4)
-	  * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500
-	    kSPS and 101 for 1 MSPS)
-
-	  Examples : ADC081S101, ADC124S501, ...
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called adcxx.
-
 config SENSORS_LM75
 	tristate "National Semiconductor LM75 and compatibles"
 	depends on I2C
diff -puN drivers/hwmon/adcxx.c~hwmon-adc124s501-generic-driver-update drivers/hwmon/adcxx.c
--- a/drivers/hwmon/adcxx.c~hwmon-adc124s501-generic-driver-update
+++ a/drivers/hwmon/adcxx.c
@@ -9,7 +9,7 @@
  * interface. This driver supports the whole family of devices with name
  * ADC<bb><c>S<sss>, where
  * * bb is the resolution in number of bits (8, 10, 12)
- * * c is the number of channels (1, 2, 4)
+ * * c is the number of channels (1, 2, 4, 8)
  * * sss is the maximum conversion speed (021 for 200 kSPS, 051 for 500 kSPS
  *   and 101 for 1 MSPS)
  *
@@ -142,16 +142,17 @@ static ssize_t adcxx_show_name(struct de
 
 static struct sensor_device_attribute ad_input[] = {
 	SENSOR_ATTR(name, S_IRUGO, adcxx_show_name, NULL, 0),
-
-	/* The reference is the same for all channels */
 	SENSOR_ATTR(in_min, S_IRUGO, adcxx_show_min, NULL, 0),
 	SENSOR_ATTR(in_max, S_IWUSR | S_IRUGO, adcxx_show_max,
 					adcxx_set_max, 0),
-
 	SENSOR_ATTR(in0_input, S_IRUGO, adcxx_read, NULL, 0),
 	SENSOR_ATTR(in1_input, S_IRUGO, adcxx_read, NULL, 1),
 	SENSOR_ATTR(in2_input, S_IRUGO, adcxx_read, NULL, 2),
 	SENSOR_ATTR(in3_input, S_IRUGO, adcxx_read, NULL, 3),
+	SENSOR_ATTR(in4_input, S_IRUGO, adcxx_read, NULL, 4),
+	SENSOR_ATTR(in5_input, S_IRUGO, adcxx_read, NULL, 5),
+	SENSOR_ATTR(in6_input, S_IRUGO, adcxx_read, NULL, 6),
+	SENSOR_ATTR(in7_input, S_IRUGO, adcxx_read, NULL, 7),
 };
 
 /*----------------------------------------------------------------------*/
@@ -168,34 +169,37 @@ static int __devinit adcxx_probe(struct 
 
 	/* set a default value for the reference */
 	adc->reference = 3300;
-
 	adc->channels = channels;
-
 	mutex_init(&adc->lock);
 
+	mutex_lock(&adc->lock);
+
 	dev_set_drvdata(&spi->dev, adc);
 
 	for (i = 0; i < 3 + adc->channels; i++) {
 		status = device_create_file(&spi->dev, &ad_input[i].dev_attr);
-		if (status)
-			goto out_dev_create_file_failed;
+		if (status) {
+			dev_err(&spi->dev, "device_create_file failed.\n");
+			goto out_err;
+		}
 	}
 
 	adc->hwmon_dev = hwmon_device_register(&spi->dev);
 	if (IS_ERR(adc->hwmon_dev)) {
-		dev_dbg(&spi->dev, "hwmon_device_register failed.\n");
+		dev_err(&spi->dev, "hwmon_device_register failed.\n");
 		status = PTR_ERR(adc->hwmon_dev);
-		goto out_dev_reg_failed;
+		goto out_err;
 	}
 
+	mutex_unlock(&adc->lock);
 	return 0;
 
-out_dev_create_file_failed:
-	hwmon_device_unregister(adc->hwmon_dev);
-	for (i = 0; i < 3 + adc->channels; i++)
+out_err:
+	for (i--; i >= 0; i--)
 		device_remove_file(&spi->dev, &ad_input[i].dev_attr);
-out_dev_reg_failed:
+
 	dev_set_drvdata(&spi->dev, NULL);
+	mutex_unlock(&adc->lock);
 	kfree(adc);
 	return status;
 }
@@ -215,15 +219,23 @@ static int __devinit adcxx4s_probe(struc
 	return adcxx_probe(spi, 4);
 }
 
+static int __devinit adcxx8s_probe(struct spi_device *spi)
+{
+	return adcxx_probe(spi, 8);
+}
+
 static int __devexit adcxx_remove(struct spi_device *spi)
 {
 	struct adcxx *adc = dev_get_drvdata(&spi->dev);
 	int i;
 
+	mutex_lock(&adc->lock);
 	hwmon_device_unregister(adc->hwmon_dev);
 	for (i = 0; i < 3 + adc->channels; i++)
 		device_remove_file(&spi->dev, &ad_input[i].dev_attr);
+
 	dev_set_drvdata(&spi->dev, NULL);
+	mutex_unlock(&adc->lock);
 	kfree(adc);
 
 	return 0;
@@ -256,18 +268,44 @@ static struct spi_driver adcxx4s_driver 
 	.remove	= __devexit_p(adcxx_remove),
 };
 
+static struct spi_driver adcxx8s_driver = {
+	.driver = {
+		.name	= "adcxx8s",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= adcxx8s_probe,
+	.remove	= __devexit_p(adcxx_remove),
+};
+
 static int __init init_adcxx(void)
 {
 	int status;
 	status = spi_register_driver(&adcxx1s_driver);
 	if (status)
-		return status;
+		goto reg_1_failed;
 
 	status = spi_register_driver(&adcxx2s_driver);
 	if (status)
-		return status;
+		goto reg_2_failed;
+
+	status = spi_register_driver(&adcxx4s_driver);
+	if (status)
+		goto reg_4_failed;
 
-	return spi_register_driver(&adcxx4s_driver);
+	status = spi_register_driver(&adcxx8s_driver);
+	if (status)
+		goto reg_8_failed;
+
+	return status;
+
+reg_8_failed:
+	spi_unregister_driver(&adcxx4s_driver);
+reg_4_failed:
+	spi_unregister_driver(&adcxx2s_driver);
+reg_2_failed:
+	spi_unregister_driver(&adcxx1s_driver);
+reg_1_failed:
+	return status;
 }
 
 static void __exit exit_adcxx(void)
@@ -275,15 +313,17 @@ static void __exit exit_adcxx(void)
 	spi_unregister_driver(&adcxx1s_driver);
 	spi_unregister_driver(&adcxx2s_driver);
 	spi_unregister_driver(&adcxx4s_driver);
+	spi_unregister_driver(&adcxx8s_driver);
 }
 
 module_init(init_adcxx);
 module_exit(exit_adcxx);
 
 MODULE_AUTHOR("Marc Pignat");
-MODULE_DESCRIPTION("National Semiconductor adcxx4sxxx Linux driver");
+MODULE_DESCRIPTION("National Semiconductor adcxx8sxxx Linux driver");
 MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("adcxx1s");
 MODULE_ALIAS("adcxx2s");
 MODULE_ALIAS("adcxx4s");
+MODULE_ALIAS("adcxx8s");
_

Patches currently in -mm which might be from marc.pignat@hevs.ch are

hwmon-adc124s501-generic-driver.patch
hwmon-adc124s501-generic-driver-update.patch
linux-next.patch
rtc-ds1374-wakup-support.patch
rtc-ds1374-wakeup-support-update.patch

