From: akpm@linux-foundation.org
Subject: [merged] fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:28 -0800
Message-ID: <200912162035.nBGKZS79013100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935279AbZLPUfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: bfin-t350mcqb-fb: handle all resources in suspend/resume
has been removed from the -mm tree.  Its filename was
     fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bfin-t350mcqb-fb: handle all resources in suspend/resume
From: Michael Hennerich <michael.hennerich@analog.com>

The LCD commands DMA/timers as well as PPI which we need to save/restore.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-t350mcqb-fb.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -634,17 +634,35 @@ static int __devexit bfin_t350mcqb_remov
 #ifdef CONFIG_PM
 static int bfin_t350mcqb_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	bfin_t350mcqb_disable_ppi();
-	disable_dma(CH_PPI);
-	bfin_write_PPI_STATUS(0xFFFF);
+	struct fb_info *fbinfo = platform_get_drvdata(pdev);
+	struct bfin_t350mcqbfb_info *fbi = fbinfo->par;
+
+	if (fbi->lq043_open_cnt) {
+		bfin_t350mcqb_disable_ppi();
+		disable_dma(CH_PPI);
+		bfin_t350mcqb_stop_timers();
+		bfin_write_PPI_STATUS(-1);
+	}
+
 
 	return 0;
 }
 
 static int bfin_t350mcqb_resume(struct platform_device *pdev)
 {
-	enable_dma(CH_PPI);
-	bfin_t350mcqb_enable_ppi();
+	struct fb_info *fbinfo = platform_get_drvdata(pdev);
+	struct bfin_t350mcqbfb_info *fbi = fbinfo->par;
+
+	if (fbi->lq043_open_cnt) {
+		bfin_t350mcqb_config_dma(fbi);
+		bfin_t350mcqb_config_ppi(fbi);
+		bfin_t350mcqb_init_timers();
+
+		/* start dma */
+		enable_dma(CH_PPI);
+		bfin_t350mcqb_enable_ppi();
+		bfin_t350mcqb_start_timers();
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
linux-next.patch

