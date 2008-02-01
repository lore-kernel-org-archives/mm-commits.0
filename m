From: akpm@linux-foundation.org
Subject: - hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:29:22 -0800
Message-ID: <200802012229.m11MTMu9001801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbYBAWaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@linuxrealtime.co.uk, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon-new-chip-driver-for-ti-ads7828-a-d update
has been removed from the -mm tree.  Its filename was
     hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-new-chip-driver-for-ti-ads7828-a-d update
From: Steve Hardy <steve@linuxrealtime.co.uk>

Fix minor spelling and style issues identified with second revision of the
patch.

Signed-off-by: Steve Hardy <steve@linuxrealtime.co.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/ads7828 |   16 ++++++-------
 drivers/hwmon/Kconfig       |    8 +++---
 drivers/hwmon/ads7828.c     |   39 ++++++++++++++++------------------
 3 files changed, 30 insertions(+), 33 deletions(-)

diff -puN Documentation/hwmon/ads7828~hwmon-new-chip-driver-for-ti-ads7828-a-d-update Documentation/hwmon/ads7828
--- a/Documentation/hwmon/ads7828~hwmon-new-chip-driver-for-ti-ads7828-a-d-update
+++ a/Documentation/hwmon/ads7828
@@ -5,7 +5,7 @@ Supported chips:
   * Texas Instruments/Burr-Brown ADS7828
     Prefix: 'ads7828'
     Addresses scanned: I2C 0x48, 0x49, 0x4a, 0x4b
-    Datasheet: Publicly available at the Texas Instruments website :
+    Datasheet : Publicly available at the Texas Instruments website :
                http://focus.ti.com/lit/ds/symlink/ads7828.pdf
 
 Authors:
@@ -17,22 +17,20 @@ Module Parameters
 * se_input: bool (default Y)
   Single ended operation - set to N for differential mode
 * int_vref: bool (default Y)
-  Operate with the internal 2.5v reference - set to N for external reference
-* vref_mv: int (default 2500)
-  If using an external reference, set this to the reference voltage in mv
+  Operate with the internal 2.5V reference - set to N for external reference
+* vref_mV: int (default 2500)
+  If using an external reference, set this to the reference voltage in mV
 
 Description
 -----------
 
 This driver implements support for the Texas Instruments ADS7828.
 
-This device is a 12bit 8ch A-D converter.
+This device is a 12-bit 8-channel A-D converter.
 
 It can operate in single ended mode (8 +ve inputs) or in differential mode,
-when 4 differential pairs can be measured.
+where 4 differential pairs can be measured.
 
 The chip also has the facility to use an external voltage reference.  This
-may be required if your hardware supplies the ADS7828 from a 5v supply, see
+may be required if your hardware supplies the ADS7828 from a 5V supply, see
 the datasheet for more details.
-
-
diff -puN drivers/hwmon/Kconfig~hwmon-new-chip-driver-for-ti-ads7828-a-d-update drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-new-chip-driver-for-ti-ads7828-a-d-update
+++ a/drivers/hwmon/Kconfig
@@ -602,11 +602,11 @@ config SENSORS_ADS7828
 	tristate "Texas Instruments ADS7828"
 	depends on I2C
 	help
-	If you say yes here you get support for Texas Instruments ADS7828
-	12-bit 8-channel ADC device.
+	  If you say yes here you get support for Texas Instruments ADS7828
+	  12-bit 8-channel ADC device.
 
-	This driver can also be built as a module.  If so, the module
-	will be called ads7828.
+	  This driver can also be built as a module.  If so, the module
+	  will be called ads7828.
 
 config SENSORS_THMC50
 	tristate "Texas Instruments THMC50 / Analog Devices ADM1022"
diff -puN drivers/hwmon/ads7828.c~hwmon-new-chip-driver-for-ti-ads7828-a-d-update drivers/hwmon/ads7828.c
--- a/drivers/hwmon/ads7828.c~hwmon-new-chip-driver-for-ti-ads7828-a-d-update
+++ a/drivers/hwmon/ads7828.c
@@ -1,5 +1,5 @@
 /*
-	ads7828.c - lm_sensors driver for ads7828 12bit 8ch ADC
+	ads7828.c - lm_sensors driver for ads7828 12-bit 8-channel ADC
 	(C) 2007 EADS Astrium
 
 	This driver is based on the lm75 and other lm_sensors/hwmon drivers
@@ -34,14 +34,14 @@
 #include <linux/mutex.h>
 
 /* The ADS7828 registers */
-#define ADS7828_NCH 8 /* 8 channels of 12bit A-D supported */
+#define ADS7828_NCH 8 /* 8 channels of 12-bit A-D supported */
 #define ADS7828_CMD_SD_SE 0x80 /* Single ended inputs */
 #define ADS7828_CMD_SD_DIFF 0x00 /* Differential inputs */
 #define ADS7828_CMD_PD0 0x0 /* Power Down between A-D conversions */
 #define ADS7828_CMD_PD1 0x04 /* Internal ref OFF && A-D ON */
 #define ADS7828_CMD_PD2 0x08 /* Internal ref ON && A-D OFF */
 #define ADS7828_CMD_PD3 0x0C /* Internal ref ON && A-D ON */
-#define ADS7828_INT_VREF_MV 2500 /* Internal vref is 2.5v, 2500mV */
+#define ADS7828_INT_VREF_MV 2500 /* Internal vref is 2.5V, 2500mV */
 
 /* Addresses to scan */
 static unsigned short normal_i2c[] = { 0x48, 0x49, 0x4a, 0x4b,
@@ -53,7 +53,7 @@ I2C_CLIENT_INSMOD_1(ads7828);
 /* Other module parameters */
 static int se_input = 1; /* Default is SE, 0 == diff */
 static int int_vref = 1; /* Default is internal ref ON */
-static int vref_mv = ADS7828_INT_VREF_MV; /* set if vref != 2.5v */
+static int vref_mv = ADS7828_INT_VREF_MV; /* set if vref != 2.5V */
 module_param(se_input, bool, S_IRUGO);
 module_param(int_vref, bool, S_IRUGO);
 module_param(vref_mv, int, S_IRUGO);
@@ -69,13 +69,13 @@ struct ads7828_data {
 	struct mutex update_lock; /* mutex protect updates */
 	char valid; /* !=0 if following fields are valid */
 	unsigned long last_updated; /* In jiffies */
-	u16 adc_input[ADS7828_NCH]; /* ADS7828_NCH 12bit samples */
+	u16 adc_input[ADS7828_NCH]; /* ADS7828_NCH 12-bit samples */
 };
 
-/* Function declaration - neccesary due to function dependencies */
+/* Function declaration - necessary due to function dependencies */
 static int ads7828_detect(struct i2c_adapter *adapter, int address, int kind);
 
-/* The ADS7828 returns the 12bit sample in two bytes,
+/* The ADS7828 returns the 12-bit sample in two bytes,
 	these are read as a word then byte-swapped */
 static u16 ads7828_read_value(struct i2c_client *client, u8 reg)
 {
@@ -122,14 +122,14 @@ static ssize_t show_in(struct device *de
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
 	struct ads7828_data *data = ads7828_update_device(dev);
-	/* Print value (in mv as specified in sysfs-interface documentation) */
+	/* Print value (in mV as specified in sysfs-interface documentation) */
 	return sprintf(buf, "%d\n", (data->adc_input[attr->index] *
 		ads7828_lsb_resol)/1000);
 }
 
 #define in_reg(offset)\
 static SENSOR_DEVICE_ATTR(in##offset##_input, S_IRUGO, show_in,\
-	NULL, offset);
+	NULL, offset)
 
 in_reg(0);
 in_reg(1);
@@ -182,7 +182,7 @@ static struct i2c_driver ads7828_driver 
 	.detach_client = ads7828_detach_client,
 };
 
-/* This function is called by i2c_detect */
+/* This function is called by i2c_probe */
 static int ads7828_detect(struct i2c_adapter *adapter, int address, int kind)
 {
 	struct i2c_client *client;
@@ -195,8 +195,8 @@ static int ads7828_detect(struct i2c_ada
 		goto exit;
 
 	/* OK. For now, we presume we have a valid client. We now create the
-		 client structure, even though we cannot fill it completely yet.
-		 But it allows us to access ads7828_read_value. */
+	client structure, even though we cannot fill it completely yet.
+	But it allows us to access ads7828_read_value. */
 	data = kzalloc(sizeof(struct ads7828_data), GFP_KERNEL);
 	if (!data) {
 		err = -ENOMEM;
@@ -209,13 +209,12 @@ static int ads7828_detect(struct i2c_ada
 	client->adapter = adapter;
 	client->driver = &ads7828_driver;
 
-	/*
-	 * Now, we do the remaining detection. There is no identification
-	 * dedicated register so attempt to sanity check using knowledge of the
-	 * chip
-	 * - Read from the 8 channel addresses
-	 * - Check the top 4 bits of each result are not set (12 data bits)
-	 */
+	/* Now, we do the remaining detection. There is no identification
+	dedicated register so attempt to sanity check using knowledge of
+	the chip
+	- Read from the 8 channel addresses
+	- Check the top 4 bits of each result are not set (12 data bits)
+	*/
 	if (kind < 0) {
 		int ch;
 		for (ch = 0; ch < ADS7828_NCH; ch++) {
@@ -273,7 +272,7 @@ exit:
 
 static int __init sensors_ads7828_init(void)
 {
-	/* Initialise the command byte according to module parameters */
+	/* Initialize the command byte according to module parameters */
 	ads7828_cmd_byte = se_input ?
 		ADS7828_CMD_SD_SE : ADS7828_CMD_SD_DIFF;
 	ads7828_cmd_byte |= int_vref ?
_

Patches currently in -mm which might be from steve@linuxrealtime.co.uk are

git-hwmon.patch
