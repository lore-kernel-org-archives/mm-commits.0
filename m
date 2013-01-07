From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-vt8500c-fix-handling-of-data-passed-in-struct-rtc_time.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:27:00 -0800
Message-ID: <20130107192701.296BE200057__236.594785428856$1357586842$gmane$org@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:61045 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3AGT1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:27:03 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so1261409fav.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:27:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@prisktech.co.nz, froese@gmx.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-vt8500c-fix-handling-of-data-passed-in-struct-rtc_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Prisk <linux@prisktech.co.nz>
Subject: drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time

tm_mon is 0..11, whereas vt8500 expects 1..12 for the month field, causing
invalid date errors for January, and causing the day field to roll over
incorrectly.

The century flag is only handled in vt8500_rtc_read_time, but not set in
vt8500_rtc_set_time.  This patch corrects the behaviour of the century
flag.

Signed-off-by: Edgar Toernig <froese@gmx.de>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-fix-handling-of-data-passed-in-struct-rtc_time drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-fix-handling-of-data-passed-in-struct-rtc_time
+++ a/drivers/rtc/rtc-vt8500.c
@@ -119,7 +119,7 @@ static int vt8500_rtc_read_time(struct d
 	tm->tm_min = bcd2bin((time & TIME_MIN_MASK) >> TIME_MIN_S);
 	tm->tm_hour = bcd2bin((time & TIME_HOUR_MASK) >> TIME_HOUR_S);
 	tm->tm_mday = bcd2bin(date & DATE_DAY_MASK);
-	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S);
+	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S) - 1;
 	tm->tm_year = bcd2bin((date & DATE_YEAR_MASK) >> DATE_YEAR_S)
 			+ ((date >> DATE_CENTURY_S) & 1 ? 200 : 100);
 	tm->tm_wday = (time & TIME_DOW_MASK) >> TIME_DOW_S;
@@ -138,8 +138,9 @@ static int vt8500_rtc_set_time(struct de
 	}
 
 	writel((bin2bcd(tm->tm_year - 100) << DATE_YEAR_S)
-		| (bin2bcd(tm->tm_mon) << DATE_MONTH_S)
-		| (bin2bcd(tm->tm_mday)),
+		| (bin2bcd(tm->tm_mon + 1) << DATE_MONTH_S)
+		| (bin2bcd(tm->tm_mday))
+		| ((tm->tm_year >= 200) << DATE_CENTURY_S),
 		vt8500_rtc->regbase + VT8500_RTC_DS);
 	writel((bin2bcd(tm->tm_wday) << TIME_DOW_S)
 		| (bin2bcd(tm->tm_hour) << TIME_HOUR_S)
_

Patches currently in -mm which might be from linux@prisktech.co.nz are

origin.patch
linux-next.patch

