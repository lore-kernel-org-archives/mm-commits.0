From: akpm@linux-foundation.org
Subject: - swsusp-fix-error-paths-in-snapshot_open.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:19 -0700
Message-ID: <200705080005.l4805JqA009087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907AbXEHAGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: fix error paths in snapshot_open
has been removed from the -mm tree.  Its filename was
     swsusp-fix-error-paths-in-snapshot_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: fix error paths in snapshot_open
From: Rafael J. Wysocki <rjw@sisk.pl>

We forget to increase device_available if there's an error in snapshot_open(),
so the snapshot device cannot be open at all after snapshot_open() has
returned an error.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/power/user.c~swsusp-fix-error-paths-in-snapshot_open kernel/power/user.c
--- a/kernel/power/user.c~swsusp-fix-error-paths-in-snapshot_open
+++ a/kernel/power/user.c
@@ -49,12 +49,14 @@ static int snapshot_open(struct inode *i
 	if (!atomic_add_unless(&device_available, -1, 0))
 		return -EBUSY;
 
-	if ((filp->f_flags & O_ACCMODE) == O_RDWR)
+	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
+		atomic_inc(&device_available);
 		return -ENOSYS;
-
-	if(create_basic_memory_bitmaps())
+	}
+	if(create_basic_memory_bitmaps()) {
+		atomic_inc(&device_available);
 		return -ENOMEM;
-
+	}
 	nonseekable_open(inode, filp);
 	data = &snapshot_state;
 	filp->private_data = data;
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
swsusp-clean-up-print.patch
pm-separate-hibernation-code-from-suspend-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
workqueues-shift-kthread_bind-from-cpu_up_prepare-to-cpu_online.patch
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
remvoe-kthread_bind-call-from-_cpu_down.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
add-suspend-related-notifications-for-cpu-hotplug-cleanup.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
