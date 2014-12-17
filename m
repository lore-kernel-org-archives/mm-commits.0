From: akpm@linux-foundation.org
Subject: +
 arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patch
 added to -mm tree
Date: Wed, 17 Dec 2014 14:13:36 -0800
Message-ID: <54920010.9lpPPKykxP/Gzhlm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQWNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 17:13:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, darshanapadmadas@gmail.com, galak@codeaurora.org, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob.herring@calxeda.com, rob@landley.net, swarren@wwwdotorg.org, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mvebu: ISL12057 rtc chip can now wake up RN102, RN10=
2 and RN2120
has been added to the -mm tree.  Its filename is
     arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120=
=2Epatch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mvebu-isl12057-rtc-chi=
p-can-now-wake-up-rn102-rn102-and-rn2120.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mvebu-isl12057-rtc-chi=
p-can-now-wake-up-rn102-rn102-and-rn2120.patch

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
Subject: ARM: mvebu: ISL12057 rtc chip can now wake up RN102, RN102 and=
 RN2120

Now that alarm support for ISL12057 chip is available w/ the specific
"isil,irq2-can-wakeup-machine" property, let's use that feature of the
driver dedicated to NETGEAR ReadyNAS 102, 104 and 2120 specific routing=
 of
RTC Alarm IRQ#2 pin; on those devices, this pin is not connected to the
SoC but to a PMIC, which allows the device to be powered up when RTC al=
arm
rings.

=46or that to work, the chip needs to be explicitly marked as a device
wakeup source using this "isil,irq2-can-wakeup-machine" boolean propert=
y.=20
This makes 'wakealarm' sysfs entry available to configure the alarm.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Darshana Padmadas <darshanapadmadas@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Landley <rob@landley.net>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Kumar Gala <galak@codeaurora.org>>
Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/armada-370-netgear-rn102.dts |    1 +
 arch/arm/boot/dts/armada-370-netgear-rn104.dts |    1 +
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts |    1 +
 3 files changed, 3 insertions(+)

diff -puN arch/arm/boot/dts/armada-370-netgear-rn102.dts~arm-mvebu-isl1=
2057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120 arch/arm/boot/dts/=
armada-370-netgear-rn102.dts
--- a/arch/arm/boot/dts/armada-370-netgear-rn102.dts~arm-mvebu-isl12057=
-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120
+++ a/arch/arm/boot/dts/armada-370-netgear-rn102.dts
@@ -87,6 +87,7 @@
 				isl12057: isl12057@68 {
 					compatible =3D "isil,isl12057";
 					reg =3D <0x68>;
+					isil,irq2-can-wakeup-machine;
 				};
=20
 				g762: g762@3e {
diff -puN arch/arm/boot/dts/armada-370-netgear-rn104.dts~arm-mvebu-isl1=
2057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120 arch/arm/boot/dts/=
armada-370-netgear-rn104.dts
--- a/arch/arm/boot/dts/armada-370-netgear-rn104.dts~arm-mvebu-isl12057=
-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120
+++ a/arch/arm/boot/dts/armada-370-netgear-rn104.dts
@@ -93,6 +93,7 @@
 				isl12057: isl12057@68 {
 					compatible =3D "isil,isl12057";
 					reg =3D <0x68>;
+					isil,irq2-can-wakeup-machine;
 				};
=20
 				g762: g762@3e {
diff -puN arch/arm/boot/dts/armada-xp-netgear-rn2120.dts~arm-mvebu-isl1=
2057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120 arch/arm/boot/dts/=
armada-xp-netgear-rn2120.dts
--- a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts~arm-mvebu-isl12057=
-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120
+++ a/arch/arm/boot/dts/armada-xp-netgear-rn2120.dts
@@ -100,6 +100,7 @@
 				isl12057: isl12057@68 {
 					compatible =3D "isil,isl12057";
 					reg =3D <0x68>;
+					isil,irq2-can-wakeup-machine;
 				};
=20
 				/* Controller for rear fan #1 of 3 (Protechnic
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

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
