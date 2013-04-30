From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-tx4939-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:23 -0700
Message-ID: <20130430185523.6E11831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57785 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3D3SzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:24 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86493yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-tx4939: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-tx4939-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-tx4939: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tx4939.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-tx4939.c~rtc-rtc-tx4939-use-module_platform_driver_probe drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~rtc-rtc-tx4939-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-tx4939.c
@@ -299,18 +299,7 @@ static struct platform_driver tx4939_rtc
 	},
 };
 
-static int __init tx4939rtc_init(void)
-{
-	return platform_driver_probe(&tx4939_rtc_driver, tx4939_rtc_probe);
-}
-
-static void __exit tx4939rtc_exit(void)
-{
-	platform_driver_unregister(&tx4939_rtc_driver);
-}
