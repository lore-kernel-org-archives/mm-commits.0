From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1302-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:40 -0700
Message-ID: <20130430185440.7359F5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41254 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Syl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:41 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86417yhz.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1302: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1302-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1302: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-use-module_platform_driver_probe drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-ds1302.c
@@ -252,18 +252,7 @@ static struct platform_driver ds1302_pla
 	.remove		= __exit_p(ds1302_rtc_remove),
 };
 
-static int __init ds1302_rtc_init(void)
-{
-	return platform_driver_probe(&ds1302_platform_driver, ds1302_rtc_probe);
-}
-
-static void __exit ds1302_rtc_exit(void)
-{
-	platform_driver_unregister(&ds1302_platform_driver);
-}
