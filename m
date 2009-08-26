From: akpm@linux-foundation.org
Subject: + sdio-add-mmc_quirk_lenient_fn0.patch added to -mm tree
Date: Wed, 26 Aug 2009 16:43:00 -0700
Message-ID: <200908262343.n7QNh0mB015236__26838.1509850316$1251330193$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342AbZHZXnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 19:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ohad@wizery.com, linux-mmc@vger.kernel.org


The patch titled
     sdio: add MMC_QUIRK_LENIENT_FN0
has been added to the -mm tree.  Its filename is
     sdio-add-mmc_quirk_lenient_fn0.patch

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
Subject: sdio: add MMC_QUIRK_LENIENT_FN0
From: Ohad Ben-Cohen <ohad@wizery.com>

Normally writes to SDIO function 0 outside the vendor specific CCCR
registers are prohibited.

To support embedded devices that require writes to SDIO function 0 outside
this range (e.g.  TI WL127x embedded sdio wifi device),
MMC_QUIRK_LENIENT_FN0 is introduced.

A card quirks field is added to `struct mmc_card' to support non-standard
devices (e.g.  embedded sdio devices).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_io.c |    2 +-
 include/linux/mmc/card.h   |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/sdio_io.c~sdio-add-mmc_quirk_lenient_fn0 drivers/mmc/core/sdio_io.c
--- a/drivers/mmc/core/sdio_io.c~sdio-add-mmc_quirk_lenient_fn0
+++ a/drivers/mmc/core/sdio_io.c
@@ -624,7 +624,7 @@ void sdio_f0_writeb(struct sdio_func *fu
 
 	BUG_ON(!func);
 
-	if (addr < 0xF0 || addr > 0xFF) {
+	if ((addr < 0xF0 || addr > 0xFF) && (!mmc_card_lenient_fn0(func->card))) {
 		if (err_ret)
 			*err_ret = -EINVAL;
 		return;
diff -puN include/linux/mmc/card.h~sdio-add-mmc_quirk_lenient_fn0 include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~sdio-add-mmc_quirk_lenient_fn0
+++ a/include/linux/mmc/card.h
@@ -97,6 +97,8 @@ struct mmc_card {
 #define MMC_STATE_READONLY	(1<<1)		/* card is read-only */
 #define MMC_STATE_HIGHSPEED	(1<<2)		/* card is in high speed mode */
 #define MMC_STATE_BLOCKADDR	(1<<3)		/* card uses block-addressing */
+	unsigned int		quirks; 	/* card quirks */
+#define MMC_QUIRK_LENIENT_FN0	(1<<0)		/* allow SDIO FN0 writes outside of the VS CCCR range */
 
 	u32			raw_cid[4];	/* raw card CID */
 	u32			raw_csd[4];	/* raw card CSD */
@@ -132,6 +134,8 @@ struct mmc_card {
 #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
 
+#define mmc_card_lenient_fn0(c)	((c)->quirks & MMC_QUIRK_LENIENT_FN0)
+
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
 
_

Patches currently in -mm which might be from ohad@wizery.com are

sdio-add-cd-disable-support.patch
sdio-add-cd-disable-support-cleanup.patch
sdio-add-mmc_quirk_lenient_fn0.patch
sdio-add-mmc_quirk_lenient_fn0-fix.patch

