From: akpm@linux-foundation.org
Subject: - leds-avoid-needless-strlen-for-attributes.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:54 -0700
Message-ID: <200810182320.m9INKsZ3029846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbYJRXVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven.wegener@stealer.net, ray-lk@madrabbit.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: avoid needless strlen() for attributes
has been removed from the -mm tree.  Its filename was
     leds-avoid-needless-strlen-for-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: avoid needless strlen() for attributes
From: Sven Wegener <sven.wegener@stealer.net>

There's no need for the additional call to strlen(), we can directly
return the value returned by sprintf().  We now return a length value that
doesn't include the final '\0', but user space shouldn't bother about it
anyway.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Ray Lee <ray-lk@madrabbit.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c     |    5 +----
 drivers/leds/ledtrig-timer.c |    8 ++------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/leds/led-class.c~leds-avoid-needless-strlen-for-attributes drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-avoid-needless-strlen-for-attributes
+++ a/drivers/leds/led-class.c
@@ -34,14 +34,11 @@ static ssize_t led_brightness_show(struc
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	ssize_t ret = 0;
 
 	/* no lock needed for this */
 	led_update_brightness(led_cdev);
-	sprintf(buf, "%u\n", led_cdev->brightness);
-	ret = strlen(buf) + 1;
 
-	return ret;
+	return sprintf(buf, "%u\n", led_cdev->brightness);
 }
 
 static ssize_t led_brightness_store(struct device *dev,
diff -puN drivers/leds/ledtrig-timer.c~leds-avoid-needless-strlen-for-attributes drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-avoid-needless-strlen-for-attributes
+++ a/drivers/leds/ledtrig-timer.c
@@ -70,9 +70,7 @@ static ssize_t led_delay_on_show(struct 
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	sprintf(buf, "%lu\n", timer_data->delay_on);
-
-	return strlen(buf) + 1;
+	return sprintf(buf, "%lu\n", timer_data->delay_on);
 }
 
 static ssize_t led_delay_on_store(struct device *dev,
@@ -116,9 +114,7 @@ static ssize_t led_delay_off_show(struct
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct timer_trig_data *timer_data = led_cdev->trigger_data;
 
-	sprintf(buf, "%lu\n", timer_data->delay_off);
