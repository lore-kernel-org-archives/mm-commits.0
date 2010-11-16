From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:57 -0800
Message-ID: <201011161934.oAGJY9Ea003181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452Ab0KPTel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, inki.dae@samsung.com, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/s6e63m0.c: unregister backlight device and remove sysfs attribute file in s6e63m0_remove
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/s6e63m0.c: unregister backlight device and remove sysfs attribute file in s6e63m0_remove
From: Axel Lin <axel.lin@gmail.com>

s6e63m0_probe() registered backlight device and create sysfs attribute
files, thus s6e63m0_remove() should unregister backlight device and remove
sysfs attribute files.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Cc: InKi Dae <inki.dae@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove
+++ a/drivers/video/backlight/s6e63m0.c
@@ -829,6 +829,9 @@ static int __devexit s6e63m0_remove(stru
 	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
 
 	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
+	device_remove_file(&spi->dev, &dev_attr_gamma_table);
+	device_remove_file(&spi->dev, &dev_attr_gamma_mode);
+	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
 	kfree(lcd);
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-rtc-rtc-omapc-fix-a-memory-leak.patch

