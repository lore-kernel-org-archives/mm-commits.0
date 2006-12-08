From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:46 -0800
Message-ID: <200612082012.kB8KCk6j003030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59367 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946724AbWLHUMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/cyberfb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/cyberfb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/cyberfb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/cyberfb.c~ioremap-balanced-with-iounmap-for-drivers-video-cyberfb drivers/video/cyberfb.c
--- a/drivers/video/cyberfb.c~ioremap-balanced-with-iounmap-for-drivers-video-cyberfb
+++ a/drivers/video/cyberfb.c
@@ -1055,6 +1055,8 @@ int __init cyberfb_init(void)
 
 	    if (register_framebuffer(&fb_info) < 0) {
 		    DPRINTK("EXIT - register_framebuffer failed\n");
+			if (CyberBase)
+				iounmap(CyberBase);
 		    release_mem_region(CyberMem_phys, 0x400000);
 		    release_mem_region(CyberRegs_phys, 0x10000);
 		    return -EINVAL;
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

