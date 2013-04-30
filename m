From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sun4v-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:18 -0700
Message-ID: <20130430185518.6EEDE5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:44556 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216Ab3D3SzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:19 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86649yen.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-sun4v: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sun4v-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sun4v: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sun4v.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-sun4v.c~rtc-rtc-sun4v-use-module_platform_driver_probe drivers/rtc/rtc-sun4v.c
--- a/drivers/rtc/rtc-sun4v.c~rtc-rtc-sun4v-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-sun4v.c
@@ -106,18 +106,7 @@ static struct platform_driver sun4v_rtc_
 	.remove		= __exit_p(sun4v_rtc_remove),
 };
 
-static int __init sun4v_rtc_init(void)
-{
-	return platform_driver_probe(&sun4v_rtc_driver, sun4v_rtc_probe);
-}
-
-static void __exit sun4v_rtc_exit(void)
-{
-	platform_driver_unregister(&sun4v_rtc_driver);
-}
