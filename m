From: akpm@linux-foundation.org
Subject: + rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch added to -mm
 tree
Date: Wed, 29 May 2013 13:34:03 -0700
Message-ID: <51a6663b.WjxupvlkGwLFe16j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966925Ab3E2UeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 16:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, ludovic.desroches@atmel.com, dgilbert@interlog.com, Robert.Nelson@digikey.com, jhovold@gmail.com

Subject: + rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch added to -mm tree
To: jhovold@gmail.com,Robert.Nelson@digikey.com,dgilbert@interlog.com,ludovic.desroches@atmel.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 13:34:03 -0700


The patch titled
     Subject: rtc-at91rm9200: use shadow IMR on at91sam9x5
has been added to the -mm tree.  Its filename is
     rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch

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
Subject: rtc-at91rm9200: use shadow IMR on at91sam9x5

Add support for the at91sam9x5-family which must use the shadow interrupt
mask due to a hardware issue (causing RTC_IMR to always be zero).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Robert Nelson <Robert.Nelson@digikey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/atmel,at91rm9200-rtc.txt |    2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                              |    2 +-
 drivers/rtc/rtc-at91rm9200.c                                   |    7 +++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

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
diff -puN arch/arm/boot/dts/at91sam9x5.dtsi~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5 arch/arm/boot/dts/at91sam9x5.dtsi
--- a/arch/arm/boot/dts/at91sam9x5.dtsi~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5
+++ a/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -646,7 +646,7 @@
 			};
 
 			rtc@fffffeb0 {
-				compatible = "atmel,at91rm9200-rtc";
+				compatible = "atmel,at91sam9x5-rtc";
 				reg = <0xfffffeb0 0x40>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
 				status = "disabled";
diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5 drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-use-shadow-imr-on-at91sam9x5
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -308,12 +308,19 @@ static irqreturn_t at91_rtc_interrupt(in
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

rtc-at91rm9200-add-match-table-compile-guard.patch
rtc-at91rm9200-add-configuration-support.patch
rtc-at91rm9200-refactor-interrupt-register-handling.patch
rtc-at91rm9200-add-shadow-interrupt-mask.patch
rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch

