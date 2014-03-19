From: akpm@linux-foundation.org
Subject: + mfd-devicetree-bindings-add-pm8xxx-rtc-description.patch added
 to -mm tree
Date: Wed, 19 Mar 2014 16:17:16 -0700
Message-ID: <532a257c.O6KRPBgJWBIKt2/5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbaCSXRR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 19:17:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, robherring2@gmail.com, lee.jones@linaro.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: + mfd-devicetree-bindings-add-pm8xxx-rtc-description.patch added to -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,lee.jones@linaro.org,robherring2@gmail.com,sboyd@codeaurora.org
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 16:17:16 -0700


The patch titled
     Subject: mfd: devicetree: bindings: add pm8xxx RTC description
has been added to the -mm tree.  Its filename is
     mfd-devicetree-bindings-add-pm8xxx-rtc-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mfd-devicetree-bindings-add-pm8xxx-rtc-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mfd-devicetree-bindings-add-pm8xxx-rtc-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Cartwright <joshc@codeaurora.org>
Subject: mfd: devicetree: bindings: add pm8xxx RTC description

The PM8xxx family of PMICs contain an RTC.  This RTC is described as a
subnode of the PM8xxx.  Document these bindings, and replace the pwrkey
node in the example with the RTC, which is now described in this document.

While we're here, add a short description to the device tree bindings
describing what the the PM8xxx devices are and how they are expected to be
used.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Rob Herring <robherring2@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt |   45 ++++++++--
 1 file changed, 39 insertions(+), 6 deletions(-)

diff -puN Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt~mfd-devicetree-bindings-add-pm8xxx-rtc-description Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
--- a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt~mfd-devicetree-bindings-add-pm8xxx-rtc-description
+++ a/Documentation/devicetree/bindings/mfd/qcom,pm8xxx.txt
@@ -1,6 +1,9 @@
 Qualcomm PM8xxx PMIC multi-function devices
 
-PROPERTIES
+The PM8xxx family of Power Management ICs are used to provide regulated
+voltages and other various functionality to Qualcomm SoCs.
+
+= PROPERTIES
 
 - compatible:
 	Usage: required
@@ -45,7 +48,37 @@ PROPERTIES
 	Value type: <empty>
 	Definition: identifies this node as an interrupt controller
 
-EXAMPLE
+= SUBCOMPONENTS
+
+The PMIC contains multiple independent functions, each described in a subnode.
+The below bindings specify the set of valid subnodes.
+
+== Real-Time Clock
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8058-rtc"
+		    "qcom,pm8921-rtc"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: single entry specifying the base address of the RTC registers
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: single entry specifying the RTC's alarm interrupt
+
+- allow-set-time:
+	Usage: optional
+	Value type: <empty>
+	Definition: indicates that the setting of RTC time is allowed by
+		    the host CPU
+
+= EXAMPLE
 
 	pmicintc: pmic@0 {
 		compatible = "qcom,pm8921";
@@ -55,9 +88,9 @@ EXAMPLE
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		pwrkey {
-			compatible = "qcom,pm8921-pwrkey";
-			interrupt-parent = <&pmicintc>;
-			interrupts = <50 1>, <51 1>;
+		rtc@11d {
+			compatible = "qcom,pm8921-rtc";
+			reg = <0x11d>;
+			interrupts = <0x27 0>;
 		};
 	};
_

Patches currently in -mm which might be from joshc@codeaurora.org are

rtc-pm8xxx-fixup-checkpatch-style-issues.patch
rtc-pm8xxx-use-regmap-api-for-register-accesses.patch
rtc-pm8xxx-use-devm_request_any_context_irq.patch
rtc-pm8xxx-add-support-for-devicetree.patch
rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch
linux-next.patch
mfd-devicetree-bindings-add-pm8xxx-rtc-description.patch

