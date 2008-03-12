From: akpm@linux-foundation.org
Subject: + rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch added to -mm tree
Date: Tue, 11 Mar 2008 21:24:13 -0700
Message-ID: <200803120424.m2C4ODE6009831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYCLEYp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Mar 2008 00:24:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wei.zhang@freescale.com


The patch titled
     rapidio: add RapidIO node into MPC8641HPCN dts file
has been added to the -mm tree.  Its filename is
     rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch

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
Subject: rapidio: add RapidIO node into MPC8641HPCN dts file
From: Zhang Wei <wei.zhang@freescale.com>

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc8641_hpcn.dts |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc8641_hpcn.dts~rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file arch/powerpc/boot/dts/mpc8641_hpcn.dts
--- a/arch/powerpc/boot/dts/mpc8641_hpcn.dts~rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file
+++ a/arch/powerpc/boot/dts/mpc8641_hpcn.dts
@@ -26,6 +26,7 @@
 		serial1 = &serial1;
 		pci0 = &pci0;
 		pci1 = &pci1;
+		rapidio0 = &rapidio0;
 	};
 
 	cpus {
@@ -500,4 +501,15 @@
 				  0x0 0x00100000>;
 		};
 	};
+	rapidio0: rapidio@f80c0000 {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		compatible = "fsl,rapidio-delta";
+		reg = <0xf80c0000 0x20000>;
+		ranges = <0 0 0xc0000000 0 0x20000000>;
+		interrupt-parent = <&mpic>;
+		/* err_irq bell_outb_irq bell_inb_irq
+			msg1_tx_irq msg1_rx_irq	msg2_tx_irq msg2_rx_irq */
+		interrupts = <48 2 49 2 50 2 53 2 54 2 55 2 56 2>;
+	};
 };
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
git-async-tx.patch

