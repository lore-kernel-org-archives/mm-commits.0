From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pxac-fix-alarm-not-match-issue.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:11 -0800
Message-ID: <20130222204311.A03B95A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:36356 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab3BVUnM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:12 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so104000qcr.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liangs@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pxa.c: fix alarm not match issue
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pxac-fix-alarm-not-match-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue.patch
drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix.patch

