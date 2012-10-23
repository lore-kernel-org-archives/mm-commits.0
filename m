From: akpm@linux-foundation.org
Subject: + rtc-imxdi-add-devicetree-support.patch added to -mm tree
Date: Tue, 23 Oct 2012 11:59:50 -0700
Message-ID: <20121023185951.6CAC520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:54837 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab2JWS7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 14:59:54 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so252659lah.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 11:59:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stigge@antcom.de, a.zummo@towertech.it, grant.likely@secretlab.ca, kernel@pengutronix.de, linux@arm.linux.org.uk


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: add devicetree support
has been added to the -mm tree.  Its filename is
     rtc-imxdi-add-devicetree-support.patch

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
Subject: drivers/rtc/rtc-imxdi.c: add devicetree support

Add device tree support to the rtc-imxdi driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
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
 
@@ -493,10 +494,20 @@ static int __devexit dryice_rtc_remove(s
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

linux-next.patch
rtc-imxdi-support-for-imx53.patch
rtc-imxdi-add-devicetree-support.patch
arm-mach-imx-support-for-dryice-rtc-in-imx53.patch

