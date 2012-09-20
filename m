From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data.patch added to -mm tree
Date: Thu, 20 Sep 2012 13:05:19 -0700
Message-ID: <20120920200520.03000200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:59842 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2ITUFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 16:05:22 -0400
Received: by wibhr14 with SMTP id hr14so73786wib.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 13:05:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, FlorianSchandinat@gmx.de, jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/da9052_bl.c: drop devm_kfree of devm_kzalloc'd data
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-video-backlight-da9052_blc-drop-devm_kfree-of-devm_kzallocd-data.patch
drivers-rtc-rtc-coh901331c-use-clk_prepare_enable-and-clk_disable_unprepare.patch

