From: akpm@linux-foundation.org
Subject: + rtc-at91rm9200-add-shadow-interrupt-mask.patch added to -mm
 tree
Date: Wed, 29 May 2013 13:34:02 -0700
Message-ID: <51a6663a.CYsuQZNLWetW9M0S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966857Ab3E2UeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 16:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, ludovic.desroches@atmel.com, dgilbert@interlog.com, Robert.Nelson@digikey.com, jhovold@gmail.com

Subject: + rtc-at91rm9200-add-shadow-interrupt-mask.patch added to -mm tree
To: jhovold@gmail.com,Robert.Nelson@digikey.com,dgilbert@interlog.com,ludovic.desroches@atmel.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 13:34:02 -0700


The patch titled
     Subject: rtc-at91rm9200: add shadow interrupt mask
has been added to the -mm tree.  Its filename is
     rtc-at91rm9200-add-shadow-interrupt-mask.patch

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
Subject: rtc-at91rm9200: add shadow interrupt mask

Add shadow interrupt-mask register which can be used on SoCs where the
actual hardware register is broken.

Note that some care needs to be taken to make sure the shadow mask
corresponds to the actual hardware state.  The added overhead is not an
issue for the non-broken SoCs due to the relatively infrequent
interrupt-mask updates.  We do, however, only use the shadow mask value as
a fall-back when it actually needed as there is still a theoretical
possibility that the mask is incorrect (see the code for details).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Robert Nelson <Robert.Nelson@digikey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   39 ++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-add-shadow-interrupt-mask drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-add-shadow-interrupt-mask
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -25,6 +25,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/ioctl.h>
 #include <linux/completion.h>
 #include <linux/io.h>
@@ -42,6 +43,7 @@
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
 struct at91_rtc_config {
+	bool use_shadow_imr;
 };
 
 static const struct at91_rtc_config *at91_rtc_config;
@@ -49,20 +51,55 @@ static DECLARE_COMPLETION(at91_rtc_updat
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
+static DEFINE_SPINLOCK(at91_rtc_lock);
+static u32 at91_rtc_shadow_imr;
 
 static void at91_rtc_write_ier(u32 mask)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&at91_rtc_lock, flags);
+	at91_rtc_shadow_imr |= mask;
 	at91_rtc_write(AT91_RTC_IER, mask);
+	spin_unlock_irqrestore(&at91_rtc_lock, flags);
 }
 
 static void at91_rtc_write_idr(u32 mask)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&at91_rtc_lock, flags);
 	at91_rtc_write(AT91_RTC_IDR, mask);
+	/*
+	 * Register read back (of any RTC-register) needed to make sure
+	 * IDR-register write has reached the peripheral before updating
+	 * shadow mask.
+	 *
+	 * Note that there is still a possibility that the mask is updated
+	 * before interrupts have actually been disabled in hardware. The only
+	 * way to be certain would be to poll the IMR-register, which is is
+	 * the very register we are trying to emulate. The register read back
+	 * is a reasonable heuristic.
+	 */
+	at91_rtc_read(AT91_RTC_SR);
+	at91_rtc_shadow_imr &= ~mask;
+	spin_unlock_irqrestore(&at91_rtc_lock, flags);
 }
 
 static u32 at91_rtc_read_imr(void)
 {
-	return at91_rtc_read(AT91_RTC_IMR);
+	unsigned long flags;
+	u32 mask;
+
+	if (at91_rtc_config->use_shadow_imr) {
+		spin_lock_irqsave(&at91_rtc_lock, flags);
+		mask = at91_rtc_shadow_imr;
+		spin_unlock_irqrestore(&at91_rtc_lock, flags);
+	} else {
+		mask = at91_rtc_read(AT91_RTC_IMR);
+	}
+
+	return mask;
 }
 
 /*
_

Patches currently in -mm which might be from jhovold@gmail.com are

rtc-at91rm9200-add-match-table-compile-guard.patch
rtc-at91rm9200-add-configuration-support.patch
rtc-at91rm9200-refactor-interrupt-register-handling.patch
rtc-at91rm9200-add-shadow-interrupt-mask.patch
rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch

