From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:34 -0800
Message-ID: <201101132006.p0DK6FQV029712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933727Ab1AMUSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:18:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maramaopercheseimorto@gmail.com, axel.lin@gmail.com, marek.vasut@gmail.com, rpurdie@rpsys.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/l4f00242t03.c: prevent unbalanced calls to regulator enable/disable
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/l4f00242t03.c: prevent unbalanced calls to regulator enable/disable
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Otherwise a double call to:
$ echo 4 > /sys/class/lcd/l4f00242t03/lcd_power
Will, the first power down the lcd and regulators correctly and the
second produce an unbalanced call to regulator disable.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-prevent-unbalanced-calls-to-regulator-enable-disable
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -134,10 +134,12 @@ static int l4f00242t03_lcd_power_set(str
 		}
 	} else {
 		/* power == FB_BLANK_POWERDOWN */
-		/* Clear the screen before shutting down */
-		spi_write(spi, (const u8 *)&disoff, sizeof(u16));
-		msleep(60);
-		l4f00242t03_lcd_powerdown(spi);
+		if (priv->lcd_state != FB_BLANK_POWERDOWN) {
+			/* Clear the screen before shutting down */
+			spi_write(spi, (const u8 *)&disoff, sizeof(u16));
+			msleep(60);
+			l4f00242t03_lcd_powerdown(spi);
+		}
 	}
 
 	priv->lcd_state = power;
_

Patches currently in -mm which might be from maramaopercheseimorto@gmail.com are

origin.patch
linux-next.patch

