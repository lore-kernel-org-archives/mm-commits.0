From: akpm@linux-foundation.org
Subject: [merged] rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch
 removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:56 -0700
Message-ID: <51ba1634.ufhOWqNIWT5EjzSo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, ludovic.desroches@atmel.com, dgilbert@interlog.com, Robert.Nelson@digikey.com, jhovold@gmail.com

Subject: [merged] rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch removed from -mm tree
To: jhovold@gmail.com,Robert.Nelson@digikey.com,dgilbert@interlog.com,ludovic.desroches@atmel.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:56 -0700


The patch titled
     Subject: rtc-at91rm9200: use shadow IMR on at91sam9x5
has been removed from the -mm tree.  Its filename was
     rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: rtc-at91rm9200: use shadow IMR on at91sam9x5

Add support for the at91sam9x5-family which must use the shadow interrupt
mask due to a hardware issue (causing RTC_IMR to always be zero).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Robert Nelson <Robert.Nelson@digikey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt |    2 +-
 drivers/rtc/rtc-at91rm9200.c                                   |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5 Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
--- a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5
+++ a/Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt
@@ -1,7 +1,7 @@
 Atmel AT91RM9200 Real Time Clock
 
 Required properties:
-- compatible: should be: "atmel,at91rm9200-rtc"
+- compatible: should be: "atmel,at91rm9200-rtc" or "atmel,at91sam9x5-rtc"
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: rtc alarm/event interrupt
diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5 drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -309,12 +309,19 @@ static irqreturn_t at91_rtc_interrupt(in
 static const struct at91_rtc_config at91rm9200_config = {
 };
 
+static const struct at91_rtc_config at91sam9x5_config = {
+	.use_shadow_imr	= true,
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id at91_rtc_dt_ids[] = {
 	{
 		.compatible = "atmel,at91rm9200-rtc",
 		.data = &at91rm9200_config,
 	}, {
+		.compatible = "atmel,at91sam9x5-rtc",
+		.data = &at91sam9x5_config,
+	}, {
 		/* sentinel */
 	}
 };
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
linux-next.patch

