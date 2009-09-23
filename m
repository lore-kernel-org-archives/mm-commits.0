From: akpm@linux-foundation.org
Subject: [merged] omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:54:51 -0700
Message-ID: <200909231954.n8NJspAq001525__6344.63320388949$1253736546$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbZIWUIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, philipl@overt.


The patch titled
     omap_hsmmc: fix scatter-gather list sanity checking
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: fix scatter-gather list sanity checking
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Do not use host->dma_len when it is uninitialzed.  Finish the request with
an error if the mmc_omap_prepare_data() fails.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Cc: "Madhusudhan" <madhu.cr@ti.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-fix-scatter-gather-list-sanity-checking drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-fix-scatter-gather-list-sanity-checking
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -878,7 +878,7 @@ mmc_omap_start_dma_transfer(struct mmc_o
 	struct mmc_data *data = req->data;
 
 	/* Sanity check: all the SG entries must be aligned by block size. */
-	for (i = 0; i < host->dma_len; i++) {
+	for (i = 0; i < data->sg_len; i++) {
 		struct scatterlist *sgl;
 
 		sgl = data->sg + i;
@@ -1021,10 +1021,20 @@ static int omap_mmc_disable(struct mmc_h
 static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
 {
 	struct mmc_omap_host *host = mmc_priv(mmc);
+	int err;
 
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
-	mmc_omap_prepare_data(host, req);
+	err = mmc_omap_prepare_data(host, req);
+	if (err) {
+		req->cmd->error = err;
+		if (req->data)
+			req->data->error = err;
+		host->mrq = NULL;
+		mmc_request_done(mmc, req);
+		return;
+	}
+
 	mmc_omap_start_command(host, req->cmd, req->data);
 }
 
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

origin.patch

