From: akpm@linux-foundation.org
Subject: - cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:51:29 -0700
Message-ID: <200707060051.l660pTRR028290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760464AbXGFAvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle: fix the uninitialized variable in sysfs routine
has been removed from the -mm tree.  Its filename was
     cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuidle: fix the uninitialized variable in sysfs routine
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Fix the uninitialized usage of ret.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/sysfs.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/cpuidle/sysfs.c~cpuidle-fix-the-uninitialized-variable-in-sysfs-routine drivers/cpuidle/sysfs.c
--- a/drivers/cpuidle/sysfs.c~cpuidle-fix-the-uninitialized-variable-in-sysfs-routine
+++ a/drivers/cpuidle/sysfs.c
@@ -301,7 +301,7 @@ static void inline cpuidle_free_state_ko
  */
 int cpuidle_add_driver_sysfs(struct cpuidle_device *device)
 {
-	int i, ret;
+	int i, ret = -ENOMEM;
 	struct cpuidle_state_kobj *kobj;
 
 	/* state statistics */
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
git-newsetup.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
