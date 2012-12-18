From: akpm@linux-foundation.org
Subject: [merged] rtc-avoid-calling-platform_device_put-twice-in-test_init.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:07:48 -0800
Message-ID: <20121218200749.1C837200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:34141 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2LRUHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:07:51 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so63328wib.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:07:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-test.c: avoid calling platform_device_put() twice
has been removed from the -mm tree.  Its filename was
     rtc-avoid-calling-platform_device_put-twice-in-test_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/rtc/rtc-test.c: avoid calling platform_device_put() twice

In case of error, test_init() needs to call platform_device_del() instead
of platform_device_unregister().  Otherwise, we may call
platform_device_put() twice.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

[akpm@linux-foundation.org: improve label naming]
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-test.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-test.c~rtc-avoid-calling-platform_device_put-twice-in-test_init drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-avoid-calling-platform_device_put-twice-in-test_init
+++ a/drivers/rtc/rtc-test.c
@@ -152,24 +152,24 @@ static int __init test_init(void)
 
 	if ((test1 = platform_device_alloc("rtc-test", 1)) == NULL) {
 		err = -ENOMEM;
-		goto exit_free_test0;
+		goto exit_put_test0;
 	}
 
 	if ((err = platform_device_add(test0)))
-		goto exit_free_test1;
+		goto exit_put_test1;
 
 	if ((err = platform_device_add(test1)))
-		goto exit_device_unregister;
+		goto exit_del_test0;
 
 	return 0;
 
-exit_device_unregister:
-	platform_device_unregister(test0);
+exit_del_test0:
+	platform_device_del(test0);
 
-exit_free_test1:
+exit_put_test1:
 	platform_device_put(test1);
 
-exit_free_test0:
+exit_put_test0:
 	platform_device_put(test0);
 
 exit_driver_unregister:
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

