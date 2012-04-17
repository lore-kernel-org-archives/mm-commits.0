From: akpm@linux-foundation.org
Subject: + leds-ledtrig-timer-trigger_data-allocation-fix.patch added to -mm tree
Date: Tue, 17 Apr 2012 16:12:57 -0700
Message-ID: <20120417231258.50E3BA018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:41739 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2DQXM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Apr 2012 19:12:59 -0400
Received: by vbnl22 with SMTP id l22so792793vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Apr 2012 16:12:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuahkhan@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: leds: ledtrig-timer trigger_data allocation fix
has been added to the -mm tree.  Its filename is
     leds-ledtrig-timer-trigger_data-allocation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuahkhan@gmail.com>
Subject: leds: ledtrig-timer trigger_data allocation fix

ledtrig-timer doesn't allocate memory for trigger_data and assigns (void
*)1 to save state.  Fix it to allocate int instead.  Note that non-null
trigger_data is used to key off of to do proper cleanup in deactivation
routine and not used during the life of the trigger itself.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-timer.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/leds/ledtrig-timer.c~leds-ledtrig-timer-trigger_data-allocation-fix drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-ledtrig-timer-trigger_data-allocation-fix
+++ a/drivers/leds/ledtrig-timer.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include "leds.h"
 
@@ -88,10 +89,14 @@ static void timer_trig_activate(struct l
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
 
-	led_cdev->trigger_data = (void *)1;
+	led_cdev->trigger_data = kzalloc(sizeof(int), GFP_KERNEL);
+	if (!led_cdev->trigger_data)
+		goto err_out_delayoff;
 
 	return;
 
+err_out_delayoff:
+	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
 err_out_delayon:
 	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 }
@@ -101,6 +106,7 @@ static void timer_trig_deactivate(struct
 	if (led_cdev->trigger_data) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		kfree(led_cdev->trigger_data);
 	}
 
 	/* Stop blinking */
_
Subject: Subject: leds: ledtrig-timer trigger_data allocation fix

Patches currently in -mm which might be from shuahkhan@gmail.com are

linux-next.patch
leds-add-led-driver-for-lm3556-chip.patch
leds-simple_strtoul-cleanup.patch
leds-ledtrig-timer-trigger_data-allocation-fix.patch
leds-ledtrig-timer-trigger_data-allocation-fix-fix.patch

