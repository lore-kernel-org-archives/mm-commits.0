From: akpm@linux-foundation.org
Subject: - swsusp-fix-snapshot_release.patch removed from -mm tree
Date: Mon, 07 May 2007 17:05:38 -0700
Message-ID: <200705080005.l4805csk009111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274AbXEHAGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: fix snapshot_release
has been removed from the -mm tree.  Its filename was
     swsusp-fix-snapshot_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: fix snapshot_release
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the leftover enable_nonboot_cpus() from snapshot_release().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/user.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/power/user.c~swsusp-fix-snapshot_release kernel/power/user.c
--- a/kernel/power/user.c~swsusp-fix-snapshot_release
+++ a/kernel/power/user.c
@@ -86,7 +86,6 @@ static int snapshot_release(struct inode
 	if (data->frozen) {
 		mutex_lock(&pm_mutex);
 		thaw_processes();
-		enable_nonboot_cpus();
 		mutex_unlock(&pm_mutex);
 	}
 	atomic_inc(&snapshot_device_available);
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
