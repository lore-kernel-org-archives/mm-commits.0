From: akpm@linux-foundation.org
Subject: [merged] arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:59 -0800
Message-ID: <20130222204359.A84D131C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48080 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302Ab3BVUoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:00 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so104112vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, andrew@lunn.ch, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mvebu: add RTC support for Armada 370 and Armada XP
has been removed from the -mm tree.  Its filename was
     arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: arm: mvebu: add RTC support for Armada 370 and Armada XP

The Armada 370 and Armada XP Socs have the same controller that the one
used in the orion platforms.  This patch updates the device tree for these
SoCs.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/armada-370-xp.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/arm/boot/dts/armada-370-xp.dtsi~arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp arch/arm/boot/dts/armada-370-xp.dtsi
--- a/arch/arm/boot/dts/armada-370-xp.dtsi~arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp
+++ a/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -131,6 +131,12 @@
 			clocks = <&coreclk 0>;
 			status = "disabled";
 		};
+
+		rtc@10300 {
+			compatible = "marvell,orion-rtc";
+			reg = <0xd0010300 0x20>;
+			interrupts = <50>;
+		};
 	};
 };
 
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

origin.patch
linux-next.patch

