From: akpm@linux-foundation.org
Subject: [to-be-updated] wait_task_-cleanups-split-wait_noreap_copyout.patch removed from -mm tree
Date: Mon, 15 Jun 2009 10:15:59 -0700
Message-ID: <200906151715.n5FHFxmL025925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764126AbZFORQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 13:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: v.mayatskih@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_* cleanups: split wait_noreap_copyout()
has been removed from the -mm tree.  Its filename was
     wait_task_-cleanups-split-wait_noreap_copyout.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_* cleanups: split wait_noreap_copyout()
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

Move getrusage() and put_user() code from wait_noreap_copyout() to
copy_wait_opts_to_user().  The same code is spreaded across all
wait_task_*() routines, it's better to reuse one copy.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff -puN kernel/exit.c~wait_task_-cleanups-split-wait_noreap_copyout kernel/exit.c
--- a/kernel/exit.c~wait_task_-cleanups-split-wait_noreap_copyout
+++ a/kernel/exit.c
@@ -1125,27 +1125,34 @@ static int eligible_child(struct wait_op
 	return 1;
 }
 
-static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
-				pid_t pid, uid_t uid, int why, int status)
+static int copy_wait_opts_to_user(struct wait_opts *wo, struct task_struct *p,
+				  pid_t pid, uid_t uid, int why, int status, int signal)
 {
-	struct siginfo __user *infop;
+	struct siginfo __user *infop = wo->wo_info;
 	int retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
 
+	if (!retval && infop) {
+		retval = put_user(signal, &infop->si_signo);
+		if (!retval)
+			retval = put_user(0, &infop->si_errno);
+		if (!retval)
+			retval = put_user((short)why, &infop->si_code);
+		if (!retval)
+			retval = put_user(pid, &infop->si_pid);
+		if (!retval)
+			retval = put_user(uid, &infop->si_uid);
+		if (!retval)
+			retval = put_user(status, &infop->si_status);
+	}
+	return retval;
+}
+
+static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
+				pid_t pid, uid_t uid, int why, int status)
+{
+	int retval = copy_wait_opts_to_user(wo, p, pid, uid, why, status, SIGCHLD);
 	put_task_struct(p);
-	infop = wo->wo_info;
-	if (!retval)
-		retval = put_user(SIGCHLD, &infop->si_signo);
-	if (!retval)
-		retval = put_user(0, &infop->si_errno);
-	if (!retval)
-		retval = put_user((short)why, &infop->si_code);
-	if (!retval)
-		retval = put_user(pid, &infop->si_pid);
-	if (!retval)
-		retval = put_user(uid, &infop->si_uid);
-	if (!retval)
-		retval = put_user(status, &infop->si_status);
 	if (!retval)
 		retval = pid;
 	return retval;
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

