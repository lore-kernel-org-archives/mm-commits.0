From: akpm@linux-foundation.org
Subject: [merged] lis3-scale-output-values-to-mg.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:39 -0800
Message-ID: <200912152159.nBFLxdcU015921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933854AbZLOWAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:00:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: scale output values to mg
has been removed from the -mm tree.  Its filename was
     lis3-scale-output-values-to-mg.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: scale output values to mg
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Report output values as 1/1000 of earth gravity.

Output values from lis3 can be read from sysfs position entry and from
input device.  Input device can be accessed as event device and as
joystick device.  Joystick device can be in two modes.  Meaning of the
output values varies from case to case depending on the chip type and
configuration (scale).  Only joystick interface in JS_CORR_BROKEN mode
returned somehow similar output values in different configurations.=20
Joystick device is in that state by default in case of lis3.

Position sysfs entry, input event device and raw joystick device have b=
een
little bit broken since meaning of the output values has been varied
between 12 and 8 bit devices.  Applications which relayed on those meth=
ods
failed if the chip is different than the expected one.

This patch converts output values to mean similar thing in different
configurations.  Both 8 and 12 bit devices reports now same acceleratio=
n
values.  If somebody implements full scale support to the driver, outpu=
t
values will still mean the same.  Scaling factor and input device range
must be updated in that case.

Joystick interface in JS_CORR_BROKEN mode is not touched by this patch.=
=20
All other interfaces have different scale after this change.  For 12 bi=
t
device scaling factor is 0.977 which keeps scaled and unscaled values a=
re
quite close to each others.  For 8 bit device, scaled values are 18 tim=
es
bigger than unscaled values.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: =C9ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   30 +++++++++++++++++++++++++++---
 drivers/hwmon/lis3lv02d.h |    4 ++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-scale-output-values-to-mg driv=
ers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-scale-output-values-to-mg
+++ a/drivers/hwmon/lis3lv02d.c
@@ -53,6 +53,20 @@
 #define LIS3_PWRON_DELAY_WAI_12B	(5000)
 #define LIS3_PWRON_DELAY_WAI_8B		(3000)
=20
+/*
+ * LIS3LV02D spec says 1024 LSBs corresponds 1 G -> 1LSB is 1000/1024 =
mG
+ * LIS302D spec says: 18 mG / digit
+ * LIS3_ACCURACY is used to increase accuracy of the intermediate
+ * calculation results.
+ */
+#define LIS3_ACCURACY			1024
+/* Sensitivity values for -2G +2G scale */
+#define LIS3_SENSITIVITY_12B		((LIS3_ACCURACY * 1000) / 1024)
+#define LIS3_SENSITIVITY_8B		(18 * LIS3_ACCURACY)
+
+#define LIS3_DEFAULT_FUZZ		3
+#define LIS3_DEFAULT_FLAT		3
+
 struct lis3lv02d lis3_dev =3D {
 	.misc_wait   =3D __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
 };
@@ -105,6 +119,7 @@ static inline int lis3lv02d_get_axis(s8=20
 static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, =
int *z)
 {
 	int position[3];
+	int i;
=20
 	mutex_lock(&lis3->mutex);
 	position[0] =3D lis3->read_data(lis3, OUTX);
@@ -112,6 +127,9 @@ static void lis3lv02d_get_xyz(struct lis
 	position[2] =3D lis3->read_data(lis3, OUTZ);
 	mutex_unlock(&lis3->mutex);
=20
+	for (i =3D 0; i < 3; i++)
+		position[i] =3D (position[i] * lis3->scale) / LIS3_ACCURACY;
+
 	*x =3D lis3lv02d_get_axis(lis3->ac.x, position);
 	*y =3D lis3lv02d_get_axis(lis3->ac.y, position);
 	*z =3D lis3lv02d_get_axis(lis3->ac.z, position);
@@ -377,6 +395,7 @@ int lis3lv02d_joystick_enable(void)
 {
 	struct input_dev *input_dev;
 	int err;
+	int max_val, fuzz, flat;
=20
 	if (lis3_dev.idev)
 		return -EINVAL;
@@ -396,9 +415,12 @@ int lis3lv02d_joystick_enable(void)
 	input_dev->dev.parent =3D &lis3_dev.pdev->dev;
=20
 	set_bit(EV_ABS, input_dev->evbit);
-	input_set_abs_params(input_dev, ABS_X, -lis3_dev.mdps_max_val, lis3_d=
ev.mdps_max_val, 3, 3);
-	input_set_abs_params(input_dev, ABS_Y, -lis3_dev.mdps_max_val, lis3_d=
ev.mdps_max_val, 3, 3);
-	input_set_abs_params(input_dev, ABS_Z, -lis3_dev.mdps_max_val, lis3_d=
ev.mdps_max_val, 3, 3);
+	max_val =3D (lis3_dev.mdps_max_val * lis3_dev.scale) / LIS3_ACCURACY;
+	fuzz =3D (LIS3_DEFAULT_FUZZ * lis3_dev.scale) / LIS3_ACCURACY;
+	flat =3D (LIS3_DEFAULT_FLAT * lis3_dev.scale) / LIS3_ACCURACY;
+	input_set_abs_params(input_dev, ABS_X, -max_val, max_val, fuzz, flat)=
;
+	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat)=
;
+	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat)=
;
=20
 	err =3D input_register_polled_device(lis3_dev.idev);
 	if (err) {
@@ -515,6 +537,7 @@ int lis3lv02d_init_device(struct lis3lv0
 		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_12B;
 		dev->odrs =3D lis3_12_rates;
 		dev->odr_mask =3D CTRL1_DF0 | CTRL1_DF1;
+		dev->scale =3D LIS3_SENSITIVITY_12B;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
@@ -523,6 +546,7 @@ int lis3lv02d_init_device(struct lis3lv0
 		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
 		dev->odrs =3D lis3_8_rates;
 		dev->odr_mask =3D CTRL1_DR;
+		dev->scale =3D LIS3_SENSITIVITY_8B;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff -puN drivers/hwmon/lis3lv02d.h~lis3-scale-output-values-to-mg driv=
ers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-scale-output-values-to-mg
+++ a/drivers/hwmon/lis3lv02d.h
@@ -214,6 +214,10 @@ struct lis3lv02d {
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 	int			pwron_delay;
+	int                     scale; /*
+					* relationship between 1 LBS and mG
+					* (1/1000th of earth gravity)
+					*/
=20
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
