From: akpm@linux-foundation.org
Subject: [merged] leds-ledtrig-timer-fix-broken-sysfs-delay-handling.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:46 -0700
Message-ID: <201109151936.p8FJakYK014375@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:14095 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab1IOThf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, florian@openwrt.org, richard.purdie@linuxfoundation.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/ledtrig-timer.c: fix broken sysfs delay handling
has been removed from the -mm tree.  Its filename was
     leds-ledtrig-timer-fix-broken-sysfs-delay-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@kernel.org>		[2.6.37+]
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

origin.patch
linux-next.patch

