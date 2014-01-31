From: akpm@linux-foundation.org
Subject: [merged]
 backlight-lcd-call-put_device-if-device_register-fails.patch removed from
 -mm tree
Date: Fri, 31 Jan 2014 11:15:59 -0800
Message-ID: <52ebf66f.kAXATQPuG42X5EDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbaAaTP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:15:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, levex@linux.com

Subject: [merged] backlight-lcd-call-put_device-if-device_register-fails.patch removed from -mm tree
To: levex@linux.com,jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:15:59 -0800


The patch titled
     Subject: drivers/video/backlight/lcd.c: call put_device if device_register fails
has been removed from the -mm tree.  Its filename was
     backlight-lcd-call-put_device-if-device_register-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Levente Kurusa <levex@linux.com>
Subject: drivers/video/backlight/lcd.c: call put_device if device_register fails

Currently we kfree the container of the device which failed to register. 
This is wrong as the last reference is not given up with a put_device
call.  Also, now that we have put_device() callen, we no longer need the
kfree as the new_ld->dev.release function will take care of kfreeing the
associated memory.

Signed-off-by: Levente Kurusa <levex@linux.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lcd.c~backlight-lcd-call-put_device-if-device_register-fails drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-lcd-call-put_device-if-device_register-fails
+++ a/drivers/video/backlight/lcd.c
@@ -228,7 +228,7 @@ struct lcd_device *lcd_device_register(c
 
 	rc = device_register(&new_ld->dev);
 	if (rc) {
-		kfree(new_ld);
+		put_device(&new_ld->dev);
 		return ERR_PTR(rc);
 	}
 
_

Patches currently in -mm which might be from levex@linux.com are

origin.patch
w1-call-put_device-if-device_register-fails.patch

