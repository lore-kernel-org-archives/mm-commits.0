From: akpm@linux-foundation.org
Subject: + drivers-edac-mpc85xx_edacc-correct-offset_in_page-mask-bits-in-edac_mc_handle_ce.patch added to -mm tree
Date: Thu, 14 Jul 2011 14:50:48 -0700
Message-ID: <201107142150.p6ELomlb003931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932320Ab1GNVvZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jul 2011 17:51:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Kai.Jiang@freescale.com, Shaohui.Xie@freescale.com, avorontsov@mvista.com, davem@davemloft.net, galak@kernel.crashing.org, grant.likely@secretlab.ca


The patch titled
     drivers/edac/mpc85xx_edac.c: correct offset_in_page mask bits in edac_mc_handle_ce()
has been added to the -mm tree.  Its filename is
     drivers-edac-mpc85xx_edacc-correct-offset_in_page-mask-bits-in-edac_mc_handle_ce.patch

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
Subject: drivers/edac/mpc85xx_edac.c: correct offset_in_page mask bits in edac_mc_handle_ce()
From: Kai.Jiang <Kai.Jiang@freescale.com>

Parameter offset_in_page in edac_mc_handle_ce() should mask the higher
bits above the page size, not the lower bits.  The original input
sometimes causes a crash.

Signed-off-by: Kai.Jiang <Kai.Jiang@freescale.com>
Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~drivers-edac-mpc85xx_edacc-correct-offset_in_page-mask-bits-in-edac_mc_handle_ce drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~drivers-edac-mpc85xx_edacc-correct-offset_in_page-mask-bits-in-edac_mc_handle_ce
+++ a/drivers/edac/mpc85xx_edac.c
@@ -854,11 +854,11 @@ static void mpc85xx_mc_check(struct mem_
 		mpc85xx_mc_printk(mci, KERN_ERR, "PFN out of range!\n");
 
 	if (err_detect & DDR_EDE_SBE)
-		edac_mc_handle_ce(mci, pfn, err_addr & PAGE_MASK,
+		edac_mc_handle_ce(mci, pfn, err_addr & ~PAGE_MASK,
 				  syndrome, row_index, 0, mci->ctl_name);
 
 	if (err_detect & DDR_EDE_MBE)
-		edac_mc_handle_ue(mci, pfn, err_addr & PAGE_MASK,
+		edac_mc_handle_ue(mci, pfn, err_addr & ~PAGE_MASK,
 				  row_index, mci->ctl_name);
 
 	out_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT, err_detect);
_

Patches currently in -mm which might be from Kai.Jiang@freescale.com are

linux-next.patch
drivers-edac-mpc85xx_edacc-correct-offset_in_page-mask-bits-in-edac_mc_handle_ce.patch

