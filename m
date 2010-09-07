From: akpm@linux-foundation.org
Subject: + mmc-make-id-freq-configurable-v5.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:38:49 -0700
Message-ID: <201009072338.o87Ncnk7013457__8571.9128059738$1283902780$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758235Ab0IGXjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hein_tibosch@yahoo.es, cjb@laptop.org, linux-mmc@vger.kernel.org, matt@console-pimps.org


The patch titled
     mmc-make-id-freq-configurable-v5
has been added to the -mm tree.  Its filename is
     mmc-make-id-freq-configurable-v5.patch

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
Subject: mmc-make-id-freq-configurable-v5
From: Hein_Tibosch <hein_tibosch@yahoo.es>

Matt, Chris,

Thanks both for reviewing.

I never noticed that the host wasn't released because my f_min was low
enough so that all frequencies would be tried.  But yes, you're both
right.

Before somebody else makes the remark: "unsigned freqs[]" can be declared as
const.

Below, I changed the order of the if/else/else, and whenever no more
frequencies can be tried, it will release the host before branching out.

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Reviewed-and-Tested-by: Chris Ball <cjb@laptop.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-make-id-freq-configurable-v5 drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-make-id-freq-configurable-v5
+++ a/drivers/mmc/core/core.c
@@ -1400,7 +1400,7 @@ void mmc_rescan(struct work_struct *work
 	int err;
 	unsigned long flags;
 	int i;
-	unsigned freqs[] = { 400000, 300000, 200000, 100000 };
+	const unsigned freqs[] = { 400000, 300000, 200000, 100000 };
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1445,12 +1445,15 @@ void mmc_rescan(struct work_struct *work
 
 		if (freqs[i] >= host->f_min)
 			host->f_init = freqs[i];
-		else if (i && freqs[i-1] <= host->f_min)
-			goto out;
-		else
+		else if (!i || freqs[i-1] > host->f_min)
 			host->f_init = host->f_min;
+		else {
+			mmc_release_host(host);
+			goto out;
+		}
+		pr_info("%s: %s: trying to init card at %u Hz\n",
+			mmc_hostname(host), __func__, host->f_init);
 
-		printk ("mmc_rescan: trying %u Hz\n", host->f_init);
 		mmc_power_up(host);
 		sdio_reset(host);
 		mmc_go_idle(host);
@@ -1464,7 +1467,10 @@ void mmc_rescan(struct work_struct *work
 		if (!err) {
 			if (mmc_attach_sdio(host, ocr)) {
 				mmc_claim_host(host);
-				/* try SDMEM (but not MMC) even if SDIO is broken */
+				/*
+				 * Try SDMEM (but not MMC) even if SDIO
+				 * is broken.
+				*/
 				if (mmc_send_app_op_cond(host, 0, &ocr))
 					goto out_fail;
 
_

Patches currently in -mm which might be from hein_tibosch@yahoo.es are

mmc-make-id-freq-configurable.patch
mmc-make-id-freq-configurable-v5.patch
mmc-make-id-freq-configurable-checkpatch-fixes.patch

