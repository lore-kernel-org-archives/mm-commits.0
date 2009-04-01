From: akpm@linux-foundation.org
Subject: [merged] powerpc-add-mmc-spi-slot-bindings.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:29 -0700
Message-ID: <200904011841.n31IfTfg009380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933613AbZDASqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     powerpc: add mmc-spi-slot bindings
has been removed from the -mm tree.  Its filename was
     powerpc-add-mmc-spi-slot-bindings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: add mmc-spi-slot bindings
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The bindings describes a case where MMC/SD/SDIO slot directly connected to
a SPI bus.  Such setups are widely used on embedded PowerPC boards.

The patch also adds the mmc-spi-slot entry to the OpenFirmware modalias
table.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/powerpc/dts-bindings/mmc-spi-slot.txt |   23 ++++++++++
 drivers/of/base.c                                   |    1 
 2 files changed, 24 insertions(+)

diff -puN /dev/null Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
--- /dev/null
+++ a/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
@@ -0,0 +1,23 @@
+MMC/SD/SDIO slot directly connected to a SPI bus
+
+Required properties:
+- compatible : should be "mmc-spi-slot".
+- reg : should specify SPI address (chip-select number).
+- spi-max-frequency : maximum frequency for this device (Hz).
+- voltage-ranges : two cells are required, first cell specifies minimum
+  slot voltage (mV), second cell specifies maximum slot voltage (mV).
+  Several ranges could be specified.
+- gpios : (optional) may specify GPIOs in this order: Card-Detect GPIO,
+  Write-Protect GPIO.
+
+Example:
+
+	mmc-slot@0 {
+		compatible = "fsl,mpc8323rdb-mmc-slot",
+			     "mmc-spi-slot";
+		reg = <0>;
+		gpios = <&qe_pio_d 14 1
+			 &qe_pio_d 15 0>;
+		voltage-ranges = <3300 3300>;
+		spi-max-frequency = <50000000>;
+	};
diff -puN drivers/of/base.c~powerpc-add-mmc-spi-slot-bindings drivers/of/base.c
--- a/drivers/of/base.c~powerpc-add-mmc-spi-slot-bindings
+++ a/drivers/of/base.c
@@ -446,6 +446,7 @@ struct of_modalias_table {
 };
 static struct of_modalias_table of_modalias_table[] = {
 	{ "fsl,mcu-mpc8349emitx", "mcu-mpc8349emitx" },
+	{ "mmc-spi-slot", "mmc_spi" },
 };
 
 /**
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch

