From: akpm@linux-foundation.org
Subject: [merged] tridentfb-delete-acceleration-kconfig-option.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:44:19 -0700
Message-ID: <200904011844.n31IiJ24010437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758401AbZDATD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: delete acceleration Kconfig option
has been removed from the -mm tree.  Its filename was
     tridentfb-delete-acceleration-kconfig-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: delete acceleration Kconfig option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove Kconfig option for tridentfb acceleration.  The acceleration can be
switched off with modules "noaccel" parameter.

The acceleration for Trident chips was fixed in the 2.6.27 kernel.

Also, add CyberXXX and CyberBlade names to Kconfig option's name.  It should
make easier to find the tridentfb choice for cyblafb driver's users.  The
cyblafb driver has been replaced by the tridentfb driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig     |    9 +--------
 drivers/video/tridentfb.c |   12 ------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff -puN drivers/video/Kconfig~tridentfb-delete-acceleration-kconfig-option drivers/video/Kconfig
--- a/drivers/video/Kconfig~tridentfb-delete-acceleration-kconfig-option
+++ a/drivers/video/Kconfig
@@ -1598,7 +1598,7 @@ config FB_VT8623
 	  VIA VT8623 [Apollo CLE266] chipset.
 
 config FB_TRIDENT
-	tristate "Trident support"
+	tristate "Trident/CyberXXX/CyberBlade support"
 	depends on FB && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
@@ -1617,13 +1617,6 @@ config FB_TRIDENT
 	  To compile this driver as a module, choose M here: the
 	  module will be called tridentfb.
 
-config FB_TRIDENT_ACCEL
-	bool "Trident Acceleration functions (EXPERIMENTAL)"
-	depends on FB_TRIDENT && EXPERIMENTAL
-	---help---
-	This will compile the Trident frame buffer device with
-	acceleration functions.
-
 config FB_ARK
 	tristate "ARK 2000PV support"
 	depends on FB && PCI
diff -puN drivers/video/tridentfb.c~tridentfb-delete-acceleration-kconfig-option drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-delete-acceleration-kconfig-option
+++ a/drivers/video/tridentfb.c
@@ -490,7 +490,6 @@ static void tgui_copy_rect(struct triden
 /*
  * Accel functions called by the upper layers
  */
-#ifdef CONFIG_FB_TRIDENT_ACCEL
 static void tridentfb_fillrect(struct fb_info *info,
 			       const struct fb_fillrect *fr)
 {
@@ -565,11 +564,6 @@ static int tridentfb_sync(struct fb_info
 		par->wait_engine(par);
 	return 0;
 }
-#else
-#define tridentfb_fillrect cfb_fillrect
-#define tridentfb_copyarea cfb_copyarea
-#define tridentfb_imageblit cfb_imageblit
-#endif /* CONFIG_FB_TRIDENT_ACCEL */
 
 /*
  * Hardware access functions
@@ -1333,9 +1327,7 @@ static struct fb_ops tridentfb_ops = {
 	.fb_fillrect = tridentfb_fillrect,
 	.fb_copyarea = tridentfb_copyarea,
 	.fb_imageblit = tridentfb_imageblit,
-#ifdef CONFIG_FB_TRIDENT_ACCEL
 	.fb_sync = tridentfb_sync,
-#endif
 };
 
 static int __devinit trident_pci_probe(struct pci_dev *dev,
@@ -1359,10 +1351,6 @@ static int __devinit trident_pci_probe(s
 
 	chip_id = id->device;
 
-#ifndef CONFIG_FB_TRIDENT_ACCEL
-	noaccel = 1;
-#endif
