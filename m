From: akpm@linux-foundation.org
Subject: + wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch added to -mm tree
Date: Mon, 11 May 2009 16:44:24 -0700
Message-ID: <200905112344.n4BNiPcI025696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbZEKXrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 19:47:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: v.mayatskih@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com


The patch titled
     wait_task_* cleanups: use copy_wait_opts_to_user() in wait_task_stopped()
has been added to the -mm tree.  Its filename is
     wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch

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
Subject: wait_task_* cleanups: use copy_wait_opts_to_user() in wait_task_stopped()
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

All copy-paste getrusage() and put_user() code in wait_task_* functions is
replaced by call to copy_wait_opts_to_user()

Also, there's no reason to have two almost similar branches of copy out in
wait_task_stopped().  The later branch also puts stat_addr to user, but it
can't affect WNOWAIT flag, and it's ok to merge both branches.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff -puN kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped kernel/exit.c
--- a/kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped
+++ a/kernel/exit.c
@@ -1351,7 +1351,6 @@ static int *task_stopped_code(struct tas
 static int wait_task_stopped(struct wait_opts *wo,
 				int ptrace, struct task_struct *p)
 {
-	struct siginfo __user *infop;
 	int retval, exit_code, *p_code, why;
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
@@ -1395,27 +1394,10 @@ unlock_sig:
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
 	read_unlock(&tasklist_lock);
 
-	if (unlikely(wo->wo_flags & WNOWAIT))
-		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
+	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, exit_code, SIGCHLD);
 
-	retval = wo->wo_rusage
-		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	if (!retval && wo->wo_stat)
 		retval = put_user((exit_code << 8) | 0x7f, wo->wo_stat);
-
-	infop = wo->wo_info;
-	if (!retval && infop)
-		retval = put_user(SIGCHLD, &infop->si_signo);
-	if (!retval && infop)
-		retval = put_user(0, &infop->si_errno);
-	if (!retval && infop)
-		retval = put_user((short)why, &infop->si_code);
-	if (!retval && infop)
-		retval = put_user(exit_code, &infop->si_status);
-	if (!retval && infop)
-		retval = put_user(pid, &infop->si_pid);
-	if (!retval && infop)
-		retval = put_user(uid, &infop->si_uid);
 	if (!retval)
 		retval = pid;
 	put_task_struct(p);
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

libata-avoid-world-writable-sysfs-files.patch
wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

