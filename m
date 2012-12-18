From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3c-use-of_match_ptr-macro.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:32 -0800
Message-ID: <20121218200833.1933A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:55165 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab2LRUIf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:35 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so63516eaa.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c: use of_match_ptr() macro
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3c-use-of_match_ptr-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-s3c: use of_match_ptr() macro

This eliminates having an #ifdef returning NULL for the case when OF is
disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3c-use-of_match_ptr-macro drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3c-use-of_match_ptr-macro
+++ a/drivers/rtc/rtc-s3c.c
@@ -663,8 +663,6 @@ static const struct of_device_id s3c_rtc
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c_rtc_dt_match);
-#else
-#define s3c_rtc_dt_match NULL
 #endif
 
 static struct platform_device_id s3c_rtc_driver_ids[] = {
@@ -695,7 +693,7 @@ static struct platform_driver s3c_rtc_dr
 	.driver		= {
 		.name	= "s3c-rtc",
 		.owner	= THIS_MODULE,
-		.of_match_table	= s3c_rtc_dt_match,
+		.of_match_table	= of_match_ptr(s3c_rtc_dt_match),
 	},
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch

