From: akpm@linux-foundation.org
Subject: - tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:36 -0700
Message-ID: <200707172307.l6HN7aJF012204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761888AbXGQXPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix pseudo_palette array overrun in setcolreg
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tridentfb: fix pseudo_palette array overrun in setcolreg
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette has only 16 elements. Do not write if regno (the array
index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-pseudo_palette-array-overrun-in-setcolreg
+++ a/drivers/video/tridentfb.c
@@ -976,7 +976,7 @@ static int tridentfb_setcolreg(unsigned 
 		return 1;
 
 
-	if (bpp==8) {
+	if (bpp == 8) {
 		t_outb(0xFF,0x3C6);
 		t_outb(regno,0x3C8);
 
@@ -984,19 +984,21 @@ static int tridentfb_setcolreg(unsigned 
 		t_outb(green>>10,0x3C9);
 		t_outb(blue>>10,0x3C9);
 
-	} else if (bpp == 16) {	/* RGB 565 */
-		u32 col;
-
-		col = (red & 0xF800) | ((green & 0xFC00) >> 5) |
-			((blue & 0xF800) >> 11);
-		col |= col << 16;	
-		((u32 *)(info->pseudo_palette))[regno] = col;
-	} else if (bpp == 32)		/* ARGB 8888 */
-		((u32*)info->pseudo_palette)[regno] =
-			((transp & 0xFF00) <<16) 	|
-			((red & 0xFF00) << 8) 		|
-			((green & 0xFF00))		|
-			((blue & 0xFF00)>>8);
+	} else if (regno < 16) {
+		if (bpp == 16) {	/* RGB 565 */
+			u32 col;
+
+			col = (red & 0xF800) | ((green & 0xFC00) >> 5) |
+				((blue & 0xF800) >> 11);
+			col |= col << 16;
+			((u32 *)(info->pseudo_palette))[regno] = col;
+		} else if (bpp == 32)		/* ARGB 8888 */
+			((u32*)info->pseudo_palette)[regno] =
+				((transp & 0xFF00) <<16) 	|
+				((red & 0xFF00) << 8) 		|
+				((green & 0xFF00))		|
+				((blue & 0xFF00)>>8);
+	}
 
 //	debug("exit\n");
 	return 0;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
