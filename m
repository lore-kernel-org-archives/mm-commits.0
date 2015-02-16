From: akpm@linux-foundation.org
Subject: [merged]
 rtc-armada38x-add-the-device-tree-binding-documentation.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:19:24 -0800
Message-ID: <54e250cc.XMKTiV7nxRuNU0Ny%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbbBPUUB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:20:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, a.zummo@towertech.it, alior@marvell.com, andrew@lunn.ch, arno@natisbad.org, boris.brezillon@free-electrons.com, ezequiel.garcia@free-electrons.com, jason@lakedaemon.net, mark.rutland@arm.com, maxime.ripard@free-electrons.com, nadavh@marvell.com, sebastian.hesselbarth@gmail.com, tawfik@marvell.com, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: armada38x: add the device tree binding documentation
has been removed from the -mm tree.  Its filename was
     rtc-armada38x-add-the-device-tree-binding-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: rtc: armada38x: add the device tree binding documentation

The Marvell Armada 38x SoCs contains an RTC which differs from the RTC
used in the other mvebu SoCs until now.  This forth version of the patch
set adds support for this new IP and enable it in the Device Tree of the
Armada 38x SoC.


This patch (of 5):

The Armada 38x SoCs come with a new RTC which differs from the one used in
the other mvebu SoCs until now.  This patch describes the binding of this
RTC.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnaud Ebalard <arno@natisbad.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Tawfik Bayouk <tawfik@marvell.com>
Cc: Nadav Haklai <nadavh@marvell.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/armada-380-rtc.txt |   22 ++++++++++
 1 file changed, 22 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/armada-380-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/armada-380-rtc.txt
@@ -0,0 +1,22 @@
+* Real Time Clock of the Armada 38x SoCs
+
+RTC controller for the Armada 38x SoCs
+
+Required properties:
+- compatible : Should be "marvell,armada-380-rtc"
+- reg: a list of base address and size pairs, one for each entry in
+  reg-names
+- reg names: should contain:
+  * "rtc" for the RTC registers
+  * "rtc-soc" for the SoC related registers and among them the one
+    related to the interrupt.
+- interrupts: IRQ line for the RTC.
+
+Example:
+
+rtc@a3800 {
+	compatible = "marvell,armada-380-rtc";
+	reg = <0xa3800 0x20>, <0x184a0 0x0c>;
+	reg-names = "rtc", "rtc-soc";
+	interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
+};
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

origin.patch
linux-next.patch

