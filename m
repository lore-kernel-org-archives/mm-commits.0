From: akpm@linux-foundation.org
Subject: - leds-ledtrig-timer-on-deactivation-hardware-blinking-should-be-disabled.patch removed from -mm tree
Date: Fri, 09 Jan 2009 11:58:51 -0800
Message-ID: <200901091958.n09JwpVk031731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbZAIT7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2009 14:59:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     leds ledtrig-timer: on deactivation hardware blinking should be disabled.
has been removed from the -mm tree.  Its filename was
     leds-ledtrig-timer-on-deactivation-hardware-blinking-should-be-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds ledtrig-timer: on deactivation hardware blinking should be disabled.
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-timer.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/leds/ledtrig-timer.c~leds-ledtrig-timer-on-deactivation-hardware-blinking-should-be-disabled drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-ledtrig-timer-on-deactivation-hardware-blinking-should-be-disabled
+++ a/drivers/leds/ledtrig-timer.c
@@ -199,6 +199,7 @@ err_out:
 static void timer_trig_deactivate(struct led_classdev *led_cdev)
 {
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
+	unsigned long on = 0, off = 0;
 
 	if (timer_data) {
 		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
@@ -206,6 +207,10 @@ static void timer_trig_deactivate(struct
 		del_timer_sync(&timer_data->timer);
 		kfree(timer_data);
 	}
+
+	/* If there is hardware support for blinking, stop it */
+	if (led_cdev->blink_set)
+		led_cdev->blink_set(led_cdev, &on, &off);
 }
 
 static struct led_trigger timer_led_trigger = {
_

Patches currently in -mm which might be from giometti@linux.it are

origin.patch
linux-next.patch
linuxpps-core-support.patch
linuxpps-core-support-sysfs-not-needed-variables-removed.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

