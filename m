From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:08 -0700
Message-ID: <20120712193609.25055200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58144 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab2GLTgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:11 -0400
Received: by eekd4 with SMTP id d4so88644eek.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, a.zummo@towertech.it, stable@vger.kernel.org, viresh.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()

`config' is freed and is then used in the rtc_device_unregister() call,
causing a kernel panic.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Reviewed-by: Viresh Kumar <viresh.linux@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-spear.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-spear.c~drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove
+++ a/drivers/rtc/rtc-spear.c
@@ -458,12 +458,12 @@ static int __devexit spear_rtc_remove(st
 	clk_disable(config->clk);
 	clk_put(config->clk);
 	iounmap(config->ioaddr);
-	kfree(config);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res)
 		release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(config->rtc);
+	kfree(config);
 
 	return 0;
 }
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-r9701c-avoid-second-call-to-rtc_valid_tm.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch

