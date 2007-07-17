From: akpm@linux-foundation.org
Subject: - matroxfb-color-setting-fixes-fix.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:59 -0700
Message-ID: <200707172307.l6HN7xhK012237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935225AbXGQXPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, VANDROVE@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     matroxfb: color setting fixes fix
has been removed from the -mm tree.  Its filename was
     matroxfb-color-setting-fixes-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: matroxfb: color setting fixes fix
From: "Antonino A. Daplas" <adaplas@gmail.com>

Remove more code that writes to cmap[16].

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_accel.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/matrox/matroxfb_accel.c~matroxfb-color-setting-fixes-fix drivers/video/matrox/matroxfb_accel.c
--- a/drivers/video/matrox/matroxfb_accel.c~matroxfb-color-setting-fixes-fix
+++ a/drivers/video/matrox/matroxfb_accel.c
@@ -91,7 +91,6 @@ static inline void matrox_cfb4_pal(u_int
 	for (i = 0; i < 16; i++) {
 		pal[i] = i * 0x11111111U;
 	}
-	pal[i] = 0xFFFFFFFF;
 }
 
 static inline void matrox_cfb8_pal(u_int32_t* pal) {
@@ -100,7 +99,6 @@ static inline void matrox_cfb8_pal(u_int
 	for (i = 0; i < 16; i++) {
 		pal[i] = i * 0x01010101U;
 	}
-	pal[i] = 0x0F0F0F0F;
 }
 
 static void matroxfb_copyarea(struct fb_info* info, const struct fb_copyarea* area);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
