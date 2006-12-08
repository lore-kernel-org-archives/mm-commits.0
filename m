From: akpm@osdl.org
Subject: - ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:59 -0800
Message-ID: <200612082012.kB8KCxUi003050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59407 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946738AbWLHUND (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ioremap balanced with iounmap for drivers/video/S3triofb
has been removed from the -mm tree.  Its filename was
     ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioremap balanced with iounmap for drivers/video/S3triofb
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/S3triofb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/S3triofb.c~ioremap-balanced-with-iounmap-for-drivers-video-S3triofb drivers/video/S3triofb.c
--- a/drivers/video/S3triofb.c~ioremap-balanced-with-iounmap-for-drivers-video-S3triofb
+++ a/drivers/video/S3triofb.c
@@ -535,8 +535,11 @@ static void __init s3triofb_of_init(stru
 #endif
 
     fb_info.flags = FBINFO_FLAG_DEFAULT;
-    if (register_framebuffer(&fb_info) < 0)
-	return;
+    if (register_framebuffer(&fb_info) < 0) {
+		iounmap(fb_info.screen_base);
+		fb_info.screen_base = NULL;
+		return;
+    }
 
     printk("fb%d: S3 Trio frame buffer device on %s\n",
 	   fb_info.node, dp->full_name);
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch

