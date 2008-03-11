From: akpm@linux-foundation.org
Subject: - bf54x-lq043-framebuffer-driver-fix-bug-lcd_device_register-api-breakage.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:46 -0700
Message-ID: <200803110322.m2B3Mkhv019837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220AbYCKDWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     BF54x LQ043 Framebuffer driver: fix bug lcd_device_register API breakage
has been removed from the -mm tree.  Its filename was
     bf54x-lq043-framebuffer-driver-fix-bug-lcd_device_register-api-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BF54x LQ043 Framebuffer driver: fix bug lcd_device_register API breakage
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/bf54x-lq043fb.c~bf54x-lq043-framebuffer-driver-fix-bug-lcd_device_register-api-breakage drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~bf54x-lq043-framebuffer-driver-fix-bug-lcd_device_register-api-breakage
+++ a/drivers/video/bf54x-lq043fb.c
@@ -672,7 +672,7 @@ static int __init bfin_bf54x_probe(struc
 				      &bfin_lq043fb_bl_ops);
 	bl_dev->props.max_brightness = 255;
 
-	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
+	lcd_dev = lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lcd_ops);
 	lcd_dev->props.max_contrast = 255, printk(KERN_INFO "Done.\n");
 #endif
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
blackfin-replace-remaining-__function__-occurences.patch
remove-the-macro-get_personality.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch

