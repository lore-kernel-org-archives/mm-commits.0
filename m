From: akpm@linux-foundation.org
Subject: + backlight-new-backlight-driver-for-lp855x-devices-fix.patch added to -mm tree
Date: Wed, 01 Feb 2012 13:02:41 -0800
Message-ID: <20120201210241.9B625A02E6@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48379 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2BAVCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 16:02:43 -0500
Received: by eaae13 with SMTP id e13so25543eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 13:02:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com


The patch titled
     Subject: backlight: lp855x_bl: Add missing mutex_unlock in lp855x_read_byte error path
has been added to the -mm tree.  Its filename is
     backlight-new-backlight-driver-for-lp855x-devices-fix.patch

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
Subject: backlight: lp855x_bl: Add missing mutex_unlock in lp855x_read_byte error path

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-new-backlight-driver-for-lp855x-devices-fix drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-new-backlight-driver-for-lp855x-devices-fix
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -41,6 +41,7 @@ static int lp855x_read_byte(struct lp855
 	mutex_lock(&lp->xfer_lock);
 	ret = i2c_smbus_read_byte_data(lp->client, reg);
 	if (ret < 0) {
+		mutex_unlock(&lp->xfer_lock);
 		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
 		return ret;
 	}
_
Subject: Subject: backlight: lp855x_bl: Add missing mutex_unlock in lp855x_read_byte error path

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices-fix.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

