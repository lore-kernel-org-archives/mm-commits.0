From: akpm@linux-foundation.org
Subject: - freezer-return-int-from-freeze_processes.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:15 -0700
Message-ID: <200707192000.l6JK0Fwv019432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760504AbXGSU2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Freezer: return int from freeze_processes
has been removed from the -mm tree.  Its filename was
     freezer-return-int-from-freeze_processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Freezer: return int from freeze_processes
From: Rafael J. Wysocki <rjw@sisk.pl>

Make try_to_freeze_tasks() and freeze_processes() return -EBUSY on failure
instead of the number of unfrozen tasks (none of the callers actually uses
this number).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN kernel/power/process.c~freezer-return-int-from-freeze_processes kernel/power/process.c
--- a/kernel/power/process.c~freezer-return-int-from-freeze_processes
+++ a/kernel/power/process.c
@@ -105,7 +105,7 @@ static void cancel_freezing(struct task_
 	}
 }
 
-static unsigned int try_to_freeze_tasks(int freeze_user_space)
+static int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
 	unsigned long end_time;
@@ -176,28 +176,25 @@ static unsigned int try_to_freeze_tasks(
 		read_unlock(&tasklist_lock);
 	}
 
-	return todo;
+	return todo ? -EBUSY : 0;
 }
 
 /**
  *	freeze_processes - tell processes to enter the refrigerator
- *
- *	Returns 0 on success, or the number of processes that didn't freeze,
- *	although they were told to.
  */
 int freeze_processes(void)
 {
-	unsigned int nr_unfrozen;
+	int error;
 
 	printk("Stopping tasks ... ");
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
-	if (nr_unfrozen)
-		return nr_unfrozen;
+	error = try_to_freeze_tasks(FREEZER_USER_SPACE);
+	if (error)
+		return error;
 
 	sys_sync();
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
-	if (nr_unfrozen)
-		return nr_unfrozen;
+	error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
+	if (error)
+		return error;
 
 	printk("done.\n");
 	BUG_ON(in_atomic());
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch
