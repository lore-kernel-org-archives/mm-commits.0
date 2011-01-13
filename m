From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-fix-reset-sequence.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:36 -0800
Message-ID: <201101132006.p0DK6HeU029736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933611Ab1AMUTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:19:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maramaopercheseimorto@gmail.com, axel.lin@gmail.com, marek.vasut@gmail.com, rpurdie@rpsys.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/l4f00242t03.c: fix reset sequence
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-fix-reset-sequence.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/l4f00242t03.c: fix reset sequence
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

The reset command is part of the init sequence and it take effect
only if the lcd is powered.

The effect of the bug was that the sequence:
set lcd power_state to FB_BLANK_POWERDOWN
set lcd power_state to FB_BLANK_UNBLANK
Did not produced a complete reboot of the LCD which was showing fuzzy 
colours.

This was not experienced before implementing correctly all the LCD power
states with the patch [1].  Since before the patch [1] the regulators were
not touched and the LCD shutdown was reached with a register write.  After
the patch [1] a complete boot sequence with an initial reset is needed for
the display every time the LCD is powered up.

drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch

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

origin.patch
linux-next.patch

