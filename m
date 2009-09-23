From: akpm@linux-foundation.org
Subject: [merged] mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:21 -0700
Message-ID: <200909231956.n8NJuLMk004669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbZIWT4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nico@fluxnic.net, linux-mmc@vger.kernel.org, nico@marvell.com, mm-commits@vger.kernel.org


The patch titled
     mmc: propagate error codes back from bus drivers' suspend/resume methods
has been removed from the -mm tree.  Its filename was
     mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: propagate error codes back from bus drivers' suspend/resume methods
From: Nicolas Pitre <nico@fluxnic.net>

Especially for SDIO drivers which may have special conditions/errors to
report, it is a good thing to relay the returned error code back to upper
layers.

This also allows for the rationalization of the resume path where code to
"remove" a no-longer-existing or replaced card was duplicated into the
MMC, SD and SDIO bus drivers.

In the SDIO case, if a function suspend method returns an error, then all
previously suspended functions are resumed and the error returned.  An
exception is made for -ENOSYS which the core interprets as "we don't
support suspend so just kick the card out for suspend and return success".

When resuming SDIO cards, the core code only validates the manufacturer
and product IDs to make sure the same kind of card is still present before
invoking functions resume methods.  It's the function driver's
responsibility to perform further tests to confirm that the actual same
card is present (same MAC address, etc.) and return an error otherwise.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |   35 +++++++++++++++++++-----
 drivers/mmc/core/core.h |    4 +-
 drivers/mmc/core/mmc.c  |   15 +++-------
 drivers/mmc/core/sd.c   |   15 +++-------
 drivers/mmc/core/sdio.c |   54 ++++++++++++++++++++------------------
 5 files changed, 69 insertions(+), 54 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods
+++ a/drivers/mmc/core/core.c
@@ -1236,6 +1236,8 @@ EXPORT_SYMBOL(mmc_card_can_sleep);
  */
 int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 {
+	int err = 0;
+
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
@@ -1244,21 +1246,26 @@ int mmc_suspend_host(struct mmc_host *ho
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
 		if (host->bus_ops->suspend)
-			host->bus_ops->suspend(host);
-		if (!host->bus_ops->resume) {
+			err = host->bus_ops->suspend(host);
+		if (err == -ENOSYS || !host->bus_ops->resume) {
+			/*
+			 * We simply "remove" the card in this case.
+			 * It will be redetected on resume.
+			 */
 			if (host->bus_ops->remove)
 				host->bus_ops->remove(host);
-
 			mmc_claim_host(host);
 			mmc_detach_bus(host);
 			mmc_release_host(host);
+			err = 0;
 		}
 	}
 	mmc_bus_put(host);
 
-	mmc_power_off(host);
+	if (!err)
+		mmc_power_off(host);
 
-	return 0;
+	return err;
 }
 
 EXPORT_SYMBOL(mmc_suspend_host);
@@ -1269,12 +1276,26 @@ EXPORT_SYMBOL(mmc_suspend_host);
  */
 int mmc_resume_host(struct mmc_host *host)
 {
+	int err = 0;
+
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
 		mmc_power_up(host);
 		mmc_select_voltage(host, host->ocr);
 		BUG_ON(!host->bus_ops->resume);
-		host->bus_ops->resume(host);
+		err = host->bus_ops->resume(host);
+		if (err) {
+			printk(KERN_WARNING "%s: error %d during resume "
+					    "(card was removed?)\n",
+					    mmc_hostname(host), err);
+			if (host->bus_ops->remove)
+				host->bus_ops->remove(host);
+			mmc_claim_host(host);
+			mmc_detach_bus(host);
+			mmc_release_host(host);
+			/* no need to bother upper layers */
+			err = 0;
+		}
 	}
 	mmc_bus_put(host);
 
@@ -1284,7 +1305,7 @@ int mmc_resume_host(struct mmc_host *hos
 	 */
 	mmc_detect_change(host, 1);
 
-	return 0;
+	return err;
 }
 
 EXPORT_SYMBOL(mmc_resume_host);
diff -puN drivers/mmc/core/core.h~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods drivers/mmc/core/core.h
--- a/drivers/mmc/core/core.h~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods
+++ a/drivers/mmc/core/core.h
@@ -20,8 +20,8 @@ struct mmc_bus_ops {
 	int (*sleep)(struct mmc_host *);
 	void (*remove)(struct mmc_host *);
 	void (*detect)(struct mmc_host *);
-	void (*suspend)(struct mmc_host *);
-	void (*resume)(struct mmc_host *);
+	int (*suspend)(struct mmc_host *);
+	int (*resume)(struct mmc_host *);
 	void (*power_save)(struct mmc_host *);
 	void (*power_restore)(struct mmc_host *);
 };
diff -puN drivers/mmc/core/mmc.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods
+++ a/drivers/mmc/core/mmc.c
@@ -530,7 +530,7 @@ static void mmc_detect(struct mmc_host *
 /*
  * Suspend callback from host.
  */
-static void mmc_suspend(struct mmc_host *host)
+static int mmc_suspend(struct mmc_host *host)
 {
 	BUG_ON(!host);
 	BUG_ON(!host->card);
@@ -540,6 +540,8 @@ static void mmc_suspend(struct mmc_host 
 		mmc_deselect_cards(host);
 	host->card->state &= ~MMC_STATE_HIGHSPEED;
 	mmc_release_host(host);
+
+	return 0;
 }
 
 /*
@@ -548,7 +550,7 @@ static void mmc_suspend(struct mmc_host 
  * This function tries to determine if the same card is still present
  * and, if so, restore all state to it.
  */
-static void mmc_resume(struct mmc_host *host)
+static int mmc_resume(struct mmc_host *host)
 {
 	int err;
 
@@ -559,14 +561,7 @@ static void mmc_resume(struct mmc_host *
 	err = mmc_init_card(host, host->ocr, host->card);
 	mmc_release_host(host);
 
-	if (err) {
-		mmc_remove(host);
-
-		mmc_claim_host(host);
-		mmc_detach_bus(host);
-		mmc_release_host(host);
-	}
-
+	return err;
 }
 
 static void mmc_power_restore(struct mmc_host *host)
diff -puN drivers/mmc/core/sd.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods drivers/mmc/core/sd.c
--- a/drivers/mmc/core/sd.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods
+++ a/drivers/mmc/core/sd.c
@@ -564,7 +564,7 @@ static void mmc_sd_detect(struct mmc_hos
 /*
  * Suspend callback from host.
  */
-static void mmc_sd_suspend(struct mmc_host *host)
+static int mmc_sd_suspend(struct mmc_host *host)
 {
 	BUG_ON(!host);
 	BUG_ON(!host->card);
@@ -574,6 +574,8 @@ static void mmc_sd_suspend(struct mmc_ho
 		mmc_deselect_cards(host);
 	host->card->state &= ~MMC_STATE_HIGHSPEED;
 	mmc_release_host(host);
+
+	return 0;
 }
 
 /*
@@ -582,7 +584,7 @@ static void mmc_sd_suspend(struct mmc_ho
  * This function tries to determine if the same card is still present
  * and, if so, restore all state to it.
  */
-static void mmc_sd_resume(struct mmc_host *host)
+static int mmc_sd_resume(struct mmc_host *host)
 {
 	int err;
 
@@ -593,14 +595,7 @@ static void mmc_sd_resume(struct mmc_hos
 	err = mmc_sd_init_card(host, host->ocr, host->card);
 	mmc_release_host(host);
 
-	if (err) {
-		mmc_sd_remove(host);
-
-		mmc_claim_host(host);
-		mmc_detach_bus(host);
-		mmc_release_host(host);
-	}
-
+	return err;
 }
 
 static void mmc_sd_power_restore(struct mmc_host *host)
diff -puN drivers/mmc/core/sdio.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods drivers/mmc/core/sdio.c
--- a/drivers/mmc/core/sdio.c~mmc-propagate-error-codes-back-from-bus-drivers-suspend-resume-methods
+++ a/drivers/mmc/core/sdio.c
@@ -302,6 +302,7 @@ static int mmc_sdio_init_card(struct mmc
 			goto err;
 		}
 		card = oldcard;
+		return 0;
 	}
 
 	/*
@@ -399,62 +400,65 @@ static void mmc_sdio_detect(struct mmc_h
  * Therefore all registered functions must have drivers with suspend
  * and resume methods.  Failing that we simply remove the whole card.
  */
-static void mmc_sdio_suspend(struct mmc_host *host)
+static int mmc_sdio_suspend(struct mmc_host *host)
 {
-	int i;
+	int i, err = 0;
 
-	/* make sure all registered functions can suspend/resume */
 	for (i = 0; i < host->card->sdio_funcs; i++) {
 		struct sdio_func *func = host->card->sdio_func[i];
 		if (func && sdio_func_present(func) && func->dev.driver) {
 			const struct dev_pm_ops *pmops = func->dev.driver->pm;
 			if (!pmops || !pmops->suspend || !pmops->resume) {
-				/* just remove the entire card in that case */
-				mmc_sdio_remove(host);
-				mmc_claim_host(host);
-				mmc_detach_bus(host);
-				mmc_release_host(host);
-				return;
-			}
+				/* force removal of entire card in that case */
+				err = -ENOSYS;
+			} else
+				err = pmops->suspend(&func->dev);
+			if (err)
+				break;
 		}
 	}
-
-	/* now suspend them */
-	for (i = 0; i < host->card->sdio_funcs; i++) {
+	while (err && --i >= 0) {
 		struct sdio_func *func = host->card->sdio_func[i];
 		if (func && sdio_func_present(func) && func->dev.driver) {
 			const struct dev_pm_ops *pmops = func->dev.driver->pm;
-			pmops->suspend(&func->dev);
+			pmops->resume(&func->dev);
 		}
 	}
+
+	return err;
 }
 
-static void mmc_sdio_resume(struct mmc_host *host)
+static int mmc_sdio_resume(struct mmc_host *host)
 {
 	int i, err;
 
 	BUG_ON(!host);
 	BUG_ON(!host->card);
 
+	/* Basic card reinitialization. */
 	mmc_claim_host(host);
 	err = mmc_sdio_init_card(host, host->ocr, host->card);
 	mmc_release_host(host);
-	if (err) {
-		mmc_sdio_remove(host);
-		mmc_claim_host(host);
-		mmc_detach_bus(host);
-		mmc_release_host(host);
-		return;
-	}
 
-	/* resume all functions */
-	for (i = 0; i < host->card->sdio_funcs; i++) {
+	/*
+	 * If the card looked to be the same as before suspending, then
+	 * we proceed to resume all card functions.  If one of them returns
+	 * an error then we simply return that error to the core and the
+	 * card will be redetected as new.  It is the responsibility of
+	 * the function driver to perform further tests with the extra
+	 * knowledge it has of the card to confirm the card is indeed the
+	 * same as before suspending (same MAC address for network cards,
+	 * etc.) and return an error otherwise.
+	 */
+	for (i = 0; !err && i < host->card->sdio_funcs; i++) {
 		struct sdio_func *func = host->card->sdio_func[i];
 		if (func && sdio_func_present(func) && func->dev.driver) {
 			const struct dev_pm_ops *pmops = func->dev.driver->pm;
-			pmops->resume(&func->dev);
+			err = pmops->resume(&func->dev);
 		}
 	}
+
+	return err;
 }
 
 static const struct mmc_bus_ops mmc_sdio_ops = {
_

Patches currently in -mm which might be from nico@fluxnic.net are

origin.patch
linux-next.patch

