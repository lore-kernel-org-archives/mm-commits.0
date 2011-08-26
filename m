From: akpm@linux-foundation.org
Subject: + led-mc13783-convert-to-mc13xxx-mfd.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:15:06 -0700
Message-ID: <201108260015.p7Q0F6dS021979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab1HZAPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@protonic.nl, dmitry.torokhov@gmail.com, guenter.roeck@ericsson.com, khali@linux-fr.org, rpurdie@rpsys.net, s.hauer@pengutronix.de, sameo@linux.intel.com, u.kleine-koenig@pengutronix.de


The patch titled
     led/mc13783: convert to mc13xxx MFD
has been added to the -mm tree.  Its filename is
     led-mc13783-convert-to-mc13xxx-mfd.patch

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
Subject: led/mc13783: convert to mc13xxx MFD
=46rom: David Jander <david@protonic.nl>

mc13xxx is the more general API and most of the mc13783_...  functions =
are
going to die.

Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-mc13783.c |   52 +++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/leds/leds-mc13783.c~led-mc13783-convert-to-mc13xxx-mf=
d drivers/leds/leds-mc13783.c
--- a/drivers/leds/leds-mc13783.c~led-mc13783-convert-to-mc13xxx-mfd
+++ a/drivers/leds/leds-mc13783.c
@@ -21,13 +21,13 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
-#include <linux/mfd/mc13783.h>
+#include <linux/mfd/mc13xxx.h>
 #include <linux/slab.h>
=20
 struct mc13783_led {
 	struct led_classdev	cdev;
 	struct work_struct	work;
-	struct mc13783		*master;
+	struct mc13xxx		*master;
 	enum led_brightness	new_brightness;
 	int			id;
 };
@@ -111,11 +111,11 @@ static void mc13783_led_work(struct work
 		break;
 	}
=20
-	mc13783_lock(led->master);
+	mc13xxx_lock(led->master);
=20
-	mc13783_reg_rmw(led->master, reg, mask, value);
+	mc13xxx_reg_rmw(led->master, reg, mask, value);
=20
-	mc13783_unlock(led->master);
+	mc13xxx_unlock(led->master);
 }
=20
 static void mc13783_led_set(struct led_classdev *led_cdev,
@@ -172,23 +172,23 @@ static int __devinit mc13783_led_setup(s
 		break;
 	}
=20
-	mc13783_lock(led->master);
+	mc13xxx_lock(led->master);
=20
-	ret =3D mc13783_reg_rmw(led->master, reg, mask << shift,
+	ret =3D mc13xxx_reg_rmw(led->master, reg, mask << shift,
 						value << shift);
=20
-	mc13783_unlock(led->master);
+	mc13xxx_unlock(led->master);
 	return ret;
 }
=20
 static int __devinit mc13783_leds_prepare(struct platform_device *pdev=
)
 {
 	struct mc13783_leds_platform_data *pdata =3D dev_get_platdata(&pdev->=
dev);
-	struct mc13783 *dev =3D dev_get_drvdata(pdev->dev.parent);
+	struct mc13xxx *dev =3D dev_get_drvdata(pdev->dev.parent);
 	int ret =3D 0;
 	int reg =3D 0;
=20
-	mc13783_lock(dev);
+	mc13xxx_lock(dev);
=20
 	if (pdata->flags & MC13783_LED_TC1HALF)
 		reg |=3D MC13783_LED_C1_TC1HALF_BIT;
@@ -196,7 +196,7 @@ static int __devinit mc13783_leds_prepar
 	if (pdata->flags & MC13783_LED_SLEWLIMTC)
 		reg |=3D MC13783_LED_Cx_SLEWLIM_BIT;
=20
-	ret =3D mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_1, reg);
+	ret =3D mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_1, reg);
 	if (ret)
 		goto out;
=20
@@ -206,7 +206,7 @@ static int __devinit mc13783_leds_prepar
 	if (pdata->flags & MC13783_LED_SLEWLIMBL)
 		reg |=3D MC13783_LED_Cx_SLEWLIM_BIT;
=20
-	ret =3D mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_2, reg);
+	ret =3D mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_2, reg);
 	if (ret)
 		goto out;
=20
@@ -216,7 +216,7 @@ static int __devinit mc13783_leds_prepar
 	if (pdata->flags & MC13783_LED_TRIODE_TC1)
 		reg |=3D MC13783_LED_Cx_TRIODE_TC_BIT;
=20
-	ret =3D mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_3, reg);
+	ret =3D mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_3, reg);
 	if (ret)
 		goto out;
=20
@@ -226,7 +226,7 @@ static int __devinit mc13783_leds_prepar
 	if (pdata->flags & MC13783_LED_TRIODE_TC2)
 		reg |=3D MC13783_LED_Cx_TRIODE_TC_BIT;
=20
-	ret =3D mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_4, reg);
+	ret =3D mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_4, reg);
 	if (ret)
 		goto out;
=20
@@ -236,7 +236,7 @@ static int __devinit mc13783_leds_prepar
 	if (pdata->flags & MC13783_LED_TRIODE_TC3)
 		reg |=3D MC13783_LED_Cx_TRIODE_TC_BIT;
=20
-	ret =3D mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_5, reg);
+	ret =3D mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_5, reg);
 	if (ret)
 		goto out;
=20
@@ -255,10 +255,10 @@ static int __devinit mc13783_leds_prepar
 	reg |=3D (pdata->abref & MC13783_LED_C0_ABREF_MASK) <<
 							MC13783_LED_C0_ABREF;
=20
-	ret =3D mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_0, reg);
+	ret =3D mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_0, reg);
=20
 out:
-	mc13783_unlock(dev);
+	mc13xxx_unlock(dev);
 	return ret;
 }
=20
@@ -353,7 +353,7 @@ static int __devexit mc13783_led_remove(
 {
 	struct mc13783_leds_platform_data *pdata =3D dev_get_platdata(&pdev->=
dev);
 	struct mc13783_led *led =3D platform_get_drvdata(pdev);
-	struct mc13783 *dev =3D dev_get_drvdata(pdev->dev.parent);
+	struct mc13xxx *dev =3D dev_get_drvdata(pdev->dev.parent);
 	int i;
=20
 	for (i =3D 0; i < pdata->num_leds; i++) {
@@ -361,16 +361,16 @@ static int __devexit mc13783_led_remove(
 		cancel_work_sync(&led[i].work);
 	}
=20
-	mc13783_lock(dev);
+	mc13xxx_lock(dev);
=20
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_0, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_1, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_2, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_3, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_4, 0);
-	mc13783_reg_write(dev, MC13783_REG_LED_CONTROL_5, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_0, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_1, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_2, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_3, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_4, 0);
+	mc13xxx_reg_write(dev, MC13783_REG_LED_CONTROL_5, 0);
=20
-	mc13783_unlock(dev);
+	mc13xxx_unlock(dev);
=20
 	kfree(led);
 	return 0;
_

Patches currently in -mm which might be from david@protonic.nl are

led-mc13783-convert-to-mc13xxx-mfd.patch
mfd-mc13xxx-provide-a-generic-version-of-adc_do_conversion.patch
input-mc13783-ts-convert-to-mc13xxx-api.patch
arm-imx-use-mc13xxx-constants-instead-of-mc13783.patch
hwmon-mc13783-adc-convert-to-mc13xxx-api.patch
mfd-mc13xxx-remove-mc13783-api-functions-and-symbols.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
