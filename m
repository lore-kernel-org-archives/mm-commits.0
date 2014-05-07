From: akpm@linux-foundation.org
Subject: + rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch added to -mm tree
Date: Wed, 07 May 2014 14:58:29 -0700
Message-ID: <536aac85.lEpDng3bbwRJxhED%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaEGV6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 17:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux@maxim.org.za, bevenson@melinkcorp.com, a.zummo@towertech.it, boris.brezillon@free-electrons.com

Subject: + rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch added to -mm tree
To: boris.brezillon@free-electrons.com,a.zummo@towertech.it,bevenson@melinkcorp.com,linux@maxim.org.za,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 14:58:29 -0700


The patch titled
     Subject: rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
has been added to the -mm tree.  Its filename is
     rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq

The rtc user must wait at least 1 sec between each time/calandar update
(see atmel's datasheet chapter "Updating Time/Calendar").

Use the 1Hz interrupt to update the at91_rtc_upd_rdy flag and wait for the
at91_rtc_wait_upd_rdy event if the rtc is not ready.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
Tested-by: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -48,11 +48,13 @@ struct at91_rtc_config {
 
 static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
+static DECLARE_COMPLETION(at91_rtc_wait_upd_rdy);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
 static DEFINE_SPINLOCK(at91_rtc_lock);
 static u32 at91_rtc_shadow_imr;
+static bool at91_rtc_upd_rdy;
 
 static void at91_rtc_write_ier(u32 mask)
 {
@@ -161,6 +163,8 @@ static int at91_rtc_settime(struct devic
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
+	wait_for_completion(&at91_rtc_wait_upd_rdy);
+
 	/* Stop Time/Calendar from counting */
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
@@ -183,6 +187,7 @@ static int at91_rtc_settime(struct devic
 
 	/* Restart Time/Calendar */
 	cr = at91_rtc_read(AT91_RTC_CR);
+	at91_rtc_upd_rdy = 0;
 	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL | AT91_RTC_UPDTIM));
 
 	return 0;
@@ -290,8 +295,13 @@ static irqreturn_t at91_rtc_interrupt(in
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
-		if (rtsr & AT91_RTC_SECEV)
+		if (rtsr & AT91_RTC_SECEV) {
 			events |= (RTC_UF | RTC_IRQF);
+			if (!at91_rtc_upd_rdy) {
+				at91_rtc_upd_rdy = 1;
+				complete(&at91_rtc_wait_upd_rdy);
+			}
+		}
 		if (rtsr & AT91_RTC_ACKUPD)
 			complete(&at91_rtc_updated);
 
@@ -413,6 +423,8 @@ static int __init at91_rtc_probe(struct
 		return PTR_ERR(rtc);
 	platform_set_drvdata(pdev, rtc);
 
+	/* Enable 1Hz events */
+	at91_rtc_write_ier(AT91_RTC_SECEV);
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
_

Patches currently in -mm which might be from boris.brezillon@free-electrons.com are

rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch
linux-next.patch

