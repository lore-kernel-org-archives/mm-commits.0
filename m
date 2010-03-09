From: akpm@linux-foundation.org
Subject: [merged] mmc-at91_mci-enable-large-data-blocks.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:44 -0800
Message-ID: <201003091908.o29J8ixe031467__28489.4537217498$1268161817$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab0CITJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wolfgang.mues@auerswald.de, avictor.za@gmail.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     mmc: at91_mci: enable large data blocks
has been removed from the -mm tree.  Its filename was
     mmc-at91_mci-enable-large-data-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


