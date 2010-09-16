From: akpm@linux-foundation.org
Subject: + oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:50:27 -0700
Message-ID: <201009162250.o8GMoSug018489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab0IPWup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     oom: protect oom_disable_count with task_lock in fork
has been added to the -mm tree.  Its filename is
     oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch

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
Subject: oom: protect oom_disable_count with task_lock in fork
From: David Rientjes <rientjes@google.com>

task_lock(p) protects p->mm->oom_disable_count such that it accurately
represents the number of threads attached to that mm that cannot be killed
by the oom killer.  p->signal->oom_score_adj is never changed without
holding the lock.

This was missed in the fork() path, so we take the lock to ensure checking
its oom_score_adj and decrementing oom_disable_count don't race.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/fork.c~oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork kernel/fork.c
--- a/kernel/fork.c~oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork
+++ a/kernel/fork.c
@@ -1304,8 +1304,10 @@ bad_fork_cleanup_namespaces:
 	exit_task_namespaces(p);
 bad_fork_cleanup_mm:
 	if (p->mm) {
+		task_lock(p);
 		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 			atomic_dec(&p->mm->oom_disable_count);
+		task_unlock(p);
 		mmput(p->mm);
 	}
 bad_fork_cleanup_signal:
_

Patches currently in -mm which might be from rientjes@google.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
linux-next.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-mempolicy-check-return-code-of-check_range.patch
jbd-remove-dependency-on-__gfp_nofail.patch

