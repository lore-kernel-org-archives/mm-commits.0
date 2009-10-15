From: akpm@linux-foundation.org
Subject: + davinci-mmc-modify-data-types-of-edma-related-variables.patch added to -mm tree
Date: Thu, 15 Oct 2009 12:27:24 -0700
Message-ID: <200910151927.n9FJROeO018787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbZJOT2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 15:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sudhakar.raj@ti.com, dbrownell@users.sourceforge.net, linux-mmc@vger.kernel.org, purushotam@ti.com, vipin.bhandari@ti.com


The patch titled
     mmc: davinci: modify data types of EDMA related variables
has been added to the -mm tree.  Its filename is
     davinci-mmc-modify-data-types-of-edma-related-variables.patch

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
Subject: mmc: davinci: modify data types of EDMA related variables
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>


Currently DaVinci EDMA driver supports multiple EDMA channel
controller instances. edma_alloc_channel() api returns a 32
bit value which has the channel controller number in MSB and
the EDMA channel number in LSB. The variables which store the
value returned by edma_alloc_channel() have to be 32 bit wide
now.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Acked-by: Vipin Bhandari <vipin.bhandari@ti.com>
Cc: Purshotam Kumar <purushotam@ti.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

linux-next.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
davinci-mmc-modify-data-types-of-edma-related-variables.patch

