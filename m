From: akpm@osdl.org
Subject: - drivers-video-use-kmemdup.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:15 -0800
Message-ID: <200612082014.kB8KEFxU003154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59707 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946824AbWLHUOU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, snakebyte@gmx.de, mm-commits@vger.kernel.org


The patch titled
     drivers/video/*: use kmemdup()
has been removed from the -mm tree.  Its filename was
     drivers-video-use-kmemdup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/*: use kmemdup()
From: Alexey Dobriyan <adobriyan@gmail.com>


Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/radeon_monitor.c  |    3 +--
 drivers/video/i810/i810-i2c.c       |    4 +---
 drivers/video/intelfb/intelfbdrv.c  |    3 +--
 drivers/video/nvidia/nv_i2c.c       |    7 ++-----
 drivers/video/nvidia/nv_of.c        |    3 +--
 drivers/video/savage/savagefb-i2c.c |    7 ++-----
 6 files changed, 8 insertions(+), 19 deletions(-)

diff -puN drivers/video/aty/radeon_monitor.c~drivers-video-use-kmemdup drivers/video/aty/radeon_monitor.c
--- a/drivers/video/aty/radeon_monitor.c~drivers-video-use-kmemdup
+++ a/drivers/video/aty/radeon_monitor.c
@@ -104,10 +104,9 @@ static int __devinit radeon_parse_montyp
 	if (pedid == NULL)
 		return mt;
 
-	tmp = (u8 *)kmalloc(EDID_LENGTH, GFP_KERNEL);
+	tmp = kmemdup(pedid, EDID_LENGTH, GFP_KERNEL);
 	if (!tmp)
 		return mt;
-	memcpy(tmp, pedid, EDID_LENGTH);
 	*out_EDID = tmp;
 	return mt;
 }
diff -puN drivers/video/i810/i810-i2c.c~drivers-video-use-kmemdup drivers/video/i810/i810-i2c.c
--- a/drivers/video/i810/i810-i2c.c~drivers-video-use-kmemdup
+++ a/drivers/video/i810/i810-i2c.c
@@ -162,9 +162,7 @@ int i810_probe_i2c_connector(struct fb_i
 
 		if (e != NULL) {
 			DPRINTK("i810-i2c: Getting EDID from BIOS\n");
-			edid = kmalloc(EDID_LENGTH, GFP_KERNEL);
-			if (edid)
-				memcpy(edid, e, EDID_LENGTH);
+			edid = kmemdup(e, EDID_LENGTH, GFP_KERNEL);
 		}
 	}
 
diff -puN drivers/video/intelfb/intelfbdrv.c~drivers-video-use-kmemdup drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~drivers-video-use-kmemdup
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -1058,10 +1058,9 @@ intelfb_init_var(struct intelfb_info *di
 		u8 *edid_d = NULL;
 
 		if (edid_s) {
-			edid_d = kmalloc(EDID_LENGTH, GFP_KERNEL);
+			edid_d = kmemdup(edid_s, EDID_LENGTH, GFP_KERNEL);
 
 			if (edid_d) {
-				memcpy(edid_d, edid_s, EDID_LENGTH);
 				fb_edid_to_monspecs(edid_d,
 						    &dinfo->info->monspecs);
 				kfree(edid_d);
diff -puN drivers/video/nvidia/nv_i2c.c~drivers-video-use-kmemdup drivers/video/nvidia/nv_i2c.c
--- a/drivers/video/nvidia/nv_i2c.c~drivers-video-use-kmemdup
+++ a/drivers/video/nvidia/nv_i2c.c
@@ -210,11 +210,8 @@ int nvidia_probe_i2c_connector(struct fb
 		/* try to get from firmware */
 		const u8 *e = fb_firmware_edid(info->device);
 
-		if (e != NULL) {
-			edid = kmalloc(EDID_LENGTH, GFP_KERNEL);
-			if (edid)
-				memcpy(edid, e, EDID_LENGTH);
-		}
+		if (e != NULL)
+			edid = kmemdup(e, EDID_LENGTH, GFP_KERNEL);
 	}
 
 	*out_edid = edid;
diff -puN drivers/video/nvidia/nv_of.c~drivers-video-use-kmemdup drivers/video/nvidia/nv_of.c
--- a/drivers/video/nvidia/nv_of.c~drivers-video-use-kmemdup
+++ a/drivers/video/nvidia/nv_of.c
@@ -72,10 +72,9 @@ int nvidia_probe_of_connector(struct fb_
 		}
 	}
 	if (pedid) {
-		*out_edid = kmalloc(EDID_LENGTH, GFP_KERNEL);
+		*out_edid = kmemdup(pedid, EDID_LENGTH, GFP_KERNEL);
 		if (*out_edid == NULL)
 			return -1;
-		memcpy(*out_edid, pedid, EDID_LENGTH);
 		printk(KERN_DEBUG "nvidiafb: Found OF EDID for head %d\n", conn);
 		return 0;
 	}
diff -puN drivers/video/savage/savagefb-i2c.c~drivers-video-use-kmemdup drivers/video/savage/savagefb-i2c.c
--- a/drivers/video/savage/savagefb-i2c.c~drivers-video-use-kmemdup
+++ a/drivers/video/savage/savagefb-i2c.c
@@ -227,11 +227,8 @@ int savagefb_probe_i2c_connector(struct 
 		/* try to get from firmware */
 		const u8 *e = fb_firmware_edid(info->device);
 
-		if (e) {
-			edid = kmalloc(EDID_LENGTH, GFP_KERNEL);
-			if (edid)
-				memcpy(edid, e, EDID_LENGTH);
-		}
+		if (e)
+			edid = kmemdup(e, EDID_LENGTH, GFP_KERNEL);
 	}
 
 	*out_edid = edid;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
drivers-video-use-kmemdup.patch
git-cpufreq.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch

