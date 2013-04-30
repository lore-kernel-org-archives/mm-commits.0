From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-omap-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:00 -0700
Message-ID: <20130430185500.6F9FD5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:47083 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197Ab3D3SzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:01 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86457yha.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-omap: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-omap-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-omap: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-omap.c~rtc-rtc-omap-use-module_platform_driver_probe drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-rtc-omap-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-omap.c
@@ -550,17 +550,7 @@ static struct platform_driver omap_rtc_d
 	.id_table	= omap_rtc_devtype,
 };
 
-static int __init rtc_init(void)
-{
-	return platform_driver_probe(&omap_rtc_driver, omap_rtc_probe);
-}
-module_init(rtc_init);
