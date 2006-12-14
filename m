From: akpm@osdl.org
Subject: + fbdev-update-after-backlight-argument-change.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:00:29 -0800
Message-ID: <200612140000.kBE00Tcr025286@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59291 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbWLNAAk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:00:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jsimmons@infradead.org, Luming.yu@intel.com, adaplas@pol.net, greg@kroah.com, len.brown@intel.com


The patch titled
     fbdev: update after backlight argument change
has been added to the -mm tree.  Its filename is
     fbdev-update-after-backlight-argument-change.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: update after backlight argument change
From: James Simmons <jsimmons@infradead.org>

Update the frambuffer drivers to the backlight_device_registers changes.

Signed-off-by: James Simmons <jsimmons@infradead.org>
Cc: Luming Yu <Luming.yu@intel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/aty128fb.c         |    2 +-
 drivers/video/aty/atyfb_base.c       |    2 +-
 drivers/video/aty/radeon_backlight.c |    2 +-
 drivers/video/nvidia/nv_backlight.c  |    2 +-
 drivers/video/riva/fbdev.c           |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~fbdev-update-after-backlight-argument-change drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~fbdev-update-after-backlight-argument-change
+++ a/drivers/video/aty/aty128fb.c
@@ -1834,7 +1834,7 @@ static void aty128_bl_init(struct aty128
 
 	snprintf(name, sizeof(name), "aty128bl%d", info->node);
 
-	bd = backlight_device_register(name, par, &aty128_bl_data);
+	bd = backlight_device_register(name, info->dev, par, &aty128_bl_data);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "aty128: Backlight registration failed\n");
diff -puN drivers/video/aty/atyfb_base.c~fbdev-update-after-backlight-argument-change drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~fbdev-update-after-backlight-argument-change
+++ a/drivers/video/aty/atyfb_base.c
@@ -2211,7 +2211,7 @@ static void aty_bl_init(struct atyfb_par
 
 	snprintf(name, sizeof(name), "atybl%d", info->node);
 
-	bd = backlight_device_register(name, par, &aty_bl_data);
+	bd = backlight_device_register(name, info->dev, par, &aty_bl_data);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "aty: Backlight registration failed\n");
diff -puN drivers/video/aty/radeon_backlight.c~fbdev-update-after-backlight-argument-change drivers/video/aty/radeon_backlight.c
--- a/drivers/video/aty/radeon_backlight.c~fbdev-update-after-backlight-argument-change
+++ a/drivers/video/aty/radeon_backlight.c
@@ -163,7 +163,7 @@ void radeonfb_bl_init(struct radeonfb_in
 
 	snprintf(name, sizeof(name), "radeonbl%d", rinfo->info->node);
 
-	bd = backlight_device_register(name, pdata, &radeon_bl_data);
+	bd = backlight_device_register(name, rinfo->info->dev, pdata, &radeon_bl_data);
 	if (IS_ERR(bd)) {
 		rinfo->info->bl_dev = NULL;
 		printk("radeonfb: Backlight registration failed\n");
diff -puN drivers/video/nvidia/nv_backlight.c~fbdev-update-after-backlight-argument-change drivers/video/nvidia/nv_backlight.c
--- a/drivers/video/nvidia/nv_backlight.c~fbdev-update-after-backlight-argument-change
+++ a/drivers/video/nvidia/nv_backlight.c
@@ -141,7 +141,7 @@ void nvidia_bl_init(struct nvidia_par *p
 
 	snprintf(name, sizeof(name), "nvidiabl%d", info->node);
 
-	bd = backlight_device_register(name, par, &nvidia_bl_data);
+	bd = backlight_device_register(name, info->dev, par, &nvidia_bl_data);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "nvidia: Backlight registration failed\n");
diff -puN drivers/video/riva/fbdev.c~fbdev-update-after-backlight-argument-change drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~fbdev-update-after-backlight-argument-change
+++ a/drivers/video/riva/fbdev.c
@@ -384,7 +384,7 @@ static void riva_bl_init(struct riva_par
 
 	snprintf(name, sizeof(name), "rivabl%d", info->node);
 
-	bd = backlight_device_register(name, par, &riva_bl_data);
+	bd = backlight_device_register(name, info->dev, par, &riva_bl_data);
 	if (IS_ERR(bd)) {
 		info->bl_dev = NULL;
 		printk(KERN_WARNING "riva: Backlight registration failed\n");
_

Patches currently in -mm which might be from jsimmons@infradead.org are

origin.patch
remove-references-to-non-existent.patch
sstfb-add-sysfs-interface.patch
fbdev-update-after-backlight-argument-change.patch
proper-backlight-selection-for-fbdev-drivers.patch
fbdev-driver-for-s3-trio-virge.patch
remove-broken-video-drivers-v4.patch

