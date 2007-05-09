From: akpm@linux-foundation.org
Subject: - arkfb-fix-compile-error-if-config_mtrr=n.patch removed from -mm tree
Date: Wed, 09 May 2007 02:07:18 -0700
Message-ID: <200705090907.l4997IbI018771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874AbXEIJHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     arkfb: Fix compile error if CONFIG_MTRR=n
has been removed from the -mm tree.  Its filename was
     arkfb-fix-compile-error-if-config_mtrr=n.patch

This patch was dropped because it was folded into arkfb-new-framebuffer-driver-for-ark-logic-cards.patch

------------------------------------------------------
Subject: arkfb: Fix compile error if CONFIG_MTRR=n
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix compile error if CONFIG_MTRR=n

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/arkfb.c~arkfb-fix-compile-error-if-config_mtrr=n drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-fix-compile-error-if-config_mtrr=n
+++ a/drivers/video/arkfb.c
@@ -1055,12 +1055,10 @@ err_enable_device:
 static void __devexit ark_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
+	struct arkfb_info *par = info->par;
 
 	if (info) {
-
 #ifdef CONFIG_MTRR
-		struct arkfb_info *par = info->par;
-
 		if (par->mtrr_reg >= 0) {
 			mtrr_del(par->mtrr_reg, 0, 0);
 			par->mtrr_reg = -1;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
