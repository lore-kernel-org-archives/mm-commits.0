From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-rtc-rtc-cmosc-use-of_match_ptr.patch removed from -mm tree
Date: Thu, 20 Dec 2012 12:21:57 -0800
Message-ID: <20121220202157.82C7C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:59597 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LTUV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:21:58 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so405095vba.0
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:21:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: use of_match_ptr()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-cmosc-use-of_match_ptr.patch

This patch was dropped because it was folded into drivers-rtc-use-of_match_ptr-macro.patch

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
backlight-add-lms501kf03-lcd-driver.patch
drivers-rtc-use-of_match_ptr-macro.patch

