From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-msm6242-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:53 -0700
Message-ID: <20130430185453.6CB9D5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:42694 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Syy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:54 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86622qea.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-msm6242: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-msm6242-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-msm6242: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-msm6242.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-msm6242.c~rtc-rtc-msm6242-use-module_platform_driver_probe drivers/rtc/rtc-msm6242.c
--- a/drivers/rtc/rtc-msm6242.c~rtc-rtc-msm6242-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-msm6242.c
@@ -252,18 +252,7 @@ static struct platform_driver msm6242_rt
 	.remove	= __exit_p(msm6242_rtc_remove),
 };
 
-static int __init msm6242_rtc_init(void)
-{
-	return platform_driver_probe(&msm6242_rtc_driver, msm6242_rtc_probe);
-}
-
-static void __exit msm6242_rtc_fini(void)
-{
-	platform_driver_unregister(&msm6242_rtc_driver);
-}
