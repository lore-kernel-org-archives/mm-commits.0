From: akpm@linux-foundation.org
Subject: + sdio-add-quirk-to-clamp-byte-mode-transfer.patch added to -mm tree
Date: Wed, 27 Jan 2010 16:54:49 -0800
Message-ID: <201001280054.o0S0sns2010662__7467.80092963508$1264640101$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650Ab0A1Ayx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 19:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzhao@marvell.com, linux-mmc@vger.kernel.org, nico@marvell.com


The patch titled
     sdio: add quirk to clamp byte mode transfer
has been added to the -mm tree.  Its filename is
     sdio-add-quirk-to-clamp-byte-mode-transfer.patch

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
Subject: sdio: add quirk to clamp byte mode transfer
From: Bing Zhao <bzhao@marvell.com>

Some SDIO cards expect byte transfers not to exceed the configured block
transfer size.  Add a quirk to that effect.

Patches to make use of this quirk will be sent separately.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_io.c |    7 ++++++-
 include/linux/mmc/card.h   |    7 +++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/sdio_io.c~sdio-add-quirk-to-clamp-byte-mode-transfer drivers/mmc/core/sdio_io.c
--- a/drivers/mmc/core/sdio_io.c~sdio-add-quirk-to-clamp-byte-mode-transfer
+++ a/drivers/mmc/core/sdio_io.c
@@ -189,7 +189,12 @@ static inline unsigned int sdio_max_byte
 {
 	unsigned mval =	min(func->card->host->max_seg_size,
 			    func->card->host->max_blk_size);
-	mval = min(mval, func->max_blksize);
+
+	if (mmc_blksz_for_byte_mode(func->card))
+		mval = min(mval, func->cur_blksize);
+	else
+		mval = min(mval, func->max_blksize);
+
 	return min(mval, 512u); /* maximum size for byte mode */
 }
 
diff -puN include/linux/mmc/card.h~sdio-add-quirk-to-clamp-byte-mode-transfer include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~sdio-add-quirk-to-clamp-byte-mode-transfer
+++ a/include/linux/mmc/card.h
@@ -99,6 +99,8 @@ struct mmc_card {
 #define MMC_STATE_BLOCKADDR	(1<<3)		/* card uses block-addressing */
 	unsigned int		quirks; 	/* card quirks */
 #define MMC_QUIRK_LENIENT_FN0	(1<<0)		/* allow SDIO FN0 writes outside of the VS CCCR range */
+#define MMC_QUIRK_BLKSZ_FOR_BYTE_MODE (1<<1)	/* use func->cur_blksize */
+						/* for byte mode */
 
 	u32			raw_cid[4];	/* raw card CID */
 	u32			raw_csd[4];	/* raw card CSD */
@@ -139,6 +141,11 @@ static inline int mmc_card_lenient_fn0(c
 	return c->quirks & MMC_QUIRK_LENIENT_FN0;
 }
 
+static inline int mmc_blksz_for_byte_mode(const struct mmc_card *c)
+{
+	return c->quirks & MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
+}
+
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
 
_

Patches currently in -mm which might be from bzhao@marvell.com are

sdio-add-quirk-to-clamp-byte-mode-transfer.patch

