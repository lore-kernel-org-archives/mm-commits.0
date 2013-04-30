From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rp5c01-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:10 -0700
Message-ID: <20130430185510.71C455A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37466 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3D3SzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:11 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86452yha.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rp5c01: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rp5c01-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rp5c01: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rp5c01.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-rp5c01.c~rtc-rtc-rp5c01-use-module_platform_driver_probe drivers/rtc/rtc-rp5c01.c
--- a/drivers/rtc/rtc-rp5c01.c~rtc-rtc-rp5c01-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-rp5c01.c
@@ -294,18 +294,7 @@ static struct platform_driver rp5c01_rtc
 	.remove	= __exit_p(rp5c01_rtc_remove),
 };
 
-static int __init rp5c01_rtc_init(void)
-{
-	return platform_driver_probe(&rp5c01_rtc_driver, rp5c01_rtc_probe);
-}
-
-static void __exit rp5c01_rtc_fini(void)
-{
-	platform_driver_unregister(&rp5c01_rtc_driver);
-}
