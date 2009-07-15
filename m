From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-add-p2020ds-support.patch added to -mm tree
Date: Wed, 15 Jul 2009 12:53:05 -0700
Message-ID: <200907151953.n6FJr57s021013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756211AbZGOTyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 15:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, djiang@mvista.com, yang.shi@windriver.com


The patch titled
     edac: mpc85xx add P2020DS support
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-add-p2020ds-support.patch

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
Subject: edac: mpc85xx add P2020DS support
From: Doug Thompson <dougthompson@xmission.com>

Based on Kumar's new compatible types patch, add P2020 into MPC85xx EDAC
compatible lists so that EDAC can recognize P2020 meomry controller and L2
cache controller and export the relevant fields to sysfs.

EDAC MPC85xx DDR3 support is needed if DDR3 memory stick is installed on a
P2020DS board so that EDAC core can recognize DDR3 memory type.

Signed-off-by: Yang Shi <yang.shi@windriver.com>
Acked-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-p2020ds-support drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-p2020ds-support
+++ a/drivers/edac/mpc85xx_edac.c
@@ -646,6 +646,7 @@ static struct of_device_id mpc85xx_l2_er
 	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
+	{ .compatible = "fsl,p2020-l2-cache-controller", },
 	{},
 };
 
@@ -984,6 +985,7 @@ static struct of_device_id mpc85xx_mc_er
 	{ .compatible = "fsl,mpc8560-memory-controller", },
 	{ .compatible = "fsl,mpc8568-memory-controller", },
 	{ .compatible = "fsl,mpc8572-memory-controller", },
+	{ .compatible = "fsl,p2020-memory-controller", },
 	{},
 };
 
_

Patches currently in -mm which might be from dougthompson@xmission.com are

edac-mpc85xx-add-p2020ds-support.patch
edac-mpc85xx-add-mpc83xx-support.patch
edac-x83-fix-mchbar-high-register-addr.patch
edac-fix-resource-size-calculation.patch

