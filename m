From: akpm@linux-foundation.org
Subject: + mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch added to -mm tree
Date: Thu, 04 Feb 2010 16:10:04 -0800
Message-ID: <201002050010.o150A4Vi031113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933467Ab0BEALL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 19:11:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, dwmw2@infradead.org, ext-jorg.2.schummer@nokia.com, linux-mmc@vger.kernel.org, rjw@sisk.pl, stable@kernel.org


The patch titled
     mmc: fix hang if card was removed during suspend and unsafe resume was enabled
has been added to the -mm tree.  Its filename is
     mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch

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
Subject: mmc: fix hang if card was removed during suspend and unsafe resume was enabled
From: Maxim Levitsky <maximlevitsky@gmail.com>

Currently removal of the card leads to del_disk called indirectly by mmc
core.  This function expects userspace to be running, which isn't when
.resume is called

Fix that by removing the code that did that in mmc_resume_host.  It is
possible because card detection logic will kick it later and remove the
card.

Also make mtd workqueue freezeable, so it won't attempt to add/remove the
card while userspace is frozen.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled
+++ a/drivers/mmc/core/core.c
@@ -1257,7 +1257,6 @@ int mmc_suspend_host(struct mmc_host *ho
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
-	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
@@ -1300,15 +1299,11 @@ int mmc_resume_host(struct mmc_host *hos
 		mmc_select_voltage(host, host->ocr);
 		BUG_ON(!host->bus_ops->resume);
 		err = host->bus_ops->resume(host);
+
 		if (err) {
 			printk(KERN_WARNING "%s: error %d during resume "
 					    "(card was removed?)\n",
 					    mmc_hostname(host), err);
-			if (host->bus_ops->remove)
-				host->bus_ops->remove(host);
-			mmc_claim_host(host);
-			mmc_detach_bus(host);
-			mmc_release_host(host);
 			/* no need to bother upper layers */
 			err = 0;
 		}
@@ -1332,7 +1327,7 @@ static int __init mmc_init(void)
 {
 	int ret;
 
-	workqueue = create_singlethread_workqueue("kmmcd");
+	workqueue = create_freezeable_workqueue("kmmcd");
 	if (!workqueue)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

mmc-fix-hang-if-card-was-removed-during-suspend-and-unsafe-resume-was-enabled.patch
linux-next.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
ricoh_mmc-port-from-driver-to-pci-quirk.patch
ricoh_mmc-port-from-driver-to-pci-quirk-update.patch

