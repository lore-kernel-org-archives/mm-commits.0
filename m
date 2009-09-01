From: akpm@linux-foundation.org
Subject: + workqueues-introduce-__cancel_delayed_work.patch added to -mm tree
Date: Tue, 01 Sep 2009 15:25:18 -0700
Message-ID: <200909012225.n81MPIPa012484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755230AbZIAWZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 18:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefanr@s5r6.in-berlin.de


The patch titled
     workqueues: introduce __cancel_delayed_work()
has been added to the -mm tree.  Its filename is
     workqueues-introduce-__cancel_delayed_work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues: introduce __cancel_delayed_work()
From: Oleg Nesterov <oleg@redhat.com>

cancel_delayed_work() has to use del_timer_sync() to guarantee the timer
function is not running after return.  But most users doesn't actually
need this, and del_timer_sync() has problems: it is not useable from
interrupt, and it depends on every lock which could be taken from irq.

Introduce __cancel_delayed_work() which calls del_timer() instead.

The immediate reason for this patch is
http://bugzilla.kernel.org/show_bug.cgi?id=13757
but hopefully this helper makes sense anyway.

As for 13757 bug, actually we need requeue_delayed_work(), but its
semantics is not clear yet.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/workqueue.h~workqueues-introduce-__cancel_delayed_work include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueues-introduce-__cancel_delayed_work
+++ a/include/linux/workqueue.h
@@ -240,6 +240,21 @@ static inline int cancel_delayed_work(st
 	return ret;
 }
 
+/*
+ * Like above, but uses del_timer() instead of del_timer_sync(). This means,
+ * if it returns 0 the timer function may be running and the queueing is in
+ * progress.
+ */
+static inline int __cancel_delayed_work(struct delayed_work *work)
+{
+	int ret;
+
+	ret = del_timer(&work->timer);
+	if (ret)
+		work_clear_pending(&work->work);
+	return ret;
+}
+
 extern int cancel_delayed_work_sync(struct delayed_work *work);
 
 /* Obsolete. use cancel_delayed_work_sync() */
_

Patches currently in -mm which might be from oleg@redhat.com are

workqueues-introduce-__cancel_delayed_work.patch
linux-next.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

