From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:41:56 -0800
Message-ID: <20120128004156.D8E7CA01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:56762 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2A1Al7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:41:59 -0500
Received: by wicr5 with SMTP id r5so53477wic.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:41:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vbyravarasu@nvidia.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-twl.c: return correct RTC event from ISR
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: drivers/rtc/rtc-twl.c: return correct RTC event from ISR

Following changes are made as part of this change:

1. As TWL RTC supports periodic interrupt, the correct event should be
   RTC_PF instead of RTC_UF.

2. No need to initialize variable "events" to 0 & then OR it with the
   event values.  Hence fixing it.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr
+++ a/drivers/rtc/rtc-twl.c
@@ -365,7 +365,7 @@ out:
 
 static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 {
-	unsigned long events = 0;
+	unsigned long events;
 	int ret = IRQ_NONE;
 	int res;
 	u8 rd_reg;
@@ -380,9 +380,9 @@ static irqreturn_t twl_rtc_interrupt(int
 	 * by reading RTS_INTERRUPTS_REGISTER[IT_TIMER,IT_ALARM]
 	 */
 	if (rd_reg & BIT_RTC_STATUS_REG_ALARM_M)
-		events |= RTC_IRQF | RTC_AF;
+		events = RTC_IRQF | RTC_AF;
 	else
-		events |= RTC_IRQF | RTC_UF;
+		events = RTC_IRQF | RTC_PF;
 
 	res = twl_rtc_write_u8(BIT_RTC_STATUS_REG_ALARM_M,
 				   REG_RTC_STATUS_REG);
_
Subject: Subject: drivers/rtc/rtc-twl.c: return correct RTC event from ISR

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

drivers-rtc-rtc-twlc-optimize-irq-bit-access.patch
drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state.patch
drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing.patch
drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr.patch

