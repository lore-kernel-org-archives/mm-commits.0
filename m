From: akpm@linux-foundation.org
Subject: - acpi-add-suspend-related-notifications-for-cpu-hotplug.patch removed from -mm tree
Date: Wed, 09 May 2007 15:25:05 -0700
Message-ID: <200705092225.l49MP5JR004209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759516AbXEIWZ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:25:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Add suspend-related notifications for CPU hotplug
has been removed from the -mm tree.  Its filename was
     acpi-add-suspend-related-notifications-for-cpu-hotplug.patch

This patch was dropped because I'm cleaning old stuff out of my patches directory

------------------------------------------------------
Subject: Add suspend-related notifications for CPU hotplug

diff -puN drivers/cpuidle/cpuidle.c~add-suspend-related-notifications-for-cpu-hotplug drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~add-suspend-related-notifications-for-cpu-hotplug
+++ a/drivers/cpuidle/cpuidle.c
@@ -227,16 +227,20 @@ static int cpuidle_cpu_callback(struct n
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpuidle_add_device(sys_dev);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		mutex_lock(&cpuidle_lock);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		__cpuidle_remove_device(sys_dev);
 		mutex_unlock(&cpuidle_lock);
 		break;
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		mutex_unlock(&cpuidle_lock);
 		break;
 	}


Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
