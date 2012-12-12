From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3c-use-of_match_ptr-macro.patch added to -mm tree
Date: Wed, 12 Dec 2012 12:51:47 -0800
Message-ID: <20121212205148.0F480200063@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36921 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2LLUvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:51:50 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so66687wib.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:51:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-s3c: use of_match_ptr() macro
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3c-use-of_match_ptr-macro.patch

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
@@ -695,8 +695,6 @@ static const struct of_device_id s3c_rtc
 	{},
 };
 MODULE_DEVICE_TABLE(of, s3c_rtc_dt_match);
-#else
-#define s3c_rtc_dt_match NULL
 #endif
 
 static struct platform_device_id s3c_rtc_driver_ids[] = {
@@ -727,7 +725,7 @@ static struct platform_driver s3c_rtc_dr
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
drivers-video-console-softcursorc-remove-redundant-null-check-before-kfree.patch
rtc-remove-unused-code-from-rtc-devc.patch
drivers-rtc-rtc-s3c-use-of_match_ptr-macro.patch

