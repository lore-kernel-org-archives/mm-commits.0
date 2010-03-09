From: akpm@linux-foundation.org
Subject: [merged] sdio-dont-use-cmd-as-part-of-a-powered-sdio-resume.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:15 -0800
Message-ID: <201003091908.o29J8F9T031432__40272.837636485$1268161755$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab0CITJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:09:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cjb@laptop.org, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     sdio: don't use CMD[357] as part of a powered SDIO resume
has been removed from the -mm tree.  Its filename was
     sdio-dont-use-cmd-as-part-of-a-powered-sdio-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: don't use CMD[357] as part of a powered SDIO resume
From: Chris Ball <cjb@laptop.org>

Seen on a Marvell 8686 SDIO card and Via VX855 controller: we must avoid
sending CMD3/5/7 on a resume where power has been maintained, because the
8686 will refuse to respond to them and the MMC stack will give up on the
card.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/mmc/core/sdio.c~sdio-dont-use-cmd-as-part-of-a-powered-sdio-resume drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-dont-use-cmd-as-part-of-a-powered-sdio-resume
+++ a/drivers/mmc/core/sdio.c
@@ -224,7 +224,7 @@ static int sdio_enable_hs(struct mmc_car
  * we're trying to reinitialise.
  */
 static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
-			      struct mmc_card *oldcard)
+			      struct mmc_card *oldcard, int powered_resume)
 {
 	struct mmc_card *card;
 	int err;
@@ -235,9 +235,11 @@ static int mmc_sdio_init_card(struct mmc
 	/*
 	 * Inform the card of the voltage
 	 */
-	err = mmc_send_io_op_cond(host, host->ocr, &ocr);
-	if (err)
-		goto err;
+	if (!powered_resume) {
+		err = mmc_send_io_op_cond(host, host->ocr, &ocr);
+		if (err)
+			goto err;
+	}
 
 	/*
 	 * For SPI, enable CRC as appropriate.
@@ -262,7 +264,7 @@ static int mmc_sdio_init_card(struct mmc
 	/*
 	 * For native busses:  set card RCA and quit open drain mode.
 	 */
-	if (!mmc_host_is_spi(host)) {
+	if (!powered_resume && !mmc_host_is_spi(host)) {
 		err = mmc_send_relative_addr(host, &card->rca);
 		if (err)
 			goto remove;
@@ -273,7 +275,7 @@ static int mmc_sdio_init_card(struct mmc
 	/*
 	 * Select card, as all following commands rely on that.
 	 */
-	if (!mmc_host_is_spi(host)) {
+	if (!powered_resume && !mmc_host_is_spi(host)) {
 		err = mmc_select_card(card);
 		if (err)
 			goto remove;
@@ -437,7 +439,8 @@ static int mmc_sdio_resume(struct mmc_ho
 
 	/* Basic card reinitialization. */
 	mmc_claim_host(host);
-	err = mmc_sdio_init_card(host, host->ocr, host->card);
+	err = mmc_sdio_init_card(host, host->ocr, host->card,
+				 (host->pm_flags & MMC_PM_KEEP_POWER));
 	mmc_release_host(host);
 
 	/*
@@ -507,7 +510,7 @@ int mmc_attach_sdio(struct mmc_host *hos
 	/*
 	 * Detect and init the card.
 	 */
-	err = mmc_sdio_init_card(host, host->ocr, NULL);
+	err = mmc_sdio_init_card(host, host->ocr, NULL, 0);
 	if (err)
 		goto err;
 	card = host->card;
_

Patches currently in -mm which might be from cjb@laptop.org are


