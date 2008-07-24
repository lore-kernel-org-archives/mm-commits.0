From: akpm@linux-foundation.org
Subject: - tridentfb-acceleration-bug-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:19 -0700
Message-ID: <200807242331.m6ONVJRQ011617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756538AbYGXXbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: acceleration bug fixes
has been removed from the -mm tree.  Its filename was
     tridentfb-acceleration-bug-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: acceleration bug fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes two problems when acceleration is enabled:

 - bit for bitblt direction is corrected
   so scrolling down works as expected on 3DImage chips

 - initialization of acceleration is done later
   this helps with initial console malfuntion (on Blade3D
   chips) well documented here:
   http://marc.info/?l=linux-fbdev-users&m=111386953124478&w=2

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-acceleration-bug-fixes drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-acceleration-bug-fixes
+++ a/drivers/video/tridentfb.c
@@ -395,7 +395,7 @@ static void image_fill_rect(struct tride
 static void image_copy_rect(struct tridentfb_par *par,
 			    u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
-	int direction = 2;
+	int direction = 0x4;
 	u32 s1 = point(x1, y1);
 	u32 s2 = point(x1 + w - 1, y1 + h - 1);
 	u32 d1 = point(x2, y2);
@@ -1075,10 +1075,6 @@ static int tridentfb_set_par(struct fb_i
 	/* enable GE for text acceleration */
 	write3X4(par, GraphEngReg, 0x80);
 
-#ifdef CONFIG_FB_TRIDENT_ACCEL
-	par->init_accel(par, info->var.xres_virtual, bpp);
-#endif
