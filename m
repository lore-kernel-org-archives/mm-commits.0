From: akpm@linux-foundation.org
Subject: [to-be-updated] wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch removed from -mm tree
Date: Mon, 15 Jun 2009 10:16:05 -0700
Message-ID: <200906151716.n5FHG5MH026080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764231AbZFORQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 13:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: v.mayatskih@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_* cleanups: use copy_wait_opts_to_user() in wait_task_zombie()
has been removed from the -mm tree.  Its filename was
     wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_* cleanups: use copy_wait_opts_to_user() in wait_task_zombie()
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

All copy-paste getrusage() and put_user() code in wait_task_* functions is
replaced by call to copy_wait_opts_to_user()

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff -puN kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie kernel/exit.c
--- a/kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie
+++ a/kernel/exit.c
@@ -1167,17 +1167,15 @@ static int wait_noreap_copyout(struct wa
 static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
 	unsigned long state;
-	int retval, status, traced;
+	int retval, why, status, traced;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
-	struct siginfo __user *infop;
 
 	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
 		int exit_code = p->exit_code;
-		int why, status;
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
@@ -1273,36 +1271,21 @@ static int wait_task_zombie(struct wait_
 	 */
 	read_unlock(&tasklist_lock);
 
-	retval = wo->wo_rusage
-		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
 		? p->signal->group_exit_code : p->exit_code;
-	if (!retval && wo->wo_stat)
+	if (wo->wo_stat)
 		retval = put_user(status, wo->wo_stat);
 
-	infop = wo->wo_info;
-	if (!retval && infop)
-		retval = put_user(SIGCHLD, &infop->si_signo);
-	if (!retval && infop)
-		retval = put_user(0, &infop->si_errno);
-	if (!retval && infop) {
-		int why;
-
-		if ((status & 0x7f) == 0) {
-			why = CLD_EXITED;
-			status >>= 8;
-		} else {
-			why = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
-			status &= 0x7f;
-		}
-		retval = put_user((short)why, &infop->si_code);
-		if (!retval)
-			retval = put_user(status, &infop->si_status);
+	if ((status & 0x7f) == 0) {
+		why = CLD_EXITED;
+		status >>= 8;
+	} else {
+		why = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		status &= 0x7f;
 	}
-	if (!retval && infop)
-		retval = put_user(pid, &infop->si_pid);
-	if (!retval && infop)
-		retval = put_user(uid, &infop->si_uid);
+
+	retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
+
 	if (!retval)
 		retval = pid;
 
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

