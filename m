From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch added to -mm tree
Date: Thu, 05 May 2011 17:02:53 -0700
Message-ID: <201105060002.p4602rqQ010988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331Ab1EFADf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2011 20:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, alessandro.zummo@towertech.it, vzapolskiy@gmail.com


The patch titled
     drivers/rtc/rtc-mxc.c: remove defines already included in rtc.h
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch

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
Subject: drivers/rtc/rtc-mxc.c: remove defines already included in rtc.h
From: Wolfram Sang <w.sang@pengutronix.de>

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch
+++ a/drivers/rtc/rtc-mxc.c
@@ -55,12 +55,6 @@ static const u32 PIE_BIT_DEF[MAX_PIE_NUM
 	{ MAX_PIE_FREQ,	RTC_SAM7_BIT },
 };
 
-/* Those are the bits from a classic RTC we want to mimic */
-#define RTC_IRQF	0x80	/* any of the following 3 is active */
-#define RTC_PF		0x40	/* Periodic interrupt */
-#define RTC_AF		0x20	/* Alarm interrupt */
-#define RTC_UF		0x10	/* Update interrupt for 1Hz RTC */
