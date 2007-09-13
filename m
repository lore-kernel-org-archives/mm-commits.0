From: akpm@linux-foundation.org
Subject: + radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch added to -mm tree
Date: Thu, 13 Sep 2007 02:12:10 -0700
Message-ID: <200709130912.l8D9CAFF011322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37408 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199AbXIMJMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 05:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aherrman@arcor.de, adaplas@pol.net, benh@kernel.crashing.org


The patch titled
     radeonfb: fix setting of PPLL_REF_DIV for RV370 5B60
has been added to the -mm tree.  Its filename is
     radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

radeonfb-add-pci-id-for-rs482-radeon-xpress-200m.patch
radeonfb-add-new-module-parameter-to-force-pll-calculation.patch
radeonfb-add-new-module-parameter-to-force-pll-calculation-fix.patch
radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch
radeonfb-use-pci-device-id-in-hex-for-name-string.patch
