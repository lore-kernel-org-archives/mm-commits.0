From: akpm@linux-foundation.org
Subject: + revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync.patch added to -mm tree
Date: Thu, 17 May 2007 12:57:21 -0700
Message-ID: <200705171957.l4HJvL0m031568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756246AbXEQUAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 16:00:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, dhowells@redhat.com, jarkao2@o2.pl


The patch titled
     revert "cancel_delayed_work: use del_timer() instead of del_timer_sync()"
has been added to the -mm tree.  Its filename is
     revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert "cancel_delayed_work: use del_timer() instead of del_timer_sync()"
From: Oleg Nesterov <oleg@tv-sign.ru>

As pointed out by Jarek Poplawski, the patch

	[WORKQUEUE]: cancel_delayed_work: use del_timer() instead of del_timer_sync()
	commit: 071b638689464c6b39407025eedd810d5b5e6f5d

was wrong, it was merged by mistake after that.

From the changelog:

	after this patch:
		...
		delayed_work_timer_fn->__queue_work() in progress.

		The latter doesn't differ from the caller's POV,

it does make a difference if the caller calls flush_workqueue() after
cancel_delayed_work(), in that case flush_workqueue() can miss this
work_struct.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/workqueue.h~revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync include/linux/workqueue.h
--- a/include/linux/workqueue.h~revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync
+++ a/include/linux/workqueue.h
@@ -160,7 +160,7 @@ static inline int cancel_delayed_work(st
 {
 	int ret;
 
-	ret = del_timer(&work->timer);
+	ret = del_timer_sync(&work->timer);
 	if (ret)
 		work_clear_pending(&work->work);
 	return ret;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

make-freezeable-workqueues-singlethread.patch
revert-cancel_delayed_work-use-del_timer-instead-of-del_timer_sync.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
git-nfs.patch
recalc_sigpending_tsk-fixes.patch
freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
tidy-up-usermode-helper-waiting-a-bit.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
