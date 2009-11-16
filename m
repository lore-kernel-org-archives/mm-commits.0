From: akpm@linux-foundation.org
Subject: + lis3-update-documentation-and-comments.patch added to -mm tree
Date: Mon, 16 Nov 2009 12:04:14 -0800
Message-ID: <200911162004.nAGK4Fmv027688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbZKPUER (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 15:04:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, pavel@ucw.cz, samu.p.onkalo@nokia.com


The patch titled
     lis3: update documentation and comments
has been added to the -mm tree.  Its filename is
     lis3-update-documentation-and-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: update documentation and comments
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>

Most of the documentation and comments were written when the driver was
only supporting one type of chip, only via ACPI/HP. Update the info to
the much clearer understanding that we have now.

Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/lis3lv02d |   24 ++++++++++++++----------
 drivers/hwmon/Kconfig         |   22 ++++++++++++----------
 drivers/hwmon/lis3lv02d.c     |   20 ++++++++++----------
 drivers/hwmon/lis3lv02d.h     |   28 ++++++++++++++++------------
 4 files changed, 52 insertions(+), 42 deletions(-)

diff -puN Documentation/hwmon/lis3lv02d~lis3-update-documentation-and-c=
omments Documentation/hwmon/lis3lv02d
--- a/Documentation/hwmon/lis3lv02d~lis3-update-documentation-and-comme=
nts
+++ a/Documentation/hwmon/lis3lv02d
@@ -3,7 +3,8 @@ Kernel driver lis3lv02d
=20
 Supported chips:
=20
-  * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
+  * STMicroelectronics LIS3LV02DL, LIS3LV02DQ (12 bits precision)
+  * STMicroelectronics LIS302DL, LIS3L02DQ, LIS331DL (8 bits)
=20
 Authors:
         Yan Burman <burman.yan@gmail.com>
@@ -13,13 +14,12 @@ Authors:
 Description
 -----------
=20
-This driver provides support for the accelerometer found in various HP
-laptops sporting the feature officially called "HP Mobile Data
-Protection System 3D" or "HP 3D DriveGuard". It detects automatically
-laptops with this sensor. Known models (for now the HP 2133, nc6420,
-nc2510, nc8510, nc84x0, nw9440 and nx9420) will have their axis
-automatically oriented on standard way (eg: you can directly play
-neverball).  The accelerometer data is readable via
+This driver provides support for the accelerometer found in various HP=
 laptops
+sporting the feature officially called "HP Mobile Data Protection Syst=
em 3D" or
+"HP 3D DriveGuard". It detects automatically laptops with this sensor.=
 Known
+models (full list can be found in drivers/hwmon/hp_accel.c) will have =
their
+axis automatically oriented on standard way (eg: you can directly play
+neverball). The accelerometer data is readable via
 /sys/devices/platform/lis3lv02d.
=20
 Sysfs attributes under /sys/devices/platform/lis3lv02d/:
@@ -33,12 +33,16 @@ rate - reports the sampling rate of the=20
 This driver also provides an absolute input class device, allowing
 the laptop to act as a pinball machine-esque joystick.
=20
+On HP laptops, if the led infrastructure is activated, support for a l=
ed
+indicating disk protection will be provided as /sys/class/leds/hp::hdd=
protect.
+
 Another feature of the driver is misc device called "freefall" that
 acts similar to /dev/rtc and reacts on free-fall interrupts received
 from the device. It supports blocking operations, poll/select and
 fasync operation modes. You must read 1 bytes from the device.  The
 result is number of free-fall interrupts since the last successful
-read (or 255 if number of interrupts would not fit).
+read (or 255 if number of interrupts would not fit). See the hpfall.c
+file for an example on using the device.
=20
=20
 Axes orientation
@@ -55,7 +59,7 @@ the accelerometer are converted into a "
  * If the laptop is put upside-down, Z becomes negative
=20
 If your laptop model is not recognized (cf "dmesg"), you can send an
-email to the authors to add it to the database.  When reporting a new
+email to the maintainer to add it to the database.  When reporting a n=
ew
 laptop, please include the output of "dmidecode" plus the value of
 /sys/devices/platform/lis3lv02d/position in these four cases.
=20
diff -puN drivers/hwmon/Kconfig~lis3-update-documentation-and-comments =
drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~lis3-update-documentation-and-comments
+++ a/drivers/hwmon/Kconfig
@@ -1071,25 +1071,27 @@ config SENSORS_ATK0110
 	  will be called asus_atk0110.
=20
 config SENSORS_LIS3LV02D
-	tristate "STMicroeletronics LIS3LV02Dx three-axis digital acceleromet=
er"
+	tristate "STMicroeletronics LIS3* three-axis digital accelerometer"
 	depends on INPUT
 	select INPUT_POLLDEV
 	select NEW_LEDS
 	select LEDS_CLASS
 	default n
 	help
-	  This driver provides support for the LIS3LV02Dx accelerometer. In
-	  particular, it can be found in a number of HP laptops, which have t=
he
-	  "Mobile Data Protection System 3D" or "3D DriveGuard" feature. On s=
uch
-	  systems the driver should load automatically (via ACPI). The
-	  accelerometer might also be found in other systems, connected via S=
PI
-	  or I2C.  The accelerometer data is readable via
-	  /sys/devices/platform/lis3lv02d.
+	  This driver provides support for the LIS3* accelerometers, such as =
the
+	  LIS3LV02DL or the LIS331DL. In particular, it can be found in a num=
ber
+	  of HP laptops, which have the "Mobile Data Protection System 3D" or
+	  "3D DriveGuard" feature. On such systems the driver should load
+	  automatically (via ACPI alias). The accelerometer might also be fou=
nd
+	  in other systems, connected via SPI or I2C. The accelerometer data =
is
+	  readable via /sys/devices/platform/lis3lv02d.
=20
 	  This driver also provides an absolute input class device, allowing
-	  the laptop to act as a pinball machine-esque joystick. On HP laptop=
s,
+	  a laptop to act as a pinball machine-esque joystick. It provides al=
so
+	  a misc device which can be used to detect free-fall. On HP laptops,
 	  if the led infrastructure is activated, support for a led indicatin=
g
-	  disk protection will be provided as hp:red:hddprotection.
+	  disk protection will be provided as hp::hddprotect. For more
+	  information on the feature, refer to Documentation/hwmon/lis3lv02d.
=20
 	  This driver can also be built as modules.  If so, the core module
 	  will be called lis3lv02d and a specific module for HP laptops will =
be
diff -puN drivers/hwmon/lis3lv02d.c~lis3-update-documentation-and-comme=
nts drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-update-documentation-and-comments
+++ a/drivers/hwmon/lis3lv02d.c
@@ -43,7 +43,7 @@
 #define MDPS_POLL_INTERVAL 50
 /*
  * The sensor can also generate interrupts (DRDY) but it's pretty poin=
tless
- * because their are generated even if the data do not change. So it's=
 better
+ * because they are generated even if the data do not change. So it's =
better
  * to keep the interrupt for the free-fall event. The values are updat=
ed at
  * 40Hz (at the lowest frequency), but as it can be pretty time consum=
ing on
  * some low processor, we poll the sensor only at 20Hz... enough for t=
he
@@ -65,7 +65,7 @@ static s16 lis3lv02d_read_8(struct lis3l
 	return lo;
 }
=20
-static s16 lis3lv02d_read_16(struct lis3lv02d *lis3, int reg)
+static s16 lis3lv02d_read_12(struct lis3lv02d *lis3, int reg)
 {
 	u8 lo, hi;
=20
@@ -411,20 +411,20 @@ EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
=20
 /*
  * Initialise the accelerometer and the various subsystems.
- * Should be rather independant of the bus system.
+ * Should be rather independent of the bus system.
  */
 int lis3lv02d_init_device(struct lis3lv02d *dev)
 {
 	dev->whoami =3D lis3lv02d_read_8(dev, WHO_AM_I);
=20
 	switch (dev->whoami) {
-	case LIS_DOUBLE_ID:
-		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
-		dev->read_data =3D lis3lv02d_read_16;
+	case WAI_12B:
+		printk(KERN_INFO DRIVER_NAME ": 12 bits sensor found\n");
+		dev->read_data =3D lis3lv02d_read_12;
 		dev->mdps_max_val =3D 2048;
 		break;
-	case LIS_SINGLE_ID:
-		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
+	case WAI_8B:
+		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data =3D lis3lv02d_read_8;
 		dev->mdps_max_val =3D 128;
 		break;
@@ -445,7 +445,7 @@ int lis3lv02d_init_device(struct lis3lv0
 	if (dev->pdata) {
 		struct lis3lv02d_platform_data *p =3D dev->pdata;
=20
-		if (p->click_flags && (dev->whoami =3D=3D LIS_SINGLE_ID)) {
+		if (p->click_flags && (dev->whoami =3D=3D WAI_8B)) {
 			dev->write(dev, CLICK_CFG, p->click_flags);
 			dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
 			dev->write(dev, CLICK_LATENCY, p->click_latency);
@@ -456,7 +456,7 @@ int lis3lv02d_init_device(struct lis3lv0
 					(p->click_thresh_y << 4));
 		}
=20
-		if (p->wakeup_flags && (dev->whoami =3D=3D LIS_SINGLE_ID)) {
+		if (p->wakeup_flags && (dev->whoami =3D=3D WAI_8B)) {
 			dev->write(dev, FF_WU_CFG_1, p->wakeup_flags);
 			dev->write(dev, FF_WU_THS_1, p->wakeup_thresh & 0x7f);
 			/* default to 2.5ms for now */
diff -puN drivers/hwmon/lis3lv02d.h~lis3-update-documentation-and-comme=
nts drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-update-documentation-and-comments
+++ a/drivers/hwmon/lis3lv02d.h
@@ -2,7 +2,7 @@
  *  lis3lv02d.h - ST LIS3LV02DL accelerometer driver
  *
  *  Copyright (C) 2007-2008 Yan Burman
- *  Copyright (C) 2008 Eric Piel
+ *  Copyright (C) 2008-2009 Eric Piel
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
  *  it under the terms of the GNU General Public License as published =
by
@@ -22,20 +22,18 @@
 #include <linux/input-polldev.h>
=20
 /*
- * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that=
 seems to
- * be connected via SPI. There exists also several similar chips (such=
 as LIS302DL or
- * LIS3L02DQ) and they have slightly different registers, but we can p=
rovide a
- * common interface for all of them.
- * They can also be connected via I=C2=B2C.
+ * This driver tries to support the "digital" accelerometer chips from
+ * STMicroelectronics such as LIS3LV02DL, LIS302DL, LIS3L02DQ, LIS331D=
L,
+ * LIS35DE, or LIS202DL. They are very similar in terms of programming=
, with
+ * almost the same registers. In addition to differing on physical pro=
perties,
+ * they differ on the number of axes (2/3), precision (8/12 bits), and=
 special
+ * features (freefall detection, click...). Unfortunately, not all the
+ * differences can be probed via a register.
+ * They can be connected either via I=C2=B2C or SPI.
  */
=20
 #include <linux/lis3lv02d.h>
=20
-/* 2-byte registers */
-#define LIS_DOUBLE_ID	0x3A /* LIS3LV02D[LQ] */
-/* 1-byte registers */
-#define LIS_SINGLE_ID	0x3B /* LIS[32]02DL and others */
-
 enum lis3_reg {
 	WHO_AM_I	=3D 0x0F,
 	OFFSET_X	=3D 0x16,
@@ -94,6 +92,12 @@ enum lis3lv02d_reg {
 	DD_THSE_H	=3D 0x3F,
 };
=20
+enum lis3_who_am_i {
+	WAI_12B		=3D 0x3A, /* 12 bits: LIS3LV02D[LQ]... */
+	WAI_8B		=3D 0x3B, /* 8 bits: LIS[23]02D[LQ]... */
+	WAI_6B		=3D 0x52, /* 6 bits: LIS331DLF - not supported */
+};
+
 enum lis3lv02d_ctrl1 {
 	CTRL1_Xen	=3D 0x01,
 	CTRL1_Yen	=3D 0x02,
@@ -194,7 +198,7 @@ struct lis3lv02d {
 	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
 	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
=20
-	u8			whoami;    /* 3Ah: 2-byte registries, 3Bh: 1-byte registries */
+	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
=20
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

linux-next.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
lis3lv02d-send-sync-event.patch
lis3lv02d-correct-memory-leak-in-module-unload.patch
lis3-update-documentation-and-comments.patch
lis3-fix-show-rate-for-8-bits-chips.patch
lis3lv02d-proper-power-on-sequence.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
