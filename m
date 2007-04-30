From: akpm@linux-foundation.org
Subject: - cpuidle-hang-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:19 -0700
Message-ID: <200704302144.l3ULiJm4015588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030930AbXD3Vou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle hang fix
has been removed from the -mm tree.  Its filename was
     cpuidle-hang-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
add-support-for-deferrable-timers-respun.patch
add-a-new-deferrable-delayed-work-init.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
