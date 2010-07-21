From: akpm@linux-foundation.org
Subject: + omap-hsmmc-fix-processing-of-all-dma-interrupts-as-block-completion.patch added to -mm tree
Date: Wed, 21 Jul 2010 16:14:08 -0700
Message-ID: <201007212314.o6LNE8HC020615__31183.3795313307$1279754085$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292Ab0GUXOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 19:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: svenkatr@ti.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com


The patch titled
     omap hsmmc: fix processing of all dma interrupts as block completion
has been added to the -mm tree.  Its filename is
     omap-hsmmc-fix-processing-of-all-dma-interrupts-as-block-completion.patch

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
Subject: omap hsmmc: fix processing of all dma interrupts as block completion
From: Venkatraman S <svenkatr@ti.com>

If other informative interrupts are enabled for the DMA channel used by
hsmmc, those are incorrectly treated as block completion.  This patch lets
only the block completion interrupt to be processed.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-fix-processing-of-all-dma-interrupts-as-block-completion drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-fix-processing-of-all-dma-interrupts-as-block-completion
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -1280,8 +1280,11 @@ static void omap_hsmmc_dma_cb(int lch, u
 	struct mmc_data *data = host->mrq->data;
 	int dma_ch, req_in_progress;
 
-	if (ch_status & OMAP2_DMA_MISALIGNED_ERR_IRQ)
-		dev_dbg(mmc_dev(host->mmc), "MISALIGNED_ADRS_ERR\n");
+	if (!(ch_status & OMAP_DMA_BLOCK_IRQ)) {
+		dev_warn(mmc_dev(host->mmc), "unexpected dma status %x\n",
+			ch_status);
+		return;
+	}
 
 	spin_lock(&host->irq_lock);
 	if (host->dma_ch < 0) {
_

Patches currently in -mm which might be from svenkatr@ti.com are

mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch
omap-hsmmc-fix-processing-of-all-dma-interrupts-as-block-completion.patch

