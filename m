From: akpm@linux-foundation.org
Subject: + leds-after-setting-inverted-attribute-we-must-update-the-led.patch added to -mm tree
Date: Tue, 28 Jul 2009 15:35:31 -0700
Message-ID: <200907282235.n6SMZVpe000566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753306AbZG1WgB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 18:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, rpurdie@rpsys.net, srcvale@holoscopio.com


The patch titled
     leds: after setting inverted attribute, we must update the LED
has been added to the -mm tree.  Its filename is
     leds-after-setting-inverted-attribute-we-must-update-the-led.patch

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
Subject: leds: after setting inverted attribute, we must update the LED
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

If we change the inverted attribute to another value, the LED will not be
inverted until we change the GPIO state.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Samuel R. C. Vale <srcvale@holoscopio.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-gpio.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/leds/ledtrig-gpio.c~leds-after-setting-inverted-attribute-we-must-update-the-led drivers/leds/ledtrig-gpio.c
--- a/drivers/leds/ledtrig-gpio.c~leds-after-setting-inverted-attribute-we-must-update-the-led
+++ a/drivers/leds/ledtrig-gpio.c
@@ -117,6 +117,9 @@ static ssize_t gpio_trig_inverted_store(
 
 	gpio_data->inverted = !!inverted;
 
+	/* After inverting, we need to update the LED. */
+	schedule_work(&gpio_data->work);
+
 	return n;
 }
 static DEVICE_ATTR(inverted, 0644, gpio_trig_inverted_show,
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

rtc-mark-if-rtc-cmos-drivers-were-successfully-registered.patch
linux-next.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio-checkpatch-fixes.patch
leds-fix-multiple-requests-and-releases-of-irq-for-gpio-led-trigger.patch
leds-after-setting-inverted-attribute-we-must-update-the-led.patch

