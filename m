From: akpm@linux-foundation.org
Subject: [folded-merged] backlight-add-lms501kf03-lcd-driver-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:19:44 -0800
Message-ID: <20130221231945.15F8F31C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:61193 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3BUXTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:19:46 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so10310yen.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:19:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Ilho215.lee@samsung.com, devendra.aaru@gmail.com, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-lms501kf03-lcd-driver-fix
has been removed from the -mm tree.  Its filename was
     backlight-add-lms501kf03-lcd-driver-fix.patch

This patch was dropped because it was folded into backlight-add-lms501kf03-lcd-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-add-lms501kf03-lcd-driver-fix

remove unused variable `before_power'

Cc: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Ilho Lee <Ilho215.lee@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms501kf03.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/video/backlight/lms501kf03.c~backlight-add-lms501kf03-lcd-driver-fix drivers/video/backlight/lms501kf03.c
--- a/drivers/video/backlight/lms501kf03.c~backlight-add-lms501kf03-lcd-driver-fix
+++ a/drivers/video/backlight/lms501kf03.c
@@ -388,7 +388,6 @@ static int lms501kf03_remove(struct spi_
 }
 
 #if defined(CONFIG_PM)
-static unsigned int before_power;
 
 static int lms501kf03_suspend(struct spi_device *spi, pm_message_t mesg)
 {
@@ -396,8 +395,6 @@ static int lms501kf03_suspend(struct spi
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
-	before_power = lcd->power;
