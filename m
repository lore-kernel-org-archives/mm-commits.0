From: akpm@linux-foundation.org
Subject: + edac-ppc-mpc85xx-fix-mc-err-detect.patch added to -mm tree
Date: Mon, 20 Apr 2009 15:02:52 -0700
Message-ID: <200904202202.n3KM2q1S020037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757367AbZDTWIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 18:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com, benh@kernel.crashing.org, dougthompson@xmission.com, galak@kernel.crashing.org, jharan@Brocade.COM


The patch titled
     edac: ppc mpc85xx fix mc err detect
has been added to the -mm tree.  Its filename is
     edac-ppc-mpc85xx-fix-mc-err-detect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Kumar Gala <galak@kernel.crashing.org>
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

edac-ppc-mpc85xx-fix-mc-err-detect.patch

