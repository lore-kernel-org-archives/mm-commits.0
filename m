From: akpm@linux-foundation.org
Subject: + cpuidle-hang-fix.patch added to -mm tree
Date: Tue, 10 Apr 2007 16:26:44 -0700
Message-ID: <200704102326.l3ANQi0M022912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51619 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbXDJX0x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 19:26:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     cpuidle hang fix
has been added to the -mm tree.  Its filename is
     cpuidle-hang-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuidle hang fix
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Prevent hang on x86-64, when ACPI processor driver is added as a module on
a system that does not support C-states.

x86-64 expects all idle handlers to enable interrupts before returning from
idle handler.  This is due to enter_idle(), exit_idle() races.  Make
cpuidle_idle_call() confirm to this when there is no pm_idle_old.

Also, cpuidle look at the return values of attch_driver() and set
current_driver to NULL if attach fails on all CPUs.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |    2 ++
 drivers/cpuidle/driver.c  |   15 ++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-hang-fix drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-hang-fix
+++ a/drivers/cpuidle/cpuidle.c
@@ -43,6 +43,8 @@ static void cpuidle_idle_call(void)
 	if (dev->status != CPUIDLE_STATUS_DOIDLE) {
 		if (pm_idle_old)
 			pm_idle_old();
+		else
+			local_irq_enable();
 		return;
 	}
 
diff -puN drivers/cpuidle/driver.c~cpuidle-hang-fix drivers/cpuidle/driver.c
--- a/drivers/cpuidle/driver.c~cpuidle-hang-fix
+++ a/drivers/cpuidle/driver.c
@@ -107,11 +107,20 @@ int cpuidle_switch_driver(struct cpuidle
 	cpuidle_curr_driver = drv;
 
 	if (drv) {
+		int ret = 1;
 		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_attach_driver(dev);
-		if (cpuidle_curr_governor)
+			if (cpuidle_attach_driver(dev) == 0)
+				ret = 0;
+
+		/* If attach on all devices fail, switch to NULL driver */
+		if (ret)
+			cpuidle_curr_driver = NULL;
+
+		if (cpuidle_curr_driver && cpuidle_curr_governor) {
+			printk(KERN_INFO "cpuidle: using driver %s\n",
+					drv->name);
 			cpuidle_install_idle_handler();
-		printk(KERN_INFO "cpuidle: using driver %s\n", drv->name);
+		}
 	}
 
 	return 0;
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-hang-fix.patch
git-ia64.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
add-support-for-deferrable-timers-respun-fix-2.patch
add-a-new-deferrable-delayed-work-init.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
