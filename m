From: akpm@linux-foundation.org
Subject: - vt8623fb-fix-compile-error-if-config_mtrr=n.patch removed from -mm tree
Date: Wed, 09 May 2007 02:06:36 -0700
Message-ID: <200705090906.l4996aBB018762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754561AbXEIJHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, santiago@crfreenet.org, mm-commits@vger.kernel.org


The patch titled
     vt8623fb: Fix compile error if CONFIG_MTRR=n
has been removed from the -mm tree.  Its filename was
     vt8623fb-fix-compile-error-if-config_mtrr=n.patch

This patch was dropped because it was folded into vt8623fb-new-framebuffer-driver-for-via-vt8623.patch

------------------------------------------------------
Subject: vt8623fb: Fix compile error if CONFIG_MTRR=n
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix compile error if CONFIG_MTRR=n

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vt8623fb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/vt8623fb.c~vt8623fb-fix-compile-error-if-config_mtrr=n drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~vt8623fb-fix-compile-error-if-config_mtrr=n
+++ a/drivers/video/vt8623fb.c
@@ -777,12 +777,10 @@ err_enable_device:
 static void __devexit vt8623_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
+	struct vt8623fb_info *par = info->par;
 
 	if (info) {
-
 #ifdef CONFIG_MTRR
-		struct vt8623fb_info *par = info->par;
-
 		if (par->mtrr_reg >= 0) {
 			mtrr_del(par->mtrr_reg, 0, 0);
 			par->mtrr_reg = -1;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
