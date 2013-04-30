From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sh-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:55:13 -0700
Message-ID: <20130430185513.72AA131C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:56000 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206Ab3D3SzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:55:14 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88052qad.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:55:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-sh: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sh-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sh: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sh.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-sh.c~rtc-rtc-sh-use-module_platform_driver_probe drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-rtc-sh-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-sh.c
@@ -820,18 +820,7 @@ static struct platform_driver sh_rtc_pla
 	.remove		= __exit_p(sh_rtc_remove),
 };
 
-static int __init sh_rtc_init(void)
-{
-	return platform_driver_probe(&sh_rtc_platform_driver, sh_rtc_probe);
-}
-
-static void __exit sh_rtc_exit(void)
-{
-	platform_driver_unregister(&sh_rtc_platform_driver);
-}
