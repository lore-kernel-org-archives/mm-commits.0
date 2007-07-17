From: akpm@linux-foundation.org
Subject: - fm2fb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:18 -0700
Message-ID: <200707172307.l6HN7IYT012172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935871AbXGQXPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fm2fb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     fm2fb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fm2fb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fm2fb.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/video/fm2fb.c~fm2fb-the-pseudo_palette-is-only-16-elements-long drivers/video/fm2fb.c
--- a/drivers/video/fm2fb.c~fm2fb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/fm2fb.c
@@ -195,13 +195,15 @@ static int fm2fb_blank(int blank, struct
 static int fm2fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
                          u_int transp, struct fb_info *info)
 {
-	if (regno > info->cmap.len)
-		return 1;
-	red >>= 8;
-	green >>= 8;
-	blue >>= 8;
+	if (regno < 16) {
+		red >>= 8;
+		green >>= 8;
+		blue >>= 8;
+
+		((u32*)(info->pseudo_palette))[regno] = (red << 16) |
+			(green << 8) | blue;
+	}
 
-	((u32*)(info->pseudo_palette))[regno] = (red << 16) | (green << 8) | blue;
 	return 0;
 }
 
@@ -237,7 +239,7 @@ static int __devinit fm2fb_probe(struct 
 	if (!zorro_request_device(z,"fm2fb"))
 		return -ENXIO;
 
-	info = framebuffer_alloc(256 * sizeof(u32), &z->dev);
+	info = framebuffer_alloc(16 * sizeof(u32), &z->dev);
 	if (!info) {
 		zorro_release_device(z);
 		return -ENOMEM;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
