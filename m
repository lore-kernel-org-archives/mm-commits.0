From: akpm@linux-foundation.org
Subject: [to-be-updated] omap_hsmmc-prevent-races-with-irq-handler.patch removed from -mm tree
Date: Wed, 29 Jul 2009 13:49:51 -0700
Message-ID: <200907292049.n6TKnpw0027576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbZG2Uuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gma


The patch titled
     omap_hsmmc: prevent races with irq handler
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-prevent-races-with-irq-handler.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: prevent races with irq handler
From: Adrian Hunter <adrian.hunter@nokia.com>

If an unexpected interrupt occurs while preparing the next request, an
oops can occur.

For example, a new request is setting up DMA for data transfer so
host->data is not NULL.  An unexpected transfer complete (TC) interrupt
comes along and the interrupt handler sets host->data to NULL.  Oops!

Prevent that by disabling interrupts while setting up a new request.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-prevent-races-with-irq-handler drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-prevent-races-with-irq-handler
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -459,6 +459,13 @@ mmc_omap_start_command(struct mmc_omap_h
 	if (host->use_dma)
 		cmdreg |= DMA_EN;
 
+	/*
+	 * In an interrupt context (i.e. STOP command), the interrupt is already
+	 * enabled, otherwise it is not (i.e. new request).
+	 */
+	if (!in_interrupt())
+		enable_irq(host->irq);
+
 	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
 	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
 }
@@ -1018,6 +1025,13 @@ static void omap_mmc_request(struct mmc_
 	struct mmc_omap_host *host = mmc_priv(mmc);
 	int err;
 
+	/*
+	 * Prevent races with the interrupt handler because of unexpected
+	 * interrupts, but not if we are already in interrupt context i.e.
+	 * retries.
+	 */
+	if (!in_interrupt())
+		disable_irq(host->irq);
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
 	err = mmc_omap_prepare_data(host, req);
@@ -1026,6 +1040,8 @@ static void omap_mmc_request(struct mmc_
 		if (req->data)
 			req->data->error = err;
 		host->mrq = NULL;
+		if (!in_interrupt())
+			enable_irq(host->irq);
 		mmc_request_done(mmc, req);
 		return;
 	}
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

