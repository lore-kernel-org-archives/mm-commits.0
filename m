From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:09 -0700
Message-ID: <20121005201509.B753F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:64872 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:10 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so172294yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, FlorianSchandinat@gmx.de, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/da9052_bl.c: drop devm_kfree of devm_kzalloc'd data
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: drivers/video/backlight/da9052_bl.c: drop devm_kfree of devm_kzalloc'd data

devm_kfree should not have to be explicitly used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,d;
@@

x = devm_kzalloc(...)
...
?-devm_kfree(d,x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da9052_bl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data drivers/video/backlight/da9052_bl.c
--- a/drivers/video/backlight/da9052_bl.c~drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data
+++ a/drivers/video/backlight/da9052_bl.c
@@ -129,7 +129,6 @@ static int da9052_backlight_probe(struct
 				       &da9052_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "Failed to register backlight\n");
-		devm_kfree(&pdev->dev, wleds);
 		return PTR_ERR(bl);
 	}
 
@@ -149,7 +148,6 @@ static int da9052_backlight_remove(struc
 	wleds->state = DA9052_WLEDS_OFF;
 	da9052_adjust_wled_brightness(wleds);
 	backlight_device_unregister(bl);
-	devm_kfree(&pdev->dev, wleds);
 
 	return 0;
 }
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

origin.patch
linux-next.patch

