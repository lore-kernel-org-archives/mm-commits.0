From: akpm@linux-foundation.org
Subject: [merged] documentation-add-missing-documentation-for-tps65217-bl-device-tree-binding.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:08 -0700
Message-ID: <20130430185308.7738431C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55793 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3D3SxJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:09 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so86478qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ujhelyi.m@gmail.com, grant.likely@secretlab.ca, matus.ujhelyi@streamunlimited.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: add missing documentation for tps65217-bl device tree binding
has been removed from the -mm tree.  Its filename was
     documentation-add-missing-documentation-for-tps65217-bl-device-tree-binding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

