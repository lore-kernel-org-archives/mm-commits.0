From: akpm@linux-foundation.org
Subject: + s3c-rtc-fix-compiler-warning.patch added to -mm tree
Date: Fri, 25 May 2012 16:09:47 -0700
Message-ID: <20120525230947.3D93AA022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64598 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab2EYXJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 19:09:48 -0400
Received: by vbnl22 with SMTP id l22so161044vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 16:09:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix compiler warning
has been added to the -mm tree.  Its filename is
     s3c-rtc-fix-compiler-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: fix compiler warning

rtc-s3c.c:673:32: warning: `s3c_rtc_drv_data_array' defined but not used [-Wunused-variable]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s3c.c~s3c-rtc-fix-compiler-warning drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~s3c-rtc-fix-compiler-warning
+++ a/drivers/rtc/rtc-s3c.c
@@ -670,6 +670,7 @@ static int s3c_rtc_resume(struct platfor
 #define s3c_rtc_resume  NULL
 #endif
 
+#ifdef CONFIG_OF
 static struct s3c_rtc_drv_data s3c_rtc_drv_data_array[] = {
 	[TYPE_S3C2410] = { TYPE_S3C2410 },
 	[TYPE_S3C2416] = { TYPE_S3C2416 },
@@ -677,7 +678,6 @@ static struct s3c_rtc_drv_data s3c_rtc_d
 	[TYPE_S3C64XX] = { TYPE_S3C64XX },
 };
 
-#ifdef CONFIG_OF
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
 		.compatible = "samsung,s3c2410-rtc",
_
Subject: Subject: drivers/rtc/rtc-s3c.c: fix compiler warning

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
s3c-rtc-fix-compiler-warning.patch

