From: akpm@linux-foundation.org
Subject: + cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:48:56 -0700
Message-ID: <200706080048.l580mum2014047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965467AbXFHAtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: fix the uninitialized variable in sysfs routine
has been added to the -mm tree.  Its filename is
     cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
