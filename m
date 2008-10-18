From: akpm@linux-foundation.org
Subject: - rtc-at91rm9200-remove-now-unneeded-code.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:40 -0700
Message-ID: <200810182315.m9INFeUO028660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbYJRXP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avictor.za@gmail.com, a.zummo@towertech.it, david-b@pacbell.net, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     rtc-at91rm9200: remove now-unneeded code
has been removed from the -mm tree.  Its filename was
     rtc-at91rm9200-remove-now-unneeded-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-at91rm9200: remove now-unneeded code
From: "Andrew Victor" <avictor.za@gmail.com>

The non-functional periodic IRQ support was previously removed from the
AT91RM9200 RTC driver.  Remove the remaining AT91_RTC_FREQ definition.

Signed-off-by: Andrew Victor <linux@maxim.org.za>
Cc: David Brownell: <david-b@pacbell.net>
Cc: Alessandro Zummo: <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-remove-now-unneeded-code drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-remove-now-unneeded-code
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -29,10 +29,10 @@
 #include <linux/completion.h>
 
 #include <asm/uaccess.h>
+
 #include <mach/at91_rtc.h>
 
 
-#define AT91_RTC_FREQ		1
 #define AT91_RTC_EPOCH		1900UL	/* just like arch/arm/common/rtctime.c */
 
 static DECLARE_COMPLETION(at91_rtc_updated);
@@ -228,8 +228,6 @@ static int at91_rtc_proc(struct device *
 			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
 			(imr & AT91_RTC_SECEV) ? "yes" : "no");
-	seq_printf(seq, "periodic_freq\t: %ld\n",
-			(unsigned long) AT91_RTC_FREQ);
 
 	return 0;
 }
_

Patches currently in -mm which might be from avictor.za@gmail.com are

origin.patch

