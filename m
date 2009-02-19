From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-support-both-one-and-two-byte-sensors.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:49 -0800
Message-ID: <200902191916.n1JJGnT2016288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbZBSTQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giuseppe.bilotta@gmail.com, Eric.Piel@tremplin-utc.net, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: support both one- and two-byte sensors
has been removed from the -mm tree.  Its filename was
     lis3lv02d-support-both-one-and-two-byte-sensors.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3lv02d: support both one- and two-byte sensors
=46rom: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>

Sensors responding with 0x3B to WHO_AM_I only have one data register pe=
r
direction, thus returning a signed byte from the position which is
occupied by the MSB in sensors responding with 0x3A.

Since multiple sensors share the reply to WHO_AM_I, we rename the defin=
es
to better indicate what they identify (family of single and double
precision sensors).

We support both kind of sensors by checking for the sensor type on init
and defining appropriate data-access routines and sensor limits (for th=
e
joystick) depending on what we find.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Acked-by: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c  |   36 ++++++++++++++++++++++++++++++++----
 drivers/hwmon/lis3lv02d.c |   25 ++++++-------------------
 drivers/hwmon/lis3lv02d.h |   16 +++++++++++++---
 3 files changed, 51 insertions(+), 26 deletions(-)

diff -puN drivers/hwmon/hp_accel.c~lis3lv02d-support-both-one-and-two-b=
yte-sensors drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3lv02d-support-both-one-and-two-byte-=
sensors
+++ a/drivers/hwmon/hp_accel.c
@@ -237,9 +237,25 @@ static void lis3lv02d_enum_resources(str
 		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
 }
=20
+static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
+{
+	u8 lo, hi;
+
+	adev.read(handle, reg - 1, &lo);
+	adev.read(handle, reg, &hi);
+	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 =3D bit 5 */
+	return (s16)((hi << 8) | lo);
+}
+
+static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
+{
+	s8 lo;
+	adev.read(handle, reg, &lo);
+	return lo;
+}
+
 static int lis3lv02d_add(struct acpi_device *device)
 {
-	u8 val;
 	int ret;
=20
 	if (!device)
@@ -253,10 +269,22 @@ static int lis3lv02d_add(struct acpi_dev
 	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
 	device->driver_data =3D &adev;
=20
-	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
-	if ((val !=3D LIS3LV02DL_ID) && (val !=3D LIS302DL_ID)) {
+	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &adev.whoami);
+	switch (adev.whoami) {
+	case LIS_DOUBLE_ID:
+		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
+		adev.read_data =3D lis3lv02d_read_16;
+		adev.mdps_max_val =3D 2048;
+		break;
+	case LIS_SINGLE_ID:
+		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
+		adev.read_data =3D lis3lv02d_read_8;
+		adev.mdps_max_val =3D 128;
+		break;
+	default:
 		printk(KERN_ERR DRIVER_NAME
-				": Accelerometer chip not LIS3LV02D{L,Q}\n");
+			": unknown sensor type 0x%X\n", adev.whoami);
+		return -EINVAL;
 	}
=20
 	/* If possible use a "standard" axes order */
diff -puN drivers/hwmon/lis3lv02d.c~lis3lv02d-support-both-one-and-two-=
byte-sensors drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3lv02d-support-both-one-and-two-byte=
-sensors
+++ a/drivers/hwmon/lis3lv02d.c
@@ -53,9 +53,6 @@
  * joystick.
  */
=20
-/* Maximum value our axis may get for the input device (signed 12 bits=
) */
-#define MDPS_MAX_VAL 2048
-
 struct acpi_lis3lv02d adev =3D {
 	.misc_wait   =3D __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
 };
@@ -64,16 +61,6 @@ EXPORT_SYMBOL_GPL(adev);
=20
 static int lis3lv02d_add_fs(struct acpi_device *device);
=20
-static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
-{
-	u8 lo, hi;
-
-	adev.read(handle, reg, &lo);
-	adev.read(handle, reg + 1, &hi);
-	/* In "12 bit right justified" mode, bit 6, bit 7, bit 8 =3D bit 5 */
-	return (s16)((hi << 8) | lo);
-}
-
 /**
  * lis3lv02d_get_axis - For the given axis, give the value converted
  * @axis:      1,2,3 - can also be negative
@@ -102,9 +89,9 @@ static void lis3lv02d_get_xyz(acpi_handl
 {
 	int position[3];
=20
-	position[0] =3D lis3lv02d_read_16(handle, OUTX_L);
-	position[1] =3D lis3lv02d_read_16(handle, OUTY_L);
-	position[2] =3D lis3lv02d_read_16(handle, OUTZ_L);
+	position[0] =3D adev.read_data(handle, OUTX);
+	position[1] =3D adev.read_data(handle, OUTY);
+	position[2] =3D adev.read_data(handle, OUTZ);
=20
 	*x =3D lis3lv02d_get_axis(adev.ac.x, position);
 	*y =3D lis3lv02d_get_axis(adev.ac.y, position);
@@ -355,9 +342,9 @@ int lis3lv02d_joystick_enable(void)
 	adev.idev->close      =3D lis3lv02d_joystick_close;
=20
 	set_bit(EV_ABS, adev.idev->evbit);
-	input_set_abs_params(adev.idev, ABS_X, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3=
, 3);
-	input_set_abs_params(adev.idev, ABS_Y, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3=
, 3);
-	input_set_abs_params(adev.idev, ABS_Z, -MDPS_MAX_VAL, MDPS_MAX_VAL, 3=
, 3);
+	input_set_abs_params(adev.idev, ABS_X, -adev.mdps_max_val, adev.mdps_=
max_val, 3, 3);
+	input_set_abs_params(adev.idev, ABS_Y, -adev.mdps_max_val, adev.mdps_=
max_val, 3, 3);
+	input_set_abs_params(adev.idev, ABS_Z, -adev.mdps_max_val, adev.mdps_=
max_val, 3, 3);
=20
 	err =3D input_register_device(adev.idev);
 	if (err) {
diff -puN drivers/hwmon/lis3lv02d.h~lis3lv02d-support-both-one-and-two-=
byte-sensors drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3lv02d-support-both-one-and-two-byte=
-sensors
+++ a/drivers/hwmon/lis3lv02d.h
@@ -22,12 +22,15 @@
 /*
  * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that=
 seems to
  * be connected via SPI. There exists also several similar chips (such=
 as LIS302DL or
- * LIS3L02DQ) but not in the HP laptops and they have slightly differe=
nt registers.
+ * LIS3L02DQ) and they have slightly different registers, but we can p=
rovide a
+ * common interface for all of them.
  * They can also be connected via I=C2=B2C.
  */
=20
-#define LIS3LV02DL_ID	0x3A /* Also the LIS3LV02DQ */
-#define LIS302DL_ID	0x3B /* Also the LIS202DL! */
+/* 2-byte registers */
+#define LIS_DOUBLE_ID	0x3A /* LIS3LV02D[LQ] */
+/* 1-byte registers */
+#define LIS_SINGLE_ID	0x3B /* LIS[32]02DL and others */
=20
 enum lis3lv02d_reg {
 	WHO_AM_I	=3D 0x0F,
@@ -44,10 +47,13 @@ enum lis3lv02d_reg {
 	STATUS_REG	=3D 0x27,
 	OUTX_L		=3D 0x28,
 	OUTX_H		=3D 0x29,
+	OUTX		=3D 0x29,
 	OUTY_L		=3D 0x2A,
 	OUTY_H		=3D 0x2B,
+	OUTY		=3D 0x2B,
 	OUTZ_L		=3D 0x2C,
 	OUTZ_H		=3D 0x2D,
+	OUTZ		=3D 0x2D,
 	FF_WU_CFG	=3D 0x30,
 	FF_WU_SRC	=3D 0x31,
 	FF_WU_ACK	=3D 0x32,
@@ -159,6 +165,10 @@ struct acpi_lis3lv02d {
 	acpi_status (*write) (acpi_handle handle, int reg, u8 val);
 	acpi_status (*read) (acpi_handle handle, int reg, u8 *ret);
=20
+	u8			whoami;    /* 3Ah: 2-byte registries, 3Bh: 1-byte registries */
+	s16 (*read_data) (acpi_handle handle, int reg);
+	int			mdps_max_val;
+
 	struct input_dev	*idev;     /* input device */
 	struct task_struct	*kthread;  /* kthread for input */
 	struct mutex            lock;
_

Patches currently in -mm which might be from giuseppe.bilotta@gmail.com=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
