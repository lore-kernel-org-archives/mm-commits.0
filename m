From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:26 -0800
Message-ID: <200612082012.kB8KCQXm003003@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59276 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946694AbWLHUMd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/retz3fb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/retz3fb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/retz3fb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/retz3fb.c~ioremap-balanced-with-iounmap-for-drivers-video-retz3fb drivers/video/retz3fb.c
--- a/drivers/video/retz3fb.c~ioremap-balanced-with-iounmap-for-drivers-video-retz3fb
+++ a/drivers/video/retz3fb.c
@@ -1423,8 +1423,10 @@ int __init retz3fb_init(void)
 
 		do_install_cmap(0, fb_info);
 
-		if (register_framebuffer(fb_info) < 0)
+		if (register_framebuffer(fb_info) < 0) {
+			iounmap(zinfo->base);
 			return -EINVAL;
+		}
 
 		printk(KERN_INFO "fb%d: %s frame buffer device, using %ldK of "
 		       "video memory\n", fb_info->node,
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

