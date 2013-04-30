From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-generic-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:46 -0700
Message-ID: <20130430185446.7198C31C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:35794 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Syr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:47 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86640vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-generic: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-generic-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-generic: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-generic.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-generic.c~rtc-rtc-generic-use-module_platform_driver_probe drivers/rtc/rtc-generic.c
--- a/drivers/rtc/rtc-generic.c~rtc-rtc-generic-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-generic.c
@@ -65,18 +65,7 @@ static struct platform_driver generic_rt
 	.remove = __exit_p(generic_rtc_remove),
 };
 
-static int __init generic_rtc_init(void)
-{
-	return platform_driver_probe(&generic_rtc_driver, generic_rtc_probe);
-}
-
-static void __exit generic_rtc_fini(void)
-{
-	platform_driver_unregister(&generic_rtc_driver);
-}
