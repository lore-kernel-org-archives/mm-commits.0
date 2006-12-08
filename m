From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:35 -0800
Message-ID: <200612082012.kB8KCZkL003015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59356 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946717AbWLHUMr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/macfb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/macfb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/macfb.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN drivers/video/macfb.c~ioremap-balanced-with-iounmap-for-drivers-video-macfb drivers/video/macfb.c
--- a/drivers/video/macfb.c~ioremap-balanced-with-iounmap-for-drivers-video-macfb
+++ a/drivers/video/macfb.c
@@ -608,6 +608,22 @@ void __init macfb_setup(char *options)
 	}
 }
 
+static void __init iounmap_macfb(void)
+{
+	if (valkyrie_cmap_regs)
+		iounmap(valkyrie_cmap_regs);
+	if (dafb_cmap_regs)
+		iounmap(dafb_cmap_regs);
+	if (v8_brazil_cmap_regs)
+		iounmap(v8_brazil_cmap_regs);
+	if (rbv_cmap_regs)
+		iounmap(rbv_cmap_regs);
+	if (civic_cmap_regs)
+		iounmap(civic_cmap_regs);
+	if (csc_cmap_regs)
+		iounmap(csc_cmap_regs);
+}
+
 static int __init macfb_init(void)
 {
 	int video_cmap_len, video_is_nubus = 0;
@@ -962,6 +978,10 @@ static int __init macfb_init(void)
 	if (!err)
 		printk("fb%d: %s frame buffer device\n",
 		       fb_info.node, fb_info.fix.id);
+	else {
+		iounmap(fb_info.screen_base);
+		iounmap_macfb();
+	}
 	return err;
 }
 
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

