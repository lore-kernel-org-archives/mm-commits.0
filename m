From: akpm@linux-foundation.org
Subject: - radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:57 -0700
Message-ID: <200709160927.l8G9Rv9r009295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbXIPJim (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: fix setting of PPLL_REF_DIV for RV370 5B60
has been removed from the -mm tree.  Its filename was
     radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: radeonfb: fix setting of PPLL_REF_DIV for RV370 5B60
From: Andreas Herrmann <aherrman@arcor.de>

As observed with various Radeon X300: console goes blank
without fixing setting of PPLL_REF_DIV.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60 drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60
+++ a/drivers/video/aty/radeon_base.c
@@ -1287,7 +1287,8 @@ static void radeon_write_pll_regs(struct
 	if (rinfo->family == CHIP_FAMILY_R300 ||
 	    rinfo->family == CHIP_FAMILY_RS300 ||
 	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	    rinfo->family == CHIP_FAMILY_RV350 ||
+	    rinfo->family == CHIP_FAMILY_RV380 ) {
 		if (mode->ppll_ref_div & R300_PPLL_REF_DIV_ACC_MASK) {
 			/* When restoring console mode, use saved PPLL_REF_DIV
 			 * setting.
_

Patches currently in -mm which might be from aherrman@arcor.de are

origin.patch
