From: akpm@linux-foundation.org
Subject: [merged] proc-oom-drop-bogus-sighand-lock.patch removed from -mm
 tree
Date: Fri, 29 Jul 2016 11:53:40 -0700
Message-ID: <579ba634.1+INSSbp9O26QbSY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcG2Sxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc, oom: drop bogus sighand lock
has been removed from the -mm tree.  Its filename was
     proc-oom-drop-bogus-sighand-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: proc, oom: drop bogus sighand lock

Oleg has pointed out that can simplify both oom_adj_{read,write} and
oom_score_adj_{read,write} even further and drop the sighand lock.  The
main purpose of the lock was to protect p->signal from going away but this
will not happen since ea6d290ca34c ("signals: make task_struct->signal
immutable/refcountable").

The other role of the lock was to synchronize different writers,
especially those with CAP_SYS_RESOURCE.  Introduce a mutex for this
purpose.  Later patches will need this lock anyway.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/1466426628-15074-3-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   51 +++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff -puN fs/proc/base.c~proc-oom-drop-bogus-sighand-lock fs/proc/base.c
--- a/fs/proc/base.c~proc-oom-drop-bogus-sighand-lock
+++ a/fs/proc/base.c
@@ -1024,23 +1024,21 @@ static ssize_t oom_adj_read(struct file
 	char buffer[PROC_NUMBUF];
 	int oom_adj = OOM_ADJUST_MIN;
 	size_t len;
-	unsigned long flags;
 
 	if (!task)
 		return -ESRCH;
-	if (lock_task_sighand(task, &flags)) {
-		if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
-			oom_adj = OOM_ADJUST_MAX;
-		else
-			oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
-				  OOM_SCORE_ADJ_MAX;
-		unlock_task_sighand(task, &flags);
-	}
+	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
+		oom_adj = OOM_ADJUST_MAX;
+	else
+		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
+			  OOM_SCORE_ADJ_MAX;
 	put_task_struct(task);
 	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
 	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
+static DEFINE_MUTEX(oom_adj_mutex);
+
 /*
  * /proc/pid/oom_adj exists solely for backwards compatibility with previous
  * kernels.  The effective policy is defined by oom_score_adj, which has a
@@ -1057,7 +1055,6 @@ static ssize_t oom_adj_write(struct file
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
 	int oom_adj;
-	unsigned long flags;
 	int err;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -1083,11 +1080,6 @@ static ssize_t oom_adj_write(struct file
 		goto out;
 	}
 
-	if (!lock_task_sighand(task, &flags)) {
-		err = -ESRCH;
-		goto err_put_task;
-	}
-
 	/*
 	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
 	 * value is always attainable.
@@ -1097,10 +1089,11 @@ static ssize_t oom_adj_write(struct file
 	else
 		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
 
+	mutex_lock(&oom_adj_mutex);
 	if (oom_adj < task->signal->oom_score_adj &&
 	    !capable(CAP_SYS_RESOURCE)) {
 		err = -EACCES;
-		goto err_sighand;
+		goto err_unlock;
 	}
 
 	/*
@@ -1113,9 +1106,8 @@ static ssize_t oom_adj_write(struct file
 
 	task->signal->oom_score_adj = oom_adj;
 	trace_oom_score_adj_update(task);
-err_sighand:
-	unlock_task_sighand(task, &flags);
-err_put_task:
+err_unlock:
+	mutex_unlock(&oom_adj_mutex);
 	put_task_struct(task);
 out:
 	return err < 0 ? err : count;
@@ -1133,15 +1125,11 @@ static ssize_t oom_score_adj_read(struct
 	struct task_struct *task = get_proc_task(file_inode(file));
 	char buffer[PROC_NUMBUF];
 	short oom_score_adj = OOM_SCORE_ADJ_MIN;
-	unsigned long flags;
 	size_t len;
 
 	if (!task)
 		return -ESRCH;
-	if (lock_task_sighand(task, &flags)) {
-		oom_score_adj = task->signal->oom_score_adj;
-		unlock_task_sighand(task, &flags);
-	}
+	oom_score_adj = task->signal->oom_score_adj;
 	put_task_struct(task);
 	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
 	return simple_read_from_buffer(buf, count, ppos, buffer, len);
@@ -1152,7 +1140,6 @@ static ssize_t oom_score_adj_write(struc
 {
 	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
-	unsigned long flags;
 	int oom_score_adj;
 	int err;
 
@@ -1179,25 +1166,21 @@ static ssize_t oom_score_adj_write(struc
 		goto out;
 	}
 
-	if (!lock_task_sighand(task, &flags)) {
-		err = -ESRCH;
-		goto err_put_task;
-	}
-
+	mutex_lock(&oom_adj_mutex);
 	if ((short)oom_score_adj < task->signal->oom_score_adj_min &&
 			!capable(CAP_SYS_RESOURCE)) {
 		err = -EACCES;
-		goto err_sighand;
+		goto err_unlock;
 	}
 
 	task->signal->oom_score_adj = (short)oom_score_adj;
 	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
 		task->signal->oom_score_adj_min = (short)oom_score_adj;
+
 	trace_oom_score_adj_update(task);
 
-err_sighand:
-	unlock_task_sighand(task, &flags);
-err_put_task:
+err_unlock:
+	mutex_unlock(&oom_adj_mutex);
 	put_task_struct(task);
 out:
 	return err < 0 ? err : count;
_

Patches currently in -mm which might be from mhocko@suse.com are


