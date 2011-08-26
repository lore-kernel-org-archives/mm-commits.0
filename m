From: akpm@linux-foundation.org
Subject: + hwmon-mc13783-adc-convert-to-mc13xxx-api.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:15:16 -0700
Message-ID: <201108260015.p7Q0FGhP021991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab1HZAP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, david@protonic.nl, dmitry.torokhov@gmail.com, guenter.roeck@ericsson.com, khali@linux-fr.org, rpurdie@rpsys.net, s.hauer@pengutronix.de, sameo@linux.intel.com


The patch titled
     hwmon/mc13783-adc: convert to mc13xxx API
has been added to the -mm tree.  Its filename is
     hwmon-mc13783-adc-convert-to-mc13xxx-api.patch

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
Subject: hwmon/mc13783-adc: convert to mc13xxx API
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

The mc13783_...  functions are going to be removed, so switch to the mo=
re
generic API.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Jander <david@protonic.nl>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/mc13783-adc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/hwmon/mc13783-adc.c~hwmon-mc13783-adc-convert-to-mc13=
xxx-api drivers/hwmon/mc13783-adc.c
--- a/drivers/hwmon/mc13783-adc.c~hwmon-mc13783-adc-convert-to-mc13xxx-=
api
+++ a/drivers/hwmon/mc13783-adc.c
@@ -31,7 +31,7 @@
 #define MC13783_ADC_NAME	"mc13783-adc"
=20
 struct mc13783_adc_priv {
-	struct mc13783 *mc13783;
+	struct mc13xxx *mc13xxx;
 	struct device *hwmon_dev;
 };
=20
@@ -51,8 +51,8 @@ static int mc13783_adc_read(struct devic
 	unsigned int sample[4];
 	int ret;
=20
-	ret =3D mc13783_adc_do_conversion(priv->mc13783,
-			MC13783_ADC_MODE_MULT_CHAN,
+	ret =3D mc13xxx_adc_do_conversion(priv->mc13xxx,
+			MC13XXX_ADC_MODE_MULT_CHAN,
 			channel, sample);
 	if (ret)
 		return ret;
@@ -147,9 +147,9 @@ static const struct attribute_group mc13
 static int mc13783_adc_use_touchscreen(struct platform_device *pdev)
 {
 	struct mc13783_adc_priv *priv =3D platform_get_drvdata(pdev);
-	unsigned flags =3D mc13783_get_flags(priv->mc13783);
+	unsigned flags =3D mc13xxx_get_flags(priv->mc13xxx);
=20
-	return flags & MC13783_USE_TOUCHSCREEN;
+	return flags & MC13XXX_USE_TOUCHSCREEN;
 }
=20
 static int __init mc13783_adc_probe(struct platform_device *pdev)
@@ -161,7 +161,7 @@ static int __init mc13783_adc_probe(stru
 	if (!priv)
 		return -ENOMEM;
=20
-	priv->mc13783 =3D dev_get_drvdata(pdev->dev.parent);
+	priv->mc13xxx =3D dev_get_drvdata(pdev->dev.parent);
=20
 	platform_set_drvdata(pdev, priv);
=20
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
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
