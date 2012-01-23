From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-return-proper-error-in-l4f00242t03_probe-if-regulator_get-fails.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:33 -0800
Message-ID: <20120123202134.2331220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:40145 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab2AWUVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:36 -0500
Received: by wgbgn7 with SMTP id gn7so88864wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, alberto@amarulasolutions.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: return proper error in l4f00242t03_probe if regulator_get() fails
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-return-proper-error-in-l4f00242t03_probe-if-regulator_get-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/video/backlight/l4f00242t03.c: return proper error in l4f00242t03_probe if regulator_get() fails

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Alberto Panizzo <alberto@amarulasolutions.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-return-proper-error-in-l4f00242t03_probe-if-regulator_get-fails drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-return-proper-error-in-l4f00242t03_probe-if-regulator_get-fails
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -190,6 +190,7 @@ static int __devinit l4f00242t03_probe(s
 
 	priv->io_reg = regulator_get(&spi->dev, "vdd");
 	if (IS_ERR(priv->io_reg)) {
+		ret = PTR_ERR(priv->io_reg);
 		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
 		       __func__);
 		goto err3;
@@ -197,6 +198,7 @@ static int __devinit l4f00242t03_probe(s
 
 	priv->core_reg = regulator_get(&spi->dev, "vcore");
 	if (IS_ERR(priv->core_reg)) {
+		ret = PTR_ERR(priv->core_reg);
 		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
 		       __func__);
 		goto err4;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

