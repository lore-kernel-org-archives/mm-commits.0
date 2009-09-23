From: akpm@linux-foundation.org
Subject: [merged] omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:00:49 -0700
Message-ID: <200909232000.n8NK0nvV013892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbZIWUBU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:01:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jouni.hogander@nokia.com, imre.deak@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omapfb: suspend/resume only if FB device is already initialized
has been removed from the -mm tree.  Its filename was
     omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omapfb: suspend/resume only if FB device is already initialized
From: Jouni Hogander <jouni.hogander@nokia.com>

Check wether fbdev is NULL in suspend / resume functions. Fbdev is
NULL, if there is no lcd or it is not enabled in configuration.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/omapfb_main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/omap/omapfb_main.c~omapfb-suspend-resume-only-if-fb-device-is-already-initialized drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c~omapfb-suspend-resume-only-if-fb-device-is-already-initialized
+++ a/drivers/video/omap/omapfb_main.c
@@ -1846,8 +1846,8 @@ static int omapfb_suspend(struct platfor
 {
 	struct omapfb_device *fbdev = platform_get_drvdata(pdev);
 
-	omapfb_blank(FB_BLANK_POWERDOWN, fbdev->fb_info[0]);
