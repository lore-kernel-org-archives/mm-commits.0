From: akpm@linux-foundation.org
Subject: [merged] edac-mpc85xx-fix-build-regression-by-removing-unused-debug-code.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:14 -0800
Message-ID: <201002121903.o1CJ3E7B021098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033Ab0BLTDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:03:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ptyser@xes-inc.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: mpc85xx fix build regression by removing unused debug code
has been removed from the -mm tree.  Its filename was
     edac-mpc85xx-fix-build-regression-by-removing-unused-debug-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: mpc85xx fix build regression by removing unused debug code
From: Peter Tyser <ptyser@xes-inc.com>

Some unused, unsupported debug code existed in the mpc85xx EDAC driver
that resulted in a build failure when CONFIG_EDAC_DEBUG was defined:

  drivers/edac/mpc85xx_edac.c: In function 'mpc85xx_mc_err_probe':
  drivers/edac/mpc85xx_edac.c:1031: error: implicit declaration of function 'edac_mc_register_mcidev_debug'
  drivers/edac/mpc85xx_edac.c:1031: error: 'debug_attr' undeclared (first use in this function)
  drivers/edac/mpc85xx_edac.c:1031: error: (Each undeclared identifier is reported only once
  drivers/edac/mpc85xx_edac.c:1031: error: for each function it appears in.)

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-build-regression-by-removing-unused-debug-code drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-build-regression-by-removing-unused-debug-code
+++ a/drivers/edac/mpc85xx_edac.c
@@ -892,10 +892,6 @@ static int __devinit mpc85xx_mc_err_prob
 
 	mpc85xx_init_csrows(mci);
 
-#ifdef CONFIG_EDAC_DEBUG
-	edac_mc_register_mcidev_debug((struct attribute **)debug_attr);
-#endif
