From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-at91rm9200c-add-dt-support.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:00 -0700
Message-ID: <20130430185900.6705531C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:57308 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933035Ab3D3S7C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:02 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86884yha.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manabian@gmail.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: add DT support
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-at91rm9200c-add-dt-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joachim Eastwood <manabian@gmail.com>
Subject: drivers/rtc/rtc-at91rm9200.c: add DT support

Signed-off-by: Joachim Eastwood <manabian@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt |   15 ++++++++++
 drivers/rtc/rtc-at91rm9200.c                                   |    9 ++++++
 2 files changed, 24 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
@@ -0,0 +1,15 @@
+Atmel AT91RM9200 Real Time Clock
+
+Required properties:
+- compatible: should be: "atmel,at91rm9200-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: rtc alarm/event interrupt
+
+Example:
+
+rtc@fffffe00 {
+	compatible = "atmel,at91rm9200-rtc";
+	reg = <0xfffffe00 0x100>;
+	interrupts = <1 4 7>;
+};
diff -puN drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-add-dt-support drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~drivers-rtc-rtc-at91rm9200c-add-dt-support
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -28,6 +28,8 @@
 #include <linux/ioctl.h>
 #include <linux/completion.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <asm/uaccess.h>
 
@@ -373,12 +375,19 @@ static int at91_rtc_resume(struct device
 
 static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
 
+static const struct of_device_id at91_rtc_dt_ids[] = {
+	{ .compatible = "atmel,at91rm9200-rtc" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
+
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
 		.pm	= &at91_rtc_pm_ops,
+		.of_match_table = of_match_ptr(at91_rtc_dt_ids),
 	},
 };
 
_

Patches currently in -mm which might be from manabian@gmail.com are

origin.patch
linux-next.patch

