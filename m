From: akpm@linux-foundation.org
Subject: + lis3lv02d-proper-power-on-sequence.patch added to -mm tree
Date: Mon, 16 Nov 2009 12:04:18 -0800
Message-ID: <200911162004.nAGK4Iur027937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbZKPUEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 15:04:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3lv02d: proper power on sequence
has been added to the -mm tree.  Its filename is
     lis3lv02d-proper-power-on-sequence.patch

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
Subject: lis3lv02d: proper power on sequence
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

Lis3 accelerometer sensors have quite long power on delay (up to 125
ms). This patch adds necessary delay to power on sequence for currently
supported lis3 chips.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Tested-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Acked-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   41 +++++++++++++++++++++++-------------
 drivers/hwmon/lis3lv02d.h |    1=20
 2 files changed, 28 insertions(+), 14 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3lv02d-proper-power-on-sequence =
drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3lv02d-proper-power-on-sequence
+++ a/drivers/hwmon/lis3lv02d.c
@@ -50,6 +50,9 @@
  * joystick.
  */
=20
+#define LIS3_PWRON_DELAY_WAI_12B	(5000)
+#define LIS3_PWRON_DELAY_WAI_8B		(3000)
+
 struct lis3lv02d lis3_dev =3D {
 	.misc_wait   =3D __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
 };
@@ -112,6 +115,24 @@ static void lis3lv02d_get_xyz(struct lis
 	*z =3D lis3lv02d_get_axis(lis3->ac.z, position);
 }
=20
+/* conversion btw sampling rate and the register values */
+static int lis3_12_rates[4] =3D {40, 160, 640, 2560};
+static int lis3_8_rates[2] =3D {100, 400};
+
+static int lis3lv02d_get_odr(void)
+{
+	u8 ctrl;
+	int val;
+
+	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+
+	if (lis3_dev.whoami =3D=3D WAI_12B)
+		val =3D lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
+	else
+		val =3D lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
+	return val;
+}
+
 void lis3lv02d_poweroff(struct lis3lv02d *lis3)
 {
 	/* disable X,Y,Z axis and power down */
@@ -125,6 +146,9 @@ void lis3lv02d_poweron(struct lis3lv02d=20
=20
 	lis3->init(lis3);
=20
+	/* LIS3 power on delay is quite long */
+	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+
 	/*
 	 * Common configuration
 	 * BDU: (12 bits sensors only) LSB and MSB values are not updated unt=
il
@@ -364,23 +388,10 @@ static ssize_t lis3lv02d_calibrate_store
 	return count;
 }
=20
-/* conversion btw sampling rate and the register values */
-static int lis3_12_rates[4] =3D {40, 160, 640, 2560};
-static int lis3_8_rates[2] =3D {100, 400};
 static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	u8 ctrl;
-	int val;
-
-	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-
-	if (lis3_dev.whoami =3D=3D WAI_12B)
-		val =3D lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
-	else
-		val =3D lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
-
-	return sprintf(buf, "%d\n", val);
+	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
 }
=20
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
@@ -430,11 +441,13 @@ int lis3lv02d_init_device(struct lis3lv0
 		printk(KERN_INFO DRIVER_NAME ": 12 bits sensor found\n");
 		dev->read_data =3D lis3lv02d_read_12;
 		dev->mdps_max_val =3D 2048;
+		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_12B;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data =3D lis3lv02d_read_8;
 		dev->mdps_max_val =3D 128;
+		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff -puN drivers/hwmon/lis3lv02d.h~lis3lv02d-proper-power-on-sequence =
drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3lv02d-proper-power-on-sequence
+++ a/drivers/hwmon/lis3lv02d.h
@@ -202,6 +202,7 @@ struct lis3lv02d {
 	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
+	int			pwron_delay;
=20
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com ar=
e

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
