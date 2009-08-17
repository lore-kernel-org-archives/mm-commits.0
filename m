From: akpm@linux-foundation.org
Subject: + powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch added to -mm tree
Date: Mon, 17 Aug 2009 16:09:09 -0700
Message-ID: <200908172309.n7HN9AXB014839__26839.9840956137$1250550856$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758334AbZHQXOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 19:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben@fluff.org, benh@kernel.crashing.org, david.vrabel@csr.com, galak@kernel.crashing.org, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     powerpc: introduce and document sdhci,wp-inverted property for eSDHC
has been added to the -mm tree.  Its filename is
     powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
sdhci-be-more-strict-with-get_min_clock-usage.patch
sdhci-of-fix-sd-clock-calculation.patch
sdhci-of-avoid-writing-reserved-bits-into-host-control-register.patch
sdhci-of-fix-high-speed-cards-recognition.patch
powerpc-introduce-and-document-sdhciwp-inverted-property-for-esdhc.patch
sdhci-of-dont-hard-code-inverted-write-protect-quirk.patch
sdhci-of-cleanup-esdhcs-set_clock-a-little-bit.patch
powerpc-85xx-add-esdhc-support-for-mpc8536ds-boards.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch

