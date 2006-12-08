From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-offb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:32 -0800
Message-ID: <200612082012.kB8KCWPR003012@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59352 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946696AbWLHUMq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/offb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-offb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/offb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/offb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/offb.c~ioremap-balanced-with-iounmap-for-drivers-video-offb drivers/video/offb.c
--- a/drivers/video/offb.c~ioremap-balanced-with-iounmap-for-drivers-video-offb
+++ a/drivers/video/offb.c
@@ -402,6 +402,9 @@ static void __init offb_init_fb(const ch
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
 	if (register_framebuffer(info) < 0) {
+		iounmap(par->cmap_adr);
+		par->cmap_adr = NULL;
+		iounmap(info->screen_base);
 		kfree(info);
 		release_mem_region(res_start, res_size);
 		return;
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

