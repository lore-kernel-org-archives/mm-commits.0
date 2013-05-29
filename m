From: akpm@linux-foundation.org
Subject: + rtc-at91rm9200-add-configuration-support.patch added to -mm
 tree
Date: Wed, 29 May 2013 13:34:00 -0700
Message-ID: <51a66638.bZUWaPmQrz+8nCiM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966915Ab3E2UeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 16:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, ludovic.desroches@atmel.com, dgilbert@interlog.com, Robert.Nelson@digikey.com, jhovold@gmail.com

Subject: + rtc-at91rm9200-add-configuration-support.patch added to -mm tree
To: jhovold@gmail.com,Robert.Nelson@digikey.com,dgilbert@interlog.com,ludovic.desroches@atmel.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 13:34:00 -0700


The patch titled
     Subject: rtc-at91rm9200: add configuration support
has been added to the -mm tree.  Its filename is
     rtc-at91rm9200-add-configuration-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: rtc-at91rm9200: add configuration support

Add configuration support which can be used to implement SoC-specific
workarounds for broken hardware.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Robert Nelson <Robert.Nelson@digikey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   46 +++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-add-configuration-support drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-add-configuration-support
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -41,6 +41,10 @@
 
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
+struct at91_rtc_config {
+};
+
+static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
@@ -249,6 +253,36 @@ static irqreturn_t at91_rtc_interrupt(in
 	return IRQ_NONE;		/* not handled */
 }
 
+static const struct at91_rtc_config at91rm9200_config = {
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id at91_rtc_dt_ids[] = {
+	{
+		.compatible = "atmel,at91rm9200-rtc",
+		.data = &at91rm9200_config,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
+#endif
+
+static const struct at91_rtc_config *
+at91_rtc_get_config(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	if (pdev->dev.of_node) {
+		match = of_match_node(at91_rtc_dt_ids, pdev->dev.of_node);
+		if (!match)
+			return NULL;
+		return (const struct at91_rtc_config *)match->data;
+	}
+
+	return &at91rm9200_config;
+}
+
 static const struct rtc_class_ops at91_rtc_ops = {
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
@@ -267,6 +301,10 @@ static int __init at91_rtc_probe(struct
 	struct resource *regs;
 	int ret = 0;
 
+	at91_rtc_config = at91_rtc_get_config(pdev);
+	if (!at91_rtc_config)
+		return -ENODEV;
+
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
 		dev_err(&pdev->dev, "no mmio resource defined\n");
@@ -381,14 +419,6 @@ static int at91_rtc_resume(struct device
 
 static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
 
-#ifdef CONFIG_OF
-static const struct of_device_id at91_rtc_dt_ids[] = {
-	{ .compatible = "atmel,at91rm9200-rtc" },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
-#endif
