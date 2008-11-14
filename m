From: akpm@linux-foundation.org
Subject: + leds-add-wm8350-led-driver-fix.patch added to -mm tree
Date: Fri, 14 Nov 2008 15:19:53 -0800
Message-ID: <200811142319.mAENJrvM018923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbYKNXUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 18:20:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk, rpurdie@linux.intel.com, rpurdie@rpsys.net


The patch titled
     leds: fix locking for WM8350
has been added to the -mm tree.  Its filename is
     leds-add-wm8350-led-driver-fix.patch

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
Subject: leds: fix locking for WM8350
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

LED API functions aren't allowed to sleep so we can't take a lock when
setting the brightness of the LED.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-wm8350.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/leds/leds-wm8350.c~leds-add-wm8350-led-driver-fix drivers/leds/leds-wm8350.c
--- a/drivers/leds/leds-wm8350.c~leds-add-wm8350-led-driver-fix
+++ a/drivers/leds/leds-wm8350.c
@@ -170,10 +170,7 @@ static void wm8350_led_set(struct led_cl
 {
 	struct wm8350_led *led = to_wm8350_led(led_cdev);
 
-	mutex_lock(&led->mutex);
 	led->value = value;
-	mutex_unlock(&led->mutex);
