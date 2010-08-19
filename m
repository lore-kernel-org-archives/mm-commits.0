From: akpm@linux-foundation.org
Subject: + oom-fix-tasklist_lock-leak.patch added to -mm tree
Date: Thu, 19 Aug 2010 09:22:23 -0700
Message-ID: <201008191619.o7JGJcoA028164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab0HSQTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 12:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     oom: fix tasklist_lock leak
has been added to the -mm tree.  Its filename is
     oom-fix-tasklist_lock-leak.patch

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
Subject: oom: fix tasklist_lock leak
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 0aad4b3124 (oom: fold __out_of_memory into out_of_memory)
introduced tasklist_lock leak.  Then it caused following obvious danger
warnings and panic.

    ================================================
    [ BUG: lock held when returning to user space! ]
    ------------------------------------------------
    rsyslogd/1422 is leaving the kernel with locks still held!
    1 lock held by rsyslogd/1422:
     #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff810faf64>] out_of_memory+0x164/0x3f0
    BUG: scheduling while atomic: rsyslogd/1422/0x00000002
    INFO: lockdep is turned off.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom-fix-tasklist_lock-leak mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-tasklist_lock-leak
+++ a/mm/oom_kill.c
@@ -646,6 +646,7 @@ void out_of_memory(struct zonelist *zone
 	unsigned long freed = 0;
 	unsigned int points;
 	enum oom_constraint constraint = CONSTRAINT_NONE;
+	int killed = 0;
 
 	blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
 	if (freed > 0)
@@ -683,7 +684,7 @@ void out_of_memory(struct zonelist *zone
 		if (!oom_kill_process(current, gfp_mask, order, 0, totalpages,
 				NULL, nodemask,
 				"Out of memory (oom_kill_allocating_task)"))
-			return;
+			goto out;
 	}
 
 retry:
@@ -691,7 +692,7 @@ retry:
 			constraint == CONSTRAINT_MEMORY_POLICY ? nodemask :
 								 NULL);
 	if (PTR_ERR(p) == -1UL)
-		return;
+		goto out;
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
@@ -703,13 +704,15 @@ retry:
 	if (oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
 				nodemask, "Out of memory"))
 		goto retry;
+	killed = 1;
+out:
 	read_unlock(&tasklist_lock);
 
 	/*
 	 * Give "p" a good chance of killing itself before we
 	 * retry to allocate memory unless "p" is current
 	 */
-	if (!test_thread_flag(TIF_MEMDIE))
+	if (killed && !test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

oom-fix-null-pointer-dereference.patch
oom-fix-tasklist_lock-leak.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
reiser4.patch

