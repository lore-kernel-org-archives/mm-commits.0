From: akpm@linux-foundation.org
Subject: + sched-cleanup-remove-unused-variable-in-try_to_wake_up.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:13:17 -0800
Message-ID: <201003122213.o2CMDHcu011028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758703Ab0CLWNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu


The patch titled
     sched: cleanup: remove unused variable in try_to_wake_up()
has been added to the -mm tree.  Its filename is
     sched-cleanup-remove-unused-variable-in-try_to_wake_up.patch

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
Subject: sched: cleanup: remove unused variable in try_to_wake_up()
From: Dan Carpenter <error27@gmail.com>

We haven't used the "orig_rq" variable since 055a00865d "Fix/add missing
update_rq_clock() calls"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~sched-cleanup-remove-unused-variable-in-try_to_wake_up kernel/sched.c
--- a/kernel/sched.c~sched-cleanup-remove-unused-variable-in-try_to_wake_up
+++ a/kernel/sched.c
@@ -2359,7 +2359,7 @@ static int try_to_wake_up(struct task_st
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq, *orig_rq;
+	struct rq *rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
 		wake_flags &= ~WF_SYNC;
@@ -2367,7 +2367,7 @@ static int try_to_wake_up(struct task_st
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = orig_rq = task_rq_lock(p, &flags);
+	rq = task_rq_lock(p, &flags);
 	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
i915-fix-small-leak-on-error-path.patch
sched-cleanup-remove-unused-variable-in-try_to_wake_up.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
goku_udc-potential-null-dereference.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch

