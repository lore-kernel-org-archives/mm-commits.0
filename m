From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tilec-add-missing-platform_device_unregister-when-module-exits.patch removed from -mm tree
Date: Fri, 10 May 2013 12:14:51 -0700
Message-ID: <20130510191451.759FC5A4028@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37995 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab3EJTOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 15:14:52 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so426254yho.0
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 12:14:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tile.c: add missing platform_device_unregister() when module exits
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tilec-add-missing-platform_device_unregister-when-module-exits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

