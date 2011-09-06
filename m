From: akpm@linux-foundation.org
Subject: + lis3lv02d-make-regulator-api-usage-unconditional.patch added to -mm tree
Date: Tue, 06 Sep 2011 14:09:11 -0700
Message-ID: <201109062109.p86L9B4O032738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab1IFVJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 17:09:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, ilkka.koskinen@nokia.com


The patch titled
     lis3lv02d: make regulator API usage unconditional
has been added to the -mm tree.  Its filename is
     lis3lv02d-make-regulator-api-usage-unconditional.patch

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
Subject: lis3lv02d: make regulator API usage unconditional
=46rom: Mark Brown <broonie@opensource.wolfsonmicro.com>

The regulator API contains a range of features for stubbing itself out
when not in use and for transparently restricting the actual effect of
regulator API calls where they can't be supported on a particular syste=
m
so that drivers don't need to individually implement this.  Simplify th=
e
driver slightly by making use of this idiom.

The only in tree user is ecovec24 which does not use the regulator API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |   34 ++++++++---------------
 include/linux/lis3lv02d.h              |    1=20
 2 files changed, 12 insertions(+), 23 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_i2c.c~lis3lv02d-make-regulat=
or-api-usage-unconditional drivers/misc/lis3lv02d/lis3lv02d_i2c.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c~lis3lv02d-make-regulator-a=
pi-usage-unconditional
+++ a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -79,8 +79,7 @@ static int lis3_i2c_init(struct lis3lv02
 	u8 reg;
 	int ret;
=20
-	if (lis3->reg_ctrl)
-		lis3_reg_ctrl(lis3, LIS3_REG_ON);
+	lis3_reg_ctrl(lis3, LIS3_REG_ON);
=20
 	lis3->read(lis3, WHO_AM_I, &reg);
 	if (reg !=3D lis3->whoami)
@@ -106,10 +105,6 @@ static int __devinit lis3lv02d_i2c_probe
 	struct lis3lv02d_platform_data *pdata =3D client->dev.platform_data;
=20
 	if (pdata) {
-		/* Regulator control is optional */
-		if (pdata->driver_features & LIS3_USE_REGULATOR_CTRL)
-			lis3_dev.reg_ctrl =3D lis3_reg_ctrl;
-
 		if ((pdata->driver_features & LIS3_USE_BLOCK_READ) &&
 			(i2c_check_functionality(client->adapter,
 						I2C_FUNC_SMBUS_I2C_BLOCK)))
@@ -131,15 +126,13 @@ static int __devinit lis3lv02d_i2c_probe
 			goto fail;
 	}
=20
-	if (lis3_dev.reg_ctrl) {
-		lis3_dev.regulators[0].supply =3D reg_vdd;
-		lis3_dev.regulators[1].supply =3D reg_vdd_io;
-		ret =3D regulator_bulk_get(&client->dev,
-					ARRAY_SIZE(lis3_dev.regulators),
-					lis3_dev.regulators);
-		if (ret < 0)
-			goto fail;
-	}
+	lis3_dev.regulators[0].supply =3D reg_vdd;
+	lis3_dev.regulators[1].supply =3D reg_vdd_io;
+	ret =3D regulator_bulk_get(&client->dev,
+				 ARRAY_SIZE(lis3_dev.regulators),
+				 lis3_dev.regulators);
+	if (ret < 0)
+		goto fail;
=20
 	lis3_dev.pdata	  =3D pdata;
 	lis3_dev.bus_priv =3D client;
@@ -153,13 +146,11 @@ static int __devinit lis3lv02d_i2c_probe
 	i2c_set_clientdata(client, &lis3_dev);
=20
 	/* Provide power over the init call */
-	if (lis3_dev.reg_ctrl)
-		lis3_reg_ctrl(&lis3_dev, LIS3_REG_ON);
+	lis3_reg_ctrl(&lis3_dev, LIS3_REG_ON);
=20
 	ret =3D lis3lv02d_init_device(&lis3_dev);
=20
-	if (lis3_dev.reg_ctrl)
-		lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
+	lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
=20
 	if (ret)
 		goto fail2;
@@ -185,9 +176,8 @@ static int __devexit lis3lv02d_i2c_remov
 	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_remove_fs(&lis3_dev);
=20
-	if (lis3_dev.reg_ctrl)
-		regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
-				lis3_dev.regulators);
+	regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
+			    lis3_dev.regulators);
 	return 0;
 }
=20
diff -puN include/linux/lis3lv02d.h~lis3lv02d-make-regulator-api-usage-=
unconditional include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3lv02d-make-regulator-api-usage-unco=
nditional
+++ a/include/linux/lis3lv02d.h
@@ -113,7 +113,6 @@ struct lis3lv02d_platform_data {
 	s8 axis_x;
 	s8 axis_y;
 	s8 axis_z;
-#define LIS3_USE_REGULATOR_CTRL 0x01
 #define LIS3_USE_BLOCK_READ	0x02
 	u16 driver_features;
 	int default_rate;
_

Patches currently in -mm which might be from broonie@opensource.wolfson=
micro.com are

alpha-gpio-generic_gpio-default-must-be-n.patch
linux-next.patch
lis3lv02d-make-regulator-api-usage-unconditional.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
