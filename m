From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-enable-large-data-blocks.patch added to -mm tree
Date: Tue, 02 Mar 2010 13:35:07 -0800
Message-ID: <201003022135.o22LZ8HJ030832__48041.8318570175$1267565840$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552Ab0CBVfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 16:35:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang.mues@auerswald.de, avictor.za@gmail.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com


The patch titled
     mmc: at91_mci: enable large data blocks
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-enable-large-data-blocks.patch

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
Subject: mmc: at91_mci: enable large data blocks
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

This patch is setting some max_ variables for the IO elevator, so the
elevator will put requests for large data blocks to the driver.  This is
critical for

a) speed

and

b) wear leveling of the flash chip controller: Otherwise the controller
   will treat the SD card badly with millions of single 4 KByte write
   commands.  This will lead to a shorter life time for the SD cards.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-enable-large-data-blocks drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-enable-large-data-blocks
+++ a/drivers/mmc/host/at91_mci.c
@@ -934,6 +934,9 @@ static int __init at91_mci_probe(struct 
 	mmc->max_blk_size  = MCI_MAXBLKSIZE;
 	mmc->max_blk_count = MCI_BLKATONCE;
 	mmc->max_req_size  = MCI_BUFSIZE;
+	mmc->max_phys_segs = MCI_BLKATONCE;
+	mmc->max_hw_segs   = MCI_BLKATONCE;
+	mmc->max_seg_size  = MCI_BUFSIZE;
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;
_

Patches currently in -mm which might be from wolfgang.mues@auerswald.de are

mmc-at91_mci-fix-pointer-errors.patch
mmc-at91_mci-fix-timeout-errors.patch
mmc-at91_mci-use-one-coherent-dma-buffer.patch
mmc-at91_mci-use-dma-buffer-for-read.patch
mmc-at91_mci-enable-large-data-blocks.patch
mmc-at91_mci-enable-mmc_cap_sdio_irq-only-when-it-actually-works.patch
mmc-at91_mci-introduce-per-mci-revision-conditional-code.patch

