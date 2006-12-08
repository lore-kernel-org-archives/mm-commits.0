From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:43 -0800
Message-ID: <200612082012.kB8KChuw003027@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946696AbWLHUMt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/ffb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/ffb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/ffb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/video/ffb.c~ioremap-balanced-with-iounmap-for-drivers-video-ffb drivers/video/ffb.c
--- a/drivers/video/ffb.c~ioremap-balanced-with-iounmap-for-drivers-video-ffb
+++ a/drivers/video/ffb.c
@@ -968,6 +968,8 @@ static int ffb_init_one(struct of_device
 
 	if (fb_alloc_cmap(&all->info.cmap, 256, 0)) {
 		printk(KERN_ERR "ffb: Could not allocate color map.\n");
+		of_iounmap(all->par.fbc, sizeof(struct ffb_fbc));
+		of_iounmap(all->par.dac, sizeof(struct ffb_dac));
 		kfree(all);
 		return -ENOMEM;
 	}
@@ -978,6 +980,8 @@ static int ffb_init_one(struct of_device
 	if (err < 0) {
 		printk(KERN_ERR "ffb: Could not register framebuffer.\n");
 		fb_dealloc_cmap(&all->info.cmap);
+		of_iounmap(all->par.fbc, sizeof(struct ffb_fbc));
+		of_iounmap(all->par.dac, sizeof(struct ffb_dac));
 		kfree(all);
 		return err;
 	}
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
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

