From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-at91rm9200c-add-dt-support.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:56:58 -0700
Message-ID: <20130327205658.6B5AA5A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:36936 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3C0U47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:56:59 -0400
Received: by mail-ye0-f202.google.com with SMTP id l8so350055yen.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:56:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manabian@gmail.com, nicolas.ferre@atmel.com


The patch titled
     Subject: drivers/rtc/rtc-at91rm9200.c: add DT support
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-at91rm9200c-add-dt-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 
@@ -385,12 +387,19 @@ static int at91_rtc_resume(struct device
 
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

linux-next.patch
drivers-rtc-rtc-at91rm9200c-add-dt-support.patch

