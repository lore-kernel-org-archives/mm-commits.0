From: akpm@linux-foundation.org
Subject: + backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch added to -mm tree
Date: Wed, 28 Jul 2010 15:31:28 -0700
Message-ID: <201007282231.o6SMVSuB006241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756589Ab0G1WcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 18:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, inki.dae@samsung.com, rpurdie@rpsys.net


The patch titled
     backlight: s6e63m0: unregister backlight device and remove sysfs attribute file in s6e63m0_remove
has been added to the -mm tree.  Its filename is
     backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: s6e63m0: unregister backlight device and remove sysfs attribute file in s6e63m0_remove
From: Axel Lin <axel.lin@gmail.com>

s6e63m0_probe() registered backlight device and create sysfs attribute
files, thus s6e63m0_remove() should unregister backlight device and remove
sysfs attribute files.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
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
drivers-video-backlight-s6e63m0c-set-permissions-on-gamma_table-file-to-0444.patch
backlight-s6e63m0-unregister-backlight-device-and-remove-sysfs-attribute-file-in-s6e63m0_remove.patch
s6e63m0-fix-section-mismatch.patch
edd-fix-possible-memory-leak-in-edd_init-error-path.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch

