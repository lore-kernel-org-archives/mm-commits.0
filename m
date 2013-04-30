From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-at91rm9200-use-module_platform_driver_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:54:31 -0700
Message-ID: <20130430185431.6F67E5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:33318 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab3D3Syc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:54:32 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77192veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:54:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-at91rm9200: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at91rm9200-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-at91rm9200: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-use-module_platform_driver_probe drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -390,18 +390,7 @@ static struct platform_driver at91_rtc_d
 	},
 };
 
-static int __init at91_rtc_init(void)
-{
-	return platform_driver_probe(&at91_rtc_driver, at91_rtc_probe);
-}
-
-static void __exit at91_rtc_exit(void)
-{
-	platform_driver_unregister(&at91_rtc_driver);
-}
