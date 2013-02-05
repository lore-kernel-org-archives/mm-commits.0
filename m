From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-vt8500c-fix-year-field-in-vt8500_rtc_set_time.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:18 -0800
Message-ID: <20130205202018.AC3E731C1CE@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:58183 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3BEUUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:20 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so65490yen.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@prisktech.co.nz, a.zummo@towertech.it, froese@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-vt8500.c: fix year field in vt8500_rtc_set_time()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-vt8500c-fix-year-field-in-vt8500_rtc_set_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

