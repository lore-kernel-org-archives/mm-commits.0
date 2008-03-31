From: akpm@linux-foundation.org
Subject: + lxfb-clean-up-final-bits-of-df_regs.patch added to -mm tree
Date: Mon, 31 Mar 2008 14:26:13 -0700
Message-ID: <200803312126.m2VLQDgq026797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756029AbYCaV0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 17:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     lxfb: clean up final bits of df_regs
has been added to the -mm tree.  Its filename is
     lxfb-clean-up-final-bits-of-df_regs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: clean up final bits of df_regs
From: Andres Salomon <dilinger@queued.net>

Finally drop the last remnants of df_regs, using vp_regs instead.  Also, drop
panel_width and panel_height from lxfb_par; they're unused.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h      |   12 +++++-------
 drivers/video/geode/lxfb_core.c |   12 ++++++------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff -puN drivers/video/geode/lxfb.h~lxfb-clean-up-final-bits-of-df_regs drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-clean-up-final-bits-of-df_regs
+++ a/drivers/video/geode/lxfb.h
@@ -8,12 +8,10 @@
 
 struct lxfb_par {
 	int output;
-	int panel_width;
-	int panel_height;
 
 	void __iomem *gp_regs;
 	void __iomem *dc_regs;
-	void __iomem *df_regs;
+	void __iomem *vp_regs;
 };
 
 static inline unsigned int lx_get_pitch(unsigned int xres, int bpp)
@@ -374,22 +372,22 @@ static inline void write_dc(struct lxfb_
 
 static inline uint32_t read_vp(struct lxfb_par *par, int reg)
 {
-	return readl(par->df_regs + 8*reg);
+	return readl(par->vp_regs + 8*reg);
 }
 
 static inline void write_vp(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->df_regs + 8*reg);
+	writel(val, par->vp_regs + 8*reg);
 }
 
 static inline uint32_t read_fp(struct lxfb_par *par, int reg)
 {
-	return readl(par->df_regs + 8*reg + VP_FP_START);
+	return readl(par->vp_regs + 8*reg + VP_FP_START);
 }
 
 static inline void write_fp(struct lxfb_par *par, int reg, uint32_t val)
 {
-	writel(val, par->df_regs + 8*reg + VP_FP_START);
+	writel(val, par->vp_regs + 8*reg + VP_FP_START);
 }
 
 #endif
diff -puN drivers/video/geode/lxfb_core.c~lxfb-clean-up-final-bits-of-df_regs drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-clean-up-final-bits-of-df_regs
+++ a/drivers/video/geode/lxfb_core.c
@@ -333,7 +333,7 @@ static int __init lxfb_map_video_memory(
 	if (ret)
 		return ret;
 
-	ret = pci_request_region(dev, 3, "lxfb-vip");
+	ret = pci_request_region(dev, 3, "lxfb-vp");
 
 	if (ret)
 		return ret;
@@ -360,10 +360,10 @@ static int __init lxfb_map_video_memory(
 	if (par->dc_regs == NULL)
 		return ret;
 
-	par->df_regs = ioremap(pci_resource_start(dev, 3),
+	par->vp_regs = ioremap(pci_resource_start(dev, 3),
 			       pci_resource_len(dev, 3));
 
-	if (par->df_regs == NULL)
+	if (par->vp_regs == NULL)
 		return ret;
 
 	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
@@ -507,8 +507,8 @@ err:
 		iounmap(par->dc_regs);
 		pci_release_region(pdev, 2);
 	}
-	if (par->df_regs) {
-		iounmap(par->df_regs);
+	if (par->vp_regs) {
+		iounmap(par->vp_regs);
 		pci_release_region(pdev, 3);
 	}
 
@@ -534,7 +534,7 @@ static void lxfb_remove(struct pci_dev *
 	iounmap(par->dc_regs);
 	pci_release_region(pdev, 2);
 
-	iounmap(par->df_regs);
+	iounmap(par->vp_regs);
 	pci_release_region(pdev, 3);
 
 	pci_set_drvdata(pdev, NULL);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
x86-geode-msr-cleanup.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch

