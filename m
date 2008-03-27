From: akpm@linux-foundation.org
Subject: + fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:11:47 -0700
Message-ID: <200803270811.m2R8Blpb025096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755335AbYC0IMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wei.zhang@freescale.com, dan.j.williams@intel.com, shannon.nelson@intel.com


The patch titled
     fsldma: the MPC8377MDS board device tree node for fsldma driver
has been added to the -mm tree.  Its filename is
     fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsldma: the MPC8377MDS board device tree node for fsldma driver
From: Zhang Wei <wei.zhang@freescale.com>

The fsldma driver is tested on MPC8377MDS board.  The patch adds fsldma driver
support into MPC8377MDS device tree.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc8377_mds.dts |   27 ++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc8377_mds.dts~fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver arch/powerpc/boot/dts/mpc8377_mds.dts
--- a/arch/powerpc/boot/dts/mpc8377_mds.dts~fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver
+++ a/arch/powerpc/boot/dts/mpc8377_mds.dts
@@ -268,6 +268,33 @@
 			interrupt-parent = <&ipic>;
 		};
 
+		dma@82a8 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,mpc8349-dma";
+			reg = <0x82a8 4>;
+			ranges = <0 0x8100 0x1a8>;
+			interrupt-parent = <&ipic>;
+			interrupts = <0x47 8>;
+			cell-index = <0>;
+			dma-channel@0 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0 0x80>;
+			};
+			dma-channel@80 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0x80 0x80>;
+			};
+			dma-channel@100 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0x100 0x80>;
+			};
+			dma-channel@180 {
+				compatible = "fsl,mpc8349-dma-channel";
+				reg = <0x180 0x28>;
+			};
+		};
+
 		/* IPIC
 		 * interrupts cell = <intr #, sense>
 		 * sense values match linux IORESOURCE_IRQ_* defines:
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

rapidio-change-rio-function-mpc85xx_-to-fsl_.patch
rapidio-add-rapidio-option-to-kernel-configuration.patch
rapidio-move-include-asm-ppc-rioh-to-include-asm-powerpc-rioh.patch
rapidio-add-rapidio-multi-mport-support.patch
rapidio-add-of-tree-support-to-rapidio-controller-driver.patch
rapidio-change-the-kernel-configurated-rapidio-system-size-to-auto-probing.patch
rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch
rapidio-add-rapidio-node-probing-into-mpc86xx_hpcn-board-id-table.patch
rapidio-add-serial-rapidio-controller-support-which-includes-mpc8548-mpc8641.patch
rapidio-add-rapidio-connection-info-print-out-and-re-training-for-break-connection.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-change-rapidio-doorbell-source-and-target-id-field-to-16-bit.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-remove-config_fsl_dma_selftest-keep-fsl_dma_self_test-running-always.patch
fsldma-split-the-mpc83xx-event-from-mpc85xx-and-refine-irq-codes.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

