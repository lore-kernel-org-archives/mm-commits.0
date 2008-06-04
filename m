From: akpm@linux-foundation.org
Subject: + atyfb-remove-dead-code.patch added to -mm tree
Date: Wed, 04 Jun 2008 16:45:15 -0700
Message-ID: <200806042345.m54NjGCe015312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757810AbYFDXp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 19:45:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olaf@aepfle.de, adaplas@pol.net, krzysztof.h1@poczta.fm, syrjala@sci.fi


The patch titled
     atyfb: remove dead code
has been added to the -mm tree.  Its filename is
     atyfb-remove-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: remove dead code
From: Olaf Hering <olaf@aepfle.de>

Remove dead code.  This will slightly change the behaviour of the driver
on systems that support backlight control.  Previously they would just
turn the backlight off using the backlight control but now the generic LCD
code will also turn off the LCD using the POWER_MANAGEMENT register.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-remove-dead-code drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-remove-dead-code
+++ a/drivers/video/aty/atyfb_base.c
@@ -2709,8 +2709,7 @@ static int atyfb_blank(int blank, struct
 	if (par->lock_blank || par->asleep)
 		return 0;
 
-#ifdef CONFIG_FB_ATY_BACKLIGHT
-#elif defined(CONFIG_FB_ATY_GENERIC_LCD)
+#ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table && blank > FB_BLANK_NORMAL &&
 	    (aty_ld_lcd(LCD_GEN_CNTL, par) & LCD_ON)) {
 		u32 pm = aty_ld_lcd(POWER_MANAGEMENT, par);
@@ -2739,8 +2738,7 @@ static int atyfb_blank(int blank, struct
 	}
 	aty_st_le32(CRTC_GEN_CNTL, gen_cntl, par);
 
-#ifdef CONFIG_FB_ATY_BACKLIGHT
-#elif defined(CONFIG_FB_ATY_GENERIC_LCD)
+#ifdef CONFIG_FB_ATY_GENERIC_LCD
 	if (par->lcd_table && blank <= FB_BLANK_NORMAL &&
 	    (aty_ld_lcd(LCD_GEN_CNTL, par) & LCD_ON)) {
 		u32 pm = aty_ld_lcd(POWER_MANAGEMENT, par);
_

Patches currently in -mm which might be from olaf@aepfle.de are

linux-next.patch
atyfb-remove-dead-code.patch
keep-track-of-network-interface-renaming.patch

