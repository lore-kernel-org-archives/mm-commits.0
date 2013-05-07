From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tilec-add-missing-platform_device_unregister-when-module-exits.patch added to -mm tree
Date: Tue, 07 May 2013 16:29:17 -0700
Message-ID: <20130507232917.734D231C078@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:36428 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3EGX3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 19:29:18 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so125532vbg.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 16:29:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-tile.c: add missing platform_device_unregister() when module exits
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tilec-add-missing-platform_device_unregister-when-module-exits.patch

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
Subject: drivers/rtc/rtc-tile.c: add missing platform_device_unregister() when module exits

We have registered platform device when module init, and need to unregister
it when the module exits.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tile.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-tile.c~drivers-rtc-rtc-tilec-add-missing-platform_device_unregister-when-module-exits drivers/rtc/rtc-tile.c
--- a/drivers/rtc/rtc-tile.c~drivers-rtc-rtc-tilec-add-missing-platform_device_unregister-when-module-exits
+++ a/drivers/rtc/rtc-tile.c
@@ -146,6 +146,7 @@ exit_driver_unregister:
  */
 static void __exit tile_rtc_driver_exit(void)
 {
+	platform_device_unregister(tile_rtc_platform_device);
 	platform_driver_unregister(&tile_rtc_platform_driver);
 }
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
drivers-rtc-rtc-tilec-add-missing-platform_device_unregister-when-module-exits.patch

