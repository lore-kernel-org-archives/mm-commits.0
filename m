From: akpm@linux-foundation.org
Subject: + lis3-sysfs-entry-for-setting-chip-measurement-rate.patch added to -mm tree
Date: Wed, 02 Dec 2009 15:03:06 -0800
Message-ID: <200912022303.nB2N36Vb010309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbZLBXLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:11:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, Eric.Piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: sysfs entry for setting chip measurement rate
has been added to the -mm tree.  Its filename is
     lis3-sysfs-entry-for-setting-chip-measurement-rate.patch

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
Subject: lis3: sysfs entry for setting chip measurement rate
=46rom: Samu Onkalo <samu.p.onkalo@nokia.com>

It is possible to read position information at the chip measurement rat=
e
via sysfs.  This patch adds possibility to configure chip measurement
rate.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: =C9ric Piel <Eric.Piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |   51 +++++++++++++++++++++++++++++++-----
 drivers/hwmon/lis3lv02d.h |    2 +
 2 files changed, 46 insertions(+), 7 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-sysfs-entry-for-setting-chip-m=
easurement-rate drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-sysfs-entry-for-setting-chip-measu=
rement-rate
+++ a/drivers/hwmon/lis3lv02d.c
@@ -121,18 +121,35 @@ static void lis3lv02d_get_xyz(struct lis
 static int lis3_12_rates[4] =3D {40, 160, 640, 2560};
 static int lis3_8_rates[2] =3D {100, 400};
=20
+/* ODR is Output Data Rate */
 static int lis3lv02d_get_odr(void)
 {
 	u8 ctrl;
-	int val;
+	int shift;
=20
 	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+	ctrl &=3D lis3_dev.odr_mask;
+	shift =3D ffs(lis3_dev.odr_mask) - 1;
+	return lis3_dev.odrs[(ctrl >> shift)];
+}
=20
-	if (lis3_dev.whoami =3D=3D WAI_12B)
-		val =3D lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
-	else
-		val =3D lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
-	return val;
+static int lis3lv02d_set_odr(int rate)
+{
+	u8 ctrl;
+	int i, len, shift;
+
+	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+	ctrl &=3D ~lis3_dev.odr_mask;
+	len =3D 1 << hweight_long(lis3_dev.odr_mask); /* # of possible values=
 */
+	shift =3D ffs(lis3_dev.odr_mask) - 1;
+
+	for (i =3D 0; i < len; i++)
+		if (lis3_dev.odrs[i] =3D=3D rate) {
+			lis3_dev.write(&lis3_dev, CTRL_REG1,
+					ctrl | (i << shift));
+			return 0;
+		}
+	return -EINVAL;
 }
=20
 static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
@@ -433,9 +450,25 @@ static ssize_t lis3lv02d_rate_show(struc
 	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
 }
=20
+static ssize_t lis3lv02d_rate_set(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	unsigned long rate;
+
+	if (strict_strtoul(buf, 0, &rate))
+		return -EINVAL;
+
+	if (lis3lv02d_set_odr(rate))
+		return -EINVAL;
+
+	return count;
+}
+
 static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
-static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
+static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
+					    lis3lv02d_rate_set);
=20
 static struct attribute *lis3lv02d_attributes[] =3D {
 	&dev_attr_selftest.attr,
@@ -480,12 +513,16 @@ int lis3lv02d_init_device(struct lis3lv0
 		dev->read_data =3D lis3lv02d_read_12;
 		dev->mdps_max_val =3D 2048;
 		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_12B;
+		dev->odrs =3D lis3_12_rates;
+		dev->odr_mask =3D CTRL1_DF0 | CTRL1_DF1;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data =3D lis3lv02d_read_8;
 		dev->mdps_max_val =3D 128;
 		dev->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
+		dev->odrs =3D lis3_8_rates;
+		dev->odr_mask =3D CTRL1_DR;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff -puN drivers/hwmon/lis3lv02d.h~lis3-sysfs-entry-for-setting-chip-m=
easurement-rate drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~lis3-sysfs-entry-for-setting-chip-measu=
rement-rate
+++ a/drivers/hwmon/lis3lv02d.h
@@ -208,6 +208,8 @@ struct lis3lv02d {
 	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
 	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
=20
+	int                     *odrs;     /* Supported output data rates */
+	u8                      odr_mask;  /* ODR bit mask */
 	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
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
lis3-selftest-support.patch
lis3lv02d-remove-calibaration-functionality.patch
lis3-sysfs-entry-for-setting-chip-measurement-rate.patch
lis3-scale-output-values-to-mg.patch
lis3-update-documentation-to-match-latest-changes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
