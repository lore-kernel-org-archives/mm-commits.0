From: akpm@linux-foundation.org
Subject: + blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:50:30 -0800
Message-ID: <200901130350.n0D3oUfs012966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbZAMDut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org


The patch titled
     mtd: Blackfin NFC Driver: do not clobber DMAC1_PERIMUX
has been added to the -mm tree.  Its filename is
     blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch

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
Subject: mtd: Blackfin NFC Driver: do not clobber DMAC1_PERIMUX
From: Mike Frysinger <vapier.adi@gmail.com>

Only set DMAC1_PERIMUX once we have requested and been granted the dma
channel to prevent breaking other peripherals in the error case

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-do-not-clobber-dmac1_perimux drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-do-not-clobber-dmac1_perimux
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -552,7 +552,6 @@ static void bf5xx_nand_dma_write_buf(str
 static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 {
 	int ret;
-	unsigned short val;
 
 	/* Do not use dma */
 	if (!hardware_ecc)
@@ -560,13 +559,6 @@ static int bf5xx_nand_dma_init(struct bf
 
 	init_completion(&info->dma_completion);
 
-#ifdef CONFIG_BF54x
-	/* Setup DMAC1 channel mux for NFC which shared with SDH */
-	val = bfin_read_DMAC1_PERIMUX();
-	val &= 0xFFFE;
-	bfin_write_DMAC1_PERIMUX(val);
-	SSYNC();
-#endif
 	/* Request NFC DMA channel */
 	ret = request_dma(CH_NFC, "BF5XX NFC driver");
 	if (ret < 0) {
@@ -574,6 +566,12 @@ static int bf5xx_nand_dma_init(struct bf
 		return ret;
 	}
 
+#ifdef CONFIG_BF54x
+	/* Setup DMAC1 channel mux for NFC which shared with SDH */
+	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() & ~1);
+	SSYNC();
+#endif
+
 	set_dma_callback(CH_NFC, (void *) bf5xx_nand_dma_irq, (void *) info);
 
 	/* Turn off the DMA channel first */
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

