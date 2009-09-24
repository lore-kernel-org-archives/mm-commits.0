From: akpm@linux-foundation.org
Subject: [merged] do_wait-fix-sys_waitid-specific-behaviour.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:23 -0700
Message-ID: <200909241935.n8OJZN2K000346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbZIXTf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: v.mayatskih@gmail.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait: fix sys_waitid()-specific behaviour
has been removed from the -mm tree.  Its filename was
     do_wait-fix-sys_waitid-specific-behaviour.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait: fix sys_waitid()-specific behaviour
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

do_wait() checks ->wo_info to figure out who is the caller.  If it's not
NULL the caller should be sys_waitid(), in that case do_wait() fixes up
the retval or zeros ->wo_info, depending on retval from underlying
function.

This is bug: user can pass ->wo_info == NULL and sys_waitid() will return
incorrect value.

man 2 waitid says:

	waitid(): returns 0 on success

Test-case:

	int main(void)
	{
		if (fork())
			assert(waitid(P_ALL, 0, NULL, WEXITED) == 0);

		return 0;
	}

Result:

	Assertion `waitid(P_ALL, 0, ((void *)0), 4) == 0' failed.

Move that code to sys_waitid().

User-visible change: sys_waitid() will return 0 on success, either
infop is set or not.

Note, there's another bug in wait_noreap_copyout() which affects
return value of sys_waitid(). It will be fixed in next patch.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   49 ++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff -puN kernel/exit.c~do_wait-fix-sys_waitid-specific-behaviour kernel/exit.c
--- a/kernel/exit.c~do_wait-fix-sys_waitid-specific-behaviour
+++ a/kernel/exit.c
@@ -1645,32 +1645,6 @@ notask:
 end:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
-
-	if (wo->wo_info) {
-		struct siginfo __user *infop = wo->wo_info;
-
-		if (retval > 0)
-			retval = 0;
-		else {
-			/*
-			 * For a WNOHANG return, clear out all the fields
-			 * we would set so the user can easily tell the
-			 * difference.
-			 */
-			if (!retval)
-				retval = put_user(0, &infop->si_signo);
-			if (!retval)
-				retval = put_user(0, &infop->si_errno);
-			if (!retval)
-				retval = put_user(0, &infop->si_code);
-			if (!retval)
-				retval = put_user(0, &infop->si_pid);
-			if (!retval)
-				retval = put_user(0, &infop->si_uid);
-			if (!retval)
-				retval = put_user(0, &infop->si_status);
-		}
-	}
 	return retval;
 }
 
@@ -1715,6 +1689,29 @@ SYSCALL_DEFINE5(waitid, int, which, pid_
 	wo.wo_stat	= NULL;
 	wo.wo_rusage	= ru;
 	ret = do_wait(&wo);
+
+	if (ret > 0) {
+		ret = 0;
+	} else if (infop) {
+		/*
+		 * For a WNOHANG return, clear out all the fields
+		 * we would set so the user can easily tell the
+		 * difference.
+		 */
+		if (!ret)
+			ret = put_user(0, &infop->si_signo);
+		if (!ret)
+			ret = put_user(0, &infop->si_errno);
+		if (!ret)
+			ret = put_user(0, &infop->si_code);
+		if (!ret)
+			ret = put_user(0, &infop->si_pid);
+		if (!ret)
+			ret = put_user(0, &infop->si_uid);
+		if (!ret)
+			ret = put_user(0, &infop->si_status);
+	}
+
 	put_pid(pid);
 
 	/* avoid REGPARM breakage on x86: */
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

origin.patch

