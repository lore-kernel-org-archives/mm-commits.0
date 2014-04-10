From: akpm@linux-foundation.org
Subject: + arm64-add-apm-x-gene-soc-rtc-dts-entry.patch added to -mm tree
Date: Thu, 10 Apr 2014 16:24:56 -0700
Message-ID: <53472848.EdphOEonNns4fKeS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268AbaDJXY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Apr 2014 19:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will.deacon@arm.com, rsahu@apm.com, jcm@redhat.com, catalin.marinas@arm.com, a.zummo@towertech.it, lho@apm.com

Subject: + arm64-add-apm-x-gene-soc-rtc-dts-entry.patch added to -mm tree
To: lho@apm.com,a.zummo@towertech.it,catalin.marinas@arm.com,jcm@redhat.com,rsahu@apm.com,will.deacon@arm.com
From: akpm@linux-foundation.org
Date: Thu, 10 Apr 2014 16:24:56 -0700


The patch titled
     Subject: arm64: add APM X-Gene SoC RTC DTS entry
has been added to the -mm tree.  Its filename is
     arm64-add-apm-x-gene-soc-rtc-dts-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-add-apm-x-gene-soc-rtc-dts-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Loc Ho <lho@apm.com>
Subject: arm64: add APM X-Gene SoC RTC DTS entry

This patch adds APM X-Gene SoC RTC DTS entry

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Signed-off-by: Loc Ho <lho@apm.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/boot/dts/apm-storm.dtsi |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN arch/arm64/boot/dts/apm-storm.dtsi~arm64-add-apm-x-gene-soc-rtc-dts-entry arch/arm64/boot/dts/apm-storm.dtsi
--- a/arch/arm64/boot/dts/apm-storm.dtsi~arm64-add-apm-x-gene-soc-rtc-dts-entry
+++ a/arch/arm64/boot/dts/apm-storm.dtsi
@@ -257,6 +257,19 @@
 				enable-offset = <0x0>;
 				enable-mask = <0x39>;
 			};
+
+			rtcclk: rtcclk@17000000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x17000000 0x0 0x2000>;
+				reg-names = "csr-reg";
+				csr-offset = <0xc>;
+				csr-mask = <0x2>;
+				enable-offset = <0x10>;
+				enable-mask = <0x2>;
+				clock-output-names = "rtcclk";
+			};
 		};
 
 		serial0: serial@1c020000 {
@@ -339,5 +352,13 @@
 			phys = <&phy3 0>;
 			phy-names = "sata-phy";
 		};
+
+		rtc: rtc@10510000 {
+			compatible = "apm,xgene-rtc";
+			reg = <0x0 0x10510000 0x0 0x400>;
+			interrupts = <0x0 0x46 0x4>;
+			#clock-cells = <1>;
+			clocks = <&rtcclk 0>;
+		};
 	};
 };
_

Patches currently in -mm which might be from lho@apm.com are

origin.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

