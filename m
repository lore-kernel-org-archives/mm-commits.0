From: akpm@linux-foundation.org
Subject: + oom-fix-locking-for-oom_adj-and-oom_score_adj.patch added to -mm tree
Date: Fri, 03 Sep 2010 14:10:46 -0700
Message-ID: <201009032110.o83LAkkE012530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962Ab0ICVL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 17:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     oom: fix locking for oom_adj and oom_score_adj
has been added to the -mm tree.  Its filename is
     oom-fix-locking-for-oom_adj-and-oom_score_adj.patch

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
Subject: oom: fix locking for oom_adj and oom_score_adj
From: David Rientjes <rientjes@google.com>

The locking order in oom_adjust_write() and oom_score_adj_write() for
task->alloc_lock and task->sighand->siglock is reversed, and lockdep
notices that irqs could encounter an ABBA scenario.

This fixes the locking order so that we always take task_lock(task) prior
to lock_task_sighand(task).

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff -puN fs/proc/base.c~oom-fix-locking-for-oom_adj-and-oom_score_adj fs/proc/base.c
--- a/fs/proc/base.c~oom-fix-locking-for-oom_adj-and-oom_score_adj
+++ a/fs/proc/base.c
@@ -1044,9 +1044,16 @@ static ssize_t oom_adjust_write(struct f
 		err = -ESRCH;
 		goto out;
 	}
+
+	task_lock(task);
+	if (!task->mm) {
+		err = -EINVAL;
+		goto err_task_lock;
+	}
+
 	if (!lock_task_sighand(task, &flags)) {
 		err = -ESRCH;
-		goto err_task_struct;
+		goto err_task_lock;
 	}
 
 	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
@@ -1054,12 +1061,6 @@ static ssize_t oom_adjust_write(struct f
 		goto err_sighand;
 	}
 
-	task_lock(task);
-	if (!task->mm) {
-		err = -EINVAL;
-		goto err_task_lock;
-	}
-
 	if (oom_adjust != task->signal->oom_adj) {
 		if (oom_adjust == OOM_DISABLE)
 			atomic_inc(&task->mm->oom_disable_count);
@@ -1085,11 +1086,10 @@ static ssize_t oom_adjust_write(struct f
 	else
 		task->signal->oom_score_adj = (oom_adjust * OOM_SCORE_ADJ_MAX) /
 								-OOM_DISABLE;
-err_task_lock:
-	task_unlock(task);
 err_sighand:
 	unlock_task_sighand(task, &flags);
-err_task_struct:
+err_task_lock:
+	task_unlock(task);
 	put_task_struct(task);
 out:
 	return err < 0 ? err : count;
@@ -1152,21 +1152,24 @@ static ssize_t oom_score_adj_write(struc
 		err = -ESRCH;
 		goto out;
 	}
+
+	task_lock(task);
+	if (!task->mm) {
+		err = -EINVAL;
+		goto err_task_lock;
+	}
+
 	if (!lock_task_sighand(task, &flags)) {
 		err = -ESRCH;
-		goto err_task_struct;
+		goto err_task_lock;
 	}
+
 	if (oom_score_adj < task->signal->oom_score_adj &&
 			!capable(CAP_SYS_RESOURCE)) {
 		err = -EACCES;
 		goto err_sighand;
 	}
 
-	task_lock(task);
-	if (!task->mm) {
-		err = -EINVAL;
-		goto err_task_lock;
-	}
 	if (oom_score_adj != task->signal->oom_score_adj) {
 		if (oom_score_adj == OOM_SCORE_ADJ_MIN)
 			atomic_inc(&task->mm->oom_disable_count);
@@ -1183,11 +1186,10 @@ static ssize_t oom_score_adj_write(struc
 	else
 		task->signal->oom_adj = (oom_score_adj * OOM_ADJUST_MAX) /
 							OOM_SCORE_ADJ_MAX;
-err_task_lock:
-	task_unlock(task);
 err_sighand:
 	unlock_task_sighand(task, &flags);
-err_task_struct:
+err_task_lock:
+	task_unlock(task);
 	put_task_struct(task);
 out:
 	return err < 0 ? err : count;
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
jbd-remove-dependency-on-__gfp_nofail.patch

