From: akpm@linux-foundation.org
Subject: + rtc-rtc-ds1216-use-module_platform_driver_probe.patch added to
 -mm tree
Date: Tue, 02 Jul 2013 16:06:28 -0700
Message-ID: <51d35cf4.f+lmE5iMC678bLXG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3GBXG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 19:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, a.zummo@towertech.it, fabio.porcedda@gmail.com

Subject: + rtc-rtc-ds1216-use-module_platform_driver_probe.patch added to -mm tree
To: fabio.porcedda@gmail.com,a.zummo@towertech.it,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 16:06:28 -0700


The patch titled
     Subject: drivers/rtc/rtc-ds1216.c: use module_platform_driver_probe()
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds1216-use-module_platform_driver_probe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-ds1216-use-module_platform_driver_probe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-ds1216-use-module_platform_driver_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
