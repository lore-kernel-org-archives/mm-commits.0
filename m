From: akpm@linux-foundation.org
Subject: [merged] pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:29:24 -0700
Message-ID: <200904221829.n3MITO6E005551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbZDVSbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, eric.miao@marvell.com, mm-commits@vger.kernel.org


The patch titled
     pxafb: lcsr1 is unused without CONFIG_FB_PXA_OVERLAY
has been removed from the -mm tree.  Its filename was
     pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: lcsr1 is unused without CONFIG_FB_PXA_OVERLAY
From: "Denis V. Lunev" <den@openvz.org>

drivers/video/pxafb.c: In function 'pxafb_handle_irq':
drivers/video/pxafb.c:1442: warning: unused variable 'lcsr1'

[akpm@linux-foundation.org: save an ifdef]
Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay
+++ a/drivers/video/pxafb.c
@@ -1439,7 +1439,7 @@ static void pxafb_disable_controller(str
 static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
 {
 	struct pxafb_info *fbi = dev_id;
-	unsigned int lccr0, lcsr, lcsr1;
+	unsigned int lccr0, lcsr;
 
 	lcsr = lcd_readl(fbi, LCSR);
 	if (lcsr & LCSR_LDD) {
@@ -1455,14 +1455,16 @@ static irqreturn_t pxafb_handle_irq(int 
 	lcd_writel(fbi, LCSR, lcsr);
 
 #ifdef CONFIG_FB_PXA_OVERLAY
-	lcsr1 = lcd_readl(fbi, LCSR1);
-	if (lcsr1 & LCSR1_BS(1))
-		complete(&fbi->overlay[0].branch_done);
+	{
+		unsigned int lcsr1 = lcd_readl(fbi, LCSR1);
+		if (lcsr1 & LCSR1_BS(1))
+			complete(&fbi->overlay[0].branch_done);
 
-	if (lcsr1 & LCSR1_BS(2))
-		complete(&fbi->overlay[1].branch_done);
+		if (lcsr1 & LCSR1_BS(2))
+			complete(&fbi->overlay[1].branch_done);
 
-	lcd_writel(fbi, LCSR1, lcsr1);
+		lcd_writel(fbi, LCSR1, lcsr1);
+	}
 #endif
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from den@openvz.org are

linux-next.patch

