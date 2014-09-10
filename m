From: akpm@linux-foundation.org
Subject: +
 documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch added to -mm tree
Date: Wed, 10 Sep 2014 16:56:54 -0700
Message-ID: <5410e546.+McUiee/ORyOjcOx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbaIJX4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 19:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matti.vaittinen@nsn.com, a.zummo@towertech.it, jason@lakedaemon.net, linux@roeck-us.net, mark.rutland@arm.com, pavel@denx.de, pawel.moll@arm.com, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: dt-bindings: trickle charger dt binding document for ds1339
has been added to the -mm tree.  Its filename is
     documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matti Vaittinen <matti.vaittinen@nsn.com>
Subject: Documentation: dt-bindings: trickle charger dt binding document for ds1339

Some DS13XX devices have "trickle chargers".  Introduce a device tree
binding for the resistor and diode configuration for enabling trickle
charger.

Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pavel Machek <pavel@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/i2c/trivial-devices.txt |    1 
 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt   |   18 ++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN Documentation/devicetree/bindings/i2c/trivial-devices.txt~documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339 Documentation/devicetree/bindings/i2c/trivial-devices.txt
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt~documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339
+++ a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -35,7 +35,6 @@ catalyst,24c32		i2c serial eeprom
 cirrus,cs42l51		Cirrus Logic CS42L51 audio codec
 dallas,ds1307		64 x 8, Serial, I2C Real-Time Clock
 dallas,ds1338		I2C RTC with 56-Byte NV RAM
-dallas,ds1339		I2C Serial Real-Time Clock
 dallas,ds1340		I2C RTC with Trickle Charger
 dallas,ds1374		I2C, 32-Bit Binary Counter Watchdog RTC with Trickle Charger and Reset Input/Output
 dallas,ds1631		High-Precision Digital Thermometer
diff -puN /dev/null Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
@@ -0,0 +1,18 @@
+* Dallas DS1339		I2C Serial Real-Time Clock
+
+Required properties:
+- compatible: Should contain "dallas,ds1339".
+- reg: I2C address for chip
+
+Optional properties:
+- trickle-resistor-ohms : Selected resistor for trickle charger
+	Values usable for ds1339 are 250, 2000, 4000
+	Should be given if trickle charger should be enabled
+- trickle-diode-disable : Do not use internal trickle charger diode
+	Should be given if internal trickle charger diode should be disabled
+Example:
+	ds1339: rtc@68 {
+		compatible = "dallas,ds1339";
+		trickle-resistor-ohms = <250>;
+		reg = <0x68>;
+	};
_

Patches currently in -mm which might be from matti.vaittinen@nsn.com are

documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch
rtc-ds1307-add-trickle-charger-device-tree-binding.patch

