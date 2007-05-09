From: akpm@linux-foundation.org
Subject: - rivafb-fix-io-access.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:56 -0700
Message-ID: <200705090300.l4930u70010627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032929AbXEIDA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rivafb: fix IO access
has been removed from the -mm tree.  Its filename was
     rivafb-fix-io-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rivafb: fix IO access
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix IO access, with the following sparse warnings:

drivers/video/riva/fbdev.c:320:25: warning: dereference of noderef expression
drivers/video/riva/fbdev.c:321:29: warning: dereference of noderef expression
drivers/video/riva/fbdev.c:327:18: warning: dereference of noderef expression
drivers/video/riva/fbdev.c:328:15: warning: dereference of noderef expression

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/riva/fbdev.c~rivafb-fix-io-access drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~rivafb-fix-io-access
+++ a/drivers/video/riva/fbdev.c
@@ -317,15 +317,15 @@ static int riva_bl_update_status(struct 
 	else
 		level = bd->props.brightness;
 
-	tmp_pmc = par->riva.PMC[0x10F0/4] & 0x0000FFFF;
-	tmp_pcrt = par->riva.PCRTC0[0x081C/4] & 0xFFFFFFFC;
+	tmp_pmc = NV_RD32(par->riva.PMC, 0x10F0) & 0x0000FFFF;
+	tmp_pcrt = NV_RD32(par->riva.PCRTC0, 0x081C) & 0xFFFFFFFC;
 	if(level > 0) {
 		tmp_pcrt |= 0x1;
 		tmp_pmc |= (1 << 31); /* backlight bit */
 		tmp_pmc |= riva_bl_get_level_brightness(par, level) << 16; /* level */
 	}
-	par->riva.PCRTC0[0x081C/4] = tmp_pcrt;
-	par->riva.PMC[0x10F0/4] = tmp_pmc;
+	NV_WR32(par->riva.PCRTC0, 0x081C, tmp_pcrt);
+	NV_WR32(par->riva.PMC, 0x10F0, tmp_pmc);
 
 	return 0;
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
