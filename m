From: akpm@linux-foundation.org
Subject: - aty128fb-fix-blanking.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:03 -0700
Message-ID: <200705090259.l492x318010349@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970119AbXEIC7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: witekfl@poczta.onet.pl, benh@kernel.crashing.org, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     aty128fb: fix blanking
has been removed from the -mm tree.  Its filename was
     aty128fb-fix-blanking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aty128fb: fix blanking
From: Witold Filipczyk <witekfl@poczta.onet.pl>

I have a problem with blanking. The soundcard uses speakers of the monitor.
Sound is muted when the screen blanks due to a bug in aty128fb.c.

Here is a fragment of linux/fb.h
/* VESA Blanking Levels */
#define VESA_NO_BLANKING        0
#define VESA_VSYNC_SUSPEND      1
#define VESA_HSYNC_SUSPEND      2
#define VESA_POWERDOWN          3


enum {
        /* screen: unblanked, hsync: on,  vsync: on */
        FB_BLANK_UNBLANK       = VESA_NO_BLANKING,

        /* screen: blanked,   hsync: on,  vsync: on */
        FB_BLANK_NORMAL        = VESA_NO_BLANKING + 1,

        /* screen: blanked,   hsync: on,  vsync: off */
        FB_BLANK_VSYNC_SUSPEND = VESA_VSYNC_SUSPEND + 1,

        /* screen: blanked,   hsync: off, vsync: on */
        FB_BLANK_HSYNC_SUSPEND = VESA_HSYNC_SUSPEND + 1,

        /* screen: blanked,   hsync: off, vsync: off */
        FB_BLANK_POWERDOWN     = VESA_POWERDOWN + 1
};

So FB_BLANK_NORMAL is 1, FB_BLANK_VSYNC_SUSPEND is 2,
FB_BLANK_HSYNC_SUSPEND is 3, FB_BLANK_POWERDOWN is 4.
And now:
blank = FB_BLANK_NORMAL (1)
blank & FB_BLANK_HSYNC_SUSPEND (1 & 3) is true,
so normal blank caused hsync suspend and sound is muted.

Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~aty128fb-fix-blanking drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~aty128fb-fix-blanking
+++ a/drivers/video/aty/aty128fb.c
@@ -2165,18 +2165,29 @@ static void __devexit aty128_remove(stru
 static int aty128fb_blank(int blank, struct fb_info *fb)
 {
 	struct aty128fb_par *par = fb->par;
-	u8 state = 0;
+	u8 state;
 
 	if (par->lock_blank || par->asleep)
 		return 0;
 
-	if (blank & FB_BLANK_VSYNC_SUSPEND)
-		state |= 2;
-	if (blank & FB_BLANK_HSYNC_SUSPEND)
-		state |= 1;
-	if (blank & FB_BLANK_POWERDOWN)
-		state |= 4;
-
+	switch (blank) {
+	case FB_BLANK_NORMAL:
+		state = 4;
+		break;
+	case FB_BLANK_VSYNC_SUSPEND:
+		state = 6;
+		break;
+	case FB_BLANK_HSYNC_SUSPEND:
+		state = 5;
+		break;
+	case FB_BLANK_POWERDOWN:
+		state = 7;
+		break;
+	case FB_BLANK_UNBLANK:
+	default:
+		state = 0;
+		break;
+	}
 	aty_st_8(CRTC_EXT_CNTL+1, state);
 
 	if (par->chip_gen == rage_M3) {
@@ -2430,7 +2441,7 @@ static int aty128_pci_suspend(struct pci
 	wait_for_idle(par);
 
 	/* Blank display and LCD */
-	aty128fb_blank(VESA_POWERDOWN, info);
+	aty128fb_blank(FB_BLANK_POWERDOWN, info);
 
 	/* Sleep */
 	par->asleep = 1;
_

Patches currently in -mm which might be from witekfl@poczta.onet.pl are

origin.patch
