From: akpm@linux-foundation.org
Subject: [merged] hp_accel-fix-race-in-device-removal.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:48 -0400
Message-ID: <201005121800.o4CI0Gon011585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab0ELSAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oneukum@suse.de, eric.piel@tremplin-utc.net, morpheus.ibis@gmail.com, pavel@ucw.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hp_accel: fix race in device removal
has been removed from the -mm tree.  Its filename was
     hp_accel-fix-race-in-device-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hp_accel: fix race in device removal
From: Oliver Neukum <oneukum@suse.de>

The work queue has to be flushed after the device has been made
inaccessible.  The patch closes a window during which a work queue might
remain active after the device is removed and would then lead to ACPI
calls with undefined behavior.

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

origin.patch

