From: akpm@linux-foundation.org
Subject: [merged] backlight-add-low-threshold-to-pwm-backlight.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:31:02 -0800
Message-ID: <201011161934.oAGJYEjP003187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408Ab0KPTev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arun.murthy@stericsson.com, linus.walleij@stericsson.com, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     backlight: add low threshold to pwm backlight
has been removed from the -mm tree.  Its filename was
     backlight-add-low-threshold-to-pwm-backlight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: add low threshold to pwm backlight
From: Arun Murthy <arun.murthy@stericsson.com>

The intensity of the backlight can be varied from a range of
max_brightness to zero.  Though most, if not all the pwm based backlight
devices start flickering at lower brightness value.  And also for each
device there exists a brightness value below which the backlight appears
to be turned off though the value is not equal to zero.

If the range of brightness for a device is from zero to max_brightness.  A
graph is plotted for brightness Vs intensity for the pwm based backlight
device has to be a linear graph.

intensity
	  |   /
	  |  /
	  | /
	  |/
	  ---------
	 0	max_brightness

But pratically on measuring the above we note that the intensity of
backlight goes to zero(OFF) when the value in not zero almost nearing to
zero(some x%).  so the graph looks like

intensity
	  |    /
	  |   /
	  |  /
	  |  |
	  ------------
	 0   x	 max_brightness

In order to overcome this drawback knowing this x% i.e nothing but the low
threshold beyond which the backlight is off and will have no effect, the
brightness value is being offset by the low threshold value(retaining the
linearity of the graph).  Now the graph becomes

intensity
	  |     /
	  |    /
	  |   /
	  |  /
	  -------------
	   0	  max_brightness

With this for each and every digit increment in the brightness from zero
there is a change in the intensity of backlight.  Devices having this
behaviour can set the low threshold brightness(lth_brightness) and pass
the same as platform data else can have it as zero.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    7 ++++++-
 include/linux/pwm_backlight.h    |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/pwm_bl.c~backlight-add-low-threshold-to-pwm-backlight drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-add-low-threshold-to-pwm-backlight
+++ a/drivers/video/backlight/pwm_bl.c
@@ -25,6 +25,7 @@ struct pwm_bl_data {
 	struct pwm_device	*pwm;
 	struct device		*dev;
 	unsigned int		period;
+	unsigned int		lth_brightness;
 	int			(*notify)(struct device *,
 					  int brightness);
 };
@@ -48,7 +49,9 @@ static int pwm_backlight_update_status(s
 		pwm_config(pb->pwm, 0, pb->period);
 		pwm_disable(pb->pwm);
 	} else {
-		pwm_config(pb->pwm, brightness * pb->period / max, pb->period);
+		brightness = pb->lth_brightness +
+			(brightness * (pb->period - pb->lth_brightness) / max);
+		pwm_config(pb->pwm, brightness, pb->period);
 		pwm_enable(pb->pwm);
 	}
 	return 0;
@@ -92,6 +95,8 @@ static int pwm_backlight_probe(struct pl
 
 	pb->period = data->pwm_period_ns;
 	pb->notify = data->notify;
+	pb->lth_brightness = data->lth_brightness *
+		(data->pwm_period_ns / data->max_brightness);
 	pb->dev = &pdev->dev;
 
 	pb->pwm = pwm_request(data->pwm_id, "backlight");
diff -puN include/linux/pwm_backlight.h~backlight-add-low-threshold-to-pwm-backlight include/linux/pwm_backlight.h
--- a/include/linux/pwm_backlight.h~backlight-add-low-threshold-to-pwm-backlight
+++ a/include/linux/pwm_backlight.h
@@ -8,6 +8,7 @@ struct platform_pwm_backlight_data {
 	int pwm_id;
 	unsigned int max_brightness;
 	unsigned int dft_brightness;
+	unsigned int lth_brightness;
 	unsigned int pwm_period_ns;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
_

Patches currently in -mm which might be from arun.murthy@stericsson.com are


