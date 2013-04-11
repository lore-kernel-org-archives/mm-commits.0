From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare.patch added to -mm tree
Date: Thu, 11 Apr 2013 13:53:12 -0700
Message-ID: <20130411205312.748505A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:41573 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3DKUxO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 16:53:14 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so184870qee.4
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 13:53:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.abraham@linaro.org, gautam.vivek@samsung.com, jg1.han@samsung.com, s.nawrocki@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: use clk_prepare_enable and clk_disable_unprepare
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thomas Abraham <thomas.abraham@linaro.org>
Subject: drivers/rtc/rtc-s3c.c: use clk_prepare_enable and clk_disable_unprepare

Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
calls as required by common clock framework.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare
+++ a/drivers/rtc/rtc-s3c.c
@@ -426,6 +426,7 @@ static int s3c_rtc_remove(struct platfor
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
+	clk_unprepare(rtc_clk);
 	rtc_clk = NULL;
 
 	return 0;
@@ -494,7 +495,7 @@ static int s3c_rtc_probe(struct platform
 		return ret;
 	}
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 
 	/* check to see if everything is setup correctly */
 
@@ -573,7 +574,7 @@ static int s3c_rtc_probe(struct platform
 
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return ret;
 }
_

Patches currently in -mm which might be from thomas.abraham@linaro.org are

linux-next.patch
drivers-rtc-rtc-s3cc-use-clk_prepare_enable-and-clk_disable_unprepare.patch

