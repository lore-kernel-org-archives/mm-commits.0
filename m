From: akpm@linux-foundation.org
Subject: [folded] leds-add-output-inversion-option-to-backlight-trigger-update.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:17:26 -0800
Message-ID: <201101130017.p0D0HQ92011988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756424Ab1AMASC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkrzyszt@tis.icnet.pl, lethal@linux-sh.org, richard.purdie@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     leds-add-output-inversion-option-to-backlight-trigger-update
has been removed from the -mm tree.  Its filename was
     leds-add-output-inversion-option-to-backlight-trigger-update.patch

This patch was dropped because it was folded into leds-add-output-inversion-option-to-backlight-trigger.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-add-output-inversion-option-to-backlight-trigger-update
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

- new sysfs file should be documented,
- the new sysfs file name could be consistent with the one already used
  by the gpio trigger for a similiar function.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-led |   10 ++++++++++
 drivers/leds/ledtrig-backlight.c          |    6 +++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-class-led~leds-add-output-inversion-option-to-backlight-trigger-update Documentation/ABI/testing/sysfs-class-led
--- a/Documentation/ABI/testing/sysfs-class-led~leds-add-output-inversion-option-to-backlight-trigger-update
+++ a/Documentation/ABI/testing/sysfs-class-led
@@ -26,3 +26,13 @@ Description:
 		scheduler is chosen. Trigger specific parameters can appear in
 		/sys/class/leds/<led> once a given trigger is selected.
 
+What:		/sys/class/leds/<led>/inverted
+Date:		January 2011
+KernelVersion:	2.6.38
+Contact:	Richard Purdie <rpurdie@rpsys.net>
+Description:
+		Invert the LED on/off state. This parameter is specific to
+		gpio and backlight triggers. In case of the backlight trigger,
+		it is usefull when driving a LED which is intended to indicate
+		a device in a standby like state.
+
diff -puN drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger-update drivers/leds/ledtrig-backlight.c
--- a/drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger-update
+++ a/drivers/leds/ledtrig-backlight.c
@@ -93,7 +93,7 @@ static ssize_t bl_trig_invert_store(stru
 
 	return num;
 }
-static DEVICE_ATTR(invert, 0644, bl_trig_invert_show, bl_trig_invert_store);
+static DEVICE_ATTR(inverted, 0644, bl_trig_invert_show, bl_trig_invert_store);
 
 static void bl_trig_activate(struct led_classdev *led)
 {
@@ -108,7 +108,7 @@ static void bl_trig_activate(struct led_
 		return;
 	}
 
-	ret = device_create_file(led->dev, &dev_attr_invert);
+	ret = device_create_file(led->dev, &dev_attr_inverted);
 	if (ret)
 		goto err_invert;
 
@@ -134,7 +134,7 @@ static void bl_trig_deactivate(struct le
 		(struct bl_trig_notifier *) led->trigger_data;
 
 	if (n) {
-		device_remove_file(led->dev, &dev_attr_invert);
+		device_remove_file(led->dev, &dev_attr_inverted);
 		fb_unregister_client(&n->notifier);
 		kfree(n);
 	}
_

Patches currently in -mm which might be from jkrzyszt@tis.icnet.pl are

origin.patch
leds-add-output-inversion-option-to-backlight-trigger.patch

