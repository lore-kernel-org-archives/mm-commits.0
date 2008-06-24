From: akpm@linux-foundation.org
Subject: + fb-add-support-for-the-ili9320-video-display-controller-fix.patch added to -mm tree
Date: Tue, 24 Jun 2008 13:52:06 -0700
Message-ID: <200806242052.m5OKq65D005447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291AbYFXUwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 16:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     ili9320: ensure resource cleanup on exit
has been added to the -mm tree.  Its filename is
     fb-add-support-for-the-ili9320-video-display-controller-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ili9320: ensure resource cleanup on exit
From: Ben Dooks <ben-linux@fluff.org>

Ensure we free our 'struct ili9320' on exit or error.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~fb-add-support-for-the-ili9320-video-display-controller-fix drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~fb-add-support-for-the-ili9320-video-display-controller-fix
+++ a/drivers/video/backlight/ili9320.c
@@ -259,18 +259,19 @@ int __devinit ili9320_probe_spi(struct s
 	lcd_device_unregister(lcd);
 
  err_free:
-	kfree(lcd);
+	kfree(ili);
+
 	return ret;
 }
 
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
-int __devexit ili9320_remove(struct ili9320 *lcd)
+int __devexit ili9320_remove(struct ili9320 *ili)
 {
-	ili9320_power(lcd, FB_BLANK_POWERDOWN);
+	ili9320_power(ili, FB_BLANK_POWERDOWN);
 
-	lcd_device_unregister(lcd->lcd);
-	kfree(lcd);
+	lcd_device_unregister(ili->lcd);
+	kfree(ili);
 
 	return 0;
 }
_

Patches currently in -mm which might be from ben-linux@fluff.org are

sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

