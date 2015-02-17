From: akpm@linux-foundation.org
Subject: [merged]
 rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
 removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:06 -0800
Message-ID: <54e39ef2.COWZ9bvABO5eQh/B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbbBQUFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, darshanapadmadas@gmail.com, galak@codeaurora.org, gnurou@gmail.com, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob@landley.net, robh+dt@kernel.org, swarren@wwwdotorg.org, thierry.reding@gmail.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: isl12022: deprecate use of isl in compatible string =
for isil
has been removed from the -mm tree.  Its filename was
     rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: rtc: isl12022: deprecate use of isl in compatible string for i=
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

 drivers/rtc/rtc-isl12022.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-isl12022.c~rtc-isl12022-deprecate-use-of-isl-=
in-compatible-string-for-isil drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~rtc-isl12022-deprecate-use-of-isl-in-c=
ompatible-string-for-isil
+++ a/drivers/rtc/rtc-isl12022.c
@@ -275,7 +275,8 @@ static int isl12022_probe(struct i2c_cli
=20
 #ifdef CONFIG_OF
 static const struct of_device_id isl12022_dt_match[] =3D {
-	{ .compatible =3D "isl,isl12022" },
+	{ .compatible =3D "isl,isl12022" }, /* for backward compat., don't us=
e */
+	{ .compatible =3D "isil,isl12022" },
 	{ },
 };
 #endif
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
