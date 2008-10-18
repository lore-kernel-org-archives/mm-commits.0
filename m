From: akpm@linux-foundation.org
Subject: - cirrusfb-drop-device-pointers-from-cirrusfb_info.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:14 -0700
Message-ID: <200810182317.m9INHEO4029041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbYJRXRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: drop device pointers from cirrusfb_info
has been removed from the -mm tree.  Its filename was
     cirrusfb-drop-device-pointers-from-cirrusfb_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: drop device pointers from cirrusfb_info
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The device pointer can be easily obtained from fb_info->device if needed.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-drop-device-pointers-from-cirrusfb_info drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-drop-device-pointers-from-cirrusfb_info
+++ a/drivers/video/cirrusfb.c
@@ -367,15 +367,8 @@ struct cirrusfb_info {
 
 	struct cirrusfb_regs currentmode;
 	int blank_mode;
+	u32 pseudo_palette[16];
 
-	u32	pseudo_palette[16];
-
-#ifdef CONFIG_ZORRO
-	struct zorro_dev *zdev;
-#endif
-#ifdef CONFIG_PCI
-	struct pci_dev *pdev;
-#endif
 	void (*unmap)(struct fb_info *info);
 };
 
@@ -2183,8 +2176,7 @@ static void get_pci_addrs(const struct p
 
 static void cirrusfb_pci_unmap(struct fb_info *info)
 {
-	struct cirrusfb_info *cinfo = info->par;
-	struct pci_dev *pdev = cinfo->pdev;
+	struct pci_dev *pdev = to_pci_dev(info->device);
 
 	iounmap(info->screen_base);
 #if 0 /* if system didn't claim this region, we would... */
@@ -2200,14 +2192,16 @@ static void cirrusfb_pci_unmap(struct fb
 static void __devexit cirrusfb_zorro_unmap(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
-	zorro_release_device(cinfo->zdev);
+	struct zorro_dev *zdev = to_zorro_dev(info->device);
+
+	zorro_release_device(zdev);
 
 	if (cinfo->btype == BT_PICASSO4) {
 		cinfo->regbase -= 0x600000;
 		iounmap((void *)cinfo->regbase);
 		iounmap(info->screen_base);
 	} else {
-		if (zorro_resource_start(cinfo->zdev) > 0x01000000)
+		if (zorro_resource_start(zdev) > 0x01000000)
 			iounmap(info->screen_base);
 	}
 }
@@ -2348,7 +2342,6 @@ static int cirrusfb_pci_register(struct 
 	}
 
 	cinfo = info->par;
-	cinfo->pdev = pdev;
 	cinfo->btype = btype = (enum cirrus_board) ent->driver_data;
 
 	DPRINTK(" Found PCI device, base address 0 is 0x%x, btype set to %d\n",
@@ -2484,7 +2477,6 @@ static int cirrusfb_zorro_register(struc
 	assert(z);
 	assert(btype != BT_NONE);
 
-	cinfo->zdev = z;
 	board_addr = zorro_resource_start(z);
 	board_size = zorro_resource_len(z);
 	info->screen_size = size;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

