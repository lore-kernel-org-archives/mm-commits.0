From: akpm@linux-foundation.org
Subject: + powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch added to -mm tree
Date: Tue, 27 Jan 2009 17:10:33 -0800
Message-ID: <200901280110.n0S1AX5Q027963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbZA1BPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 20:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca


The patch titled
     powerpc/83xx: add mmc-spi support via the device tree for MPC8323E-RDB
has been added to the -mm tree.  Its filename is
     powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch

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
Subject: powerpc/83xx: add mmc-spi support via the device tree for MPC8323E-RDB
From: Anton Vorontsov <avorontsov@ru.mvista.com>

- Add gpio-controller node to manage QE GPIO Bank D;
- Add mmc-spi node;
- Modify board file so that it won't use legacy SPI support with the new
  device trees.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc832x_rdb.dts     |   24 ++++++++++++++++++++
 arch/powerpc/platforms/83xx/mpc832x_rdb.c |    6 +++++
 2 files changed, 30 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc832x_rdb.dts~powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb arch/powerpc/boot/dts/mpc832x_rdb.dts
--- a/arch/powerpc/boot/dts/mpc832x_rdb.dts~powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb
+++ a/arch/powerpc/boot/dts/mpc832x_rdb.dts
@@ -152,10 +152,21 @@
 		};
 
 		par_io@1400 {
+			#address-cells = <1>;
+			#size-cells = <1>;
 			reg = <0x1400 0x100>;
+			ranges = <3 0x1448 0x18>;
+			compatible = "fsl,mpc8323-qe-pario";
 			device_type = "par_io";
 			num-ports = <7>;
 
+			qe_pio_d: gpio-controller@1448 {
+				#gpio-cells = <2>;
+				compatible = "fsl,mpc8323-qe-pario-bank";
+				reg = <3 0x18>;
+				gpio-controller;
+			};
+
 			ucc2pio:ucc_pin@02 {
 				pio-map = <
 			/* port  pin  dir  open_drain  assignment  has_irq */
@@ -225,12 +236,25 @@
 		};
 
 		spi@4c0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
 			cell-index = <0>;
 			compatible = "fsl,spi";
 			reg = <0x4c0 0x40>;
 			interrupts = <2>;
 			interrupt-parent = <&qeic>;
+			gpios = <&qe_pio_d 13 0>;
 			mode = "cpu-qe";
+
+			mmc-slot@0 {
+				compatible = "fsl,mpc8323rdb-mmc-slot",
+					     "mmc-spi-slot";
+				reg = <0>;
+				gpios = <&qe_pio_d 14 1
+					 &qe_pio_d 15 0>;
+				voltage-ranges = <3300 3300>;
+				spi-max-frequency = <50000000>;
+			};
 		};
 
 		spi@500 {
diff -puN arch/powerpc/platforms/83xx/mpc832x_rdb.c~powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb arch/powerpc/platforms/83xx/mpc832x_rdb.c
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c~powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb
+++ a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -68,6 +68,12 @@ static int __init mpc832x_spi_init(void)
 	par_io_config_pin(3, 14, 2, 0, 0, 0); /* SD_INSERT, I */
 	par_io_config_pin(3, 15, 2, 0, 0, 0); /* SD_PROTECT,I */
 
+	/*
+	 * Don't bother with legacy stuff when device tree contains
+	 * mmc-spi-slot node.
+	 */
+	if (of_find_compatible_node(NULL, NULL, "mmc-spi-slot"))
+		return 0;
 	return fsl_spi_init(&mpc832x_spi_boardinfo, 1, mpc83xx_spi_cs_control);
 }
 machine_device_initcall(mpc832x_rdb, mpc832x_spi_init);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-qe-usb-controller-initialization.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch

