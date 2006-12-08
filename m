From: akpm@osdl.org
Subject: - atyfb-fix-sparse-warnings.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:58 -0800
Message-ID: <200612082013.kB8KDwBV003126@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59642 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946756AbWLHUOD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Fix sparse warnings
has been removed from the -mm tree.  Its filename was
     atyfb-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Fix sparse warnings
From: Ville Syrjala <syrjala@sci.fi>

Silence some sparse warnings:
* Remove casts from atari out_le32() and friends.
* Move accel functions' declarations to atyfb.h.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/aty/atyfb.h~atyfb-fix-sparse-warnings drivers/video/aty/atyfb.h
--- a/drivers/video/aty/atyfb.h~atyfb-fix-sparse-warnings
+++ a/drivers/video/aty/atyfb.h
@@ -227,7 +227,7 @@ static inline u32 aty_ld_le32(int regind
 		regindex -= 0x800;
 
 #ifdef CONFIG_ATARI
-	return in_le32((volatile u32 *)(par->ati_regbase + regindex));
+	return in_le32(par->ati_regbase + regindex);
 #else
 	return readl(par->ati_regbase + regindex);
 #endif
@@ -240,7 +240,7 @@ static inline void aty_st_le32(int regin
 		regindex -= 0x800;
 
 #ifdef CONFIG_ATARI
-	out_le32((volatile u32 *)(par->ati_regbase + regindex), val);
+	out_le32(par->ati_regbase + regindex, val);
 #else
 	writel(val, par->ati_regbase + regindex);
 #endif
@@ -253,7 +253,7 @@ static inline void aty_st_le16(int regin
 	if (regindex >= 0x400)
 		regindex -= 0x800;
 #ifdef CONFIG_ATARI
-	out_le16((volatile u16 *)(par->ati_regbase + regindex), val);
+	out_le16(par->ati_regbase + regindex, val);
 #else
 	writel(val, par->ati_regbase + regindex);
 #endif
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-sparse-warnings.patch
atyfb-fix-blanking-level.patch
atyfb-remove-pointless-aty_init.patch
atyfb-fix-__init-and-__devinit.patch
atyfb-remove-aty_cmap_regs.patch
atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

