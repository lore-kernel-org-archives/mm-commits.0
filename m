From: akpm@linux-foundation.org
Subject: - fix-pf_nofreeze-and-freezeable-race.patch removed from -mm tree
Date: Wed, 25 Apr 2007 16:15:56 -0700
Message-ID: <200704252315.l3PNFuKK015508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbXDYXQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 19:16:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ego@in.ibm.com, oleg@tv-sign.ru, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     Fix PF_NOFREEZE and freezeable race
has been removed from the -mm tree.  Its filename was
     fix-pf_nofreeze-and-freezeable-race.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Fix PF_NOFREEZE and freezeable race
From: Gautham R Shenoy <ego@in.ibm.com>

This patch fixes the race pointed out by Oleg Nesterov.

* Freezer marks a thread as freezeable.
* The thread now marks itself PF_NOFREEZE causing it to
  freeze on calling try_to_freeze(). Thus the task is frozen, even though
  it doesn't want to.
* Subsequent thaw_processes() will also fail to thaw the task since it is
  marked PF_NOFREEZE.

Avoid this problem by checking the current task's PF_NOFREEZE status in the
refrigerator before marking current as frozen.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN kernel/power/process.c~fix-pf_nofreeze-and-freezeable-race kernel/power/process.c
--- a/kernel/power/process.c~fix-pf_nofreeze-and-freezeable-race
+++ a/kernel/power/process.c
@@ -41,6 +41,15 @@ void refrigerator(void)
 
 	task_lock(current);
 	if (freezing(current)) {
+		/* check if we had marked ourself PF_NOFREEZE
+		 * *after* the freezer did the freezeable() check
+		 * on us.
+		 */
+		if (current->flags & PF_NOFREEZE) {
+			clear_tsk_thread_flag(current, TIF_FREEZE);
+			task_unlock(current);
+			return;
+		}
 		frozen_process(current);
 		task_unlock(current);
 	} else {
_

Patches currently in -mm which might be from ego@in.ibm.com are

i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
flush_cpu_workqueue-dont-flush-an-empty-worklist.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
fix-pf_nofreeze-and-freezeable-race.patch
freezer-document-task_lock-in-thaw_process.patch
add-suspend-related-notifications-for-cpu-hotplug.patch
microcode-use-suspend-related-cpu-hotplug-notifications.patch
