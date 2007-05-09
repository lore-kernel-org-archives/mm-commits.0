From: akpm@linux-foundation.org
Subject: - nvidiafb-fix-sparse-warning.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:54 -0700
Message-ID: <200705090300.l4930sRE010623@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032919AbXEIDA4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: fix sparse warning
has been removed from the -mm tree.  Its filename was
     nvidiafb-fix-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nvidiafb: fix sparse warning
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix the following sparse warning:

drivers/video/nvidia/nv_setup.c:659:20: warning: dereference of noderef expression

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/nvidia/nv_setup.c~nvidiafb-fix-sparse-warning drivers/video/nvidia/nv_setup.c
--- a/drivers/video/nvidia/nv_setup.c~nvidiafb-fix-sparse-warning
+++ a/drivers/video/nvidia/nv_setup.c
@@ -656,7 +656,7 @@ int NVCommonSetup(struct fb_info *info)
 	par->LVDS = 0;
 	if (par->FlatPanel && par->twoHeads) {
 		NV_WR32(par->PRAMDAC0, 0x08B0, 0x00010004);
-		if (par->PRAMDAC0[0x08b4] & 1)
+		if (NV_RD32(par->PRAMDAC0, 0x08b4) & 1)
 			par->LVDS = 1;
 		printk("nvidiafb: Panel is %s\n", par->LVDS ? "LVDS" : "TMDS");
 	}
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
