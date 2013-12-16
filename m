From: akpm@linux-foundation.org
Subject: + backlight-lcd-call-put_device-if-device_register-fails.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 15:17:49 -0800
Message-ID: <52af8a1d.9lps6d04rj+IG3DA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3LPXRu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 18:17:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, levex@linux.com

Subject: + backlight-lcd-call-put_device-if-device_register-fails.patch added to -mm tree
To: levex@linux.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 15:17:49 -0800


The patch titled
     Subject: drivers/video/backlight/lcd.c: call put_device if device_register fails
has been added to the -mm tree.  Its filename is
     backlight-lcd-call-put_device-if-device_register-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lcd-call-put_device-if-device_register-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lcd-call-put_device-if-device_register-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kstrtox-remove-redundant-cleanup.patch
lib-cmdlinec-declare-exported-symbols-immediately.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch
net-phy-call-put_device-on-device_register-failure.patch
eisa-call-put_device-if-device_register-fails.patch
w1-call-put_device-if-device_register-fails.patch

