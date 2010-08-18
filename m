From: akpm@linux-foundation.org
Subject: + mmc-avoid-getting-cid-on-sdio-only-cards.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:36:09 -0700
Message-ID: <201008182036.o7IKa9R8010886__19660.4389850565$1282163794$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab0HRUgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david.vrabel@csr.com, linux-mmc@vger.kernel.org, mirq-linux@rere.qmqm.pl


The patch titled
     mmc: avoid getting CID on SDIO-only cards
has been added to the -mm tree.  Its filename is
     mmc-avoid-getting-cid-on-sdio-only-cards.patch

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
Subject: mmc: avoid getting CID on SDIO-only cards
From: David Vrabel <david.vrabel@csr.com>

The introduction of support for SD combo cards breaks the initialization
of all CSR SDIO chips.  The GO_IDLE (CMD0) in mmc_sd_get_cid() causes CSR
chips to be reset (this is non-standard behavior).

When initializing an SDIO card check for a combo card by using the memory
present bit in the R4 response to IO_SEND_OP_COND (CMD5).  This avoids the
call to mmc_sd_get_cid() on an SDIO-only card.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
Cc: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c  |    8 +++++---
 include/linux/mmc/sdio.h |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/core/sdio.c~mmc-avoid-getting-cid-on-sdio-only-cards drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~mmc-avoid-getting-cid-on-sdio-only-cards
+++ a/drivers/mmc/core/sdio.c
@@ -362,11 +362,13 @@ static int mmc_sdio_init_card(struct mmc
 		goto err;
 	}
 
-	err = mmc_sd_get_cid(host, host->ocr & ocr, card->raw_cid);
-
-	if (!err) {
+	if (ocr & R4_MEMORY_PRESENT) {
 		card->type = MMC_TYPE_SD_COMBO;
 
+		err = mmc_sd_get_cid(host, host->ocr & ocr, card->raw_cid);
+		if (err)
+			goto remove;
+
 		if (oldcard && (oldcard->type != MMC_TYPE_SD_COMBO ||
 		    memcmp(card->raw_cid, oldcard->raw_cid, sizeof(card->raw_cid)) != 0)) {
 			mmc_remove_card(card);
diff -puN include/linux/mmc/sdio.h~mmc-avoid-getting-cid-on-sdio-only-cards include/linux/mmc/sdio.h
--- a/include/linux/mmc/sdio.h~mmc-avoid-getting-cid-on-sdio-only-cards
+++ a/include/linux/mmc/sdio.h
@@ -38,6 +38,8 @@
  *      [8:0] Byte/block count
  */
 
+#define R4_MEMORY_PRESENT (1 << 27)
+
 /*
   SDIO status in R5
   Type
_

Patches currently in -mm which might be from david.vrabel@csr.com are

mmc-avoid-getting-cid-on-sdio-only-cards.patch
linux-next.patch

