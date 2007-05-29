From: akpm@linux-foundation.org
Subject: + freezer-return-int-from-freeze_processes.patch added to -mm tree
Date: Tue, 29 May 2007 15:55:35 -0700
Message-ID: <200705292255.l4TMtawL013747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbXE2Wz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ego@in.ibm.com, oleg@tv-sign.ru, pavel@ucw.cz


The patch titled
     Freezer: return int from freeze_processes
has been added to the -mm tree.  Its filename is
     freezer-return-int-from-freeze_processes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 9 insertions(+), 12 deletions(-)

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

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
x86_64-pm_trace-support.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
