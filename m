From: akpm@linux-foundation.org
Subject: + rtc-avoid-calling-platform_device_put-twice-in-test_init.patch added to -mm tree
Date: Tue, 06 Nov 2012 16:52:33 -0800
Message-ID: <20121107005234.BA9F320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:44729 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2KGAwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 19:52:37 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt11so70316wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 16:52:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-test.c: avoid calling platform_device_put() twice
has been added to the -mm tree.  Its filename is
     rtc-avoid-calling-platform_device_put-twice-in-test_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/rtc/rtc-test.c: avoid calling platform_device_put() twice

In case of error, test_init() needs to call platform_device_del() instead
of platform_device_unregister().  Otherwise, we may call
platform_device_put() twice.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-test.c~rtc-avoid-calling-platform_device_put-twice-in-test_init drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-avoid-calling-platform_device_put-twice-in-test_init
+++ a/drivers/rtc/rtc-test.c
@@ -164,7 +164,7 @@ static int __init test_init(void)
 	return 0;
 
 exit_device_unregister:
-	platform_device_unregister(test0);
+	platform_device_del(test0);
 
 exit_free_test1:
 	platform_device_put(test1);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
procfs-use-kbasename-fix.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch

