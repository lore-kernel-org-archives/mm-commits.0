From: akpm@linux-foundation.org
Subject: + leds-support-automatic-start-of-blinking-with-ledtrig-timer-fix.patch added to -mm tree
Date: Tue, 10 May 2011 16:13:48 -0700
Message-ID: <201105102313.p4ANDmBK028201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253Ab1EJXOY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 19:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eha@doredevelopment.dk, rdunlap@xenotime.net


The patch titled
     leds: fix build with CONFIG_LEDS_TRIGGERS disabled
has been added to the -mm tree.  Its filename is
     leds-support-automatic-start-of-blinking-with-ledtrig-timer-fix.patch

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
Subject: leds: fix build with CONFIG_LEDS_TRIGGERS disabled
From: Esben Haabendal <eha@doredevelopment.dk>

Add led_get_trigger_data() function for stubbing out access to
trigger_data when CONFIG_LEDS_TRIGGERS is disabled.  This fixes builds
with CONFIG_LEDS_CLASS enabled, which were broken by
leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch

Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c |    2 +-
 drivers/leds/leds.h      |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/leds/led-class.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer-fix drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-support-automatic-start-of-blinking-with-ledtrig-timer-fix
+++ a/drivers/leds/led-class.c
@@ -131,7 +131,7 @@ static void led_set_software_blink(struc
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (led_cdev->trigger_data &&
+	if (led_get_trigger_data(led_cdev) &&
 	    delay_on == led_cdev->blink_delay_on &&
 	    delay_off == led_cdev->blink_delay_off)
 		return;
diff -puN drivers/leds/leds.h~leds-support-automatic-start-of-blinking-with-ledtrig-timer-fix drivers/leds/leds.h
--- a/drivers/leds/leds.h~leds-support-automatic-start-of-blinking-with-ledtrig-timer-fix
+++ a/drivers/leds/leds.h
@@ -40,10 +40,17 @@ void led_trigger_set_default(struct led_
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
 void led_trigger_remove(struct led_classdev *led_cdev);
+
+static inline void *led_get_trigger_data(struct led_classdev *led_cdev)
+{
+	return led_cdev->trigger_data;
+}
+
 #else
 #define led_trigger_set_default(x) do {} while (0)
 #define led_trigger_set(x, y) do {} while (0)
 #define led_trigger_remove(x) do {} while (0)
+#define led_get_trigger_data(x) (NULL)
 #endif
 
 ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
_

Patches currently in -mm which might be from eha@doredevelopment.dk are

leds-support-automatic-start-of-blinking-with-ledtrig-timer.patch
leds-support-automatic-start-of-blinking-with-ledtrig-timer-fix.patch

