From: akpm@linux-foundation.org
Subject: + mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update.patch added to -mm tree
Date: Fri, 30 Jul 2010 15:39:10 -0700
Message-ID: <201007302239.o6UMdA6C005145__48851.1354117238$1280529591$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751910Ab0G3Wjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 18:39:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, david-b@pacbell.net, linux-mmc@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update
has been added to the -mm tree.  Its filename is
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update.patch

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
Subject: mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update
From: Maxim Levitsky <maximlevitsky@gmail.com>

If you don't use CONFIG_MMC_UNSAFE_RESUME, as soon as you attempt to
suspend, the card will be removed, therefore this patch doesn't change
the behavior of this option.

However the removal will be done by pm notifier, which runs while
userspace is still not frozen and thus can freely use del_gendisk,
without the risk of deadlock which would happen otherwise.

Card detect workqueue is now disabled while userspace is frozen,
Therefore if you do use CONFIG_MMC_UNSAFE_RESUME,
and remove the card during suspend, the removal will be
detected as soon as userspace is unfrozen, again at the moment
it is safe to call del_gendisk.

Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |   45 +++++++++++++++++++++++++++----------
 drivers/mmc/core/host.c  |    1 
 include/linux/mmc/host.h |    9 ++-----
 3 files changed, 37 insertions(+), 18 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update
+++ a/drivers/mmc/core/core.c
@@ -1057,6 +1057,17 @@ void mmc_rescan(struct work_struct *work
 		container_of(work, struct mmc_host, detect.work);
 	u32 ocr;
 	int err;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (host->rescan_disable) {
+		spin_unlock_irqrestore(&host->lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
 
 	mmc_bus_get(host);
 
@@ -1267,6 +1278,8 @@ int mmc_suspend_host(struct mmc_host *ho
 
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
+	cancel_delayed_work(&host->detect);
+	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
@@ -1308,54 +1321,64 @@ int mmc_resume_host(struct mmc_host *hos
 	}
 	mmc_bus_put(host);
 
-	/*
-	 * We add a slight delay here so that resume can progress
-	 * in parallel.
-	 */
-	mmc_detect_change(host, 1);
-
 	return err;
 }
-EXPORT_SYMBOL(mmc_resume_host);
 
 /* Do the card removal on suspend if card is assumed removeable
  * Do that in pm notifier while userspace isn't yet frozen, so we will be able
- * to sync the card.
- */
+   to sync the card.
+*/
 int mmc_pm_notify(struct notifier_block *notify_block,
 					unsigned long mode, void *unused)
 {
 	struct mmc_host *host = container_of(
 		notify_block, struct mmc_host, pm_notify);
+	unsigned long flags;
 
 
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 
+		spin_lock_irqsave(&host->lock, flags);
+		host->rescan_disable = 1;
+		spin_unlock_irqrestore(&host->lock, flags);
+
 		if (!host->bus_ops || host->bus_ops->suspend)
 			break;
 
+		mmc_claim_host(host);
+
 		if (host->bus_ops->remove)
 			host->bus_ops->remove(host);
-		mmc_claim_host(host);
+
 		mmc_detach_bus(host);
 		mmc_release_host(host);
 		host->pm_flags = 0;
 		break;
 
+	case PM_POST_SUSPEND:
+	case PM_POST_HIBERNATION:
+
+		spin_lock_irqsave(&host->lock, flags);
+		host->rescan_disable = 0;
+		spin_unlock_irqrestore(&host->lock, flags);
+		mmc_detect_change(host, 0);
+
 	}
 
 	return 0;
 }
 
+EXPORT_SYMBOL(mmc_resume_host);
+
 #endif
 
 static int __init mmc_init(void)
 {
 	int ret;
 
-	workqueue = create_freezeable_workqueue("kmmcd");
+	workqueue = create_singlethread_workqueue("kmmcd");
 	if (!workqueue)
 		return -ENOMEM;
 
diff -puN drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update
+++ a/drivers/mmc/core/host.c
@@ -163,7 +163,6 @@ void mmc_remove_host(struct mmc_host *ho
 	device_del(&host->class_dev);
 
 	led_trigger_unregister_simple(host->led);
-
 }
 
 EXPORT_SYMBOL(mmc_remove_host);
diff -puN include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update
+++ a/include/linux/mmc/host.h
@@ -184,6 +184,7 @@ struct mmc_host {
 
 	/* Only used with MMC_CAP_DISABLE */
 	int			enabled;	/* host is enabled */
+	int			rescan_disable;	/* disable card detection */
 	int			nesting_cnt;	/* "enable" nesting count */
 	int			en_dis_recurs;	/* detect recursion */
 	unsigned int		disable_delay;	/* disable delay in msecs */
@@ -258,12 +259,8 @@ int mmc_card_can_sleep(struct mmc_host *
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
-#ifdef CONFIG_PM
-int mmc_pm_notify(struct notifier_block *notify_block, unsigned long mode,
-		  void *unused);
-#else
-#define mmc_pm_notify NULL
-#endif
+int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
+
 
 static inline void mmc_set_disable_delay(struct mmc_host *host,
 					 unsigned int disable_delay)
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
maintainers-update-ricoh-smartmedia-xd-driver-file-patterns.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update.patch
mmc-make-sdhci-work-with-ricoh-mmc-controller.patch

