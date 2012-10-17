From: akpm@linux-foundation.org
Subject: + backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:10:31 -0700
Message-ID: <20121017231031.9F3DF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56086 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2JQXKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:10:32 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so143335qae.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:10:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, mike@compulab.co.il, rpurdie@rpsys.net


The patch titled
     Subject: backlight: da903x_bl: use dev_get_drvdata() instead of platform_get_drvdata()
has been added to the -mm tree.  Its filename is
     backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: da903x_bl: use dev_get_drvdata() instead of platform_get_drvdata()

dev_get_drvdata() can be used instead of platform_get_drvdata()
to make the code smaller.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da903x_bl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata
+++ a/drivers/video/backlight/da903x_bl.c
@@ -164,15 +164,14 @@ static int da903x_backlight_remove(struc
 #ifdef CONFIG_PM
 static int da903x_backlight_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
+
 	return da903x_backlight_set(bl, 0);
 }
 
 static int da903x_backlight_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch

