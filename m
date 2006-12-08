From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:13 -0800
Message-ID: <200612082012.kB8KCDtV002988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946681AbWLHUMR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/virgefb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/virgefb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/virgefb.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/video/virgefb.c~ioremap-balanced-with-iounmap-for-drivers-video-virgefb drivers/video/virgefb.c
--- a/drivers/video/virgefb.c~ioremap-balanced-with-iounmap-for-drivers-video-virgefb
+++ a/drivers/video/virgefb.c
@@ -1799,7 +1799,7 @@ int __init virgefb_init(void)
 		#warning release resources
 		printk(KERN_ERR "virgefb.c: register_framebuffer failed\n");
 		DPRINTK("EXIT\n");
-		return -EINVAL;
+		goto out_unmap;
 	}
 
 	printk(KERN_INFO "fb%d: %s frame buffer device, using %ldK of video memory\n",
@@ -1809,6 +1809,21 @@ int __init virgefb_init(void)
 
 	DPRINTK("EXIT\n");
 	return 0;
+
+out_unmap:
+	if (board_addr >= 0x01000000) {
+		if (v_ram)
+			iounmap((void*)v_ram);
+		if (vgaio_regs)
+			iounmap(vgaio_regs);
+		if (mmio_regs)
+			iounmap(mmio_regs);
+		if (vcode_switch_base)
+			iounmap((void*)vcode_switch_base);
+		v_ram = vcode_switch_base = 0;
+		vgaio_regs = mmio_regs = NULL;
+	}
+	return -EINVAL;
 }
 
 
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch
ioremap-balanced-with-iounmap-for-drivers-video-vesafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch
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

