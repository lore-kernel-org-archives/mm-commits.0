From: akpm@linux-foundation.org
Subject: - ssb-fix-context-assertion-in-ssb_pcicore_dev_irqvecs_enable.patch removed from -mm tree
Date: Thu, 05 Jun 2008 11:21:49 -0700
Message-ID: <200806051821.m55ILnB8023255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbYFESWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     ssb: fix context assertion in ssb_pcicore_dev_irqvecs_enable
has been removed from the -mm tree.  Its filename was
     ssb-fix-context-assertion-in-ssb_pcicore_dev_irqvecs_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ssb: fix context assertion in ssb_pcicore_dev_irqvecs_enable
From: Michael Buesch <mb@bu3sch.de>

This fixes a context assertion in ssb that makes b44 print out warnings on
resume.

This fixes the following kernel oops:
http://www.kerneloops.org/oops.php?number=12732
http://www.kerneloops.org/oops.php?number=11410

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/driver_pcicore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ssb/driver_pcicore.c~ssb-fix-context-assertion-in-ssb_pcicore_dev_irqvecs_enable drivers/ssb/driver_pcicore.c
--- a/drivers/ssb/driver_pcicore.c~ssb-fix-context-assertion-in-ssb_pcicore_dev_irqvecs_enable
+++ a/drivers/ssb/driver_pcicore.c
@@ -537,12 +537,12 @@ int ssb_pcicore_dev_irqvecs_enable(struc
 	int err = 0;
 	u32 tmp;
 
-	might_sleep();
