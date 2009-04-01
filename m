From: akpm@linux-foundation.org
Subject: [merged] rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch removed from -mm tree
Date: Wed, 01 Apr 2009 12:07:24 -0700
Message-ID: <200904011907.n31J7Owc017117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765196AbZDATLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     rtc-parisc: use rtc_valid_tm() in parisc_get_time
has been removed from the -mm tree.  Its filename was
     rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-parisc: use rtc_valid_tm() in parisc_get_time
From: dann frazier <dannf@hp.com>

Use the return value of rtc_valid_tm() instead of just returning 0.

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-parisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-parisc.c~rtc-parisc-use-rtc_valid_tm-in-parisc_get_time drivers/rtc/rtc-parisc.c
--- a/drivers/rtc/rtc-parisc.c~rtc-parisc-use-rtc_valid_tm-in-parisc_get_time
+++ a/drivers/rtc/rtc-parisc.c
@@ -20,7 +20,7 @@ static int parisc_get_time(struct device
 	if (ret & RTC_BATT_BAD)
 		return -EOPNOTSUPP;
 
-	return 0;
+	return rtc_valid_tm(tm);
 }
 
 static int parisc_set_time(struct device *dev, struct rtc_time *tm)
_

Patches currently in -mm which might be from dannf@hp.com are

origin.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
ipmi-add-oem-message-handling.patch

