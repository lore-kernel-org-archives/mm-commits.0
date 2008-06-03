From: akpm@linux-foundation.org
Subject: + ssb-fix-context-assertion-in-ssb_pcicore_dev_irqvecs_enable.patch added to -mm tree
Date: Tue, 03 Jun 2008 16:05:51 -0700
Message-ID: <200806032305.m53N5pLr024619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbYFCXGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 19:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de


The patch titled
     ssb: fix context assertion in ssb_pcicore_dev_irqvecs_enable
has been added to the -mm tree.  Its filename is
     ssb-fix-context-assertion-in-ssb_pcicore_dev_irqvecs_enable.patch

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
