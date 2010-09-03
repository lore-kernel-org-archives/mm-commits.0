From: akpm@linux-foundation.org
Subject: + mmc-make-id-freq-configurable.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:21:02 -0700
Message-ID: <201009032321.o83NL2eP018564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752Ab0ICXVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:21:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hein_tibosch@yahoo.es, adrian.hunter@nokia.com, bn@niasdigital.com, cjb@laptop.org, linux-mmc@vger.kernel.org, matt@console-pimps.org, pierre@ossman.eu, s.hauer@pengutronix.de


The patch titled
     mmc: make ID freq configurable
has been added to the -mm tree.  Its filename is
     mmc-make-id-freq-configurable.patch

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
Subject: mmc: make ID freq configurable
From: Hein Tibosch <hein_tibosch@yahoo.es>

In the latest releases of the mmc driver, the freq during initialization
is set to a fixed 400 Khz.  This was reportedly too fast for several
users.  As there doesn't seem to be an ideal frequency
which-works-for-all, Pierre suggested to let the driver try several
frequencies.

This patch implements that idea. It will try mmc-initialization using
several frequencies from an array 400, 300, 200 and 100.

In case SDIO is broken, it'll still try to detect SDMEM, also at different
freqs.

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Pierre Ossman <pierre@ossman.eu>
Reviewed-by: Chris Ball <cjb@laptop.org>
Tested-by: Chris Ball <cjb@laptop.org>
Cc: Ben Nizette <bn@niasdigital.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |   96 +++++++++++++++++++------------------
 include/linux/mmc/host.h |    1 
 2 files changed, 52 insertions(+), 45 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-make-id-freq-configurable drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-make-id-freq-configurable
+++ a/drivers/mmc/core/core.c
@@ -907,12 +907,7 @@ static void mmc_power_up(struct mmc_host
 	 */
 	mmc_delay(10);
 
-	if (host->f_min > 400000) {
-		pr_warning("%s: Minimum clock frequency too high for "
-				"identification mode\n", mmc_hostname(host));
-		host->ios.clock = host->f_min;
-	} else
-		host->ios.clock = 400000;
+	host->ios.clock = host->f_init;
 
 	host->ios.power_mode = MMC_POWER_ON;
 	mmc_set_ios(host);
@@ -1404,6 +1399,8 @@ void mmc_rescan(struct work_struct *work
 	u32 ocr;
 	int err;
 	unsigned long flags;
+	int i;
+	unsigned freqs[] = { 400000, 300000, 200000, 100000 };
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1443,55 +1440,64 @@ void mmc_rescan(struct work_struct *work
 	if (host->ops->get_cd && host->ops->get_cd(host) == 0)
 		goto out;
 
-	mmc_claim_host(host);
+	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
+		mmc_claim_host(host);
 
-	mmc_power_up(host);
-	sdio_reset(host);
-	mmc_go_idle(host);
+		if (freqs[i] >= host->f_min)
+			host->f_init = freqs[i];
+		else if (i && freqs[i-1] <= host->f_min)
+			goto out;
+		else
+			host->f_init = host->f_min;
 
-	mmc_send_if_cond(host, host->ocr_avail);
+		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
+		mmc_power_up(host);
+		sdio_reset(host);
+		mmc_go_idle(host);
 
-	/*
-	 * First we search for SDIO...
-	 */
-	err = mmc_send_io_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_sdio(host, ocr)) {
-			mmc_claim_host(host);
-			/* try SDMEM (but not MMC) even if SDIO is broken */
-			if (mmc_send_app_op_cond(host, 0, &ocr))
-				goto out_fail;
+		mmc_send_if_cond(host, host->ocr_avail);
+
+		/*
+		 * First we search for SDIO...
+		 */
+		err = mmc_send_io_op_cond(host, 0, &ocr);
+		if (!err) {
+			if (mmc_attach_sdio(host, ocr)) {
+				mmc_claim_host(host);
+				/* try SDMEM (but not MMC) even if SDIO is broken */
+				if (mmc_send_app_op_cond(host, 0, &ocr))
+					goto out_fail;
+
+				if (mmc_attach_sd(host, ocr))
+					mmc_power_off(host);
+			}
+			goto out;
+		}
 
+		/*
+		 * ...then normal SD...
+		 */
+		err = mmc_send_app_op_cond(host, 0, &ocr);
+		if (!err) {
 			if (mmc_attach_sd(host, ocr))
 				mmc_power_off(host);
+			goto out;
 		}
-		goto out;
-	}
 
-	/*
-	 * ...then normal SD...
-	 */
-	err = mmc_send_app_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_sd(host, ocr))
-			mmc_power_off(host);
-		goto out;
-	}
-
-	/*
-	 * ...and finally MMC.
-	 */
-	err = mmc_send_op_cond(host, 0, &ocr);
-	if (!err) {
-		if (mmc_attach_mmc(host, ocr))
-			mmc_power_off(host);
-		goto out;
-	}
+		/*
+		 * ...and finally MMC.
+		 */
+		err = mmc_send_op_cond(host, 0, &ocr);
+		if (!err) {
+			if (mmc_attach_mmc(host, ocr))
+				mmc_power_off(host);
+			goto out;
+		}
 
 out_fail:
-	mmc_release_host(host);
-	mmc_power_off(host);
