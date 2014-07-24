From: akpm@linux-foundation.org
Subject: +
 documentation-dt-add-allwinner-a31-dma-controller-bindings.patch added to
 -mm tree
Date: Thu, 24 Jul 2014 16:44:31 -0700
Message-ID: <53d19a5f.6V9cPI4howM4S3yk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:44038 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaGXXod (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 19:44:33 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so624851qap.0
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 16:44:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime.ripard@free-electrons.com, andriy.shevchenko@intel.com, arnd@arndb.de, dan.j.williams@intel.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: dt: Add Allwinner A31 DMA controller bindings
has been added to the -mm tree.  Its filename is
     documentation-dt-add-allwinner-a31-dma-controller-bindings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-dt-add-allwinner-a31-dma-controller-bindings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-dt-add-allwinner-a31-dma-controller-bindings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

documentation-dt-add-allwinner-a31-dma-controller-bindings.patch
dmaengine-sun6i-add-driver-for-the-allwinner-a31-dma-controller.patch
linux-next.patch

