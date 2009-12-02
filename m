From: akpm@linux-foundation.org
Subject: [to-be-updated] sdio-initialise-sdio-functions-and-update-card-sdio_funcs-in-lockstep.patch removed from -mm tree
Date: Wed, 02 Dec 2009 15:51:23 -0800
Message-ID: <200912022351.nB2NpNNG031853__14164.6648561165$1259797923$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbZLBXvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 18:51:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matt@console-pimps.org, dsd@laptop.org, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdio: initialise SDIO functions and update card->sdio_funcs in lockstep
has been removed from the -mm tree.  Its filename was
     sdio-initialise-sdio-functions-and-update-card-sdio_funcs-in-lockstep.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: initialise SDIO functions and update card->sdio_funcs in lockstep
From: Matt Fleming <matt@console-pimps.org>

We need to accurately track how many SDIO functions have been initialised
(and keep card->sdio_funcs in sync) so that we don't try to remove more
functions than we initialised if we hit the error path in
mmc_attach_sdio().

Without this patch if we hit the error path in mmc_attach_sdio() we run
the risk of deferencing invalid memory in sdio_remove_func(), leading to a
crash.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Cc: Daniel Drake <dsd@laptop.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/sdio.c~sdio-initialise-sdio-functions-and-update-card-sdio_funcs-in-lockstep drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~sdio-initialise-sdio-functions-and-update-card-sdio_funcs-in-lockstep
+++ a/drivers/mmc/core/sdio.c
@@ -516,7 +516,8 @@ int mmc_attach_sdio(struct mmc_host *hos
 	 * The number of functions on the card is encoded inside
 	 * the ocr.
 	 */
-	card->sdio_funcs = funcs = (ocr & 0x70000000) >> 28;
+	funcs = (ocr & 0x70000000) >> 28;
+	card->sdio_funcs = 0;
 
 	/*
 	 * If needed, disconnect card detection pull-up resistor.
@@ -528,7 +529,7 @@ int mmc_attach_sdio(struct mmc_host *hos
 	/*
 	 * Initialize (but don't add) all present functions.
 	 */
-	for (i = 0;i < funcs;i++) {
+	for (i = 0;i < funcs;i++, card->sdio_funcs++) {
 		err = sdio_init_func(host->card, i + 1);
 		if (err)
 			goto remove;
_

Patches currently in -mm which might be from matt@console-pimps.org are

linux-next.patch
sdio-initialise-sdio-functions-and-update-card-sdio_funcs-in-lockstep.patch
sdio-initialise-sdio-functions-and-update-card-sdio_funcs-in-lockstep-checkpatch-fixes.patch

