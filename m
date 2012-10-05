From: akpm@linux-foundation.org
Subject: [merged] rtc-at91sam9-use-module_platform_driver-macro.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:45 -0700
Message-ID: <20121005201646.159BF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:60327 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2JEUQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:48 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so139620wey.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: develkernel412222@gmail.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-at91sam9.c: use module_platform_driver() macro
has been removed from the -mm tree.  Its filename was
     rtc-at91sam9-use-module_platform_driver-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <develkernel412222@gmail.com>
Subject: drivers/rtc/rtc-at91sam9.c: use module_platform_driver() macro

This driver does seems to do only platform_driver_register in the init
function and platform_driver_unregister in the exit function,

so replace all this code including the module_init and module_exit with
module_platform_driver macro...

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-use-module_platform_driver-macro drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-at91sam9-use-module_platform_driver-macro
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -473,18 +473,7 @@ static struct platform_driver at91_rtc_d
 	},
 };
 
-static int __init at91_rtc_init(void)
-{
-	return platform_driver_register(&at91_rtc_driver);
-}
-module_init(at91_rtc_init);
-
-static void __exit at91_rtc_exit(void)
-{
-	platform_driver_unregister(&at91_rtc_driver);
-}
-module_exit(at91_rtc_exit);
