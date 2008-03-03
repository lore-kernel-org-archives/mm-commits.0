From: akpm@linux-foundation.org
Subject: + ptrace-introduce-ptrace_reparented-helper.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:31:21 -0800
Message-ID: <200803030831.m238VLEb006875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666AbYCCIdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:33:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     ptrace: introduce ptrace_reparented() helper
has been added to the -mm tree.  Its filename is
     ptrace-introduce-ptrace_reparented-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: introduce ptrace_reparented() helper
From: Oleg Nesterov <oleg@tv-sign.ru>

Add another trivial helper for the sake of grep.  It also auto-documents the
fact that ->parent != real_parent implies ->ptrace.

No functional changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    4 ++++
 kernel/exit.c          |    9 ++++-----
 kernel/ptrace.c        |    2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-introduce-ptrace_reparented-helper include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-introduce-ptrace_reparented-helper
+++ a/include/linux/ptrace.h
@@ -98,6 +98,10 @@ extern void ptrace_untrace(struct task_s
 extern int ptrace_may_attach(struct task_struct *task);
 extern int __ptrace_may_attach(struct task_struct *task);
 
+static inline int ptrace_reparented(struct task_struct *child)
+{
+	return child->real_parent != child->parent;
+}
 static inline void ptrace_link(struct task_struct *child,
 			       struct task_struct *new_parent)
 {
diff -puN kernel/exit.c~ptrace-introduce-ptrace_reparented-helper kernel/exit.c
--- a/kernel/exit.c~ptrace-introduce-ptrace_reparented-helper
+++ a/kernel/exit.c
@@ -632,7 +632,7 @@ reparent_thread(struct task_struct *p, s
 	if (unlikely(traced)) {
 		/* Preserve ptrace links if someone else is tracing this child.  */
 		list_del_init(&p->ptrace_list);
-		if (p->parent != p->real_parent)
+		if (ptrace_reparented(p))
 			list_add(&p->ptrace_list, &p->real_parent->ptrace_children);
 	} else {
 		/* If this child is being traced, then we're the one tracing it
@@ -799,8 +799,8 @@ static void exit_notify(struct task_stru
 	 * only has special meaning to our real parent.
 	 */
 	if (!task_detached(tsk) && thread_group_empty(tsk)) {
-		int signal = (tsk->parent == tsk->real_parent)
-				? tsk->exit_signal : SIGCHLD;
+		int signal = ptrace_reparented(tsk) ?
+				SIGCHLD : tsk->exit_signal;
 		do_notify_parent(tsk, signal);
 	} else if (tsk->ptrace) {
 		do_notify_parent(tsk, SIGCHLD);
@@ -1202,8 +1202,7 @@ static int wait_task_zombie(struct task_
 		return 0;
 	}
 
-	/* traced means p->ptrace, but not vice versa */
-	traced = (p->real_parent != p->parent);
+	traced = ptrace_reparented(p);
 
 	if (likely(!traced)) {
 		struct signal_struct *psig;
diff -puN kernel/ptrace.c~ptrace-introduce-ptrace_reparented-helper kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-introduce-ptrace_reparented-helper
+++ a/kernel/ptrace.c
@@ -73,7 +73,7 @@ void __ptrace_unlink(struct task_struct 
 	BUG_ON(!child->ptrace);
 
 	child->ptrace = 0;
-	if (!list_empty(&child->ptrace_list)) {
+	if (ptrace_reparented(child)) {
 		list_del_init(&child->ptrace_list);
 		remove_parent(child);
 		child->parent = child->real_parent;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
introduce-kill_orphaned_pgrp-helper.patch
will_become_orphaned_pgrp-partially-fix-insufficient-exit_state-check.patch
exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit.patch
ptrace-introduce-task_detached-helper.patch
ptrace-introduce-ptrace_reparented-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

