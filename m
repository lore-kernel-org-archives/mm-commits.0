From: akpm@linux-foundation.org
Subject: + leds-ledtrig-timer-fix-broken-sysfs-delay-handling.patch added to -mm tree
Date: Tue, 06 Sep 2011 16:02:32 -0700
Message-ID: <201109062302.p86N2WO2010091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab1IFXCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 19:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhovold@gmail.com, florian@openwrt.org, richard.purdie@linuxfoundation.org, stable@kernel.org


The patch titled
     drivers/leds/ledtrig-timer.c: fix broken sysfs delay handling
has been added to the -mm tree.  Its filename is
     leds-ledtrig-timer-fix-broken-sysfs-delay-handling.patch

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
Subject: drivers/leds/ledtrig-timer.c: fix broken sysfs delay handling
From: Johan Hovold <jhovold@gmail.com>

Fix regression introduced by commit 5ada28bf7675 ("led-class: always
implement blinking") which broke sysfs delay handling by not storing the
updated value.  Consequently it was only possible to set one of the delays
through the sysfs interface as the other delay was automatically restored
to it's default value.  Reading the parameters always gave the defaults.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Florian Fainelli <florian@openwrt.org>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-timer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/leds/ledtrig-timer.c~leds-ledtrig-timer-fix-broken-sysfs-delay-handling drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-ledtrig-timer-fix-broken-sysfs-delay-handling
+++ a/drivers/leds/ledtrig-timer.c
@@ -41,6 +41,7 @@ static ssize_t led_delay_on_store(struct
 
 	if (count == size) {
 		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
+		led_cdev->blink_delay_on = state;
 		ret = count;
 	}
 
@@ -69,6 +70,7 @@ static ssize_t led_delay_off_store(struc
 
 	if (count == size) {
 		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
+		led_cdev->blink_delay_off = state;
 		ret = count;
 	}
 
_

Patches currently in -mm which might be from jhovold@gmail.com are

leds-ledtrig-timer-fix-broken-sysfs-delay-handling.patch
linux-next.patch

