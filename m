From: akpm@linux-foundation.org
Subject: + hp_accel-fix-race-in-device-removal.patch added to -mm tree
Date: Mon, 10 May 2010 15:47:22 -0700
Message-ID: <201005102247.o4AMlMhH027212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757242Ab0EJWsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oneukum@suse.de, eric.piel@tremplin-utc.net, morpheus.ibis@gmail.com, pavel@ucw.cz, stable@kernel.org


The patch titled
     hp_accel: fix race in device removal
has been added to the -mm tree.  Its filename is
     hp_accel-fix-race-in-device-removal.patch

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
Subject: hp_accel: fix race in device removal
From: Oliver Neukum <oneukum@suse.de>

The work queue has to be flushed after the device has been made
inaccessible.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Herrmann <morpheus.ibis@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hp_accel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/hp_accel.c~hp_accel-fix-race-in-device-removal drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp_accel-fix-race-in-device-removal
+++ a/drivers/hwmon/hp_accel.c
@@ -328,8 +328,8 @@ static int lis3lv02d_remove(struct acpi_
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(&lis3_dev);
 
-	flush_work(&hpled_led.work);
 	led_classdev_unregister(&hpled_led.led_classdev);
+	flush_work(&hpled_led.work);
 
 	return lis3lv02d_remove_fs(&lis3_dev);
 }
_

Patches currently in -mm which might be from oneukum@suse.de are

hp_accel-fix-race-in-device-removal.patch

