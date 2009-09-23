From: akpm@linux-foundation.org
Subject: [folded] signals-introduce-tracehook_finish_jctl-helper.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:35:18 -0700
Message-ID: <200909232235.n8NMZIHj028821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbZIWWf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:35:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: introduce tracehook_finish_jctl() helper
has been removed from the -mm tree.  Its filename was
     signals-introduce-tracehook_finish_jctl-helper.patch

This patch was dropped because it was folded into signals-tracehook_notify_jctl-change.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: introduce tracehook_finish_jctl() helper
From: Oleg Nesterov <oleg@redhat.com>

Introduce the empty inline tracehook_finish_jctl() helper called by
do_signal_stop() after wakeup.

Currently we lack the ability to report this state change.

Also fix the comment, it should be placed before schedule().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    9 +++++++++
 kernel/signal.c           |    6 +++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff -puN include/linux/tracehook.h~signals-introduce-tracehook_finish_jctl-helper include/linux/tracehook.h
--- a/include/linux/tracehook.h~signals-introduce-tracehook_finish_jctl-helper
+++ a/include/linux/tracehook.h
@@ -488,6 +488,15 @@ static inline int tracehook_notify_jctl(
 	return notify ?: (current->ptrace & PT_PTRACED) ? why : 0;
 }
 
+/**
+ * tracehook_finish_jctl - report about return from job control stop
+ *
+ * This is called by do_signal_stop() after wakeup.
+ */
+static inline void tracehook_finish_jctl(void)
+{
+}
+
 #define DEATH_REAP			-1
 #define DEATH_DELAYED_GROUP_LEADER	-2
 
diff -puN kernel/signal.c~signals-introduce-tracehook_finish_jctl-helper kernel/signal.c
--- a/kernel/signal.c~signals-introduce-tracehook_finish_jctl-helper
+++ a/kernel/signal.c
@@ -1717,12 +1717,12 @@ static int do_signal_stop(int signr)
 		read_unlock(&tasklist_lock);
 	}
 
+	/* Now we don't run again until woken by SIGCONT or SIGKILL */
 	do {
 		schedule();
 	} while (try_to_freeze());
-	/*
-	 * Now we don't run again until continued.
-	 */
+
+	tracehook_finish_jctl();
 	current->exit_code = 0;
 
 	return 1;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-tracehook_notify_jctl-change.patch
signals-introduce-tracehook_finish_jctl-helper.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

