From: akpm@linux-foundation.org
Subject: - tgafb-sync-on-green-support-fixes.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:28 -0800
Message-ID: <200702122249.l1CMnS1E014111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030433AbXBLWww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:52:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tgafb: sync-on-green support fixes
has been removed from the -mm tree.  Its filename was
     tgafb-sync-on-green-support-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb: sync-on-green support fixes
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This sets up the deep register of the TGA ASIC as well as the blank pedestal
of the Bt463 RAMDAC correctly for the sync-on-green mode.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-sync-on-green-support-fixes drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-sync-on-green-support-fixes
+++ a/drivers/video/tgafb.c
@@ -197,7 +197,9 @@ tgafb_set_par(struct fb_info *info)
 	while (TGA_READ_REG(par, TGA_CMD_STAT_REG) & 1) /* wait for not busy */
 		continue;
 	mb();
-	TGA_WRITE_REG(par, deep_presets[tga_type], TGA_DEEP_REG);
+	TGA_WRITE_REG(par, deep_presets[tga_type] |
+			   (par->sync_on_green ? 0x0 : 0x00010000),
+		      TGA_DEEP_REG);
 	while (TGA_READ_REG(par, TGA_CMD_STAT_REG) & 1) /* wait for not busy */
 		continue;
 	mb();
@@ -261,11 +263,11 @@ tgafb_set_par(struct fb_info *info)
 
 	} else { /* 24-plane or 24plusZ */
 
-		/* Init BT463 registers.  */
+		/* Init BT463 RAMDAC registers.  */
 		BT463_WRITE(par, BT463_REG_ACC, BT463_CMD_REG_0, 0x40);
 		BT463_WRITE(par, BT463_REG_ACC, BT463_CMD_REG_1, 0x08);
 		BT463_WRITE(par, BT463_REG_ACC, BT463_CMD_REG_2,
-			    (par->sync_on_green ? 0x80 : 0x40));
+			    (par->sync_on_green ? 0xc0 : 0x40));
 
 		BT463_WRITE(par, BT463_REG_ACC, BT463_READ_MASK_0, 0xff);
 		BT463_WRITE(par, BT463_REG_ACC, BT463_READ_MASK_1, 0xff);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
