From: akpm@linux-foundation.org
Subject: + exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:57:01 -0700
Message-ID: <200708072257.l77Mv1p3009160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757987AbXHGW6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     exit_notify: don't take tasklist for TIF_SIGPENDING re-targeting
has been added to the -mm tree.  Its filename is
     exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: exit_notify: don't take tasklist for TIF_SIGPENDING re-targeting
From: Oleg Nesterov <oleg@tv-sign.ru>

->siglock provides enough protection to iterate over the thread group.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/exit.c~exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting kernel/exit.c
--- a/kernel/exit.c~exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting
+++ a/kernel/exit.c
@@ -755,13 +755,11 @@ static void exit_notify(struct task_stru
 		 * Now we'll wake all the threads in the group just to make
 		 * sure someone gets all the pending signals.
 		 */
-		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		for (t = next_thread(tsk); t != tsk; t = next_thread(t))
 			if (!signal_pending(t) && !(t->flags & PF_EXITING))
 				recalc_sigpending_and_wake(t);
 		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
 	}
 
 	write_lock_irq(&tasklist_lock);
@@ -789,9 +787,8 @@ static void exit_notify(struct task_stru
 	 * and we were the only connection outside, so our pgrp
 	 * is about to become orphaned.
 	 */
-	 
 	t = tsk->real_parent;
-	
+
 	pgrp = task_pgrp(tsk);
 	if ((task_pgrp(t) != pgrp) &&
 	    (task_session(t) == task_session(tsk)) &&
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
