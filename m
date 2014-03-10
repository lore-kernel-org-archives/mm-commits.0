From: akpm@linux-foundation.org
Subject: + documentation-bindings-document-pmic8921-8058-rtc.patch added
 to -mm tree
Date: Mon, 10 Mar 2014 13:48:08 -0700
Message-ID: <531e2508.NV7y6ytZjqTTmE1w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbaCJUsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: + documentation-bindings-document-pmic8921-8058-rtc.patch added to -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,sboyd@codeaurora.org
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:48:08 -0700


The patch titled
     Subject: documentation: bindings: document PMIC8921/8058 RTC
has been added to the -mm tree.  Its filename is
     documentation-bindings-document-pmic8921-8058-rtc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-bindings-document-pmic8921-8058-rtc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-bindings-document-pmic8921-8058-rtc.patch

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
Subject: documentation: bindings: document PMIC8921/8058 RTC

This RTC is found on the Qualcomm 8921 and 8058 PMICs.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt |   21 ++++++++++
 1 file changed, 21 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
@@ -0,0 +1,21 @@
+* Real-Time Clock for Qualcomm 8058/8921 PMICs
+
+Required properties:
+- compatible: should be one of the following.
+    * "qcom,pm8058-rtc"
+    * "qcom,pm8921-rtc"
+- reg: base address of the register region
+- interrupts: interrupt list for the RTC, must contain a single interrupt
+              specifier for the alarm interrupt
+
+Optional properties:
+- allow-set-time: indicates that the setting of RTC time is allowed by
+                  the host CPU
+
+Example:
+
+	rtc@11d {
+		compatible = "qcom,pm8921-rtc";
+		reg = <0x11d>;
+		interrupts = <0x27 0>;
+	};
_

Patches currently in -mm which might be from joshc@codeaurora.org are

rtc-pm8xxx-fixup-checkpatch-style-issues.patch
rtc-pm8xxx-use-regmap-api-for-register-accesses.patch
rtc-pm8xxx-use-devm_request_any_context_irq.patch
rtc-pm8xxx-add-support-for-devicetree.patch
rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch
documentation-bindings-document-pmic8921-8058-rtc.patch
linux-next.patch

