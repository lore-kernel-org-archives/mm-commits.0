From: akpm@linux-foundation.org
Subject: + mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2.patch added to -mm tree
Date: Mon, 02 Aug 2010 15:56:35 -0700
Message-ID: <201008022256.o72MuZJh016384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370Ab0HBW5P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Aug 2010 18:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, david-b@pacbell.net, linux-mmc@vger.kernel.org, stern@rowland.harvard.edu


The patch titled
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2
has been added to the -mm tree.  Its filename is
     mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2.patch

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
Subject: mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2
From: Maxim Levitsky <maximlevitsky@gmail.com>

If you don't use CONFIG_MMC_UNSAFE_RESUME, as soon as you attempt to
suspend, the card will be removed, therefore this patch doesn't change the
behavior of this option.

However the removal will be done by pm notifier, which runs while
userspace is still not frozen and thus can freely use del_gendisk, without
the risk of deadlock which would happen otherwise.

Card detect workqueue is now disabled while userspace is frozen, Therefore
if you do use CONFIG_MMC_UNSAFE_RESUME, and remove the card during
suspend, the removal will be detected as soon as userspace is unfrozen,
again at the moment it is safe to call del_gendisk.

Tested with and without CONFIG_MMC_UNSAFE_RESUME with suspend and hibernate.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |    4 ++--
 drivers/mmc/core/host.c  |    1 -
 include/linux/mmc/host.h |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2 drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2
+++ a/drivers/mmc/core/core.c
@@ -1323,6 +1323,7 @@ int mmc_resume_host(struct mmc_host *hos
 
 	return err;
 }
+EXPORT_SYMBOL(mmc_resume_host);
 
 /* Do the card removal on suspend if card is assumed removeable
  * Do that in pm notifier while userspace isn't yet frozen, so we will be able
@@ -1343,6 +1344,7 @@ int mmc_pm_notify(struct notifier_block 
 		spin_lock_irqsave(&host->lock, flags);
 		host->rescan_disable = 1;
 		spin_unlock_irqrestore(&host->lock, flags);
+		cancel_delayed_work_sync(&host->detect);
 
 		if (!host->bus_ops || host->bus_ops->suspend)
 			break;
@@ -1369,8 +1371,6 @@ int mmc_pm_notify(struct notifier_block 
 
 	return 0;
 }
-EXPORT_SYMBOL(mmc_resume_host);
-
 #endif
 
 static int __init mmc_init(void)
diff -puN drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2 drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2
+++ a/drivers/mmc/core/host.c
@@ -88,7 +88,6 @@ struct mmc_host *mmc_alloc_host(int extr
 	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
 	host->pm_notify.notifier_call = mmc_pm_notify;
 
-
 	/*
 	 * By default, hosts do not support SGIO or large requests.
 	 * They have to set these according to their abilities.
diff -puN include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2 include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update-2
+++ a/include/linux/mmc/host.h
@@ -261,7 +261,6 @@ int mmc_host_disable(struct mmc_host *ho
 int mmc_host_lazy_disable(struct mmc_host *host);
 int mmc_pm_notify(struct notifier_block *notify_block, unsigned long, void *);
 
