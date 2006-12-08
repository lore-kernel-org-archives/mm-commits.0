From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:38 -0800
Message-ID: <200612082012.kB8KCcuM003019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946714AbWLHUMp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/hpfb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/hpfb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/hpfb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/hpfb.c~ioremap-balanced-with-iounmap-for-drivers-video-hpfb drivers/video/hpfb.c
--- a/drivers/video/hpfb.c~ioremap-balanced-with-iounmap-for-drivers-video-hpfb
+++ a/drivers/video/hpfb.c
@@ -295,6 +295,8 @@ static int __init hpfb_init_one(unsigned
 
 	if (register_framebuffer(&fb_info) < 0) {
 		fb_dealloc_cmap(&fb_info.cmap);
+		iounmap(fb_info.screen_base);
+		fb_info.screen_base = NULL;
 		return 1;
 	}
 
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

