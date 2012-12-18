From: akpm@linux-foundation.org
Subject: [merged] rtc-imxdi-add-devicetree-support.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:41 -0800
Message-ID: <20121218200741.AB77F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:48075 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2LRUHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:42 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125794yen.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stigge@antcom.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk, shawn.guo@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: add devicetree support
has been removed from the -mm tree.  Its filename was
     rtc-imxdi-add-devicetree-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roland Stigge <stigge@antcom.de>
Subject: drivers/rtc/rtc-imxdi.c: add devicetree support

Add device tree support to the rtc-imxdi driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/imxdi-rtc.txt |   17 ++++++++++
 drivers/rtc/rtc-imxdi.c                             |   11 ++++++
 2 files changed, 28 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/imxdi-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/imxdi-rtc.txt
@@ -0,0 +1,17 @@
+* i.MX25 Real Time Clock controller
+
+This binding supports the following chips: i.MX25, i.MX53
+
+Required properties:
+- compatible: should be: "fsl,imx25-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: rtc alarm interrupt
+
+Example:
+
+rtc@80056000 {
+	compatible = "fsl,imx53-rtc", "fsl,imx25-rtc";
+	reg = <0x80056000 2000>;
+	interrupts = <29>;
+};
diff -puN drivers/rtc/rtc-imxdi.c~rtc-imxdi-add-devicetree-support drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-imxdi-add-devicetree-support
+++ a/drivers/rtc/rtc-imxdi.c
@@ -37,6 +37,7 @@
 #include <linux/rtc.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/of.h>
 
 /* DryIce Register Definitions */
 
@@ -495,10 +496,20 @@ static int __devexit dryice_rtc_remove(s
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id dryice_dt_ids[] = {
+	{ .compatible = "fsl,imx25-rtc" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, dryice_dt_ids);
+#endif
+
 static struct platform_driver dryice_rtc_driver = {
 	.driver = {
 		   .name = "imxdi_rtc",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(dryice_dt_ids),
 		   },
 	.remove = __devexit_p(dryice_rtc_remove),
 };
_

Patches currently in -mm which might be from stigge@antcom.de are

origin.patch
linux-next.patch

