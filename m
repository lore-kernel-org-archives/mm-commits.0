From: akpm@linux-foundation.org
Subject: [merged]
 documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:28:17 -0700
Message-ID: <53960ad1.rZj3DtvD3OnM/ZQC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaFIT2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, rsahu@apm.com, jcm@redhat.com, catalin.marinas@arm.com, a.zummo@towertech.it, lho@apm.com

Subject: [merged] documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch removed from -mm tree
To: lho@apm.com,a.zummo@towertech.it,catalin.marinas@arm.com,jcm@redhat.com,rsahu@apm.com,will.deacon@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:28:17 -0700


The patch titled
     Subject: Documentation/devicetree/bindings: add documentation for the APM X-Gene SoC RTC DTS binding
has been removed from the -mm tree.  Its filename was
     documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Loc Ho <lho@apm.com>
Subject: Documentation/devicetree/bindings: add documentation for the APM X-Gene SoC RTC DTS binding

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Signed-off-by: Loc Ho <lho@apm.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/xgene-rtc.txt |   28 ++++++++++
 1 file changed, 28 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/xgene-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/xgene-rtc.txt
@@ -0,0 +1,28 @@
+* APM X-Gene Real Time Clock
+
+RTC controller for the APM X-Gene Real Time Clock
+
+Required properties:
+- compatible : Should be "apm,xgene-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: IRQ line for the RTC.
+- #clock-cells: Should be 1.
+- clocks: Reference to the clock entry.
+
+Example:
+
+rtcclk: rtcclk {
+	compatible = "fixed-clock";
+	#clock-cells = <1>;
+	clock-frequency = <100000000>;
+	clock-output-names = "rtcclk";
+};
+
+rtc: rtc@10510000 {
+	compatible = "apm,xgene-rtc";
+	reg = <0x0 0x10510000 0x0 0x400>;
+	interrupts = <0x0 0x46 0x4>;
+	#clock-cells = <1>;
+	clocks = <&rtcclk 0>;
+};
_

Patches currently in -mm which might be from lho@apm.com are

origin.patch
linux-next.patch

