From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-lpc32xxc-add-device-tree-support.patch added to -mm tree
Date: Wed, 09 May 2012 16:13:54 -0700
Message-ID: <20120509231354.AD00DA0333@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:52235 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab2EIXN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2012 19:13:56 -0400
Received: by qabg24 with SMTP id g24so136070qab.1
        for <mm-commits@vger.kernel.org>; Wed, 09 May 2012 16:13:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stigge@antcom.de, a.zummo@towertech.it, arnd@arndb.de, rob.herring@calxeda.com


The patch titled
     Subject: drivers/rtc/rtc-lpc32xx.c: add device tree support
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-lpc32xxc-add-device-tree-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roland Stigge <stigge@antcom.de>
Subject: drivers/rtc/rtc-lpc32xx.c: add device tree support

Adds device tree support for rtc-lpc32xx.c

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt |   15 ++++++++++
 drivers/rtc/rtc-lpc32xx.c                             |   12 +++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/lpc32xx-rtc.txt
@@ -0,0 +1,15 @@
+* NXP LPC32xx SoC Real Time Clock controller
+
+Required properties:
+- compatible: must be "nxp,lpc3220-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The RTC interrupt
+
+Example:
+
+	rtc@40024000 {
+		compatible = "nxp,lpc3220-rtc";
+		reg = <0x40024000 0x1000>;
+		interrupts = <52 0>;
+	};
diff -puN drivers/rtc/rtc-lpc32xx.c~drivers-rtc-rtc-lpc32xxc-add-device-tree-support drivers/rtc/rtc-lpc32xx.c
--- a/drivers/rtc/rtc-lpc32xx.c~drivers-rtc-rtc-lpc32xxc-add-device-tree-support
+++ a/drivers/rtc/rtc-lpc32xx.c
@@ -19,6 +19,7 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 /*
  * Clock and Power control register offsets
@@ -386,13 +387,22 @@ static const struct dev_pm_ops lpc32xx_r
 #define LPC32XX_RTC_PM_OPS NULL
 #endif
 
+#ifdef CONFIG_OF
+static const struct of_device_id lpc32xx_rtc_match[] = {
+	{ .compatible = "nxp,lpc3220-rtc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_rtc_match);
+#endif
+
 static struct platform_driver lpc32xx_rtc_driver = {
 	.probe		= lpc32xx_rtc_probe,
 	.remove		= __devexit_p(lpc32xx_rtc_remove),
 	.driver = {
 		.name	= RTC_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= LPC32XX_RTC_PM_OPS
+		.pm	= LPC32XX_RTC_PM_OPS,
+		.of_match_table = of_match_ptr(lpc32xx_rtc_match),
 	},
 };
 
_
Subject: Subject: drivers/rtc/rtc-lpc32xx.c: add device tree support

Patches currently in -mm which might be from stigge@antcom.de are

linux-next.patch
drivers-rtc-rtc-lpc32xxc-add-device-tree-support.patch

