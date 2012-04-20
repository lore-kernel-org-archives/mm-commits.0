From: akpm@linux-foundation.org
Subject: + leds-change-ledtrig-timer-to-use-activated-flag.patch added to -mm tree
Date: Fri, 20 Apr 2012 14:02:41 -0700
Message-ID: <20120420210242.1E83DA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:50051 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2DTVCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 17:02:44 -0400
Received: by wejx9 with SMTP id x9so478174wej.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 14:02:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuahkhan@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: leds: change ledtrig-timer to use activated flag
has been added to the -mm tree.  Its filename is
     leds-change-ledtrig-timer-to-use-activated-flag.patch

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
Subject: leds: change ledtrig-timer to use activated flag

Change existing timer trigger to use the new ->activated flag to set
activate successful status in activate routine and check it in deactivate
routine to do cleanup.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-timer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/ledtrig-timer.c~leds-change-ledtrig-timer-to-use-activated-flag drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-change-ledtrig-timer-to-use-activated-flag
+++ a/drivers/leds/ledtrig-timer.c
@@ -87,8 +87,7 @@ static void timer_trig_activate(struct l
 
 	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
 		      &led_cdev->blink_delay_off);
-
-	led_cdev->trigger_data = (void *)1;
+	led_cdev->activated = true;
 
 	return;
 
@@ -98,9 +97,10 @@ err_out_delayon:
 
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
 {
-	if (led_cdev->trigger_data) {
+	if (led_cdev->activated) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		led_cdev->activated = false;
 	}
 
 	/* Stop blinking */
_
Subject: Subject: leds: change ledtrig-timer to use activated flag

Patches currently in -mm which might be from shuahkhan@gmail.com are

linux-next.patch
leds-add-led-driver-for-lm3556-chip.patch
leds-simple_strtoul-cleanup.patch
leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch
leds-change-existing-triggers-to-use-activated-flag.patch
leds-change-ledtrig-timer-to-use-activated-flag.patch

