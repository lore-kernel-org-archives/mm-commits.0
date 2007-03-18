From: akpm@linux-foundation.org
Subject: - sstfb-fix-pixclock-setting-on-voodoo-1-2-cards.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:17 -0800
Message-ID: <200703180909.l2I99HV8020001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbXCRJJ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sstfb: fix pixclock setting on Voodoo 1/2 cards
has been removed from the -mm tree.  Its filename was
     sstfb-fix-pixclock-setting-on-voodoo-1-2-cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sstfb: fix pixclock setting on Voodoo 1/2 cards
From: Ondrej Zajicek <santiago@crfreenet.org>

Pixclock setting in sstfb didn't work with my Voodoo 2 card with ICS 5342 DAC
(this DAC requires two consecutive writes to one of its registers to program
pixclock - maybe first write merged with second).

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sstfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/sstfb.c~sstfb-fix-pixclock-setting-on-voodoo-1-2-cards drivers/video/sstfb.c
--- a/drivers/video/sstfb.c~sstfb-fix-pixclock-setting-on-voodoo-1-2-cards
+++ a/drivers/video/sstfb.c
@@ -257,6 +257,7 @@ static void __sst_dac_write(u8 __iomem *
 	r_dprintk("sst_dac_write(%#x, %#x)\n", reg, val);
 	reg &= 0x07;
 	__sst_write(vbase, DAC_DATA,(((u32)reg << 8)) | (u32)val);
+	__sst_wait_idle(vbase);
 }
 
 /* indexed access to ti/att dacs */
_

Patches currently in -mm which might be from santiago@crfreenet.org are

origin.patch
