From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-wm831x_blc-use-devm_-functions.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:54 -0700
Message-ID: <20120326192854.9CB15A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34884 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2CZT24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:56 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so288078lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/wm831x_bl.c: use devm_ functions
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-wm831x_blc-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: drivers/video/backlight/wm831x_bl.c: use devm_ functions

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/wm831x_bl.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/video/backlight/wm831x_bl.c~drivers-video-backlight-wm831x_blc-use-devm_-functions drivers/video/backlight/wm831x_bl.c
--- a/drivers/video/backlight/wm831x_bl.c~drivers-video-backlight-wm831x_blc-use-devm_-functions
+++ a/drivers/video/backlight/wm831x_bl.c
@@ -186,7 +186,7 @@ static int wm831x_backlight_probe(struct
 	if (ret < 0)
 		return ret;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -200,7 +200,6 @@ static int wm831x_backlight_probe(struct
 				       &wm831x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 
@@ -211,7 +210,6 @@ static int wm831x_backlight_probe(struct
 	/* Disable the DCDC if it was started so we can bootstrap */
 	wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, WM831X_DC4_ENA, 0);
 
