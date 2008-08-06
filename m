From: akpm@linux-foundation.org
Subject: - atyfb_basec-fix-warning.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:00 -0700
Message-ID: <200808062057.m76Kv0le014724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074AbYHFVFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, adaplas@pol.net, asselsm@gmail.com, syrjala@sci.fi, mm-commits@vger.kernel.org


The patch titled
     atyfb_base.c: fix warning
has been removed from the -mm tree.  Its filename was
     atyfb_basec-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb_base.c: fix warning
From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/video/aty/atyfb_base.c:2663: warning: 'aty_resume_chip' defined
but not used

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Antonino A. Daplas <adaplas@pol.net>
Cc: Mark Asselstine <asselsm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb_basec-fix-warning drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb_basec-fix-warning
+++ a/drivers/video/aty/atyfb_base.c
@@ -244,7 +244,7 @@ static int atyfb_sync(struct fb_info *in
      */
 
 static int aty_init(struct fb_info *info);
-static void aty_resume_chip(struct fb_info *info);
+
 #ifdef CONFIG_ATARI
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
@@ -2023,6 +2023,20 @@ static int atyfb_pci_suspend(struct pci_
 	return 0;
 }
 
+static void aty_resume_chip(struct fb_info *info)
+{
+	struct atyfb_par *par = info->par;
+
+	aty_st_le32(MEM_CNTL, par->mem_cntl, par);
+
+	if (par->pll_ops->resume_pll)
+		par->pll_ops->resume_pll(info, &par->pll);
+
+	if (par->aux_start)
+		aty_st_le32(BUS_CNTL,
+			aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
+}
+
 static int atyfb_pci_resume(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
@@ -2659,19 +2673,6 @@ aty_init_exit:
 	return ret;
 }
 
-static void aty_resume_chip(struct fb_info *info)
-{
-	struct atyfb_par *par = info->par;
-
-	aty_st_le32(MEM_CNTL, par->mem_cntl, par);
-
-	if (par->pll_ops->resume_pll)
-		par->pll_ops->resume_pll(info, &par->pll);
-
-	if (par->aux_start)
-		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
-}
