From: akpm@linux-foundation.org
Subject: [merged] davinci-mmc-modify-data-types-of-edma-related-variables.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:36 -0800
Message-ID: <200912152158.nBFLwasH015831__10707.7101165943$1260915462$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933993AbZLOWQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudhakar.raj@ti.com, dbrownell@users.sourceforge.net, linux-mmc@vger.kernel.org, purushotam@ti.com, vipin.bhandari@ti.com, mm-commits@vger.kernel.org


The patch titled
     mmc: davinci: modify data types of EDMA related variables
has been removed from the -mm tree.  Its filename was
     davinci-mmc-modify-data-types-of-edma-related-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: davinci: modify data types of EDMA related variables
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

Currently DaVinci EDMA driver supports multiple EDMA channel controller
instances.  edma_alloc_channel() api returns a 32 bit value which has the
channel controller number in MSB and the EDMA channel number in LSB.  The
variables which store the value returned by edma_alloc_channel() have to
be 32 bit wide now.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Acked-by: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: Purshotam Kumar <purushotam@ti.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/davinci_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/davinci_mmc.c~davinci-mmc-modify-data-types-of-edma-related-variables drivers/mmc/host/davinci_mmc.c
--- a/drivers/mmc/host/davinci_mmc.c~davinci-mmc-modify-data-types-of-edma-related-variables
+++ a/drivers/mmc/host/davinci_mmc.c
@@ -178,7 +178,7 @@ struct mmc_davinci_host {
 	u32 buffer_bytes_left;
 	u32 bytes_left;
 
-	u8 rxdma, txdma;
+	u32 rxdma, txdma;
 	bool use_dma;
 	bool do_dma;
 
@@ -190,7 +190,7 @@ struct mmc_davinci_host {
 	struct edmacc_param	tx_template;
 	struct edmacc_param	rx_template;
 	unsigned		n_link;
-	u8			links[NR_SG - 1];
+	u32			links[NR_SG - 1];
 
 	/* For PIO we walk scatterlists one segment at a time. */
 	unsigned int		sg_len;
_

Patches currently in -mm which might be from sudhakar.raj@ti.com are

origin.patch
linux-next.patch
mtd-nand-davinci-correct-4-bit-error-correction.patch
mtd-nand-davinci-correct-4-bit-error-correction-update.patch
davinci-fb-calculate-the-clock-divider-from-pixel-clock-info.patch

