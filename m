From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-davinci-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:38 -0700
Message-ID: <20130430185438.6E55931C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:58016 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691Ab3D3Syj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:39 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86655qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-davinci: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-davinci-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-davinci: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-module_platform_driver_probe drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-davinci.c
@@ -588,17 +588,7 @@ static struct platform_driver davinci_rt
 	},
 };
 
-static int __init rtc_init(void)
-{
-	return platform_driver_probe(&davinci_rtc_driver, davinci_rtc_probe);
-}
-module_init(rtc_init);
