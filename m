From: akpm@linux-foundation.org
Subject: [merged] hwmon-applesmc-add-support-for-macpro-3-temperature-sensors.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:20 -0800
Message-ID: <200901301914.n0UJEKns027221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753293AbZA3TO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bramesh@vt.edu, rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: add support for MacPro 3 temperature sensors
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-add-support-for-macpro-3-temperature-sensors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: add support for MacPro 3 temperature sensors
From: Bharath Ramesh <bramesh@vt.edu>

MacPro 3 have more temperature sensors than the previous MacPro's also the
sensor THTG has been removed.  This patch add supports for the newer
temperature sensors in the MacPro3.

Signed-off-by: Bharath Ramesh <bramesh@vt.edu>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macpro-3-temperature-sensors drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-add-support-for-macpro-3-temperature-sensors
+++ a/drivers/hwmon/applesmc.c
@@ -83,7 +83,7 @@
 /*
  * Temperature sensors keys (sp78 - 2 bytes).
  */
-static const char* temperature_sensors_sets[][36] = {
+static const char *temperature_sensors_sets[][41] = {
 /* Set 0: Macbook Pro */
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
@@ -135,6 +135,13 @@ static const char* temperature_sensors_s
 	{ "TB0T", "TB1S", "TB1T", "TB2S", "TB2T", "TC0D", "TN0D", "TTF0",
 	  "TV0P", "TVFP", "TW0P", "Th0P", "Tp0P", "Tp1P", "TpFP", "Ts0P",
 	  "Ts0S", NULL },
+/* Set 16: Mac Pro 3,1 (2 x Quad-Core) */
+	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
+	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "TH0P", "TH1P",
+	  "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S", "TM1P",
+	  "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P", "TM9S",
+	  "TN0C", "TN0D", "TN0H", "TS0C", "Tp0C", "Tp1C", "Tv0S", "Tv1S",
+	  NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1153,6 +1160,16 @@ static SENSOR_DEVICE_ATTR(temp34_input, 
 					applesmc_show_temperature, NULL, 33);
 static SENSOR_DEVICE_ATTR(temp35_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 34);
+static SENSOR_DEVICE_ATTR(temp36_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 35);
+static SENSOR_DEVICE_ATTR(temp37_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 36);
+static SENSOR_DEVICE_ATTR(temp38_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 37);
+static SENSOR_DEVICE_ATTR(temp39_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 38);
+static SENSOR_DEVICE_ATTR(temp40_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 39);
 
 static struct attribute *temperature_attributes[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
@@ -1190,6 +1207,11 @@ static struct attribute *temperature_att
 	&sensor_dev_attr_temp33_input.dev_attr.attr,
 	&sensor_dev_attr_temp34_input.dev_attr.attr,
 	&sensor_dev_attr_temp35_input.dev_attr.attr,
+	&sensor_dev_attr_temp36_input.dev_attr.attr,
+	&sensor_dev_attr_temp37_input.dev_attr.attr,
+	&sensor_dev_attr_temp38_input.dev_attr.attr,
+	&sensor_dev_attr_temp39_input.dev_attr.attr,
+	&sensor_dev_attr_temp40_input.dev_attr.attr,
 	NULL
 };
 
@@ -1312,6 +1334,8 @@ static __initdata struct dmi_match_data 
 	{ .accelerometer = 0, .light = 0, .temperature_set = 14 },
 /* MacBook Air 2,1: accelerometer, backlight and temperature set 15 */
 	{ .accelerometer = 1, .light = 1, .temperature_set = 15 },
+/* MacPro3,1: temperature set 16 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 16 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1369,6 +1393,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
 		&applesmc_dmi_data[4]},
+	{ applesmc_dmi_match, "Apple MacPro3", {
+	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro3") },
+		&applesmc_dmi_data[16]},
 	{ applesmc_dmi_match, "Apple MacPro", {
 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacPro") },
_

Patches currently in -mm which might be from bramesh@vt.edu are

origin.patch

