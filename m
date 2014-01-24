From: akpm@linux-foundation.org
Subject: [merged] dt-bindings-add-hym8563-binding.patch removed from -mm
 tree
Date: Fri, 24 Jan 2014 11:02:40 -0800
Message-ID: <52e2b8d0.jog/yyxQcjou0vuK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAXTCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@wwwdotorg.org, rob.herring@calxeda.com, richard.weinberger@gmail.com, pawel.moll@arm.com, mturquette@linaro.org, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, grant.likely@linaro.org, broonie@kernel.org, heiko@sntech.de

Subject: [merged] dt-bindings-add-hym8563-binding.patch removed from -mm tree
To: heiko@sntech.de,broonie@kernel.org,grant.likely@linaro.org,ijc+devicetree@hellion.org.uk,mark.rutland@arm.com,mturquette@linaro.org,pawel.moll@arm.com,richard.weinberger@gmail.com,rob.herring@calxeda.com,swarren@wwwdotorg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:40 -0800


The patch titled
     Subject: dt-bindings: add hym8563 binding
has been removed from the -mm tree.  Its filename was
     dt-bindings-add-hym8563-binding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Stuebner <heiko@sntech.de>
Subject: dt-bindings: add hym8563 binding

Add binding documentation for the hym8563 rtc chip.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt |   27 ++++++++++
 Documentation/devicetree/bindings/vendor-prefixes.txt   |    1 
 2 files changed, 28 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
@@ -0,0 +1,27 @@
+Haoyu Microelectronics HYM8563 Real Time Clock
+
+The HYM8563 provides basic rtc and alarm functionality
+as well as a clock output of up to 32kHz.
+
+Required properties:
+- compatible: should be: "haoyu,hym8563"
+- reg: i2c address
+- interrupts: rtc alarm/event interrupt
+- #clock-cells: the value should be 0
+
+Example:
+
+hym8563: hym8563@51 {
+	compatible = "haoyu,hym8563";
+	reg = <0x51>;
+
+	interrupts = <13 IRQ_TYPE_EDGE_FALLING>;
+
+	#clock-cells = <0>;
+};
+
+device {
+...
+	clocks = <&hym8563>;
+...
+};
diff -puN Documentation/devicetree/bindings/vendor-prefixes.txt~dt-bindings-add-hym8563-binding Documentation/devicetree/bindings/vendor-prefixes.txt
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt~dt-bindings-add-hym8563-binding
+++ a/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -34,6 +34,7 @@ fsl	Freescale Semiconductor
 GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gmt	Global Mixed-mode Technology, Inc.
+haoyu	Haoyu Microelectronic Co. Ltd.
 hisilicon	Hisilicon Limited.
 hp	Hewlett Packard
 ibm	International Business Machines (IBM)
_

Patches currently in -mm which might be from heiko@sntech.de are

origin.patch
linux-next.patch

