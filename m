From: akpm@linux-foundation.org
Subject: [merged] dt-bindings-use-isil-prefix-for-intersil.patch removed
 from -mm tree
Date: Tue, 20 Jan 2015 13:31:59 -0800
Message-ID: <54bec94f.dReDLrOC6xl5+l3t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbbATVcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 16:32:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, darshanapadmadas@gmail.com, galak@codeaurora.org, gnurou@gmail.com, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@arm.linux.org.uk, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob@landley.net, robh+dt@kernel.org, swarren@wwwdotorg.org, thierry.reding@gmail.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dt-bindings: use isil prefix for Intersil
has been removed from the -mm tree.  Its filename was
     dt-bindings-use-isil-prefix-for-intersil.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: dt-bindings: use isil prefix for Intersil

When Intersil ISL12057 driver was introduced by commit 70e123373c05 ("r=
tc:
Add support for Intersil ISL12057 I2C RTC chip"), the vendor prefix 'is=
l'
was used instead of the expected 'isil' (Intersil NASDAQ symbol) and
documented in vendor-prefixes.txt.

Recently, a patch from Philip Zabel (7a6540ca856a, "ARM: mvebu: Change
vendor prefix for Intersil Corporation to isil") fixed that prefix in
ReadyNAS devices .dts files (AFAICT, the only users of the driver).

Then, commits 7c75c1d5e72b ("dt-bindings: Document deprecated device
vendor name to fix related warning") and b2ea3f82e798 (dt-bindings:
Document correct and deprecated vendor-prefix with device isl29028)
decided to go the other way and deprecate isil in vendor-prefixes.txt a=
nd
in isl29028.c staging driver.

While trying and merge a fix I wrote for ISL12057 drivers to finish
Philip's work, it conflicted with the two recently introduced commits, =
and
revealed the issue: at the moment, there are various compatible strings=
 in
drivers and .dts files for Intersil products which use either isl or is=
il:

$ grep -R "isil," .
=2E/Documentation/devicetree/bindings/i2c/trivial-devices.txt:isil,isl2=
9028           (deprecated, use isl)
=2E/drivers/staging/iio/light/isl29028.c:   { .compatible =3D "isil,isl=
29028", },/* deprecated, don't use */
=2E/drivers/staging/iio/light/isl29018.c:   { .compatible =3D "isil,isl=
29018", },
=2E/drivers/staging/iio/light/isl29018.c:   { .compatible =3D "isil,isl=
29023", },
=2E/drivers/staging/iio/light/isl29018.c:   { .compatible =3D "isil,isl=
29035", },
=2E/arch/powerpc/boot/dts/p1022rdk.dts:        compatible =3D "isil,zl6=
100";
=2E/arch/powerpc/boot/dts/p1022rdk.dts:        compatible =3D "isil,zl6=
100";
=2E/arch/powerpc/boot/dts/p1022rdk.dts:        compatible =3D "isil,zl6=
100";
=2E/arch/powerpc/boot/dts/p1022rdk.dts:        compatible =3D "isil,zl6=
100";
=2E/arch/arm/boot/dts/exynos5800-peach-pi.dts: compatible =3D "isil,isl=
29018";
=2E/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi: compatible =3D "isil,isl=
1208";
=2E/arch/arm/boot/dts/tegra20-ventana.dts:     compatible =3D "isil,isl=
29018";
=2E/arch/arm/boot/dts/tegra20-seaboard.dts:    compatible =3D "isil,isl=
29018";
=2E/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts: compatible =3D "isi=
l,isl12057";
=2E/arch/arm/boot/dts/armada-370-netgear-rn104.dts: compatible =3D "isi=
l,isl12057";
=2E/arch/arm/boot/dts/exynos5420-peach-pit.dts:     compatible =3D "isi=
l,isl29018";
=2E/arch/arm/boot/dts/armada-370-netgear-rn102.dts: compatible =3D "isi=
l,isl12057";

$ grep -R "isl," .
=2E/Documentation/devicetree/bindings/regulator/isl9305.txt:- compatibl=
e: "isl,isl9305" or "isl,isl9305h"
=2E/Documentation/devicetree/bindings/regulator/isl9305.txt:           =
   compatible =3D "isl,isl9305";
=2E/Documentation/devicetree/bindings/i2c/trivial-devices.txt:isl,isl12=
057      Intersil ISL12057 I2C RTC Chip
=2E/Documentation/devicetree/bindings/i2c/trivial-devices.txt:isl,isl29=
028      Intersil ISL29028 Ambient Light ....
=2E/drivers/regulator/isl9305.c:          { .compatible =3D "isl,isl930=
5" },
=2E/drivers/regulator/isl9305.c:          { .compatible =3D "isl,isl930=
5h" },
=2E/drivers/staging/iio/light/isl29028.c: { .compatible =3D "isl,isl290=
28", },
=2E/drivers/rtc/rtc-isl12057.c:           { .compatible =3D "isl,isl120=
57" },
=2E/drivers/rtc/rtc-isl12022.c:           { .compatible =3D "isl,isl120=
22" },
=2E/arch/arm/boot/dts/tegra30-cardhu.dtsi:   compatible =3D "isl,isl290=
28";
=2E/arch/arm/boot/dts/zynq-parallella.dts:   compatible =3D "isl,isl930=
5";

AFAICT, it seems it makes sense to *definitively* settle for isil as th=
e
vendor prefix for Intersil, as Philip did in 7a6540ca856a: it's the NAS=
DAQ
symbol and this choice requires less changes than opting for isl.

So, this series changes compatible strings in .dts files to use isil wh=
ere
isl was found before, and modify drivers w/ compatible strings using is=
l
to add one using isil.  In those cases, a comment is made that the old
compatible string is kept for backward compatibility (w/ out-fo-tree us=
ers
of those drivers).  Additionally, it leaves only isil as prefix in
vendor-prefixes.txt.  Those changes should prevent any new inclusion of
isl compatible strings for Intersil devices due to copy-and-paste.



This patch (of 7):

=46ix DT documentation to reference isil (NASDAQ symbol and the most us=
ed
prefix inside the kernel) for all Intersil products.

It reverts b2ea3f82e798 ("dt-bindings: Document correct and deprecated
vendor-prefix with device isl29028").

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

 Documentation/devicetree/bindings/i2c/trivial-devices.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/devicetree/bindings/i2c/trivial-devices.txt~dt-=
bindings-use-isil-prefix-for-intersil Documentation/devicetree/bindings=
/i2c/trivial-devices.txt
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt~dt-bind=
ings-use-isil-prefix-for-intersil
+++ a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -59,9 +59,8 @@ fsl,sgtl5000		SGTL5000: Ultra Low-Power
 gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with T=
wo-Wire Interface
 infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max=
 100khz)
 infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
-isl,isl12057		Intersil ISL12057 I2C RTC Chip
-isil,isl29028           (deprecated, use isl)
-isl,isl29028            Intersil ISL29028 Ambient Light and Proximity =
Sensor
+isil,isl12057		Intersil ISL12057 I2C RTC Chip
+isil,isl29028           Intersil ISL29028 Ambient Light and Proximity =
Sensor
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
 maxim,max6625		9-Bit/12-Bit Temperature Sensors with I=C2=B2C-Compatib=
le Serial Interface
_

Patches currently in -mm which might be from arno@natisbad.org are

rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patc=
h
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver-upda=
te.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-u=
sers.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patc=
h
of-add-vendor-prefix-for-abracon-corporation.patch
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patc=
h
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip-v2.p=
atch
rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
linux-next.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil=
=2Epatch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix=
=2Epatch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
