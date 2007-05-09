From: akpm@linux-foundation.org
Subject: - vt8623fb-fix-compile-warnings.patch removed from -mm tree
Date: Wed, 09 May 2007 02:06:33 -0700
Message-ID: <200705090906.l4996XDS018754@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbXEIJHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vt8623fb: fix compile warnings
has been removed from the -mm tree.  Its filename was
     vt8623fb-fix-compile-warnings.patch

This patch was dropped because it was folded into vt8623fb-new-framebuffer-driver-for-via-vt8623.patch

------------------------------------------------------
Subject: vt8623fb: fix compile warnings
From: "Antonino A. Daplas" <adaplas@gmail.com>

- use memset_io()
- check for return value of pci_enable_device()
- fix for CONFIG_PM=n

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vt8623fb.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/video/vt8623fb.c~vt8623fb-fix-compile-warnings drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~vt8623fb-fix-compile-warnings
+++ a/drivers/video/vt8623fb.c
@@ -497,7 +497,7 @@ static int vt8623fb_set_par(struct fb_in
 			 (info->var.vmode & FB_VMODE_DOUBLE) ? 2 : 1, 1,
 			 1, info->node);
 
-	memset((u8*)info->screen_base, 0x00, screen_size);
+	memset_io(info->screen_base, 0x00, screen_size);
 
 	/* Device and screen back on */
 	svga_wcrt_mask(0x17, 0x80, 0x80);
@@ -804,6 +804,7 @@ static void __devexit vt8623_pci_remove(
 }
 
 
+#ifdef CONFIG_PM
 /* PCI suspend */
 
 static int vt8623_pci_suspend(struct pci_dev* dev, pm_message_t state)
@@ -855,18 +856,25 @@ static int vt8623_pci_resume(struct pci_
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
-	pci_enable_device(dev);
+
+	if (pci_enable_device(dev))
+		goto fail;
+
 	pci_set_master(dev);
 
 	vt8623fb_set_par(info);
 	fb_set_suspend(info, 0);
 
 	mutex_unlock(&(par->open_lock));
+fail:
 	release_console_sem();
 
 	return 0;
 }
-
+#else
+#define vt8623_pci_suspend NULL
+#define vt8623_pci_resume NULL
+#endif /* CONFIG_PM */
 
 /* List of boards that we are trying to support */
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
