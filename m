From: akpm@linux-foundation.org
Subject: [merged] lis3-selftest-support.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:30 -0800
Message-ID: <200912152159.nBFLxU8p015908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933959AbZLOWPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:15:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: selftest support
has been removed from the -mm tree.  Its filename was
     lis3-selftest-support.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3: selftest support
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Implement selftest feature as specified by chip manufacturer.  Control:
read selftest sysfs entry

Response: "OK x y z" or "FAIL x y z"

where x, y, and z are difference between selftest mode and normal mode.=
=20
Test is passed when values are within acceptance limit values.

Acceptance limits are provided via platform data.  See chip spesificati=
ons
for acceptance limits.  If limits are not properly set, OK / FAIL decis=
ion
is meaningless.  However, userspace application can still make decision
based on the numeric x, y, z values.

Selftest is meant for HW diagnostic purposes.  It is not meant to be
called during normal use of the chip.  It may cause false interrupt
events.  Selftest mode delays polling of the normal results but it does=
n't
cause wrong values.  Chip must be in static state during selftest.  Any
acceration during the test causes most probably failure.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: =C9ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   67 +++++++++++++++++++++++++++++++++++-
 drivers/hwmon/lis3lv02d.h |   14 ++++++-
 include/linux/lis3lv02d.h |    3 +
 3 files changed, 81 insertions(+), 3 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-selftest-support drivers/hwmon=
/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-selftest-support
+++ a/drivers/hwmon/lis3lv02d.c
@@ -106,9 +106,11 @@ static void lis3lv02d_get_xyz(struct lis
 {
 	int position[3];
=20
+	mutex_lock(&lis3->mutex);
 	position[0] =3D lis3->read_data(lis3, OUTX);
 	position[1] =3D lis3->read_data(lis3, OUTY);
 	position[2] =3D lis3->read_data(lis3, OUTZ);
+	mutex_unlock(&lis3->mutex);
=20
 	*x =3D lis3lv02d_get_axis(lis3->ac.x, position);
 	*y =3D lis3lv02d_get_axis(lis3->ac.y, position);
@@ -133,6 +135,55 @@ static int lis3lv02d_get_odr(void)
 	return val;
 }
=20
+static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
+{
+	u8 reg;
+	s16 x, y, z;
+	u8 selftest;
+	int ret;
+
+	mutex_lock(&lis3->mutex);
+	if (lis3_dev.whoami =3D=3D WAI_12B)
+		selftest =3D CTRL1_ST;
+	else
+		selftest =3D CTRL1_STP;
+
+	lis3->read(lis3, CTRL_REG1, &reg);
+	lis3->write(lis3, CTRL_REG1, (reg | selftest));
+	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+
+	/* Read directly to avoid axis remap */
+	x =3D lis3->read_data(lis3, OUTX);
+	y =3D lis3->read_data(lis3, OUTY);
+	z =3D lis3->read_data(lis3, OUTZ);
+
+	/* back to normal settings */
+	lis3->write(lis3, CTRL_REG1, reg);
+	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+
+	results[0] =3D x - lis3->read_data(lis3, OUTX);
+	results[1] =3D y - lis3->read_data(lis3, OUTY);
+	results[2] =3D z - lis3->read_data(lis3, OUTZ);
+
+	ret =3D 0;
+	if (lis3->pdata) {
+		int i;
+		for (i =3D 0; i < 3; i++) {
+			/* Check against selftest acceptance limits */
+			if ((results[i] < lis3->pdata->st_min_limits[i]) ||
+			    (results[i] > lis3->pdata->st_max_limits[i])) {
+				ret =3D -EIO;
+				goto fail;
+			}
+		}
+	}
+
+	/* test passed */
+fail:
+	mutex_unlock(&lis3->mutex);
+	return ret;
+}
+
 void lis3lv02d_poweroff(struct lis3lv02d *lis3)
 {
 	/* disable X,Y,Z axis and power down */
@@ -365,6 +416,17 @@ void lis3lv02d_joystick_disable(void)
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
=20
 /* Sysfs stuff */
+static ssize_t lis3lv02d_selftest_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int result;
+	s16 values[3];
+
+	result =3D lis3lv02d_selftest(&lis3_dev, values);
+	return sprintf(buf, "%s %d %d %d\n", result =3D=3D 0 ? "OK" : "FAIL",
+		values[0], values[1], values[2]);
+}
+
 static ssize_t lis3lv02d_position_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -394,12 +456,14 @@ static ssize_t lis3lv02d_rate_show(struc
 	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
 }
=20
+static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
 static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, lis3lv02d_calibrate_sho=
w,
 	lis3lv02d_calibrate_store);
 static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
=20
 static struct attribute *lis3lv02d_attributes[] =3D {
+	&dev_attr_selftest.attr,
 	&dev_attr_position.attr,
 	&dev_attr_calibrate.attr,
 	&dev_attr_rate.attr,
@@ -455,6 +519,8 @@ int lis3lv02d_init_device(struct lis3lv0
 		return -EINVAL;
 	}
=20
+	mutex_init(&dev->mutex);
+
 	lis3lv02d_add_fs(dev);
 	lis3lv02d_poweron(dev);
=20
@@ -507,4 +573,3 @@ EXPORT_SYMBOL_GPL(lis3lv02d_init_device)
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer dri=
ver");
 MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
 MODULE_LICENSE("GPL");
-
diff -puN drivers/hwmon/lis3lv02d.h~lis3-selftest-support drivers/hwmon=
/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-selftest-support
+++ a/drivers/hwmon/lis3lv02d.h
@@ -98,7 +98,7 @@ enum lis3_who_am_i {
 	WAI_6B		=3D 0x52, /* 6 bits: LIS331DLF - not supported */
 };
=20
-enum lis3lv02d_ctrl1 {
+enum lis3lv02d_ctrl1_12b {
 	CTRL1_Xen	=3D 0x01,
 	CTRL1_Yen	=3D 0x02,
 	CTRL1_Zen	=3D 0x04,
@@ -107,8 +107,17 @@ enum lis3lv02d_ctrl1 {
 	CTRL1_DF1	=3D 0x20,
 	CTRL1_PD0	=3D 0x40,
 	CTRL1_PD1	=3D 0x80,
-	CTRL1_DR	=3D 0x80, /* Data rate on 8 bits */
 };
+
+/* Delta to ctrl1_12b version */
+enum lis3lv02d_ctrl1_8b {
+	CTRL1_STM	=3D 0x08,
+	CTRL1_STP	=3D 0x10,
+	CTRL1_FS	=3D 0x20,
+	CTRL1_PD	=3D 0x40,
+	CTRL1_DR	=3D 0x80,
+};
+
 enum lis3lv02d_ctrl2 {
 	CTRL2_DAS	=3D 0x01,
 	CTRL2_SIM	=3D 0x02,
@@ -218,6 +227,7 @@ struct lis3lv02d {
 	unsigned long		misc_opened; /* bit0: whether the device is open */
=20
 	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
+	struct mutex		mutex;     /* Serialize poll and selftest */
 };
=20
 int lis3lv02d_init_device(struct lis3lv02d *lis3);
diff -puN include/linux/lis3lv02d.h~lis3-selftest-support include/linux=
/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3-selftest-support
+++ a/include/linux/lis3lv02d.h
@@ -55,6 +55,9 @@ struct lis3lv02d_platform_data {
 	s8 axis_z;
 	int (*setup_resources)(void);
 	int (*release_resources)(void);
+	/* Limits for selftest are specified in chip data sheet */
+	s16 st_min_limits[3]; /* min pass limit x, y, z */
+	s16 st_max_limits[3]; /* max pass limit x, y, z */
 };
=20
 #endif /* __LIS3LV02D_H_ */
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
