From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-fix-compilation-error.patch added to -mm tree
Date: Fri, 06 Apr 2012 12:14:06 -0700
Message-ID: <20120406191406.CFB65A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57468 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2DFTOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 15:14:09 -0400
Received: by eekc41 with SMTP id c41so131535eek.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 12:14:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tushar.behera@linaro.org, a.zummo@towertech.it, heiko@sntech.de


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix compilation error
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-fix-compilation-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tushar Behera <tushar.behera@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: fix compilation error

drivers/rtc/rtc-s3c.c: At top level:
drivers/rtc/rtc-s3c.c:671:3: error: request for member `data' in something not a structure or union
drivers/rtc/rtc-s3c.c:674:3: error: request for member `data' in something not a structure or union
drivers/rtc/rtc-s3c.c:677:3: error: request for member `data' in something not a structure or union
drivers/rtc/rtc-s3c.c:680:3: error: request for member `data' in something not a structure or union

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-compilation-error drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-compilation-error
+++ a/drivers/rtc/rtc-s3c.c
@@ -667,16 +667,16 @@ static int s3c_rtc_resume(struct platfor
 #ifdef CONFIG_OF
 static const struct of_device_id s3c_rtc_dt_match[] = {
 	{
-		.compatible = "samsung,s3c2410-rtc"
+		.compatible = "samsung,s3c2410-rtc",
 		.data = TYPE_S3C2410,
 	}, {
-		.compatible = "samsung,s3c2416-rtc"
+		.compatible = "samsung,s3c2416-rtc",
 		.data = TYPE_S3C2416,
 	}, {
-		.compatible = "samsung,s3c2443-rtc"
+		.compatible = "samsung,s3c2443-rtc",
 		.data = TYPE_S3C2443,
 	}, {
-		.compatible = "samsung,s3c6410-rtc"
+		.compatible = "samsung,s3c6410-rtc",
 		.data = TYPE_S3C64XX,
 	},
 	{},
_
Subject: Subject: drivers/rtc/rtc-s3c.c: fix compilation error

Patches currently in -mm which might be from tushar.behera@linaro.org are

drivers-rtc-rtc-s3cc-fix-compilation-error.patch

