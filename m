From: akpm@linux-foundation.org
Subject: - video-framebuffer-add-fuctional-power-management-support-to-blackfin-bf54x-lq043-framebuffer-driver.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:43 -0700
Message-ID: <200808210349.m7L3nhik015659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbYHUDtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     Video/Framebuffer: add fuctional power management support to Blackfin BF54x LQ043 framebuffer driver
has been removed from the -mm tree.  Its filename was
     video-framebuffer-add-fuctional-power-management-support-to-blackfin-bf54x-lq043-framebuffer-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Video/Framebuffer: add fuctional power management support to Blackfin BF54x LQ043 framebuffer driver
From: Michael Hennerich <michael.hennerich@analog.com>

Fix bug: does nor properply resume after suspend mem
Fix for PM_SUSPEND_MEM: Save and restore peripheral base and DMA registers

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~video-framebuffer-add-fuctional-power-management-support-to-blackfin-bf54x-lq043-framebuffer-driver drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~video-framebuffer-add-fuctional-power-management-support-to-blackfin-bf54x-lq043-framebuffer-driver
+++ a/drivers/video/bf54x-lq043fb.c
@@ -733,7 +733,6 @@ static int bfin_bf54x_remove(struct plat
 static int bfin_bf54x_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
-	struct bfin_bf54xfb_info *info = fbinfo->par;
 
 	bfin_write_EPPI0_CONTROL(bfin_read_EPPI0_CONTROL() & ~EPPI_EN);
 	disable_dma(CH_EPPI0);
@@ -747,8 +746,18 @@ static int bfin_bf54x_resume(struct plat
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
 	struct bfin_bf54xfb_info *info = fbinfo->par;
 
-	enable_dma(CH_EPPI0);
-	bfin_write_EPPI0_CONTROL(bfin_read_EPPI0_CONTROL() | EPPI_EN);
+	if (info->lq043_open_cnt) {
+
+		bfin_write_EPPI0_CONTROL(0);
+		SSYNC();
+
+		config_dma(info);
+		config_ppi(info);
+
+		/* start dma */
+		enable_dma(CH_EPPI0);
+		bfin_write_EPPI0_CONTROL(bfin_read_EPPI0_CONTROL() | EPPI_EN);
+	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

