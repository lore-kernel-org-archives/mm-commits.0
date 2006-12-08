From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:54 -0800
Message-ID: <200612082012.kB8KCs71003040@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59405 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946724AbWLHUNC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/atafb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/atafb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/atafb.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/video/atafb.c~ioremap-balanced-with-iounmap-for-drivers-video-atafb drivers/video/atafb.c
--- a/drivers/video/atafb.c~ioremap-balanced-with-iounmap-for-drivers-video-atafb
+++ a/drivers/video/atafb.c
@@ -2804,8 +2804,19 @@ int __init atafb_init(void)
 	atafb_set_disp(-1, &fb_info);
 	do_install_cmap(0, &fb_info);
 
-	if (register_framebuffer(&fb_info) < 0)
+	if (register_framebuffer(&fb_info) < 0) {
+#ifdef ATAFB_EXT
+		if (external_addr) {
+			iounmap(external_addr);
+			external_addr = NULL;
+		}
+		if (external_vgaiobase) {
+			iounmap((void*)external_vgaiobase);
+			external_vgaiobase = 0;
+		}
+#endif
 		return -EINVAL;
+	}
 
 	printk("Determined %dx%d, depth %d\n",
 	       disp.var.xres, disp.var.yres, disp.var.bits_per_pixel);
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

