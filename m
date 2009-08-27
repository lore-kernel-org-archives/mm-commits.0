From: akpm@linux-foundation.org
Subject: [merged] leds-after-setting-inverted-attribute-we-must-update-the-led.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:40 -0700
Message-ID: <200908271918.n7RJIeLN010721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbZH0TSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, rpurdie@rpsys.net, srcvale@holoscopio.com, mm-commits@vger.kernel.org


The patch titled
     leds: after setting inverted attribute, we must update the LED
has been removed from the -mm tree.  Its filename was
     leds-after-setting-inverted-attribute-we-must-update-the-led.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch

