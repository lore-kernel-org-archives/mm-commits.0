From: akpm@linux-foundation.org
Subject: - freezer-do-not-sync-filesystems-from-freeze_processes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:57 -0700
Message-ID: <200710190340.l9J3evH9012751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965759AbXJSD4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     freezer: do not sync filesystems from freeze_processes
has been removed from the -mm tree.  Its filename was
     freezer-do-not-sync-filesystems-from-freeze_processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: freezer: do not sync filesystems from freeze_processes
From: Rafael J. Wysocki <rjw@sisk.pl>

The syncing of filesystems from within the freezer is generally not needed. 
Also, if there's an ext3 filesystem loopback-mounted from a FUSE one, the
syncing results in writes to it and deadlocks.  Similarly, it will deadlock if
FUSE implements sync.

Change freeze_processes() so that it doesn't execute sys_sync() and make the
suspend and hibernation code path sync filesystems independently of the
freezer.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c    |    4 ++++
 kernel/power/main.c    |    6 ++++++
 kernel/power/process.c |    1 -
 kernel/power/user.c    |    4 ++++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff -puN kernel/power/disk.c~freezer-do-not-sync-filesystems-from-freeze_processes kernel/power/disk.c
--- a/kernel/power/disk.c~freezer-do-not-sync-filesystems-from-freeze_processes
+++ a/kernel/power/disk.c
@@ -313,6 +313,10 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
+	printk("Syncing filesystems ... ");
+	sys_sync();
+	printk("done.\n");
+
 	error = prepare_processes();
 	if (error)
 		goto Finish;
diff -puN kernel/power/main.c~freezer-do-not-sync-filesystems-from-freeze_processes kernel/power/main.c
--- a/kernel/power/main.c~freezer-do-not-sync-filesystems-from-freeze_processes
+++ a/kernel/power/main.c
@@ -20,6 +20,7 @@
 #include <linux/resume-trace.h>
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
+#include <linux/syscalls.h>
 
 #include "power.h"
 
@@ -230,9 +231,14 @@ static int enter_state(suspend_state_t s
 
 	if (!valid_state(state))
 		return -ENODEV;
+
 	if (!mutex_trylock(&pm_mutex))
 		return -EBUSY;
 
+	printk("Syncing filesystems ... ");
+	sys_sync();
+	printk("done.\n");
+
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
 	if ((error = suspend_prepare()))
 		goto Unlock;
diff -puN kernel/power/process.c~freezer-do-not-sync-filesystems-from-freeze_processes kernel/power/process.c
--- a/kernel/power/process.c~freezer-do-not-sync-filesystems-from-freeze_processes
+++ a/kernel/power/process.c
@@ -191,7 +191,6 @@ int freeze_processes(void)
 	if (error)
 		return error;
 
-	sys_sync();
 	error = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
 	if (error)
 		return error;
diff -puN kernel/power/user.c~freezer-do-not-sync-filesystems-from-freeze_processes kernel/power/user.c
--- a/kernel/power/user.c~freezer-do-not-sync-filesystems-from-freeze_processes
+++ a/kernel/power/user.c
@@ -153,6 +153,10 @@ static int snapshot_ioctl(struct inode *
 		mutex_lock(&pm_mutex);
 		error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 		if (!error) {
+			printk("Syncing filesystems ... ");
+			sys_sync();
+			printk("done.\n");
+
 			error = freeze_processes();
 			if (error)
 				thaw_processes();
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
