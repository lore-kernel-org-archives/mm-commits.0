From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-lpc32xxc-add-device-tree-support.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:38 -0700
Message-ID: <20120531192038.5602FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60590 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab2EaTUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:40 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so86026lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stigge@antcom.de, a.zummo@towertech.it, arnd@arndb.de, rob.herring@calxeda.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-lpc32xx.c: add device tree support
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-lpc32xxc-add-device-tree-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from stigge@antcom.de are

origin.patch
linux-next.patch

