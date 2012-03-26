From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp5520_blc-use-devm_-functions.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:58 -0700
Message-ID: <20120326192858.7EDABA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37807 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2CZT27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:59 -0400
Received: by mail-ey0-f202.google.com with SMTP id q10so289891eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp5520_bl.c: use devm_ functions
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp5520_blc-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

origin.patch
linux-next.patch
libfs-add-simple_open.patch
scripts-coccinelle-api-simple_opencocci-semantic-patch-for-simple_open.patch
simple_open-automatically-convert-to-simple_open.patch

