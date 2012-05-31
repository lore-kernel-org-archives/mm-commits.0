From: akpm@linux-foundation.org
Subject: [merged] s3c-rtc-fix-compiler-warning.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:45 -0700
Message-ID: <20120531192045.5F8CAA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:57799 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab2EaTUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:46 -0400
Received: by ghbz15 with SMTP id z15so135474ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix compiler warning
has been removed from the -mm tree.  Its filename was
     s3c-rtc-fix-compiler-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch

