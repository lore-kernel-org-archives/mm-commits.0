From: akpm@linux-foundation.org
Subject: + sdio-add-cd-disable-support.patch added to -mm tree
Date: Fri, 31 Jul 2009 15:59:24 -0700
Message-ID: <200907312259.n6VMxOCK017490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751447AbZGaW7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 18:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ohad@wizery.com, david.vrabel@csr.com, ian@mnementh.co.uk, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     sdio: add CD disable support
has been added to the -mm tree.  Its filename is
     sdio-add-cd-disable-support.patch

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
Subject: sdio: add CD disable support
From: Ohad Ben-Cohen <ohad@wizery.com>

Add support to disconnect the pull-up resistor on CD/DAT[3] (pin 1)
of the card. This may be desired on certain setups of boards,
controllers and embedded sdio devices which do not need the card's
pull-up. As a result, card detection is disabled and power is saved.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c  |   34 ++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h |    3 ++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/sdio.c~sdio-add-cd-disable-support drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-add-cd-disable-support
+++ a/drivers/mmc/core/sdio.c
@@ -165,6 +165,33 @@ static int sdio_enable_wide(struct mmc_c
 }
 
 /*
+ * If desired, disconnect the pull-up resistor on CD/DAT[3] (pin 1)
+ * of the card. This may be required on certain setups of boards,
+ * controllers and embedded sdio device which do not need the card's
+ * pull-up. As a result, card detection is disabled and power is saved.
+ */
+static int sdio_disable_cd(struct mmc_card *card)
+{
+	int ret;
+	u8 ctrl;
+
+	if (!card->cccr.disable_cd)
+		return 0;
+
+	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_IF, 0, &ctrl);
+	if (ret)
+		return ret;
+
+	ctrl |= SDIO_BUS_CD_DISABLE;
+
+	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
 static int sdio_enable_hs(struct mmc_card *card)
@@ -385,6 +412,13 @@ int mmc_attach_sdio(struct mmc_host *hos
 		goto remove;
 
 	/*
+	 * If needed, disconnect card detection pull-up resistor.
+	 */
+	err = sdio_disable_cd(card);
+	if (err)
+		goto remove;
+
+	/*
 	 * Initialize (but don't add) all present functions.
 	 */
 	for (i = 0;i < funcs;i++) {
diff -puN include/linux/mmc/card.h~sdio-add-cd-disable-support include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~sdio-add-cd-disable-support
+++ a/include/linux/mmc/card.h
@@ -64,7 +64,8 @@ struct sdio_cccr {
 				low_speed:1,
 				wide_bus:1,
 				high_power:1,
-				high_speed:1;
+				high_speed:1,
+				disable_cd:1;
 };
 
 struct sdio_cis {
_

Patches currently in -mm which might be from ohad@wizery.com are

sdio-add-cd-disable-support.patch
sdio-add-cd-disable-support-cleanup.patch

