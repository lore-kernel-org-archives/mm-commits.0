From: akpm@linux-foundation.org
Subject: + mmc-allow-host-claim-release-nesting.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:54:30 -0700
Message-ID: <200907242254.n6OMsU4t030795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbZGXWym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     mmc: allow host claim / release nesting
has been added to the -mm tree.  Its filename is
     mmc-allow-host-claim-release-nesting.patch

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
Subject: mmc: allow host claim / release nesting
From: Adrian Hunter <adrian.hunter@nokia.com>

This change allows the MMC host to be claimed in situations where the host
may or may not have already been claimed.  Also 'mmc_try_claim_host()' is
now exported.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |   34 +++++++++++++++++++++++++---------
 include/linux/mmc/core.h |    1 +
 include/linux/mmc/host.h |    2 ++
 3 files changed, 28 insertions(+), 9 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-allow-host-claim-release-nesting drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-allow-host-claim-release-nesting
+++ a/drivers/mmc/core/core.c
@@ -458,16 +458,18 @@ int __mmc_claim_host(struct mmc_host *ho
 	while (1) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		stop = abort ? atomic_read(abort) : 0;
-		if (stop || !host->claimed)
+		if (stop || !host->claimed || host->claimer == current)
 			break;
 		spin_unlock_irqrestore(&host->lock, flags);
 		schedule();
 		spin_lock_irqsave(&host->lock, flags);
 	}
 	set_current_state(TASK_RUNNING);
-	if (!stop)
+	if (!stop) {
 		host->claimed = 1;
-	else
+		host->claimer = current;
+		host->claim_cnt += 1;
+	} else
 		wake_up(&host->wq);
 	spin_unlock_irqrestore(&host->lock, flags);
 	remove_wait_queue(&host->wq, &wait);
@@ -478,29 +480,43 @@ int __mmc_claim_host(struct mmc_host *ho
 
 EXPORT_SYMBOL(__mmc_claim_host);
 
-static int mmc_try_claim_host(struct mmc_host *host)
+/**
+ *	mmc_try_claim_host - try exclusively to claim a host
+ *	@host: mmc host to claim
+ *
+ *	Returns %1 if the host is claimed, %0 otherwise.
+ */
+int mmc_try_claim_host(struct mmc_host *host)
 {
 	int claimed_host = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&host->lock, flags);
-	if (!host->claimed) {
+	if (!host->claimed || host->claimer == current) {
 		host->claimed = 1;
+		host->claimer = current;
+		host->claim_cnt += 1;
 		claimed_host = 1;
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 	return claimed_host;
 }
+EXPORT_SYMBOL(mmc_try_claim_host);
 
 static void mmc_do_release_host(struct mmc_host *host)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&host->lock, flags);
-	host->claimed = 0;
-	spin_unlock_irqrestore(&host->lock, flags);
-
-	wake_up(&host->wq);
+	if (--host->claim_cnt) {
+		/* Release for nested claim */
+		spin_unlock_irqrestore(&host->lock, flags);
+	} else {
+		host->claimed = 0;
+		host->claimer = NULL;
+		spin_unlock_irqrestore(&host->lock, flags);
+		wake_up(&host->wq);
+	}
 }
 
 void mmc_host_deeper_disable(struct work_struct *work)
diff -puN include/linux/mmc/core.h~mmc-allow-host-claim-release-nesting include/linux/mmc/core.h
--- a/include/linux/mmc/core.h~mmc-allow-host-claim-release-nesting
+++ a/include/linux/mmc/core.h
@@ -139,6 +139,7 @@ extern unsigned int mmc_align_data_size(
 
 extern int __mmc_claim_host(struct mmc_host *host, atomic_t *abort);
 extern void mmc_release_host(struct mmc_host *host);
+extern int mmc_try_claim_host(struct mmc_host *host);
 
 /**
  *	mmc_claim_host - exclusively claim a host
diff -puN include/linux/mmc/host.h~mmc-allow-host-claim-release-nesting include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-allow-host-claim-release-nesting
+++ a/include/linux/mmc/host.h
@@ -182,6 +182,8 @@ struct mmc_host {
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
+	struct task_struct	*claimer;	/* task that has host claimed */
+	int			claim_cnt;	/* "claim" nesting count */
 
 	struct delayed_work	detect;
 
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch
mmc-check-status-after-mmc-switch-command.patch
omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

