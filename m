From: akpm@linux-foundation.org
Subject: - video_sh_mobile_ceu-should-depend-on-has_dma.patch removed from -mm tree
Date: Thu, 28 Aug 2008 14:49:00 -0700
Message-ID: <200808282149.m7SLn0Vm016151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733AbYH1VtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 17:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, damm@igel.co.jp, lethal@linux-sh.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
has been removed from the -mm tree.  Its filename was
     video_sh_mobile_ceu-should-depend-on-has_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>

ERROR: "dma_alloc_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
ERROR: "dma_sync_single_for_cpu" [drivers/media/video/videobuf-dma-contig.ko] undefined!
ERROR: "dma_free_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!

commit 0d3244d6439c8c31d2a29efd587c7aca9042c8aa ("V4L/DVB (8342):
sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3") introduced
VIDEO_SH_MOBILE_CEU, which selects VIDEOBUF_DMA_CONTIG.  This circumvents
the dependency on HAS_DMA of VIDEOBUF_DMA_CONTIG.

Add a dependency on HAS_DMA to VIDEO_SH_MOBILE_CEU to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Magnus Damm <damm@igel.co.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/Kconfig~video_sh_mobile_ceu-should-depend-on-has_dma drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~video_sh_mobile_ceu-should-depend-on-has_dma
+++ a/drivers/media/video/Kconfig
@@ -968,7 +968,7 @@ config VIDEO_PXA27x
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
-	depends on VIDEO_DEV
+	depends on VIDEO_DEV && HAS_DMA
 	select SOC_CAMERA
 	select VIDEOBUF_DMA_CONTIG
 	---help---
_

Patches currently in -mm which might be from geert@linux-m68k.org are

m68k-update-defconfigs.patch
linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch
viafb-viafbmodes-viafbtxt.patch
viafb-viafbmodes-viafbtxt-fix.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch

