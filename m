From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:56 -0800
Message-ID: <200612082012.kB8KCug6003047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946738AbWLHUNA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/amifb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/amifb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/amifb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/video/amifb.c~ioremap-balanced-with-iounmap-for-drivers-video-amifb drivers/video/amifb.c
--- a/drivers/video/amifb.c~ioremap-balanced-with-iounmap-for-drivers-video-amifb
+++ a/drivers/video/amifb.c
@@ -2407,10 +2407,10 @@ default_chipset:
 						   fb_info.fix.smem_len);
 	if (!videomemory) {
 		printk("amifb: WARNING! unable to map videomem cached writethrough\n");
-		videomemory = ZTWO_VADDR(fb_info.fix.smem_start);
-	}
+		fb_info.screen_base = (char *)ZTWO_VADDR(fb_info.fix.smem_start);
+	} else
+		fb_info.screen_base = (char *)videomemory;
 
-	fb_info.screen_base = (char *)videomemory;
 	memset(dummysprite, 0, DUMMYSPRITEMEMSIZE);
 
 	/*
@@ -2453,6 +2453,8 @@ static void amifb_deinit(void)
 {
 	fb_dealloc_cmap(&fb_info.cmap);
 	chipfree();
+	if (videomemory)
+		iounmap((void*)videomemory);
 	release_mem_region(CUSTOM_PHYSADDR+0xe0, 0x120);
 	custom.dmacon = DMAF_ALL | DMAF_MASTER;
 }
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

