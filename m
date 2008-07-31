From: akpm@linux-foundation.org
Subject: + radeonfb-revert-fix-radeon-ddc-regression.patch added to -mm tree
Date: Thu, 31 Jul 2008 01:58:54 -0700
Message-ID: <200807310858.m6V8wscd014030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbYGaI7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 04:59:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, benh@kernel.crashing.org


The patch titled
     radeonfb: revert "Fix radeon DDC regression"
has been added to the -mm tree.  Its filename is
     radeonfb-revert-fix-radeon-ddc-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: revert "Fix radeon DDC regression"
From: Jean Delvare <khali@linux-fr.org>

The bug was in fb_ddc and was fixed by commit
b64d70825abbf706bbe80be1b11b09514b71f45e (fb_ddc: fix DDC lines quirk) so
the workaround in radeonfb can be removed now.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_i2c.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/video/aty/radeon_i2c.c~radeonfb-revert-fix-radeon-ddc-regression drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~radeonfb-revert-fix-radeon-ddc-regression
+++ a/drivers/video/aty/radeon_i2c.c
@@ -139,12 +139,8 @@ void radeon_delete_i2c_busses(struct rad
 int radeon_probe_i2c_connector(struct radeonfb_info *rinfo, int conn,
 			       u8 **out_edid)
 {
-	u32 reg = rinfo->i2c[conn-1].ddc_reg;
 	u8 *edid;
 
-	OUTREG(reg, INREG(reg) &
-			~(VGA_DDC_DATA_OUTPUT | VGA_DDC_CLK_OUTPUT));
