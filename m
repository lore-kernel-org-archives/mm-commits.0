From: akpm@linux-foundation.org
Subject: + atyfb-fix-xclk-frequency-on-apple-ibook1.patch added to -mm tree
Date: Mon, 25 Jun 2007 11:56:47 -0700
Message-ID: <200706251856.l5PIulCB008396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbXFYS5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 14:57:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, adaplas@gmail.com, olaf@aepfle.de


The patch titled
     atyfb: Fix XCLK frequency on Apple iBook1
has been added to the -mm tree.  Its filename is
     atyfb-fix-xclk-frequency-on-apple-ibook1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atyfb: Fix XCLK frequency on Apple iBook1
From: Ville Syrjala <syrjala@sci.fi>

Fix a regression on Apple iBook1.  Changes in the clock init code caused an
incorrect XCLK frequency to be used leading to a corrupted display.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-xclk-frequency-on-apple-ibook1 drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-xclk-frequency-on-apple-ibook1
+++ a/drivers/video/aty/atyfb_base.c
@@ -2290,15 +2290,6 @@ static int __devinit aty_init(struct fb_
 	init_waitqueue_head(&par->vblank.wait);
 	spin_lock_init(&par->int_lock);
 
-#ifdef CONFIG_PPC_PMAC
-	/* The Apple iBook1 uses non-standard memory frequencies. We detect it
-	 * and set the frequency manually. */
-	if (machine_is_compatible("PowerBook2,1")) {
-		par->pll_limits.mclk = 70;
-		par->pll_limits.xclk = 53;
-	}
-#endif
-
 #ifdef CONFIG_FB_ATY_GX
 	if (!M64_HAS(INTEGRATED)) {
 		u32 stat0;
@@ -2383,6 +2374,14 @@ static int __devinit aty_init(struct fb_
 			par->pll_limits.xclk = (par->pll_limits.xclk + 1) >> 1;
 	}
 #endif
+#ifdef CONFIG_PPC_PMAC
+	/* The Apple iBook1 uses non-standard memory frequencies. We detect it
+	 * and set the frequency manually. */
+	if (machine_is_compatible("PowerBook2,1")) {
+		par->pll_limits.mclk = 70;
+		par->pll_limits.xclk = 53;
+	}
+#endif
 
 	/* Allow command line to override clocks. */
 	if (pll)
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-xclk-frequency-on-apple-ibook1.patch
