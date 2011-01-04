From: akpm@linux-foundation.org
Subject: + leds-lp5521-modify-the-way-of-setting-led-device-name.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:57:24 -0800
Message-ID: <201101042257.p04MvOTt028979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab1ADW5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arun.murthy@stericsson.com, ilkka.koskinen@nokia.com, rpurdie@rpsys.net, samu.p.onkalo@nokia.com


The patch titled
     leds-lp5521: modify the way of setting led device name
has been added to the -mm tree.  Its filename is
     leds-lp5521-modify-the-way-of-setting-led-device-name.patch

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
Subject: leds-lp5521: modify the way of setting led device name
From: Arun Murthy <arun.murthy@stericsson.com>

Currently the led device name is fetched from the device_type in
I2C_BOARD_INFO which comes from the platform data.  This name is in turn
used to create an entry in sysfs.

If there exists two or more lp5521 on a particular platform, the
device_type in I2C_BOARD_INFO has to be the same, else lp5521 driver probe
wont be called and if used so, results in run time warning "cannot create
sysfs with same name" and hence a failure.

The name that is used to create sysfs entry is to be passed by the struct
led_platform_data.  Hence adding an element of type const char * and
change in lp5521 driver to use this name in creating the led device if
present else use the name obtained by I2C_BOARD_INFO.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c  |    3 ++-
 include/linux/leds-lp5521.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-modify-the-way-of-setting-led-device-name drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-modify-the-way-of-setting-led-device-name
+++ a/drivers/leds/leds-lp5521.c
@@ -617,7 +617,8 @@ static int __init lp5521_init_led(struct
 		return -EINVAL;
 	}
 
-	snprintf(name, sizeof(name), "%s:channel%d", client->name, chan);
+	snprintf(name, sizeof(name), "%s:channel%d",
+			pdata->label ?: client->name, chan);
 	led->cdev.brightness_set = lp5521_set_brightness;
 	led->cdev.name = name;
 	res = led_classdev_register(dev, &led->cdev);
diff -puN include/linux/leds-lp5521.h~leds-lp5521-modify-the-way-of-setting-led-device-name include/linux/leds-lp5521.h
--- a/include/linux/leds-lp5521.h~leds-lp5521-modify-the-way-of-setting-led-device-name
+++ a/include/linux/leds-lp5521.h
@@ -42,6 +42,7 @@ struct lp5521_platform_data {
 	int	(*setup_resources)(void);
 	void	(*release_resources)(void);
 	void	(*enable)(bool state);
+	const char *label;
 };
 
 #endif /* __LINUX_LP5521_H */
_

Patches currently in -mm which might be from arun.murthy@stericsson.com are

leds-leds-lp5523-modify-the-way-of-setting-led-device-name.patch
leds-lp5523-fix-circular-locking.patch
leds-lp5521-fix-circular-locking.patch
leds-lp5521-modify-the-way-of-setting-led-device-name.patch

