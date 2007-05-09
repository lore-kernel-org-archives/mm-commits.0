From: akpm@linux-foundation.org
Subject: + mmc-build-fix.patch added to -mm tree
Date: Wed, 09 May 2007 02:21:51 -0700
Message-ID: <200705090921.l499LpLu019038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499AbXEIJWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, drzeus@drzeus.cx


The patch titled
     mmc build fix
has been added to the -mm tree.  Its filename is
     mmc-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mmc build fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-build-fix drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-build-fix
+++ a/drivers/mmc/core/core.c
@@ -501,9 +501,9 @@ void mmc_detect_change(struct mmc_host *
 {
 #ifdef CONFIG_MMC_DEBUG
 	unsigned long flags;
-	spin_lock_irqsave(host->lock, flags);
+	spin_lock_irqsave(&host->lock, flags);
 	BUG_ON(host->removed);
-	spin_unlock_irqrestore(host->lock, flags);
+	spin_unlock_irqrestore(&host->lock, flags);
 #endif
 
 	mmc_schedule_delayed_work(&host->detect, delay);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmc-build-fix.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
rename-thread_info-to-stack.patch
