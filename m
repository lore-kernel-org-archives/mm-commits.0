From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pxac-fix-alarm-not-match-issue.patch added to -mm tree
Date: Tue, 18 Dec 2012 16:11:48 -0800
Message-ID: <20121219001149.4C1D3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42698 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2LSALu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 19:11:50 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so159172vcd.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 16:11:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liangs@marvell.com


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: fix alarm not match issue
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pxac-fix-alarm-not-match-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Leo Song <liangs@marvell.com>
Subject: drivers/rtc/rtc-pxa.c: fix alarm not match issue

Fix pxa rtc alarm issue by setting week of month and day of week in
rdar/rdcr or it would not match.

Signed-off-by: Leo Song <liangs@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-alarm-not-match-issue drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~drivers-rtc-rtc-pxac-fix-alarm-not-match-issue
+++ a/drivers/rtc/rtc-pxa.c
@@ -62,6 +62,10 @@
 #define RYxR_MONTH_S	5
 #define RYxR_MONTH_MASK	(0xf << RYxR_MONTH_S)
 #define RYxR_DAY_MASK	0x1f
+#define RDxR_WOM_S     20
+#define RDxR_WOM_MASK  (0x7 << RDxR_WOM_S)
+#define RDxR_DOW_S     17
+#define RDxR_DOW_MASK  (0x7 << RDxR_DOW_S)
 #define RDxR_HOUR_S	12
 #define RDxR_HOUR_MASK	(0x1f << RDxR_HOUR_S)
 #define RDxR_MIN_S	6
@@ -91,6 +95,7 @@ struct pxa_rtc {
 	spinlock_t		lock;		/* Protects this structure */
 };
 
+
 static u32 ryxr_calc(struct rtc_time *tm)
 {
 	return ((tm->tm_year + 1900) << RYxR_YEAR_S)
@@ -100,7 +105,10 @@ static u32 ryxr_calc(struct rtc_time *tm
 
 static u32 rdxr_calc(struct rtc_time *tm)
 {
-	return (tm->tm_hour << RDxR_HOUR_S) | (tm->tm_min << RDxR_MIN_S)
+	return ((((tm->tm_mday + 6) / 7) << RDxR_WOM_S) & RDxR_WOM_MASK)
+		| (((tm->tm_wday + 1) << RDxR_DOW_S) & RDxR_DOW_MASK)
+		| (tm->tm_hour << RDxR_HOUR_S)
+		| (tm->tm_min << RDxR_MIN_S)
 		| tm->tm_sec;
 }
 
@@ -109,6 +117,7 @@ static void tm_calc(u32 rycr, u32 rdcr, 
 	tm->tm_year = ((rycr & RYxR_YEAR_MASK) >> RYxR_YEAR_S) - 1900;
 	tm->tm_mon = (((rycr & RYxR_MONTH_MASK) >> RYxR_MONTH_S)) - 1;
 	tm->tm_mday = (rycr & RYxR_DAY_MASK);
+	tm->tm_wday = ((rycr & RDxR_DOW_MASK) >> RDxR_DOW_S) - 1;
 	tm->tm_hour = (rdcr & RDxR_HOUR_MASK) >> RDxR_HOUR_S;
 	tm->tm_min = (rdcr & RDxR_MIN_MASK) >> RDxR_MIN_S;
 	tm->tm_sec = rdcr & RDxR_SEC_MASK;
_

Patches currently in -mm which might be from liangs@marvell.com are

drivers-rtc-rtc-pxac-fix-alarm-not-match-issue.patch
drivers-rtc-rtc-pxac-fix-alarm-cant-wake-up-system-issue.patch
drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue.patch

