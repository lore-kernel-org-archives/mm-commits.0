From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-fifo-underflow-management-rework.patch added to -mm tree
Date: Tue, 20 May 2008 18:56:14 -0700
Message-ID: <200805210156.m4L1uEUf022711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765777AbYEUB41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 21:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux@maxim.org.za


The patch titled
     atmel_lcdfb: FIFO underflow management rework
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-fifo-underflow-management-rework.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: FIFO underflow management rework
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Manage atmel_lcdfb FIFO underflow rework

Resetting the LCD and DMA allows to fix screen shifting after
a FIFO underflow. It follows reset sequence from errata
"LCD Screen Shifting After a Reset".

Reworked following Andrew Morton comments.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-fifo-underflow-management-rework drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-fifo-underflow-management-rework
+++ a/drivers/video/atmel_lcdfb.c
@@ -384,6 +384,8 @@ static int atmel_lcdfb_check_var(struct 
  */
 static void atmel_lcdfb_reset(struct atmel_lcdfb_info *sinfo)
 {
+	might_sleep();
+
 	/* LCD power off */
 	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
 
@@ -428,6 +430,8 @@ static int atmel_lcdfb_set_par(struct fb
 	unsigned long clk_value_khz;
 	unsigned long bits_per_line;
 
+	might_sleep();
+
 	dev_dbg(info->device, "%s:\n", __func__);
 	dev_dbg(info->device, "  * resolution: %ux%u (%ux%u virtual)\n",
 		 info->var.xres, info->var.yres,
@@ -869,7 +873,8 @@ static int __init atmel_lcdfb_probe(stru
 		goto unmap_mmio;
 	}
 
-	/* Initialize bottom half workqueue */
+	/* Some operations on the LCDC might sleep and
+	 * require a preemptible task context */
 	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
 
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
@@ -914,6 +919,7 @@ static int __init atmel_lcdfb_probe(stru
 free_cmap:
 	fb_dealloc_cmap(&info->cmap);
 unregister_irqs:
+	cancel_work_sync(&sinfo->task);
 	free_irq(sinfo->irq_base, info);
 unmap_mmio:
 	exit_backlight(sinfo);
@@ -951,6 +957,7 @@ static int __exit atmel_lcdfb_remove(str
 	if (!sinfo)
 		return 0;
 
+	cancel_work_sync(&sinfo->task);
 	exit_backlight(sinfo);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(0);
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

atmel_lcdfb-fifo-underflow-management.patch
atmel_lcdfb-fifo-underflow-management-rework.patch

