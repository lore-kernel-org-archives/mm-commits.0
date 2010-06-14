From: akpm@linux-foundation.org
Subject: + mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch added to -mm tree
Date: Mon, 14 Jun 2010 16:01:44 -0700
Message-ID: <201006142301.o5EN1iwW004071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab0FNXBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 19:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, david-b@pacbell.net, linux-mmc@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume
has been added to the -mm tree.  Its filename is
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch

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
Subject: mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume
From: Maxim Levitsky <maximlevitsky@gmail.com>

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |   54 +++++++++++++++++++++----------------
 drivers/mmc/core/host.c  |    6 ++++
 include/linux/mmc/host.h |    3 ++
 3 files changed, 41 insertions(+), 22 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume
+++ a/drivers/mmc/core/core.c
@@ -1267,26 +1267,11 @@ int mmc_suspend_host(struct mmc_host *ho
 
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
-	cancel_delayed_work(&host->detect);
-	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
 		if (host->bus_ops->suspend)
 			err = host->bus_ops->suspend(host);
-		if (err == -ENOSYS || !host->bus_ops->resume) {
-			/*
-			 * We simply "remove" the card in this case.
-			 * It will be redetected on resume.
-			 */
-			if (host->bus_ops->remove)
-				host->bus_ops->remove(host);
-			mmc_claim_host(host);
-			mmc_detach_bus(host);
-			mmc_release_host(host);
-			host->pm_flags = 0;
-			err = 0;
-		}
 	}
 	mmc_bus_put(host);
 
@@ -1318,12 +1303,6 @@ int mmc_resume_host(struct mmc_host *hos
 			printk(KERN_WARNING "%s: error %d during resume "
 					    "(card was removed?)\n",
 					    mmc_hostname(host), err);
-			if (host->bus_ops->remove)
-				host->bus_ops->remove(host);
-			mmc_claim_host(host);
-			mmc_detach_bus(host);
-			mmc_release_host(host);
-			/* no need to bother upper layers */
 			err = 0;
 		}
 	}
@@ -1338,6 +1317,37 @@ int mmc_resume_host(struct mmc_host *hos
 	return err;
 }
 
+/* Do the card removal on suspend if card is assumed removeable
+ * Do that in pm notifier while userspace isn't yet frozen, so we will be able
+   to sync the card.
+*/
+int mmc_pm_notify(struct notifier_block *notify_block,
+					unsigned long mode, void *unused)
+{
+	struct mmc_host *host = container_of(
+		notify_block, struct mmc_host, pm_notify);
+
+
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+
+		if (!host->bus_ops || host->bus_ops->suspend)
+			break;
+
+		if (host->bus_ops->remove)
+			host->bus_ops->remove(host);
+		mmc_claim_host(host);
+		mmc_detach_bus(host);
+		mmc_release_host(host);
+		host->pm_flags = 0;
+		break;
+
+	}
+
+	return 0;
+}
+
 EXPORT_SYMBOL(mmc_resume_host);
 
 #endif
@@ -1346,7 +1356,7 @@ static int __init mmc_init(void)
 {
 	int ret;
 
-	workqueue = create_singlethread_workqueue("kmmcd");
+	workqueue = create_freezeable_workqueue("kmmcd");
 	if (!workqueue)
 		return -ENOMEM;
 
diff -puN drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume
+++ a/drivers/mmc/core/host.c
@@ -17,6 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 
 #include <linux/mmc/host.h>
 
@@ -85,6 +86,8 @@ struct mmc_host *mmc_alloc_host(int extr
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
 	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
+	host->pm_notify.notifier_call = mmc_pm_notify;
+
 
 	/*
 	 * By default, hosts do not support SGIO or large requests.
@@ -132,6 +135,7 @@ int mmc_add_host(struct mmc_host *host)
 	mmc_add_host_debugfs(host);
 #endif
 
+	register_pm_notifier(&host->pm_notify);
 	mmc_start_host(host);
 
 	return 0;
@@ -158,6 +162,8 @@ void mmc_remove_host(struct mmc_host *ho
 	device_del(&host->class_dev);
 
 	led_trigger_unregister_simple(host->led);
+
+	unregister_pm_notifier(&host->pm_notify);
 }
 
 EXPORT_SYMBOL(mmc_remove_host);
diff -puN include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume
+++ a/include/linux/mmc/host.h
@@ -124,6 +124,7 @@ struct mmc_host {
 	unsigned int		f_min;
 	unsigned int		f_max;
 	u32			ocr_avail;
+	struct notifier_block	pm_notify;
 
 #define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
 #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
@@ -257,6 +258,8 @@ int mmc_card_can_sleep(struct mmc_host *
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
+int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
+
 
 static inline void mmc_set_disable_delay(struct mmc_host *host,
 					 unsigned int disable_delay)
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
maintainers-update-ricoh-smartmedia-xd-driver-file-patterns.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch

