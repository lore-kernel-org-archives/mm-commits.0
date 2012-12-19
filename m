From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-cmosc-use-of_match_ptr.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:23:33 -0800
Message-ID: <20121219222333.EBBE120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:59855 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LSWXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:23:36 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so137486wey.5
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:23:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: use of_match_ptr()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-cmosc-use-of_match_ptr.patch

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
Subject: drivers/rtc/rtc-cmos.c: use of_match_ptr()

This eliminates having an #ifdef returning NULL for the case when OF is
disabled.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-use-of_match_ptr drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-use-of_match_ptr
+++ a/drivers/rtc/rtc-cmos.c
@@ -1101,7 +1101,6 @@ static __init void cmos_of_init(struct p
 }
 #else
 static inline void cmos_of_init(struct platform_device *pdev) {}
-#define of_cmos_match NULL
 #endif
 /*----------------------------------------------------------------*/
 
@@ -1143,7 +1142,7 @@ static struct platform_driver cmos_platf
 #ifdef CONFIG_PM
 		.pm		= &cmos_pm_ops,
 #endif
-		.of_match_table = of_cmos_match,
+		.of_match_table = of_match_ptr(of_cmos_match),
 	}
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-cmosc-use-of_match_ptr.patch

