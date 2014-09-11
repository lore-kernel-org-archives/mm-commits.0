From: akpm@linux-foundation.org
Subject: + rtc-bq32000-add-trickle-charger-device-tree-binding.patch added to -mm tree
Date: Thu, 11 Sep 2014 13:24:46 -0700
Message-ID: <5412050e.vOCTaxIoICsg1Q5B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaIKUYr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 16:24:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, a.zummo@towertech.it, ijc+devicetree@hellion.org.uk, jason@lakedameon.net, linux@roeck-us.net, matti.vaittinen@nsn.com, pavel@denx.de, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: bq32000: add trickle charger device tree binding
has been added to the -mm tree.  Its filename is
     rtc-bq32000-add-trickle-charger-device-tree-binding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-bq32000-add-trickle-charger-device-tree-binding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-bq32000-add-trickle-charger-device-tree-binding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: rtc: bq32000: add trickle charger device tree binding

BQ32000 have "trickle chargers".  Introduce a device tree binding for
specifying the trickle charger configuration for that.

Signed-off-by: Pavel Machek <pavel@denx.de>
Reviewed-by: Jason Cooper <jason@lakedameon.net>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/i2c/ti,bq32k.txt |   18 +++++++++++
 1 file changed, 18 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/i2c/ti,bq32k.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/i2c/ti,bq32k.txt
@@ -0,0 +1,18 @@
+* TI BQ32000                I2C Serial Real-Time Clock
+
+Required properties:
+- compatible: Should contain "ti,bq32000".
+- reg: I2C address for chip
+
+Optional properties:
+- trickle-resistor-ohms : Selected resistor for trickle charger
+       Values usable are 1120 and 20180
+       Should be given if trickle charger should be enabled
+- trickle-diode-disable : Do not use internal trickle charger diode
+       Should be given if internal trickle charger diode should be disabled
+Example:
+       bq32000: rtc@68 {
+               compatible = "ti,bq32000";
+               trickle-resistor-ohms = <1120>;
+               reg = <0x68>;
+       };
_

Patches currently in -mm which might be from pavel@ucw.cz are

input-route-kbd-leds-through-the-generic-leds-layer.patch
lib-vsprintf-add-%pt-format-specifier.patch
rtc-bq32000-add-trickle-charger-device-tree-binding.patch
linux-next.patch

