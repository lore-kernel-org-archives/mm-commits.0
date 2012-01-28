From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing.patch added to -mm tree
Date: Fri, 27 Jan 2012 16:41:54 -0800
Message-ID: <20120128004154.D28CBA01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:65310 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2A1Al4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Jan 2012 19:41:56 -0500
Received: by eaaf1 with SMTP id f1so108974eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Jan 2012 16:41:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vbyravarasu@nvidia.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing.patch

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
Subject: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing

For clearing RTC interrupt, programming ALARM bit only is sufficient, as
all other bits are any way not affected by writing 0 to them.

Hence removed unwanted OR operation.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing
+++ a/drivers/rtc/rtc-twl.c
@@ -384,7 +384,7 @@ static irqreturn_t twl_rtc_interrupt(int
 	else
 		events |= RTC_IRQF | RTC_UF;
 
-	res = twl_rtc_write_u8(rd_reg | BIT_RTC_STATUS_REG_ALARM_M,
+	res = twl_rtc_write_u8(BIT_RTC_STATUS_REG_ALARM_M,
 				   REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
_
Subject: Subject: drivers/rtc/rtc-twl.c: simplify RTC interrupt clearing

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

drivers-rtc-rtc-twlc-optimize-irq-bit-access.patch
drivers-rtc-rtc-twlc-enable-rtc-irrespective-of-its-prior-state.patch
drivers-rtc-rtc-twlc-simplify-rtc-interrupt-clearing.patch
drivers-rtc-rtc-twlc-return-correct-rtc-event-from-isr.patch

