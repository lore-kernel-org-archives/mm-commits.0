From: akpm@linux-foundation.org
Subject: + arm-imx-use-mc13xxx-constants-instead-of-mc13783.patch added to -mm tree
Date: Thu, 25 Aug 2011 17:15:14 -0700
Message-ID: <201108260015.p7Q0FFOD021988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865Ab1HZAP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 20:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, david@protonic.nl, dmitry.torokhov@gmail.com, guenter.roeck@ericsson.com, khali@linux-fr.org, rpurdie@rpsys.net, s.hauer@pengutronix.de, sameo@linux.intel.com


The patch titled
     ARM: imx: use mc13xxx constants instead of mc13783
has been added to the -mm tree.  Its filename is
     arm-imx-use-mc13xxx-constants-instead-of-mc13783.patch

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
Subject: ARM: imx: use mc13xxx constants instead of mc13783
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

The latter constants are going to be removed in favour of the former

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: David Jander <david@protonic.nl>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-imx/mach-mx27_3ds.c |    4 ++--
 arch/arm/mach-imx/mach-mx31_3ds.c |    2 +-
 arch/arm/mach-imx/mach-pcm038.c   |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/arm/mach-imx/mach-mx27_3ds.c~arm-imx-use-mc13xxx-constan=
ts-instead-of-mc13783 arch/arm/mach-imx/mach-mx27_3ds.c
--- a/arch/arm/mach-imx/mach-mx27_3ds.c~arm-imx-use-mc13xxx-constants-i=
nstead-of-mc13783
+++ a/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -293,8 +293,8 @@ static struct mc13xxx_platform_data mc13
 		.num_regulators =3D ARRAY_SIZE(mx27_3ds_regulators),
=20
 	},
-	.flags  =3D MC13783_USE_REGULATOR | MC13783_USE_TOUCHSCREEN |
-	MC13783_USE_RTC,
+	.flags  =3D MC13XXX_USE_REGULATOR | MC13XXX_USE_TOUCHSCREEN |
+		MC13XXX_USE_RTC,
 };
=20
 /* SPI */
diff -puN arch/arm/mach-imx/mach-mx31_3ds.c~arm-imx-use-mc13xxx-constan=
ts-instead-of-mc13783 arch/arm/mach-imx/mach-mx31_3ds.c
--- a/arch/arm/mach-imx/mach-mx31_3ds.c~arm-imx-use-mc13xxx-constants-i=
nstead-of-mc13783
+++ a/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -494,7 +494,7 @@ static struct mc13xxx_platform_data mc13
 		.regulators =3D mx31_3ds_regulators,
 		.num_regulators =3D ARRAY_SIZE(mx31_3ds_regulators),
 	},
-	.flags  =3D MC13783_USE_REGULATOR | MC13783_USE_TOUCHSCREEN,
+	.flags  =3D MC13XXX_USE_REGULATOR | MC13XXX_USE_TOUCHSCREEN,
 };
=20
 /* SPI */
diff -puN arch/arm/mach-imx/mach-pcm038.c~arm-imx-use-mc13xxx-constants=
-instead-of-mc13783 arch/arm/mach-imx/mach-pcm038.c
--- a/arch/arm/mach-imx/mach-pcm038.c~arm-imx-use-mc13xxx-constants-ins=
tead-of-mc13783
+++ a/arch/arm/mach-imx/mach-pcm038.c
@@ -266,8 +266,8 @@ static struct mc13xxx_platform_data pcm0
 		.regulators =3D pcm038_regulators,
 		.num_regulators =3D ARRAY_SIZE(pcm038_regulators),
 	},
-	.flags =3D MC13783_USE_ADC | MC13783_USE_REGULATOR |
-		 MC13783_USE_TOUCHSCREEN,
+	.flags =3D MC13XXX_USE_ADC | MC13XXX_USE_REGULATOR |
+		 MC13XXX_USE_TOUCHSCREEN,
 };
=20
 static struct spi_board_info pcm038_spi_board_info[] __initdata =3D {
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
