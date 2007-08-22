From: akpm@linux-foundation.org
Subject: + au1100fb-move-au1100fb_fb_blank-beforce.patch added to -mm tree
Date: Tue, 21 Aug 2007 22:05:04 -0700
Message-ID: <200708220505.l7M554CX028389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52959 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbXHVFFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 01:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, adaplas@pol.net, ralf@linux-mips.org


The patch titled
     au1100fb: move au1100fb_fb_blank() beforce  au1100fb_setmode()
has been added to the -mm tree.  Its filename is
     au1100fb-move-au1100fb_fb_blank-beforce.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: au1100fb: move au1100fb_fb_blank() beforce  au1100fb_setmode()
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

au1100fb_fb_blank() should come before au1100fb_setmode().

drivers/video/au1100fb.c: In function 'au1100fb_setmode':
drivers/video/au1100fb.c:211: error: implicit declaration of function 'au1100fb_fb_blank'

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/au1100fb.c |   92 ++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff -puN drivers/video/au1100fb.c~au1100fb-move-au1100fb_fb_blank-beforce drivers/video/au1100fb.c
--- a/drivers/video/au1100fb.c~au1100fb-move-au1100fb_fb_blank-beforce
+++ a/drivers/video/au1100fb.c
@@ -115,6 +115,52 @@ static int nocursor = 0;
 module_param(nocursor, int, 0644);
 MODULE_PARM_DESC(nocursor, "cursor enable/disable");
 
+/* fb_blank
+ * Blank the screen. Depending on the mode, the screen will be
+ * activated with the backlight color, or desactivated
+ */
+static int au1100fb_fb_blank(int blank_mode, struct fb_info *fbi)
+{
+	struct au1100fb_device *fbdev = to_au1100fb_device(fbi);
+
+	print_dbg("fb_blank %d %p", blank_mode, fbi);
+
+	switch (blank_mode) {
+
+	case VESA_NO_BLANKING:
+			/* Turn on panel */
+			fbdev->regs->lcd_control |= LCD_CONTROL_GO;
+#ifdef CONFIG_MIPS_PB1100
+			if (drv_info.panel_idx == 1) {
+				au_writew(au_readw(PB1100_G_CONTROL)
+					  | (PB1100_G_CONTROL_BL | PB1100_G_CONTROL_VDD),
+			PB1100_G_CONTROL);
+			}
+#endif
+		au_sync();
+		break;
+
+	case VESA_VSYNC_SUSPEND:
+	case VESA_HSYNC_SUSPEND:
+	case VESA_POWERDOWN:
+			/* Turn off panel */
+			fbdev->regs->lcd_control &= ~LCD_CONTROL_GO;
+#ifdef CONFIG_MIPS_PB1100
+			if (drv_info.panel_idx == 1) {
+				au_writew(au_readw(PB1100_G_CONTROL)
+				  	  & ~(PB1100_G_CONTROL_BL | PB1100_G_CONTROL_VDD),
+			PB1100_G_CONTROL);
+			}
+#endif
+		au_sync();
+		break;
+	default:
+		break;
+
+	}
+	return 0;
+}
+
 /*
  * Set hardware with var settings. This will enable the controller with a specific
  * mode, normally validated with the fb_check_var method
@@ -272,52 +318,6 @@ int au1100fb_fb_setcolreg(unsigned regno
 	return 0;
 }
 
-/* fb_blank
- * Blank the screen. Depending on the mode, the screen will be
- * activated with the backlight color, or desactivated
- */
-int au1100fb_fb_blank(int blank_mode, struct fb_info *fbi)
-{
-	struct au1100fb_device *fbdev = to_au1100fb_device(fbi);
-
-	print_dbg("fb_blank %d %p", blank_mode, fbi);
-
-	switch (blank_mode) {
-
-	case VESA_NO_BLANKING:
-			/* Turn on panel */
-			fbdev->regs->lcd_control |= LCD_CONTROL_GO;
-#ifdef CONFIG_MIPS_PB1100
-			if (drv_info.panel_idx == 1) {
-				au_writew(au_readw(PB1100_G_CONTROL)
-					  | (PB1100_G_CONTROL_BL | PB1100_G_CONTROL_VDD),
-			PB1100_G_CONTROL);
-			}
-#endif
-		au_sync();
-		break;
-
-	case VESA_VSYNC_SUSPEND:
-	case VESA_HSYNC_SUSPEND:
-	case VESA_POWERDOWN:
-			/* Turn off panel */
-			fbdev->regs->lcd_control &= ~LCD_CONTROL_GO;
-#ifdef CONFIG_MIPS_PB1100
-			if (drv_info.panel_idx == 1) {
-				au_writew(au_readw(PB1100_G_CONTROL)
-				  	  & ~(PB1100_G_CONTROL_BL | PB1100_G_CONTROL_VDD),
-			PB1100_G_CONTROL);
-			}
-#endif
-		au_sync();
-		break;
-	default:
-		break;
-
-	}
-	return 0;
-}
-
 /* fb_pan_display
  * Pan display in x and/or y as specified
  */
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

au1100fb-move-au1100fb_fb_blank-beforce.patch
git-mips.patch
git-mtd.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
