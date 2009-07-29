From: akpm@linux-foundation.org
Subject: + signals-introduce-tracehook_finish_jctl-helper.patch added to -mm tree
Date: Wed, 29 Jul 2009 15:50:20 -0700
Message-ID: <200907292250.n6TMoKT4029268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbZG2Wug (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 18:50:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     signals: introduce tracehook_finish_jctl() helper
has been added to the -mm tree.  Its filename is
     signals-introduce-tracehook_finish_jctl-helper.patch

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
Subject: signals: introduce tracehook_finish_jctl() helper
From: Oleg Nesterov <oleg@redhat.com>

Introduce the empty inline tracehook_finish_jctl() helper called by
do_signal_stop() after wakeup.

Currently we lack the ability to report this state change.

Also fix the comment, it should be placed before schedule().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
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
@@ -1726,12 +1726,12 @@ static int do_signal_stop(int signr)
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
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch

