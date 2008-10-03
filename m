From: akpm@linux-foundation.org
Subject: + dw_dmac-fix-copy-paste-bug-in-tasklet.patch added to -mm tree
Date: Fri, 03 Oct 2008 02:26:44 -0700
Message-ID: <200810030926.m939QieN020785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbYJCJ0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 05:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, dan.j.williams@intel.com, nicolas.ferre@atmel.com


The patch titled
     dw_dmac: fix copy/paste bug in tasklet
has been added to the -mm tree.  Its filename is
     dw_dmac-fix-copy-paste-bug-in-tasklet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dw_dmac: fix copy/paste bug in tasklet
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

The tasklet checks RAW.BLOCK twice, and does not check RAW.XFER. This is
obviously wrong, and could theoretically cause the driver to hang.

Reported-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dw_dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/dw_dmac.c~dw_dmac-fix-copy-paste-bug-in-tasklet drivers/dma/dw_dmac.c
--- a/drivers/dma/dw_dmac.c~dw_dmac-fix-copy-paste-bug-in-tasklet
+++ a/drivers/dma/dw_dmac.c
@@ -364,7 +364,7 @@ static void dw_dma_tasklet(unsigned long
 	int i;
 
 	status_block = dma_readl(dw, RAW.BLOCK);
-	status_xfer = dma_readl(dw, RAW.BLOCK);
+	status_xfer = dma_readl(dw, RAW.XFER);
 	status_err = dma_readl(dw, RAW.ERROR);
 
 	dev_vdbg(dw->dma.dev, "tasklet: status_block=%x status_err=%x\n",
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

dw_dmac-fix-copy-paste-bug-in-tasklet.patch
git-arm.patch
git-avr32.patch
git-async_tx.patch
git-mtd.patch

