From: akpm@linux-foundation.org
Subject: + wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch added to -mm tree
Date: Mon, 11 May 2009 16:44:26 -0700
Message-ID: <200905112344.n4BNiRbA025711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758231AbZEKXry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 19:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: v.mayatskih@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com


The patch titled
     wait_task_* cleanups: use copy_wait_opts_to_user() in do_wait()
has been added to the -mm tree.  Its filename is
     wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch

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
Subject: wait_task_* cleanups: use copy_wait_opts_to_user() in do_wait()
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

All copy-paste getrusage() and put_user() code in wait_task_* functions is
replaced by call to copy_wait_opts_to_user()

Use copy_wait_opts_to_user() in do_wait() to clean up user's siginfo
structure.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff -puN kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait kernel/exit.c
--- a/kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait
+++ a/kernel/exit.c
@@ -1606,8 +1606,6 @@ end:
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
 	if (wo->wo_info) {
-		struct siginfo __user *infop = wo->wo_info;
-
 		if (retval > 0)
 			retval = 0;
 		else {
@@ -1616,18 +1614,7 @@ end:
 			 * we would set so the user can easily tell the
 			 * difference.
 			 */
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
+			retval = copy_wait_opts_to_user(wo, 0, 0, 0, 0, 0, 0);
 		}
 	}
 	return retval;
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

libata-avoid-world-writable-sysfs-files.patch
wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

