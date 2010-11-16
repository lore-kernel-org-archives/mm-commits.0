From: akpm@linux-foundation.org
Subject: [merged] backlight-fix-blanking-for-l4f00242t03-lcd.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:55 -0800
Message-ID: <201011161934.oAGJY7YI003178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757605Ab0KPTeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marek.vasut@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: fix blanking for L4F00242T03 LCD
has been removed from the -mm tree.  Its filename was
     backlight-fix-blanking-for-l4f00242t03-lcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: fix blanking for L4F00242T03 LCD
From: Marek Vasut <marek.vasut@gmail.com>

The LCD was turned on if the variable power was > 0, but that was
incorrect.  The LCD has to be turned on in NORMAL and UNBLANK case.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/l4f00242t03.c~backlight-fix-blanking-for-l4f00242t03-lcd drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-fix-blanking-for-l4f00242t03-lcd
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -78,7 +78,7 @@ static int l4f00242t03_lcd_power_set(str
 	const u16 slpin = 0x10;
 	const u16 disoff = 0x28;
 
-	if (power) {
+	if (power <= FB_BLANK_NORMAL) {
 		if (priv->lcd_on)
 			return 0;
 
_

Patches currently in -mm which might be from marek.vasut@gmail.com are

drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch

