From: akpm@linux-foundation.org
Subject: [merged] omapfb-fix-argument-of-blank-operation.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:44:09 -0700
Message-ID: <200904011844.n31Ii9HZ010298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934001AbZDATtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: felipe.contreras@nokia.com, imre.deak@solidboot.com, krzysztof.h1@poczta.fm, righi.andrea@gmail.com, rmk@arm.linux.org.uk, soni.trilok@gmail.com, mm-commits@vger.kernel.org


The patch titled
     omapfb: fix argument of blank operation
has been removed from the -mm tree.  Its filename was
     omapfb-fix-argument-of-blank-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omapfb: fix argument of blank operation
From: Felipe Contreras <felipe.contreras@nokia.com>

The blank operation should receive FB_BLANK_POWERDOWN, not VESA_POWERDOWN.

Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andrea Righi <righi.andrea@gmail.com>
Acked-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/omapfb_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/omap/omapfb_main.c~omapfb-fix-argument-of-blank-operation drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c~omapfb-fix-argument-of-blank-operation
+++ a/drivers/video/omap/omapfb_main.c
@@ -338,7 +338,7 @@ static int omapfb_blank(int blank, struc
 
 	omapfb_rqueue_lock(fbdev);
 	switch (blank) {
-	case VESA_NO_BLANKING:
+	case FB_BLANK_UNBLANK:
 		if (fbdev->state == OMAPFB_SUSPENDED) {
 			if (fbdev->ctrl->resume)
 				fbdev->ctrl->resume();
@@ -349,7 +349,7 @@ static int omapfb_blank(int blank, struc
 				do_update = 1;
 		}
 		break;
-	case VESA_POWERDOWN:
+	case FB_BLANK_POWERDOWN:
 		if (fbdev->state == OMAPFB_ACTIVE) {
 			fbdev->panel->disable(fbdev->panel);
 			if (fbdev->ctrl->suspend)
@@ -1818,7 +1818,7 @@ static int omapfb_suspend(struct platfor
 {
 	struct omapfb_device *fbdev = platform_get_drvdata(pdev);
 
-	omapfb_blank(VESA_POWERDOWN, fbdev->fb_info[0]);
+	omapfb_blank(FB_BLANK_POWERDOWN, fbdev->fb_info[0]);
 
 	return 0;
 }
@@ -1828,7 +1828,7 @@ static int omapfb_resume(struct platform
 {
 	struct omapfb_device *fbdev = platform_get_drvdata(pdev);
 
-	omapfb_blank(VESA_NO_BLANKING, fbdev->fb_info[0]);
+	omapfb_blank(FB_BLANK_UNBLANK, fbdev->fb_info[0]);
 	return 0;
 }
 
_

Patches currently in -mm which might be from felipe.contreras@nokia.com are

origin.patch

