From: akpm@linux-foundation.org
Subject: [merged]
 rtc-at91rm9200-refactor-interrupt-register-handling.patch removed from -mm
 tree
Date: Thu, 13 Jun 2013 11:57:52 -0700
Message-ID: <51ba1630.oe7ZPVPDZBaTlzOG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, ludovic.desroches@atmel.com, dgilbert@interlog.com, Robert.Nelson@digikey.com, jhovold@gmail.com

Subject: [merged] rtc-at91rm9200-refactor-interrupt-register-handling.patch removed from -mm tree
To: jhovold@gmail.com,Robert.Nelson@digikey.com,dgilbert@interlog.com,ludovic.desroches@atmel.com,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:52 -0700


The patch titled
     Subject: rtc-at91rm9200: refactor interrupt-register handling
has been removed from the -mm tree.  Its filename was
     rtc-at91rm9200-refactor-interrupt-register-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: rtc-at91rm9200: refactor interrupt-register handling

Add accessors for the interrupt register.

This will allow us to easily add a shadow interrupt-mask register to
use on SoCs where the interrupt-mask register cannot be used.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Robert Nelson <Robert.Nelson@digikey.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   43 ++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-refactor-interrupt-register-handling drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-refactor-interrupt-register-handling
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -51,6 +51,21 @@ static unsigned int at91_alarm_year = AT
 static void __iomem *at91_rtc_regs;
 static int irq;
 
+static void at91_rtc_write_ier(u32 mask)
+{
+	at91_rtc_write(AT91_RTC_IER, mask);
+}
+
+static void at91_rtc_write_idr(u32 mask)
+{
+	at91_rtc_write(AT91_RTC_IDR, mask);
+}
+
+static u32 at91_rtc_read_imr(void)
+{
+	return at91_rtc_read(AT91_RTC_IMR);
+}
+
 /*
  * Decode time/date into rtc_time structure
  */
@@ -114,9 +129,9 @@ static int at91_rtc_settime(struct devic
 	cr = at91_rtc_read(AT91_RTC_CR);
 	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL | AT91_RTC_UPDTIM);
 
-	at91_rtc_write(AT91_RTC_IER, AT91_RTC_ACKUPD);
+	at91_rtc_write_ier(AT91_RTC_ACKUPD);
 	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD interrupt */
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD);
+	at91_rtc_write_idr(AT91_RTC_ACKUPD);
 
 	at91_rtc_write(AT91_RTC_TIMR,
 			  bin2bcd(tm->tm_sec) << 0
@@ -148,7 +163,7 @@ static int at91_rtc_readalarm(struct dev
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
-	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
+	alrm->enabled = (at91_rtc_read_imr() & AT91_RTC_ALARM)
 			? 1 : 0;
 
 	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -173,7 +188,7 @@ static int at91_rtc_setalarm(struct devi
 	tm.tm_min = alrm->time.tm_min;
 	tm.tm_sec = alrm->time.tm_sec;
 
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
+	at91_rtc_write_idr(AT91_RTC_ALARM);
 	at91_rtc_write(AT91_RTC_TIMALR,
 		  bin2bcd(tm.tm_sec) << 0
 		| bin2bcd(tm.tm_min) << 8
@@ -186,7 +201,7 @@ static int at91_rtc_setalarm(struct devi
 
 	if (alrm->enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
+		at91_rtc_write_ier(AT91_RTC_ALARM);
 	}
 
 	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
@@ -202,9 +217,9 @@ static int at91_rtc_alarm_irq_enable(str
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
+		at91_rtc_write_ier(AT91_RTC_ALARM);
 	} else
-		at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ALARM);
+		at91_rtc_write_idr(AT91_RTC_ALARM);
 
 	return 0;
 }
@@ -213,7 +228,7 @@ static int at91_rtc_alarm_irq_enable(str
  */
 static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	unsigned long imr = at91_rtc_read(AT91_RTC_IMR);
+	unsigned long imr = at91_rtc_read_imr();
 
 	seq_printf(seq, "update_IRQ\t: %s\n",
 			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
@@ -233,7 +248,7 @@ static irqreturn_t at91_rtc_interrupt(in
 	unsigned int rtsr;
 	unsigned long events = 0;
 
-	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read(AT91_RTC_IMR);
+	rtsr = at91_rtc_read(AT91_RTC_SR) & at91_rtc_read_imr();
 	if (rtsr) {		/* this interrupt is shared!  Is it ours? */
 		if (rtsr & AT91_RTC_ALARM)
 			events |= (RTC_AF | RTC_IRQF);
@@ -328,7 +343,7 @@ static int __init at91_rtc_probe(struct
 	at91_rtc_write(AT91_RTC_MR, 0);		/* 24 hour mode */
 
 	/* Disable all interrupts */
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
+	at91_rtc_write_idr(AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
 
@@ -373,7 +388,7 @@ static int __exit at91_rtc_remove(struct
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
 	/* Disable all interrupts */
-	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
+	at91_rtc_write_idr(AT91_RTC_ACKUPD | AT91_RTC_ALARM |
 					AT91_RTC_SECEV | AT91_RTC_TIMEV |
 					AT91_RTC_CALEV);
 	free_irq(irq, pdev);
@@ -396,13 +411,13 @@ static int at91_rtc_suspend(struct devic
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
 	 */
-	at91_rtc_imr = at91_rtc_read(AT91_RTC_IMR)
+	at91_rtc_imr = at91_rtc_read_imr()
 			& (AT91_RTC_ALARM|AT91_RTC_SECEV);
 	if (at91_rtc_imr) {
 		if (device_may_wakeup(dev))
 			enable_irq_wake(irq);
 		else
-			at91_rtc_write(AT91_RTC_IDR, at91_rtc_imr);
+			at91_rtc_write_idr(at91_rtc_imr);
 	}
 	return 0;
 }
@@ -413,7 +428,7 @@ static int at91_rtc_resume(struct device
 		if (device_may_wakeup(dev))
 			disable_irq_wake(irq);
 		else
-			at91_rtc_write(AT91_RTC_IER, at91_rtc_imr);
+			at91_rtc_write_ier(at91_rtc_imr);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
linux-next.patch

