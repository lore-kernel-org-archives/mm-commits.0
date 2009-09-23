From: akpm@linux-foundation.org
Subject: [merged] powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:47 -0700
Message-ID: <200909231955.n8NJtlLT003555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbZIWT5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben@fluff.org, benh@kernel.crashing.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     powerpc: introduce and document sdhci,wp-inverted property for eSDHC
has been removed from the -mm tree.  Its filename was
     powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: introduce and document sdhci,wp-inverted property for eSDHC
From: Anton Vorontsov <avorontsov@ru.mvista.com>

eSDHC block in MPC837x SOCs reports inverted write-protect state, soon
sdhci-of driver will look for sdhci,wp-inverted properties to decide
whether apply a specific quirk.

So, document the property and add it to device tree source files.

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

 Documentation/powerpc/dts-bindings/fsl/esdhc.txt |    2 ++
 arch/powerpc/boot/dts/mpc8377_mds.dts            |    1 +
 arch/powerpc/boot/dts/mpc8377_rdb.dts            |    1 +
 arch/powerpc/boot/dts/mpc8377_wlan.dts           |    1 +
 arch/powerpc/boot/dts/mpc8378_mds.dts            |    1 +
 arch/powerpc/boot/dts/mpc8378_rdb.dts            |    1 +
 arch/powerpc/boot/dts/mpc8379_mds.dts            |    1 +
 arch/powerpc/boot/dts/mpc8379_rdb.dts            |    1 +
 8 files changed, 9 insertions(+)

diff -puN Documentation/powerpc/dts-bindings/fsl/esdhc.txt~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc Documentation/powerpc/dts-bindings/fsl/esdhc.txt
--- a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt
@@ -10,6 +10,8 @@ Required properties:
   - interrupts : should contain eSDHC interrupt.
   - interrupt-parent : interrupt source phandle.
   - clock-frequency : specifies eSDHC base clock frequency.
+  - sdhci,wp-inverted : (optional) specifies that eSDHC controller
+    reports inverted write-protect state;
   - sdhci,1-bit-only : (optional) specifies that a controller can
     only handle 1-bit data transfers.
 
diff -puN arch/powerpc/boot/dts/mpc8377_mds.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc arch/powerpc/boot/dts/mpc8377_mds.dts
--- a/arch/powerpc/boot/dts/mpc8377_mds.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/arch/powerpc/boot/dts/mpc8377_mds.dts
@@ -159,6 +159,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <0>;
 			};
diff -puN arch/powerpc/boot/dts/mpc8377_rdb.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc arch/powerpc/boot/dts/mpc8377_rdb.dts
--- a/arch/powerpc/boot/dts/mpc8377_rdb.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/arch/powerpc/boot/dts/mpc8377_rdb.dts
@@ -173,6 +173,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <111111111>;
 			};
diff -puN arch/powerpc/boot/dts/mpc8377_wlan.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc arch/powerpc/boot/dts/mpc8377_wlan.dts
--- a/arch/powerpc/boot/dts/mpc8377_wlan.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/arch/powerpc/boot/dts/mpc8377_wlan.dts
@@ -150,6 +150,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				clock-frequency = <133333333>;
 			};
 		};
diff -puN arch/powerpc/boot/dts/mpc8378_mds.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc arch/powerpc/boot/dts/mpc8378_mds.dts
--- a/arch/powerpc/boot/dts/mpc8378_mds.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/arch/powerpc/boot/dts/mpc8378_mds.dts
@@ -159,6 +159,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <0>;
 			};
diff -puN arch/powerpc/boot/dts/mpc8378_rdb.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc arch/powerpc/boot/dts/mpc8378_rdb.dts
--- a/arch/powerpc/boot/dts/mpc8378_rdb.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/arch/powerpc/boot/dts/mpc8378_rdb.dts
@@ -173,6 +173,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <111111111>;
 			};
diff -puN arch/powerpc/boot/dts/mpc8379_mds.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc arch/powerpc/boot/dts/mpc8379_mds.dts
--- a/arch/powerpc/boot/dts/mpc8379_mds.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/arch/powerpc/boot/dts/mpc8379_mds.dts
@@ -157,6 +157,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <0>;
 			};
diff -puN arch/powerpc/boot/dts/mpc8379_rdb.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc arch/powerpc/boot/dts/mpc8379_rdb.dts
--- a/arch/powerpc/boot/dts/mpc8379_rdb.dts~powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc
+++ a/arch/powerpc/boot/dts/mpc8379_rdb.dts
@@ -171,6 +171,7 @@
 				reg = <0x2e000 0x1000>;
 				interrupts = <42 0x8>;
 				interrupt-parent = <&ipic>;
+				sdhci,wp-inverted;
 				/* Filled in by U-Boot */
 				clock-frequency = <111111111>;
 			};
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

