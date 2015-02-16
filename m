From: akpm@linux-foundation.org
Subject: [merged]
 arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:19:33 -0800
Message-ID: <54e250d5.4PHiG6HkrCn/f3Cw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbbBPUUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, a.zummo@towertech.it, alior@marvell.com, andrew@lunn.ch, arno@natisbad.org, boris.brezillon@free-electrons.com, ezequiel.garcia@free-electrons.com, jason@lakedaemon.net, mark.rutland@arm.com, maxime.ripard@free-electrons.com, nadavh@marvell.com, sebastian.hesselbarth@gmail.com, tawfik@marvell.com, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mvebu: add Device Tree description of RTC on Armada 38x
has been removed from the -mm tree.  Its filename was
     arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: ARM: mvebu: add Device Tree description of RTC on Armada 38x

The Marvell Armada 38x SoCs contains an RTC which differs from the RTC
used in the other mvebu SoCs until now.  This commit adds the Device Tree
description of this interface at the SoC level.

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

 arch/arm/boot/dts/armada-38x.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/arm/boot/dts/armada-38x.dtsi~arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x arch/arm/boot/dts/armada-38x.dtsi
--- a/arch/arm/boot/dts/armada-38x.dtsi~arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x
+++ a/arch/arm/boot/dts/armada-38x.dtsi
@@ -381,6 +381,13 @@
 				clocks = <&gateclk 4>;
 			};
 
+			rtc@a3800 {
+				compatible = "marvell,armada-380-rtc";
+				reg = <0xa3800 0x20>, <0x184a0 0x0c>;
+				reg-names = "rtc", "rtc-soc";
+				interrupts = <GIC_SPI 21 IRQ_TYPE_LEVEL_HIGH>;
+			};
+
 			sata@a8000 {
 				compatible = "marvell,armada-380-ahci";
 				reg = <0xa8000 0x2000>;
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

origin.patch
linux-next.patch

