From: akpm@linux-foundation.org
Subject: [merged]
 arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 11:07:03 -0800
Message-ID: <5489eb57.D3YDCa5Pm+I08+EP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbaLKTHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johan@kernel.org, a.zummo@towertech.it, balbi@ti.com, bcousson@baylibre.com, j-keerthy@ti.com, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dts: am335x-boneblack: enable power off and rtc wake up
has been removed from the -mm tree.  Its filename was
     arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <johan@kernel.org>
Subject: ARM: dts: am335x-boneblack: enable power off and rtc wake up

Configure the RTC as system-power controller, which allows the system to
be powered off as well as woken up again on subsequent RTC alarms.

Note that the PMIC needs to be put in SLEEP (rather than OFF) mode to
maintain RTC power.  Specifically, this means that the PMIC
ti,pmic-shutdown-controller property must be left unset in order to be
able to wake up on RTC alarms.

Tested on BeagleBone Black (rev A5).

Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Keerthy J <j-keerthy@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/boot/dts/am335x-boneblack.dts |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/arm/boot/dts/am335x-boneblack.dts~arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up arch/arm/boot/dts/am335x-boneblack.dts
--- a/arch/arm/boot/dts/am335x-boneblack.dts~arm-dts-am335x-boneblack-enable-power-off-and-rtc-wake-up
+++ a/arch/arm/boot/dts/am335x-boneblack.dts
@@ -80,3 +80,7 @@
 		status = "okay";
 	};
 };
+
+&rtc {
+	ti,system-power-controller;
+};
_

Patches currently in -mm which might be from johan@kernel.org are

origin.patch
linux-next.patch

