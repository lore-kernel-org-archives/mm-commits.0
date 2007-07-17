From: akpm@linux-foundation.org
Subject: - cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:14 -0700
Message-ID: <200707172307.l6HN7Egw012163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890AbXGQXPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cyblafb: fix pseudo_palette array overrun in setcolreg
has been removed from the -mm tree.  Its filename was
     cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cyblafb: fix pseudo_palette array overrun in setcolreg
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette has only 16 elements. Do not write if regno (the array
index) is more than 15.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cyblafb.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/video/cyblafb.c~cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg drivers/video/cyblafb.c
--- a/drivers/video/cyblafb.c~cyblafb-fix-pseudo_palette-array-overrun-in-setcolreg
+++ a/drivers/video/cyblafb.c
@@ -1068,15 +1068,18 @@ static int cyblafb_setcolreg(unsigned re
 		out8(0x3C9, green >> 10);
 		out8(0x3C9, blue >> 10);
 
-	} else if (bpp == 16)	// RGB 565
-		((u32 *) info->pseudo_palette)[regno] =
-		    (red & 0xF800) |
-		    ((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
-	else if (bpp == 32)	// ARGB 8888
-		((u32 *) info->pseudo_palette)[regno] =
-		    ((transp & 0xFF00) << 16) |
-		    ((red & 0xFF00) << 8) |
-		    ((green & 0xFF00)) | ((blue & 0xFF00) >> 8);
+	} else if (regno < 16) {
+		if (bpp == 16)	// RGB 565
+			((u32 *) info->pseudo_palette)[regno] =
+				(red & 0xF800) |
+				((green & 0xFC00) >> 5) |
+				((blue & 0xF800) >> 11);
+		else if (bpp == 32)	// ARGB 8888
+			((u32 *) info->pseudo_palette)[regno] =
+				((transp & 0xFF00) << 16) |
+				((red & 0xFF00) << 8) |
+				((green & 0xFF00)) | ((blue & 0xFF00) >> 8);
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
