From: akpm@linux-foundation.org
Subject: [merged] pwm_backlight-add-check_fb-hook.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:29 -0700
Message-ID: <201103232037.p2NKb5GI028207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933490Ab1CWUzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmorell@nvidia.com, arun.murthy@stericsson.com, linus.walleij@stericsson.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     pwm_backlight: add check_fb() hook
has been removed from the -mm tree.  Its filename was
     pwm_backlight-add-check_fb-hook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pwm_backlight: add check_fb() hook
From: Robert Morell <rmorell@nvidia.com>

In systems with multiple framebuffer devices, one of the devices might be
blanked while another is unblanked.  In order for the backlight blanking
logic to know whether to turn off the backlight for a particular
framebuffer's blanking notification, it needs to be able to check if a
given framebuffer device corresponds to the backlight.

This plumbs the check_fb hook from core backlight through the
pwm_backlight helper to allow platform code to plug in a check_fb hook.

Signed-off-by: Robert Morell <rmorell@nvidia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Arun Murthy <arun.murthy@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |   11 +++++++++++
 include/linux/pwm_backlight.h    |    3 +++
 2 files changed, 14 insertions(+)

diff -puN drivers/video/backlight/pwm_bl.c~pwm_backlight-add-check_fb-hook drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~pwm_backlight-add-check_fb-hook
+++ a/drivers/video/backlight/pwm_bl.c
@@ -28,6 +28,7 @@ struct pwm_bl_data {
 	unsigned int		lth_brightness;
 	int			(*notify)(struct device *,
 					  int brightness);
+	int			(*check_fb)(struct device *, struct fb_info *);
 };
 
 static int pwm_backlight_update_status(struct backlight_device *bl)
@@ -62,9 +63,18 @@ static int pwm_backlight_get_brightness(
 	return bl->props.brightness;
 }
 
+static int pwm_backlight_check_fb(struct backlight_device *bl,
+				  struct fb_info *info)
+{
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+
+	return !pb->check_fb || pb->check_fb(pb->dev, info);
+}
+
 static const struct backlight_ops pwm_backlight_ops = {
 	.update_status	= pwm_backlight_update_status,
 	.get_brightness	= pwm_backlight_get_brightness,
+	.check_fb	= pwm_backlight_check_fb,
 };
 
 static int pwm_backlight_probe(struct platform_device *pdev)
@@ -95,6 +105,7 @@ static int pwm_backlight_probe(struct pl
 
 	pb->period = data->pwm_period_ns;
 	pb->notify = data->notify;
+	pb->check_fb = data->check_fb;
 	pb->lth_brightness = data->lth_brightness *
 		(data->pwm_period_ns / data->max_brightness);
 	pb->dev = &pdev->dev;
diff -puN include/linux/pwm_backlight.h~pwm_backlight-add-check_fb-hook include/linux/pwm_backlight.h
--- a/include/linux/pwm_backlight.h~pwm_backlight-add-check_fb-hook
+++ a/include/linux/pwm_backlight.h
@@ -4,6 +4,8 @@
 #ifndef __LINUX_PWM_BACKLIGHT_H
 #define __LINUX_PWM_BACKLIGHT_H
 
+#include <linux/backlight.h>
+
 struct platform_pwm_backlight_data {
 	int pwm_id;
 	unsigned int max_brightness;
@@ -13,6 +15,7 @@ struct platform_pwm_backlight_data {
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
 	void (*exit)(struct device *dev);
+	int (*check_fb)(struct device *dev, struct fb_info *info);
 };
 
 #endif
_

Patches currently in -mm which might be from rmorell@nvidia.com are

origin.patch

