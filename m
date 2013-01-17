From: akpm@linux-foundation.org
Subject: + arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch added to -mm tree
Date: Wed, 16 Jan 2013 16:03:35 -0800
Message-ID: <20130117000336.345AD82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:54034 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3AQADh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 19:03:37 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so242020yhr.4
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 16:03:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregory.clement@free-electrons.com, andrew@lunn.ch, linux@arm.linux.org.uk


The patch titled
     Subject: arm: mvebu: add RTC support for Armada 370 and Armada XP
has been added to the -mm tree.  Its filename is
     arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
rtc-add-support-of-rtc-mv-for-mvebu-socs.patch
arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch
arm-mvebu-update-defconfig-with-marvell-rtc-support.patch

