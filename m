From: akpm@linux-foundation.org
Subject: [merged] sdio-add-cd-disable-support.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:55:28 -0700
Message-ID: <200909231955.n8NJtSIT002909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbZIWUHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:07:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ohad@wizery.com, david.vrabel@csr.com, ian@mnementh.co.uk, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sdio: add CD disable support
has been removed from the -mm tree.  Its filename was
     sdio-add-cd-disable-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: add CD disable support
From: Ohad Ben-Cohen <ohad@wizery.com>

Add support to disconnect the pull-up resistor on CD/DAT[3] (pin 1)
of the card. This may be desired on certain setups of boards,
controllers and embedded sdio devices which do not need the card's
pull-up. As a result, card detection is disabled and power is saved.

[akpm@linux-foundation.org: simplify sdio_disable_cd() a bit]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: David Vrabel <david.vrabel@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c  |   30 ++++++++++++++++++++++++++++++
 include/linux/mmc/card.h |    3 ++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/sdio.c~sdio-add-cd-disable-support drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-add-cd-disable-support
+++ a/drivers/mmc/core/sdio.c
@@ -165,6 +165,29 @@ static int sdio_enable_wide(struct mmc_c
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
+	return mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
+}
+
+/*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
 static int sdio_enable_hs(struct mmc_card *card)
@@ -385,6 +408,13 @@ int mmc_attach_sdio(struct mmc_host *hos
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

origin.patch

