From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-use-module_platform_driver.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:12 -0700
Message-ID: <20130430185412.6FD6531C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45738 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3D3SyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:13 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86543yha.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use module_platform_driver()
has been removed from the -mm tree.  Its filename was
     rtc-max77686-use-module_platform_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-max77686.c: use module_platform_driver()

Use module_platform_driver() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-module_platform_driver drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-module_platform_driver
+++ a/drivers/rtc/rtc-max77686.c
@@ -624,17 +624,7 @@ static struct platform_driver max77686_r
 	.id_table	= rtc_id,
 };
 
-static int __init max77686_rtc_init(void)
-{
-	return platform_driver_register(&max77686_rtc_driver);
-}
-module_init(max77686_rtc_init);
