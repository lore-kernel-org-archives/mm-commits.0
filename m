From: akpm@linux-foundation.org
Subject: - gbefb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:20 -0700
Message-ID: <200707172307.l6HN7KtJ012180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761896AbXGQXPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     gbefb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     gbefb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gbefb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/gbefb.c |   41 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN drivers/video/gbefb.c~gbefb-the-pseudo_palette-is-only-16-elements-long drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~gbefb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/gbefb.c
@@ -86,7 +86,7 @@ static int gbe_revision;
 
 static int ypan, ywrap;
 
-static uint32_t pseudo_palette[256];
+static uint32_t pseudo_palette[16];
 
 static char *mode_option __initdata = NULL;
 
@@ -854,8 +854,7 @@ static int gbefb_setcolreg(unsigned regn
 	green >>= 8;
 	blue >>= 8;
 
-	switch (info->var.bits_per_pixel) {
-	case 8:
+	if (info->var.bits_per_pixel <= 8) {
 		/* wait for the color map FIFO to have a free entry */
 		for (i = 0; i < 1000 && gbe->cm_fifo >= 63; i++)
 			udelay(10);
@@ -864,23 +863,25 @@ static int gbefb_setcolreg(unsigned regn
 			return 1;
 		}
 		gbe->cmap[regno] = (red << 24) | (green << 16) | (blue << 8);
-		break;
-	case 15:
-	case 16:
-		red >>= 3;
-		green >>= 3;
-		blue >>= 3;
-		pseudo_palette[regno] =
-			(red << info->var.red.offset) |
-			(green << info->var.green.offset) |
-			(blue << info->var.blue.offset);
-		break;
-	case 32:
-		pseudo_palette[regno] =
-			(red << info->var.red.offset) |
-			(green << info->var.green.offset) |
-			(blue << info->var.blue.offset);
-		break;
+	} else if (regno < 16) {
+		switch (info->var.bits_per_pixel) {
+		case 15:
+		case 16:
+			red >>= 3;
+			green >>= 3;
+			blue >>= 3;
+			pseudo_palette[regno] =
+				(red << info->var.red.offset) |
+				(green << info->var.green.offset) |
+				(blue << info->var.blue.offset);
+			break;
+		case 32:
+			pseudo_palette[regno] =
+				(red << info->var.red.offset) |
+				(green << info->var.green.offset) |
+				(blue << info->var.blue.offset);
+			break;
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
