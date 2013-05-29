From: akpm@linux-foundation.org
Subject: + rtc-at91rm9200-add-match-table-compile-guard.patch added to -mm tree
Date: Wed, 29 May 2013 13:33:59 -0700
Message-ID: <51a66637.f+bA804L/LEsvMG/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966913Ab3E2UeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 16:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, ludovic.desroches@atmel.com, dgilbert@interlog.com, Robert.Nelson@digikey.com, jhovold@gmail.com

Subject: + rtc-at91rm9200-add-match-table-compile-guard.patch added to -mm tree
To: jhovold@gmail.com,Robert.Nelson@digikey.com,dgilbert@interlog.com,ludovic.desroches@atmel.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 13:33:59 -0700


The patch titled
     Subject: rtc-at91rm9200: add match-table compile guard
has been added to the -mm tree.  Its filename is
     rtc-at91rm9200-add-match-table-compile-guard.patch

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
Subject: rtc-at91rm9200: add match-table compile guard

Add missing match-table compile guard.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Robert Nelson <Robert.Nelson@digikey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-add-match-table-compile-guard drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-add-match-table-compile-guard
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -381,11 +381,13 @@ static int at91_rtc_resume(struct device
 
 static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
 
+#ifdef CONFIG_OF
 static const struct of_device_id at91_rtc_dt_ids[] = {
 	{ .compatible = "atmel,at91rm9200-rtc" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, at91_rtc_dt_ids);
+#endif
 
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
_

Patches currently in -mm which might be from jhovold@gmail.com are

rtc-at91rm9200-add-match-table-compile-guard.patch
rtc-at91rm9200-add-configuration-support.patch
rtc-at91rm9200-refactor-interrupt-register-handling.patch
rtc-at91rm9200-add-shadow-interrupt-mask.patch
rtc-at91rm9200-use-shadow-imr-on-at91sam9x5.patch

