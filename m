From: akpm@linux-foundation.org
Subject: - powerpc-add-i2c-pins-to-dts-and-board-setup.patch removed from -mm tree
Date: Wed, 14 May 2008 16:38:43 -0700
Message-ID: <200805142338.m4ENchq7027599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747AbYENXit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 19:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@scram.de, mm-commits@vger.kernel.org


The patch titled
     powerpc: add i2c pins to dts and board setup
has been removed from the -mm tree.  Its filename was
     powerpc-add-i2c-pins-to-dts-and-board-setup.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: add i2c pins to dts and board setup
From: Jochen Friedrich <jochen@scram.de>

Initialize I2C pins on boards with CPM1/CPM2 controllers.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc8272ads.dts         |   10 ++++++++++
 arch/powerpc/boot/dts/mpc866ads.dts          |   10 ++++++++++
 arch/powerpc/boot/dts/mpc885ads.dts          |   10 ++++++++++
 arch/powerpc/platforms/82xx/mpc8272_ads.c    |    4 ++++
 arch/powerpc/platforms/8xx/mpc86xads_setup.c |    4 ++++
 arch/powerpc/platforms/8xx/mpc885ads_setup.c |    3 +++
 6 files changed, 41 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc8272ads.dts~powerpc-add-i2c-pins-to-dts-and-board-setup arch/powerpc/boot/dts/mpc8272ads.dts
--- a/arch/powerpc/boot/dts/mpc8272ads.dts~powerpc-add-i2c-pins-to-dts-and-board-setup
+++ a/arch/powerpc/boot/dts/mpc8272ads.dts
@@ -217,6 +217,16 @@
 				linux,network-index = <1>;
 				fsl,cpm-command = <0x16200300>;
 			};
+
+			i2c@11860 {
+				compatible = "fsl,mpc8272-i2c",
+					     "fsl,cpm2-i2c",
+					     "fsl,cpm-i2c";
+				reg = <11860 20 8afc 2>;
+				interrupts = <1 8>;
+				interrupt-parent = <&PIC>;
+				fsl,cpm-command = <29600000>;
+			};
 		};
 
 		PIC: interrupt-controller@10c00 {
diff -puN arch/powerpc/boot/dts/mpc866ads.dts~powerpc-add-i2c-pins-to-dts-and-board-setup arch/powerpc/boot/dts/mpc866ads.dts
--- a/arch/powerpc/boot/dts/mpc866ads.dts~powerpc-add-i2c-pins-to-dts-and-board-setup
+++ a/arch/powerpc/boot/dts/mpc866ads.dts
@@ -171,6 +171,16 @@
 				fsl,cpm-command = <0000>;
 				linux,network-index = <1>;
 			};
+
+			i2c@860 {
+				compatible = "fsl,mpc866-i2c",
+					     "fsl,cpm1-i2c",
+					     "fsl,cpm-i2c";
+				reg = <860 20 3c80 30>;
+				interrupts = <10>;
+				interrupt-parent = <&CPM_PIC>;
+				fsl,cpm-command = <0010>;
+			};
 		};
 	};
 
diff -puN arch/powerpc/boot/dts/mpc885ads.dts~powerpc-add-i2c-pins-to-dts-and-board-setup arch/powerpc/boot/dts/mpc885ads.dts
--- a/arch/powerpc/boot/dts/mpc885ads.dts~powerpc-add-i2c-pins-to-dts-and-board-setup
+++ a/arch/powerpc/boot/dts/mpc885ads.dts
@@ -215,6 +215,16 @@
 				fsl,cpm-command = <0x80>;
 				linux,network-index = <2>;
 			};
+
+			i2c@860 {
+				compatible = "fsl,mpc885-i2c",
+					     "fsl,cpm1-i2c",
+					     "fsl,cpm-i2c";
+				reg = <860 20 3c80 30>;
+				interrupts = <10>;
+				interrupt-parent = <&CPM_PIC>;
+				fsl,cpm-command = <0010>;
+			};
 		};
 	};
 
diff -puN arch/powerpc/platforms/82xx/mpc8272_ads.c~powerpc-add-i2c-pins-to-dts-and-board-setup arch/powerpc/platforms/82xx/mpc8272_ads.c
--- a/arch/powerpc/platforms/82xx/mpc8272_ads.c~powerpc-add-i2c-pins-to-dts-and-board-setup
+++ a/arch/powerpc/platforms/82xx/mpc8272_ads.c
@@ -96,6 +96,10 @@ static struct cpm_pin mpc8272_ads_pins[]
 	{1, 31, CPM_PIN_OUTPUT | CPM_PIN_PRIMARY},
 	{2, 16, CPM_PIN_INPUT | CPM_PIN_PRIMARY},
 	{2, 17, CPM_PIN_INPUT | CPM_PIN_PRIMARY},
+
+	/* I2C */
+	{3, 14, CPM_PIN_INPUT | CPM_PIN_SECONDARY | CPM_PIN_OPENDRAIN},
+	{3, 15, CPM_PIN_INPUT | CPM_PIN_SECONDARY | CPM_PIN_OPENDRAIN},
 };
 
 static void __init init_ioports(void)
diff -puN arch/powerpc/platforms/8xx/mpc86xads_setup.c~powerpc-add-i2c-pins-to-dts-and-board-setup arch/powerpc/platforms/8xx/mpc86xads_setup.c
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c~powerpc-add-i2c-pins-to-dts-and-board-setup
+++ a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -65,6 +65,10 @@ static struct cpm_pin mpc866ads_pins[] =
 	{CPM_PORTD, 13, CPM_PIN_OUTPUT},
 	{CPM_PORTD, 14, CPM_PIN_OUTPUT},
 	{CPM_PORTD, 15, CPM_PIN_OUTPUT},
+
+	/* I2C */
+	{CPM_PORTB, 26, CPM_PIN_INPUT | CPM_PIN_OPENDRAIN},
+	{CPM_PORTB, 27, CPM_PIN_INPUT | CPM_PIN_OPENDRAIN},
 };
 
 static void __init init_ioports(void)
diff -puN arch/powerpc/platforms/8xx/mpc885ads_setup.c~powerpc-add-i2c-pins-to-dts-and-board-setup arch/powerpc/platforms/8xx/mpc885ads_setup.c
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c~powerpc-add-i2c-pins-to-dts-and-board-setup
+++ a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -158,6 +158,9 @@ static struct cpm_pin mpc885ads_pins[] =
 	{CPM_PORTE, 28, CPM_PIN_OUTPUT},
 	{CPM_PORTE, 29, CPM_PIN_OUTPUT},
 #endif
+	/* I2C */
+	{CPM_PORTB, 26, CPM_PIN_INPUT | CPM_PIN_OPENDRAIN},
+	{CPM_PORTB, 27, CPM_PIN_INPUT | CPM_PIN_OPENDRAIN},
 };
 
 static void __init init_ioports(void)
_

Patches currently in -mm which might be from jochen@scram.de are

powerpc-add-i2c-pins-to-dts-and-board-setup.patch
i2c-add-support-for-i2c-bus-on-freescale-cpm1-cpm2-controllers.patch

