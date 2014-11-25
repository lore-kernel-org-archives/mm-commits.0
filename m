From: akpm@linux-foundation.org
Subject: + rtc-ds1307-add-device-tree-bindings-documentation.patch added
 to -mm tree
Date: Mon, 24 Nov 2014 22:42:51 -0800
Message-ID: <547424eb.oFVEs5X/aFnwysbd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaKYGm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 01:42:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomas@novotny.cz, a.zummo@towertech.it, grant.likely@linaro.org, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: add device tree bindings documentation
has been added to the -mm tree.  Its filename is
     rtc-ds1307-add-device-tree-bindings-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1307-add-device-tree-bindings-documentation.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1307-add-device-tree-bindings-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomas Novotny <tomas@novotny.cz>
Subject: rtc: ds1307: add device tree bindings documentation

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/maxim,ds1307.txt |   23 ++++++++++
 1 file changed, 23 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/maxim,ds1307.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/maxim,ds1307.txt
@@ -0,0 +1,23 @@
+* Maxim (Dallas) DS1307 and compatible Real Time Clock
+
+For example, compatible chips are Maxim DS1337, Microchip MCP794xx,
+STMicroelectronics M41T00 and Epson RX-8025.
+
+Required properties:
+- compatible: For example "maxim,ds1307" (see rtc-ds1307.c driver for a full
+  list).
+- reg: i2c address
+
+Example for DS1307:
+
+ds1307: rtc@68 {
+	compatible = "maxim,ds1307";
+	reg = <0x68>;
+};
+
+Example for MCP79401:
+
+mcp7940x: rtc@6f {
+	compatible = "microchip,mcp7940x";
+	reg = <0x6f>;
+};
_

Patches currently in -mm which might be from tomas@novotny.cz are

rtc-ds1307-add-support-for-mcp7940x-chips.patch
of-add-vendor-prefix-for-pericom-technology.patch
rtc-ds1307-add-device-tree-bindings-documentation.patch
rtc-ds1307-add-device-tree-support.patch

