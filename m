From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mc13xxx-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:51 -0700
Message-ID: <20130430185451.6CAA431C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:37221 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Syw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:52 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77222veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mc13xxx: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mc13xxx-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-mc13xxx: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-use-module_platform_driver_probe drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-rtc-mc13xxx-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -420,17 +420,7 @@ static struct platform_driver mc13xxx_rt
 	},
 };
 
-static int __init mc13xxx_rtc_init(void)
-{
-	return platform_driver_probe(&mc13xxx_rtc_driver, &mc13xxx_rtc_probe);
-}
-module_init(mc13xxx_rtc_init);
