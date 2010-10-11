From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-add-rtc_valid_tm-in-s3c_rtc_gettime.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:59:38 -0700
Message-ID: <201010112259.o9BMxcTp023173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306Ab0JKXAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kgene.kim@samsung.com, a.zummo@towertech.it, ben-linux@fluff.org, mcuos.com@gmail.com


The patch titled
     rtc: rtc-s3c: add rtc_valid_tm in s3c_rtc_gettime()
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-add-rtc_valid_tm-in-s3c_rtc_gettime.patch

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
Subject: rtc: rtc-s3c: add rtc_valid_tm in s3c_rtc_gettime()
From: Kukjin Kim <kgene.kim@samsung.com>

Add "rtc_valid_tm" in s3c_rtc_gettime() as per Wan ZongShun's suggestion.

Suggested-by: Wan ZongShun <mcuos.com@gmail.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-add-rtc_valid_tm-in-s3c_rtc_gettime drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-add-rtc_valid_tm-in-s3c_rtc_gettime
+++ a/drivers/rtc/rtc-s3c.c
@@ -185,7 +185,7 @@ static int s3c_rtc_gettime(struct device
 	rtc_tm->tm_year += 100;
 	rtc_tm->tm_mon -= 1;
 
-	return 0;
+	return rtc_valid_tm(rtc_tm);
 }
 
 static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
_

Patches currently in -mm which might be from kgene.kim@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch
rtc-rtc-s3c-fix-setting-missing-field-of-getalarm.patch
rtc-rtc-s3c-fix-on-support-rtc-alarm.patch
rtc-rtc-s3c-fix-debug-message-format-on-rtc.patch
rtc-rtc-s3c-fix-rtc-initialization-method.patch
rtc-rtc-s3c-add-rtc_valid_tm-in-s3c_rtc_gettime.patch

