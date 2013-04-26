From: akpm@linux-foundation.org
Subject: + documentation-add-missing-documentation-for-tps65217-bl-device-tree-binding.patch added to -mm tree
Date: Fri, 26 Apr 2013 14:32:43 -0700
Message-ID: <20130426213243.C72D75A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:56921 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3DZVco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Apr 2013 17:32:44 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so481115ggm.3
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2013 14:32:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ujhelyi.m@gmail.com, grant.likely@secretlab.ca, matus.ujhelyi@streamunlimited.com


The patch titled
     Subject: Documentation: add missing documentation for tps65217-bl device tree binding
has been added to the -mm tree.  Its filename is
     documentation-add-missing-documentation-for-tps65217-bl-device-tree-binding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matus Ujhelyi <ujhelyi.m@gmail.com>
Subject: Documentation: add missing documentation for tps65217-bl device tree binding

Signed-off-by: Matus Ujhelyi <matus.ujhelyi@streamunlimited.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt |   25 ++++++++++
 1 file changed, 25 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
@@ -0,0 +1,25 @@
+TPS65217 family of regulators
+
+The TPS65217 chip contains a boost converter and current sinks which can be
+used to drive LEDs for use as backlights.
+
+Required properties:
+- compatible: "ti,tps65217"
+- reg: I2C slave address
+- backlight: node for specifying WLED1 and WLED2 lines in TPS65217
+- isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
+- fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
+
+Each regulator is defined using the standard binding for regulators.
+
+Example:
+
+	tps: tps@24 {
+		reg = <0x24>;
+		compatible = "ti,tps65217";
+		backlight {
+			isel = <1>;  /* 1 - ISET1, 2 ISET2 */
+			fdim = <100>; /* TPS65217_BL_FDIM_100HZ */
+		};
+	};
+
_

Patches currently in -mm which might be from ujhelyi.m@gmail.com are

documentation-add-missing-documentation-for-tps65217-bl-device-tree-binding.patch
drivers-video-backlight-tps65217_blc-add-default-brightness-value-option.patch

