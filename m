From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2.patch removed from
 -mm tree
Date: Fri, 06 Jun 2014 14:04:10 -0700
Message-ID: <53922cca.NUVFW1pU0FTddnst%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFVEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux@maxim.org.za, bevenson@melinkcorp.com, a.zummo@towertech.it, boris.brezillon@free-electrons.com

Subject: [folded-merged] rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2.patch removed from -mm tree
To: boris.brezillon@free-electrons.com,a.zummo@towertech.it,bevenson@melinkcorp.com,linux@maxim.org.za,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:04:10 -0700


The patch titled
     Subject: rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2.patch

This patch was dropped because it was folded into rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch

------------------------------------------------------
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2

Changes since v1:
- disable SECEV interrupt when the RTC is ready to accept new time updates

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2 drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq-v2
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -48,13 +48,12 @@ struct at91_rtc_config {
 
 static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
-static DECLARE_COMPLETION(at91_rtc_wait_upd_rdy);
+static DECLARE_COMPLETION(at91_rtc_upd_rdy);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
 static DEFINE_SPINLOCK(at91_rtc_lock);
 static u32 at91_rtc_shadow_imr;
-static bool at91_rtc_upd_rdy;
 
 static void at91_rtc_write_ier(u32 mask)
 {
@@ -163,7 +162,7 @@ static int at91_rtc_settime(struct devic
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
-	wait_for_completion(&at91_rtc_wait_upd_rdy);
+	wait_for_completion(&at91_rtc_upd_rdy);
 
 	/* Stop Time/Calendar from counting */
 	cr = at91_rtc_read(AT91_RTC_CR);
@@ -187,8 +186,9 @@ static int at91_rtc_settime(struct devic
 
 	/* Restart Time/Calendar */
 	cr = at91_rtc_read(AT91_RTC_CR);
-	at91_rtc_upd_rdy = 0;
+	at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
 	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL | AT91_RTC_UPDTIM));
+	at91_rtc_write_ier(AT91_RTC_SECEV);
 
 	return 0;
 }
@@ -296,11 +296,8 @@ static irqreturn_t at91_rtc_interrupt(in
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
 		if (rtsr & AT91_RTC_SECEV) {
-			events |= (RTC_UF | RTC_IRQF);
-			if (!at91_rtc_upd_rdy) {
-				at91_rtc_upd_rdy = 1;
-				complete(&at91_rtc_wait_upd_rdy);
-			}
+			complete(&at91_rtc_upd_rdy);
+			at91_rtc_write_idr(AT91_RTC_SECEV);
 		}
 		if (rtsr & AT91_RTC_ACKUPD)
 			complete(&at91_rtc_updated);
@@ -423,8 +420,11 @@ static int __init at91_rtc_probe(struct
 		return PTR_ERR(rtc);
 	platform_set_drvdata(pdev, rtc);
 
-	/* Enable 1Hz events */
+	/* enable SECEV interrupt in order to initialize at91_rtc_upd_rdy
+	 * completion.
+	 */
 	at91_rtc_write_ier(AT91_RTC_SECEV);
+
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
_

Patches currently in -mm which might be from boris.brezillon@free-electrons.com are

origin.patch
rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch
arm-at91-fix-rtc-irq-mask-for-sam9x5-socs.patch

