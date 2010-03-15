From: akpm@linux-foundation.org
Subject: [merged] pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:41 -0400
Message-ID: <201003150702.o2F72Eu2016858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935855Ab0COHCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, serue@us.ibm.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     pid_ns: zap_pid_ns_processes: use SEND_SIG_NOINFO instead of force_sig()
has been removed from the -mm tree.  Its filename was
     pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid_ns: zap_pid_ns_processes: use SEND_SIG_NOINFO instead of force_sig()
From: Oleg Nesterov <oleg@redhat.com>

zap_pid_ns_processes() uses force_sig(SIGKILL) to ensure SIGKILL will be
delivered to sub-namespace inits as well.  This is correct, but we are
going to change force_sig_info() semantics.  See
http://bugzilla.kernel.org/show_bug.cgi?id=15395#c31

We can use send_sig_info(SEND_SIG_NOINFO) instead, since
614c517d7c00af1b26ded20646b329397d6f51a1 ("signals: SEND_SIG_NOINFO should
be considered as SI_FROMUSER()") SEND_SIG_NOINFO means "from user" and
therefore send_signal() will get the correct from_ancestor_ns = T flag.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/pid_namespace.c~pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pid_ns-zap_pid_ns_processes-use-send_sig_noinfo-instead-of-force_sig
+++ a/kernel/pid_namespace.c
@@ -161,13 +161,12 @@ void zap_pid_ns_processes(struct pid_nam
 		rcu_read_lock();
 
 		/*
-		 * Use force_sig() since it clears SIGNAL_UNKILLABLE ensuring
-		 * any nested-container's init processes don't ignore the
-		 * signal
+		 * Any nested-container's init processes won't ignore the
+		 * SEND_SIG_NOINFO signal, see send_signal()->si_fromuser().
 		 */
 		task = pid_task(find_vpid(nr), PIDTYPE_PID);
 		if (task)
-			force_sig(SIGKILL, task);
+			send_sig_info(SIGKILL, SEND_SIG_NOINFO, task);
 
 		rcu_read_unlock();
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race.patch

