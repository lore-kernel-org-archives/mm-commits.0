From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-twlc-cleanup-with-module_platform_driver-conversion.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:10 -0700
Message-ID: <51db146e.lUKtZsom6kS1Hj6L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3GHTfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khilman@linaro.org, peter.ujfalusi@ti.com

Subject: [merged] drivers-rtc-rtc-twlc-cleanup-with-module_platform_driver-conversion.patch removed from -mm tree
To: peter.ujfalusi@ti.com,khilman@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:10 -0700


The patch titled
     Subject: drivers/rtc/rtc-twl.c: cleanup with module_platform_driver() conversion
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-cleanup-with-module_platform_driver-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: drivers/rtc/rtc-twl.c: cleanup with module_platform_driver() conversion

Use module_platform_driver() to register the platform driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-cleanup-with-module_platform_driver-conversion drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-cleanup-with-module_platform_driver-conversion
+++ a/drivers/rtc/rtc-twl.c
@@ -626,17 +626,7 @@ static struct platform_driver twl4030rtc
 	},
 };
 
-static int __init twl_rtc_init(void)
-{
-	return platform_driver_register(&twl4030rtc_driver);
-}
-module_init(twl_rtc_init);
