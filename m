From: akpm@linux-foundation.org
Subject: + signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch added to -mm tree
Date: Thu, 25 Jun 2009 16:53:40 -0700
Message-ID: <200906252353.n5PNreI5020890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbZFYXyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 19:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com


The patch titled
     signals: shift security_task_wait() from eligible_child() to wait_consider_task()
has been added to the -mm tree.  Its filename is
     signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch

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
Subject: signals: shift security_task_wait() from eligible_child() to wait_consider_task()
From: Oleg Nesterov <oleg@redhat.com>

Preparation, no functional changes.

eligible_child() has a single caller, wait_consider_task().  We can move
security_task_wait() out from eligible_child(), this allows us to use it
for filtered wake_up().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/exit.c~signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task kernel/exit.c
--- a/kernel/exit.c~signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task
+++ a/kernel/exit.c
@@ -1108,8 +1108,6 @@ static struct pid *task_pid_type(struct 
 
 static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 {
-	int err;
-
 	if (wo->wo_type < PIDTYPE_MAX) {
 		if (task_pid_type(p, wo->wo_type) != wo->wo_pid)
 			return 0;
@@ -1124,10 +1122,6 @@ static int eligible_child(struct wait_op
 	    && !(wo->wo_flags & __WALL))
 		return 0;
 
-	err = security_task_wait(p);
-	if (err)
-		return err;
