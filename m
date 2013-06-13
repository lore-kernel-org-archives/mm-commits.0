From: akpm@linux-foundation.org
Subject: [merged] rtc-at91rm9200-add-match-table-compile-guard.patch
 removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:48 -0700
Message-ID: <51ba162c.UsuDVyr+CzqO6yr1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, ludovic.desroches@atmel.com, dgilbert@interlog.com, Robert.Nelson@digikey.com, jhovold@gmail.com

Subject: [merged] rtc-at91rm9200-add-match-table-compile-guard.patch removed from -mm tree
To: jhovold@gmail.com,Robert.Nelson@digikey.com,dgilbert@interlog.com,ludovic.desroches@atmel.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:48 -0700


The patch titled
     Subject: rtc-at91rm9200: add match-table compile guard
has been removed from the -mm tree.  Its filename was
     rtc-at91rm9200-add-match-table-compile-guard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: rtc-at91rm9200: add match-table compile guard

The members of Atmel's at91sam9x5 family (9x5) have a broken RTC interrupt
mask register (AT91_RTC_IMR).  It does not reflect enabled interrupts but
instead always returns zero.

The kernel's rtc-at91rm9200 driver handles the RTC for the 9x5 family. 
Currently when the date/time is set, an interrupt is generated and this
driver neglects to handle the interrupt.  The kernel complains about the
un-handled interrupt and disables it henceforth.  This not only breaks the
RTC function, but since that interrupt is shared (Atmel's SYS interrupt)
then other things break as well (e.g.  the debug port no longer accepts
characters).

Tested on the at91sam9g25. Bug confirmed by Atmel.


This patch (of 5):

Add missing match-table compile guard.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
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
@@ -383,11 +383,13 @@ static int at91_rtc_resume(struct device
 
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

origin.patch
linux-next.patch

