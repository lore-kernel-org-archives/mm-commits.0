From: akpm@linux-foundation.org
Subject: + blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:50:34 -0800
Message-ID: <200901130350.n0D3oYRF012988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbZAMDvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:51:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd: Blackfin NFC Driver: drop pointless casts with set_dma_callback()
has been added to the -mm tree.  Its filename is
     blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch

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
Subject: mtd: Blackfin NFC Driver: drop pointless casts with set_dma_callback()
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -572,7 +572,7 @@ static int bf5xx_nand_dma_init(struct bf
 	SSYNC();
 #endif
 
-	set_dma_callback(CH_NFC, (void *) bf5xx_nand_dma_irq, (void *) info);
+	set_dma_callback(CH_NFC, bf5xx_nand_dma_irq, info);
 
 	/* Turn off the DMA channel first */
 	disable_dma(CH_NFC);
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

