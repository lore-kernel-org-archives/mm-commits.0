From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-lis3lv02d-fix-some-comments-specific-to-lis331dlh-driver.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:36 -0700
Message-ID: <20121001192836.BD0321E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57603 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2JAT2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:37 -0400
Received: by yenr11 with SMTP id r11so688532yen.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anilkumar@ti.com, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lis3lv02d: fix some comments specific to lis=
331dlh driver
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-fix-some-comments-specific-to-lis331dlh-dri=
ver.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: AnilKumar Ch <anilkumar@ti.com>
Subject: drivers/misc/lis3lv02d: fix some comments specific to lis331dl=
h driver

=46ix some minor problems in comments of lis331dlh driver

  * correct comments with respect to 2G sensitivity
  * correct typo lis3331dlh mistake to lis331dlh
  * add comment to say only 2G range is supported
  * change the function name from lis3lv02d_read_16 to
    lis331dlh_read_data.
  * update i2c_device_id table entry to maintaine consistancy
  * update sensor display message

This patch is created based on Eric Piel's review comments on "lis3lv02=
d:
Add STMicroelectronics lis331dlh digital accelerometer" v2 patch.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c     |   13 +++++++------
 drivers/misc/lis3lv02d/lis3lv02d.h     |    2 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~drivers-misc-lis3lv02d-fix=
-some-comments-specific-to-lis331dlh-driver drivers/misc/lis3lv02d/lis3=
lv02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~drivers-misc-lis3lv02d-fix-som=
e-comments-specific-to-lis331dlh-driver
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -82,9 +82,10 @@
 #define LIS3_SENSITIVITY_8B		(18 * LIS3_ACCURACY)
=20
 /*
- * LIS3331DLH spec says 1LSBs corresponds 4G/1024 -> 1LSB is 1000/1024=
 mG.
- * Sensitivity values for +/-2G, outdata in 12 bits for +/-2G scale. s=
o 4
- * bits adjustment is required
+ * LIS331DLH spec says 1LSBs corresponds 4G/4096 -> 1LSB is 1000/1024 =
mG.
+ * Below macros defines sensitivity values for +/-2G. Dataout bits for
+ * +/-2G range is 12 bits so 4 bits adjustment must be done to get 12b=
it
+ * data from 16bit value. Currently this driver supports only 2G range=
=2E
  */
 #define LIS3DLH_SENSITIVITY_2G		((LIS3_ACCURACY * 1000) / 1024)
 #define SHIFT_ADJ_2G			4
@@ -145,7 +146,7 @@ static s16 lis3lv02d_read_12(struct lis3
 }
=20
 /* 12bits for 2G range, 13 bits for 4G range and 14 bits for 8G range =
*/
-static s16 lis3lv02d_read_16(struct lis3lv02d *lis3, int reg)
+static s16 lis331dlh_read_data(struct lis3lv02d *lis3, int reg)
 {
 	u8 lo, hi;
 	int v;
@@ -1136,8 +1137,8 @@ int lis3lv02d_init_device(struct lis3lv0
 		lis3->scale =3D LIS3_SENSITIVITY_8B;
 		break;
 	case WAI_3DLH:
-		pr_info("16 bits 3DLH sensor found\n");
-		lis3->read_data =3D lis3lv02d_read_16;
+		pr_info("16 bits lis331dlh sensor found\n");
+		lis3->read_data =3D lis331dlh_read_data;
 		lis3->mdps_max_val =3D 2048; /* 12 bits for 2G */
 		lis3->shift_adj =3D SHIFT_ADJ_2G;
 		lis3->pwron_delay =3D LIS3_PWRON_DELAY_WAI_8B;
diff -puN drivers/misc/lis3lv02d/lis3lv02d.h~drivers-misc-lis3lv02d-fix=
-some-comments-specific-to-lis331dlh-driver drivers/misc/lis3lv02d/lis3=
lv02d.h
--- a/drivers/misc/lis3lv02d/lis3lv02d.h~drivers-misc-lis3lv02d-fix-som=
e-comments-specific-to-lis331dlh-driver
+++ a/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -104,9 +104,9 @@ enum lis3_who_am_i {
 };
=20
 enum lis3_type {
+	LIS3LV02D,
 	LIS3DC,
 	HP3DC,
-	LIS3LV02D,
 	LIS2302D,
 	LIS331DLF,
 	LIS331DLH,
diff -puN drivers/misc/lis3lv02d/lis3lv02d_i2c.c~drivers-misc-lis3lv02d=
-fix-some-comments-specific-to-lis331dlh-driver drivers/misc/lis3lv02d/=
lis3lv02d_i2c.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c~drivers-misc-lis3lv02d-fix=
-some-comments-specific-to-lis331dlh-driver
+++ a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -257,7 +257,7 @@ static int lis3_i2c_runtime_resume(struc
 #endif /* CONFIG_PM_RUNTIME */
=20
 static const struct i2c_device_id lis3lv02d_id[] =3D {
-	{"lis3lv02d", 0 },
+	{"lis3lv02d", LIS3LV02D},
 	{"lis331dlh", LIS331DLH},
 	{}
 };
_

Patches currently in -mm which might be from anilkumar@ti.com are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
