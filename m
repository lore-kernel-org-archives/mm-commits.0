From: akpm@linux-foundation.org
Subject: [merged] edac-ppc-mpc85xx-fix-mc-err-detect.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:52 -0700
Message-ID: <200904221830.n3MIUqgc006434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbZDVShn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, benh@kernel.crashing.org, dougthompson@xmission.com, galak@kernel.crashing.org, jharan@Brocade.COM, mm-commits@vger.kernel.org


The patch titled
     edac: ppc mpc85xx fix mc err detect
has been removed from the -mm tree.  Its filename was
     edac-ppc-mpc85xx-fix-mc-err-detect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: ppc mpc85xx fix mc err detect
From: Dave Jiang <djiang@mvista.com>

Error found by Jeff Haran.

The error detect register is 0s when no errors are detected.  The check
code is incorrect, so reverse check sense.

Reported-by: Jeff Haran <jharan@Brocade.COM>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-ppc-mpc85xx-fix-mc-err-detect drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-ppc-mpc85xx-fix-mc-err-detect
+++ a/drivers/edac/mpc85xx_edac.c
@@ -674,7 +674,7 @@ static void mpc85xx_mc_check(struct mem_
 	int row_index;
 
 	err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
-	if (err_detect)
+	if (!err_detect)
 		return;
 
 	mpc85xx_mc_printk(mci, KERN_ERR, "Err Detect Register: %#8.8x\n",
_

Patches currently in -mm which might be from djiang@mvista.com are


