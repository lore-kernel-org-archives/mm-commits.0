From: akpm@linux-foundation.org
Subject: + wait_noreap_copyout-check-for-wo_info-=-null.patch added to -mm tree
Date: Tue, 21 Jul 2009 15:55:19 -0700
Message-ID: <200907212255.n6LMtKKn021214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898AbZGUW4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 18:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: v.mayatskih@gmail.com, oleg@redhat.com, roland@redhat.com


The patch titled
     wait_noreap_copyout(): check for ->wo_info != NULL
has been added to the -mm tree.  Its filename is
     wait_noreap_copyout-check-for-wo_info-=-null.patch

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
Subject: wait_noreap_copyout(): check for ->wo_info != NULL
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>

Current behaviour of sys_waitid() looks odd.  If user passes infop ==
NULL, sys_waitid() returns success.  When user additionally specifies flag
WNOWAIT, sys_waitid() returns -EFAULT on the same conditions.  When user
combines WNOWAIT with WCONTINUED, sys_waitid() again returns success.

This patch adds check for ->wo_info in wait_noreap_copyout().

User-visible change: starting from this commit, sys_waitid() always checks
infop != NULL and does not fail if it is NULL.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN kernel/exit.c~wait_noreap_copyout-check-for-wo_info-=-null kernel/exit.c
--- a/kernel/exit.c~wait_noreap_copyout-check-for-wo_info-=-null
+++ a/kernel/exit.c
@@ -1135,18 +1135,20 @@ static int wait_noreap_copyout(struct wa
 
 	put_task_struct(p);
 	infop = wo->wo_info;
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
+	if (infop) {
+		if (!retval)
+			retval = put_user(SIGCHLD, &infop->si_signo);
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
 	if (!retval)
 		retval = pid;
 	return retval;
_

Patches currently in -mm which might be from v.mayatskih@gmail.com are

do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch

