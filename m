From: akpm@linux-foundation.org
Subject: + signals-cleanup-security_task_kill-usage-implementation.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:27:16 -0800
Message-ID: <200802280327.m1S3RGPF013354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbYB1D23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, casey@schaufler-ca.com, dpquigl@tycho.nsa.gov, ebiederm@xmission.com, eparis@redhat.com, laforge@gnumonks.org, roland@redhat.com, sds@tycho.nsa.gov, serue@us.ibm.com, xemul@openvz.org


The patch titled
     signals: cleanup security_task_kill() usage/implementation
has been added to the -mm tree.  Its filename is
     signals-cleanup-security_task_kill-usage-implementation.patch

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
Subject: signals: cleanup security_task_kill() usage/implementation
From: Oleg Nesterov <oleg@tv-sign.ru>

Every implementation of ->task_kill() does nothing when the signal comes from
the kernel.  This is correct, but means that check_kill_permission() should
call security_task_kill() only for SI_FROMUSER() case, and we can remove the
same check from ->task_kill() implementations.

(sadly, check_kill_permission() is the last user of signal->session/__session
 but we can't s/task_session_nr/task_session/ here).

NOTE: Eric W.  Biederman pointed out cap_task_kill() should die, and I think
he is very right.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Quigley <dpquigl@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c            |   27 ++++++++++++++-------------
 security/commoncap.c       |    3 ---
 security/selinux/hooks.c   |    3 ---
 security/smack/smack_lsm.c |    9 ---------
 4 files changed, 14 insertions(+), 28 deletions(-)

diff -puN kernel/signal.c~signals-cleanup-security_task_kill-usage-implementation kernel/signal.c
--- a/kernel/signal.c~signals-cleanup-security_task_kill-usage-implementation
+++ a/kernel/signal.c
@@ -533,22 +533,23 @@ static int rm_from_queue(unsigned long m
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
-	int error = -EINVAL;
+	int error;
+
 	if (!valid_signal(sig))
-		return error;
+		return -EINVAL;
 
-	if (info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info))) {
-		error = audit_signal_info(sig, t); /* Let audit system see the signal */
-		if (error)
-			return error;
-		error = -EPERM;
-		if (((sig != SIGCONT) ||
-			(task_session_nr(current) != task_session_nr(t)))
-		    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
-		    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
-		    && !capable(CAP_KILL))
+	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
+		return 0;
+
+	error = audit_signal_info(sig, t); /* Let audit system see the signal */
+	if (error)
 		return error;
-	}
+
+	if (((sig != SIGCONT) || (task_session_nr(current) != task_session_nr(t)))
+	    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
+	    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
+	    && !capable(CAP_KILL))
+		return -EPERM;
 
 	return security_task_kill(t, info, sig, 0);
 }
diff -puN security/commoncap.c~signals-cleanup-security_task_kill-usage-implementation security/commoncap.c
--- a/security/commoncap.c~signals-cleanup-security_task_kill-usage-implementation
+++ a/security/commoncap.c
@@ -540,9 +540,6 @@ int cap_task_setnice (struct task_struct
 int cap_task_kill(struct task_struct *p, struct siginfo *info,
 				int sig, u32 secid)
 {
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-
 	/*
 	 * Running a setuid root program raises your capabilities.
 	 * Killing your own setuid root processes was previously
diff -puN security/selinux/hooks.c~signals-cleanup-security_task_kill-usage-implementation security/selinux/hooks.c
--- a/security/selinux/hooks.c~signals-cleanup-security_task_kill-usage-implementation
+++ a/security/selinux/hooks.c
@@ -3203,9 +3203,6 @@ static int selinux_task_kill(struct task
 	if (rc)
 		return rc;
 
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-
 	if (!sig)
 		perm = PROCESS__SIGNULL; /* null signal; existence test */
 	else
diff -puN security/smack/smack_lsm.c~signals-cleanup-security_task_kill-usage-implementation security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~signals-cleanup-security_task_kill-usage-implementation
+++ a/security/smack/smack_lsm.c
@@ -1130,15 +1130,6 @@ static int smack_task_kill(struct task_s
 	if (rc != 0)
 		return rc;
 	/*
-	 * Special cases where signals really ought to go through
-	 * in spite of policy. Stephen Smalley suggests it may
-	 * make sense to change the caller so that it doesn't
-	 * bother with the LSM hook in these cases.
-	 */
-	if (info != SEND_SIG_NOINFO &&
-	    (is_si_special(info) || SI_FROMKERNEL(info)))
-		return 0;
-	/*
 	 * Sending a signal requires that the sender
 	 * can write the receiver.
 	 */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
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
