From: akpm@linux-foundation.org
Subject: [merged] powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:59 -0700
Message-ID: <200909231955.n8NJtxLa003933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776AbZIWT5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben@fluff.org, benh@kernel.crashing.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     powerpc/85xx: add eSDHC support for MPC8536DS boards
has been removed from the -mm tree.  Its filename was
     powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/85xx: add eSDHC support for MPC8536DS boards
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This patch simply adds sdhci node to the device tree.

We specify clock-frequency manually, so that eSDHC will work without
upgrading U-Boot.  Though, that'll only work for default setup (1500 MHz)
on new board revisions.  For non-default setups, it's recommended to
upgrade U-Boot, since it will fixup clock-frequency automatically.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Ben Dooks <ben@fluff.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc8536ds.dts |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc8536ds.dts~powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards arch/powerpc/boot/dts/mpc8536ds.dts
--- a/arch/powerpc/boot/dts/mpc8536ds.dts~powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards
+++ a/arch/powerpc/boot/dts/mpc8536ds.dts
@@ -258,6 +258,14 @@
 			clock-frequency = <250000000>;
 		};
 
+		sdhci@2e000 {
+			compatible = "fsl,mpc8536-esdhc", "fsl,esdhc";
+			reg = <0x2e000 0x1000>;
+			interrupts = <72 0x2>;
+			interrupt-parent = <&mpic>;
+			clock-frequency = <250000000>;
+		};
+
 		serial0: serial@4500 {
 			cell-index = <0>;
 			device_type = "serial";
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

