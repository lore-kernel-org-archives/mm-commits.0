From: akpm@linux-foundation.org
Subject: + mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update.patch added to -mm tree
Date: Mon, 21 Jun 2010 12:34:54 -0700
Message-ID: <201006211934.o5LJYsxe000404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757566Ab0FUTfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 15:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com


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

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/host.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update drivers/mmc/core/host.c
--- a/drivers/mmc/core/host.c~mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update
+++ a/drivers/mmc/core/host.c
@@ -135,8 +135,8 @@ int mmc_add_host(struct mmc_host *host)
 	mmc_add_host_debugfs(host);
 #endif
 
-	register_pm_notifier(&host->pm_notify);
 	mmc_start_host(host);
+	register_pm_notifier(&host->pm_notify);
 
 	return 0;
 }
@@ -153,6 +153,7 @@ EXPORT_SYMBOL(mmc_add_host);
  */
 void mmc_remove_host(struct mmc_host *host)
 {
+	unregister_pm_notifier(&host->pm_notify);
 	mmc_stop_host(host);
 
 #ifdef CONFIG_DEBUG_FS
@@ -163,7 +164,6 @@ void mmc_remove_host(struct mmc_host *ho
 
 	led_trigger_unregister_simple(host->led);
 
-	unregister_pm_notifier(&host->pm_notify);
 }
 
 EXPORT_SYMBOL(mmc_remove_host);
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

linux-next.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
maintainers-update-ricoh-smartmedia-xd-driver-file-patterns.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-update.patch
mmc-make-sdhci-work-with-ricoh-mmc-controller.patch

