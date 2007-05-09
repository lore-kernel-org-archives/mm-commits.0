From: akpm@linux-foundation.org
Subject: - arkfb-fix-compiler-warnings.patch removed from -mm tree
Date: Wed, 09 May 2007 02:07:15 -0700
Message-ID: <200705090907.l4997Fqw018768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbXEIJHo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:07:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arkfb: fix compiler warnings
has been removed from the -mm tree.  Its filename was
     arkfb-fix-compiler-warnings.patch

This patch was dropped because it was folded into arkfb-new-framebuffer-driver-for-ark-logic-cards.patch

------------------------------------------------------
Subject: arkfb: fix compiler warnings
From: "Antonino A. Daplas" <adaplas@gmail.com>

- add sparse annotations
- check return value of pci_enable_device()
- fix if CONFIG_PM=n

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/video/arkfb.c~arkfb-fix-compiler-warnings drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-fix-compiler-warnings
+++ a/drivers/video/arkfb.c
@@ -131,21 +131,22 @@ MODULE_PARM_DESC(mtrr, "FIFO threshold")
 static void arkfb_settile(struct fb_info *info, struct fb_tilemap *map)
 {
 	const u8 *font = map->data;
-	u8* fb = (u8 *) info->screen_base;
+	u8 __iomem *fb = (u8 __iomem *)info->screen_base;
 	int i, c;
 
 	if ((map->width != 8) || (map->height != 16) ||
 	    (map->depth != 1) || (map->length != 256)) {
-	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
-			info->node, map->width, map->height, map->depth, map->length);
+	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, "
+		       "height %d, depth %d, length %d\n", info->node,
+		       map->width, map->height, map->depth, map->length);
 		return;
 	}
 
 	fb += 2;
 	for (c = 0; c < map->length; c++) {
 		for (i = 0; i < map->height; i++) {
-			fb[i * 4] = font[i];
-			fb[i * 4 + (128*8)] = font[i];
+			fb_writeb(font[i], &fb[i * 4]);
+			fb_writeb(font[i], &fb[i * 4 + (128 * 8)]);
 		}
 		fb += 128;
 
@@ -1080,6 +1081,7 @@ static void __devexit ark_pci_remove(str
 }
 
 
+#ifdef CONFIG_PM
 /* PCI suspend */
 
 static int ark_pci_suspend (struct pci_dev* dev, pm_message_t state)
@@ -1131,17 +1133,24 @@ static int ark_pci_resume (struct pci_de
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
-	pci_enable_device(dev);
+
+	if (pci_enable_device(dev))
+		goto fail;
+
 	pci_set_master(dev);
 
 	arkfb_set_par(info);
 	fb_set_suspend(info, 0);
 
 	mutex_unlock(&(par->open_lock));
+fail:
 	release_console_sem();
 	return 0;
 }
-
+#else
+#define ark_pci_suspend NULL
+#define ark_pci_resume NULL
+#endif /* CONFIG_PM */
 
 /* List of boards that we are trying to support */
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
