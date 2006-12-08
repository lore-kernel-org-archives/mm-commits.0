From: akpm@osdl.org
Subject: - atyfb-remove-fixme.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:52 -0800
Message-ID: <200612082013.kB8KDq9T003120@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946783AbWLHUOH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     atyfb: Remove FIXME
has been removed from the -mm tree.  Its filename was
     atyfb-remove-fixme.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Remove FIXME
From: Ville Syrjala <syrjala@sci.fi>

atyfb has used the auxiliary register aperture for a long time.  Remove a
related FIXME which was accidentally left in.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-remove-fixme drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-remove-fixme
+++ a/drivers/video/aty/atyfb_base.c
@@ -2601,9 +2601,8 @@ static int __devinit aty_init(struct fb_
 		par->pll_ops->init_pll(info, &par->pll);
 
 	/*
-	 *  Last page of 8 MB (4 MB on ISA) aperture is MMIO
-	 *  FIXME: we should use the auxiliary aperture instead so we can access
-	 *  the full 8 MB of video RAM on 8 MB boards
+	 *  Last page of 8 MB (4 MB on ISA) aperture is MMIO,
+	 *  unless the auxiliary register aperture is used.
 	 */
 
 	if (!par->aux_start &&
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-remove-fixme.patch
atyfb-fix-compiler-warnings.patch
atyfb-fix-sparse-warnings.patch
atyfb-fix-blanking-level.patch
atyfb-remove-pointless-aty_init.patch
atyfb-fix-__init-and-__devinit.patch
atyfb-remove-aty_cmap_regs.patch
atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

