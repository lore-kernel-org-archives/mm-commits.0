From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-vt8500c-fix-year-field-in-vt8500_rtc_set_time.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:58:16 -0800
Message-ID: <20130115215816.9513F31C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:59142 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3AOV6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:58:17 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so81523yhr.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:58:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@prisktech.co.nz, a.zummo@towertech.it, froese@gmx.de


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: fix year field in vt8500_rtc_set_time()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-vt8500c-fix-year-field-in-vt8500_rtc_set_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tony Prisk <linux@prisktech.co.nz>
Subject: drivers/rtc/rtc-vt8500.c: fix year field in vt8500_rtc_set_time()

The year field is incorrectly masked when setting the date.  If the year
is beyond 2099, the year field will be incorrectly updated in hardware.

This patch masks the year field correctly.

Signed-off-by: Edgar Toernig <froese@gmx.de>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-fix-year-field-in-vt8500_rtc_set_time drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~drivers-rtc-rtc-vt8500c-fix-year-field-in-vt8500_rtc_set_time
+++ a/drivers/rtc/rtc-vt8500.c
@@ -137,7 +137,7 @@ static int vt8500_rtc_set_time(struct de
 		return -EINVAL;
 	}
 
-	writel((bin2bcd(tm->tm_year - 100) << DATE_YEAR_S)
+	writel((bin2bcd(tm->tm_year % 100) << DATE_YEAR_S)
 		| (bin2bcd(tm->tm_mon + 1) << DATE_MONTH_S)
 		| (bin2bcd(tm->tm_mday))
 		| ((tm->tm_year >= 200) << DATE_CENTURY_S),
_

Patches currently in -mm which might be from linux@prisktech.co.nz are

linux-next.patch
drivers-rtc-rtc-vt8500c-fix-year-field-in-vt8500_rtc_set_time.patch

