From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-l4f00242t03c-fix-reset-sequence.patch added to -mm tree
Date: Tue, 04 Jan 2011 15:59:31 -0800
Message-ID: <201101042359.p04NxVBB031691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249Ab1AEAAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:00:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maramaopercheseimorto@gmail.com, axel.lin@gmail.com, marek.vasut@gmail.com, rpurdie@rpsys.net, tj@kernel.org


The patch titled
     drivers/video/backlight/l4f00242t03.c: fix reset sequence
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-l4f00242t03c-fix-reset-sequence.patch

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
Subject: drivers/video/backlight/l4f00242t03.c: fix reset sequence
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

The reset command is part of the init sequence and it take effect
only if the lcd is powered.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-fix-reset-sequence drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-fix-reset-sequence
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -62,6 +62,8 @@ static void l4f00242t03_lcd_init(struct 
 		regulator_enable(priv->core_reg);
 	}
 
+	l4f00242t03_reset(pdata->reset_gpio);
+
 	gpio_set_value(pdata->data_enable_gpio, 1);
 	msleep(60);
 	spi_write(spi, (const u8 *)cmd, ARRAY_SIZE(cmd) * sizeof(u16));
@@ -227,7 +229,6 @@ static int __devinit l4f00242t03_probe(s
 	}
 
 	/* Init the LCD */
-	l4f00242t03_reset(pdata->reset_gpio);
 	l4f00242t03_lcd_init(spi);
 	priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_UNBLANK);
_

Patches currently in -mm which might be from maramaopercheseimorto@gmail.com are

linux-next.patch
drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch
drivers-video-backlight-l4f00242t03c-fix-reset-sequence.patch

