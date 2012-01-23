From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp5520_blc-use-devm_-functions.patch added to -mm tree
Date: Mon, 23 Jan 2012 13:21:28 -0800
Message-ID: <20120123212128.98BCA10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:43618 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2AWVV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 16:21:29 -0500
Received: by ghbg20 with SMTP id g20so295708ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 13:21:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/adp5520_bl.c: use devm_ functions
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp5520_blc-use-devm_-functions.patch

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
Subject: drivers/video/backlight/adp5520_bl.c: use devm_ functions

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp5520_bl.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-use-devm_-functions drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-use-devm_-functions
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -289,7 +289,7 @@ static int __devinit adp5520_bl_probe(st
 	struct adp5520_bl *data;
 	int ret = 0;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -298,7 +298,6 @@ static int __devinit adp5520_bl_probe(st
 
 	if (data->pdata  == NULL) {
 		dev_err(&pdev->dev, "missing platform data\n");
-		kfree(data);
 		return -ENODEV;
 	}
 
@@ -314,7 +313,6 @@ static int __devinit adp5520_bl_probe(st
 				       &adp5520_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 
@@ -326,7 +324,6 @@ static int __devinit adp5520_bl_probe(st
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register sysfs\n");
 		backlight_device_unregister(bl);
-		kfree(data);
 	}
 
 	platform_set_drvdata(pdev, bl);
@@ -348,7 +345,6 @@ static int __devexit adp5520_bl_remove(s
 				&adp5520_bl_attr_group);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 
 	return 0;
 }
_
Subject: Subject: drivers/video/backlight/adp5520_bl.c: use devm_ functions

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

linux-next.patch
drivers-video-backlight-wm831x_blc-use-devm_-functions.patch
drivers-video-backlight-use-devm_-functions.patch
drivers-video-backlight-adp5520_blc-use-devm_-functions.patch

