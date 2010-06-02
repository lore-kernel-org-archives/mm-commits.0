From: akpm@linux-foundation.org
Subject: + omap-remove-bug_on-for-disabled-interrupts.patch added to -mm tree
Date: Wed, 02 Jun 2010 14:05:59 -0700
Message-ID: <201006022105.o52L5xqC016900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758615Ab0FBVGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 17:06:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darkstar6262@gmail.com, linux-mmc@vger.kernel.org, tony@atomide.com


The patch titled
     omap: remove BUG_ON for disabled interrupts
has been added to the -mm tree.  Its filename is
     omap-remove-bug_on-for-disabled-interrupts.patch

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
Subject: omap: remove BUG_ON for disabled interrupts
From: Cory Maccarrone <darkstar6262@gmail.com>

Remove a BUG_ON for when interrupts are disabled during an MMC request.

During boot, interrupts can be disabled when a request is made, causing
this bug to be triggered.  In reality, there's no reason this should halt
the kernel, as the driver has proved reliable in spite of disabled
interrupts, and additionally, there's nothing in this code that would
require interrupts to be enabled.

Signed-off-by: Cory Maccarrone <darkstar6262@gmail.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/mmc/host/omap.c~omap-remove-bug_on-for-disabled-interrupts drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~omap-remove-bug_on-for-disabled-interrupts
+++ a/drivers/mmc/host/omap.c
@@ -1157,7 +1157,6 @@ static void mmc_omap_start_request(struc
 	mmc_omap_start_command(host, req->cmd);
 	if (host->dma_in_use)
 		omap_start_dma(host->dma_ch);
-	BUG_ON(irqs_disabled());
 }
 
 static void mmc_omap_request(struct mmc_host *mmc, struct mmc_request *req)
_

Patches currently in -mm which might be from darkstar6262@gmail.com are

linux-next.patch
omap-remove-bug_on-for-disabled-interrupts.patch

