From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:33 -0700
Message-ID: <20120326193133.631FFA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38526 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2CZTbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:35 -0400
Received: by vbnl22 with SMTP id l22so508386vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl.c: return correct RTC event from ISR
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

origin.patch
linux-next.patch

