From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-au1xxx-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:33 -0700
Message-ID: <20130430185433.701B731C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:39792 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab3D3Sye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:34 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so87973qad.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-au1xxx: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-au1xxx-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-au1xxx: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-au1xxx.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-au1xxx.c~rtc-rtc-au1xxx-use-module_platform_driver_probe drivers/rtc/rtc-au1xxx.c
--- a/drivers/rtc/rtc-au1xxx.c~rtc-rtc-au1xxx-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-au1xxx.c
@@ -134,18 +134,7 @@ static struct platform_driver au1xrtc_dr
 	.remove		= au1xtoy_rtc_remove,
 };
 
-static int __init au1xtoy_rtc_init(void)
-{
-	return platform_driver_probe(&au1xrtc_driver, au1xtoy_rtc_probe);
-}
-
-static void __exit au1xtoy_rtc_exit(void)
-{
-	platform_driver_unregister(&au1xrtc_driver);
-}
