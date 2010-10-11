From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-fix-debug-message-format-on-rtc.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:59:34 -0700
Message-ID: <201010112259.o9BMxY1u023166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569Ab0JKXAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kgene.kim@samsung.com, a.zummo@towertech.it, ben-linux@fluff.org, mcuos.com@gmail.com


The patch titled
     rtc: rtc-s3c: Fix debug message format on RTC
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-fix-debug-message-format-on-rtc.patch

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
Subject: rtc: rtc-s3c: Fix debug message format on RTC
From: Kukjin Kim <kgene.kim@samsung.com>

Fix debug message format.

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-debug-message-format-on-rtc drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-debug-message-format-on-rtc
+++ a/drivers/rtc/rtc-s3c.c
@@ -171,8 +171,8 @@ static int s3c_rtc_gettime(struct device
 		goto retry_get_time;
 	}
 
-	pr_debug("read time %02x.%02x.%02x %02x/%02x/%02x\n",
-		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
+	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
+		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
 		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
 
 	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
@@ -193,8 +193,8 @@ static int s3c_rtc_settime(struct device
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	pr_debug("set time %02d.%02d.%02d %02d/%02d/%02d\n",
-		 tm->tm_year, tm->tm_mon, tm->tm_mday,
+	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
+		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
 	/* we get around y2k by simply not supporting it */
@@ -231,9 +231,9 @@ static int s3c_rtc_getalarm(struct devic
 
 	alrm->enabled = (alm_en & S3C2410_RTCALM_ALMEN) ? 1 : 0;
 
-	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
+	pr_debug("read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alm_en,
-		 alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
+		 1900 + alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
 		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
 
 
@@ -280,10 +280,10 @@ static int s3c_rtc_setalarm(struct devic
 	void __iomem *base = s3c_rtc_base;
 	unsigned int alrm_en;
 
-	pr_debug("s3c_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
+	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
-		 tm->tm_mday & 0xff, tm->tm_mon & 0xff, tm->tm_year & 0xff,
-		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
+		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
+		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
 
 	alrm_en = readb(base + S3C2410_RTCALM) & S3C2410_RTCALM_ALMEN;
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

