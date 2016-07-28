From: akpm@linux-foundation.org
Subject: [patch 003/101] proc, oom_adj: extract oom_score_adj setting into a helper
Date: Thu, 28 Jul 2016 15:44:40 -0700
Message-ID: <579a8ad8.UnURLHgyN4E/V2MF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcG1Wom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:44:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: proc, oom_adj: extract oom_score_adj setting into a helper

Currently we have two proc interfaces to set oom_score_adj.  The legacy
/proc/<pid>/oom_adj and /proc/<pid>/oom_score_adj which both have their
specific handlers.  Big part of the logic is duplicated so extract the
common code into __set_oom_adj helper.  Legacy knob still expects some
details slightly different so make sure those are handled same way - e.g. 
the legacy mode ignores oom_score_adj_min and it warns about the usage.

This patch shouldn't introduce any functional changes.

Link: http://lkml.kernel.org/r/1466426628-15074-4-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   94 +++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 51 deletions(-)

diff -puN fs/proc/base.c~proc-oom_adj-extract-oom_score_adj-setting-into-a-helper fs/proc/base.c
--- a/fs/proc/base.c~proc-oom_adj-extract-oom_score_adj-setting-into-a-helper
+++ a/fs/proc/base.c
@@ -1037,7 +1037,47 @@ static ssize_t oom_adj_read(struct file
 	return simple_read_from_buffer(buf, count, ppos, buffer, len);
 }
 
-static DEFINE_MUTEX(oom_adj_mutex);
+static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
+{
+	static DEFINE_MUTEX(oom_adj_mutex);
+	struct task_struct *task;
+	int err = 0;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	mutex_lock(&oom_adj_mutex);
+	if (legacy) {
+		if (oom_adj < task->signal->oom_score_adj &&
+				!capable(CAP_SYS_RESOURCE)) {
+			err = -EACCES;
+			goto err_unlock;
+		}
+		/*
+		 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
+		 * /proc/pid/oom_score_adj instead.
+		 */
+		pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
+			  current->comm, task_pid_nr(current), task_pid_nr(task),
+			  task_pid_nr(task));
+	} else {
+		if ((short)oom_adj < task->signal->oom_score_adj_min &&
+				!capable(CAP_SYS_RESOURCE)) {
+			err = -EACCES;
+			goto err_unlock;
+		}
+	}
+
+	task->signal->oom_score_adj = oom_adj;
+	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
+		task->signal->oom_score_adj_min = (short)oom_adj;
+	trace_oom_score_adj_update(task);
+err_unlock:
+	mutex_unlock(&oom_adj_mutex);
+	put_task_struct(task);
+	return err;
+}
 
 /*
  * /proc/pid/oom_adj exists solely for backwards compatibility with previous
@@ -1052,7 +1092,6 @@ static DEFINE_MUTEX(oom_adj_mutex);
 static ssize_t oom_adj_write(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
 	int oom_adj;
 	int err;
@@ -1074,12 +1113,6 @@ static ssize_t oom_adj_write(struct file
 		goto out;
 	}
 
-	task = get_proc_task(file_inode(file));
-	if (!task) {
-		err = -ESRCH;
-		goto out;
-	}
-
 	/*
 	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
 	 * value is always attainable.
@@ -1089,26 +1122,7 @@ static ssize_t oom_adj_write(struct file
 	else
 		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
 
-	mutex_lock(&oom_adj_mutex);
-	if (oom_adj < task->signal->oom_score_adj &&
-	    !capable(CAP_SYS_RESOURCE)) {
-		err = -EACCES;
-		goto err_unlock;
-	}
-
-	/*
-	 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
-	 * /proc/pid/oom_score_adj instead.
-	 */
-	pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
-		  current->comm, task_pid_nr(current), task_pid_nr(task),
-		  task_pid_nr(task));
-
-	task->signal->oom_score_adj = oom_adj;
-	trace_oom_score_adj_update(task);
-err_unlock:
-	mutex_unlock(&oom_adj_mutex);
-	put_task_struct(task);
+	err = __set_oom_adj(file, oom_adj, true);
 out:
 	return err < 0 ? err : count;
 }
@@ -1138,7 +1152,6 @@ static ssize_t oom_score_adj_read(struct
 static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 					size_t count, loff_t *ppos)
 {
-	struct task_struct *task;
 	char buffer[PROC_NUMBUF];
 	int oom_score_adj;
 	int err;
@@ -1160,28 +1173,7 @@ static ssize_t oom_score_adj_write(struc
 		goto out;
 	}
 
-	task = get_proc_task(file_inode(file));
-	if (!task) {
-		err = -ESRCH;
-		goto out;
-	}
-
-	mutex_lock(&oom_adj_mutex);
-	if ((short)oom_score_adj < task->signal->oom_score_adj_min &&
-			!capable(CAP_SYS_RESOURCE)) {
-		err = -EACCES;
-		goto err_unlock;
-	}
-
-	task->signal->oom_score_adj = (short)oom_score_adj;
-	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
-		task->signal->oom_score_adj_min = (short)oom_score_adj;
-
-	trace_oom_score_adj_update(task);
