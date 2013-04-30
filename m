From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pxa-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:07 -0700
Message-ID: <20130430185507.6F7315A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50872 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3D3SzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:08 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86872vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pxa: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pxa-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pxa: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~rtc-rtc-pxa-use-module_platform_driver_probe drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-rtc-pxa-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-pxa.c
@@ -452,18 +452,7 @@ static struct platform_driver pxa_rtc_dr
 	},
 };
 
-static int __init pxa_rtc_init(void)
-{
-	return platform_driver_probe(&pxa_rtc_driver, pxa_rtc_probe);
-}
-
-static void __exit pxa_rtc_exit(void)
-{
-	platform_driver_unregister(&pxa_rtc_driver);
-}
