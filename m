From: akpm@osdl.org
Subject: - atyfb-improve-atyfb_atari_probe.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:10 -0800
Message-ID: <200612082014.kB8KEAon003145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59682 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946766AbWLHUOO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Improve atyfb_atari_probe()
has been removed from the -mm tree.  Its filename was
     atyfb-improve-atyfb_atari_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Improve atyfb_atari_probe()
From: Ville Syrjala <syrjala@sci.fi>

Improve atyfb_atari_probe():
* Call correct_chipset() so that more par members, par->features in
  particular, get initialized.
* If probe fails iounmap() the mapped regions and continue probing for more
  adapters.

Only verified to cross-compile due to lack of hardware.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-improve-atyfb_atari_probe drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-improve-atyfb_atari_probe
+++ a/drivers/video/aty/atyfb_base.c
@@ -3629,6 +3629,7 @@ static int __init atyfb_atari_probe(void
 	struct fb_info *info;
 	int m64_num;
 	u32 clock_r;
+	int num_found = 0;
 
 	for (m64_num = 0; m64_num < mach64_count; m64_num++) {
 		if (!phys_vmembase[m64_num] || !phys_size[m64_num] ||
@@ -3676,16 +3677,28 @@ static int __init atyfb_atari_probe(void
 			break;
 		}
 
-		if (aty_init(info)) {
-			if (info->screen_base)
-				iounmap(info->screen_base);
-			if (par->ati_regbase)
-				iounmap(par->ati_regbase);
+		/* Fake pci_id for correct_chipset() */
+		switch (aty_ld_le32(CONFIG_CHIP_ID, par) & CFG_CHIP_TYPE) {
+		case 0x00d7:
+			par->pci_id = PCI_CHIP_MACH64GX;
+			break;
+		case 0x0057:
+			par->pci_id = PCI_CHIP_MACH64CX;
+			break;
+		default:
+			break;
+		}
+
+		if (correct_chipset(par) || aty_init(info)) {
+			iounmap(info->screen_base);
+			iounmap(par->ati_regbase);
 			framebuffer_release(info);
-			/* This is insufficient! kernel_map has added two large chunks!! */
-			return -ENXIO;
+		} else {
+			num_found++;
 		}
 	}
+
+	return num_found ? 0 : -ENXIO;
 }
 
 #endif /* CONFIG_ATARI */
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

