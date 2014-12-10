From: akpm@linux-foundation.org
Subject: [wrecked]
 rtc-rtc-isl12057-fix-isil-vs-isl-naming-for-intersil.patch removed from -mm tree
Date: Wed, 10 Dec 2014 13:30:59 -0800
Message-ID: <5488bb93.H0zZRm14NyN6CvsA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaLJVbA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 16:31:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, broonie@kernel.org, grant.likely@linaro.org, linus.walleij@linaro.org, mark.rutland@arm.com, peter.huewe@infineon.com, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: fix isil vs isl naming for in=
tersil
has been removed from the -mm tree.  Its filename was
     rtc-rtc-isl12057-fix-isil-vs-isl-naming-for-intersil.patch

This patch was dropped because other changes were merged, which wrecked=
 this patch

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: drivers/rtc/rtc-isl12057.c: fix isil vs isl naming for intersi=
l

When Intersil ISL12057 driver was introduced by commit 70e123373c05 ("r=
tc:
Add support for Intersil ISL12057 I2C RTC chip"), the vendor prefix 'is=
l'
was used instead of the expected 'isil' (Intersil NASDAQ symbol).=20
Recently, a patch from Philip Zabel (7a6540ca856a, "ARM: mvebu: Change
vendor prefix for Intersil Corporation to isil") fixed that prefix in
ReadyNAS devices .dts files (AFAICT, the only users).

That patch completes that work to change the remaining values in:

 - Intersil ISL12057 driver (compatible string) and also associated
   Documentation/devicetree/bindings/i2c/trivial-devices.txt file
   to reflect the changes introduced by previous commit from Philip
 - Documentation/devicetree/bindings/vendor-prefixes.txt files to
   avoid future mistakes

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Acked-by: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/i2c/trivial-devices.txt |    2 +-
 Documentation/devicetree/bindings/vendor-prefixes.txt     |    2 +-
 drivers/rtc/rtc-isl12057.c                                |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc=
-rtc-isl12057-fix-isil-vs-isl-naming-for-intersil Documentation/devicet=
ree/bindings/i2c/trivial-devices.txt
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc-rtc=
-isl12057-fix-isil-vs-isl-naming-for-intersil
+++ a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -55,7 +55,7 @@ fsl,sgtl5000		SGTL5000: Ultra Low-Power
 gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with T=
wo-Wire Interface
 infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max=
 100khz)
 infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
-isl,isl12057		Intersil ISL12057 I2C RTC Chip
+isil,isl12057		Intersil ISL12057 I2C RTC Chip
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
 maxim,max6625		9-Bit/12-Bit Temperature Sensors with I=C2=B2C-Compatib=
le Serial Interface
diff -puN Documentation/devicetree/bindings/vendor-prefixes.txt~rtc-rtc=
-isl12057-fix-isil-vs-isl-naming-for-intersil Documentation/devicetree/=
bindings/vendor-prefixes.txt
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt~rtc-rtc-isl=
12057-fix-isil-vs-isl-naming-for-intersil
+++ a/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -78,7 +78,7 @@ innolux	Innolux Corporation
 intel	Intel Corporation
 intercontrol	Inter Control Group
 isee	ISEE 2007 S.L.
-isl	Intersil
+isil	Intersil
 karo	Ka-Ro electronics GmbH
 keymile	Keymile GmbH
 lacie	LaCie
diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-fix-isil-vs-isl-n=
aming-for-intersil drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-fix-isil-vs-isl-namin=
g-for-intersil
+++ a/drivers/rtc/rtc-isl12057.c
@@ -310,7 +310,8 @@ static int isl12057_probe(struct i2c_cli
=20
 #ifdef CONFIG_OF
 static const struct of_device_id isl12057_dt_match[] =3D {
-	{ .compatible =3D "isl,isl12057" },
+	{ .compatible =3D "isl,isl12057" },  /* obsolete */
+	{ .compatible =3D "isil,isl12057" },
 	{ },
 };
 #endif
_

Patches currently in -mm which might be from arno@natisbad.org are

origin.patch
rtc-rtc-isl12057-fix-masking-of-register-values.patch
rtc-rtc-isl12057-add-support-for-century-bit.patch
rtc-rtc-isl12057-add-proper-handling-of-oscillator-failure-bit.patch
rtc-rtc-isl12057-report-error-code-upon-failure-in-dev_err-calls.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patc=
h
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
