From: akpm@linux-foundation.org
Subject: [to-be-updated] omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch removed from -mm tree
Date: Wed, 29 Jul 2009 13:50:06 -0700
Message-ID: <200907292050.n6TKo6cY028046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbZG2Uwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gma


The patch titled
     omap_hsmmc: set a large data timeout for commands with busy signal
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: set a large data timeout for commands with busy signal
From: Adrian Hunter <adrian.hunter@nokia.com>

Commands like SWITCH (CMD6) send a response and then signal busy while the
operation is completed.  These commands are expected to always succeed
(otherwise the response would have indicated an error).

Set an arbitrarily large data timeout value (100ms) for these commands to
ensure that premature timeouts do not occur.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -989,7 +989,8 @@ static int omap_hsmmc_start_dma_transfer
 }
 
 static void set_data_timeout(struct omap_hsmmc_host *host,
-			     struct mmc_request *req)
+			     unsigned int timeout_ns,
+			     unsigned int timeout_clks)
 {
 	unsigned int timeout, cycle_ns;
 	uint32_t reg, clkd, dto = 0;
@@ -1000,8 +1001,8 @@ static void set_data_timeout(struct omap
 		clkd = 1;
 
 	cycle_ns = 1000000000 / (clk_get_rate(host->fclk) / clkd);
-	timeout = req->data->timeout_ns / cycle_ns;
-	timeout += req->data->timeout_clks;
+	timeout = timeout_ns / cycle_ns;
+	timeout += timeout_clks;
 	if (timeout) {
 		while ((timeout & 0x80000000) == 0) {
 			dto += 1;
@@ -1035,12 +1036,18 @@ omap_hsmmc_prepare_data(struct omap_hsmm
 
 	if (req->data == NULL) {
 		OMAP_HSMMC_WRITE(host->base, BLK, 0);
+		/*
+		 * Set an arbitrary 100ms data timeout for commands with
+		 * busy signal.
+		 */
+		if (req->cmd->flags & MMC_RSP_BUSY)
+			set_data_timeout(host, 100000000U, 0);
 		return 0;
 	}
 
 	OMAP_HSMMC_WRITE(host->base, BLK, (req->data->blksz)
 					| (req->data->blocks << 16));
-	set_data_timeout(host, req);
+	set_data_timeout(host, req->data->timeout_ns, req->data->timeout_clks);
 
 	if (host->use_dma) {
 		ret = omap_hsmmc_start_dma_transfer(host, req);
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

