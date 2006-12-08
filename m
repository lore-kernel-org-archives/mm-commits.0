From: akpm@osdl.org
Subject: - atyfb-remove-pointless-aty_init.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:02 -0800
Message-ID: <200612082014.kB8KE256003132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59654 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946782AbWLHUOH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Remove pointless aty_init() argument
has been removed from the -mm tree.  Its filename was
     atyfb-remove-pointless-aty_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Remove pointless aty_init() argument
From: Ville Syrjala <syrjala@sci.fi>

The 'name' argument of aty_init() is pointless because the bus type can be
queried from the hardware.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-remove-pointless-aty_init drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-remove-pointless-aty_init
+++ a/drivers/video/aty/atyfb_base.c
@@ -249,7 +249,7 @@ static int atyfb_sync(struct fb_info *in
      *  Internal routines
      */
 
-static int aty_init(struct fb_info *info, const char *name);
+static int aty_init(struct fb_info *info);
 #ifdef CONFIG_ATARI
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
@@ -2344,7 +2344,7 @@ static int __devinit atyfb_get_timings_f
 }
 #endif /* defined(__i386__) && defined(CONFIG_FB_ATY_GENERIC_LCD) */
 
-static int __devinit aty_init(struct fb_info *info, const char *name)
+static int __devinit aty_init(struct fb_info *info)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
 	const char *ramname = NULL, *xtal;
@@ -2748,7 +2748,7 @@ static int __devinit aty_init(struct fb_
 	fb_list = info;
 
 	PRINTKI("fb%d: %s frame buffer device on %s\n",
-	       info->node, info->fix.id, name);
+		info->node, info->fix.id, par->bus_type == ISA ? "ISA" : "PCI");
 	return 0;
 
 aty_init_exit:
@@ -3597,7 +3597,7 @@ static int __devinit atyfb_pci_probe(str
 	pci_set_drvdata(pdev, info);
 
 	/* Init chip & register framebuffer */
-	if (aty_init(info, "PCI"))
+	if (aty_init(info))
 		goto err_release_io;
 
 #ifdef __sparc__
@@ -3697,7 +3697,7 @@ static int __devinit atyfb_atari_probe(v
 			break;
 		}
 
-		if (aty_init(info, "ISA bus")) {
+		if (aty_init(info)) {
 			if (info->screen_base)
 				iounmap(info->screen_base);
 			if (par->ati_regbase)
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-remove-pointless-aty_init.patch
atyfb-fix-__init-and-__devinit.patch
atyfb-remove-aty_cmap_regs.patch
atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

