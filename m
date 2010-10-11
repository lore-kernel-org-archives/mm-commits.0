From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-fix-setting-missing-field-of-getalarm.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:59:30 -0700
Message-ID: <201010112259.o9BMxU3L023159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524Ab0JKXAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaos.youn@samsung.com, a.zummo@towertech.it, ben-linux@fluff.org, kgene.kim@samsung.com, mcuos.com@gmail.com


The patch titled
     rtc: rtc-s3c: fix setting missing field of getalarm
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-fix-setting-missing-field-of-getalarm.patch

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
Subject: rtc: rtc-s3c: fix setting missing field of getalarm
From: Changhwan Youn <chaos.youn@samsung.com>

Current s3c_rtc_getalarm() sets missing field of alarm time with 0xff. 
But this value should be -1 according to drivers/rtc/interface.c.

Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-setting-missing-field-of-getalarm drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-setting-missing-field-of-getalarm
+++ a/drivers/rtc/rtc-s3c.c
@@ -242,34 +242,34 @@ static int s3c_rtc_getalarm(struct devic
 	if (alm_en & S3C2410_RTCALM_SECEN)
 		alm_tm->tm_sec = bcd2bin(alm_tm->tm_sec);
 	else
-		alm_tm->tm_sec = 0xff;
+		alm_tm->tm_sec = -1;
 
 	if (alm_en & S3C2410_RTCALM_MINEN)
 		alm_tm->tm_min = bcd2bin(alm_tm->tm_min);
 	else
-		alm_tm->tm_min = 0xff;
+		alm_tm->tm_min = -1;
 
 	if (alm_en & S3C2410_RTCALM_HOUREN)
 		alm_tm->tm_hour = bcd2bin(alm_tm->tm_hour);
 	else
-		alm_tm->tm_hour = 0xff;
+		alm_tm->tm_hour = -1;
 
 	if (alm_en & S3C2410_RTCALM_DAYEN)
 		alm_tm->tm_mday = bcd2bin(alm_tm->tm_mday);
 	else
-		alm_tm->tm_mday = 0xff;
+		alm_tm->tm_mday = -1;
 
 	if (alm_en & S3C2410_RTCALM_MONEN) {
 		alm_tm->tm_mon = bcd2bin(alm_tm->tm_mon);
 		alm_tm->tm_mon -= 1;
 	} else {
-		alm_tm->tm_mon = 0xff;
+		alm_tm->tm_mon = -1;
 	}
 
 	if (alm_en & S3C2410_RTCALM_YEAREN)
 		alm_tm->tm_year = bcd2bin(alm_tm->tm_year);
 	else
-		alm_tm->tm_year = 0xffff;
+		alm_tm->tm_year = -1;
 
 	return 0;
 }
_

Patches currently in -mm which might be from chaos.youn@samsung.com are

linux-next.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch
rtc-rtc-s3c-fix-setting-missing-field-of-getalarm.patch
rtc-rtc-s3c-fix-on-support-rtc-alarm.patch
rtc-rtc-s3c-fix-rtc-initialization-method.patch

