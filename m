From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-wm831x_blc-use-devm_-functions.patch added to -mm tree
Date: Mon, 23 Jan 2012 13:21:19 -0800
Message-ID: <20120123212120.AD2A420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48885 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab2AWVVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 16:21:23 -0500
Received: by eekb15 with SMTP id b15so141524eek.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 13:21:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, FlorianSchandinat@gmx.de, broonie@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/wm831x_bl.c: use devm_ functions
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-wm831x_blc-use-devm_-functions.patch

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
 
