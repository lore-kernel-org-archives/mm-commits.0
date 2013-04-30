From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ab3100-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:26 -0700
Message-ID: <20130430185426.7656E5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62733 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab3D3Sy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:27 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so86555qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ab3100: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ab3100-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ab3100: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab3100.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-ab3100.c~rtc-rtc-ab3100-use-module_platform_driver_probe drivers/rtc/rtc-ab3100.c
--- a/drivers/rtc/rtc-ab3100.c~rtc-rtc-ab3100-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-ab3100.c
@@ -257,19 +257,7 @@ static struct platform_driver ab3100_rtc
 	.remove	 = __exit_p(ab3100_rtc_remove),
 };
 
-static int __init ab3100_rtc_init(void)
-{
-	return platform_driver_probe(&ab3100_rtc_driver,
-				     ab3100_rtc_probe);
-}
-
-static void __exit ab3100_rtc_exit(void)
-{
-	platform_driver_unregister(&ab3100_rtc_driver);
-}
