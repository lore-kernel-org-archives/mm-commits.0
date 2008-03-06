From: akpm@linux-foundation.org
Subject: + stifb-fix-crash-a1439a-crx-rattler-graphics-card.patch added to -mm tree
Date: Wed, 05 Mar 2008 22:33:50 -0800
Message-ID: <200803060633.m266Xoc8012850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756745AbYCFGeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 01:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de


The patch titled
     stifb: fix crash A1439A CRX (Rattler) graphics card
has been added to the -mm tree.  Its filename is
     stifb-fix-crash-a1439a-crx-rattler-graphics-card.patch

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
Subject: stifb: fix crash A1439A CRX (Rattler) graphics card
From: Helge Deller <deller@gmx.de>

Fix kernel crash when stifb driver is used with a A1439A CRX (Rattler)
graphics card.  (Reference:
http://thread.gmane.org/gmane.linux.ports.hppa/1834)

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/stifb.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN drivers/video/stifb.c~stifb-fix-crash-a1439a-crx-rattler-graphics-card drivers/video/stifb.c
--- a/drivers/video/stifb.c~stifb-fix-crash-a1439a-crx-rattler-graphics-card
+++ a/drivers/video/stifb.c
@@ -505,16 +505,24 @@ ngleSetupAttrPlanes(struct stifb_info *f
 static void
 rattlerSetupPlanes(struct stifb_info *fb)
 {
+	int saved_id, y;
+
+ 	/* Write RAMDAC pixel read mask register so all overlay
+	 * planes are display-enabled.  (CRX24 uses Bt462 pixel
+	 * read mask register for overlay planes, not image planes).
+	 */
 	CRX24_SETUP_RAMDAC(fb);
     
-	/* replacement for: SETUP_FB(fb, CRX24_OVERLAY_PLANES); */
-	WRITE_WORD(0x83000300, fb, REG_14);
-	SETUP_HW(fb);
-	WRITE_BYTE(1, fb, REG_16b1);
+	/* change fb->id temporarily to fool SETUP_FB() */
+	saved_id = fb->id;
+	fb->id = CRX24_OVERLAY_PLANES;
+	SETUP_FB(fb);
+	fb->id = saved_id;
+
+	for (y = 0; y < fb->info.var.yres; ++y)
+		memset(fb->info.screen_base + y * fb->info.fix.line_length,
+			0xff, fb->info.var.xres * fb->info.var.bits_per_pixel/8);
 
-	fb_memset((void*)fb->info.fix.smem_start, 0xff,
-		fb->info.var.yres*fb->info.fix.line_length);
-    
 	CRX24_SET_OVLY_MASK(fb);
 	SETUP_FB(fb);
 }
_

Patches currently in -mm which might be from deller@gmx.de are

stifb-fix-crash-a1439a-crx-rattler-graphics-card.patch

