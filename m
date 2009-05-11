From: akpm@linux-foundation.org
Subject: + wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch added to -mm tree
Date: Mon, 11 May 2009 16:44:30 -0700
Message-ID: <200905112344.n4BNiUAD025797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758059AbZEKXrr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 19:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: v.mayatskih@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com


The patch titled
     wait_task_* cleanups: use copy_wait_opts_to_user() in wait_task_continued()
has been added to the -mm tree.  Its filename is
     wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

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
Subject: wait_task_* cleanups: use copy_wait_opts_to_user() in wait_task_continued()
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

All copy-paste getrusage() and put_user() code in wait_task_* functions is
replaced by call to copy_wait_opts_to_user()

It makes no sense to do conditional siginfo's fill,
copy_wait_opts_to_user() knows how to handle it right.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued kernel/exit.c
--- a/kernel/exit.c~wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued
+++ a/kernel/exit.c
@@ -1422,19 +1422,16 @@ static int wait_task_continued(struct wa
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
-	if (!wo->wo_info) {
-		retval = wo->wo_rusage
-			? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
-		put_task_struct(p);
-		if (!retval && wo->wo_stat)
-			retval = put_user(0xffff, wo->wo_stat);
-		if (!retval)
-			retval = pid;
-	} else {
-		retval = wait_noreap_copyout(wo, p, pid, uid,
-					     CLD_CONTINUED, SIGCONT);
-		BUG_ON(retval == 0);
-	}
+	retval = copy_wait_opts_to_user(wo, p, pid, uid,
+					CLD_CONTINUED, SIGCONT, SIGCHLD);
+	put_task_struct(p);
+
+	if (!retval && wo->wo_stat)
+		retval = put_user(0xffff, wo->wo_stat);
+	if (!retval)
+		retval = pid;
+
+	BUG_ON(retval == 0);
 
 	return retval;
 }
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

libata-avoid-world-writable-sysfs-files.patch
wait_task_-cleanups-split-wait_noreap_copyout.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_stopped.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-do_wait.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_zombie.patch
wait_task_-cleanups-use-copy_wait_opts_to_user-in-wait_task_continued.patch

