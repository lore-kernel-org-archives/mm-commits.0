From: akpm@linux-foundation.org
Subject: [merged] leds-leds-lp5523-modify-the-way-of-setting-led-device-name.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:20 -0800
Message-ID: <201101132006.p0DK61fj029683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933606Ab1AMUGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:06:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samu.p.onkalo@nokia.com, arun.murthy@stericsson.com, ilkka.koskinen@nokia.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: leds-lp5523: modify the way of setting led device name
has been removed from the -mm tree.  Its filename was
     leds-leds-lp5523-modify-the-way-of-setting-led-device-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: leds-lp5523: modify the way of setting led device name
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Currently all leds channels begins with string lp5523.  Patch adds a
possibility to provide name via platform data.  This makes it possible to
have several chips without overlapping sysfs names.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Arun Murthy <arun.murthy@stericsson.com>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c  |    3 ++-
 include/linux/leds-lp5523.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/leds/leds-lp5523.c~leds-leds-lp5523-modify-the-way-of-setting-led-device-name drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~leds-leds-lp5523-modify-the-way-of-setting-led-device-name
+++ a/drivers/leds/leds-lp5523.c
@@ -870,7 +870,8 @@ static int __init lp5523_init_led(struct
 			return -EINVAL;
 		}
 
-		snprintf(name, 32, "lp5523:channel%d", chan);
+		snprintf(name, sizeof(name), "%s:channel%d",
+			pdata->label ?: "lp5523", chan);
 
 		led->cdev.name = name;
 		led->cdev.brightness_set = lp5523_set_brightness;
diff -puN include/linux/leds-lp5523.h~leds-leds-lp5523-modify-the-way-of-setting-led-device-name include/linux/leds-lp5523.h
--- a/include/linux/leds-lp5523.h~leds-leds-lp5523-modify-the-way-of-setting-led-device-name
+++ a/include/linux/leds-lp5523.h
@@ -42,6 +42,7 @@ struct lp5523_platform_data {
 	int	(*setup_resources)(void);
 	void	(*release_resources)(void);
 	void	(*enable)(bool state);
+	const	char *label;
 };
 
 #endif /* __LINUX_LP5523_H */
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

origin.patch

