From: akpm@linux-foundation.org
Subject: +
 rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch added to -mm tree
Date: Wed, 17 Dec 2014 14:18:34 -0800
Message-ID: <5492013a.le1/DBkMmmAwbwR4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaLQWSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 17:18:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, darshanapadmadas@gmail.com, galak@codeaurora.org, gnurou@gmail.com, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob@landley.net, robh+dt@kernel.org, swarren@wwwdotorg.org, thierry.reding@gmail.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: isl12057: deprecate use of isl in compatible string =
for isil
has been added to the -mm tree.  Its filename is
     rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.pa=
tch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-isl12057-deprecate-use=
-of-isl-in-compatible-string-for-isil.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-isl12057-deprecate-use=
-of-isl-in-compatible-string-for-isil.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: rtc: isl12057: deprecate use of isl in compatible string for i=
sil

"isil" and "isl" prefixes are used at various locations inside the kern=
el
to reference Intersil corporation.  This patch is part of a series fixi=
ng
those locations were "isl" is used in compatible strings to use the now
expected "isil" prefix instead (NASDAQ symbol for Intersil and most use=
d
version).  The old compatible string is kept for backward compatibility=
=2E

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Uwe Kleine-Knig <uwe@kleine-koenig.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Darshana Padmadas <darshanapadmadas@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Landley <rob@landley.net>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12057.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-isl12057.c~rtc-isl12057-deprecate-use-of-isl-=
in-compatible-string-for-isil drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-isl12057-deprecate-use-of-isl-in-c=
ompatible-string-for-isil
+++ a/drivers/rtc/rtc-isl12057.c
@@ -644,7 +644,8 @@ static SIMPLE_DEV_PM_OPS(isl12057_rtc_pm
=20
 #ifdef CONFIG_OF
 static const struct of_device_id isl12057_dt_match[] =3D {
-	{ .compatible =3D "isl,isl12057" },
+	{ .compatible =3D "isl,isl12057" }, /* for backward compat., don't us=
e */
+	{ .compatible =3D "isil,isl12057" },
 	{ },
 };
 #endif
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patc=
h
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver-upda=
te.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-u=
sers.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patc=
h
dt-bindings-use-isil-prefix-for-intersil.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil=
=2Epatch
regulator-isl9305-deprecate-use-of-isl-in-compatible-string-for-isil.pa=
tch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix=
=2Epatch
arm-dts-tegra-update-isl29028-compatible-string-to-use-isil-vendor-pref=
ix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
