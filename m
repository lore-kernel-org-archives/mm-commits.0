From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:32:22 -0800
Message-ID: <20120111213222.9B4AC100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:61363 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2AKVcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:32:23 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134903ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:32:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, plagnioj@jcrosoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-wm831x.c: convert to devm_kzalloc()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: drivers/rtc/rtc-wm831x.c: convert to devm_kzalloc()

Marginally less code and eliminate the possibility of memory leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm831x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc
+++ a/drivers/rtc/rtc-wm831x.c
@@ -399,7 +399,7 @@ static int wm831x_rtc_probe(struct platf
 	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 	int ret = 0;
 
-	wm831x_rtc = kzalloc(sizeof(*wm831x_rtc), GFP_KERNEL);
+	wm831x_rtc = devm_kzalloc(&pdev->dev, sizeof(*wm831x_rtc), GFP_KERNEL);
 	if (wm831x_rtc == NULL)
 		return -ENOMEM;
 
@@ -434,7 +434,6 @@ static int wm831x_rtc_probe(struct platf
 	return 0;
 
 err:
-	kfree(wm831x_rtc);
 	return ret;
 }
 
@@ -445,7 +444,6 @@ static int __devexit wm831x_rtc_remove(s
 
 	free_irq(alm_irq, wm831x_rtc);
 	rtc_device_unregister(wm831x_rtc->rtc);
-	kfree(wm831x_rtc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

