From: akpm@linux-foundation.org
Subject: + signals-introduce-do_send_sig_info-helper.patch added to -mm tree
Date: Mon, 03 Aug 2009 15:37:28 -0700
Message-ID: <200908032237.n73MbSaF005482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052AbZHCWif (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 18:38:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, eranian@googlemail.com, mingo@elte.hu, roland@redhat.com


The patch titled
     signals: introduce do_send_sig_info() helper
has been added to the -mm tree.  Its filename is
     signals-introduce-do_send_sig_info-helper.patch

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
Subject: signals: introduce do_send_sig_info() helper
From: Oleg Nesterov <oleg@redhat.com>

Introduce do_send_sig_info() and convert group_send_sig_info(),
send_sig_info(), do_send_specific() to use this helper.

Hopefully it will have more users soon, it allows to specify
specific/group behaviour via "bool group" argument.

Shaves 80 bytes from .text.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 +
 kernel/signal.c        |   56 ++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff -puN include/linux/signal.h~signals-introduce-do_send_sig_info-helper include/linux/signal.h
--- a/include/linux/signal.h~signals-introduce-do_send_sig_info-helper
+++ a/include/linux/signal.h
@@ -233,6 +233,8 @@ static inline int valid_signal(unsigned 
 }
 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
+extern int do_send_sig_info(int sig, struct siginfo *info,
+				struct task_struct *p, bool group);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
diff -puN kernel/signal.c~signals-introduce-do_send_sig_info-helper kernel/signal.c
--- a/kernel/signal.c~signals-introduce-do_send_sig_info-helper
+++ a/kernel/signal.c
@@ -971,6 +971,20 @@ specific_send_sig_info(int sig, struct s
 	return send_signal(sig, info, t, 0);
 }
 
+int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
+			bool group)
+{
+	unsigned long flags;
+	int ret = -ESRCH;
+
+	if (lock_task_sighand(p, &flags)) {
+		ret = send_signal(sig, info, p, group);
+		unlock_task_sighand(p, &flags);
+	}
+
+	return ret;
+}
+
 /*
  * Force a signal that the process can't ignore: if necessary
  * we unblock the signal and change any SIG_IGN to SIG_DFL.
@@ -1068,18 +1082,10 @@ struct sighand_struct *lock_task_sighand
  */
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret;
-
-	ret = check_kill_permission(sig, info, p);
+	int ret = check_kill_permission(sig, info, p);
 
-	if (!ret && sig) {
-		ret = -ESRCH;
-		if (lock_task_sighand(p, &flags)) {
-			ret = __group_send_sig_info(sig, info, p);
-			unlock_task_sighand(p, &flags);
-		}
-	}
+	if (!ret && sig)
+		ret = do_send_sig_info(sig, info, p, true);
 
 	return ret;
 }
@@ -1224,15 +1230,9 @@ static int kill_something_info(int sig, 
  * These are for backward compatibility with the rest of the kernel source.
  */
 
-/*
- * The caller must ensure the task can't exit.
- */
 int
 send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret;
-	unsigned long flags;
-
 	/*
 	 * Make sure legacy kernel users don't send in bad values
 	 * (normal paths check this in check_kill_permission).
@@ -1240,10 +1240,7 @@ send_sig_info(int sig, struct siginfo *i
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	ret = specific_send_sig_info(sig, info, p);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	return ret;
+	return do_send_sig_info(sig, info, p, false);
 }
 
 #define __si_special(priv) \
@@ -2281,7 +2278,6 @@ static int
 do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 {
 	struct task_struct *p;
-	unsigned long flags;
 	int error = -ESRCH;
 
 	rcu_read_lock();
@@ -2291,14 +2287,16 @@ do_send_specific(pid_t tgid, pid_t pid, 
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
-		 *
-		 * If lock_task_sighand() fails we pretend the task dies
-		 * after receiving the signal. The window is tiny, and the
-		 * signal is private anyway.
 		 */
-		if (!error && sig && lock_task_sighand(p, &flags)) {
-			error = specific_send_sig_info(sig, info, p);
-			unlock_task_sighand(p, &flags);
+		if (!error && sig) {
+			error = do_send_sig_info(sig, info, p, false);
+			/*
+			 * If lock_task_sighand() failed we pretend the task
+			 * dies after receiving the signal. The window is tiny,
+			 * and the signal is private anyway.
+			 */
+			if (unlikely(error == -ESRCH))
+				error = 0;
 		}
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
execve-must-clear-current-clear_child_tid-v2.patch
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
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
schedule_work-documentation-improvements.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

