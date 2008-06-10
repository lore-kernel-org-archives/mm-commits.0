From: akpm@linux-foundation.org
Subject: - fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch removed from -mm tree
Date: Mon, 09 Jun 2008 22:29:05 -0700
Message-ID: <200806100529.m5A5T56G027302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYFJF3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 01:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, benh@kernel.crashing.org, dan.j.williams@intel.com, galak@gate.crashing.org, leoli@freescale.com, paulus@samba.org, scottwood@freescale.com, shannon.nelson@in


The patch titled
     fsldma: the MPC8377MDS board device tree node for fsldma driver
has been removed from the -mm tree.  Its filename was
     fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsldma: the MPC8377MDS board device tree node for fsldma driver
From: Zhang Wei <wei.zhang@freescale.com>

The fsldma driver is tested on MPC8377MDS board.  The patch adds fsldma driver
support into MPC8377MDS device tree.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Li Yang <leoli@freescale.com>

On Wed, 14 May 2008 18:28:08 -0500
Scott Wood <scottwood@freescale.com> wrote:


> akpm@linux-foundation.org wrote:
> > From: Zhang Wei <wei.zhang@freescale.com>
> > 
> According to booting-without-of.txt, the interrupts property should be 
> repeated in each channel.  The driver also needs to be fixed to remember 
> whether it registered a DMA-block-level interrupt handler already, and 
> not try to register a channel interrupt.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/mpc8377_mds.dts |   27 ++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN arch/powerpc/boot/dts/mpc8377_mds.dts~fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver arch/powerpc/boot/dts/mpc8377_mds.dts
--- a/arch/powerpc/boot/dts/mpc8377_mds.dts~fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver
+++ a/arch/powerpc/boot/dts/mpc8377_mds.dts
@@ -303,6 +303,33 @@
 			};
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

fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

