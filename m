From: akpm@linux-foundation.org
Subject: [merged] do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:05 -0700
Message-ID: <200909241935.n8OJZ5Ac032201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbZIXTpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     do_wait() wakeup optimization: shift security_task_wait() from eligible_child() to wait_consider_task()
has been removed from the -mm tree.  Its filename was
     do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: do_wait() wakeup optimization: shift security_task_wait() from eligible_child() to wait_consider_task()
From: Oleg Nesterov <oleg@redhat.com>

Preparation, no functional changes.

eligible_child() has a single caller, wait_consider_task(). We can move
security_task_wait() out from eligible_child(), this allows us to use it
for filtered wake_up().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/exit.c~do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task kernel/exit.c
--- a/kernel/exit.c~do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task
+++ a/kernel/exit.c
@@ -1112,8 +1112,6 @@ static struct pid *task_pid_type(struct 
 
 static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 {
-	int err;
-
 	if (wo->wo_type < PIDTYPE_MAX) {
 		if (task_pid_type(p, wo->wo_type) != wo->wo_pid)
 			return 0;
@@ -1128,10 +1126,6 @@ static int eligible_child(struct wait_op
 	    && !(wo->wo_flags & __WALL))
 		return 0;
 
-	err = security_task_wait(p);
-	if (err)
-		return err;
