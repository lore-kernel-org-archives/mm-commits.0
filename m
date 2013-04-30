From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-coh901331-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:35 -0700
Message-ID: <20130430185435.72C235A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52650 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Syg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:36 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86407yha.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-coh901331: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-coh901331-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-coh901331: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-module_platform_driver_probe drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-coh901331.c
@@ -287,18 +287,7 @@ static struct platform_driver coh901331_
 	.shutdown = coh901331_shutdown,
 };
 
-static int __init coh901331_init(void)
-{
-	return platform_driver_probe(&coh901331_driver, coh901331_probe);
-}
-
-static void __exit coh901331_exit(void)
-{
-	platform_driver_unregister(&coh901331_driver);
-}
