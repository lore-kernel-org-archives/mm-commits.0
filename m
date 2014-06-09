From: akpm@linux-foundation.org
Subject: [merged]
 rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:30:37 -0700
Message-ID: <53960b5d.QeJ8MvHo5/WR0MID%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaFITai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:30:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux@maxim.org.za, bevenson@melinkcorp.com, a.zummo@towertech.it, boris.brezillon@free-electrons.com

Subject: [merged] rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch removed from -mm tree
To: boris.brezillon@free-electrons.com,a.zummo@towertech.it,bevenson@melinkcorp.com,linux@maxim.org.za,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:30:37 -0700


The patch titled
     Subject: rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq

The rtc user must wait at least 1 sec between each time/calandar update
(see atmel's datasheet chapter "Updating Time/Calendar").

Use the 1Hz interrupt to update the at91_rtc_upd_rdy flag and wait for the
at91_rtc_wait_upd_rdy event if the rtc is not ready.

This patch fixes a deadlock in an uninterruptible wait when the RTC is
updated more than once every second.  AFAICT the bug is here from the
beginning, but I think we should at least backport this fix to 3.10 and
the following longterm and stable releases.

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

 drivers/rtc/rtc-at91rm9200.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-fix-infinite-wait-for-ackupd-irq
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -48,6 +48,7 @@ struct at91_rtc_config {
 
 static const struct at91_rtc_config *at91_rtc_config;
 static DECLARE_COMPLETION(at91_rtc_updated);
+static DECLARE_COMPLETION(at91_rtc_upd_rdy);
 static unsigned int at91_alarm_year = AT91_RTC_EPOCH;
 static void __iomem *at91_rtc_regs;
 static int irq;
@@ -161,6 +162,8 @@ static int at91_rtc_settime(struct devic
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
+	wait_for_completion(&at91_rtc_upd_rdy);
+
 	/* Stop Time/Calendar from counting */
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
@@ -183,7 +186,9 @@ static int at91_rtc_settime(struct devic
 
 	/* Restart Time/Calendar */
 	cr = at91_rtc_read(AT91_RTC_CR);
+	at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
 	at91_rtc_write(AT91_RTC_CR, cr & ~(AT91_RTC_UPDCAL | AT91_RTC_UPDTIM));
+	at91_rtc_write_ier(AT91_RTC_SECEV);
 
 	return 0;
 }
@@ -290,8 +295,10 @@ static irqreturn_t at91_rtc_interrupt(in
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
-		if (rtsr & AT91_RTC_SECEV)
-			events |= (RTC_UF | RTC_IRQF);
+		if (rtsr & AT91_RTC_SECEV) {
+			complete(&at91_rtc_upd_rdy);
+			at91_rtc_write_idr(AT91_RTC_SECEV);
+		}
 		if (rtsr & AT91_RTC_ACKUPD)
 			complete(&at91_rtc_updated);
 
@@ -413,6 +420,11 @@ static int __init at91_rtc_probe(struct
 		return PTR_ERR(rtc);
 	platform_set_drvdata(pdev, rtc);
 
+	/* enable SECEV interrupt in order to initialize at91_rtc_upd_rdy
+	 * completion.
+	 */
+	at91_rtc_write_ier(AT91_RTC_SECEV);
+
 	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
_

Patches currently in -mm which might be from boris.brezillon@free-electrons.com are

origin.patch
linux-next.patch

