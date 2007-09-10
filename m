From: akpm@linux-foundation.org
Subject: + applesmc-for-mac-pro-2-x-quad-core.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:54:19 -0700
Message-ID: <200709100854.l8A8sJuV016193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755606AbXIJIyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene@exactcode.de, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch


The patch titled
     applesmc for Mac Pro 2 x Quad-Core
has been added to the -mm tree.  Its filename is
     applesmc-for-mac-pro-2-x-quad-core.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: applesmc for Mac Pro 2 x Quad-Core
=46rom: Ren=E9 Rebe <rene@exactcode.de

At least the 2x Quad-Core Apple Mac Pro appears to have some over-heat
protection which suddenly powers off the whole box under load.  This ad=
ds
support for the fans and temerature sensors in the Mac Pro - later some
"windwarm" a-like code should probably monitor the values.  For now
manually tweaking the fans prevents the sudden shutdown for me.

cd /sys/devices/platform/applesmc.768
for x in fan{1,2,3,4}; do
	echo 1 > ${x}_manual
	echo 1285 > ${x}_output
done

Two sensors are 0, while four are 129 =B0C, those might be removed agai=
n,
later.

Signed-off-by: Ren=E9 Rebe <rene@exactcode.de
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |  107 ++++++++++++++++++++++++++++++++++---
 1 file changed, 101 insertions(+), 6 deletions(-)

diff -puN drivers/hwmon/applesmc.c~applesmc-for-mac-pro-2-x-quad-core d=
rivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~applesmc-for-mac-pro-2-x-quad-core
+++ a/drivers/hwmon/applesmc.c
@@ -80,7 +80,7 @@
 /*
  * Temperature sensors keys (sp78 - 2 bytes).
  */
-static const char* temperature_sensors_sets[][13] =3D {
+static const char* temperature_sensors_sets[][36] =3D {
 /* Set 0: Macbook Pro */
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
@@ -88,7 +88,13 @@ static const char* temperature_sensors_s
 	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
 	  "Th1H", "Ts0P", NULL },
 /* Set 2: Macmini set */
-	{ "TC0D", "TC0P", NULL }
+	{ "TC0D", "TC0P", NULL },
+/* Set 3: Mac Pro (2 x Quad-Core) */
+	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
+	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "THTG", "TH0P",
+	  "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S",
+	  "TM1P", "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P",
+	  "TM9S", "TN0H", "TS0C", NULL },
 };
=20
 /* List of keys used to read/write fan speeds */
@@ -1009,14 +1015,18 @@ static struct attribute *fan##offset##_a
=20
 /*
  * Create the needed functions for each fan using the macro defined ab=
ove
- * (2 fans are supported)
+ * (4 fans are supported)
  */
 sysfs_fan_speeds_offset(1);
 sysfs_fan_speeds_offset(2);
+sysfs_fan_speeds_offset(3);
+sysfs_fan_speeds_offset(4);
=20
 static const struct attribute_group fan_attribute_groups[] =3D {
 	{ .attrs =3D fan1_attributes },
-	{ .attrs =3D fan2_attributes }
+	{ .attrs =3D fan2_attributes },
+	{ .attrs =3D fan3_attributes },
+	{ .attrs =3D fan4_attributes }
 };
=20
 /*
@@ -1046,6 +1056,52 @@ static SENSOR_DEVICE_ATTR(temp11_input,=20
 					applesmc_show_temperature, NULL, 10);
 static SENSOR_DEVICE_ATTR(temp12_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 11);
+static SENSOR_DEVICE_ATTR(temp13_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 12);
+static SENSOR_DEVICE_ATTR(temp14_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 13);
+static SENSOR_DEVICE_ATTR(temp15_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 14);
+static SENSOR_DEVICE_ATTR(temp16_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 15);
+static SENSOR_DEVICE_ATTR(temp17_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 16);
+static SENSOR_DEVICE_ATTR(temp18_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 17);
+static SENSOR_DEVICE_ATTR(temp19_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 18);
+static SENSOR_DEVICE_ATTR(temp20_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 19);
+static SENSOR_DEVICE_ATTR(temp21_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 20);
+static SENSOR_DEVICE_ATTR(temp22_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 21);
+static SENSOR_DEVICE_ATTR(temp23_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 22);
+static SENSOR_DEVICE_ATTR(temp24_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 23);
+static SENSOR_DEVICE_ATTR(temp25_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 24);
+static SENSOR_DEVICE_ATTR(temp26_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 25);
+static SENSOR_DEVICE_ATTR(temp27_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 26);
+static SENSOR_DEVICE_ATTR(temp28_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 27);
+static SENSOR_DEVICE_ATTR(temp29_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 28);
+static SENSOR_DEVICE_ATTR(temp30_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 29);
+static SENSOR_DEVICE_ATTR(temp31_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 30);
+static SENSOR_DEVICE_ATTR(temp32_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 31);
+static SENSOR_DEVICE_ATTR(temp33_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 32);
+static SENSOR_DEVICE_ATTR(temp34_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 33);
+static SENSOR_DEVICE_ATTR(temp35_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 34);
=20
 static struct attribute *temperature_attributes[] =3D {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
@@ -1060,6 +1116,29 @@ static struct attribute *temperature_att
 	&sensor_dev_attr_temp10_input.dev_attr.attr,
 	&sensor_dev_attr_temp11_input.dev_attr.attr,
 	&sensor_dev_attr_temp12_input.dev_attr.attr,
+	&sensor_dev_attr_temp13_input.dev_attr.attr,
+	&sensor_dev_attr_temp14_input.dev_attr.attr,
+	&sensor_dev_attr_temp15_input.dev_attr.attr,
+	&sensor_dev_attr_temp16_input.dev_attr.attr,
+	&sensor_dev_attr_temp17_input.dev_attr.attr,
+	&sensor_dev_attr_temp18_input.dev_attr.attr,
+	&sensor_dev_attr_temp19_input.dev_attr.attr,
+	&sensor_dev_attr_temp20_input.dev_attr.attr,
+	&sensor_dev_attr_temp21_input.dev_attr.attr,
+	&sensor_dev_attr_temp22_input.dev_attr.attr,
+	&sensor_dev_attr_temp23_input.dev_attr.attr,
+	&sensor_dev_attr_temp24_input.dev_attr.attr,
+	&sensor_dev_attr_temp25_input.dev_attr.attr,
+	&sensor_dev_attr_temp26_input.dev_attr.attr,
+	&sensor_dev_attr_temp27_input.dev_attr.attr,
+	&sensor_dev_attr_temp28_input.dev_attr.attr,
+	&sensor_dev_attr_temp29_input.dev_attr.attr,
+	&sensor_dev_attr_temp30_input.dev_attr.attr,
+	&sensor_dev_attr_temp31_input.dev_attr.attr,
+	&sensor_dev_attr_temp32_input.dev_attr.attr,
+	&sensor_dev_attr_temp33_input.dev_attr.attr,
+	&sensor_dev_attr_temp34_input.dev_attr.attr,
+	&sensor_dev_attr_temp35_input.dev_attr.attr,
 	NULL
 };
=20
@@ -1158,6 +1237,8 @@ static __initdata struct dmi_match_data=20
 	{ .accelerometer =3D 1, .light =3D 0, .temperature_set =3D 1 },
 /* MacMini: temperature set 2 */
 	{ .accelerometer =3D 0, .light =3D 0, .temperature_set =3D 2 },
+/* MacPro: temperature set 3 */
+	{ .accelerometer =3D 0, .light =3D 0, .temperature_set =3D 3 },
 };
=20
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1175,6 +1256,10 @@ static __initdata struct dmi_system_id a
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
 		(void*)&applesmc_dmi_data[2]},
+	{ applesmc_dmi_match, "Apple MacPro2", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
+		(void*)&applesmc_dmi_data[3]},
 	{ .ident =3D NULL }
 };
=20
@@ -1227,9 +1312,19 @@ static int __init applesmc_init(void)
=20
 		switch (count) {
 		default:
-			printk(KERN_WARNING "applesmc: More than 2 fans found,"
-					" but at most 2 fans are supported"
+			printk(KERN_WARNING "applesmc: More than 4 fans found,"
+					" but at most 4 fans are supported"
 						" by the driver.\n");
+		case 4:
+			ret =3D sysfs_create_group(&pdev->dev.kobj,
+						 &fan_attribute_groups[3]);
+			if (ret)
+				goto out_key_enumeration;
+		case 3:
+			ret =3D sysfs_create_group(&pdev->dev.kobj,
+						 &fan_attribute_groups[2]);
+			if (ret)
+				goto out_key_enumeration;
 		case 2:
 			ret =3D sysfs_create_group(&pdev->dev.kobj,
 						 &fan_attribute_groups[1]);
_

Patches currently in -mm which might be from rene@exactcode.de are

applesmc-for-mac-pro-2-x-quad-core.patch
