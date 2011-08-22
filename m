From: akpm@linux-foundation.org
Subject: + backlight-add-a-callback-notify_after-for-backlight-control.patch added to -mm tree
Date: Mon, 22 Aug 2011 16:18:30 -0700
Message-ID: <201108222318.p7MNIUbe012775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab1HVXTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Aug 2011 19:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilee@nvidia.com, arun.murthy@stericsson.com, lethal@linux-sh.org, rmorell@nvidia.com, rpurdie@rpsys.net


The patch titled
     backlight: add a callback 'notify_after' for backlight control
has been added to the -mm tree.  Its filename is
     backlight-add-a-callback-notify_after-for-backlight-control.patch

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
Subject: backlight: add a callback 'notify_after' for backlight control
From: Dilan Lee <dilee@nvidia.com>

We need a callback to do some things after pwm_enable, pwm_disable
and pwm_config.

Signed-off-by: Dilan Lee <dilee@nvidia.com>
Reviewed-by: Robert Morell <rmorell@nvidia.com>
Reviewed-by: Arun Murthy <arun.murthy@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    9 +++++++++
 include/linux/pwm_backlight.h    |    1 +
 2 files changed, 10 insertions(+)

diff -puN drivers/video/backlight/pwm_bl.c~backlight-add-a-callback-notify_after-for-backlight-control drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-add-a-callback-notify_after-for-backlight-control
+++ a/drivers/video/backlight/pwm_bl.c
@@ -28,6 +28,8 @@ struct pwm_bl_data {
 	unsigned int		lth_brightness;
 	int			(*notify)(struct device *,
 					  int brightness);
+	void			(*notify_after)(struct device *,
+					int brightness);
 	int			(*check_fb)(struct device *, struct fb_info *);
 };
 
@@ -55,6 +57,10 @@ static int pwm_backlight_update_status(s
 		pwm_config(pb->pwm, brightness, pb->period);
 		pwm_enable(pb->pwm);
 	}
+
+	if (pb->notify_after)
+		pb->notify_after(pb->dev, brightness);
+
 	return 0;
 }
 
@@ -105,6 +111,7 @@ static int pwm_backlight_probe(struct pl
 
 	pb->period = data->pwm_period_ns;
 	pb->notify = data->notify;
+	pb->notify_after = data->notify_after;
 	pb->check_fb = data->check_fb;
 	pb->lth_brightness = data->lth_brightness *
 		(data->pwm_period_ns / data->max_brightness);
@@ -172,6 +179,8 @@ static int pwm_backlight_suspend(struct 
 		pb->notify(pb->dev, 0);
 	pwm_config(pb->pwm, 0, pb->period);
 	pwm_disable(pb->pwm);
+	if (pb->notify_after)
+		pb->notify_after(pb->dev, 0);
 	return 0;
 }
 
diff -puN include/linux/pwm_backlight.h~backlight-add-a-callback-notify_after-for-backlight-control include/linux/pwm_backlight.h
--- a/include/linux/pwm_backlight.h~backlight-add-a-callback-notify_after-for-backlight-control
+++ a/include/linux/pwm_backlight.h
@@ -14,6 +14,7 @@ struct platform_pwm_backlight_data {
 	unsigned int pwm_period_ns;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
+	void (*notify_after)(struct device *dev, int brightness);
 	void (*exit)(struct device *dev);
 	int (*check_fb)(struct device *dev, struct fb_info *info);
 };
_

Patches currently in -mm which might be from dilee@nvidia.com are

backlight-add-a-callback-notify_after-for-backlight-control.patch

