From: akpm@linux-foundation.org
Subject: [to-be-updated] omap_hsmmc-protect-the-card-when-the-cover-is-open.patch removed from -mm tree
Date: Wed, 29 Jul 2009 13:50:00 -0700
Message-ID: <200907292050.n6TKo0uu027808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbZG2Uup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gma


The patch titled
     omap_hsmmc: protect the card when the cover is open
has been removed from the -mm tree.  Its filename was
     omap_hsmmc-protect-the-card-when-the-cover-is-open.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap_hsmmc: protect the card when the cover is open
From: Adrian Hunter <adrian.hunter@nokia.com>

Depending on the manufacturer, there is a small possibility that removing
a card while it is being written to, can render the card permanently
unusable.  To prevent that, the card is made inaccessible when the cover
is open.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   63 ++++++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-protect-the-card-when-the-cover-is-open drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-protect-the-card-when-the-cover-is-open
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -165,6 +165,8 @@ struct omap_hsmmc_host {
 	int			context_loss;
 	int			dpm_state;
 	int			vdd;
+	int			protect_card;
+	int			reqs_blocked;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -349,6 +351,9 @@ static void send_init_stream(struct omap
 	int reg = 0;
 	unsigned long timeout;
 
+	if (host->protect_card)
+		return;
+
 	disable_irq(host->irq);
 	OMAP_HSMMC_WRITE(host->base, CON,
 		OMAP_HSMMC_READ(host->base, CON) | INIT_STREAM);
@@ -778,6 +783,30 @@ err:
 	return ret;
 }
 
+/* Protect the card while the cover is open */
+static void omap_hsmmc_protect_card(struct omap_hsmmc_host *host)
+{
+	if (!mmc_slot(host).get_cover_state)
+		return;
+
+	host->reqs_blocked = 0;
+	if (mmc_slot(host).get_cover_state(host->dev, host->slot_id)) {
+		if (host->protect_card) {
+			printk(KERN_INFO "%s: cover is closed, "
+					 "card is now accessible\n",
+					 mmc_hostname(host->mmc));
+			host->protect_card = 0;
+		}
+	} else {
+		if (!host->protect_card) {
+			printk(KERN_INFO "%s: cover is open, "
+					 "card is now inaccessible\n",
+					 mmc_hostname(host->mmc));
+			host->protect_card = 1;
+		}
+	}
+}
+
 /*
  * Work Item to notify the core about card insertion/removal
  */
@@ -795,8 +824,10 @@ static void omap_hsmmc_detect(struct wor
 
 	if (slot->card_detect)
 		carddetect = slot->card_detect(slot->card_detect_irq);
-	else
+	else {
+		omap_hsmmc_protect_card(host);
 		carddetect = -ENOSYS;
+	}
 
 	if (carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
@@ -1032,8 +1063,32 @@ static void omap_hsmmc_request(struct mm
 	 * interrupts, but not if we are already in interrupt context i.e.
 	 * retries.
 	 */
-	if (!in_interrupt())
+	if (!in_interrupt()) {
 		disable_irq(host->irq);
+		/*
+		 * Protect the card from I/O if there is a possibility
+		 * it can be removed.
+		 */
+		if (host->protect_card) {
+			if (host->reqs_blocked < 3) {
+				/*
+				 * Ensure the controller is left in a consistent
+				 * state by resetting the command and data state
+				 * machines.
+				 */
+				omap_hsmmc_reset_controller_fsm(host, SRD);
+				omap_hsmmc_reset_controller_fsm(host, SRC);
+				host->reqs_blocked += 1;
+			}
+			req->cmd->error = -EBADF;
+			if (req->data)
+				req->data->error = -EBADF;
+			enable_irq(host->irq);
+			mmc_request_done(mmc, req);
+			return;
+		} else if (host->reqs_blocked)
+			host->reqs_blocked = 0;
+	}
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
 	err = omap_hsmmc_prepare_data(host, req);
@@ -1722,6 +1777,8 @@ static int __init omap_hsmmc_probe(struc
 
 	mmc_host_lazy_disable(host->mmc);
 
+	omap_hsmmc_protect_card(host);
+
 	mmc_add_host(mmc);
 
 	if (mmc_slot(host).name != NULL) {
@@ -1887,6 +1944,8 @@ static int omap_hsmmc_resume(struct plat
 					"Unmask interrupt failed\n");
 		}
 
+		omap_hsmmc_protect_card(host);
+
 		/* Notify the core to resume the host */
 		ret = mmc_resume_host(host->mmc);
 		if (ret == 0)
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

