From: akpm@linux-foundation.org
Subject: - rtc-rs5c313c-rtc_time-value-are-fixed.patch removed from -mm tree
Date: Fri, 11 May 2007 22:34:19 -0700
Message-ID: <200705120534.l4C5YJHU002192@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275AbXELFfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kogiidena@eggplant.ddo.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-rs5c313.c: rtc_time value are fixed
has been removed from the -mm tree.  Its filename was
     rtc-rs5c313c-rtc_time-value-are-fixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-rs5c313.c: rtc_time value are fixed
From: "kogiidena" <kogiidena@eggplant.ddo.jp>

Correct an initial value of suruct rtc_ time.

Signed-off-by: kogiidena <kogiidena@eggplant.ddo.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c313.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-rs5c313.c~rtc-rs5c313c-rtc_time-value-are-fixed drivers/rtc/rtc-rs5c313.c
--- a/drivers/rtc/rtc-rs5c313.c~rtc-rs5c313c-rtc_time-value-are-fixed
+++ a/drivers/rtc/rtc-rs5c313.c
@@ -331,7 +331,8 @@ static void rs5c313_check_xstp_bit(void)
 
 		memset(&tm, 0, sizeof(struct rtc_time));
 		tm.tm_mday 	= 1;
-		tm.tm_mon 	= 1;
+		tm.tm_mon 	= 1 - 1;
+		tm.tm_year 	= 2000 - 1900;
 
 		rs5c313_rtc_set_time(NULL, &tm);
 		printk(KERN_ERR "RICHO RS5C313: invalid value, resetting to "
_

Patches currently in -mm which might be from kogiidena@eggplant.ddo.jp are

origin.patch
