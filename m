From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1216-use-module_platform_driver_probe.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:23 -0700
Message-ID: <51db147b.QLQlG0+AWFSi2Bc0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3GHTfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, fabio.porcedda@gmail.com

Subject: [merged] rtc-rtc-ds1216-use-module_platform_driver_probe.patch removed from -mm tree
To: fabio.porcedda@gmail.com,a.zummo@towertech.it,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:23 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1216.c: use module_platform_driver_probe()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1216-use-module_platform_driver_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: drivers/rtc/rtc-ds1216.c: use module_platform_driver_probe()

Use module_platform_driver_probe() macro which makes the code smaller and
simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1216.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-ds1216.c~rtc-rtc-ds1216-use-module_platform_driver_probe drivers/rtc/rtc-ds1216.c
--- a/drivers/rtc/rtc-ds1216.c~rtc-rtc-ds1216-use-module_platform_driver_probe
+++ a/drivers/rtc/rtc-ds1216.c
@@ -174,21 +174,10 @@ static struct platform_driver ds1216_rtc
 	},
 };
 
-static int __init ds1216_rtc_init(void)
-{
-	return platform_driver_probe(&ds1216_rtc_platform_driver, ds1216_rtc_probe);
-}
-
-static void __exit ds1216_rtc_exit(void)
-{
-	platform_driver_unregister(&ds1216_rtc_platform_driver);
-}
+module_platform_driver_probe(ds1216_rtc_platform_driver, ds1216_rtc_probe);
 
 MODULE_AUTHOR("Thomas Bogendoerfer <tsbogend@alpha.franken.de>");
 MODULE_DESCRIPTION("DS1216 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:rtc-ds1216");
