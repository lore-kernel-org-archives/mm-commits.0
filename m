From: akpm@linux-foundation.org
Subject: [to-be-updated] wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch removed from -mm tree
Date: Mon, 15 Jun 2009 10:16:01 -0700
Message-ID: <200906151716.n5FHG1GM025929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764129AbZFORQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 13:16:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: v.mayatskih@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_* cleanups: use copy_wait_opts_to_user() in wait_task_stopped()
has been removed from the -mm tree.  Its filename was
     wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch

This patch was dropped because an updated version will be merged

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

wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

