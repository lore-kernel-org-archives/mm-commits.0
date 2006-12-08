From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:24 -0800
Message-ID: <200612082012.kB8KCOt7003000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59376 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946721AbWLHUMy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, deller@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/stifb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/stifb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Helge Deller <deller@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/stifb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/stifb.c~ioremap-balanced-with-iounmap-for-drivers-video-stifb drivers/video/stifb.c
--- a/drivers/video/stifb.c~ioremap-balanced-with-iounmap-for-drivers-video-stifb
+++ a/drivers/video/stifb.c
@@ -1291,6 +1291,7 @@ out_err3:
 out_err2:
 	release_mem_region(fix->smem_start, fix->smem_len);
 out_err1:
+	iounmap(info->screen_base);
 	fb_dealloc_cmap(&info->cmap);
 out_err0:
 	kfree(fb);
@@ -1364,6 +1365,8 @@ stifb_cleanup(void)
 			unregister_framebuffer(sti->info);
 			release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 		        release_mem_region(info->fix.smem_start, info->fix.smem_len);
+				if (info->screen_base)
+					iounmap(info->screen_base);
 		        fb_dealloc_cmap(&info->cmap);
 		        kfree(info); 
 		}
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-platinumfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-offb.patch
ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-fm2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

