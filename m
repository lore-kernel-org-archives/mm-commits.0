From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-l4f00242t03c-return-proper-error-in-l4f00242t03_probe-if-regulator_get-fails.patch added to -mm tree
Date: Fri, 13 Jan 2012 14:26:21 -0800
Message-ID: <20120113222622.016AF200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48453 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab2AMW0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 17:26:24 -0500
Received: by eaad12 with SMTP id d12so28054eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 14:26:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, alberto@amarulasolutions.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: return proper error in l4f00242t03_probe if regulator_get() fails
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-l4f00242t03c-return-proper-error-in-l4f00242t03_probe-if-regulator_get-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/video/backlight/l4f00242t03.c: return proper error in l4f00242t03_probe if regulator_get() fails

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-adp88x0_blc-fix-bit-testing-logic.patch
drivers-video-backlight-l4f00242t03c-return-proper-error-in-l4f00242t03_probe-if-regulator_get-fails.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch

