From: akpm@linux-foundation.org
Subject: [merged]
 arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:05:15 -0800
Message-ID: <54e39efb.dO80FrNI1voG7O0M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbbBQUFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:05:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, darshanapadmadas@gmail.com, galak@codeaurora.org, gnurou@gmail.com, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob@landley.net, robh+dt@kernel.org, swarren@wwwdotorg.org, thierry.reding@gmail.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: dts: zynq: update isl9305 compatible string to use i=
sil vendor prefix
has been removed from the -mm tree.  Its filename was
     arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-p=
refix.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: arm: dts: zynq: update isl9305 compatible string to use isil v=
endor prefix

"isil" and "isl" prefixes are used at various locations inside the kern=
el
to reference Intersil corporation.  This patch is part of a series fixi=
ng
those locations were "isl" is used in compatible strings to use the now
expected "isil" prefix instead (NASDAQ symbol for Intersil and most use=
d
version).

Note: isl9305 is an I2C device so the patch does not in fact currently
depend on the introduction of "isil"-based compatible string in isl9305
driver (provided by another patch) because I2C core does not check the
prefix yet.

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

 arch/arm/boot/dts/zynq-parallella.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/boot/dts/zynq-parallella.dts~arm-dts-zynq-update-isl=
9305-compatible-string-to-use-isil-vendor-prefix arch/arm/boot/dts/zynq=
-parallella.dts
--- a/arch/arm/boot/dts/zynq-parallella.dts~arm-dts-zynq-update-isl9305=
-compatible-string-to-use-isil-vendor-prefix
+++ a/arch/arm/boot/dts/zynq-parallella.dts
@@ -58,7 +58,7 @@
 	status =3D "okay";
=20
 	isl9305: isl9305@68 {
-		compatible =3D "isl,isl9305";
+		compatible =3D "isil,isl9305";
 		reg =3D <0x68>;
=20
 		regulators {
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
