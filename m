From: akpm@osdl.org
Subject: - atyfb-fix-blanking-level.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:00 -0800
Message-ID: <200612082014.kB8KE0B0003129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946765AbWLHUOE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Fix blanking level transitions
has been removed from the -mm tree.  Its filename was
     atyfb-fix-blanking-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Fix blanking level transitions
From: Ville Syrjala <syrjala@sci.fi>

Fix a minor problem in blanking level transitions.  Reducing the blanking
level gradually was impossible.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-blanking-level drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-blanking-level
+++ a/drivers/video/aty/atyfb_base.c
@@ -2825,9 +2825,9 @@ static int atyfb_blank(int blank, struct
 #endif
 
 	gen_cntl = aty_ld_le32(CRTC_GEN_CNTL, par);
+	gen_cntl &= ~0x400004c;
 	switch (blank) {
-        	case FB_BLANK_UNBLANK:
-			gen_cntl &= ~0x400004c;
+		case FB_BLANK_UNBLANK:
 			break;
 		case FB_BLANK_NORMAL:
 			gen_cntl |= 0x4000040;
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-blanking-level.patch
atyfb-remove-pointless-aty_init.patch
atyfb-fix-__init-and-__devinit.patch
atyfb-remove-aty_cmap_regs.patch
atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

