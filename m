From: akpm@linux-foundation.org
Subject: + oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch added to -mm tree
Date: Tue, 24 Aug 2010 15:50:32 -0700
Message-ID: <201008242250.o7OMoWn6019467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756283Ab0HXWvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 18:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, yinghan@google.com


The patch titled
     oom: rewrite error handling for oom_adj and oom_score_adj tunables
has been added to the -mm tree.  Its filename is
     oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch

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
Subject: oom: rewrite error handling for oom_adj and oom_score_adj tunables
From: David Rientjes <rientjes@google.com>

It's better to use proper error handling in oom_adjust_write() and
oom_score_adj_write() instead of duplicating the locking order on various
exit paths.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   83 +++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 35 deletions(-)

diff -puN fs/proc/base.c~oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables fs/proc/base.c
--- a/fs/proc/base.c~oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables
+++ a/fs/proc/base.c
@@ -1025,36 +1025,39 @@ static ssize_t oom_adjust_write(struct f
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
-		return -EFAULT;
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
 
 	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
 	if (err)
-		return -EINVAL;
+		goto out;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
-	     oom_adjust != OOM_DISABLE)
-		return -EINVAL;
+	     oom_adjust != OOM_DISABLE) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	task = get_proc_task(file->f_path.dentry->d_inode);
-	if (!task)
-		return -ESRCH;
+	if (!task) {
+		err = -ESRCH;
+		goto out;
+	}
 	if (!lock_task_sighand(task, &flags)) {
-		put_task_struct(task);
-		return -ESRCH;
+		err = -ESRCH;
+		goto err_task_struct;
 	}
 
 	if (oom_adjust < task->signal->oom_adj && !capable(CAP_SYS_RESOURCE)) {
-		unlock_task_sighand(task, &flags);
-		put_task_struct(task);
-		return -EACCES;
+		err = -EACCES;
+		goto err_sighand;
 	}
 
 	task_lock(task);
 	if (!task->mm) {
-		task_unlock(task);
-		unlock_task_sighand(task, &flags);
-		put_task_struct(task);
-		return -EINVAL;
+		err = -EINVAL;
+		goto err_task_lock;
 	}
 
 	if (oom_adjust != task->signal->oom_adj) {
@@ -1082,11 +1085,14 @@ static ssize_t oom_adjust_write(struct f
 	else
 		task->signal->oom_score_adj = (oom_adjust * OOM_SCORE_ADJ_MAX) /
 								-OOM_DISABLE;
+err_task_lock:
 	task_unlock(task);
+err_sighand:
 	unlock_task_sighand(task, &flags);
+err_task_struct:
 	put_task_struct(task);
-
-	return count;
+out:
+	return err < 0 ? err : count;
 }
 
 static const struct file_operations proc_oom_adjust_operations = {
@@ -1127,36 +1133,39 @@ static ssize_t oom_score_adj_write(struc
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
-	if (copy_from_user(buffer, buf, count))
-		return -EFAULT;
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
 
 	err = strict_strtol(strstrip(buffer), 0, &oom_score_adj);
 	if (err)
-		return -EINVAL;
+		goto out;
 	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
-			oom_score_adj > OOM_SCORE_ADJ_MAX)
-		return -EINVAL;
+			oom_score_adj > OOM_SCORE_ADJ_MAX) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	task = get_proc_task(file->f_path.dentry->d_inode);
-	if (!task)
-		return -ESRCH;
+	if (!task) {
+		err = -ESRCH;
+		goto out;
+	}
 	if (!lock_task_sighand(task, &flags)) {
-		put_task_struct(task);
-		return -ESRCH;
+		err = -ESRCH;
+		goto err_task_struct;
 	}
 	if (oom_score_adj < task->signal->oom_score_adj &&
 			!capable(CAP_SYS_RESOURCE)) {
-		unlock_task_sighand(task, &flags);
-		put_task_struct(task);
-		return -EACCES;
+		err = -EACCES;
+		goto err_sighand;
 	}
 
 	task_lock(task);
 	if (!task->mm) {
-		task_unlock(task);
-		unlock_task_sighand(task, &flags);
-		put_task_struct(task);
-		return -EINVAL;
+		err = -EINVAL;
+		goto err_task_lock;
 	}
 	if (oom_score_adj != task->signal->oom_score_adj) {
 		if (oom_score_adj == OOM_SCORE_ADJ_MIN)
@@ -1174,10 +1183,14 @@ static ssize_t oom_score_adj_write(struc
 	else
 		task->signal->oom_adj = (oom_score_adj * OOM_ADJUST_MAX) /
 							OOM_SCORE_ADJ_MAX;
+err_task_lock:
 	task_unlock(task);
+err_sighand:
 	unlock_task_sighand(task, &flags);
+err_task_struct:
 	put_task_struct(task);
-	return count;
+out:
+	return err < 0 ? err : count;
 }
 
 static const struct file_operations proc_oom_score_adj_operations = {
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

