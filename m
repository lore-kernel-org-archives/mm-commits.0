From: akpm@linux-foundation.org
Subject: + rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch added to -mm tree
Date: Mon, 23 Aug 2010 12:15:40 -0700
Message-ID: <201008231915.o7NJFepZ009664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343Ab0HWTQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 15:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it


The patch titled
     rtc-bfin: shrink/optimize interrupt handler a bit
has been added to the -mm tree.  Its filename is
     rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-bfin: shrink/optimize interrupt handler a bit
From: Mike Frysinger <vapier@gentoo.org>

By unifying the RTC_ISTAT clearing steps, we shrink the interrupt handler
and avoid multiple writes to the hardware registers.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~rtc-bfin-shrink-optimize-interrupt-handler-a-bit drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-bfin-shrink-optimize-interrupt-handler-a-bit
+++ a/drivers/rtc/rtc-bfin.c
@@ -183,29 +183,33 @@ static irqreturn_t bfin_rtc_interrupt(in
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
 	unsigned long events = 0;
 	bool write_complete = false;
-	u16 rtc_istat, rtc_ictl;
+	u16 rtc_istat, rtc_istat_clear, rtc_ictl, bits;
 
 	dev_dbg_stamp(dev);
 
 	rtc_istat = bfin_read_RTC_ISTAT();
 	rtc_ictl = bfin_read_RTC_ICTL();
+	rtc_istat_clear = 0;
 
-	if (rtc_istat & RTC_ISTAT_WRITE_COMPLETE) {
-		bfin_write_RTC_ISTAT(RTC_ISTAT_WRITE_COMPLETE);
+	bits = RTC_ISTAT_WRITE_COMPLETE;
+	if (rtc_istat & bits) {
+		rtc_istat_clear |= bits;
 		write_complete = true;
 		complete(&bfin_write_complete);
 	}
 
-	if (rtc_ictl & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY)) {
-		if (rtc_istat & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY)) {
-			bfin_write_RTC_ISTAT(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY);
+	bits = (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY);
+	if (rtc_ictl & bits) {
+		if (rtc_istat & bits) {
+			rtc_istat_clear |= bits;
 			events |= RTC_AF | RTC_IRQF;
 		}
 	}
 
-	if (rtc_ictl & RTC_ISTAT_SEC) {
-		if (rtc_istat & RTC_ISTAT_SEC) {
-			bfin_write_RTC_ISTAT(RTC_ISTAT_SEC);
+	bits = RTC_ISTAT_SEC;
+	if (rtc_ictl & bits) {
+		if (rtc_istat & bits) {
+			rtc_istat_clear |= bits;
 			events |= RTC_UF | RTC_IRQF;
 		}
 	}
@@ -213,9 +217,10 @@ static irqreturn_t bfin_rtc_interrupt(in
 	if (events)
 		rtc_update_irq(rtc->rtc_dev, 1, events);
 
-	if (write_complete || events)
+	if (write_complete || events) {
+		bfin_write_RTC_ISTAT(rtc_istat_clear);
 		return IRQ_HANDLED;
-	else
+	} else
 		return IRQ_NONE;
 }
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

rtc-bfin-fix-inverted-logic-in-suspend-path.patch
rtc-bfin-fix-state-restoration-when-resuming.patch
linux-next.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch
rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch
rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch

