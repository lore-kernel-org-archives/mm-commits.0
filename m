From: akpm@linux-foundation.org
Subject: + signals-introduce-send_sigkill-helper.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:30:54 -0700
Message-ID: <201006112030.o5BKUsrS017901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757815Ab0FKUbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, roland@redhat.com


The patch titled
     signals: introduce send_sigkill() helper
has been added to the -mm tree.  Its filename is
     signals-introduce-send_sigkill-helper.patch

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
Subject: signals: introduce send_sigkill() helper
From: Oleg Nesterov <oleg@redhat.com>

Cleanup, no functional changes.

There are a lot of buggy SIGKILL users in kernel.  For example, almost
every force_sig(SIGKILL) is wrong.  force_sig() is not safe, it assumes
that the task has the valid ->sighand, and in general it should be used
only for synchronous signals.  send_sig(SIGKILL, p, 1) or
send_xxx(SEND_SIG_FORCED/SEND_SIG_PRIV) is not right too but this is not
immediately obvious.

The only way to correctly send SIGKILL is send_sig_info(SEND_SIG_NOINFO)
but we do not want to use this directly, because we can optimize this case
later.  For example, zap_pid_ns_processes() allocates sigqueue for each
process in namespace, this is unneeded.

Introduce the trivial send_sigkill() helper on top of send_sig_info()
and change zap_pid_ns_processes() as an example.

Note: we need more cleanups here, this is only the first change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h  |    9 +++++++++
 kernel/pid_namespace.c |    8 +-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/sched.h~signals-introduce-send_sigkill-helper include/linux/sched.h
--- a/include/linux/sched.h~signals-introduce-send_sigkill-helper
+++ a/include/linux/sched.h
@@ -2049,6 +2049,15 @@ static inline int kill_cad_pid(int sig, 
 #define SEND_SIG_PRIV	((struct siginfo *) 1)
 #define SEND_SIG_FORCED	((struct siginfo *) 2)
 
+static inline int send_sigkill(struct task_struct * p)
+{
+	/*
+	 * Kills any user-space task, even SIGNAL_UNKILLABLE.
+	 * We use SEND_SIG_NOINFO to make si_fromuser() true.
+	 */
+	return send_sig_info(SIGKILL, SEND_SIG_NOINFO, p);
+}
+
 /*
  * True if we are on the alternate signal stack.
  */
diff -puN kernel/pid_namespace.c~signals-introduce-send_sigkill-helper kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~signals-introduce-send_sigkill-helper
+++ a/kernel/pid_namespace.c
@@ -160,15 +160,9 @@ void zap_pid_ns_processes(struct pid_nam
 	nr = next_pidmap(pid_ns, 1);
 	while (nr > 0) {
 		rcu_read_lock();
-
-		/*
-		 * Any nested-container's init processes won't ignore the
-		 * SEND_SIG_NOINFO signal, see send_signal()->si_fromuser().
-		 */
 		task = pid_task(find_vpid(nr), PIDTYPE_PID);
 		if (task)
-			send_sig_info(SIGKILL, SEND_SIG_NOINFO, task);
