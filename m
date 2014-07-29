From: akpm@linux-foundation.org
Subject: [merged]
 documentation-dt-add-allwinner-a31-dma-controller-bindings.patch removed
 from -mm tree
Date: Tue, 29 Jul 2014 12:08:16 -0700
Message-ID: <53d7f120.pZrWaKJeBm1Rh5U8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:42404 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaG2TIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jul 2014 15:08:17 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so46530oac.5
        for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2014 12:08:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime.ripard@free-electrons.com, andriy.shevchenko@intel.com, arnd@arndb.de, dan.j.williams@intel.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: dt: Add Allwinner A31 DMA controller bindings
has been removed from the -mm tree.  Its filename was
     documentation-dt-add-allwinner-a31-dma-controller-bindings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Documentation: dt: Add Allwinner A31 DMA controller bindings

This patchset adds support for the DMA controller found in the
Allwinner A31 and A23 SoCs.

This has been tested using the newly introduced SPI driver on an A31
EVK. Support for DMA-driven SPI transfers will be the subject of
another patch serie.

This patch (of 2):

The Allwinner A31 DMA controller is rather simple to describe in the DT. Add
the bindings documentation.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/dma/sun6i-dma.txt |   45 ++++++++++
 1 file changed, 45 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/dma/sun6i-dma.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/dma/sun6i-dma.txt
@@ -0,0 +1,45 @@
+Allwinner A31 DMA Controller
+
+This driver follows the generic DMA bindings defined in dma.txt.
+
+Required properties:
+
+- compatible:	Must be "allwinner,sun6i-a31-dma"
+- reg:		Should contain the registers base address and length
+- interrupts:	Should contain a reference to the interrupt used by this device
+- clocks:	Should contain a reference to the parent AHB clock
+- resets:	Should contain a reference to the reset controller asserting
+		this device in reset
+- #dma-cells :	Should be 1, a single cell holding a line request number
+
+Example:
+	dma: dma-controller@01c02000 {
+		compatible = "allwinner,sun6i-a31-dma";
+		reg = <0x01c02000 0x1000>;
+		interrupts = <0 50 4>;
+		clocks = <&ahb1_gates 6>;
+		resets = <&ahb1_rst 6>;
+		#dma-cells = <1>;
+	};
+
+Clients:
+
+DMA clients connected to the A31 DMA controller must use the format
+described in the dma.txt file, using a two-cell specifier for each
+channel: a phandle plus one integer cells.
+The two cells in order are:
+
+1. A phandle pointing to the DMA controller.
+2. The port ID as specified in the datasheet
+
+Example:
+spi2: spi@01c6a000 {
+	compatible = "allwinner,sun6i-a31-spi";
+	reg = <0x01c6a000 0x1000>;
+	interrupts = <0 67 4>;
+	clocks = <&ahb1_gates 22>, <&spi2_clk>;
+	clock-names = "ahb", "mod";
+	dmas = <&dma 25>, <&dma 25>;
+	dma-names = "rx", "tx";
+	resets = <&ahb1_rst 22>;
+};
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

linux-next.patch

