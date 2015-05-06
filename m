From: akpm@linux-foundation.org
Subject: [merged] documentation-bindings-add-abraconabx80x.patch removed
 from -mm tree
Date: Wed, 06 May 2015 11:58:18 -0700
Message-ID: <554a644a.qgyzcIQj9qNNUbv1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbbEFS6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 14:58:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.belloni@free-electrons.com, a.zummo@towertech.it, arnd@arndb.de, pebolle@tiscali.nl, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: bindings: add abracon,abx80x
has been removed from the -mm tree.  Its filename was
     documentation-bindings-add-abraconabx80x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Documentation: bindings: add abracon,abx80x

Document the bindings for abracon,abx80x and related compatibles.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Philippe De Muyter <phdm@macqel.be>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/abracon,abx80x.txt |   32 ++++++++++
 1 file changed, 32 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/abracon,abx80x.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/abracon,abx80x.txt
@@ -0,0 +1,32 @@
+Abracon ABX80X I2C ultra low power RTC/Alarm chip
+
+The Abracon ABX80X family consist of the ab0801, ab0803, ab0804, ab0805, ab1801,
+ab1803, ab1804 and ab1805. The ab0805 is the superset of ab080x and the ab1805
+is the superset of ab180x.
+
+Required properties:
+
+ - "compatible": should one of:
+        "abracon,abx80x"
+        "abracon,ab0801"
+        "abracon,ab0803"
+        "abracon,ab0804"
+        "abracon,ab0805"
+        "abracon,ab1801"
+        "abracon,ab1803"
+        "abracon,ab1804"
+        "abracon,ab1805"
+	Using "abracon,abx80x" will enable chip autodetection.
+ - "reg": I2C bus address of the device
+
+Optional properties:
+
+The abx804 and abx805 have a trickle charger that is able to charge the
+connected battery or supercap. Both the following properties have to be defined
+and valid to enable charging:
+
+ - "abracon,tc-diode": should be "standard" (0.6V) or "schottky" (0.3V)
+ - "abracon,tc-resistor": should be <0>, <3>, <6> or <11>. 0 disables the output
+                          resistor, the other values are in ohm.
+
+
_

Patches currently in -mm which might be from alexandre.belloni@free-electrons.com are

origin.patch
drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time.patch
linux-next.patch

