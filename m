From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove.patch added to -mm tree
Date: Wed, 20 Jun 2012 14:48:00 -0700
Message-ID: <20120620214800.8AF72A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62002 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2FTVsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 17:48:01 -0400
Received: by qabg24 with SMTP id g24so140408qab.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 14:48:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, stable@vger.kernel.org, viresh.linux@gmail.com


The patch titled
     Subject: drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/rtc-spear.c: fix use-after-free in spear_rtc_remove()

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove.patch

