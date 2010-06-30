From: akpm@linux-foundation.org
Subject: + backlight-fix-blanking-for-l4f00242t03-lcd.patch added to -mm tree
Date: Wed, 30 Jun 2010 15:42:23 -0700
Message-ID: <201006302242.o5UMgN0c030757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332Ab0F3Wmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 18:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marek.vasut@gmail.com, rpurdie@rpsys.net


The patch titled
     backlight: fix blanking for L4F00242T03 LCD
has been added to the -mm tree.  Its filename is
     backlight-fix-blanking-for-l4f00242t03-lcd.patch

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
Subject: backlight: fix blanking for L4F00242T03 LCD
From: Marek Vasut <marek.vasut@gmail.com>

The LCD was turned on if the variable power was > 0, but that was
incorrect.  The LCD has to be turned on in NORMAL and UNBLANK case.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
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

linux-next.patch
backlight-fix-blanking-for-lms283gf05-lcd.patch
backlight-fix-blanking-for-l4f00242t03-lcd.patch
maintainers-update-arm-voipac-pxa270-file-patterns.patch
maintainers-update-arm-zipit-z2-support-file-patterns.patch

