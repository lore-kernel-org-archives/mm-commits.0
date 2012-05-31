From: akpm@linux-foundation.org
Subject: [merged] leds-simple_strtoul-cleanup.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:32 -0700
Message-ID: <20120531191932.61245A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63242 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2EaTTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:33 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so146999yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkhan@gmail.com, bryan.wu@canonical.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: simple_strtoul() cleanup
has been removed from the -mm tree.  Its filename was
     leds-simple_strtoul-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shuah Khan <shuahkhan@gmail.com>
Subject: leds: simple_strtoul() cleanup

led-class.c and ledtrig-timer.c still use simple_strtoul().  Change them
to use kstrtoul() instead of obsolete simple_strtoul().

Also fix the existing int ret declaration to be ssize_t to match the
return type for _store functions in ledtrig-timer.c.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/led-class.c     |   25 ++++++-----------
 drivers/leds/ledtrig-timer.c |   48 +++++++++++++--------------------
 2 files changed, 30 insertions(+), 43 deletions(-)

diff -puN drivers/leds/led-class.c~leds-simple_strtoul-cleanup drivers/leds/led-class.c
--- a/drivers/leds/led-class.c~leds-simple_strtoul-cleanup
+++ a/drivers/leds/led-class.c
@@ -44,23 +44,18 @@ static ssize_t led_brightness_store(stru
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
 	ssize_t ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
-
-	if (isspace(*after))
-		count++;
-
-	if (count == size) {
-		ret = count;
-
-		if (state == LED_OFF)
-			led_trigger_remove(led_cdev);
-		led_set_brightness(led_cdev, state);
-	}
 
-	return ret;
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	if (state == LED_OFF)
+		led_trigger_remove(led_cdev);
+	led_set_brightness(led_cdev, state);
+
+	return size;
 }
 
 static ssize_t led_max_brightness_show(struct device *dev,
diff -puN drivers/leds/ledtrig-timer.c~leds-simple_strtoul-cleanup drivers/leds/ledtrig-timer.c
--- a/drivers/leds/ledtrig-timer.c~leds-simple_strtoul-cleanup
+++ a/drivers/leds/ledtrig-timer.c
@@ -31,21 +31,17 @@ static ssize_t led_delay_on_store(struct
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	int ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
-
-	if (isspace(*after))
-		count++;
-
-	if (count == size) {
-		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
-		led_cdev->blink_delay_on = state;
-		ret = count;
-	}
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
+	led_cdev->blink_delay_on = state;
 
-	return ret;
+	return size;
 }
 
 static ssize_t led_delay_off_show(struct device *dev,
@@ -60,21 +56,17 @@ static ssize_t led_delay_off_store(struc
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	int ret = -EINVAL;
-	char *after;
-	unsigned long state = simple_strtoul(buf, &after, 10);
-	size_t count = after - buf;
-
-	if (isspace(*after))
-		count++;
-
-	if (count == size) {
-		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
-		led_cdev->blink_delay_off = state;
-		ret = count;
-	}
+	unsigned long state;
+	ssize_t ret = -EINVAL;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
+	led_cdev->blink_delay_off = state;
 
-	return ret;
+	return size;
 }
 
 static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
_

Patches currently in -mm which might be from shuahkhan@gmail.com are

origin.patch

