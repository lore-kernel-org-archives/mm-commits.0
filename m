From: akpm@linux-foundation.org
Subject: [merged] fbdev-bfin-t350mcqb-fb-drop-unused-local-variables.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:55 -0700
Message-ID: <200906171839.n5HIdtEM005943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467AbZFQSpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: bfin-t350mcqb-fb: drop unused local variables
has been removed from the -mm tree.  Its filename was
     fbdev-bfin-t350mcqb-fb-drop-unused-local-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bfin-t350mcqb-fb: drop unused local variables
From: Mike Frysinger <vapier@gentoo.org>

The local fbinfo/info vars in the suspend functions don't actually get
used which cause ugly gcc warnings, so drop them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-drop-unused-local-variables drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-drop-unused-local-variables
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -637,9 +637,6 @@ static int bfin_t350mcqb_remove(struct p
 #ifdef CONFIG_PM
 static int bfin_t350mcqb_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_t350mcqbfb_info *info = fbinfo->par;
-
 	bfin_t350mcqb_disable_ppi();
 	disable_dma(CH_PPI);
 	bfin_write_PPI_STATUS(0xFFFF);
@@ -649,9 +646,6 @@ static int bfin_t350mcqb_suspend(struct 
 
 static int bfin_t350mcqb_resume(struct platform_device *pdev)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_t350mcqbfb_info *info = fbinfo->par;
