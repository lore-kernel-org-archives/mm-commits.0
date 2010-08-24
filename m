From: akpm@linux-foundation.org
Subject: + oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch added to -mm tree
Date: Tue, 24 Aug 2010 15:50:28 -0700
Message-ID: <201008242250.o7OMoSgd019457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab0HXWvM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 18:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     oom: protect task name when killing threads sharing memory
has been added to the -mm tree.  Its filename is
     oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch

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
Subject: oom: protect task name when killing threads sharing memory
From: David Rientjes <rientjes@google.com>

It's necessary to prevent dereferences of q->comm for a task q when q !=
current because its name may change during prctl() with PR_SET_NAME.

Unfortunately, we can't use get_task_comm() when killing other threads
sharing the same memory as the oom killed task since it would require a
string to be allocated on the stack which may be very deep, especially
during failed page allocations.

This patch protects the dereference with task_lock() instead.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/oom_kill.c~oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix mm/oom_kill.c
--- a/mm/oom_kill.c~oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix
+++ a/mm/oom_kill.c
@@ -429,8 +429,10 @@ static int oom_kill_task(struct task_str
 	 */
 	for_each_process(q)
 		if (q->mm == mm && !same_thread_group(q, p)) {
+			task_lock(q);
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(q), q->comm);
+			task_unlock(q);
 			force_sig(SIGKILL, q);
 		}
 
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
jbd-remove-dependency-on-__gfp_nofail.patch

