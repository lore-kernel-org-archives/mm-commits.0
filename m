From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-remove-calibaration-functionality.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:59:33 -0800
Message-ID: <200912152159.nBFLxXZO015912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761365AbZLOWOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3lv02d: remove calibaration functionality
has been removed from the -mm tree.  Its filename was
     lis3lv02d-remove-calibaration-functionality.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lis3lv02d: remove calibaration functionality
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Chip is calibrated by the manufacturer.  There is no need to calibarate=
 it
at driver level.  If the chip is used as a joystick, calibaration can b=
e
done using joystick device calibration mechanism.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: =C9ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   32 +++-----------------------------
 drivers/hwmon/lis3lv02d.h |    3 ---
 2 files changed, 3 insertions(+), 32 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3lv02d-remove-calibaration-funct=
ionality drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3lv02d-remove-calibaration-functiona=
lity
+++ a/drivers/hwmon/lis3lv02d.c
@@ -350,19 +350,12 @@ static void lis3lv02d_joystick_poll(stru
 	int x, y, z;
=20
 	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-	input_report_abs(pidev->input, ABS_X, x - lis3_dev.xcalib);
-	input_report_abs(pidev->input, ABS_Y, y - lis3_dev.ycalib);
-	input_report_abs(pidev->input, ABS_Z, z - lis3_dev.zcalib);
+	input_report_abs(pidev->input, ABS_X, x);
+	input_report_abs(pidev->input, ABS_Y, y);
+	input_report_abs(pidev->input, ABS_Z, z);
 	input_sync(pidev->input);
 }
=20
-
-static inline void lis3lv02d_calibrate_joystick(void)
-{
-	lis3lv02d_get_xyz(&lis3_dev,
-		&lis3_dev.xcalib, &lis3_dev.ycalib, &lis3_dev.zcalib);
-}
-
 int lis3lv02d_joystick_enable(void)
 {
 	struct input_dev *input_dev;
@@ -379,8 +372,6 @@ int lis3lv02d_joystick_enable(void)
 	lis3_dev.idev->poll_interval =3D MDPS_POLL_INTERVAL;
 	input_dev =3D lis3_dev.idev->input;
=20
-	lis3lv02d_calibrate_joystick();
-
 	input_dev->name       =3D "ST LIS3LV02DL Accelerometer";
 	input_dev->phys       =3D DRIVER_NAME "/input0";
 	input_dev->id.bustype =3D BUS_HOST;
@@ -436,20 +427,6 @@ static ssize_t lis3lv02d_position_show(s
 	return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
 }
=20
-static ssize_t lis3lv02d_calibrate_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "(%d,%d,%d)\n", lis3_dev.xcalib, lis3_dev.ycalib,=
 lis3_dev.zcalib);
-}
-
-static ssize_t lis3lv02d_calibrate_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	lis3lv02d_calibrate_joystick();
-	return count;
-}
-
 static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -458,14 +435,11 @@ static ssize_t lis3lv02d_rate_show(struc
=20
 static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
-static DEVICE_ATTR(calibrate, S_IRUGO|S_IWUSR, lis3lv02d_calibrate_sho=
w,
-	lis3lv02d_calibrate_store);
 static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
=20
 static struct attribute *lis3lv02d_attributes[] =3D {
 	&dev_attr_selftest.attr,
 	&dev_attr_position.attr,
-	&dev_attr_calibrate.attr,
 	&dev_attr_rate.attr,
 	NULL
 };
diff -puN drivers/hwmon/lis3lv02d.h~lis3lv02d-remove-calibaration-funct=
ionality drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3lv02d-remove-calibaration-functiona=
lity
+++ a/drivers/hwmon/lis3lv02d.h
@@ -216,9 +216,6 @@ struct lis3lv02d {
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
-	int			xcalib;    /* calibrated null value for x */
-	int			ycalib;    /* calibrated null value for y */
-	int			zcalib;    /* calibrated null value for z */
 	struct axis_conversion	ac;        /* hw -> logical axis */
=20
 	u32			irq;       /* IRQ number */
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
