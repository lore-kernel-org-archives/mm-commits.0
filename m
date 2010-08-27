From: akpm@linux-foundation.org
Subject: + omap_hsmmc-remove-unused-state-variable.patch added to -mm tree
Date: Fri, 27 Aug 2010 13:04:40 -0700
Message-ID: <201008272004.o7RK4ewY013150__1185.39458276263$1282939490$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab0H0UEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Aug 2010 16:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: saaguirre@ti.com, cjb@laptop.org, linux-mmc@vger.kernel.org, matt@console-pimps.org


The patch titled
     omap_hsmmc: remove unused local `state'
has been added to the -mm tree.  Its filename is
     omap_hsmmc-remove-unused-state-variable.patch

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
Subject: omap_hsmmc: remove unused local `state'
From: Sergio Aguirre <saaguirre@ti.com>

This fixes the following warning:

drivers/mmc/host/omap_hsmmc.c: In function 'omap_hsmmc_suspend':
drivers/mmc/host/omap_hsmmc.c:2275: warning: unused variable 'state'

Introduced by commit ID:

  commit 1a13f8fa76c880be41d6b1e6a2b44404bcbfdf9e
  Author: Matt Fleming <matt@console-pimps.org>
  Date:   Wed May 26 14:42:08 2010 -0700

      mmc: remove the "state" argument to mmc_suspend_host()

The unique usage of this var was removed there, and missed
removing the respective declaration aswell.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-remove-unused-state-variable drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-remove-unused-state-variable
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2305,7 +2305,6 @@ static int omap_hsmmc_suspend(struct dev
 	int ret = 0;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
-	pm_message_t state = PMSG_SUSPEND; /* unused by MMC core */
 
 	if (host && host->suspended)
 		return 0;
_

Patches currently in -mm which might be from saaguirre@ti.com are

omap_hsmmc-remove-unused-state-variable.patch

