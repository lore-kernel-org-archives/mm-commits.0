From: akpm@linux-foundation.org
Subject: - rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:15 -0700
Message-ID: <200804300551.m3U5pFYx030206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759279AbYD3FvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: add RapidIO node into MPC8641HPCN dts file
has been removed from the -mm tree.  Its filename was
     rapidio-add-rapidio-node-into-mpc8641hpcn-dts-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
rapidio-add-memory-mapping-driver-to-rapidio.patch
rapidio-add-rapidio-space-allocation-bitmap-arithmetic.patch
rapidio-add-fsl-rapidio-controller-memory-ops-functions.patch
rapidio-add-the-rapidio-master-port-maintance-and-doorbell-window-to-space-resources.patch
rapidio-add-rapidio-proc-fs-for-memory-mapping-debugging.patch
rapidio-add-the-memory-mapping-support-in-rionet-driver.patch
rapidio-fix-docbook-references.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

